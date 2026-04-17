
CREATE TABLE public.usuario (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL
);


CREATE TABLE public.rol (
    id_rol SERIAL PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE public.producto (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    precio NUMERIC(10,2) NOT NULL CHECK (precio >= 0)
);

CREATE TABLE public.productor (
    id_productor SERIAL PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL
);

CREATE TABLE public.ubicacion (
    id_ubicacion SERIAL PRIMARY KEY,
    descripcion TEXT,
    latitud NUMERIC(9,6),
    longitud NUMERIC(9,6)
);

CREATE TABLE public.entidad_apoyo (
    id_entidad SERIAL PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL
);


---Entidades dependientes--
CREATE TABLE public.pedido (
    id_pedido SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL REFERENCES public.usuario(id_usuario),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.pago (
    id_pago SERIAL PRIMARY KEY,
    id_pedido INT NOT NULL REFERENCES public.pedido(id_pedido),
    monto NUMERIC(10,2) NOT NULL CHECK (monto >= 0),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.apiario (
    id_apiario SERIAL PRIMARY KEY,
    id_ubicacion INT NOT NULL REFERENCES public.ubicacion(id_ubicacion)
);

CREATE TABLE public.colmena (
    id_colmena SERIAL PRIMARY KEY,
    id_apiario INT NOT NULL REFERENCES public.apiario(id_apiario),
    estado VARCHAR(15) CHECK (estado IN ('activa','inactiva','mantenimiento'))
);

CREATE TABLE public.inspeccion (
    id_inspeccion SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL REFERENCES public.usuario(id_usuario),
    id_colmena INT NOT NULL REFERENCES public.colmena(id_colmena),
    fecha DATE NOT NULL,
    resultado VARCHAR(20)
);

CREATE TABLE public.certificacion (
    id_certificacion SERIAL PRIMARY KEY,
    id_inspeccion INT NOT NULL REFERENCES public.inspeccion(id_inspeccion),
    tipo VARCHAR(20)
);

CREATE TABLE public.sensor (
    id_sensor SERIAL PRIMARY KEY,
    id_colmena INT NOT NULL REFERENCES public.colmena(id_colmena),
    tipo VARCHAR(25),
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE public.registro_ambiental (
    id_registro SERIAL PRIMARY KEY,
    id_sensor INT NOT NULL REFERENCES public.sensor(id_sensor),
    temperatura NUMERIC(5,2),
    humedad NUMERIC(5,2),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.evento (
    id_evento SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL REFERENCES public.usuario(id_usuario),
    tipo VARCHAR(20),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.credito (
    id_credito SERIAL PRIMARY KEY,
    id_entidad INT NOT NULL REFERENCES public.entidad_apoyo(id_entidad),
    monto NUMERIC(12,2) CHECK (monto >= 0)
);

CREATE TABLE public.detalle_pedido (
    id_detalle SERIAL PRIMARY KEY,
    id_pedido INT NOT NULL REFERENCES public.pedido(id_pedido),
    id_producto INT NOT NULL REFERENCES public.producto(id_producto),
    cantidad INT NOT NULL CHECK (cantidad > 0)
);

--Tablas intermedias--
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