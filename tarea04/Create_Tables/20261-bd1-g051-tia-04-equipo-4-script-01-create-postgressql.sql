CREATE TABLE public.usuario (
    id_usuario SERIAL NOT NULL PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL
);


CREATE TABLE public.rol (
    id_rol SERIAL NOT NULL PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE public.producto (
    id_producto SERIAL NOT NULL PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    precio NUMERIC(10,2) NOT NULL CHECK (precio >= 0)
);

CREATE TABLE public.productor (
    id_productor SERIAL NOT NULL PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL
);


CREATE TABLE public.ubicacion (
    id_ubicacion SERIAL NOT NULL PRIMARY KEY,
    descripcion TEXT,
    latitud NUMERIC(9,6),
    longitud NUMERIC(9,6)
);

CREATE TABLE public.entidad_apoyo (
    id_entidad SERIAL NOT NULL PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL
);



CREATE TABLE public.pedido (
    id_pedido SERIAL NOT NULL PRIMARY KEY,
    id_usuario INT NOT NULL REFERENCES public.usuario(id_usuario),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.pago (
    id_pago SERIAL NOT NULL PRIMARY KEY,
    id_pedido INT NOT NULL REFERENCES public.pedido(id_pedido),
    monto NUMERIC(10,2) NOT NULL CHECK (monto >= 0),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.apiario (
    id_apiario SERIAL NOT NULL PRIMARY KEY,
    id_ubicacion INT NOT NULL REFERENCES public.ubicacion(id_ubicacion)
);

CREATE TABLE public.colmena (
    id_colmena SERIAL NOT NULL PRIMARY KEY,
    id_apiario INT NOT NULL REFERENCES public.apiario(id_apiario),
    estado VARCHAR(15) CHECK (estado IN ('activa','inactiva','mantenimiento'))
);

CREATE TABLE public.inspeccion (
    id_inspeccion SERIAL NOT NULL PRIMARY KEY,
    id_usuario INT NOT NULL REFERENCES public.usuario(id_usuario),
    id_colmena INT NOT NULL REFERENCES public.colmena(id_colmena),
    fecha DATE NOT NULL,
    resultado VARCHAR(20)
);

CREATE TABLE public.certificacion (
    id_certificacion SERIAL NOT NULL PRIMARY KEY,
    id_inspeccion INT NOT NULL REFERENCES public.inspeccion(id_inspeccion),
    tipo VARCHAR(20)
);

CREATE TABLE public.sensor (
    id_sensor SERIAL NOT NULL PRIMARY KEY,
    id_colmena INT NOT NULL REFERENCES public.colmena(id_colmena),
    tipo VARCHAR(25),
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE public.registro_ambiental (
    id_registro SERIAL NOT NULL PRIMARY KEY,
    id_sensor INT NOT NULL REFERENCES public.sensor(id_sensor),
    temperatura NUMERIC(5,2),
    humedad NUMERIC(5,2),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.evento (
    id_evento SERIAL NOT NULL PRIMARY KEY,
    id_usuario INT NOT NULL REFERENCES public.usuario(id_usuario),
    tipo VARCHAR(20),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.credito (
    id_credito SERIAL NOT NULL PRIMARY KEY,
    id_entidad INT NOT NULL REFERENCES public.entidad_apoyo(id_entidad),
    monto NUMERIC(12,2) CHECK (monto >= 0)
);

CREATE TABLE public.detalle_pedido (
    id_detalle SERIAL NOT NULL PRIMARY KEY,
    id_pedido INT NOT NULL REFERENCES public.pedido(id_pedido),
    id_producto INT NOT NULL REFERENCES public.producto(id_producto),
    cantidad INT NOT NULL CHECK (cantidad > 0)
);


CREATE TABLE public.usuario_rol (
    id_usuario INT REFERENCES public.usuario(id_usuario),
    id_rol INT REFERENCES public.rol(id_rol),
    PRIMARY KEY (id_usuario, id_rol)
);

CREATE TABLE public.productor_producto (
    id_productor INT REFERENCES public.productor(id_productor),
    id_producto INT REFERENCES public.producto(id_producto),
    PRIMARY KEY (id_productor, id_producto)
);

CREATE TABLE public.sensor_evento (
    id_sensor INT REFERENCES public.sensor(id_sensor),
    id_evento INT REFERENCES public.evento(id_evento),
    PRIMARY KEY (id_sensor, id_evento)
);



ALTER TABLE productor
ADD COLUMN telefono VARCHAR(20);

ALTER TABLE productor
ALTER COLUMN telefono TYPE VARCHAR(25);


CREATE TABLE control_produccion (
    id_control SERIAL PRIMARY KEY,
    descripcion TEXT,
    cantidad INTEGER,
    estado VARCHAR(15)
);

ALTER TABLE control_produccion
DROP COLUMN estado;

ALTER TABLE control_produccion
RENAME TO gestion_produccion;

ALTER TABLE gestion_produccion
ADD CONSTRAINT unique_descripcion UNIQUE (descripcion);

ALTER TABLE gestion_produccion
ADD COLUMN fecha_inicio DATE,
ADD COLUMN fecha_fin DATE;

ALTER TABLE gestion_produccion
ADD CONSTRAINT check_fechas CHECK (fecha_fin >= fecha_inicio);

ALTER TABLE gestion_produccion
ADD COLUMN stock INTEGER;

ALTER TABLE gestion_produccion
ADD CONSTRAINT check_stock CHECK (stock >= 0);

ALTER TABLE gestion_produccion
ALTER COLUMN descripcion TYPE VARCHAR(200);  

ALTER TABLE gestion_produccion
ADD CONSTRAINT check_cantidad CHECK (cantidad BETWEEN 1 AND 1000);

CREATE INDEX idx_descripcion
ON gestion_produccion (descripcion);

ALTER TABLE gestion_produccion
DROP COLUMN fecha_fin;



TRUNCATE TABLE gestion_produccion;


ALTER TABLE gestion_produccion
ADD COLUMN datos_ambientales JSONB;

INSERT INTO gestion_produccion (descripcion, cantidad, stock, fecha_inicio, datos_ambientales)
VALUES 
(
    	'Produccion 1',
    	50,
    	20,
    	'2026-03-20',
   	 '{
        "temperatura": 28.5,
        "humedad": 70,
        "estado": "estable"
    }'
),
(
    	'Produccion 2',
    	80,
    	30,
    	'2026-03-21',
    	'{
        "temperatura": 30,
        "humedad": 65,
        "estado": "alerta"
    }'
);

SELECT 
    	descripcion,
   	 	datos_ambientales->>'temperatura' AS temperatura
FROM 	gestion_produccion;

ALTER TABLE productor
ADD COLUMN info_extra JSONB;


UPDATE productor
SET info_extra = '{
    "certificado": true
}';

SELECT *
FROM productor
WHERE info_extra @> '{"certificado": true}';


