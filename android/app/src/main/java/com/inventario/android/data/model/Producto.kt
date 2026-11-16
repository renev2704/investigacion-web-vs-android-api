package com.inventario.android.data.model

data class Producto(
    val productoId: Int = 0,
    val codigo: String,
    val nombre: String,
    val descripcion: String? = null,
    val categoriaId: Int,
    val precioUnitario: Double,
    val stock: Int,
    val stockMinimo: Int,
    val activo: Boolean = true
)