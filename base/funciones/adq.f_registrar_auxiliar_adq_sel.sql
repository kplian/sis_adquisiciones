--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_registrar_auxiliar_adq (
  p_id_usuario integer,
  p_id_depto_usuario integer,
  p_id_solicitud integer
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA ENDESIS - SISTEMA DE ...
***************************************************************************
 SCRIPT: 		adq.f_registrar_auxiliar_adq
 DESCRIPCIÓN: 	asigna un usuario auxiliar al proceso de compra
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
    v_registros       record;
    v_id_usuario   integer;
    v_id_alarma    integer;
    

BEGIN
   v_nombre_funcion ='adq.f_registrar_auxiliar_adq';
   v_resp = 'false';
   
           select 
             id_usuario
            into
             v_id_usuario 
            from param.tdepto_usuario d 
            where d.id_depto_usuario =  p_id_depto_usuario;
            
           select 
             sol.num_tramite,
             sol.numero,
             f.desc_funcionario1
           into 
            v_registros
           
           from adq.tsolicitud sol
           inner join orga.vfuncionario f on f.id_funcionario = sol.id_funcionario 
           where sol.id_solicitud = p_id_solicitud ;
        
          
        
        --inserta alarma cuando se afigna a un auxiliar
        
         v_id_alarma = param.f_inserta_alarma(
                                    NULL::integer,
                                    'Usted fue asignado a la solicitud de compra: '||v_registros.numero||'('||v_registros.desc_funcionario1||') del tramite '||v_registros.num_tramite,    --descripcion alarmce
                                    '../../../sis_adquisiciones/vista/proceso_compra/ProcesoCompra.php',--acceso directo
                                    now()::date,
                                    'notificacion',
                                    'Asignacion de proceso de compra',  --asunto
                                    p_id_usuario,
                                    'ProcesoCompra', --clase
                                    'Proceso de compra',--titulo
                                    '{filtro_directo:{campo:"id_solicitud",valor:"'||p_id_solicitud::varchar||'"}}',
                                    v_id_usuario, --usuario a quien va dirigida la alarma
                                    'Asignacion de proceso de compra'
                                   );
            
            
            
            --Sentencia de la modificacion
			update adq.tproceso_compra set
			id_usuario_auxiliar = v_id_usuario,
            id_usuario_mod = p_id_usuario
            where id_solicitud=p_id_solicitud;
  
            v_resp = 'true';
     
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