--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_gestionar_presupuesto_solicitud (
  p_id_solicitud_compra integer,
  p_id_usuario integer,
  p_operacion varchar
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Adquisiciones
 FUNCION: 		adq.f_gestionar_presupuesto_solicitud
                
 DESCRIPCION:   Esta funcion a partir del id SOlicitud de COmpra se encarga de gestion el presupuesto,
                compromenter
                revertir
                adcionar comprometido (revertido ne negativo)
 AUTOR: 		Rensi Arteaga Copari
 FECHA:	        25-06-2013
 COMENTARIOS:	
***************************************************************************/

DECLARE
  v_registros record;
  v_nombre_funcion varchar;
  v_resp varchar;
 
  va_id_presupuesto integer[];
  va_id_partida     integer[];
  va_momento		INTEGER[];
  va_monto          numeric[];
  va_id_moneda    	integer[];
  va_id_partida_ejecucion integer[];
  va_columna_relacion     varchar[];
  va_fk_llave             integer[];
  v_i   				  integer;
  v_cont				  integer;
  va_id_solicitud_det	  integer[];
  v_id_moneda_base		  integer;
  va_resp_ges              numeric[];
  
  va_fecha                date[];
  
  
  
                                      
  
  
  
  
BEGIN
 
  v_nombre_funcion = 'adq.f_gestionar_presupuesto_solicitud';
   
  v_id_moneda_base =  param.f_get_moneda_base();
  
      IF p_operacion = 'comprometer' THEN
        
          --compromete al aprobar la solicitud  
           v_i = 0;
           
           -- verifica que solicitud
       
          FOR v_registros in ( 
                            SELECT
                              sd.id_solicitud_det,
                              sd.id_centro_costo,
                              s.id_gestion,
                              s.id_solicitud,
                              sd.id_partida,
                              sd.precio_ga_mb,
                              p.id_presupuesto,
                              s.presu_comprometido
                              
                              FROM  adq.tsolicitud s 
                              INNER JOIN adq.tsolicitud_det sd on s.id_solicitud = sd.id_solicitud
                              inner join pre.tpresupuesto   p  on p.id_centro_costo = sd.id_centro_costo 
                              WHERE  sd.id_solicitud = p_id_solicitud_compra
                                     and sd.estado_reg = 'activo' 
                                     and sd.cantidad > 0 ) LOOP
                                     
                                
                     IF(v_registros.presu_comprometido='si') THEN
                     
                        raise exception 'El presupuesto ya se encuentra comprometido';
                     
                     END IF;
                     
                     v_i = v_i +1;                
                   
                   --armamos los array para enviar a presupuestos          
           
                    va_id_presupuesto[v_i] = v_registros.id_presupuesto;
                    va_id_partida[v_i]= v_registros.id_partida;
                    va_momento[v_i]	= 1; --el momento 1 es el comprometido
                    va_monto[v_i]  = v_registros.precio_ga_mb;
                    va_id_moneda[v_i]  = v_id_moneda_base;
                  
                    va_columna_relacion[v_i]= 'id_solicitud_compra';
                    va_fk_llave[v_i] = v_registros.id_solicitud;
                    va_id_solicitud_det[v_i]= v_registros.id_solicitud_det;
                    va_fecha[v_i]=now()::date;
             
             
             END LOOP;
             
             --llamada a la funcion de compromiso
              va_resp_ges =  pre.f_gestionar_presupuesto(va_id_presupuesto, 
                                                         va_id_partida, 
                                                         va_id_moneda, 
                                                         va_monto, 
                                                         va_fecha, --p_fecha
                                                         va_momento, 
                                                         NULL,--  p_id_partida_ejecucion 
                                                         va_columna_relacion, 
                                                         va_fk_llave);
             
             
             
             --actualizacion de los id_partida_ejecucion en el detalle de solicitud
           
             
             FOR v_cont IN 1..v_i LOOP
             
                
                update adq.tsolicitud_det  s set
                   id_partida_ejecucion = va_resp_ges[v_cont],
                   fecha_mod = now(),
                   id_usuario_mod = p_id_usuario
                where s.id_solicitud_det =  va_id_solicitud_det[v_cont];
             
             
             END LOOP;
            
      
      
      
        ELSEIF p_operacion = 'revertir' THEN
       
       --revierte al revveertir la probacion de la solicitud
       
           v_i = 0;
           
           
           
       
            FOR v_registros in ( SELECT
                              sd.id_solicitud_det,
                              sd.id_centro_costo,
                              s.id_gestion,
                              s.id_solicitud,
                              sd.id_partida,
                              sd.precio_ga_mb,
                              p.id_presupuesto,
                              sd.id_partida_ejecucion
                              
                              FROM  adq.tsolicitud s 
                              INNER JOIN adq.tsolicitud_det sd on s.id_solicitud = sd.id_solicitud
                              inner join pre.tpresupuesto   p  on p.id_centro_costo = sd.id_centro_costo 
                              WHERE  sd.id_solicitud = p_id_solicitud_compra
                                     and sd.estado_reg = 'activo' 
                                     and sd.cantidad > 0 ) LOOP
                                     
                     IF(v_registros.id_partida_ejecucion is NULL) THEN
                     
                        raise exception 'El presupuesto del detalle con el identificador (%)  no se encuntra comprometido',v_registros.id_solicitud_det;
                     
                     END IF;
                     
                     
                     v_i = v_i +1;                
                   
                   --armamos los array para enviar a presupuestos          
           
                    va_id_presupuesto[v_i] = v_registros.id_presupuesto;
                    va_id_partida[v_i]= v_registros.id_partida;
                    va_momento[v_i]	= 2; --el momento 2 con signo positivo es revertir
                    va_monto[v_i]  = (v_registros.precio_ga_mb)*-1;
                    va_id_moneda[v_i]  = v_id_moneda_base;
                    va_id_partida_ejecucion[v_i]= v_registros.id_partida_ejecucion;
                    va_columna_relacion[v_i]= 'id_solicitud_compra';
                    va_fk_llave[v_i] = v_registros.id_solicitud;
                    va_id_solicitud_det[v_i]= v_registros.id_solicitud_det;
                    va_fecha[v_i]=now()::date;
             
             
             END LOOP;
             
             --llamada a la funcion de para reversion
              va_resp_ges =  pre.f_gestionar_presupuesto(va_id_presupuesto, 
                                                         va_id_partida, 
                                                         va_id_moneda, 
                                                         va_monto, 
                                                         va_fecha, --p_fecha
                                                         va_momento, 
                                                         va_id_partida_ejecucion,--  p_id_partida_ejecucion 
                                                         va_columna_relacion, 
                                                         va_fk_llave);
             
       ELSEIF p_operacion = 'revertir_sobrante' THEN
       
       -- revierte el sobrante no adjudicado en el proceso
           
           raise exception 'TO DO';
       
       
       ELSE
       
          raise exception 'Oepracion no implementada';
       
       END IF;
   

  
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