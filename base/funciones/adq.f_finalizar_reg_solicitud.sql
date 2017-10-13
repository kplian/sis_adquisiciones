--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_finalizar_reg_solicitud (
  p_administrador integer,
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_funcionario_rpc integer,
  p_id_solicitud integer,
  p_id_estado_wf_act integer,
  p_id_cargo integer = NULL::integer,
  p_id_cargo_ai integer = NULL::integer,
  p_ai_habilitado varchar = 'no'::character varying
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.f_finalizar_reg_solicitud
 DESCRIPCION:   Esta funcion finaliza la solictud cambiandola al siguiente estado y asignado un RPC
 AUTOR: 		Rensi Arteaga COpar
 FECHA:	        29-1-2014
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 ISSUE            FECHA:		      AUTOR       DESCRIPCION
 0				12/10/2017			RAC			Adciona verificacion   de mosnto por categoria programatica opcionalmente segun variable global
***************************************************************************/

DECLARE

   
    v_resp		            			varchar;
    v_nombre_funcion        			text;
    v_mensaje_error         			text;
    v_id_proceso_wf 					integer;
    v_id_estado_wf 						integer;
    v_codigo_estado  					varchar;
    v_id_funcionario_aprobador  		integer;
    v_numero_sol  						varchar;
    v_id_estado_actual  				integer;
    va_id_tipo_estado 					integer [];
    va_codigo_estado					varchar [];
    va_disparador 						varchar [];
    va_regla 							varchar [];
    va_prioridad 						integer [];
    v_id_funcionario_supervisor 		integer;
    v_id_funcionario_estado_sig   		integer;
    v_acceso_directo  					varchar;
    v_clase   							varchar;
    v_parametros_ad   					varchar;
    v_tipo_noti  						varchar;
    v_titulo   							varchar;
    v_num_estados  						integer;
    v_fecha_soli 						date;
    v_num_funcionarios 					integer;
    presu_comprometido 					varchar;
    v_id_tipo_estado					integer;
    v_adq_comprometer_presupuesto		varchar;
    v_adq_revisar_montos_categoria		varchar;
    v_id_categoria_compra				integer;
    v_total_mb							numeric;
    
    
   
			    
BEGIN

/*

p_hstore


p_hstore->'id_solicitud'


*/



  v_nombre_funcion = 'adq.f_finalizar_reg_solicitud';
  v_adq_comprometer_presupuesto = pxp.f_get_variable_global('adq_comprometer_presupuesto');
  v_adq_revisar_montos_categoria = pxp.f_get_variable_global('adq_revisar_montos_categoria');
  
 
          
        --obtenermos datos basicos
          
          select
            s.id_proceso_wf,
            s.id_estado_wf,
            s.estado,
            s.id_funcionario_aprobador,
            s.id_funcionario_supervisor,
            s.numero,
            s.fecha_soli,
            s.presu_comprometido,
            s.id_categoria_compra
          into 
          
            v_id_proceso_wf,
            v_id_estado_wf,
            v_codigo_estado,
            v_id_funcionario_aprobador,
            v_id_funcionario_supervisor,
            v_numero_sol,
            v_fecha_soli,
            presu_comprometido,
            v_id_categoria_compra
            
          from adq.tsolicitud s
          where s.id_solicitud=p_id_solicitud;
          
         
          
          select 
            ew.id_tipo_estado 
           into 
            v_id_tipo_estado
          from wf.testado_wf ew
          inner join wf.ttipo_estado te on te.id_tipo_estado = ew.id_tipo_estado
          where ew.id_estado_wf = v_id_estado_wf;
          
          --actualizamos el rpc
          update adq.tsolicitud  s set 
             id_funcionario_rpc=p_id_funcionario_rpc
          where id_solicitud = p_id_solicitud;
          
          
        --buscamos siguiente estado correpondiente al proceso del WF 
      
          
     
        
        SELECT  
             ps_id_tipo_estado,
             ps_codigo_estado,
             ps_disparador,
             ps_regla,
             ps_prioridad
          into
            va_id_tipo_estado,
            va_codigo_estado,
            va_disparador,
            va_regla,
            va_prioridad 
          FROM adq.f_obtener_sig_estado_sol_rec(p_id_solicitud, v_id_proceso_wf, v_id_tipo_estado); 
                        
      
        v_num_estados= array_length(va_id_tipo_estado, 1);
        
        
                       
        IF v_num_estados = 1 then
                  -- si solo hay un estado,  verificamos si tiene mas de un funcionario por este estado
                 SELECT 
                 *
                  into
                  v_num_funcionarios
                  
                 FROM wf.f_funcionario_wf_sel(
                     p_id_usuario, 
                     va_id_tipo_estado[1], 
                     v_fecha_soli,
                     v_id_estado_wf,
                     TRUE) AS (total bigint);
                     
                     
             
                                   
                      IF v_num_funcionarios = 1 THEN
                      -- si solo es un funcionario, recuperamos el funcionario correspondiente
                           SELECT 
                               id_funcionario
                                 into
                               v_id_funcionario_estado_sig
                           FROM wf.f_funcionario_wf_sel(
                               p_id_usuario, 
                               va_id_tipo_estado[1], 
                               v_fecha_soli,
                               v_id_estado_wf,
                               FALSE) 
                               AS (id_funcionario integer,
                                 desc_funcionario text,
                                 desc_funcionario_cargo text,
                                 prioridad integer);
                      END IF;  
        
        ELSE
        
            raise exception 'El flujo se encuentra mal parametrizados, mas de un estado destino';
        
        END IF;
        
       
  
        
        -- 15/04/2015, por qu ese agregan mas estado al flujo es nesario obtene el funcionari dinamicamente  
         v_num_estados= array_length(va_id_tipo_estado, 1);
        
         v_id_funcionario_estado_sig = v_id_funcionario_supervisor;
        
        -- verifica si tiene un supervisor
        IF v_id_funcionario_supervisor is NULL then
        
         --si no tiene supervisor pasamos directo al siguiente estado
            SELECT  
               ps_id_tipo_estado,
               ps_codigo_estado,
               ps_disparador,
               ps_regla,
               ps_prioridad
            into
              va_id_tipo_estado,
              va_codigo_estado,
              va_disparador,
              va_regla,
              va_prioridad 
            FROM adq.f_obtener_sig_estado_sol_rec(p_id_solicitud, v_id_proceso_wf, va_id_tipo_estado[1]);
            
            IF va_id_tipo_estado[1] is NULL THEN
           
              raise exception 'No se encontro el estado de visto bueno gerencia';
           
            END IF;
            
            
           
            
            v_num_estados= array_length(va_id_tipo_estado, 1);
            
            
            IF v_num_estados = 1 then
                    -- si solo hay un estado,  verificamos si tiene mas de un funcionario por este estado
                    
                   SELECT 
                       *
                    into
                       v_num_funcionarios
                   FROM wf.f_funcionario_wf_sel(
                       p_id_usuario, 
                       va_id_tipo_estado[1], 
                       v_fecha_soli,
                       v_id_estado_wf,
                       TRUE) AS (total bigint);
                       
                                     
                  IF v_num_funcionarios = 1 THEN
                  -- si solo es un funcionario, recuperamos el funcionario correspondiente
                       SELECT 
                           id_funcionario
                             into
                           v_id_funcionario_estado_sig
                       FROM wf.f_funcionario_wf_sel(
                           p_id_usuario, 
                           va_id_tipo_estado[1], 
                           v_fecha_soli,
                           v_id_estado_wf,
                           FALSE) 
                           AS (id_funcionario integer,
                             desc_funcionario text,
                             desc_funcionario_cargo text,
                             prioridad integer);
                  ELSE
                      raise exception 'El estado % , solo puede tener un funcionario registrado id =  %', va_codigo_estado,  va_id_tipo_estado;
                  END IF;  
          
          ELSE
          
              raise exception 'El flujo se encuentra mal parametrizados, mas de un estado destino';
          
          END IF;
            
        END IF;
        
      
          
          --cambiamos estado de la solicitud
         
          IF  va_id_tipo_estado[2] is not null  THEN
           
            raise exception 'El proceso se encuentra mal parametrizado dentro de Work Flow,  la finalizacion de solicitud solo admite un estado siguiente';
          
          END IF;
          
          IF  va_id_tipo_estado[1] is  null  THEN
           
            raise exception ' El proceso de Work Flow esta mal parametrizado, no tiene un estado siguiente para la finalizacion';
          
          END IF;
          
            
          IF  va_disparador[1]='si'  THEN
           
            raise exception ' El proceso de Work Flow esta mal parametrizado, antes de iniciar el proceso de compra necesita comprometer el presupuesto';
          
          END IF;
          
          
          --registra estado eactual en el WF
          
           --configurar acceso directo para la alarma   
           v_acceso_directo = '';
           v_clase = '';
           v_parametros_ad = '';
           v_tipo_noti = 'notificacion';
           v_titulo  = 'Visto Bueno';
                       
                     
           IF  va_codigo_estado[1] not in('borrador','aprobado','en_proceso','finalizado','anulado')   THEN
               v_acceso_directo = '../../../sis_adquisiciones/vista/solicitud/SolicitudVb.php';
               v_clase = 'SolicitudVb';
               v_parametros_ad = '{filtro_directo:{campo:"sol.id_proceso_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
               v_tipo_noti = 'notificacion';
               v_titulo  = 'Visto Bueno';
                       
            END IF;
            
            
            
           -- si ele estado es borrador verificamos que el presupuesto sea suficiente
            
             IF v_codigo_estado =  'borrador' THEN             
                  IF not adq.f_gestionar_presupuesto_solicitud(p_id_solicitud, p_id_usuario, 'verificar')  THEN                     
                       raise exception 'Error al verificar  el presupeusto';                     
                  END IF;
             
             END IF;
            
           
           
           -- registra nuevo estado
          
           v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado[1], 
                                                         v_id_funcionario_estado_sig, 
                                                         p_id_estado_wf_act, 
                                                         v_id_proceso_wf,
                                                         p_id_usuario,
                                                         p_id_usuario_ai,
                                                         p_usuario_ai,
                                                         NULL,
                                                         'Solicitud a espera de aprobación #'||COALESCE(v_numero_sol,'S/N'),
                                                         v_acceso_directo ,
                                                         v_clase,
                                                         v_parametros_ad,
                                                         v_tipo_noti,
                                                         v_titulo);
             
                                                         
           --si el estado  anteriro es vbpresupuestos  entonces comprometemos                                            
           IF v_codigo_estado =  'vbpresupuestos'  and presu_comprometido = 'no' and v_adq_comprometer_presupuesto = 'si' THEN 
              
                  -- Comprometer Presupuesto                  
                  IF not adq.f_gestionar_presupuesto_solicitud(p_id_solicitud, p_id_usuario, 'comprometer')  THEN                     
                       raise exception 'Error al comprometer el presupeusto';                     
                  END IF;

                  --modifca bandera de comprometido  
                   update adq.tsolicitud  s set 
                        presu_comprometido =  'si',
                        fecha_apro = now()
                   where id_solicitud = p_id_solicitud;
             END IF;
             
             
            --12/20/2017 RAC, 
            -- Preguntar si es necesario validar lso mosnto por categoria de compra 
            IF v_adq_revisar_montos_categoria = 'si' THEN   
                --la validacion se hace en moenda base
                 select
                    sum(sd.precio_ga_mb + sd.precio_sg_mb )
                  into
                    v_total_mb
                 from adq.tsolicitud_det sd   
                 where sd.estado_reg = 'activo' and sd.id_solicitud = p_id_solicitud;
                 
                IF not EXISTS (select
                                  1 
                               from adq.tcategoria_compra cat
                               where      cat.id_categoria_compra =  v_id_categoria_compra
                                     and     
                                            ((v_total_mb >= cat.min and v_total_mb <= cat.max)
                                        or 
                                            (v_total_mb >= cat.min and cat.max is null))) THEN
                        
                       raise exception 'El monto %  (Moneda Base) no se correponde con la categoria seleccionada (%)', v_total_mb,v_id_categoria_compra ;
                                    
                 END IF;
              
            END IF;
             
           
           
           --RAC 11/08/2017  
           -- si llega al estado aprobacion y el presupeusto todavia noe sta comprometido, y el sistema esta configurado para comproemter,
           -- comprometemos  
            IF va_codigo_estado[1] = 'aprobado' and presu_comprometido = 'no' and v_adq_comprometer_presupuesto = 'si' THEN
                  
                  -- Comprometer Presupuesto                  
                  IF not adq.f_gestionar_presupuesto_solicitud(p_id_solicitud, p_id_usuario, 'comprometer')  THEN                     
                       raise exception 'Error al comprometer el presupeusto';                     
                  END IF;

                  --modifca bandera de comprometido  
                   update adq.tsolicitud  s set 
                        presu_comprometido =  'si',
                        fecha_apro = now()
                   where id_solicitud = p_id_solicitud;
            
            END IF; 

       
          
           -- actualiza estado en la solicitud
          
           update adq.tsolicitud  s set 
             id_estado_wf =  v_id_estado_actual,
             estado = va_codigo_estado[1],
             id_usuario_mod=p_id_usuario,
             fecha_mod=now(),
             id_cargo_rpc = p_id_cargo,
             id_cargo_rpc_ai = p_id_cargo_ai,
             id_usuario_ai= p_id_usuario_ai,
             usuario_ai = p_usuario_ai,
             ai_habilitado = p_ai_habilitado
           where id_solicitud = p_id_solicitud;
           
      --Definicion de la respuesta
          v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Solicitud de compra finalizada'); 
        
        
  
         return v_resp;

EXCEPTION
				
	WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
		raise exception '%',v_resp;
				        
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;