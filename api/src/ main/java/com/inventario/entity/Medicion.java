package com.inventario.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "Mediciones")
public class Medicion {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long medicionId;
    private String plataforma;
    private Integer volumen;
    private String operacion;
    private Integer repeticion;
    private Boolean esCalentamiento;
    private BigDecimal tiempoRespuestaMs;
    private BigDecimal memoriaMB;
    private Integer codigoHttp;
    private String dispositivo;
    private String notas;

    @Column(insertable = false, updatable = false)
    private LocalDateTime fechaRegistro;

    // Getters y Setters
    public Long getMedicionId() { return medicionId; }
    public void setMedicionId(Long medicionId) { this.medicionId = medicionId; }
    public String getPlataforma() { return plataforma; }
    public void setPlataforma(String plataforma) { this.plataforma = plataforma; }
    public Integer getVolumen() { return volumen; }
    public void setVolumen(Integer volumen) { this.volumen = volumen; }
    public String getOperacion() { return operacion; }
    public void setOperacion(String operacion) { this.operacion = operacion; }
    public Integer getRepeticion() { return repeticion; }
    public void setRepeticion(Integer repeticion) { this.repeticion = repeticion; }
    public Boolean getEsCalentamiento() { return esCalentamiento; }
    public void setEsCalentamiento(Boolean esCalentamiento) { this.esCalentamiento = esCalentamiento; }
    public BigDecimal getTiempoRespuestaMs() { return tiempoRespuestaMs; }
    public void setTiempoRespuestaMs(BigDecimal tiempoRespuestaMs) { this.tiempoRespuestaMs = tiempoRespuestaMs; }
    public BigDecimal getMemoriaMB() { return memoriaMB; }
    public void setMemoriaMB(BigDecimal memoriaMB) { this.memoriaMB = memoriaMB; }
    public Integer getCodigoHttp() { return codigoHttp; }
    public void setCodigoHttp(Integer codigoHttp) { this.codigoHttp = codigoHttp; }
    public String getDispositivo() { return dispositivo; }
    public void setDispositivo(String dispositivo) { this.dispositivo = dispositivo; }
    public String getNotas() { return notas; }
    public void setNotas(String notas) { this.notas = notas; }
    public LocalDateTime getFechaRegistro() { return fechaRegistro; }
}