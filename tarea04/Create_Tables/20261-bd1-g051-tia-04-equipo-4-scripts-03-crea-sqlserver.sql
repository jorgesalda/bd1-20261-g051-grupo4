CREATE DATABASE BD1;
USE BD1;


CREATE TABLE usuario (
    id_usuario INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL
);

CREATE TABLE rol (
    id_rol INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE producto (
    id_producto INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0)
);

CREATE TABLE productor (
    id_productor INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL
);

CREATE TABLE ubicacion (
    id_ubicacion INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    descripcion TEXT,
    latitud DECIMAL(9,6),
    longitud DECIMAL(9,6)
);

CREATE TABLE entidad_apoyo (
    id_entidad INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL
);

CREATE TABLE pedido (
    id_pedido INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_usuario INT NOT NULL FOREIGN KEY REFERENCES usuario(id_usuario),
    fecha DATETIME DEFAULT GETDATE()
);

CREATE TABLE pago (
    id_pago INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_pedido INT NOT NULL FOREIGN KEY REFERENCES pedido(id_pedido),
    monto DECIMAL(10,2) NOT NULL CHECK (monto >= 0),
    fecha DATETIME DEFAULT GETDATE()
);

CREATE TABLE apiario (
    id_apiario INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_ubicacion INT NOT NULL FOREIGN KEY REFERENCES ubicacion(id_ubicacion)
);

CREATE TABLE colmena (
    id_colmena INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_apiario INT NOT NULL FOREIGN KEY REFERENCES apiario(id_apiario),
    estado VARCHAR(15)
);

CREATE TABLE inspeccion (
    id_inspeccion INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_usuario INT NOT NULL FOREIGN KEY REFERENCES usuario(id_usuario),
    id_colmena INT NOT NULL FOREIGN KEY REFERENCES colmena(id_colmena),
    fecha DATE NOT NULL,
    resultado VARCHAR(20)
);

CREATE TABLE certificacion (
    id_certificacion INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_inspeccion INT NOT NULL FOREIGN KEY REFERENCES inspeccion(id_inspeccion),
    tipo VARCHAR(20)
);

CREATE TABLE sensor (
    id_sensor INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_colmena INT NOT NULL FOREIGN KEY REFERENCES colmena(id_colmena),
    tipo VARCHAR(25),
    activo BIT DEFAULT 1
);

CREATE TABLE registro_ambiental (
    id_registro INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_sensor INT NOT NULL FOREIGN KEY REFERENCES sensor(id_sensor),
    temperatura DECIMAL(5,2),
    humedad DECIMAL(5,2),
    fecha DATETIME DEFAULT GETDATE()
);

CREATE TABLE evento (
    id_evento INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_usuario INT NOT NULL FOREIGN KEY REFERENCES usuario(id_usuario),
    tipo VARCHAR(20),
    fecha DATETIME DEFAULT GETDATE()
);

CREATE TABLE credito (
    id_credito INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_entidad INT NOT NULL FOREIGN KEY REFERENCES entidad_apoyo(id_entidad),
    monto DECIMAL(12,2) CHECK (monto >= 0)
);

CREATE TABLE detalle_pedido (
    id_detalle INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_pedido INT NOT NULL FOREIGN KEY REFERENCES pedido(id_pedido),
    id_producto INT NOT NULL FOREIGN KEY REFERENCES producto(id_producto),
    cantidad INT NOT NULL CHECK (cantidad > 0)
);


CREATE TABLE usuario_rol (
    id_usuario INT NOT NULL FOREIGN KEY REFERENCES usuario(id_usuario),
    id_rol INT NOT NULL FOREIGN KEY REFERENCES rol(id_rol),
    PRIMARY KEY (id_usuario, id_rol)
);

CREATE TABLE productor_producto (
    id_productor INT NOT NULL FOREIGN KEY REFERENCES productor(id_productor),
    id_producto INT NOT NULL FOREIGN KEY REFERENCES producto(id_producto),
    PRIMARY KEY (id_productor, id_producto)
);

CREATE TABLE sensor_evento (
    id_sensor INT NOT NULL FOREIGN KEY REFERENCES sensor(id_sensor),
    id_evento INT NOT NULL FOREIGN KEY REFERENCES evento(id_evento),
    PRIMARY KEY (id_sensor, id_evento)
);

