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

    @PostMapping
    public ResponseEntity<Void> registrarMediciones(@RequestBody List<Medicion> mediciones) {
        medicionRepo.saveAll(mediciones);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }
}