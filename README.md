# Proyecto Sistemas Distribuidos – Entrega 3

## Descripción General

Este proyecto implementa un pipeline **distribuido y modular** para procesar y analizar eventos de tráfico en la Región Metropolitana de Santiago, obtenidos desde Waze. La arquitectura se basa en **Docker Compose**, permitiendo que cada módulo funcione como un servicio independiente. El flujo de datos es secuencial y cada módulo produce la entrada del siguiente, permitiendo obtener **reportes limpios y visualizaciones útiles para la toma de decisiones en gestión vial**.

---

##  Arquitectura del Pipeline

El pipeline consta de **6 servicios** principales, que deben ejecutarse **en orden lógico pero pueden correr en paralelo**:

1. ###  `scraper-selenium`
   Scrapea los eventos en tiempo real desde el mapa de Waze usando Selenium y los guarda en una base de datos MongoDB.

2. ### `cache-service`
   Servicio que implementa Redis como sistema de caché para reducir la latencia de consultas a MongoDB.

3. ### `mongo-exporter`
   Exporta los eventos desde MongoDB hacia un archivo CSV plano (`data/eventos.csv`), para su posterior análisis.

4. ### `pig-filter`
   Filtra y limpia los datos eliminando:
   - El encabezado
   - Eventos incompletos o vacíos (sin tipo, sin coordenadas, etc.)
   - Eventos duplicados por `evento_id`  
   El resultado es un nuevo archivo limpio: `data/eventos_filtrados.csv`.

5. ### `pig-process`
   Procesa el archivo limpio y genera reportes agregados por:
   - Comuna
   - Tipo y subtipo de evento
   - Rangos horarios, entre otros.

6. ### `display-elastic`
   Carga los datos procesados a **Elasticsearch**, permitiendo su visualización mediante **Kibana**.

---

##  Ejecución Paso a Paso

> Todos los comandos deben ejecutarse desde la raíz del proyecto donde se encuentra el archivo `docker-compose.yml`.

### 1. Scrapeo de eventos con Selenium

Para ejecutar el scraper manualmente:

```bash
cd scraper-selenium
python -m venv selenium-venv
.\selenium-venv\Scripts\Activate.ps1  # En PowerShell de Windows
pip install -r requirements.txt
pip install setuptools packaging webdriver-manager
python scraper_selenium.py
```
- Se abrirá una pestaña de Google Chrome con la vista del mapa de Waze.
- El scraper recogerá los eventos y los almacenará en MongoDB.

### 2. Construcción y ejecución de los contenedores
```bash
docker compose build
docker compose up
```
- Esto levanta los servicios definidos en el pipeline.
- Los datos fluyen desde la base de datos hasta el filtrado, procesamiento y visualización.

###  3. Visualización en Kibana
Una vez ejecutado todo el pipeline:

> Accede a: http://localhost:5601/

Dentro de Kibana, puedes crear dashboards e índices basados en los datos procesados.

