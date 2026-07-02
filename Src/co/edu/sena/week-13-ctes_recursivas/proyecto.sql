DROP TABLE IF EXISTS aquarium_taxonomy CASCADE;

-- ============================================
-- TABLA AUTO-REFERENCIAL: estructura taxonómica de especies
-- Jerarquía: Grupo Base -> Familia/Clado -> Especie/Variedad específica
-- ============================================

CREATE TABLE aquarium_taxonomy (
    id        SERIAL PRIMARY KEY,
    name      TEXT   NOT NULL,
    parent_id INT    REFERENCES aquarium_taxonomy (id)
);

-- ============================================
-- DATOS: 205 filas en 3 niveles
-- Nivel 1: grupos base (parent_id = NULL)
-- Nivel 2: familias/clados (apuntan a un grupo base)
-- Nivel 3: especies específicas (apuntan a una familia)
-- ============================================

INSERT INTO aquarium_taxonomy (id, name, parent_id) VALUES
(1, 'Peces Óseos Marinos', NULL),
(2, 'Peces de Agua Dulce', NULL),
(3, 'Invertebrados de Arrecife', NULL),
(4, 'Flora y Macroalgas', NULL),
(5, 'Microfauna y Sustrato', NULL),
(6, 'Pomacéntridos', 1),
(7, 'Acantúridos', 1),
(8, 'Quetodóntidos', 1),
(9, 'Blénidos', 1),
(10, 'Poecílidos', 2),
(11, 'Cíclidos', 2),
(12, 'Carácidos', 2),
(13, 'Corales LPS', 3),
(14, 'Corales SPS', 3),
(15, 'Crustáceos', 3),
(16, 'Plantas de Tallo', 4),
(17, 'Plantas de Roseta', 4),
(18, 'Macroalgas Marinas', 4),
(19, 'Copépodos', 5),
(20, 'Anfípodos', 5),
(21, 'Bacterias Nitrificantes', 5),
(22, 'Pez Payaso Ocellaris #1', 6),
(23, 'Pez Cirujano Azul #2', 7),
(24, 'Pez Mariposa Auriga #3', 8),
(25, 'Blénido Podador #4', 9),
(26, 'Pez Guppy Cobra #5', 10),
(27, 'Pez Disco Azul #6', 11),
(28, 'Tetra Neón #7', 12),
(29, 'Coral Torch Euphillia #8', 13),
(30, 'Coral Acropora Azul #9', 14),
(31, 'Camarón Limpiador #10', 15),
(32, 'Ambulia Acuática #11', 16),
(33, 'Anubia Barteri #12', 17),
(34, 'Alga Chaetomorpha #13', 18),
(35, 'Tisbe biminiensis #14', 19),
(36, 'Gammarus silvestre #15', 20),
(37, 'Nitrosomonas activas #16', 21),
(38, 'Pez Payaso Negro Express #17', 6),
(39, 'Pez Cirujano Amarillo Express #18', 7),
(40, 'Pez Mariposa de Nariz Larga Express #19', 8),
(41, 'Blénido Bicolor Express #20', 9),
(42, 'Pez Molly Balón Express #21', 10),
(43, 'Pez Ángel Altum Express #22', 11),
(44, 'Tetra Cardenal Express #23', 12),
(45, 'Coral Hammer LPS Express #24', 13),
(46, 'Coral Montipora SPS Express #25', 14),
(47, 'Camarón Pimienta Express #26', 15),
(48, 'Rotala Rotundifolia Express #27', 16),
(49, 'Espada Amazónica Express #28', 17),
(50, 'Caulerpa Prolifera Express #29', 18),
(51, 'Tigriopus californicus Express #30', 19),
(52, 'Anfípodo Rojo Express #31', 20),
(53, 'Nitrobacter cepa Express #32', 21),
(54, 'Pez Payaso Picasso Premium #33', 6),
(55, 'Pez Cirujano Convicto Premium #34', 7),
(56, 'Pez Mariposa de Klein Premium #35', 8),
(57, 'Blénido de Líneas Premium #36', 9),
(58, 'Pez Platty Sangre Premium #37', 10),
(59, 'Pez Cíclido Jaguar Premium #38', 11),
(60, 'Tetra Borrachito Premium #39', 12),
(61, 'Coral Frogspawn Premium #40', 13),
(62, 'Coral Seriatopora Premium #41', 14),
(63, 'Cangrejo Ermitaño Premium #42', 15),
(64, 'Ludwigia Repens Premium #43', 16),
(65, 'Cryptocoryne Wendtii Premium #44', 17),
(66, 'Alga Dragón Rojo Premium #45', 18),
(67, 'Copépodo Bentónico Premium #46', 19),
(68, 'Anfípodo de Arena Premium #47', 20),
(69, 'Consorcio Bio-Spira Premium #48', 21),
(70, 'Damisela Azul Delicado #49', 6),
(71, 'Pez Cirujano de Sombra Delicado #50', 7),
(72, 'Pez Mariposa Enmascarado Delicado #51', 8),
(73, 'Blénido Midas Delicado #52', 9),
(74, 'Pez Guppy Endler Delicado #53', 10),
(75, 'Pez Cíclido Ramirezi Delicado #54', 11),
(76, 'Tetra Emperador Delicado #55', 12),
(77, 'Coral Duncan LPS Delicado #56', 13),
(78, 'Coral Pocillopora SPS Delicado #57', 14),
(79, 'Camarón Boxeador Delicado #58', 15),
(80, 'Helecho de Sumatra Delicado #59', 16),
(81, 'Vallisneria Spiralis Delicado #60', 17),
(82, 'Alga Halimeda Delicado #61', 18),
(83, 'Cyclops Vivo Delicado #62', 19),
(84, 'Anfípodo de Roca Delicado #63', 20),
(85, 'Cepa Desnitrificante Delicado #64', 21),
(86, 'Damisela Dominó Industrial #65', 6),
(87, 'Pez Cirujano Naso Industrial #66', 7),
(88, 'Pez Mariposa Bandas Negras Industrial #67', 8),
(89, 'Blénido de Roca Industrial #68', 9),
(90, 'Pez Molly Negro Industrial #69', 10),
(91, 'Cíclido Oscar Africano Industrial #70', 11),
(92, 'Tetra de Buenos Aires Industrial #71', 12),
(93, 'Coral de Burbujas Industrial #72', 13),
(94, 'Coral Stylophora Industrial #73', 14),
(95, 'Cangrejo Esmeralda Industrial #74', 15),
(96, 'Higrofila Polisperma Industrial #75', 16),
(97, 'Echinodorus Bleheri Industrial #76', 17),
(98, 'Alga Ulva Lactuca Industrial #77', 18),
(99, 'Copépodos de Estanque Industrial #78', 19),
(100, 'Anfípodos de Detrito Industrial #79', 20),
(101, 'Bacterias de Lodo Industrial #80', 21),
(102, 'Pez Payaso Tomate Estacional #81', 6),
(103, 'Pez Cirujano Mimético Estacional #82', 7),
(104, 'Pez Mariposa Cooper Estacional #83', 8),
(105, 'Blénido Colmillo Estacional #84', 9),
(106, 'Pez Guppy Leopardo Estacional #85', 10),
(107, 'Cíclido Convicto Estacional #86', 11),
(108, 'Tetra Negro Estacional #87', 12),
(109, 'Coral Candy Cane Estacional #88', 13),
(110, 'Coral Pavona SPS Estacional #89', 14),
(111, 'Camarón de Cristal Estacional #90', 15),
(112, 'Bacopa Monnieri Estacional #91', 16),
(113, 'Anubia Nana Estacional #92', 17),
(114, 'Alga Gracilaria Estacional #93', 18),
(115, 'Copépodo de Agua Dulce Estacional #94', 19),
(116, 'Anfípodo de Estuario Estacional #95', 20),
(117, 'Bacterias Simbióticas Estacional #96', 21),
(118, 'Pez Payaso Sebae Estandar Plus #97', 6),
(119, 'Pez Cirujano de Yates Estandar Plus #98', 7),
(120, 'Pez Mariposa Vagabundo Estandar Plus #99', 8),
(121, 'Blénido Leopardo Estandar Plus #100', 9),
(122, 'Pez Xipho Cola de Espada Estandar Plus #101', 10),
(123, 'Cíclido Terror Verde Estandar Plus #102', 11),
(124, 'Tetra Ojo de Rojo Estandar Plus #103', 12),
(125, 'Coral Galaxea LPS Estandar Plus #104', 13),
(126, 'Coral Millepora SPS Estandar Plus #105', 14),
(127, 'Camarón Fantasma Marítimo Estandar Plus #106', 15),
(128, 'Limnophila Sessiliflora Estandar Plus #107', 16),
(129, 'Cryptocoryne Parva Estandar Plus #108', 17),
(130, 'Alga Kelp Decorativa Estandar Plus #109', 18),
(131, 'Copépodo Pelágico Estandar Plus #110', 19),
(132, 'Anfípodo Tubícola Estandar Plus #111', 20),
(133, 'Enzimas Depuradoras Estandar Plus #112', 21),
(134, 'Damisela Cola Amarilla Economico #113', 6),
(135, 'Pez Cirujano Marrón Economico #114', 7),
(136, 'Pez Mariposa de Hilo Economico #115', 8),
(137, 'Blénido Lineal Gris Economico #116', 9),
(138, 'Pez Guppy Común Economico #117', 10),
(139, 'Cíclido Cebra Común Economico #118', 11),
(140, 'Tetra Rayado Economico #119', 12),
(141, 'Coral Calice LPS Economico #120', 13),
(142, 'Coral de Pólipo Corto Salvaje Economico #121', 14),
(143, 'Cangrejo Violinista Economico #122', 15),
(144, 'Elodea Densa Economico #123', 16),
(145, 'Sagitaria Subulata Economico #124', 17),
(146, 'Alga Caulerpa Taxifolia Economico #125', 18),
(147, 'Micro-fauna Mixta Economico #126', 19),
(148, 'Pulga de Agua Base Economico #127', 20),
(149, 'Cepa Estándar de Ciclado Economico #128', 21),
(150, 'Pez Payaso Mocha Rapido #129', 6),
(151, 'Pez Cirujano de Escopas Rapido #130', 7),
(152, 'Pez Mariposa Pirámide Rapido #131', 8),
(153, 'Blénido de Bandas Rapido #132', 9),
(154, 'Pez Molly Plata Rapido #133', 10),
(155, 'Cíclido Joya Africano Rapido #134', 11),
(156, 'Tetra Luminoso Rapido #135', 12),
(157, 'Coral Acanthastrea Rapido #136', 13),
(158, 'Coral Leptoseris Rapido #137', 14),
(159, 'Camarón de Plaga Aiptasia Rapido #138', 15),
(160, 'Egeria Najas Rapido #139', 16),
(161, 'Anubia Heterophylla Rapido #140', 17),
(162, 'Alga de Hilo de Seda Rapido #141', 18),
(163, 'Copépodo Arpacticoida Rapido #142', 19),
(164, 'Anfípodo Gammarideo Rapido #143', 20),
(165, 'Bacterias Heterótrofas Rapido #144', 21),
(166, 'Pez Payaso de Crianza Completo #145', 6),
(167, 'Pez Cirujano de Aquiles Completo #146', 7),
(168, 'Pez Mariposa de Cobre Completo #147', 8),
(169, 'Blénido de Puntos Azules Completo #148', 9),
(170, 'Pez Guppy de Velo Completo #149', 10),
(171, 'Cíclido Escalar Fantasma Completo #150', 11),
(172, 'Tetra Pingüino Completo #151', 12),
(173, 'Coral Blastomussa Completo #152', 13),
(174, 'Coral Turbinaria Completo #153', 14),
(175, 'Camarón Arlequín Completo #154', 15),
(176, 'Ceratophyllum Demersum Completo #155', 16),
(177, 'Anubia Congensis Completo #156', 17),
(178, 'Alga Ochtodes Violeta Completo #157', 18),
(179, 'Copépodo Calanoida Completo #158', 19),
(180, 'Anfípodo Marino Gigante Completo #159', 20),
(181, 'Inóculo de Filtro Biológico Completo #160', 21),
(182, 'Damisela de Bandas Nocturno #161', 6),
(183, 'Pez Cirujano Cebra Nocturno #162', 7),
(184, 'Pez Mariposa de Silla Nocturno #163', 8),
(185, 'Blénido Vampiro Nocturno #164', 9),
(186, 'Pez Molly Negro Lira Nocturno #165', 10),
(187, 'Cíclido Loro Esmeralda Nocturno #166', 11),
(188, 'Tetra Fantasma Negro Nocturno #167', 12),
(189, 'Coral Lobophyllia Nocturno #168', 13),
(190, 'Coral Merulina Nocturno #169', 14),
(191, 'Camarón de Cueva Nocturno #170', 15),
(192, 'Musgo de Java Nocturno #171', 16),
(193, 'Cryptocoryne Balansae Nocturno #172', 17),
(194, 'Alga Penicillus Nocturno #173', 18),
(195, 'Copépodos de Arena Nocturno #174', 19),
(196, 'Anfípodos Abisales Nocturno #175', 20),
(197, 'Bacterias Anaerobias Nocturno #176', 21),
(198, 'Pez Payaso Clarkii Fin de Semana #177', 6),
(199, 'Pez Cirujano de Collar Fin de Semana #178', 7),
(200, 'Pez Mariposa Ocho Bandas Fin de Semana #179', 8),
(201, 'Blénido de Cola Roja Fin de Semana #180', 9),
(202, 'Pez Guppy de Fuego Fin de Semana #181', 10),
(203, 'Cíclido Kribensis Fin de Semana #182', 11),
(204, 'Tetra Diamante Fin de Semana #183', 12),
(205, 'Coral Goniopora Fin de Semana #184', 13);


