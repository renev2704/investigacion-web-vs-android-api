```markdown
# 🌐 Aplicación Web - Sistema de Inventario

Interfaz web desarrollada con **HTML5**, **CSS3** y **JavaScript puro** (sin frameworks). Consume la API REST del backend para gestionar productos y ejecutar el experimento de rendimiento comparativo.

---

## 📋 Requisitos previos

| Herramienta | Versión | Notas |
|---|---|---|
| **Google Chrome** | 128 o superior | Navegador objetivo del experimento |
| **Servidor local** | Cualquiera | Python, Node.js o extensión Live Server |
| **API REST corriendo** | — | Debe estar activa en `http://localhost:8080` |

> ⚠️ **Importante**: La API del backend debe estar corriendo **antes** de abrir la web, de lo contrario no se podrán cargar los productos.

---

## 🚀 1. Iniciar la API primero

Antes de abrir la página web, asegúrate de que la API del backend esté corriendo:

```bash
cd api
./mvnw spring-boot:run

Confirma que responde en http://localhost:8080/api/productos.

2. Ejecutar la Web