CREATE DATABASE BD1;
USE BD1;


CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE rol (
    id_rol INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    UNIQUE KEY uk_rol_nombre (nombre)
) ENGINE=InnoDB;

CREATE TABLE producto (
    id_producto INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0)
) ENGINE=InnoDB;

CREATE TABLE productor (
    id_productor INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE ubicacion (
    id_ubicacion INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    descripcion TEXT,
    latitud DECIMAL(9,6),
    longitud DECIMAL(9,6)
) ENGINE=InnoDB;

CREATE TABLE entidad_apoyo (
    id_entidad INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL
) ENGINE=InnoDB;


CREATE TABLE pedido (
    id_pedido INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB;

CREATE TABLE pago (
    id_pago INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_pedido INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL CHECK (monto >= 0),
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
) ENGINE=InnoDB;

CREATE TABLE apiario (
    id_apiario INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_ubicacion INT NOT NULL,
    FOREIGN KEY (id_ubicacion) REFERENCES ubicacion(id_ubicacion)
) ENGINE=InnoDB;

CREATE TABLE colmena (
    id_colmena INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_apiario INT NOT NULL,
    estado ENUM('activa','inactiva','mantenimiento'),
    FOREIGN KEY (id_apiario) REFERENCES apiario(id_apiario)
) ENGINE=InnoDB;

CREATE TABLE inspeccion (
    id_inspeccion INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_colmena INT NOT NULL,
    fecha DATE NOT NULL,
    resultado VARCHAR(20),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_colmena) REFERENCES colmena(id_colmena)
) ENGINE=InnoDB;

CREATE TABLE certificacion (
    id_certificacion INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_inspeccion INT NOT NULL,
    tipo VARCHAR(20),
    FOREIGN KEY (id_inspeccion) REFERENCES inspeccion(id_inspeccion)
) ENGINE=InnoDB;

CREATE TABLE sensor (
    id_sensor INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_colmena INT NOT NULL,
    tipo VARCHAR(25),
    activo TINYINT(1) DEFAULT 1,
    FOREIGN KEY (id_colmena) REFERENCES colmena(id_colmena)
) ENGINE=InnoDB;

CREATE TABLE registro_ambiental (
    id_registro INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_sensor INT NOT NULL,
    temperatura DECIMAL(5,2),
    humedad DECIMAL(5,2),
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_sensor) REFERENCES sensor(id_sensor)
) ENGINE=InnoDB;

CREATE TABLE evento (
    id_evento INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_usuario INT NOT NULL,
    tipo VARCHAR(20),
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB;

CREATE TABLE credito (
    id_credito INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_entidad INT NOT NULL,
    monto DECIMAL(12,2) CHECK (monto >= 0),
    FOREIGN KEY (id_entidad) REFERENCES entidad_apoyo(id_entidad)
) ENGINE=InnoDB;

CREATE TABLE detalle_pedido (
    id_detalle INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
) ENGINE=InnoDB;


CREATE TABLE usuario_rol (
    id_usuario INT NOT NULL,
    id_rol INT NOT NULL,
    PRIMARY KEY (id_usuario, id_rol),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_rol) REFERENCES rol(id_rol)
) ENGINE=InnoDB;

CREATE TABLE productor_producto (
    id_productor INT NOT NULL,
    id_producto INT NOT NULL,
    PRIMARY KEY (id_productor, id_producto),
    FOREIGN KEY (id_productor) REFERENCES productor(id_productor),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
) ENGINE=InnoDB;

CREATE TABLE sensor_evento (
    id_sensor INT NOT NULL,
    id_evento INT NOT NULL,
    PRIMARY KEY (id_sensor, id_evento),
    FOREIGN KEY (id_sensor) REFERENCES sensor(id_sensor),
    FOREIGN KEY (id_evento) REFERENCES evento(id_evento)
) ENGINE=InnoDB;

SELECT * FROM sensor;