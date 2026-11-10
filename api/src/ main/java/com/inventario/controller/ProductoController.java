package com.inventario.controller;

import com.inventario.entity.Categoria;
import com.inventario.entity.Producto;
import com.inventario.repository.CategoriaRepository;
import com.inventario.repository.ProductoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class ProductoController {

    @Autowired
    private ProductoRepository productoRepo;

    @Autowired
    private CategoriaRepository categoriaRepo;

    @GetMapping("/productos")
    public List<Producto> listarProductos() {
        return productoRepo.findAll();
    }

    @GetMapping("/productos/{id}")
    public ResponseEntity<Producto> obtenerProducto(@PathVariable Integer id) {
        return productoRepo.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }

    @PostMapping("/productos")
    public ResponseEntity<Producto> crearProducto(@RequestBody Producto producto) {
        // Aseguramos que el ID sea nulo para que lo genere la BD
        producto.setProductoId(null);
        if(producto.getStock() == null) producto.setStock(0);
        if(producto.getActivo() == null) producto.setActivo(true);

        Producto nuevo = productoRepo.save(producto);
        return new ResponseEntity<>(nuevo, HttpStatus.CREATED);
    }

    @PutMapping("/productos/{id}")
    public ResponseEntity<Producto> actualizarProducto(@PathVariable Integer id, @RequestBody Producto detalles) {
        return productoRepo.findById(id).map(producto -> {
            producto.setCodigo(detalles.getCodigo());
            producto.setNombre(detalles.getNombre());
            producto.setDescripcion(detalles.getDescripcion());
            producto.setCategoriaId(detalles.getCategoriaId());
            producto.setPrecioUnitario(detalles.getPrecioUnitario());
            producto.setStockMinimo(detalles.getStockMinimo());
            producto.setActivo(detalles.getActivo());
            producto.setFechaActualizacion(LocalDateTime.now());
            // El Stock NO se actualiza aquí (según el README)
            return ResponseEntity.ok(productoRepo.save(producto));
        }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/productos/{id}")
    public ResponseEntity<Void> eliminarProducto(@PathVariable Integer id) {
        if (productoRepo.existsById(id)) {
            productoRepo.deleteById(id);
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/categorias")
    public List<Categoria> listarCategorias() {
        return categoriaRepo.findAll();
    }
}