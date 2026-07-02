-- ============================================
-- REPORTE 1: Totales globales
-- ============================================
-- Cuenta todas las especies registradas y calcula el costo total
-- estimado de alimentación y el costo promedio por especie.

SELECT
    COUNT(*)            AS total_especies,
    SUM(fe.daily_cost)  AS costo_alimentacion_total,
    AVG(fe.daily_cost)  AS costo_alimentacion_promedio
FROM species s
JOIN fish f        ON f.species_id = s.id
JOIN feedings fe   ON fe.species_type = f.species_type;


-- ============================================
-- REPORTE 2: Extremos
-- ============================================
-- Costo diario de alimentación mínimo y máximo registrado en la tabla feedings

SELECT
    MIN(daily_cost) AS costo_alimentacion_minimo,
    MAX(daily_cost) AS costo_alimentacion_maximo
FROM feedings;


-- ============================================
-- REPORTE 3: Subtotales por categoría (GROUP BY)
-- ============================================
-- Peces agrupados por su tipo de especie: cuántos ejemplares hay 
-- y cuánto cuesta en promedio mantener su alimentación diaria

SELECT
    f.species_type          AS tipo_especie,
    COUNT(*)                AS total_peces,
    AVG(fe.daily_cost)      AS costo_alimentacion_promedio
FROM fish f
JOIN feedings fe ON fe.species_type = f.species_type
GROUP BY f.species_type
ORDER BY total_peces DESC;


-- ============================================
-- REPORTE 4: Filtro de grupos (HAVING)
-- ============================================
-- Tanques que albergan más de 3 especies diferentes registradas
-- (Tanques de alta biodiversidad / comunitarios)

SELECT
    t.name              AS nombre_tanque,
    COUNT(s.id)         AS total_especies
FROM tanks t
JOIN species s ON s.tank_id = t.id
GROUP BY t.name
HAVING COUNT(s.id) > 3
ORDER BY total_especies DESC;