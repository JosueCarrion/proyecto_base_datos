CREATE OR REPLACE FUNCTION calcular_dia_facturacion(numero_telefono VARCHAR(15)) 
RETURNS INT AS $$
BEGIN
    RETURN CASE RIGHT(TRIM(numero_telefono), 1)
        WHEN '0' THEN 1
        WHEN '1' THEN 4
        WHEN '2' THEN 7
        WHEN '3' THEN 10
        WHEN '4' THEN 13
        WHEN '5' THEN 16
        WHEN '6' THEN 19
        WHEN '7' THEN 22
        WHEN '8' THEN 25
        WHEN '9' THEN 28
        ELSE NULL
    END;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION calcular_dia_pago(numero_telefono VARCHAR(15)) 
RETURNS INT AS $$
BEGIN
    RETURN CASE RIGHT(TRIM(numero_telefono), 1)
        WHEN '0' THEN 25
        WHEN '1' THEN 28
        WHEN '2' THEN 1
        WHEN '3' THEN 4
        WHEN '4' THEN 7
        WHEN '5' THEN 10
        WHEN '6' THEN 13
        WHEN '7' THEN 16
        WHEN '8' THEN 19
        WHEN '9' THEN 22
        ELSE NULL
    END;
END;
$$ LANGUAGE plpgsql;



CREATE TABLE Impuesto (
    codigo_de_impuesto CHAR(3) PRIMARY KEY,
    descripcion TEXT NOT NULL,
    monto NUMERIC(10,2) NOT NULL,
    fecha DATE NOT NULL
);

CREATE TABLE Sucursal (
    codigo_sucursal VARCHAR(20) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    direccion TEXT NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    PRIMARY KEY (codigo_sucursal)
);

CREATE TABLE Pais (
    codigo_pais CHAR(3),
    costo NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (codigo_pais)

);

