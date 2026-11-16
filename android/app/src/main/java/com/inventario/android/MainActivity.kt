package com.inventario.android

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.viewModels
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.List
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.inventario.android.ui.theme.InventarioAndroidTheme
import com.inventario.android.viewmodel.ProductoViewModel
import androidx.compose.foundation.background
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.material3.HorizontalDivider // Si usas Material 3 nueva, o Divider en versiones viejas

class MainActivity : ComponentActivity() {
    private val viewModel: ProductoViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            InventarioAndroidTheme {
                MainScreen(viewModel)
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MainScreen(viewModel: ProductoViewModel) {
    var selectedTab by remember { mutableIntStateOf(0) }

    Scaffold(
        topBar = { TopAppBar(title = { Text("Inventario Android") }) },
        bottomBar = {
            NavigationBar {
                NavigationBarItem(
                    selected = selectedTab == 0,
                    onClick = { selectedTab = 0 },
                    icon = { Icon(Icons.Default.List, contentDescription = "Lista") },
                    label = { Text("Productos") }
                )
                NavigationBarItem(
                    selected = selectedTab == 1,
                    onClick = { selectedTab = 1 },
                    icon = { Icon(Icons.Default.Add, contentDescription = "Agregar") },
                    label = { Text("Agregar") }
                )
                NavigationBarItem(
                    selected = selectedTab == 2,
                    onClick = { selectedTab = 2 },
                    icon = { Icon(Icons.Default.PlayArrow, contentDescription = "Experimento") },
                    label = { Text("Experimento") }
                )
            }
        }
    ) { padding ->
        Box(modifier = Modifier.padding(padding)) {
            when (selectedTab) {
                0 -> PantallaLista(viewModel)
                1 -> PantallaAgregar(viewModel)
                2 -> PantallaExperimento(viewModel)
            }
        }
    }
}

// --- PANTALLA 1: LISTA DE PRODUCTOS ---
@Composable
fun PantallaLista(viewModel: ProductoViewModel) {
    val productos by viewModel.productos.collectAsStateWithLifecycle()
    val cargando by viewModel.cargando.collectAsStateWithLifecycle()
    val error by viewModel.error.collectAsStateWithLifecycle()

    LaunchedEffect(Unit) { viewModel.cargarProductos() }

    if (cargando) {
        Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
            CircularProgressIndicator()
        }
    } else if (error != null) {
        Text(text = "❌ $error", color = MaterialTheme.colorScheme.error, modifier = Modifier.padding(16.dp))
    } else {
        LazyColumn(modifier = Modifier.padding(16.dp)) {
            item { Text("Total: ${productos.size} productos", style = MaterialTheme.typography.titleMedium) }
            items(productos) { producto ->
                Card(modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp)) {
                    Column(modifier = Modifier.padding(12.dp)) {
                        Text(producto.nombre, style = MaterialTheme.typography.titleMedium)
                        Text("Código: ${producto.codigo} | Stock: ${producto.stock}")
                    }
                }
            }
        }
    }
}

// --- PANTALLA 2: AGREGAR (Placeholder por ahora) ---
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PantallaAgregar(viewModel: ProductoViewModel) {
    var codigo by remember { mutableStateOf("") }
    var nombre by remember { mutableStateOf("") }
    var precio by remember { mutableStateOf("") }
    var stock by remember { mutableStateOf("") }
    var stockMinimo by remember { mutableStateOf("") } // <-- NUEVA VARIABLE
    var mensaje by remember { mutableStateOf("") }

    Column(modifier = Modifier.padding(16.dp).fillMaxSize()) {
        Text("➕ Agregar Producto", style = MaterialTheme.typography.headlineSmall)
        Spacer(modifier = Modifier.height(16.dp))

        OutlinedTextField(value = codigo, onValueChange = { codigo = it }, label = { Text("Código (Ej: AND-001)") }, modifier = Modifier.fillMaxWidth())
        Spacer(modifier = Modifier.height(8.dp))

        OutlinedTextField(value = nombre, onValueChange = { nombre = it }, label = { Text("Nombre") }, modifier = Modifier.fillMaxWidth())
        Spacer(modifier = Modifier.height(8.dp))

        OutlinedTextField(value = precio, onValueChange = { precio = it }, label = { Text("Precio") }, modifier = Modifier.fillMaxWidth())
        Spacer(modifier = Modifier.height(8.dp))

        OutlinedTextField(value = stock, onValueChange = { stock = it }, label = { Text("Stock Inicial") }, modifier = Modifier.fillMaxWidth())
        Spacer(modifier = Modifier.height(8.dp))

        // NUEVO CAMPO VISUAL
        OutlinedTextField(value = stockMinimo, onValueChange = { stockMinimo = it }, label = { Text("Stock Mínimo") }, modifier = Modifier.fillMaxWidth())
        Spacer(modifier = Modifier.height(16.dp))

        Button(
            onClick = {
                // Pasamos el nuevo parámetro
                viewModel.agregarProducto(
                    codigo = codigo,
                    nombre = nombre,
                    precio = precio.toDoubleOrNull() ?: 0.0,
                    stock = stock.toIntOrNull() ?: 0,
                    stockMinimo = stockMinimo.toIntOrNull() ?: 0, // <-- SE LO PASAMOS
                    onResult = { resultado -> mensaje = resultado }
                )
            },
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("Guardar Producto")
        }

        if (mensaje.isNotEmpty()) {
            Spacer(modifier = Modifier.height(16.dp))
            Text(mensaje, color = MaterialTheme.colorScheme.primary)
        }
    }
}


