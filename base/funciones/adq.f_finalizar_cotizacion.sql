--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_finalizar_cotizacion (
  p_id_cotizacion integer,
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Adquisiciones
 FUNCION: 		adq.f_finalizar_cotizacion
                
 DESCRIPCION:   Esta funciona camba de estado la cotizacion selecionado llevandola al estado finalizado
                es requisot para finalizar el proceso
 AUTOR: 		Rensi Arteaga Copari
 FECHA:	        08-07-2013
 COMENTARIOS:	
***************************************************************************/

DECLARE
  v_registros record;
  v_nombre_funcion varchar;
  v_resp varchar;
 
  v_id_estado_wf    integer;
  v_id_proceso_wf   integer;
  v_estado_cot      varchar;
  v_id_depto        integer;
  v_id_tipo_estado  integer;
  v_id_estado_actual integer;
  

  
BEGIN
 
  v_nombre_funcion = 'adq.f_finalizar_cotizacion';
   
 
  
    --recupepramos datos de la cotizacion
            
            SELECT
              c.id_estado_wf,
              c.id_proceso_wf,
              c.estado,
              pc.id_depto
            into
              v_id_estado_wf,
              v_id_proceso_wf,
              v_estado_cot,
              v_id_depto
            from adq.tcotizacion c
            inner join adq.tproceso_compra pc on pc.id_proceso_compra = c.id_proceso_compra
            where  c.id_cotizacion = p_id_cotizacion;
            
            
            
            -- preguntamos por los estados validos para anular 
            
            IF  v_estado_cot = 'pago_habilitado'  THEN
            
               --recuperamos el id_tipo_proceso en el WF para el estado anulado
               --ya que este es un estado especial que no tiene padres definidos
               
               
               select 
               	te.id_tipo_estado
               into
               	v_id_tipo_estado
               from wf.tproceso_wf pw 
               inner join wf.ttipo_proceso tp on pw.id_tipo_proceso = tp.id_tipo_proceso
               inner join wf.ttipo_estado te on te.id_tipo_proceso = tp.id_tipo_proceso and te.codigo = 'finalizada'               
               where pw.id_proceso_wf = v_id_proceso_wf;
               
              
              
               -- pasamos la cotizacion al siguiente estado
           
               v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado, 
                                                           NULL, 
                                                           v_id_estado_wf, 
                                                           v_id_proceso_wf,
                                                           p_id_usuario,
                                                           p_id_usuario_ai,
                                                           p_usuario_ai,
                                                           v_id_depto);
            
            
               -- actualiza estado en la cotizacion
              
               update adq.tcotizacion  c set 
                 id_estado_wf =  v_id_estado_actual,
                 estado = 'finalizada',
                 id_usuario_mod=p_id_usuario,
                 fecha_mod=now(),
                 id_usuario_ai = p_id_usuario_ai,
                 usuario_ai = p_usuario_ai
               where c.id_cotizacion  = p_id_cotizacion;
               
              
            
            ELSE
            
                 raise exception 'solo se puede finalizar cotizaciones en estado "pago_habilitado"';
            
            
            END IF;
            
           
            --Devuelve la respuesta
            return TRUE;  

  
  return  TRUE;


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