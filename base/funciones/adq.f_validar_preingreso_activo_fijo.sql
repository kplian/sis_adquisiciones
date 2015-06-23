--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_validar_preingreso_activo_fijo (
  p_id_usuario integer,
  p_id_proceso_wf integer
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA ENDESIS - SISTEMA DE ...
***************************************************************************
 SCRIPT: 		adq.f_validar_preingreso_activo_fijo
 DESCRIPCIÓN: 	Verifica si la cotizacion tiene items almacenables para generar el preingreso de activos fijos
 AUTOR: 		Rensi Arteaga Copari
 FECHA:			29/4/2014
 COMENTARIOS:	
***************************************************************************
 HISTORIA DE MODIFICACIONES:

 DESCRIPCIÓN:
 AUTOR:       
 FECHA:      

***************************************************************************/

-------------------------
-- CUERPO DE LA FUNCIÓN --
--------------------------

-- PARÁMETROS FIJOS


DECLARE
	v_resp            varchar;
    v_nombre_funcion  varchar;
    v_id_cotizacion   integer;
    

BEGIN
  v_nombre_funcion ='adq.f_validar_preingreso_activo_fijo';
  
  select 
    c.id_cotizacion
  into
    v_id_cotizacion
  from adq.tcotizacion c
  where  c.id_proceso_wf = p_id_proceso_wf;
  
   v_resp = 'false';
  
   --Verifica que en el detalle de la cotización existan item adjudicados y  almacenables
   if exists(select 1
                  from adq.tcotizacion_det cdet
                  inner join adq.tsolicitud_det sdet
                  on sdet.id_solicitud_det = cdet.id_solicitud_det
                  inner join param.tconcepto_ingas cin
                  on cin.id_concepto_ingas = sdet.id_concepto_ingas
                  where cdet.id_cotizacion = v_id_cotizacion
                    and cdet.estado_reg = 'activo'
                    and cdet.cantidad_adju > 0
                    and lower(cin.tipo) = 'bien'
                    and lower(cin.activo_fijo) = 'si' 
                    and lower(cin.almacenable) = 'no') then
      
         v_resp = 'true';
    
    end if;
    
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