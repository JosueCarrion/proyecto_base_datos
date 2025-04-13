-- Tarifas internacionales
INSERT INTO Pais (codigo_pais, costo) VALUES
    ('VEN', 0),
    ('ESP', 9.80),
    ('ITA', 10.00),
    ('EUA', 7.60);

-- Destinos
INSERT INTO Destino (abreviatura, codigo_destino, nombre) VALUES
    ('VEN', '0212', 'Caracas'),
    ('VEN','0232', 'Los Teques'),
    ('VEN','0233', 'Carayaca'),
    ('VEN','0234', 'Los Velásquez'),
    ('ESP','034', 'España'),
    ('ITA','039', 'Italia'),
    ('EUA','001', 'Estados Unidos de América');

-- Impuestos
INSERT INTO Impuesto (codigo_de_impuesto, descripcion, monto, fecha) VALUES
    ('ICS', 'Impuesto al Consumo Suntuario', 16.00, '2020-09-01'),
    ('UCI', 'Impuesto al Uso de la Conexión Internacional', 25.00, '2020-09-01'),
    ('IMR', 'Impuesto al Mantenimiento de la Red', 1.00, '2020-09-01'),
    ('IVM', 'Impuesto de Ventas al Mayor', 12.50, '2020-09-01');

-- Tipo de Renta
INSERT INTO Tipo_Renta (codigo_renta, descripcion, tipo_de_telefono,  costo, fecha, cupo, costo_impulso_adicional) VALUES
    ('BAS', 'Básica', 'Residencial', 194.00, '2020-08-01', 50, 5.17),
    ('INT', 'Intermedia','Residencial', 304.00, '2020-08-01', 90, 3.69),
    ('REN', 'Rendidora Residencial','Residencial', 555.00, '2020-08-01', 130, 3.19),
    ('UNI', 'Única', 'Comercial',  800.00, '2020-08-01', 0, 5.75);

-- Tipos de servicio
INSERT INTO Servicio (codigo_servicio, descripcion, monto, fecha) VALUES
    ('STA', 'Servicio de Teleamigo', 200.00, '2020-07-01'),
    ('SNP', 'Servicio de Número Privado', 400.00, '2020-07-01');

-- Compania
INSERT INTO Compania_Celular (codigo_compania, monto, fecha, descripcion) VALUES
    ('MOV', 14.60, '2020-07-01', 'Movilcel'),
    ('TEL', 15.00, '2020-09-01', 'Telenet');



-- Tarifas Nacionales
INSERT INTO Sucursal (codigo_sucursal, nombre, direccion, telefono) VALUES
    ('0212', 'Sucursal Caracas', 'Av. Principal #123, Caracas', '0212-5551234'),
    ('0232', 'Sucursal Los Teques', 'Calle Norte #456, Los Teques', '0232-5555678'),
    ('0233', 'Sucursal Carayaca', 'Av. Principal #789, Carayaca', '0233-5559012'),
    ('0234', 'Sucursal Los Velásquez', 'Calle Sur #101, Los Velásquez', '0234-5553456');


-- ************************************************************
-- Informacion sacada de los contratos
-- ************************************************************


-- Suscriptores
INSERT INTO Suscriptor (id_suscriptor, tipo) VALUES
    (1, 'Persona Natural'),
    (2, 'Persona Natural'),
    (3, 'Persona Natural'),
    (4, 'Persona Juridica');

-- Personas Naturales
INSERT INTO Persona_Natural (cedula_de_identidad, primer_nombre, primer_apellido, id_suscriptor) VALUES
    ('V-4890639', 'José Eladio', 'Martínez Díaz', 1),
    ('V-6345012', 'Milexa', 'Deris Nieto', 2),
    ('V-3855721', 'Vicenta', 'Rivero de Bracho', 3);

-- Personas Juridicas
INSERT INTO Persona_Juridica (rif, razon_social, id_suscriptor) VALUES
    ('J-02690345-7', 'Sistemas J.J. y Asociados', 4);



-- Contratos
INSERT INTO Contrato (codigo_sucursal, numero_telefonico, titular_de_pago, tipo_de_telefono, direccion_de_suministro, id_suscriptor, codigo_renta) VALUES
    ('0234', '0234-2576389', 'José Eladio Martínez Díaz', 'Residencial', 'Urb. Carrizales, calle 14, Nro. 153', 1, 'BAS'),
    ('0212', '0212-6622590', 'Milexa Deris Nieto', 'Residencial', 'Urb. La Colina, Edif. Girasol, Apto. 22', 2, 'INT'),
    ('0212', '0212-4844356', 'Vicenta Rivero de Bracho', 'Residencial', 'Urb. La Cascada, Edif. Némesis, Apto. 5-A', 3, 'REN'),
    ('0212', '0212-4435560', 'Sistemas J.J. y Asociados', 'Comercial', 'C.C. Centro Plaza, nivel 3, local 35', 4, 'UNI');

