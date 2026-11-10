package com.inventario.controller;

import com.inventario.dto.MovimientoRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/movimientos")
@CrossOrigin(origins = "*")
public class MovimientoController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostMapping
    public ResponseEntity<String> registrarMovimiento(@RequestBody MovimientoRequest request) {
        try {
            // Llamada al procedimiento almacenado
            jdbcTemplate.update(
                    "EXEC dbo.sp_RegistrarMovimiento @ProductoId = ?, @TipoMovimiento = ?, @Cantidad = ?, @Comentario = ?",
                    request.getProductoId(), request.getTipoMovimiento(), request.getCantidad(), request.getComentario()
            );
            return new ResponseEntity<>("Movimiento registrado exitosamente", HttpStatus.CREATED);
        } catch (Exception e) {
            // El GlobalExceptionHandler se encargará de traducir los errores de SQL Server
            throw e;
        }
    }
}