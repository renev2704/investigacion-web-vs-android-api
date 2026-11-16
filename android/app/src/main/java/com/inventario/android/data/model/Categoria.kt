package com.inventario.android.data.model

data class Categoria(
    val categoriaId: Int,
    val nombre: String,
    val descripcion: String? = null,
    val activo: Boolean = true
)