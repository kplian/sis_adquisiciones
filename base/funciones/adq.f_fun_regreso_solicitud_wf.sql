--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_fun_regreso_solicitud_wf (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_estado_wf integer,
  p_id_proceso_wf integer,
  p_codigo_estado varchar
)
RETURNS boolean AS
$body$
/*
*
*  Autor:   RAC
*  DESC:    funcion que actualiza los estados despues del registro de un retroceso 
            en la solicitud de compra, si retrocede a estado borrador controla la  reversion de presupuesto
*  Fecha:   10/06/2013
*
*/

DECLARE

	v_nombre_funcion   	text;
    v_resp    			varchar;
    v_mensaje varchar;
    v_registros record;
   
	
    
BEGIN

	v_nombre_funcion = 'adq.f_fun_regreso_solicitud_wf';
    
        SELECT
              sol.id_solicitud,
              sol.id_estado_wf,
              sol.presu_comprometido,
              pw.id_tipo_proceso,
              pw.id_proceso_wf,
              sol.numero
             into
              v_registros
               
         FROM adq.tsolicitud sol
         inner join wf.tproceso_wf pw on pw.id_proceso_wf = sol.id_proceso_wf
         WHERE  sol.id_proceso_wf = p_id_proceso_wf;
    
         -- actualiza estado en la solicitud
         update adq.tsolicitud  s set 
           id_estado_wf =  p_id_estado_wf,
           estado = p_codigo_estado,
           id_usuario_mod=p_id_usuario,
           fecha_mod=now()
         where id_solicitud = v_registros.id_solicitud;
                 
                 
          --  cuando el estado al que regresa es boorador  o vbpresupuestos, si tiene la bandera de comprometido activada entocnes
          --  revierte presusupesto comprometido
          IF (p_codigo_estado = 'borrador' or p_codigo_estado = 'vbpresupuestos') and v_registros.presu_comprometido ='si'    THEN
                         
               --  llamar a funciond revertir  presupuesto
                            
               IF not adq.f_gestionar_presupuesto_solicitud(v_registros.id_solicitud, p_id_usuario, 'revertir')  THEN
                 
                           raise exception 'Error al revertir  el presupeusto';
                 
               END IF;
                           
                           
             --  modifica bandera de presupuesto comprometido
              update adq.tsolicitud   set 
                 presu_comprometido =  'no',
                 fecha_apro = NULL
               where id_solicitud = v_registros.id_solicitud;

                           
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