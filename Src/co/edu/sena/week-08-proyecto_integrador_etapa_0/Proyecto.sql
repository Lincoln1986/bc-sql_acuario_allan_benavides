PRAGMA foreign_keys = ON;

-- ============================================
-- PARTE 1: ESQUEMA (DDL)
-- ============================================

-- Tabla de referencia: tipos de tanques / ecosistemas
CREATE TABLE tank_types (
    id          INTEGER PRIMARY KEY,
    name        TEXT    NOT NULL UNIQUE,
    description TEXT                        -- opcional
);

-- Tabla secundaria: catálogo de planes de alimentación por especie y ecosistema
CREATE TABLE feeding_plans (
    id              INTEGER PRIMARY KEY,
    species_type    TEXT    NOT NULL,
    tank_type_id    INTEGER NOT NULL
        REFERENCES tank_types(id) ON DELETE RESTRICT,
    daily_cost      REAL    NOT NULL CHECK (daily_cost > 0),
    feedings_per_day INTEGER NOT NULL DEFAULT 2
                            CHECK (feedings_per_day >= 1),
    UNIQUE (species_type, tank_type_id)
);

-- Tabla principal: ejemplares de peces registrados
CREATE TABLE fish_specimens (
    id              INTEGER PRIMARY KEY,
    tank_name       TEXT    NOT NULL,           -- Nombre del tanque asignado
    chip_code       TEXT    UNIQUE,             -- Código de chip de rastreo (puede ser NULL)
    species_type    TEXT    NOT NULL,
    gender          TEXT,                       -- puede ser NULL (indeterminado)
    health_notes    TEXT,                       -- observaciones médicas (puede ser NULL)
    health_status   TEXT    NOT NULL DEFAULT 'saludable'
                            CHECK (health_status IN ('saludable','cuarentena','en_tratamiento','baja')),
    feeding_plan_id INTEGER NOT NULL
        REFERENCES feeding_plans(id) ON DELETE RESTRICT,
    registered_at   TEXT    NOT NULL DEFAULT (date('now')),
    is_active       INTEGER NOT NULL DEFAULT 1
                            CHECK (is_active IN (0, 1))
);


-- ============================================
-- PARTE 2: DATOS (DML)
-- ============================================

-- Tipos de tanques o ambientes (tabla de referencia)
INSERT INTO tank_types (id, name, description) VALUES
    (1, 'Arrecife de Coral', 'Ecosistema marino con corales vivos y alta salinidad'),
    (2, 'Comunitario Tropical','Agua dulce templada con vegetación densa'),
    (3, 'Solo Peces Marinos', 'Agua salada enfocada en peces grandes sin corales'),
    (4, 'Estuario Salobre',   'Agua de transición de río a mar, salinidad media'),
    (5, 'Estanque Frío',      'Agua dulce a baja temperatura para especies grandes');

-- Catálogo de planes de alimentación (tabla secundaria — 12 registros)
INSERT INTO feeding_plans (id, species_type, tank_type_id, daily_cost, feedings_per_day) VALUES
    (1,  'Pez Payaso',   1,  8000,  2),
    (2,  'Pez Payaso',   3,  4000,  1),
    (3,  'Pez Cirujano', 1, 10000,  2),
    (4,  'Pez Cirujano', 3,  5000,  1),
    (5,  'Pez Disco',    2, 18000,  3),
    (6,  'Pez Disco',    4, 25000,  5),
    (7,  'Pez Ángel',    1, 15000,  3),
    (8,  'Pez Ángel',    5, 20000,  4),
    (9,  'Pez Guppy',    3,  4500,  1),
    (10, 'Pez Globo',    1, 22000,  4),
    (11, 'Pez Globo',    4, 30000,  6),
    (12, 'Pez Goldfish', 2,  9000,  2);

