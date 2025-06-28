events = LOAD '/data/eventos.csv'
    USING PigStorage(',')
    AS (evento_id:chararray, tipo:chararray, subtipo:chararray, calle:chararray, lat:chararray, lon:chararray,
        timestamp:chararray, fecha_evento:chararray, hora_evento:chararray, fuente:chararray, procesado:chararray);

data_wo_header = FILTER events BY evento_id != 'evento_id';

filtered = FILTER data_wo_header BY 
    (tipo is not null) AND (tipo != '') AND
    (lat is not null) AND (lat != '') AND
    (lon is not null) AND (lon != '');

unique = DISTINCT filtered;

STORE unique INTO '/data/eventos_filtrados.csv' USING PigStorage(',');
