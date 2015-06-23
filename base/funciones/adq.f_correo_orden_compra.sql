--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_correo_orden_compra (
  p_id_alarma integer,
  p_id_proceso_wf integer,
  p_id_estado_wf integer
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

	   v_nombre_funcion = 'adq.f_correo_orden_compra';
              
       select
         ala.estado_envio,
         ala.sw_correo
       into
         v_registros
       from param.talarma ala
       where ala.id_alarma = p_id_alarma;
       
       
       IF v_registros.estado_envio = 'bloqueado' and v_registros.sw_correo = 0 THEN
          update adq.tcotizacion set
           correo_oc = 'bloqueado'       
         where id_proceso_wf = p_id_proceso_wf;
       END IF;
       
       IF v_registros.estado_envio = 'exito' and v_registros.sw_correo = 0 THEN
          update adq.tcotizacion set
           correo_oc = 'pendiente'       
         where id_proceso_wf = p_id_proceso_wf;
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