-- Ejemplares de peces individuales (tabla principal — 30 registros)
-- 4 registros con chip_code NULL y varios con gender/health_notes NULL
INSERT INTO fish_specimens (id, tank_name, chip_code, species_type, gender, health_notes, health_status, feeding_plan_id) VALUES
    (1,  'Arrecife Norte',    'CHIP300123', 'Pez Payaso',   'Macho',   'Aleta dorsal lastimada', 'saludable',     1),
    (2,  'Amazonas Central',  NULL,         'Pez Disco',    'Hembra',  NULL,                     'cuarentena',    5),
    (3,  'Marino Costero',    'CHIP311987', 'Pez Cirujano', 'Macho',   'Pérdida de apetito',     'en_tratamiento',3),
    (4,  'Coral Sur',         'CHIP320123', 'Pez Ángel',    NULL,      NULL,                     'saludable',     7),
    (5,  'Foso del Pacífico', NULL,         'Pez Globo',    'Macho',   'Urgente: revisar nado',  'cuarentena',    10),
    (6,  'Bahía Tropical',    'CHIP301123', 'Pez Guppy',    'Macho',   NULL,                     'saludable',     9),
    (7,  'Arrecife Norte',    'CHIP312123', 'Pez Payaso',   'Hembra',  NULL,                     'en_tratamiento',2),
    (8,  'Estanque Exterior', NULL,         'Pez Goldfish', 'Hembra',  'Escamas opacas',         'cuarentena',    12),
    (9,  'Manglar Salobre',   'CHIP303123', 'Pez Disco',    NULL,      'Especie muy tímida',     'en_tratamiento',6),
    (10, 'Río Amazonas',      'CHIP314123', 'Pez Cirujano', 'Hembra',  NULL,                     'saludable',     4),
    (11, 'Estanque Frío',     'CHIP305123', 'Pez Ángel',    'Macho',   'Falta marcar territorio','cuarentena',    8),
    (12, 'Costa de Coral',    NULL,         'Pez Globo',    'Hembra',  NULL,                     'baja',          11),
    (13, 'Arrecife Norte',    'CHIP316123', 'Pez Payaso',   'Macho',   'Fémina dominante cerca', 'saludable',     1),
    (14, 'Bahía Tropical',    'CHIP307123', 'Pez Guppy',    'Hembra',  NULL,                     'en_tratamiento',9),
    (15, 'Marino Costero',    'CHIP318123', 'Pez Cirujano', 'Macho',   'Raspadura en el flanco', 'cuarentena',    3),
    (16, 'Arrecife Norte',    'CHIP309123', 'Pez Disco',    'Hembra',  NULL,                     'saludable',     5),
    (17, 'Arrecife Norte',    'CHIP320123', 'Pez Payaso',   'Macho',   NULL,                     'en_tratamiento',2),
    (18, 'Coral Sur',         'CHIP301123', 'Pez Ángel',    'Macho',   'Infección branquial',    'cuarentena',    7),
    (19, 'Estanque Exterior', 'CHIP312123', 'Pez Goldfish', 'Hembra',  NULL,                     'saludable',     12),
    (20, 'Foso del Pacífico', 'CHIP303123', 'Pez Globo',    'Macho',   'Revisar coloración',     'en_tratamiento',10),
    (21, 'Río Amazonas',      'CHIP314123', 'Pez Cirujano', 'Macho',   NULL,                     'saludable',     4),
    (22, 'Manglar Salobre',   'CHIP305123', 'Pez Disco',    'Hembra',  'Desove reciente',        'cuarentena',    6),
    (23, 'Bahía Tropical',    'CHIP316123', 'Pez Guppy',    'Macho',   NULL,                     'saludable',     9),
    (24, 'Arrecife Norte',    'CHIP307123', 'Pez Payaso',   'Hembra',  'Parásitos externos',     'en_tratamiento',1),
    (25, 'Estanque Frío',     'CHIP318123', 'Pez Ángel',    'Macho',   NULL,                     'saludable',     8),
    (26, 'Costa de Coral',    'CHIP309123', 'Pez Globo',    'Hembra',  'Infección bacteriana',   'cuarentena',    11),
    (27, 'Estanque Exterior', 'CHIP320123', 'Pez Goldfish', NULL,      NULL,                     'en_tratamiento',12),
    (28, 'Marino Costero',    'CHIP301123', 'Pez Cirujano', 'Hembra',  NULL,                     'saludable',     3),
    (29, 'Arrecife Norte',    'CHIP312123', 'Pez Disco',    'Macho',   'Monitoreo por estrés',   'cuarentena',    5),
    (30, 'Arrecife Norte',    'CHIP303123', 'Pez Payaso',   'Hembra',  NULL,                     'en_tratamiento',2);


-- ============================================
-- PARTE 3: REPORTES (SELECT)
-- ============================================

-- REPORTE 1: Totales globales
-- Total de peces ejemplares activos, suma y promedio de costos de alimentación diarios
SELECT
    COUNT(*)            AS total_ejemplares,
    SUM(fp.daily_cost)  AS costo_alimentacion_total,
    AVG(fp.daily_cost)  AS costo_alimentacion_promedio
FROM fish_specimens fs
JOIN feeding_plans fp ON fp.id = fs.feeding_plan_id
WHERE fs.is_active = 1;


-- REPORTE 2: Ejemplares por tipo de ecosistema/tanque (GROUP BY)
-- Cuántos peces están asignados a cada ecosistema y su costo de alimentación promedio
SELECT
    tt.name             AS tipo_ecosistema,
    COUNT(fs.id)        AS total_peces,
    AVG(fp.daily_cost)  AS costo_alimentacion_promedio
FROM fish_specimens fs
JOIN feeding_plans fp ON fp.id = fs.feeding_plan_id
JOIN tank_types tt    ON tt.id = fp.tank_type_id
WHERE fs.is_active = 1
GROUP BY tt.name
ORDER BY total_peces DESC;


-- REPORTE 3: Tipos de especies con más de 4 ejemplares registrados (HAVING)
-- Detecta las especies con mayor sobrepoblación o densidad en el inventario
SELECT
    species_type        AS tipo_especie,
    COUNT(*)            AS total_ejemplares
FROM fish_specimens
WHERE is_active = 1
GROUP BY species_type
HAVING total_ejemplares > 4
ORDER BY total_ejemplares DESC;


-- REPORTE 4: Ejemplares sin chip de rastreo registrado (NULL + COALESCE)
-- Peces silvestres o nacidos en tanque que no poseen tag electrónico aún
SELECT
    tank_name,
    COALESCE(chip_code, 'Sin chip rastreo') AS codigo_identificacion,
    COALESCE(health_notes, 'Sin notas')    AS historial_medico,
    health_status
FROM fish_specimens
WHERE chip_code IS NULL;


-- REPORTE 5: Búsqueda combinada — ejemplares activos con planes de costo medio
-- Peces vigentes cuya dieta diaria cuesta entre $8.000 y $20.000
SELECT
    fs.tank_name,
    fs.species_type,
    tt.name     AS tipo_ecosistema,
    fp.daily_cost AS costo_diario
FROM fish_specimens fs
JOIN feeding_plans fp ON fp.id = fs.feeding_plan_id
JOIN tank_types tt    ON tt.id = fp.tank_type_id
WHERE fp.daily_cost BETWEEN 8000 AND 20000
  AND fs.is_active = 1
  AND fs.health_status != 'baja'
ORDER BY fp.daily_cost DESC
LIMIT 10;