CREATE TABLE Tipo_Renta (
    codigo_renta CHAR(3) NOT NULL,
    tipo_de_telefono VARCHAR(20) NOT NULL,
    descripcion TEXT NOT NULL,
    costo NUMERIC(10,2) NOT NULL,
    fecha DATE NOT NULL,
    cupo INTEGER NOT NULL,
    costo_impulso_adicional NUMERIC(10,2),
    PRIMARY KEY (codigo_renta, tipo_de_telefono)
     
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


CREATE TABLE Contrato (
    numero_telefonico VARCHAR(15),
    titular_de_pago VARCHAR(100) NOT NULL,
    tipo_de_telefono VARCHAR(20) NOT NULL,
    direccion_de_suministro TEXT NOT NULL,
    id_suscriptor INT NOT NULL,
    fecha_de_facturacion INT NULL,
    fecha_de_pago INT NULL,
    codigo_renta CHAR(3) NOT NULL,
    codigo_sucursal VARCHAR(20),
    PRIMARY KEY(codigo_sucursal, numero_telefonico),
    FOREIGN KEY (id_suscriptor) REFERENCES Suscriptor(id_suscriptor) ON DELETE CASCADE,
    FOREIGN KEY (codigo_renta, tipo_de_telefono) REFERENCES Tipo_Renta(codigo_renta, tipo_de_telefono) ON DELETE CASCADE,
    FOREIGN KEY (codigo_sucursal) REFERENCES Sucursal(codigo_sucursal)
);



CREATE TABLE pagado (
    codigo_pago_oficina INT PRIMARY KEY ,
    codigo_sucursal VARCHAR(20),
    numero_telefonico VARCHAR(20) NOT NULL,
    tipo_de_pago VARCHAR(20) NOT NULL CHECK (tipo_de_pago IN ('Automático', 'Por Oficina')),
    FOREIGN KEY (codigo_sucursal, numero_telefonico) REFERENCES Contrato(codigo_sucursal, numero_telefonico) ON DELETE CASCADE

);

CREATE TABLE Pago (
    codigo_pago_oficina INT NOT NULL,
    numero_de_tarjeta VARCHAR(20) NULL,
    fecha DATE NOT NULL,
    monto NUMERIC(10,2) NOT NULL,
     FOREIGN KEY (codigo_pago_oficina) REFERENCES pagado(codigo_pago_oficina) ON DELETE CASCADE
);

CREATE TABLE Cheque (
    cod_cheque VARCHAR(20) PRIMARY KEY,
    numero_cheque VARCHAR(20) NOT NULL,
    operador_telefonico VARCHAR(50) NOT NULL,
    banco VARCHAR(50) NOT NULL,
    clave VARCHAR(20) NOT NULL
)INHERITS (Pago);

CREATE TABLE Pago_Por_Oficina (
    codigo_sucursal VARCHAR(20),
    numero_telefonico VARCHAR(20) NOT NULL,
    codigo_pago_oficina INT PRIMARY KEY,
    FOREIGN KEY (codigo_sucursal, numero_telefonico) REFERENCES Contrato(codigo_sucursal, numero_telefonico) ON DELETE CASCADE,
    FOREIGN KEY (codigo_pago_oficina) REFERENCES pagado(codigo_pago_oficina) ON DELETE CASCADE
);

CREATE TABLE Pago_Automatico (
    codigo_pago_automatico INT NOT NULL,
    codigo_sucursal VARCHAR(20),
    numero_telefonico VARCHAR(20) NOT NULL,
    numero_de_tarjeta VARCHAR(20) NOT NULL,
    PRIMARY KEY (codigo_pago_automatico, codigo_sucursal, numero_telefonico, numero_de_tarjeta),
    FOREIGN KEY (codigo_sucursal,numero_telefonico) REFERENCES Contrato(codigo_sucursal, numero_telefonico) ON DELETE CASCADE,
    FOREIGN KEY (codigo_pago_automatico) REFERENCES pagado(codigo_pago_oficina) ON DELETE CASCADE
);



CREATE TABLE Llamada (
    id_llamada SERIAL,
    codigo_sucursal VARCHAR(20),
    numero_destino VARCHAR(20) NULL,
    operador VARCHAR(3) NOT NULL,
    minutos INTEGER NOT NULL,
    segundos INTEGER NOT NULL CHECK (segundos >= 0 AND segundos < 60),
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    tarifa NUMERIC (18,5) NULL,
    numero_telefonico VARCHAR(20) NOT NULL,
    codigo_destino VARCHAR(20) NULL,
    PRIMARY KEY (id_llamada),
    FOREIGN KEY (codigo_sucursal, numero_telefonico) REFERENCES Contrato(codigo_sucursal, numero_telefonico) ON DELETE CASCADE,
    FOREIGN KEY (codigo_destino) REFERENCES Destino(codigo_destino) ON DELETE CASCADE
);

CREATE TABLE Celular (
    compania_celular CHAR(3) NOT NULL,
    PRIMARY KEY (id_llamada, compania_celular),
    FOREIGN KEY (compania_celular) REFERENCES Compania_Celular(codigo_compania) ON DELETE CASCADE
) INHERITS (Llamada);


CREATE TABLE Tiene_servicio (
    codigo_sucursal VARCHAR(20) NOT NULL,
    numero_telefonico VARCHAR(20) NOT NULL,
    codigo_servicio VARCHAR(20) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    PRIMARY KEY (codigo_sucursal, numero_telefonico, codigo_servicio),
    FOREIGN KEY (codigo_sucursal, numero_telefonico) REFERENCES Contrato(codigo_sucursal, numero_telefonico) ON DELETE CASCADE,
    FOREIGN KEY (codigo_servicio) REFERENCES Servicio(codigo_servicio) ON DELETE CASCADE,
    CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
);

CREATE TABLE Cuesta (
    origen VARCHAR(20) NOT NULL,
    destino VARCHAR(20) NOT NULL,
    monto NUMERIC(10,2) NOT NULL,
    fecha DATE NOT NULL,
    PRIMARY KEY (origen, destino),
    FOREIGN KEY (origen) REFERENCES Sucursal(codigo_sucursal) ON DELETE CASCADE,
    FOREIGN KEY (destino) REFERENCES Sucursal(codigo_sucursal) ON DELETE CASCADE
);


CREATE OR REPLACE FUNCTION actualizar_fechas_contrato()
RETURNS TRIGGER AS $$
DECLARE
    dia_facturacion INT;
    dia_pago INT;

BEGIN
    dia_facturacion := calcular_dia_facturacion(NEW.numero_telefonico);
    dia_pago := calcular_dia_pago(NEW.numero_telefonico);
    
    -- Si no se pudo determinar el día, usar un valor por defecto (ej. día 1)
    IF dia_facturacion IS NULL THEN
        dia_facturacion := 1;
    END IF;
    
    -- Asignar los valores calculados a los campos del registro
    NEW.fecha_de_facturacion := dia_facturacion;
    NEW.fecha_de_pago := dia_pago;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_actualizar_fechas_contrato
BEFORE INSERT OR UPDATE ON contrato
FOR EACH ROW
EXECUTE FUNCTION actualizar_fechas_contrato();

-- Función final para el trigger con detección precisa de celulares
CREATE OR REPLACE FUNCTION actualizar_tarifa_llamada()
RETURNS TRIGGER AS $$
DECLARE
    v_tipo_llamada VARCHAR(20);
    v_costo_minuto NUMERIC(18,5);
    v_pais_origen VARCHAR(3);
    v_pais_destino VARCHAR(3);
    v_tipo_de_telefono VARCHAR(20);
    v_codigo_renta VARCHAR(20);
    v_es_internacional BOOLEAN;
    v_es_local BOOLEAN;
    v_duracion_minutos NUMERIC(18,5);
    v_cupos_libres NUMERIC(18,5);
    v_porcentaje_tarifa NUMERIC(18,5);
    v_costo_impulso_adicional NUMERIC(18,5);
BEGIN
    -- Calcular duración en minutos (con segundos como fracción)
    v_duracion_minutos := NEW.minutos + (NEW.segundos / 60.0);
    
    -- Obtener país de origen (sucursal) y destino
    SELECT d.abreviatura INTO v_pais_origen
    FROM destino d
    WHERE d.codigo_destino = NEW.codigo_sucursal;
    
    -- Solo buscar país destino si no es celular (para optimización)
    SELECT d.abreviatura INTO v_pais_destino
    FROM destino d
    WHERE d.codigo_destino = NEW.codigo_destino;

    v_es_local := (NEW.codigo_sucursal = NEW.codigo_destino);
    
    -- Determinar si es internacional
    v_es_internacional := (v_pais_origen <> v_pais_destino);

    -- Determinar el tipo de llamada
    IF NEW.codigo_destino IS NULL THEN
        -- Llamada local (sin código de destino)
        NEW.tarifa := 0;
        RETURN NEW;
    ELSIF v_es_local THEN
        v_tipo_llamada := 'local';
    ELSIF v_es_internacional THEN
        v_tipo_llamada := 'internacional';
    ELSE
        v_tipo_llamada := 'nacional';
    END IF;

    SELECT tipo_de_telefono, codigo_renta INTO v_tipo_de_telefono,v_codigo_renta from contrato where numero_telefonico = NEW.numero_telefonico;

    -- Obtener el costo por minuto según el tipo de llamada
    
    
    SELECT costo, cupo, costo_impulso_adicional INTO v_costo_minuto, v_cupos_libres, v_costo_impulso_adicional
    FROM tipo_renta
    WHERE tipo_de_telefono = v_tipo_de_telefono and codigo_renta = v_codigo_renta;


    
    -- Valor por defecto si no se encuentra tarifa
    IF v_costo_minuto IS NULL THEN
        v_costo_minuto := 0;
    END IF;
    
    -- Calcular tarifa según tipo y horario
    IF (NEW.hora BETWEEN '19:00:00' AND '07:00:00') OR 
       (EXTRACT(DOW FROM NEW.fecha) = 0) THEN -- Domingo
        -- Tarifa reducida (67.5%)
        v_porcentaje_tarifa := 0.675;
    ELSE
        -- Tarifa normal (100%)
        v_porcentaje_tarifa := 1;
    END IF;


    -- CALCULOS FINALES FALTA TERMINARLO
    CASE 
            WHEN v_tipo_llamada = 'local' THEN
                NEW.tarifa := (v_costo_minuto) * v_duracion_minutos;

            WHEN v_tipo_llamada = 'nacional' THEN
                NEW.tarifa := (v_costo_minuto * v_porcentaje_tarifa) * v_duracion_minutos;

            WHEN v_tipo_llamada = 'internacional' THEN
                NEW.tarifa := v_costo_minuto * CEIL(v_duracion_minutos) * v_porcentaje_tarifa;
        END CASE;
    
    -- Redondear a 5 decimales
    NEW.tarifa := ROUND(NEW.tarifa, 5);
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger (si no existe)
CREATE TRIGGER trg_actualizar_tarifa_llamada
BEFORE INSERT OR UPDATE ON Llamada
FOR EACH ROW
EXECUTE FUNCTION actualizar_tarifa_llamada();

-- Función final para el trigger con detección precisa de celulares
CREATE OR REPLACE FUNCTION actualizar_tarifa_celular()
RETURNS TRIGGER AS $$
DECLARE
    v_tipo_llamada VARCHAR(20);
    v_costo_minuto NUMERIC(18,5);
    v_pais_origen VARCHAR(3);
    v_pais_destino VARCHAR(3);
    v_tipo_de_telefono VARCHAR(20);
    v_codigo_renta VARCHAR(20);
    v_es_internacional BOOLEAN;
    v_es_local BOOLEAN;
    v_duracion_minutos NUMERIC(18,5);
    v_cupos_libres NUMERIC(18,5);
    v_porcentaje_tarifa NUMERIC(18,5);
    v_costo_impulso_adicional NUMERIC(18,5);
BEGIN
    -- Calcular duración en minutos (con segundos como fracción)
    v_duracion_minutos := NEW.minutos + (NEW.segundos / 60.0);
    
    
    -- Obtener país de origen (sucursal) y destino
    SELECT d.abreviatura INTO v_pais_origen
    FROM destino d
    WHERE d.codigo_destino = NEW.codigo_sucursal;
    
    -- Solo buscar país destino si no es celular (para optimización)
    SELECT d.abreviatura INTO v_pais_destino
    FROM destino d
    WHERE d.codigo_destino = NEW.codigo_destino;
    
    v_es_local := (NEW.codigo_sucursal = NEW.codigo_destino);
    -- Determinar si es internacional
    v_es_internacional := (v_pais_origen <> v_pais_destino);

    -- Determinar el tipo de llamada
    IF NEW.codigo_destino IS NULL THEN
        -- Llamada local (sin código de destino)
        NEW.tarifa := 0;
        RETURN NEW;
    ELSIF v_es_local THEN
        v_tipo_llamada := 'local';
    ELSIF v_es_internacional THEN
        v_tipo_llamada := 'internacional';
    ELSE
        v_tipo_llamada := 'nacional';
    END IF;

    SELECT tipo_de_telefono, codigo_renta INTO v_tipo_de_telefono,v_codigo_renta from contrato where numero_telefonico = NEW.numero_telefonico;

    -- Obtener el costo por minuto según el tipo de llamada
    
    
        select monto into v_costo_minuto from compania_celular
        WHERE codigo_compania = NEW.compania_celular;

        SELECT cupo , costo_impulso_adicional INTO v_cupos_libres, v_costo_impulso_adicional
        FROM tipo_renta
        WHERE tipo_de_telefono = v_tipo_de_telefono and codigo_renta = v_codigo_renta;

    
    -- Valor por defecto si no se encuentra tarifa
    IF v_costo_minuto IS NULL THEN
        v_costo_minuto := 0;
    END IF;
    
    -- Calcular tarifa según tipo y horario
    IF (NEW.hora BETWEEN '19:00:00' AND '07:00:00') OR 
       (EXTRACT(DOW FROM NEW.fecha) = 0) THEN -- Domingo
        -- Tarifa reducida (67.5%)
        v_porcentaje_tarifa := 0.675;
    ELSE
        -- Tarifa normal (100%)
        v_porcentaje_tarifa := 1;
    END IF;


    -- CALCULOS FINALES FALTA TERMINARLO
    CASE 
            WHEN v_tipo_llamada = 'local' THEN
                NEW.tarifa := (v_costo_minuto) * v_duracion_minutos;
            WHEN v_tipo_llamada = 'nacional' THEN
                NEW.tarifa := (v_costo_minuto * v_porcentaje_tarifa) * v_duracion_minutos;
            WHEN v_tipo_llamada = 'internacional' THEN
                NEW.tarifa := v_costo_minuto * CEIL(v_duracion_minutos) * v_porcentaje_tarifa;
        END CASE;
    
    -- Redondear a 5 decimales
    NEW.tarifa := ROUND(NEW.tarifa, 5);
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger (si no existe)
CREATE TRIGGER trg_actualizar_tarifa_celular
BEFORE INSERT OR UPDATE ON Celular
FOR EACH ROW
EXECUTE FUNCTION actualizar_tarifa_celular();