INSERT INTO Cheque (codigo_pago_oficina, numero_de_tarjeta, fecha, monto, cod_cheque, numero_cheque, operador_telefonico, banco, clave) VALUES
    (2, NULL, '2020-10-27', 257.50, 'CHQ001', '3445645646', '43', 'Banco de Venezuela', '3443');



INSERT INTO pagado (codigo_pago_oficina, codigo_sucursal,numero_telefonico, tipo_de_pago) VALUES
    (1, '0234', '0234-2576389', 'Por Oficina'),
    (2, '0212', '0212-6622590', 'Por Oficina'),
    (3, '0212', '0212-4844356', 'Por Oficina'),
    (4, '0212', '0212-4435560', 'Automático');

    INSERT INTO Pago (codigo_pago_oficina, numero_de_tarjeta, fecha, monto) VALUES
    (1, NULL, '2020-10-04', 576.80),
    (2, NULL, '2020-10-27', 257.50),
    (3, NULL, '2020-10-28', 30.00),
    (4, '4554-333333333333', '2020-10-01', 2400.00);


INSERT INTO Pago_Por_Oficina (codigo_sucursal, numero_telefonico, codigo_pago_oficina) VALUES
    ('0234', '0234-2576389', 1),
    ('0212', '0212-6622590', 2),
    ('0212', '0212-4844356', 3);

INSERT INTO Pago_Automatico (codigo_pago_automatico, codigo_sucursal,numero_telefonico, numero_de_tarjeta) VALUES
    (4, '0212', '0212-4435560', '4554-333333333333');



INSERT INTO Tiene_servicio (codigo_sucursal, numero_telefonico, codigo_servicio, fecha_inicio, fecha_fin) VALUES
    ('0212', '0212-6622590', 'STA', '2020-10-01', NULL),
    ('0212', '0212-6622590', 'SNP', '2020-10-01', NULL),
    ('0212', '0212-4844356', 'STA', '2020-10-01', NULL);

INSERT INTO Cuesta (origen, destino, monto, fecha) VALUES
    ('0234', '0212', 5.80, '2020-08-01'),
    ('0234', '0232', 3.00, '2020-08-01'),
    ('0234', '0233', 2.70, '2020-08-01'),
    ('0212', '0232', 4.50, '2020-08-01'),
    ('0212', '0233', 3.60, '2020-08-01'),
    ('0233', '0232', 2.50, '2020-08-01');

INSERT INTO Llamada (numero_destino, operador, minutos, segundos, fecha, hora, codigo_sucursal, numero_telefonico, codigo_destino) VALUES
    ('0212-9063999', 'CAR', 0, 41, '2020-10-05', '21:35:09', '0234', '0234-2576389', '0212'),
    ('0232-2344441', 'LTQ', 1, 02, '2020-10-15', '12:42:09', '0234', '0234-2576389', '0232'),
    ('0233-3455511', 'CAZ', 3, 39, '2020-10-26', '08:06:29', '0234', '0234-2576389', '0233'),
    ('0212-9773044', 'CAR', 1, 16, '2020-10-17', '11:28:39', '0234', '0234-2576389', '0212'),
    ('0340034439007', 'ESP', 6, 00, '2020-10-20', '06:20:06', '0234', '0234-2576389', '034'),
    ('0019082231083', 'EUA', 2, 00, '2020-10-24', '22:07:00', '0234', '0234-2576389', '001');
    
INSERT INTO Llamada (numero_destino, operador, minutos, segundos, fecha, hora, codigo_sucursal, numero_telefonico, codigo_destino) VALUES
    ('0232-6334942', 'LTQ', 1, 42, '2020-10-20', '12:42:09', '0212', '0212-6622590', '0232');

INSERT INTO Celular (numero_destino, operador, minutos, segundos, fecha, hora, codigo_sucursal, numero_telefonico, codigo_destino, compania_celular) VALUES
    ('0416-7345559', 'CAR', 9, 38, '2020-10-30', '20:06:29', '0212', '0212-6622590', '0212', 'MOV'),
    ('0414-0319889', 'CAR', 6, 43, '2020-10-20', '16:20:01', '0212', '0212-6622590', '0212', 'TEL');