// --- PANTALLA 3: EXPERIMENTO ---
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PantallaExperimento(viewModel: ProductoViewModel) {
    val estado by viewModel.estadoExperimento.collectAsStateWithLifecycle()
    val resultados by viewModel.resultadosExperimento.collectAsStateWithLifecycle()
    val volumen by viewModel.volumenSeleccionado.collectAsStateWithLifecycle()
    val operacion by viewModel.operacionSeleccionada.collectAsStateWithLifecycle()

    Column(modifier = Modifier.padding(16.dp).fillMaxSize()) {
        Text("🧪 Panel de Experimentos", style = MaterialTheme.typography.headlineSmall)
        Spacer(modifier = Modifier.height(16.dp))

        // SELECTOR DE OPERACIÓN
        Text("Operación:", fontWeight = FontWeight.Bold)
        Row(
            modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            listOf("READ", "CREATE", "UPDATE", "DELETE").forEach { op ->
                FilterChip(
                    selected = operacion == op,
                    onClick = { viewModel.setOperacion(op) },
                    label = { Text(op) }
                )
            }
        }

        Spacer(modifier = Modifier.height(8.dp))

        // SELECTOR DE VOLUMEN
        Text("Volumen de datos:", fontWeight = FontWeight.Bold)
        Row(
            modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            listOf(1000, 10000, 100000).forEach { vol ->
                FilterChip(
                    selected = volumen == vol,
                    onClick = { viewModel.setVolumen(vol) },
                    label = { Text("${vol / 1000}k") }
                )
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // BOTÓN DE INICIO
        Button(
            onClick = { viewModel.iniciarExperimento() },
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("Iniciar Experimento ($operacion - $volumen)")
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Estado actual
        Card(modifier = Modifier.fillMaxWidth()) {
            Text(
                text = estado,
                modifier = Modifier.padding(12.dp),
                style = MaterialTheme.typography.bodyLarge
            )
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Tabla de resultados
        if (resultados.isNotEmpty()) {
            Text("Resultados en vivo:", style = MaterialTheme.typography.titleMedium)
            Spacer(modifier = Modifier.height(8.dp))

            // Encabezados
            Row(modifier = Modifier.fillMaxWidth().padding(horizontal = 8.dp, vertical = 4.dp)) {
                Text("Rep", modifier = Modifier.weight(1f), fontWeight = FontWeight.Bold)
                Text("Tiempo (ms)", modifier = Modifier.weight(2f), fontWeight = FontWeight.Bold)
                Text("Memoria (MB)", modifier = Modifier.weight(2f), fontWeight = FontWeight.Bold)
                Text("HTTP", modifier = Modifier.weight(1f), fontWeight = FontWeight.Bold)
            }
            HorizontalDivider()

            // Lista de resultados (Ajustada para mostrar Memoria)
            LazyColumn(modifier = Modifier.weight(1f)) {
                items(resultados) { med ->
                    Row(
                        modifier = Modifier.fillMaxWidth().padding(horizontal = 8.dp, vertical = 8.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            text = "${med.repeticion} ${if (med.esCalentamiento) "(C)" else ""}",
                            modifier = Modifier.weight(1f),
                            color = if (med.esCalentamiento) Color.Gray else Color.Unspecified
                        )
                        Text(
                            text = String.format("%.2f", med.tiempoRespuestaMs),
                            modifier = Modifier.weight(2f),
                            fontWeight = if (med.esCalentamiento) FontWeight.Normal else FontWeight.Bold,
                            color = if (med.esCalentamiento) Color.Gray else MaterialTheme.colorScheme.primary
                        )
                        Text(
                            text = med.memoriaMB?.let { String.format("%.2f", it) } ?: "0.00",
                            modifier = Modifier.weight(2f),
                            color = if (med.esCalentamiento) Color.Gray else Color.Unspecified
                        )
                        Text(
                            text = med.codigoHttp.toString(),
                            modifier = Modifier.weight(1f)
                        )
                    }
                    HorizontalDivider()
                }
            }

            // Resumen final
            val validas = resultados.filter { !it.esCalentamiento }
            if (validas.isNotEmpty()) {
                val promedio = validas.map { it.tiempoRespuestaMs }.average()
                val minimo = validas.minOf { it.tiempoRespuestaMs }
                val maximo = validas.maxOf { it.tiempoRespuestaMs }
                val memoriaPromedio = validas.mapNotNull { it.memoriaMB }.average()

                Card(
                    modifier = Modifier.fillMaxWidth().padding(top = 8.dp),
                    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)
                ) {
                    Column(modifier = Modifier.padding(12.dp)) {
                        Text("Resumen (Promedios válidos):", fontWeight = FontWeight.Bold)
                        Text("Tiempo prom: ${String.format("%.2f", promedio)} ms")
                        Text("Tiempo mín: ${String.format("%.2f", minimo)} ms")
                        Text("Tiempo máx: ${String.format("%.2f", maximo)} ms")
                        Text("Memoria prom: ${String.format("%.2f", memoriaPromedio)} MB")
                    }
                }
            }
        }
    }
}