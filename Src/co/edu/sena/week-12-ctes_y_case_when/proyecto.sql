PRAGMA foreign_keys = ON;

-- ============================================
-- DOMINIO: Gestión de Acuarios (Tanks, Species, Fish, Feedings)
-- Tablas: items -> supply_items (Suministros), transactions -> feeding_logs (Consumos/Alimentación)
-- ============================================

DROP TABLE IF EXISTS feeding_logs;
DROP TABLE IF EXISTS supply_items;

CREATE TABLE supply_items (
id       INTEGER PRIMARY KEY,
name     TEXT    NOT NULL,
price    REAL    NOT NULL CHECK (price > 0), -- Costo por unidad/empaque
category TEXT    NOT NULL                    -- 'Alimento Seco', 'Alimento Vivo', 'Suplementos'
);

CREATE TABLE feeding_logs (
id       INTEGER PRIMARY KEY,
item_id  INTEGER NOT NULL REFERENCES supply_items (id) ON DELETE RESTRICT,
quantity INTEGER NOT NULL DEFAULT 1,         -- Cantidad de dosis o empaques consumidos
tx_date  TEXT    NOT NULL                    -- Formato YYYY-MM-DD
);

-- ============================================
-- DATOS DE PRUEBA
-- 7 Suministros distribuidos en 3 categorías diferentes
-- 11 Registros de consumo distribuidos a lo largo de varias semanas de 2026
-- ============================================

INSERT INTO supply_items (id, name, price, category) VALUES
(1, 'Hojuelas Premium Krill', 45000, 'Alimento Seco'),
(2, 'Pellets Básicos de Algas',15000, 'Alimento Seco'),
(3, 'Bloques de Artemia Congelada', 32000, 'Alimento Vivo'),
(4, 'Cepa de Copépodos Vivos',  55000, 'Alimento Vivo'),
(5, 'Complejo de Aminoácidos Coral', 75000, 'Suplementos'),
(6, 'Suplemento de Calcio Líquido', 48000, 'Suplementos'),
(7, 'Micro-perlas de Crecimiento', 12000, 'Alimento Seco');

INSERT INTO feeding_logs (id, item_id, quantity, tx_date) VALUES
(1,  1, 2, '2026-05-01'), -- Semana 1
(2,  2, 5, '2026-05-03'),
(3,  3, 3, '2026-05-04'),
(4,  5, 1, '2026-05-10'), -- Semana 2
(5,  7, 4, '2026-05-12'),
(6,  1, 2, '2026-05-18'), -- Semana 3
(7,  4, 2, '2026-05-20'),
(8,  6, 1, '2026-05-21'),
(9,  3, 4, '2026-05-26'), -- Semana 4
(10, 2, 6, '2026-05-28'),
(11, 4, 1, '2026-06-02'); -- Semana 5

-- ============================================
-- CONSULTA 1: CTE simple + CASE WHEN de clasificación
-- Clasifica cada suministro de acuario según su costo en 3 rangos
-- Umbrales: Premium (>= $50.000), Estándar (>= $20.000), Económico (< $20.000)
-- ============================================

WITH suministros_con_actividad AS (
SELECT
i.id,
i.name,
i.price,
i.category,
COUNT(t.id) AS total_consumos
FROM supply_items i
LEFT JOIN feeding_logs t ON t.item_id = i.id
GROUP BY i.id, i.name, i.price, i.category
)
SELECT
name               AS suministro,
price              AS costo_unidad,
total_consumos     AS veces_utilizado,
CASE
WHEN price >= 50000 THEN 'Premium'
WHEN price >= 20000 THEN 'Estándar'
ELSE                     'Económico'
END AS rango_precio
FROM suministros_con_actividad
ORDER BY price DESC;

-- ============================================
-- CONSULTA 2: Dos CTEs encadenados
-- Primer CTE: Total de unidades consumidas por categoría de suministro
-- Segundo CTE: Filtra las categorías que superaron el promedio de consumo global
-- ============================================

WITH consumo_por_categoria AS (
SELECT
i.category,
SUM(t.quantity) AS total_unidades_consumidas
FROM supply_items i
INNER JOIN feeding_logs t ON t.item_id = i.id
GROUP BY i.category
),
categorias_top AS (
SELECT category
FROM consumo_por_categoria
WHERE total_unidades_consumidas > (SELECT AVG(total_unidades_consumidas) FROM consumo_por_categoria)
)
SELECT
cc.category                 AS categoria_insumo,
cc.total_unidades_consumidas AS dosis_totales_servidas
FROM consumo_por_categoria cc
WHERE cc.category IN (SELECT category FROM categorias_top)
ORDER BY cc.total_unidades_consumidas DESC;

-- ============================================
-- CONSULTA 3: CTE + COUNT condicional por banda
-- Por cada categoría del acuario, cuenta cuántos productos pertenecen a cada rango de precio
-- ============================================

WITH clasificados AS (
SELECT
name,
category,
price,
CASE
WHEN price >= 50000 THEN 'Premium'
WHEN price >= 20000 THEN 'Estándar'
ELSE                     'Económico'
END AS price_band
FROM supply_items
)
SELECT
category                                                AS categoria_insumo,
COUNT(CASE WHEN price_band = 'Premium'   THEN 1 END)    AS total_premium,
COUNT(CASE WHEN price_band = 'Estándar'  THEN 1 END)    AS total_estandar,
COUNT(CASE WHEN price_band = 'Económico' THEN 1 END)    AS total_economico
FROM clasificados
GROUP BY category
ORDER BY category;