package com.inventario;

import com.inventario.entity.Producto;
import com.inventario.repository.ProductoRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Arrays;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
public class ProductoControllerTest {

    @Autowired
    private MockMvc mockMvc;

    // Simulamos la base de datos para no necesitar SQL Server en los tests
    @MockBean
    private ProductoRepository productoRepository;

    @Test
    public void testListarProductos() throws Exception {
        Producto p1 = new Producto();
        p1.setProductoId(1);
        p1.setNombre("Producto Test");
        p1.setCodigo("TEST-001");
        p1.setPrecioUnitario(new java.math.BigDecimal("10.50"));

        when(productoRepository.findAll()).thenReturn(Arrays.asList(p1));

        mockMvc.perform(get("/api/productos")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].nombre").value("Producto Test"))
                .andExpect(jsonPath("$[0].codigo").value("TEST-001"));
    }
}