INSERT INTO Llamada (numero_destino, operador, minutos, segundos, fecha, hora, codigo_sucursal, numero_telefonico, codigo_destino) VALUES
    ('0232-6334942', 'LTQ', 11, 23, '2020-10-16', '12:42:09', '0212', '0212-4844356', '0232'),
    ('0232-6334942', 'LTQ', 31, 23, '2020-10-17', '02:40:01', '0212', '0212-4844356', '0232'),
    ('0232-6334942', 'LTQ', 90, 23, '2020-10-17', '14:00:06', '0212', '0212-4844356', '0232'),
    ('0340014490207', 'ESP', 26, 00, '2020-10-20', '16:20:06', '0212', '0212-4844356', '034'),
    ('0340014490207', 'ESP', 47, 00, '2020-10-22', '06:00:36', '0212', '0212-4844356', '034'),
    ('0390312407563', 'ITA', 7, 00, '2020-10-22', '22:00:36', '0212', '0212-4844356', '039'),
    ('0019031247563', 'EUA', 21, 00, '2020-10-17', '00:00:54', '0212', '0212-4844356', '001');

INSERT INTO Celular (numero_destino, operador, minutos, segundos, fecha, hora, codigo_sucursal, numero_telefonico, codigo_destino, compania_celular) VALUES
    ('0416-5312345', 'CAR', 9, 38, '2020-10-20', '20:06:29', '0212', '0212-4844356', '0212', 'MOV'),
    ('0416-5312345', 'CAR', 11, 38, '2020-10-20', '20:20:29', '0212', '0212-4844356', '0212', 'MOV'),
    ('0414-2837200', 'CAR', 1, 08, '2020-10-20', '20:17:30', '0212', '0212-4844356', '0212', 'TEL');


INSERT INTO Celular (numero_destino, operador, minutos, segundos, fecha, hora, codigo_sucursal, numero_telefonico, codigo_destino, compania_celular) VALUES
    ('0416-5312345', 'CAR', 9, 38, '2020-10-20', '20:06:29', '0212', '0212-4844356', '0212', 'MOV'),
    ('0416-5312345', 'CAR', 11, 38, '2020-10-20', '20:20:29', '0212', '0212-4844356', '0212', 'MOV'),
    ('0414-2837200', 'CAR', 1, 08, '2020-10-20', '20:17:30', '0212', '0212-4844356', '0212', 'TEL'),
    ('0416-3312336', 'CAR', 19, 38, '2020-10-12', '20:06:29', '0212', '0212-4435560', '0212', 'MOV'),
    ('0416-8312347', 'CAR', 1, 38, '2020-10-14', '20:40:29', '0212', '0212-4435560', '0212', 'MOV'),
    ('0414-2837201', 'CAR', 11, 08, '2020-10-18', '20:17:30', '0212', '0212-4435560', '0212', 'TEL'),
    ('0414-2833402', 'LTQ', 13, 08, '2020-10-19', '10:17:30', '0212', '0212-4435560', '0232', 'TEL');

INSERT INTO Llamada (numero_destino, operador, minutos, segundos, fecha, hora,codigo_sucursal, numero_telefonico, codigo_destino) VALUES
    ('0390312199098', 'ITA', 12, 00, '2020-10-15', '12:00:36', '0212', '0212-4435560', '039'),
    ('0390312199098', 'ITA', 12, 00, '2020-10-16', '12:00:32', '0212', '0212-4435560', '039'),
    ('0390312199098', 'ITA', 12, 00, '2020-10-17', '21:00:33', '0212', '0212-4435560', '039'),
    ('0390312199098', 'ITA', 12, 00, '2020-10-18', '13:00:55', '0212', '0212-4435560', '039'),
    ('0390312199098', 'ITA', 12, 00, '2020-10-19', '14:00:13', '0212', '0212-4435560', '039'),
    ('0390312199098', 'ITA', 12, 00, '2020-10-20', '22:00:24', '0212', '0212-4435560', '039'),
    ('0390312199098', 'ITA', 12, 00, '2020-10-22', '22:00:36', '0212', '0212-4435560', '039'),
    ('0340014480072', 'ESP', 16, 00, '2020-10-21', '16:20:06', '0212', '0212-4435560', '034'),
    ('0340014341992', 'ESP', 17, 00, '2020-10-22', '06:00:36', '0212', '0212-4435560', '034'),
    ('0019031247563', 'EUA', 21, 00, '2020-10-17', '00:00:54', '0212', '0212-4435560', '001'),
    ('0019031247563', 'EUA', 51, 00, '2020-10-18', '10:00:43', '0212', '0212-4435560', '001'),
    ('0019031247563', 'EUA', 11, 00, '2020-10-18', '11:14:33', '0212', '0212-4435560', '001'),
    ('0019031247563', 'EUA', 1, 00, '2020-10-19', '11:00:41', '0212', '0212-4435560', '001');

    
