// Variables globales
let productosCache = [];

document.addEventListener('DOMContentLoaded', () => {
    inicializarNavegacion();
    cargarCategorias();
    cargarProductos();
    configurarFormulario();
    configurarBuscador();
});

// ==========================================
// NAVEGACIÓN ENTRE SECCIONES
// ==========================================
function inicializarNavegacion() {
    const botones = document.querySelectorAll('.menu-btn');
    const secciones = document.querySelectorAll('.seccion');
    const titulo = document.getElementById('titulo-seccion');

    botones.forEach(btn => {
        btn.addEventListener('click', () => {
            const targetId = btn.getAttribute('data-target');
            const seccion = document.getElementById(targetId);

            // Cambiar botón activo
            botones.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');

            // Cambiar sección visible
            secciones.forEach(s => s.classList.remove('active'));
            seccion.classList.add('active');

            // Cambiar título
            titulo.textContent = btn.textContent.trim();

            // Acciones específicas al cambiar de sección
            if (targetId === 'seccion-informes') {
                cargarEstadisticas();
            }
            if (targetId === 'seccion-listar') {
                cargarProductos();
            }
        });
    });
}

// ==========================================
// CARGA DE DATOS
// ==========================================
async function cargarCategorias() {
    try {
        const categorias = await obtenerCategorias();
        const select = document.getElementById('select-categoria');
        categorias.forEach(cat => {
            const option = document.createElement('option');
            option.value = cat.categoriaId;
            option.textContent = cat.nombre;
            select.appendChild(option);
        });
    } catch (error) {
        console.error('Error cargando categorías:', error);
    }
}

async function cargarProductos() {
    try {
        const inicio = performance.now();
        const productos = await obtenerProductos();
        const fin = performance.now();

        console.log(`[READ] Tiempo: ${(fin - inicio).toFixed(3)} ms`);

        productosCache = productos;
        renderizarTabla(productos);
    } catch (error) {
        console.error('Error cargando productos:', error);
    }
}

function renderizarTabla(productos) {
    const cuerpo = document.getElementById('cuerpo-tabla');
    const contador = document.getElementById('contador-productos');

    cuerpo.innerHTML = '';
    contador.textContent = `(${productos.length})`;

    productos.forEach(p => {
        const fila = document.createElement('tr');
        fila.innerHTML = `
            <td>${p.productoId}</td>
            <td>${p.codigo}</td>
            <td>${p.nombre}</td>
            <td>${p.categoriaId}</td>
            <td>$${p.precioUnitario ? p.precioUnitario.toFixed(2) : '0.00'}</td>
            <td>${p.stock}</td>
            <td>
                <button class="btn btn-danger" style="padding: 6px 10px;" onclick="borrarProducto(${p.productoId})">
                    <i class="fa-solid fa-trash"></i>
                </button>
            </td>
        `;
        cuerpo.appendChild(fila);
    });
}

// ==========================================
// FORMULARIO (CREATE)
// ==========================================
function configurarFormulario() {
    document.getElementById('form-producto').addEventListener('submit', async (e) => {
        e.preventDefault();

        const nuevoProducto = {
            codigo: document.getElementById('input-codigo').value,
            nombre: document.getElementById('input-nombre').value,
            descripcion: document.getElementById('input-descripcion').value,
            categoriaId: parseInt(document.getElementById('select-categoria').value),
            precioUnitario: parseFloat(document.getElementById('input-precio').value),
            stock: parseInt(document.getElementById('input-stock').value),
            stockMinimo: parseInt(document.getElementById('input-stock-minimo').value),
            activo: true
        };

        try {
            const inicio = performance.now();
            await crearProducto(nuevoProducto);
            const fin = performance.now();

            mostrarMensaje(`✅ Producto creado en ${(fin - inicio).toFixed(3)} ms`, 'exito');
            document.getElementById('form-producto').reset();
            cargarProductos();
        } catch (error) {
            mostrarMensaje('❌ Error: ' + error.message, 'error');
        }
    });

    document.getElementById('btn-recargar').addEventListener('click', cargarProductos);
}

// ==========================================
// ELIMINAR (DELETE)
// ==========================================
window.borrarProducto = async function(id) {
    if (!confirm(`¿Seguro que quieres eliminar el producto con ID ${id}?`)) return;

    try {
        const inicio = performance.now();
        await eliminarProducto(id);
        const fin = performance.now();

        console.log(`[DELETE] Tiempo: ${(fin - inicio).toFixed(3)} ms`);
        cargarProductos();
    } catch (error) {
        alert('Error al eliminar: ' + error.message);
    }
};

// ==========================================
// BUSCADOR
// ==========================================
function configurarBuscador() {
    document.getElementById('input-buscar').addEventListener('input', (e) => {
        const filtro = e.target.value.toLowerCase();
        const filtrados = productosCache.filter(p =>
            p.nombre.toLowerCase().includes(filtro) ||
            p.codigo.toLowerCase().includes(filtro)
        );
        renderizarTabla(filtrados);
    });
}

// ==========================================
// INFORMES / ESTADÍSTICAS
// ==========================================
async function cargarEstadisticas() {
    try {
        const productos = await obtenerProductos();

        const total = productos.length;
        const bajoStock = productos.filter(p => p.stock <= p.stockMinimo).length;
        const valorInventario = productos.reduce((acc, p) => acc + (p.precioUnitario * p.stock), 0);

        document.getElementById('stat-total-productos').textContent = total;
        document.getElementById('stat-bajo-stock').textContent = bajoStock;
        document.getElementById('stat-valor-inventario').textContent = `$${valorInventario.toLocaleString('en-US', {minimumFractionDigits: 2})}`;
        document.getElementById('stat-mediciones-total').textContent = '—'; // Pendiente
    } catch (error) {
        console.error('Error cargando estadísticas:', error);
    }
}

// ==========================================
// UTILIDADES
// ==========================================
function mostrarMensaje(texto, tipo) {
    const msg = document.getElementById('mensaje-formulario');
    msg.textContent = texto;
    msg.className = tipo === 'exito' ? 'mensaje-exito' : 'mensaje-error';
    setTimeout(() => { msg.textContent = ''; }, 5000);
}