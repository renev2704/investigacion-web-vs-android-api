package com.inventario.android.data.model

import com.google.gson.annotations.SerializedName

data class Medicion(
    @SerializedName("plataforma") val plataforma: String = "ANDROID",
    @SerializedName("volumen") val volumen: Int,
    @SerializedName("operacion") val operacion: String = "READ",
    @SerializedName("repeticion") val repeticion: Int,
    @SerializedName("esCalentamiento") val esCalentamiento: Boolean,
    @SerializedName("tiempoRespuestaMs") val tiempoRespuestaMs: Double,
    @SerializedName("memoriaMB") val memoriaMB: Double? = null,
    @SerializedName("codigoHttp") val codigoHttp: Int,
    @SerializedName("dispositivo") val dispositivo: String = "Emulador Android 14"
)