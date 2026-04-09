DROP DATABASE IF EXISTS milpa_alta_agricola;
CREATE DATABASE milpa_alta_agricola;
USE milpa_alta_agricola;

-- =========================
-- CULTIVOS
-- =========================
CREATE TABLE cultivos (
    id_cultivo INT AUTO_INCREMENT PRIMARY KEY,
    nombre_comun VARCHAR(80) NOT NULL,
    nombre_cientifico VARCHAR(120),
    tipo_cultivo ENUM('ANUAL','PERMANENTE') NOT NULL,
    ciclo_produccion VARCHAR(40),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO cultivos (nombre_comun, nombre_cientifico, tipo_cultivo, ciclo_produccion) VALUES
('Maíz criollo','Zea mays','ANUAL','PV'),
('Nopal verdura','Opuntia ficus-indica','PERMANENTE','ANUAL'),
('Ajo','Allium sativum','ANUAL','OI'),
('Pitahaya','Hylocereus undatus','PERMANENTE','ANUAL');

-- =========================
-- CICLOS
-- =========================
CREATE TABLE ciclos_agricolas (
    id_ciclo INT AUTO_INCREMENT PRIMARY KEY,
    anio SMALLINT NOT NULL,
    ciclo ENUM('PV','OI','ANUAL') NOT NULL,
    descripcion VARCHAR(120)
);

INSERT INTO ciclos_agricolas (id_ciclo,anio,ciclo,descripcion) VALUES
(1,2024,'PV','Primavera-Verano'),
(2,2024,'OI','Otoño-Invierno'),
(3,2024,'ANUAL','Ciclo completo');

-- =========================
-- CATEGORIAS
-- =========================
CREATE TABLE categorias_costo (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(10),
    nombre VARCHAR(80),
    tipo ENUM('DIR','IND'),
    id_padre INT NULL,
    FOREIGN KEY (id_padre) REFERENCES categorias_costo(id_categoria)
);

INSERT INTO categorias_costo (id_categoria,codigo,nombre,tipo,id_padre) VALUES
(1,'PREP','Preparación del terreno','DIR',NULL),
(2,'SIEM','Siembra','DIR',NULL),
(3,'INS','Insumos','DIR',NULL),
(4,'MANO','Mano de obra','DIR',NULL),
(5,'COSE','Cosecha','DIR',NULL),
(6,'INF','Infraestructura','DIR',NULL);

-- =========================
-- COSTOS
-- =========================
CREATE TABLE costos_produccion (
    id_costo INT AUTO_INCREMENT PRIMARY KEY,
    id_cultivo INT,
    id_ciclo INT,
    id_categoria INT,
    concepto VARCHAR(120),
    unidad VARCHAR(20),
    cantidad DECIMAL(10,2),
    precio_unitario DECIMAL(12,2),
    valor_total DECIMAL(14,2) GENERATED ALWAYS AS (cantidad * precio_unitario) STORED,

    FOREIGN KEY (id_cultivo) REFERENCES cultivos(id_cultivo),
    FOREIGN KEY (id_ciclo) REFERENCES ciclos_agricolas(id_ciclo),
    FOREIGN KEY (id_categoria) REFERENCES categorias_costo(id_categoria)
);

-- =========================
-- INSERTS CORREGIDOS (SIN valor_total)
-- =========================

-- MAÍZ
INSERT INTO costos_produccion
(id_cultivo,id_ciclo,id_categoria,concepto,unidad,cantidad,precio_unitario)
VALUES
(1,1,1,'Barbecho','Servicio',1,1500),
(1,1,1,'Rastreo','Servicio',1,1200),
(1,1,2,'Siembra manual','Jornal',10,250),
(1,1,3,'Semilla criolla','Kg',25,60),
(1,1,3,'Fertilizante','Kg',200,12),
(1,1,3,'Herbicida','Litro',5,180),
(1,1,4,'Deshierbe','Jornal',12,250),
(1,1,4,'Riego','Jornal',8,250),
(1,1,5,'Cosecha','Jornal',10,250);

-- NOPAL
INSERT INTO costos_produccion
(id_cultivo,id_ciclo,id_categoria,concepto,unidad,cantidad,precio_unitario)
VALUES
(2,3,1,'Limpieza del terreno','Jornal',8,250),
(2,3,1,'Preparación suelo','Servicio',1,1800),
(2,3,6,'Plantación de pencas','Unidad',500,5),
(2,3,3,'Abono orgánico','Ton',2,1500),
(2,3,4,'Mano de obra instalación','Jornal',10,250);

-- AJO
INSERT INTO costos_produccion
(id_cultivo,id_ciclo,id_categoria,concepto,unidad,cantidad,precio_unitario)
VALUES
(3,2,1,'Barbecho','Servicio',1,1500),
(3,2,2,'Siembra manual','Jornal',12,250),
(3,2,3,'Semilla de ajo','Kg',800,35),
(3,2,3,'Fertilizante','Kg',250,12),
(3,2,4,'Deshierbe','Jornal',15,250),
(3,2,5,'Cosecha','Jornal',12,250);

-- PITAHAYA
INSERT INTO costos_produccion
(id_cultivo,id_ciclo,id_categoria,concepto,unidad,cantidad,precio_unitario)
VALUES
(4,3,1,'Preparación terreno','Jornal',10,250),
(4,3,6,'Postes soporte','Unidad',400,120),
(4,3,6,'Alambre','Metro',1000,15),
(4,3,3,'Fertilizante','Kg',200,12),
(4,3,4,'Instalación','Jornal',15,250);

-- =========================
-- RESUMEN ECONÓMICO
-- =========================
CREATE TABLE resumen_economico (
    id_resumen INT AUTO_INCREMENT PRIMARY KEY,
    id_cultivo INT,
    id_ciclo INT,
    rendimiento_ton_ha DECIMAL(8,2),
    precio_productor DECIMAL(12,2),
    ingreso_bruto DECIMAL(14,2) GENERATED ALWAYS AS (rendimiento_ton_ha * precio_productor) STORED,
    costo_total DECIMAL(14,2),
    utilidad_neta DECIMAL(14,2) GENERATED ALWAYS AS (ingreso_bruto - costo_total) STORED,

    FOREIGN KEY (id_cultivo) REFERENCES cultivos(id_cultivo),
    FOREIGN KEY (id_ciclo) REFERENCES ciclos_agricolas(id_ciclo)
);

INSERT INTO resumen_economico
(id_cultivo,id_ciclo,rendimiento_ton_ha,precio_productor,costo_total)
VALUES
(1,1,3.5,6000,15000),
(2,3,10,4000,18000),
(3,2,5,8000,22000),
(4,3,8,9000,35000);