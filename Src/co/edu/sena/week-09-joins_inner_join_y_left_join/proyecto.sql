PRAGMA foreign_keys = ON;

-- ============================================
-- DOMINIO: Gestión de Acuarios (Tanks, Species, Fish, Feedings)
-- Tablas: tank_types (Ref), species (Main), feedings (Child)
-- ============================================

DROP TABLE IF EXISTS feedings;
DROP TABLE IF EXISTS species;
DROP TABLE IF EXISTS tank_types;

-- Tabla de referencia: Tipos de agua o ambientes requeridos
CREATE TABLE tank_types (
id          INTEGER PRIMARY KEY,
name        TEXT    NOT NULL UNIQUE,
salinity    REAL    NOT NULL DEFAULT 0.0,  -- Columnas específicas del dominio
temperature REAL    NOT NULL DEFAULT 24.0
);

-- Tabla principal de tu dominio: Especies catalogadas en el acuario
CREATE TABLE species (
id           INTEGER PRIMARY KEY,
common_name  TEXT    NOT NULL UNIQUE,
scientific_name TEXT NOT NULL UNIQUE,
tank_type_id INTEGER REFERENCES tank_types (id) ON DELETE RESTRICT
);

-- Tabla hija: Historial de eventos de alimentación (Feedings)
CREATE TABLE feedings (
id           INTEGER PRIMARY KEY,
recorded_at  TEXT    NOT NULL DEFAULT (DATE('now')),
food_type    TEXT    NOT NULL,
amount_grams REAL    NOT NULL CHECK (amount_grams > 0),
species_id   INTEGER REFERENCES species (id) ON DELETE CASCADE
);

-- ============================================
-- DATOS DE PRUEBA REALISTAS
-- Incluye un registro "huérfano" en species (Pez León)
-- que no tiene ningún historial de alimentación asignado.
-- ============================================

INSERT INTO tank_types (id, name, salinity, temperature) VALUES
(1, 'Agua Dulce Tropical', 0.0,  25.5),
(2, 'Agua Salada Arrecife',35.0, 24.0),
(3, 'Agua Salobre',        15.0, 26.0);

INSERT INTO species (id, common_name, scientific_name, tank_type_id) VALUES
(1, 'Pez Payaso',    'Amphiprion ocellaris', 2),
(2, 'Pez Guppy',     'Poecilia reticulata',  1),
(3, 'Pez Cirujano',  'Paracanthurus hepatus',2),
(4, 'Pez Monjita',   'Gymnocorymbus ternetzi',1),
(5, 'Pez León',      'Pterois antennata',    2); -- <--- EJEMPLAR HUÉRFANO (Sin registros en feedings)

INSERT INTO feedings (id, food_type, amount_grams, species_id, recorded_at) VALUES
(1, 'Hojuelas de Artemia',  15.5, 1, '2026-07-01'),
(2, 'Gránulos de Algas',    30.0, 3, '2026-07-01'),
(3, 'Micro Pellets',         5.0, 2, '2026-07-02'),
(4, 'Larva de Mosquito',    12.0, 4, '2026-07-02'),
(5, 'Pellets de Proteína',  18.0, 1, '2026-07-02'),
(6, 'Gránulos de Algas',    28.5, 3, '2026-07-02');

-- ============================================
-- CONSULTA 1: INNER JOIN principal
-- Une las dos tablas más importantes (Especies y Alimentación)
-- Muestra solo las especies que ya han sido alimentadas
-- ============================================

SELECT
s.common_name     AS especie,
f.food_type       AS alimento_provisto,
f.recorded_at     AS fecha_alimentacion
FROM species s
INNER JOIN feedings f ON f.species_id = s.id;

-- ============================================
-- CONSULTA 2: JOIN con tres tablas
-- Encadena species + feedings + tank_types
-- ============================================

SELECT
s.common_name     AS especie,
tt.name           AS tipo_ambiente,
f.food_type       AS tipo_alimento,
f.amount_grams    AS cantidad_g,
f.recorded_at     AS fecha
FROM species s
INNER JOIN tank_types tt ON s.tank_type_id = tt.id
INNER JOIN feedings f    ON f.species_id   = s.id;

-- ============================================
-- CONSULTA 3: LEFT JOIN — todos los registros
-- Obtiene todas las especies aunque no tengan registros de alimentación
-- ============================================

SELECT
s.common_name     AS especie,
f.food_type       AS alimento,
f.recorded_at     AS ultima_actividad
FROM species s
LEFT JOIN feedings f ON f.species_id = s.id;

-- ============================================
-- CONSULTA 4: Detectar huérfanos (registros sin actividad)
-- Muestra las especies que nunca han recibido una sesión de alimentación
-- ============================================

SELECT
s.common_name AS especie_sin_alimentacion,
s.scientific_name
FROM species s
LEFT JOIN feedings f ON f.species_id = s.id
WHERE f.id IS NULL;

-- ============================================
-- CONSULTA 5: Reporte agregado con LEFT JOIN + COUNT
-- Cantidad de alimentaciones por especie (incluyendo el 0 para el huérfano)
-- ============================================

SELECT
s.common_name     AS especie,
COUNT(f.id)       AS total_alimentaciones
FROM species s
LEFT JOIN feedings f ON f.species_id = s.id
GROUP BY s.common_name
ORDER BY total_alimentaciones DESC;