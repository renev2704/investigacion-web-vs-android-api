let chartInstance = null;
let experimentoActivo = false;
let medicionesRecolectadas = [];

document.addEventListener('DOMContentLoaded', () => {
    inicializarGrafico();
    document.getElementById('btn-iniciar-experimento').addEventListener('click', iniciarExperimento);
});

// ==========================================
// CONFIGURACIÓN DEL GRÁFICO
// ==========================================
function inicializarGrafico() {
    const ctx = document.getElementById('grafico-tiempos').getContext('2d');
    chartInstance = new Chart(ctx, {
        type: 'line',
        data: {
            labels: [],
            datasets: [{
                label: 'Tiempo de respuesta (ms)',
                data: [],
                borderColor: '#3b82f6',
                backgroundColor: 'rgba(59, 130, 246, 0.1)',
                tension: 0.3,
                fill: true,
                pointRadius: 4,
                pointBackgroundColor: '#3b82f6'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: true, position: 'top' }
            },
            scales: {
                y: { beginAtZero: true, title: { display: true, text: 'Milisegundos (ms)' } },
                x: { title: { display: true, text: 'Repetición' } }
            }
        }
    });
}

// ==========================================
// LÓGICA DEL EXPERIMENTO
// ==========================================
async function iniciarExperimento() {
    if (experimentoActivo) return;
    experimentoActivo = true;
    medicionesRecolectadas = [];

    const btnIniciar = document.getElementById('btn-iniciar-experimento');
    const btnDetener = document.getElementById('btn-detener-experimento');
    const estado = document.getElementById('estado-experimento');
    const barra = document.getElementById('barra-progreso');
    const cuerpoResultados = document.getElementById('cuerpo-resultados');

    btnIniciar.disabled = true;
    btnDetener.disabled = false;
    cuerpoResultados.innerHTML = '';

    // Resetear gráfico
    chartInstance.data.labels = [];
    chartInstance.data.datasets[0].data = [];
    chartInstance.update();

    const volumen = parseInt(document.getElementById('select-volumen').value);
    const operacion = document.getElementById('select-operacion').value;

    const totalRepeticiones = 15; // 5 calentamientos + 10 válidas
    let repeticionActual = 0;

    estado.innerHTML = `<i class="fa-solid fa-spinner fa-spin"></i> Ejecutando experimento para ${volumen} registros...`;

    try {
        // 5 Calentamientos
        for (let i = 1; i <= 5; i++) {
            repeticionActual++;
            await ejecutarOperacion(operacion, i, true, volumen, repeticionActual, totalRepeticiones, barra, cuerpoResultados);
        }

        // 10 Válidas
        for (let i = 1; i <= 10; i++) {
            repeticionActual++;
            await ejecutarOperacion(operacion, i, false, volumen, repeticionActual, totalRepeticiones, barra, cuerpoResultados);
        }

        // Enviar todas las mediciones a la API
        await enviarMediciones(medicionesRecolectadas);

        estado.innerHTML = `<i class="fa-solid fa-check-circle" style="color: var(--success);"></i> Experimento completado. ${medicionesRecolectadas.length} mediciones guardadas.`;

    } catch (error) {
        console.error(error);
        estado.innerHTML = `<i class="fa-solid fa-exclamation-circle" style="color: var(--danger);"></i> Error: ${error.message}`;
    } finally {
        experimentoActivo = false;
        btnIniciar.disabled = false;
        btnDetener.disabled = true;
        barra.style.width = '100%';
    }
}

async function ejecutarOperacion(operacion, repeticion, esCalentamiento, volumen, repeticionActual, totalRepeticiones, barra, cuerpoResultados) {
    let tiempoMs = 0;
    let codigoHttp = 0;
    let exitoso = false;
    let memoriaMB = 0;

    // 1. Medir memoria ANTES de la petición (si el navegador lo soporta)
    const memoriaAntes = performance.memory ? performance.memory.usedJSHeapSize : 0;

    try {
        const inicio = performance.now();

        switch (operacion) {
            case 'READ':
                const res = await fetch('http://localhost:8080/api/productos');
                codigoHttp = res.status;
                await res.json();
                exitoso = res.ok;
                break;
            case 'CREATE':
                const codigoUnico = `WEB-C-${volumen}-${repeticion}-${Date.now()}`;
                const nuevo = {
                    codigo: codigoUnico, nombre: `Test ${codigoUnico}`,
                    categoriaId: 1, precioUnitario: 10.0, stock: 1, stockMinimo: 1, activo: true
                };
                const resCreate = await fetch('http://localhost:8080/api/productos', {
                    method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify(nuevo)
                });
                codigoHttp = resCreate.status;
                exitoso = resCreate.ok;
                break;
            case 'UPDATE':
                const idUpdate = Math.floor(volumen / 2);
                const resUpdate = await fetch(`http://localhost:8080/api/productos/${idUpdate}`, {
                    method: 'PUT', headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({codigo: `UPD-${idUpdate}`, nombre: `Actualizado ${Date.now()}`, categoriaId: 1, precioUnitario: 15.0, stockMinimo: 2, activo: true})
                });
                codigoHttp = resUpdate.status;
                exitoso = resUpdate.ok;
                break;
            case 'DELETE':
                // Borrar un id distinto por repetición. Si intenta borrar uno que no existe (404), lo tomamos como válido para no romper la prueba.
                const idDelete = repeticionActual;
                const resDelete = await fetch(`http://localhost:8080/api/productos/${idDelete}`, { method: 'DELETE' });
                codigoHttp = resDelete.status;
                exitoso = resDelete.ok || resDelete.status === 404;
                break;
        }

        const fin = performance.now();
        tiempoMs = fin - inicio;
    } catch (error) {
        console.error(`Error en ${operacion}:`, error);
        codigoHttp = 500;
        exitoso = false;
    }

    // 2. Medir memoria DESPUÉS y calcular la diferencia en MB
    if (performance.memory) {
        const memoriaDespues = performance.memory.usedJSHeapSize;
        const diferenciaBytes = memoriaDespues - memoriaAntes;
        memoriaMB = diferenciaBytes > 0 ? (diferenciaBytes / (1024 * 1024)) : 0; // Convertir a MB
    }

    // Guardar medición
    medicionesRecolectadas.push({
        plataforma: 'WEB', volumen: volumen, operacion: operacion,
        repeticion: repeticion, esCalentamiento: esCalentamiento,
        tiempoRespuestaMs: tiempoMs,
        memoriaMB: memoriaMB, // <-- AHORA SÍ SE GUARDA LA MEMORIA
        codigoHttp: codigoHttp, dispositivo: 'Chrome 128'
    });

    // Actualizar gráfico (solo las válidas)
    if (!esCalentamiento) {
        chartInstance.data.labels.push(`Rep ${repeticion}`);
        chartInstance.data.datasets[0].data.push(tiempoMs);
        chartInstance.update();
    }

    // Agregar fila a la tabla HTML (agregamos la columna de memoria)
    const fila = document.createElement('tr');
    fila.innerHTML = `
        <td>${repeticion} ${esCalentamiento ? '(Calent.)' : ''}</td>
        <td>${operacion}</td>
        <td><strong>${tiempoMs.toFixed(2)} ms</strong></td>
        <td>${memoriaMB > 0 ? memoriaMB.toFixed(2) + ' MB' : '0.00 MB'}</td>
        <td>${codigoHttp}</td>
        <td>${exitoso ? '✅' : '❌'}</td>
    `;
    cuerpoResultados.appendChild(fila);

    // Actualizar barra de progreso
    barra.style.width = `${(repeticionActual / totalRepeticiones) * 100}%`;
}