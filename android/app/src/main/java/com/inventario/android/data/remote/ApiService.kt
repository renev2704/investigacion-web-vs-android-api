package com.inventario.android.data.remote

import com.inventario.android.data.model.Categoria
import com.inventario.android.data.model.Medicion
import com.inventario.android.data.model.Producto
import retrofit2.Response
import retrofit2.http.*

interface ApiService {
    @GET("api/productos")
    suspend fun getProductos(): Response<List<Producto>>

    @GET("api/categorias")
    suspend fun getCategorias(): Response<List<Categoria>>

    @POST("api/productos")
    suspend fun crearProducto(@Body producto: Producto): Response<Producto>

    @DELETE("api/productos/{id}")
    suspend fun eliminarProducto(@Path("id") id: Int): Response<Unit>

    @POST("api/mediciones")
    suspend fun enviarMediciones(@Body mediciones: List<Medicion>): Response<Unit>

    @POST("api/mediciones")
    suspend fun enviarMedicionIndividual(@Body medicion: Medicion): Response<Unit>

    @PUT("api/productos/{id}")
    suspend fun actualizarProducto(@Path("id") id: Int, @Body producto: Producto): Response<Producto>
}