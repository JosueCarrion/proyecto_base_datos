-- Función final para el trigger con detección precisa de celulares
CREATE OR REPLACE FUNCTION actualizar_tarifa_llamada()
RETURNS TRIGGER AS $$
DECLARE
    v_tipo_llamada VARCHAR(20);
    v_costo_minuto NUMERIC(18,5);
    v_es_celular BOOLEAN;
    v_pais_origen VARCHAR(3);
    v_pais_destino VARCHAR(3);
    v_tipo_de_telefono VARCHAR(20);
    v_codigo_renta VARCHAR(20);
    v_es_internacional BOOLEAN;
    v_duracion_minutos NUMERIC(18,5);
    v_cupos_libres NUMERIC(18,5);
    v_porcentaje_tarifa NUMERIC(18,5);
    v_costo_impulso_adicional NUMERIC(18,5);
BEGIN
    -- Calcular duración en minutos (con segundos como fracción)
    v_duracion_minutos := NEW.minutos + (NEW.segundos / 60.0);
    
    -- Determinar si es llamada a celular (usando la tabla celular)
    SELECT EXISTS (
        SELECT 1 FROM celular 
        WHERE id_llamada = NEW.id_llamada
    ) INTO v_es_celular;
    
    -- Obtener país de origen (sucursal) y destino
    SELECT d.abreviatura INTO v_pais_origen
    FROM destino d
    WHERE d.codigo_destino = NEW.codigo_sucursal;
    
    -- Solo buscar país destino si no es celular (para optimización)
    SELECT d.abreviatura INTO v_pais_destino
    FROM destino d
    WHERE d.codigo_destino = NEW.codigo_destino;
    
    -- Determinar si es internacional
    v_es_internacional := (v_pais_origen <> v_pais_destino);

    -- Determinar el tipo de llamada
    IF NEW.codigo_destino IS NULL THEN
        -- Llamada local (sin código de destino)
        NEW.tarifa := 0;
        RETURN NEW;
    ELSIF v_es_celular THEN
        v_tipo_llamada := 'celular';
    ELSIF v_es_internacional THEN
        v_tipo_llamada := 'internacional';
    ELSE
        v_tipo_llamada := 'nacional';
    END IF;

    select tipo_de_telefono INTO v_tipo_de_telefono, codigo_renta INTO v_codigo_renta from contrato where numero_telefonico = NEW.numero_telefonico;

    -- Obtener el costo por minuto según el tipo de llamada
    
    IF (v_tipo_llamada = 'celular') THEN -- Celular
        select monto into v_costo_minuto from compania_celular
        WHERE codigo_compania = (select compania_celular from celular where id_llamada = NEW.id_llamada);
    ELSE
        SELECT costo INTO v_costo_minuto, cupo INTO v_cupos_libres, costo_impulso_adicional INTO v_costo_impulso_adicional
        FROM tipo_renta
        WHERE tipo_telefono = v_tipo_de_telefono and codigo_renta = v_codigo_renta;
    END IF;

    
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
            WHEN v_tipo_llamada = 'nacional' THEN
                NEW.tarifa := (v_costo_minuto * v_porcentaje_tarifa) * v_duracion_minutos;

            WHEN v_tipo_llamada = 'celular' THEN
                NEW.tarifa := v_costo_minuto * CEIL(v_duracion_minutos);

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