-- ============================================
-- CONSULTA 1: Árbol completo taxonómico con depth y path
-- Caso base: grupos base primarios (parent_id IS NULL).
-- Caso recursivo: cada subgrupo taxonómico se une jerárquicamente con su ancestro,
-- incrementando la profundidad (depth) y concatenando la traza biológica (path).
-- ============================================

WITH RECURSIVE arbol_taxonomico AS (
    -- Caso base: Nodos raíz taxonómicos
    SELECT
        id,
        name,
        parent_id,
        1        AS depth,
        name     AS path
    FROM aquarium_taxonomy
    WHERE parent_id IS NULL

    UNION ALL

    -- Caso recursivo: Clados e incrustaciones de especies descendientes
    SELECT
        n.id,
        n.name,
        n.parent_id,
        a.depth + 1,
        a.path || ' > ' || n.name
    FROM aquarium_taxonomy n
    INNER JOIN arbol_taxonomico a ON n.parent_id = a.id
)
SELECT
    depth,
    REPEAT('  ', depth - 1) || name AS nombre_identado,
    path                             AS linea_biologica
FROM arbol_taxonomico
ORDER BY path;


-- ============================================
-- CONSULTA 2: Nodos de un nivel taxonómico específico
-- Reutiliza la CTE recursiva para aislar de forma exacta el nivel de profundidad 2,
-- es decir, las familias o clados biológicos intermedios del acuario.
-- ============================================

WITH RECURSIVE arbol_taxonomico AS (
    SELECT id, name, parent_id, 1 AS depth, name AS path
    FROM aquarium_taxonomy
    WHERE parent_id IS NULL
    UNION ALL
    SELECT n.id, n.name, n.parent_id, a.depth + 1, a.path || ' > ' || n.name
    FROM aquarium_taxonomy n
    INNER JOIN arbol_taxonomico a ON n.parent_id = a.id
)
SELECT 
    name AS familia_o_clado, 
    depth, 
    path AS linaje_completo
FROM arbol_taxonomico
WHERE depth = 2
ORDER BY path;


-- ============================================
-- CONSULTA 3: Hojas del árbol (especies/variedades finales sin descendencia)
-- Un elemento es hoja si ningún otro registro hereda de su id como parent_id.
-- Devuelve el catálogo definitivo de organismos específicos que pueblan los tanques.
-- ============================================

SELECT
    n.id,
    n.name AS organismo_especifico
FROM aquarium_taxonomy n
WHERE NOT EXISTS (
    SELECT 1
    FROM aquarium_taxonomy child
    WHERE child.parent_id = n.id
)
ORDER BY n.name;