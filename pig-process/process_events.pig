events = LOAD '/data/eventos_filtrados_comuna.csv'
    USING PigStorage(',')
    AS (
        evento_id:chararray,
        tipo:chararray,
        subtipo:chararray,
        calle:chararray,
        lat:chararray,
        lon:chararray,
        timestamp:chararray,
        fecha_evento:chararray,
        hora_evento:chararray,
        fuente:chararray,
        procesado:chararray,
        comuna:chararray
    );

-- Conteo por comuna
by_comuna = GROUP events BY comuna;
count_by_comuna = FOREACH by_comuna GENERATE
    group   AS comuna,
    COUNT(events) AS cantidad;

ordered_comuna = ORDER count_by_comuna BY cantidad DESC;
STORE ordered_comuna INTO '/data/reporte_comunas.csv' USING PigStorage(',');

-- Conteo por tipo de evento
by_tipo = GROUP events BY tipo;
count_by_tipo = FOREACH by_tipo GENERATE
    group   AS tipo,
    COUNT(events) AS cantidad;

ordered_tipo = ORDER count_by_tipo BY cantidad DESC;
STORE ordered_tipo INTO '/data/reporte_tipos.csv' USING PigStorage(',');

-- Conteo por subtipo
by_subtipo = GROUP events BY subtipo;
count_by_subtipo = FOREACH by_subtipo GENERATE
    group    AS subtipo,
    COUNT(events) AS cantidad;

ordered_subtipo = ORDER count_by_subtipo BY cantidad DESC;
STORE ordered_subtipo INTO '/data/reporte_subtipos.csv' USING PigStorage(',');

-- Conteo por calle
by_calle = GROUP events BY calle;
count_by_calle = FOREACH by_calle GENERATE
    group   AS calle,
    COUNT(events) AS cantidad;

ordered_calle = ORDER count_by_calle BY cantidad DESC;
STORE ordered_calle INTO '/data/reporte_calles.csv' USING PigStorage(',');

-- Conteo por hora con formato [HH:00 - HH:59]
events_hora = FOREACH events GENERATE
    *,
    (int)SUBSTRING(hora_evento, 0, 2) AS hora_num,
    CONCAT('[', SUBSTRING(hora_evento,0,2), ':00 - ', SUBSTRING(hora_evento,0,2), ':59]') AS hora_intervalo;

by_hora = GROUP events_hora BY hora_intervalo;
count_by_hora = FOREACH by_hora GENERATE
    group    AS horario,
    COUNT(events_hora) AS cantidad;

ordered_hora = ORDER count_by_hora BY cantidad DESC;
STORE ordered_hora INTO '/data/reporte_horarios.csv' USING PigStorage(',');

-- Conteo por combinación tipo de evento + calle
by_tipo_calle = GROUP events BY (tipo, calle);
count_by_tipo_calle = FOREACH by_tipo_calle GENERATE
    group.$0 AS tipo,
    group.$1 AS calle,
    COUNT(events) AS cantidad;

ordered_tipo_calle = ORDER count_by_tipo_calle BY cantidad DESC;
STORE ordered_tipo_calle INTO '/data/reporte_tipo_calle.csv' USING PigStorage(',');

-- Conteo por combinación tipo de evento + comuna
by_tipo_comuna = GROUP events BY (tipo, comuna);
count_by_tipo_comuna = FOREACH by_tipo_comuna GENERATE
    group.$0 AS tipo,
    group.$1 AS comuna,
    COUNT(events) AS cantidad;

ordered_tipo_comuna = ORDER count_by_tipo_comuna BY cantidad DESC;
STORE ordered_tipo_comuna INTO '/data/reporte_tipo_comuna.csv' USING PigStorage(',');

-- Conteo por combinación calle + comuna
by_calle_comuna = GROUP events BY (calle, comuna);
count_by_calle_comuna = FOREACH by_calle_comuna GENERATE
    group.$0 AS calle,
    group.$1 AS comuna,
    COUNT(events) AS cantidad;

ordered_calle_comuna = ORDER count_by_calle_comuna BY cantidad DESC;
STORE ordered_calle_comuna INTO '/data/reporte_calle_comuna.csv' USING PigStorage(',');

-- Conteo por combinación Tipo + Hora + Calle
by_tipo_hora_calle = GROUP events_hora BY (tipo, hora_intervalo, calle);
count_by_tipo_hora_calle = FOREACH by_tipo_hora_calle GENERATE
    group.$0 AS tipo,
    group.$1 AS horario,
    group.$2 AS calle,
    COUNT(events_hora) AS cantidad;

ordered_tipo_hora_calle = ORDER count_by_tipo_hora_calle BY cantidad DESC;
STORE ordered_tipo_hora_calle INTO '/data/reporte_tipo_horario_calle.csv' USING PigStorage(',');
