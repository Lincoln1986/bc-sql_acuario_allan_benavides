PRAGMA foreign_keys = ON;

-- ============================================
-- LIMPIEZA
-- ============================================

DROP TABLE IF EXISTS categorias_especies;

-- ============================================
-- TABLA CON AUTO-REFERENCIA: categorías de especies
-- Jerarquía: gran grupo → familia/orden → especie/variedad
-- Ejemplo: Peces Óseos → Pomacéntridos (Payasos) → Pez Payaso Ocellaris
-- ============================================

CREATE TABLE categorias_especies (
    id          INTEGER PRIMARY KEY,
    nombre      TEXT    NOT NULL UNIQUE,
    descripcion TEXT,
    parent_id   INTEGER REFERENCES categorias_especies (id)
);

-- ============================================
-- DATOS: 3 niveles jerárquicos
-- Nivel 0 (raíz)   → parent_id = NULL  (grandes grupos taxonómicos)
-- Nivel 1 (hijos)  → apuntan a una raíz (familias o tipos biológicos)
-- Nivel 2 (nietos) → apuntan a un nivel 1 (especies o subtipos específicos)
-- ============================================

-- Nivel 0: raíces (sin padre)
INSERT INTO categorias_especies (id, nombre, descripcion, parent_id) VALUES
(1,  'Peces Óseos Marinos',    'Peces con esqueleto óseo del ecosistema salado', NULL),
(2,  'Peces de Agua Dulce',    'Peces adaptados a ríos, lagos y estanques',      NULL),
(3,  'Invertebrados e Infauna','Corales, moluscos y crustáceos del acuario',     NULL);

-- Nivel 1: hijos de las raíces (Familias o categorías biológicas)
INSERT INTO categorias_especies (id, nombre, descripcion, parent_id) VALUES
(4,  'Pomacéntridos',          'Peces damisela y peces payaso',                  1),
(5,  'Acantúridos',            'Peces cirujano con espinas escapulares',         1),
(6,  'Quetodóntidos',          'Peces mariposa de arrecife',                     1),
(7,  'Poecílidos',             'Peces vivíparos pequeños de agua dulce',         2),
(8,  'Cíclidos',               'Peces territoriales, gran variedad amazónica',   2),
(9,  'Corales LPS',            'Corales duros de pólipo largo',                  3),
(10, 'Cnidarios Sésiles',      'Anémonas y actinias de sustrato',                3),
(11, 'Crustáceos Decápodos',   'Camarones, cangrejos y limpiadores',             3);

-- Nivel 2: nietos (Especies o variedades específicas que heredan de las familias)
INSERT INTO categorias_especies (id, nombre, descripcion, parent_id) VALUES
(12, 'Pez Payaso Ocellaris',    'Variedad clásica naranja y blanca',             4),
(13, 'Pez Payaso Negro',        'Variedad melánica de arrecife',                 4),
(14, 'Damisela Azul',           'Pez pequeño de alta agresividad',               4),
(15, 'Pez Cirujano Azul',       'Especie Paracanthurus hepatus',                 5),
(16, 'Pez Cirujano Amarillo',   'Especie Zebrasoma flavescens',                  5),
(17, 'Pez Mariposa Auriga',     'Pez mariposa de líneas diagonales',             6),
(18, 'Pez Mariposa de Nariz Larga', 'Especie especializada en microfauna',       6),
(19, 'Pez Guppy Variedad Cobra','Línea de cría con patrón atigrado',             7),
(20, 'Pez Molly Balón',         'Variedad morfológica de agua dulce',            7),
(21, 'Pez Disco Azul',          'Cíclido amazónico de cuerpo discoidal',         8),
(22, 'Pez Ángel Altum',         'Cíclido alto de aguas negras',                  8),
(23, 'Coral Euphillia Torch',   'Coral con pólipos móviles ondulantes',          9),
(24, 'Coral Hammer',            'Coral duro con puntas en forma de martillo',    9),
(25, 'Anémona Burbuja',         'Anémona hospedadora para peces payaso',         10),
(26, 'Anémona Alfombra',        'Especie sésil de gran tamaño en sustrato',      10),
(27, 'Camarón Limpiador',       'Lysmata amboinensis, desparasitador',           11),
(28, 'Cangrejo Ermitaño',       'Crustáceo detritívoro para control de algas',   11);


-- ============================================
-- CONSULTA 1: SELF JOIN básico (INNER JOIN)
-- Muestra cada especie/familia junto con su categoría padre biológica.
-- Se excluyen las raíces porque son los filos principales.
-- ============================================

SELECT
    hijo.nombre     AS taxonomia,
    padre.nombre    AS taxonomia_padre
FROM categorias_especies hijo
INNER JOIN categorias_especies padre ON hijo.parent_id = padre.id
ORDER BY padre.nombre, hijo.nombre;


-- ============================================
-- CONSULTA 2: Incluir la raíz con LEFT JOIN + COALESCE
-- Muestra todo el árbol taxonómico incluyendo los grupos raíz.
-- COALESCE reemplaza NULL por la etiqueta 'Filo/Grupo Base'.
-- ============================================

SELECT
    hijo.nombre                             AS taxonomia,
    COALESCE(padre.nombre, 'Grupo Base')    AS taxonomia_padre
FROM categorias_especies hijo
LEFT JOIN categorias_especies padre ON hijo.parent_id = padre.id
ORDER BY taxonomia_padre, hijo.nombre;


-- ============================================
-- CONSULTA 3: Contar hijos directos por padre
-- Cuántas subcategorías o especies tiene asignada cada familia/grupo.
-- Solo muestra las categorías que tienen ramas descendientes (HAVING).
-- ============================================

SELECT
    padre.nombre        AS taxonomia_padre,
    COUNT(hijo.id)      AS total_subelementos
FROM categorias_especies padre
LEFT JOIN categorias_especies hijo ON hijo.parent_id = padre.id
GROUP BY padre.id, padre.nombre
HAVING COUNT(hijo.id) > 0
ORDER BY total_subelementos DESC;


-- ============================================
-- CONSULTA 4: Dos niveles jerárquicos (Especie → Familia → Gran Grupo)
-- Encadena tres aliases para navegar la taxonomía completa del acuario.
-- ============================================

SELECT
    hijo.nombre         AS especie_o_variedad,
    padre.nombre        AS familia_o_orden,
    abuelo.nombre       AS gran_grupo_biologico
FROM categorias_especies hijo
LEFT JOIN categorias_especies padre   ON hijo.parent_id  = padre.id
LEFT JOIN categorias_especies abuelo  ON padre.parent_id = abuelo.id
ORDER BY abuelo.nombre, padre.nombre, hijo.nombre;