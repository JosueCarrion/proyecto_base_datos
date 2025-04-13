CREATE TABLE Impuesto (
    codigo_de_impuesto CHAR(3) PRIMARY KEY,
    descripcion TEXT NOT NULL,
    monto NUMERIC(10,2) NOT NULL,
    fecha DATE NOT NULL
);

CREATE TABLE Tipo_Renta (
    codigo_renta CHAR(3) PRIMARY KEY,
    descripcion TEXT NOT NULL,
    costo NUMERIC(10,2) NOT NULL,
    fecha DATE NOT NULL,
    cupo INTEGER NOT NULL,
    costo_impulso_adicional NUMERIC(10,2)
);

CREATE TABLE Servicio (
    codigo_servicio CHAR(3) PRIMARY KEY,
    descripcion TEXT NOT NULL,
    monto NUMERIC(10,2) NOT NULL,
    fecha DATE NOT NULL
);

CREATE TABLE Destino (
    abreviatura CHAR(3),
    codigo_destino VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Compania_Celular (
    codigo_compania CHAR(3) PRIMARY KEY,
    monto NUMERIC(10,2) NOT NULL,
    fecha DATE NOT NULL,
    descripcion TEXT NOT NULL
);

CREATE TABLE Suscriptor (
    id_suscriptor INT PRIMARY KEY,
    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('Persona Natural', 'Persona Juridica'))
);

CREATE TABLE Persona_Natural (
    cedula_de_identidad VARCHAR(20) PRIMARY KEY,
    primer_nombre VARCHAR(50) NOT NULL,
    primer_apellido VARCHAR(50) NOT NULL,
    id_suscriptor INT NOT NULL,
    FOREIGN KEY (id_suscriptor) REFERENCES Suscriptor(id_suscriptor) ON DELETE CASCADE
);

CREATE TABLE Persona_Juridica (
    rif VARCHAR(20) PRIMARY KEY,
    razon_social VARCHAR(100) NOT NULL,
    id_suscriptor INT NOT NULL,
    FOREIGN KEY (id_suscriptor) REFERENCES Suscriptor(id_suscriptor) ON DELETE CASCADE
);

CREATE TABLE Sucursal (
    codigo_destino VARCHAR(20) NOT NULL,
    codigo_sucursal VARCHAR(20) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    direccion TEXT NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    PRIMARY KEY (codigo_destino, codigo_sucursal),
    FOREIGN KEY (codigo_destino) REFERENCES Destino(codigo_destino) ON DELETE CASCADE
);

CREATE TABLE Pais (
    codigo_destino CHAR(3) PRIMARY KEY,
    costo NUMERIC(10,2) NOT NULL,
    FOREIGN KEY (codigo_destino) REFERENCES Destino(codigo_destino) ON DELETE CASCADE
);



CREATE TABLE Contrato (
    numero_telefonico VARCHAR(15) PRIMARY KEY,
    titular_de_pago VARCHAR(100) NOT NULL,
    tipo_de_telefono VARCHAR(20) NOT NULL,
    direccion_de_suministro TEXT NOT NULL,
    id_suscriptor INT NOT NULL,
    codigo_renta CHAR(3) NOT NULL,
    codigo_sucursal VARCHAR(20),
    FOREIGN KEY (id_suscriptor) REFERENCES Suscriptor(id_suscriptor) ON DELETE CASCADE,
    FOREIGN KEY (codigo_renta) REFERENCES Tipo_Renta(codigo_renta) ON DELETE CASCADE
);

CREATE TABLE Cheque (
    cod_cheque VARCHAR(20) PRIMARY KEY,
    numero_cheque VARCHAR(20) NOT NULL,
    operador_telefonico VARCHAR(50) NOT NULL,
    banco VARCHAR(50) NOT NULL,
    clave VARCHAR(20) NOT NULL
);

