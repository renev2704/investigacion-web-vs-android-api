package com.inventario.android.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.inventario.android.data.model.Producto
import com.inventario.android.data.remote.RetrofitClient
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import com.inventario.android.data.model.Medicion

class ProductoViewModel : ViewModel() {
    private val _productos = MutableStateFlow<List<Producto>>(emptyList())
    val productos: StateFlow<List<Producto>> = _productos

    private val _cargando = MutableStateFlow(false)
    val cargando: StateFlow<Boolean> = _cargando

    private val _error = MutableStateFlow<String?>(null)
    val error: StateFlow<String?> = _error

    private val _estadoExperimento = MutableStateFlow("Listo para iniciar.")
    val estadoExperimento: StateFlow<String> = _estadoExperimento

    private val _resultadosExperimento = MutableStateFlow<List<Medicion>>(emptyList())
    val resultadosExperimento: StateFlow<List<Medicion>> = _resultadosExperimento

    private val _volumenSeleccionado = MutableStateFlow(1000)
    val volumenSeleccionado: StateFlow<Int> = _volumenSeleccionado

    private val _operacionSeleccionada = MutableStateFlow("READ")
    val operacionSeleccionada: StateFlow<String> = _operacionSeleccionada

    fun setVolumen(vol: Int) { _volumenSeleccionado.value = vol }
    fun setOperacion(op: String) { _operacionSeleccionada.value = op }

    fun cargarProductos() {
        viewModelScope.launch {
            _cargando.value = true
            _error.value = null
            try {
                val response = RetrofitClient.api.getProductos()
                if (response.isSuccessful) {
                    _productos.value = response.body() ?: emptyList()
                } else {
                    _error.value = "Error: ${response.code()}"
                }
            } catch (e: Exception) {
                _error.value = "Error de red: ${e.message}"
            } finally {
                _cargando.value = false
            }
        }
    }

    fun eliminarProducto(id: Int) {
        viewModelScope.launch {
            try {
                val response = RetrofitClient.api.eliminarProducto(id)
                if (response.isSuccessful) {
                    cargarProductos()
                } else {
                    _error.value = "Error al eliminar: ${response.code()}"
                }
            } catch (e: Exception) {
                _error.value = "Error: ${e.message}"
            }
        }
    }

    fun iniciarExperimento() {
        viewModelScope.launch {
            val volumen = _volumenSeleccionado.value
            val operacion = _operacionSeleccionada.value

            _estadoExperimento.value = "Ejecutando $operacion con volumen $volumen..."
            _resultadosExperimento.value = emptyList()
            val mediciones = mutableListOf<Medicion>()

            // 15 repeticiones (5 calentamiento + 10 válidas)
            for (i in 1..15) {
                val esCalentamiento = i <= 5

                // 1. Medir Memoria ANTES de la petición
                val runtime = Runtime.getRuntime()
                val memoriaAntes = runtime.totalMemory() - runtime.freeMemory()

                // 2. Medir Tiempo
                val inicio = System.nanoTime()
                var codigoHttp = 0
                var exitoso = false

                try {
                    when (operacion) {
                        "READ" -> {
                            val response = RetrofitClient.api.getProductos()
                            codigoHttp = response.code()
                            exitoso = response.isSuccessful
                        }
                        "CREATE" -> {
                            val codigoUnico = "AND-C-${volumen}-${i}-${System.currentTimeMillis()}"
                            val nuevo = Producto(codigo = codigoUnico, nombre = "Test $codigoUnico", categoriaId = 1, precioUnitario = 10.0, stock = 1, stockMinimo = 1)
                            val response = RetrofitClient.api.crearProducto(nuevo)
                            codigoHttp = response.code()
                            exitoso = response.isSuccessful
                        }
                        "UPDATE" -> {
                            val idUpdate = volumen / 2 // Actualizar el de la mitad
                            val prodUpdate = Producto(productoId = idUpdate, codigo = "UPD-$idUpdate", nombre = "Actualizado", categoriaId = 1, precioUnitario = 15.0, stock = 1, stockMinimo = 1)
                            val response = RetrofitClient.api.actualizarProducto(idUpdate, prodUpdate)
                            codigoHttp = response.code()
                            exitoso = response.isSuccessful
                        }
                        "DELETE" -> {
                            val idDelete = i // Borrar un ID distinto por repetición
                            val response = RetrofitClient.api.eliminarProducto(idDelete)
                            codigoHttp = response.code()
                            exitoso = response.isSuccessful || response.code() == 404
                        }
                    }
                } catch (e: Exception) {
                    codigoHttp = 500
                }

                val fin = System.nanoTime()
                val tiempoMs = (fin - inicio) / 1_000_000.0

                // 3. Medir Memoria DESPUÉS
                val memoriaDespues = runtime.totalMemory() - runtime.freeMemory()
                val memoriaMB = (memoriaDespues - memoriaAntes) / (1024.0 * 1024.0) // Convertir a MB

                val nuevaMedicion = Medicion(
                    volumen = volumen,
                    operacion = operacion,
                    repeticion = i,
                    esCalentamiento = esCalentamiento,
                    tiempoRespuestaMs = tiempoMs,
                    memoriaMB = if (memoriaMB > 0) memoriaMB else 0.0,
                    codigoHttp = codigoHttp,
                    dispositivo = "Emulador Android 14" // O el nombre de tu celular
                )

                mediciones.add(nuevaMedicion)
                _resultadosExperimento.value = mediciones.toList()
                _estadoExperimento.value = "Rep $i/15: ${String.format("%.2f", tiempoMs)} ms | ${String.format("%.2f", memoriaMB)} MB"
            }

            // Guardar en BD
            _estadoExperimento.value = "Guardando en base de datos..."
            var exitosas = 0
            for (med in mediciones) {
                try {
                    val response = RetrofitClient.api.enviarMedicionIndividual(med)
                    if (response.isSuccessful) exitosas++
                } catch (e: Exception) { }
            }
            _estadoExperimento.value = "✅ Listo. $exitosas de 15 guardadas."
        }
    }

    fun agregarProducto(
        codigo: String,
        nombre: String,
        precio: Double,
        stock: Int,
        stockMinimo: Int, // <-- NUEVO PARÁMETRO
        onResult: (String) -> Unit
    ) {
        viewModelScope.launch {
            try {
                val nuevoProducto = Producto(
                    codigo = codigo,
                    nombre = nombre,
                    categoriaId = 1, // Categoría por defecto
                    precioUnitario = precio,
                    stock = stock,
                    stockMinimo = stockMinimo, // <-- SE ASIGNA AQUÍ
                    activo = true
                )
                val response = RetrofitClient.api.crearProducto(nuevoProducto)
                if (response.isSuccessful) {
                    onResult("✅ Producto guardado con éxito")
                    cargarProductos()
                } else {
                    onResult("❌ Error: ${response.code()} - Código duplicado o inválido")
                }
            } catch (e: Exception) {
                onResult("❌ Error de red: ${e.message}")
            }
        }
    }
}

