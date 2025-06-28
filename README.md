# Proyecto Sistemas Distribuidos | Entrega 2

## Descripción

##### Este proyecto implementa un pipeline distribuido y modular para procesar y analizar eventos de tráfico de Waze en la Región Metropolitana, usando Docker Compose. Cada módulo tiene una función y su output sirve de input para el siguiente, permitiendo obtener reportes y métricas útiles para la toma de decisiones en gestión vial.
---
## Pipeline y Servicios

El pipeline consta de los siguientes pasos/servicios, **que deben ejecutarse en orden**:

1. **mongo-exporter:**  
   Exporta todos los eventos almacenados en MongoDB (contenedor Docker) a un archivo CSV plano (`data/eventos.csv`).

2. **pig-filter:**  
   Filtra y limpia los eventos, eliminando registros incompletos, duplicados y no útiles. El resultado es `data/eventos_filtrados.csv`.

3. **class-comuna:**  
   Añade el CSV filtrado con la columna `comuna` utilizando los polígonos geográficos (GeoJSON). Produce `data/eventos_filtrados_comuna.csv`.

4. **pig-process:**  
   Procesa el csv con los eventos y genera distintos reportes agregados según múltiples métricas (comuna, tipo, horario, etc.).

---
## Ejecución Paso a Paso

> Todos los comandos se ejecutan en la raíz del proyecto donde está el `docker-compose.yml`.

### 1. Exportar eventos desde MongoDB
```sh
docker compose up --build mongo-exporter
```
- Crea el archivo `data/eventos.csv` con todos los eventos desde la base de datos.

### 2. Filtrar eventos con Apache Pig
```sh
docker compose up --build pig-filter
```
- Filtra y limpia los eventos.
- Dado a que fue procesado con pig, se tendrá la carpeta data/eventos_filtrados.csv siendo el ultimo archivo `part-r-00000`, se tendrá que copiar y pegar en la carpeta data, y renombrarlo a `eventos_filtrados.csv`.
### 3. Adición del campo comunas al CSV 
- Primero se tiene que pegar `evento_id,tipo,subtipo,calle,lat,lon,timestamp,fecha_evento,hora_evento,fuente,procesado,comuna` en la primera fila del archivo `data/eventos_filtrados.csv`, para que funcione de forma correcta el servicio `class-comunas`.
```sh
docker compose up --build class-comuna
```
- Tras la ejecución del `class-comuna` se almacenará en la carpeta data el archivo `eventos_filtrados_comuna.csv` el cual va a ser el CSV utilizado para el procesamiento y la obtencion de reportes.

### 4. Procesar y generar reportes con Apache Pig
```sh
docker compose up --build pig-process
```
Calcula reportes agregados por diferentes métricas:
- Eventos por comuna
- Eventos por tipo o subtipo
- Eventos por horario
- Combinaciones: tipo+calle, tipo+comuna, calle+comuna, tipo+horario+calle, etc.

> Los reportes se generan como carpetas, cada una con su archivo part-r-00000, en donde se tendrá la información del reporte.
