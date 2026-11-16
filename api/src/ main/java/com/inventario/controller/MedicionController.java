package com.inventario.controller;

import com.inventario.entity.Medicion;
import com.inventario.repository.MedicionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/mediciones")
@CrossOrigin(origins = "*")
public class MedicionController {

    @Autowired
    private MedicionRepository medicionRepo;

    // Este recibe una sola medición (el que usa Android ahora)
    @PostMapping
    public ResponseEntity<Void> registrarMedicion(@RequestBody Medicion medicion) {
        medicionRepo.save(medicion);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

    // Este recibe una lista (el que usaba la web)
    @PostMapping("/lote")
    public ResponseEntity<Void> registrarMedicionesLote(@RequestBody List<Medicion> mediciones) {
        medicionRepo.saveAll(mediciones);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }
}