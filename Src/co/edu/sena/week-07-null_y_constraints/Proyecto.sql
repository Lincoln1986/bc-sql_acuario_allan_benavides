PRAGMA foreign_keys = ON;

-- ============================================
-- PARTE 1: ESQUEMA CON CONSTRAINTS
-- ============================================

-- Tabla de tipos de agua o ecosistema del tanque (Agua dulce, marina, etc.)
CREATE TABLE tank_types (
    id   INTEGER PRIMARY KEY,
    name TEXT    NOT NULL UNIQUE
);

-- Tabla de costos de alimentación por tipo de especie y tipo de agua requerido
CREATE TABLE feedings (
    id              INTEGER PRIMARY KEY,
    species_type    TEXT    NOT NULL,
    tank_type_id    INTEGER NOT NULL
        REFERENCES tank_types(id) ON DELETE RESTRICT,
    daily_cost      REAL    NOT NULL CHECK (daily_cost > 0),
    UNIQUE (species_type, tank_type_id)
);

-- Tabla de tanques/acuarios físicos
CREATE TABLE tanks (
    id       INTEGER PRIMARY KEY,
    name     TEXT    NOT NULL,
    location TEXT    UNIQUE          -- Ubicación física, puede ser NULL si no se asigna sala
);

-- Tabla principal de especies
CREATE TABLE species (
    id          INTEGER PRIMARY KEY,
    tank_id     INTEGER NOT NULL
        REFERENCES tanks(id) ON DELETE RESTRICT,
    created_at  TEXT    NOT NULL DEFAULT (date('now')),
    health_status TEXT  NOT NULL DEFAULT 'saludable'
                        CHECK (health_status IN ('saludable','cuarentena','en_tratamiento'))
);

-- Tabla de peces (ejemplares individuales) por especie
CREATE TABLE fish (
    id              INTEGER PRIMARY KEY,
    species_id      INTEGER NOT NULL
        REFERENCES species(id) ON DELETE RESTRICT,
    species_type    TEXT    NOT NULL,
    gender          TEXT,           -- opcional: puede ser NULL (indeterminado)
    health_notes    TEXT            -- observaciones médicas u opcionales
);


-- ============================================
-- PARTE 2: DATOS DE PRUEBA
-- ============================================

INSERT INTO tank_types (id, name) VALUES
    (1, 'Agua Dulce'),
    (2, 'Agua Salada'),
    (3, 'Agua Salobre');

INSERT INTO feedings (id, species_type, tank_type_id, daily_cost) VALUES
    (1, 'Pez Payaso', 2, 5000),
    (2, 'Pez Cirujano', 2, 7000),
    (3, 'Pez Guppy',   1, 3000),
    (4, 'Pez Globo',   3, 15000),
    (5, 'Pez Disco',   1, 12000),
    (6, 'Pez Molly',   1, 4000);

INSERT INTO tanks (id, name, location) VALUES
    (1, 'Tanque Arrecife Central', 'Sala Principal Norte'),
    (2, 'Acuario Amazónico',       NULL),                  -- sin ubicación registrada aún
    (3, 'Estuario Costero',        'Pasillo Central Sur');

INSERT INTO species (id, tank_id, health_status) VALUES
    (1, 1, 'en_tratamiento'),
    (2, 2, 'cuarentena'),
    (3, 3, 'saludable');

INSERT INTO fish (id, species_id, species_type, gender, health_notes) VALUES
    (1, 1, 'Pez Payaso',   'Macho',  'Aleta dorsal ligeramente lastimada'),
    (2, 1, 'Pez Cirujano', 'Hembra', NULL),                -- sin observaciones médicas
    (3, 2, 'Pez Globo',    NULL,     NULL),                -- género y notas NULL
    (4, 2, 'Pez Disco',    'Macho',  'Tratamiento preventivo contra parásitos'),
    (5, 3, 'Pez Molly',    NULL,     'Monitorear nado'),   -- género NULL
    (6, 3, 'Pez Guppy',    'Hembra', NULL);                -- sin observaciones


-- ============================================
-- PARTE 3: CONSULTAS CON NULL
-- ============================================

-- Peces sin género determinado (gender IS NULL)
SELECT id, species_type
FROM   fish
WHERE  gender IS NULL;

-- Todos los peces mostrando el género y notas médicas con COALESCE
SELECT
    species_type,
    COALESCE(gender, 'Indeterminado')   AS genero_display,
    COALESCE(health_notes, 'Sin notas') AS notas_medicas_display
FROM fish;

-- Tanques que no tienen una ubicación física asignada en el sistema
SELECT id, name
FROM   tanks
WHERE  location IS NULL;