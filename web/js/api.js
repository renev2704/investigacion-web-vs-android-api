// Configuración de la API
const API_BASE_URL = 'http://localhost:8080/api';

// ==========================================
// FUNCIONES PARA PRODUCTOS
// ==========================================

async function obtenerProductos() {
    const response = await fetch(`${API_BASE_URL}/productos`);
    if (!response.ok) throw new Error('Error al obtener productos');
    return await response.json();
}

async function obtenerProductoPorId(id) {
    const response = await fetch(`${API_BASE_URL}/productos/${id}`);
    if (!response.ok) throw new Error('Producto no encontrado');
    return await response.json();
}

async function crearProducto(producto) {
    const response = await fetch(`${API_BASE_URL}/productos`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(producto)
    });
    if (!response.ok) {
        const errorText = await response.text();
        throw new Error(errorText || 'Error al crear producto');
    }
    return await response.json();
}

async function actualizarProducto(id, producto) {
    const response = await fetch(`${API_BASE_URL}/productos/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(producto)
    });
    if (!response.ok) throw new Error('Error al actualizar producto');
    return await response.json();
}

async function eliminarProducto(id) {
    const response = await fetch(`${API_BASE_URL}/productos/${id}`, {
        method: 'DELETE'
    });
    if (!response.ok) throw new Error('Error al eliminar producto');
    return true;
}

// ==========================================
// FUNCIONES PARA CATEGORÍAS
// ==========================================

async function obtenerCategorias() {
    const response = await fetch(`${API_BASE_URL}/categorias`);
    if (!response.ok) throw new Error('Error al obtener categorías');
    return await response.json();
}

// ==========================================
// FUNCIONES PARA MOVIMIENTOS
// ==========================================

async function registrarMovimiento(movimiento) {
    const response = await fetch(`${API_BASE_URL}/movimientos`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(movimiento)
    });
    if (!response.ok) {
        const errorText = await response.text();
        throw new Error(errorText || 'Error al registrar movimiento');
    }
    return true;
}

// ==========================================
// FUNCIONES PARA MEDICIONES (EXPERIMENTO)
// ==========================================

async function enviarMediciones(mediciones) {
    // El endpoint acepta un array
    const response = await fetch(`${API_BASE_URL}/mediciones`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(mediciones)
    });
    if (!response.ok) throw new Error('Error al enviar mediciones');
    return true;
}