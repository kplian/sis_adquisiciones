CREATE OR REPLACE FUNCTION adq.f_tr_delete_soldet_up_presoldet (
)
RETURNS trigger AS
$body$
/**************************************************************************
 SISTEMA:        Adquisiciones
 FUNCION:         adq.tr_delete_soldet_up_presoldet
 DESCRIPCION:   Funcion que retrocede los estados de una presolicitud cuando el detalle de la solicitud pasa a inactivo y este detalle 
                esta asociada al detalle de una presolicitud.
 AUTOR:          (EGS)
 FECHA:          07/02/2019
 COMENTARIOS:
 ISSUE:            #4    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
ISSUE   FECHA           AUTOR           DESCRIPCION    
     
***************************************************************************/
DECLARE
  v_id_presolicitud     integer;
  v_id_presolicitud_det integer;
  v_id_solicitud        integer;
  v_item                record;
  v_codigo_inv          varchar;
  v_pre_solicitud       varchar;
  v_nro_item_asignado   integer;
  
    --variables para cambio de estado automatico
    v_registros             record;
    va_id_tipo_estado 		integer[];
    va_codigo_estado 		varchar[];
    va_disparador    		varchar[];
    va_regla         		varchar[]; 
    va_prioridad     		integer[];
    p_id_usuario            integer;
    p_id_usuario_ai         integer;
    p_usuario_ai            varchar;
    v_id_estado_actual		integer;
    v_id_funcionario        integer;

BEGIN
    

    --Recuperamos los datos de la presolicitud
    IF TG_OP = 'UPDATE' THEN 
            SELECT
                presoldet.id_presolicitud,
                presoldet.id_presolicitud_det
                INTO
                v_id_presolicitud,
                v_id_presolicitud_det   
            FROM adq.tpresolicitud_det presoldet
            WHERE presoldet.id_solicitud_det = NEW.id_solicitud_det ;
            --si existe una presolicitud relacionada y el nuevo estado del detalle de la solicitud es inactivo
            --se cambia de estado a la presolicitud y a su detalle para que no esten asociados a la solicitud
            IF v_id_presolicitud_det is not null AND NEW.estado_reg ='inactivo'  THEN
                --actualizamos la presolicitud_det
                UPDATE adq.tpresolicitud_det set
                estado = 'pendiente',
                id_solicitud_det = null
                WHERE id_presolicitud_det = v_id_presolicitud_det;
                 --verificamos si en el detalle tiene consolidados   
                    SELECT
                     count(presold.id_presolicitud_det)
                        into
                        v_nro_item_asignado
                    FROM adq.tpresolicitud_det presold
                    WHERE presold.id_solicitud_det is not null and presold.id_presolicitud =v_id_presolicitud ;
                    --si no tienen consolidados se retrocedes de estado a aprobado
                    IF v_nro_item_asignado = 0 THEN
                     SELECT
                            pres.id_presolicitud,
                            pres.id_estado_wf,
                            pres.id_proceso_wf,
                            pres.id_depto      
                        INTO
                            v_registros
                        FROM adq.tpresolicitud pres 
                        WHERE    pres.id_presolicitud = v_id_presolicitud;
                    
                    --actualizamos la presolicitud asociada
                        SELECT 
                             *
                          into
                            va_id_tipo_estado,
                            va_codigo_estado,
                            va_disparador,
                            va_regla,
                            va_prioridad                        
                        FROM wf.f_obtener_estado_wf(v_registros.id_proceso_wf, v_registros.id_estado_wf,NULL,'anterior');                        
                        IF va_codigo_estado[2] is not null THEN
                                                 raise exception 'El proceso de WF esta mal parametrizado,  solo admite un estado siguiente para el estado: %', v_registros.estado;      
                        END IF;   
                         IF va_codigo_estado[1] is  null THEN                       
                         raise exception 'El proceso de WF esta mal parametrizado, no se encuentra el estado siguiente,  para el estado: %', v_registros.estado;           
                        END IF;
                     SELECT
                        fun.id_funcionario
                     into
                        v_id_funcionario
                     FROM orga.tfuncionario fun
                     left join segu.tusuario usu on usu.id_persona = fun.id_persona
                     WHERE usu.id_usuario = new.id_usuario_mod;
                      p_id_usuario= new.id_usuario_mod;
                      p_id_usuario_ai = 1;
                      p_usuario_ai = null;                       
                        -- estado anterios
                     v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado[1], 
                                                                       v_id_funcionario, 
                                                                       v_registros.id_estado_wf, 
                                                                       v_registros.id_proceso_wf,
                                                                       p_id_usuario,
                                                                       p_id_usuario_ai, -- id_usuario_ai
                                                                       p_usuario_ai, -- usuario_ai
                                                                       v_registros.id_depto,
                                                                       'Desasignación de Items');  
                        -- actualiza estado de aprobado
                         update adq.tpresolicitud pp  set 
                                     id_estado_wf =  v_id_estado_actual,
                                     estado = va_codigo_estado[1],
                                     id_usuario_mod=new.id_usuario_mod,
                                     fecha_mod=now(),
                                     id_usuario_ai = p_id_usuario_ai,
                                     usuario_ai = p_usuario_ai
                                   where id_presolicitud  = v_registros.id_presolicitud; 
                          -- se rompe la relacion con el detalle de la solicitud         
                    UPDATE adq.tpresolicitud SET
                    estado = 'aprobado' 
                    where id_presolicitud = v_id_presolicitud;
                END IF;
            END IF;

    END IF;   
    return null;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;