CREATE TABLE pagado (
    codigo_pago_oficina INT PRIMARY KEY ,
    numero_telefonico VARCHAR(20) NOT NULL,
    tipo_de_pago VARCHAR(20) NOT NULL CHECK (tipo_de_pago IN ('Automático', 'Por Oficina')),
    FOREIGN KEY (numero_telefonico) REFERENCES Contrato(numero_telefonico) ON DELETE CASCADE

);

CREATE TABLE Pago (
    codigo_pago_oficina INT NOT NULL,
    numero_de_tarjeta VARCHAR(20) NULL,
    fecha DATE NOT NULL,
    monto NUMERIC(10,2) NOT NULL,
    codigo_cheque VARCHAR(20) NULL,
    FOREIGN KEY (codigo_cheque) REFERENCES Cheque(cod_cheque) ON DELETE SET NULL,
     FOREIGN KEY (codigo_pago_oficina) REFERENCES pagado(codigo_pago_oficina) ON DELETE CASCADE
);

CREATE TABLE Pago_Por_Oficina (
    numero_telefonico VARCHAR(20) NOT NULL,
    codigo_pago_oficina INT PRIMARY KEY,
    FOREIGN KEY (numero_telefonico) REFERENCES Contrato(numero_telefonico) ON DELETE CASCADE,
    FOREIGN KEY (codigo_pago_oficina) REFERENCES pagado(codigo_pago_oficina) ON DELETE CASCADE
);

CREATE TABLE Pago_Automatico (
    codigo_pago_automatico INT NOT NULL,
    numero_telefonico VARCHAR(20) NOT NULL,
    numero_de_tarjeta VARCHAR(20) NOT NULL,
    PRIMARY KEY (codigo_pago_automatico, numero_telefonico, numero_de_tarjeta),
    FOREIGN KEY (numero_telefonico) REFERENCES Contrato(numero_telefonico) ON DELETE CASCADE,
    FOREIGN KEY (codigo_pago_automatico) REFERENCES pagado(codigo_pago_oficina) ON DELETE CASCADE
);



CREATE TABLE Llamada (
    id_llamada SERIAL,
    numero_destino VARCHAR(20) NULL,
    operador VARCHAR(3) NOT NULL,
    minutos INTEGER NOT NULL,
    segundos INTEGER NOT NULL CHECK (segundos >= 0 AND segundos < 60),
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    numero_telefonico VARCHAR(20) NOT NULL,
    codigo_destino VARCHAR(20) NULL,
    compania_celular CHAR(3) NULL,
    PRIMARY KEY (id_llamada),
    FOREIGN KEY (numero_telefonico) REFERENCES Contrato(numero_telefonico) ON DELETE CASCADE,
    FOREIGN KEY (codigo_destino) REFERENCES Destino(codigo_destino) ON DELETE CASCADE,
    FOREIGN KEY (compania_celular) REFERENCES Compania_Celular(codigo_compania) ON DELETE CASCADE
);

CREATE TABLE Tiene_servicio (
    numero_telefonico VARCHAR(20) NOT NULL,
    codigo_servicio VARCHAR(20) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    PRIMARY KEY (numero_telefonico, codigo_servicio),
    FOREIGN KEY (numero_telefonico) REFERENCES Contrato(numero_telefonico) ON DELETE CASCADE,
    FOREIGN KEY (codigo_servicio) REFERENCES Servicio(codigo_servicio) ON DELETE CASCADE,
    CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
);

CREATE TABLE Cuesta (
    origen VARCHAR(20) NOT NULL,
    destino VARCHAR(20) NOT NULL,
    monto NUMERIC(10,2) NOT NULL,
    fecha DATE NOT NULL,
    PRIMARY KEY (origen, destino),
    FOREIGN KEY (origen) REFERENCES Destino(codigo_destino) ON DELETE CASCADE,
    FOREIGN KEY (destino) REFERENCES Destino(codigo_destino) ON DELETE CASCADE
);
