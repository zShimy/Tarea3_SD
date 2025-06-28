import pandas as pd
import geopandas as gpd
from shapely.geometry import Point

EVENTOS_CSV = '/data/eventos_filtrados.csv'
GEOJSON_COMUNAS = '/data/comunas_rm.geojson'
OUTPUT_CSV = '/data/eventos_filtrados_comuna.csv'

print("Cargando eventos...")
df = pd.read_csv(EVENTOS_CSV)

print("Creando geometría...")
geometry = [Point(xy) for xy in zip(df['lon'], df['lat'])]
gdf = gpd.GeoDataFrame(df, geometry=geometry, crs="EPSG:4326")

print("Cargando comunas...")
comunas = gpd.read_file(GEOJSON_COMUNAS)

campo_comuna = "Comuna"

print("Realizando unión espacial...")
gdf_joined = gpd.sjoin(gdf, comunas[[campo_comuna, 'geometry']], how="left", predicate='within')
gdf_joined = gdf_joined.rename(columns={campo_comuna: 'comuna'})
gdf_joined['comuna'] = gdf_joined['comuna'].fillna('desconocido')

cols_final = list(df.columns) + ['comuna']
gdf_joined[cols_final].to_csv(OUTPUT_CSV, index=False)

print(f"¡Listo! Archivo enriquecido guardado como {OUTPUT_CSV}")
