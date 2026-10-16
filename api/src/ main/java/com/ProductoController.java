package com.inventario.controller;

import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/productos")
public class ProductoController {

    @GetMapping
    public List<Map<String, Object>> listar() {
        return List.of(
            Map.of("id", 1, "nombre", "Producto A", "stock", 100),
            Map.of("id", 2, "nombre", "Producto B", "stock", 250)
        );
    }

    @PostMapping
    public Map<String, Object> crear(@RequestBody Map<String, Object> producto) {
        return Map.of("id", 3, "creado", true, "producto", producto);
    }

    @PutMapping("/{id}")
    public Map<String, Object> actualizar(@PathVariable Long id,
                                          @RequestBody Map<String, Object> producto) {
        return Map.of("id", id, "actualizado", true, "producto", producto);
    }

    @DeleteMapping("/{id}")
    public Map<String, Object> eliminar(@PathVariable Long id) {
        return Map.of("id", id, "eliminado", true);
    }
}
