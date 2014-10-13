CREATE OR REPLACE FUNCTION adq.f_fun_inicio_solicitud_wf (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_estado_wf integer,
  p_id_proceso_wf integer,
  p_codigo_estado varchar,
  p_instrucciones_rpc varchar = 'Orden de Bien/Servicio'::character varying
)
RETURNS boolean AS
$body$
/*
*
*  Autor:   RAC
*  DESC:    funcion que actualiza los estados despues del registro de un retroceso en el plan de pago
*  Fecha:   10/06/2013
*
*/

DECLARE

	v_nombre_funcion   	text;
    v_resp    			varchar;
    v_mensaje varchar;
    
    v_registros record;
    v_monto_ejecutar_mo  numeric;
    v_estado_anterior varchar;
    v_sw_presu_comprometido varchar;
   
	
    
BEGIN

	 v_nombre_funcion = 'adq.f_fun_inicio_solicitud_wf';
     
           select
            s.id_solicitud,
            s.id_proceso_wf,
            s.fecha_soli,
            s.numero,
            s.estado,
            s.presu_comprometido
          into 
            v_registros
            
          from adq.tsolicitud s
          where id_proceso_wf = p_id_proceso_wf;
     
          IF p_instrucciones_rpc = '' THEN
              p_instrucciones_rpc =  'Orden de Bien/Servicio';
          END IF;
             
             -- actualiza estado en la solicitud
            
             update adq.tsolicitud  s set 
               id_estado_wf =  p_id_estado_wf,
               estado =p_codigo_estado,
               id_usuario_mod=p_id_usuario,
               fecha_mod=now(),
               instruc_rpc= COALESCE(p_instrucciones_rpc,'Orden de Bien/Servicio')
               
             where id_proceso_wf = p_id_proceso_wf;
    
          
             select 
               te.codigo
             into
               v_estado_anterior
             from wf.testado_wf ew 
             inner join wf.testado_wf eant on ew.id_estado_anterior = eant.id_estado_wf
             inner join wf.ttipo_estado te on te.id_tipo_estado = eant.id_tipo_estado
             where ew.id_estado_wf = p_id_estado_wf;
             
      
             v_sw_presu_comprometido = 'no';
             
             
      
      -- comprometer presupuesto cuando el estado anterior es el vbpresupuestos)
             IF v_estado_anterior =  'vbpresupuesto'  and v_registros.presu_comprometido = 'no' THEN 

              -- Comprometer Presupuesto
              
              
                 IF not adq.f_gestionar_presupuesto_solicitud(v_registros.id_solicitud, p_id_usuario, 'comprometer')  THEN
                 
                   raise exception 'Error al comprometer el presupeusto';
                 
                 END IF;
              
              
              --modifca bandera de comprometido  
           
                   update adq.tsolicitud  s set 
                     presu_comprometido =  'si',
                     fecha_apro = now()
                   where id_solicitud = v_registros.id_solicitud;
                   
                   v_sw_presu_comprometido = 'si';
            
            
            END IF; 
            
           
            
            IF  p_codigo_estado = 'vbrpc' and  ( v_registros.presu_comprometido !=  'si' and  v_sw_presu_comprometido != 'si') THEN
            
                raise exception 'No puede pasar al VoBo del RPC si el presupuesto no esta comprometido, comuniquese con el administrador de sistemas';
            
            END IF;
     
   
   

RETURN   TRUE;



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