package com.inventario;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.UncategorizedSQLException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.sql.SQLException;

@ControllerAdvice
public class GlobalExceptionHandler {

    // Errores de JPA/Hibernate (Ej: Código duplicado, FK inválida)
    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<String> handleDataIntegrity(DataIntegrityViolationException ex) {
        return ResponseEntity.status(HttpStatus.CONFLICT)
                .body("Error de integridad: Código duplicado o restricción violada.");
    }

    // Errores del Procedimiento Almacenado (sp_RegistrarMovimiento)
    @ExceptionHandler(UncategorizedSQLException.class)
    public ResponseEntity<String> handleStoredProcedure(UncategorizedSQLException ex) {
        Throwable cause = ex.getCause();
        if (cause instanceof SQLException sqlEx) {
            int errorCode = sqlEx.getErrorCode();
            return switch (errorCode) {
                case 50001 -> ResponseEntity.status(HttpStatus.NOT_FOUND).body("Producto no existe.");
                case 50002 -> ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Tipo o cantidad inválidos.");
                case 50003 -> ResponseEntity.status(HttpStatus.CONFLICT).body("Stock insuficiente.");
                case 50004 -> ResponseEntity.status(HttpStatus.CONFLICT).body("Producto inactivo.");
                default -> ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error en BD: " + sqlEx.getMessage());
            };
        }
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error desconocido en BD.");
    }
}