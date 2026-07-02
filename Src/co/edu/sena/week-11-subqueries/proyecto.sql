PRAGMA foreign_keys = ON;

-- ============================================
-- DOMINIO: Gestión de Acuarios (Tanks, Species, Fish, Feedings)
-- Tablas: main_items -> tanks (Tanques), child_records -> fish_specimens (Ejemplares de Peces)
-- ============================================
DROP TABLE IF EXISTS fish_specimens;
DROP TABLE IF EXISTS tanks;

CREATE TABLE tanks (
id       INTEGER PRIMARY KEY,
name     TEXT    NOT NULL,
capacity_liters REAL NOT NULL CHECK (capacity_liters > 0),
water_type TEXT    NOT NULL -- Categorías: 'Agua Dulce', 'Agua Salada', 'Salobre'
);

CREATE TABLE fish_specimens (
id       INTEGER PRIMARY KEY,
tank_id  INTEGER NOT NULL REFERENCES tanks (id) ON DELETE RESTRICT,
quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity >= 1),
species  TEXT    NOT NULL
);

-- ============================================
-- DATOS DE PRUEBA REALISTAS
-- Incluye el tanque 'Mega Arrecife Marino' como item huérfano (SIN ejemplares)
-- para evaluar correctamente la consulta con NOT EXISTS.
-- ============================================

INSERT INTO tanks (id, name, capacity_liters, water_type) VALUES
(1, 'Acuario Comunitario Neon', 120.0, 'Agua Dulce'),
(2, 'Estanque de Discos',        350.0, 'Agua Dulce'),
(3, 'Nano Reef Payaso',          60.0,  'Agua Salada'),
(4, 'Mega Arrecife Marino',     1500.0, 'Agua Salada'), -- <--- TANQUE HUÉRFANO (Sin ejemplares asignados)
(5, 'Manglar de Peces Globo',    200.0, 'Salobre');

INSERT INTO fish_specimens (id, tank_id, quantity, species) VALUES
(1, 1, 15, 'Pez Neón Tetra'),
(2, 1, 4,  'Pez Coridora'),
(3, 2, 6,  'Pez Disco Azul'),
(4, 2, 2,  'Pez Ángel Altum'),
(5, 3, 2,  'Pez Payaso Ocellaris'),
(6, 5, 3,  'Pez Globo Verde');

-- ============================================
-- CONSULTA 1: Subquery escalar correlacionada en WHERE
-- Muestra los tanques cuya capacidad supera el promedio de su tipo de agua
-- ============================================

SELECT
name         AS tanque,
capacity_liters AS capacidad_l,
water_type   AS tipo_agua
FROM tanks t
WHERE capacity_liters > (
SELECT AVG(t2.capacity_liters)
FROM tanks t2
WHERE t2.water_type = t.water_type
)
ORDER BY water_type, capacity_liters DESC;

-- ============================================
-- CONSULTA 2: Subquery escalar en SELECT
-- Muestra la capacidad de cada tanque junto al promedio global del acuario
-- ============================================

SELECT
name         AS tanque,
capacity_liters AS capacidad_l,
ROUND((SELECT AVG(capacity_liters) FROM tanks), 2) AS promedio_global_liters
FROM tanks
ORDER BY capacity_liters DESC;

-- ============================================
-- CONSULTA 3: NOT EXISTS — tanques sin actividad biológica
-- Encuentra los tanques que actualmente NO albergan ningún ejemplar de pez
-- ============================================

SELECT
name AS tanque_sin_peces
FROM tanks t
WHERE NOT EXISTS (
SELECT 1
FROM fish_specimens f
WHERE f.tank_id = t.id
);

-- ============================================
-- CONSULTA 4: Tabla derivada en FROM (Subquery en FROM)
-- Filtra las categorías de agua que tienen más de 2 registros de peces en total
-- ============================================

SELECT
cat_stats.tipo_agua,
cat_stats.total_registros_peces
FROM (
SELECT
t.water_type AS tipo_agua,
COUNT(f.id)  AS total_registros_peces
FROM tanks t
LEFT JOIN fish_specimens f ON f.tank_id = t.id
GROUP BY t.water_type
) AS cat_stats
WHERE cat_stats.total_registros_peces > 2
ORDER BY cat_stats.total_registros_peces DESC;