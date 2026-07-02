-- ============================================
-- TODO 1: Eliminar duplicados con ROW_NUMBER()
-- ============================================
-- Filtra los ítems quedándose únicamente con el primer registro 
-- insertado (`id` más bajo) para cada nombre duplicado.
-- ============================================

WITH items_numerados AS (
    SELECT
        id,
        name,
        value,
        category_id,
        ROW_NUMBER() OVER (PARTITION BY name ORDER BY id ASC) AS rn
    FROM items
)
SELECT
    id,
    name,
    value,
    category_id
FROM items_numerados
WHERE rn = 1
ORDER BY id;


-- ============================================
-- TODO 2: RANK y DENSE_RANK por categoría
-- ============================================
-- Clasifica cada ítem por su precio (`value`) en orden descendente.
-- Permite contrastar cómo RANK() genera saltos en la numeración 
-- ante empates, mientras que DENSE_RANK() mantiene la secuencia.
-- ============================================

SELECT
    name,
    value,
    category_id,
    RANK()       OVER (PARTITION BY category_id ORDER BY value DESC) AS rnk,
    DENSE_RANK() OVER (PARTITION BY category_id ORDER BY value DESC) AS dense_rnk
FROM items
ORDER BY category_id, dense_rnk, name;


-- ============================================
-- TODO 3: Top-2 por categoría con CTE
-- ============================================
-- Recupera los ítems que poseen los dos precios más altos por categoría.
-- Al utilizar DENSE_RANK, se garantiza que si existen múltiples artículos 
-- empatados en el primer o segundo precio más alto, se incluyan todos.
-- ============================================

WITH ranking_categoria AS (
    SELECT
        name,
        value,
        category_id,
        DENSE_RANK() OVER (PARTITION BY category_id ORDER BY value DESC) AS dense_rnk
    FROM items
)
SELECT
    name,
    value,
    category_id,
    dense_rnk
FROM ranking_categoria
WHERE dense_rnk <= 2
ORDER BY category_id, dense_rnk, value DESC;