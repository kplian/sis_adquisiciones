--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_gestionar_presupuesto_solicitud (
  p_id_solicitud_compra integer,
  p_id_usuario integer,
  p_operacion varchar,
  p_conexion varchar = NULL::character varying
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Adquisiciones
 FUNadq.f_gestionar_presupuesto_solicitud(p_id_solicitud_compra integer, p_id_usuario integer, p_operacion varchar)CION: 		adq.f_gestionar_presupuesto_solicitud
                
 DESCRIPCION:   Esta funcion a partir del id SOlicitud de COmpra se encarga de gestion el presupuesto,
                compromenter
                revertir
                adcionar comprometido (revertido ne negativo)
 AUTOR: 		Rensi Arteaga Copari
 FECHA:	        25-06-2013
 COMENTARIOS:	
 
 ISSUE            FECHA:		      AUTOR       DESCRIPCION
 0				12/10/2017			RAC			Se adciona verificacion pro tipo de centro de costo, segun configuración de control de partidas
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
  
  v_monto_a_revertir 	numeric;
  v_total_adjudicado  	numeric;
  v_aux 				numeric;
  v_comprometido  	    numeric;
  v_comprometido_ga     numeric;
  v_ejecutado     	    numeric;
  
  v_men_presu			varchar;
  v_monto_a_revertir_mb  numeric;
  v_ano_1 integer;
  v_ano_2 integer;
  v_reg_sol						record;
  va_num_tramite				varchar[];
  v_mensage_error				varchar;
  v_sw_error					boolean;
  v_resp_pre 					varchar;  
 v_pre_verificar_categoria 		varchar;
 v_pre_verificar_tipo_cc 		varchar;
 v_control_partida 				varchar;
 v_consulta						varchar;
 v_id_centro_costo				integer;
  

  
BEGIN
 
  v_nombre_funcion = 'adq.f_gestionar_presupuesto_solicitud';
   
  v_id_moneda_base =  param.f_get_moneda_base();
  
  select 
    s.*
  into
   v_reg_sol
  from adq.tsolicitud s
  where s.id_solicitud = p_id_solicitud_compra;
  
  
  
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
                              s.presu_comprometido,
                              s.id_moneda,
                              sd.precio_ga,
                              s.fecha_soli,
                              s.num_tramite as nro_tramite
                              
                              FROM  adq.tsolicitud s 
                              INNER JOIN adq.tsolicitud_det sd on s.id_solicitud = sd.id_solicitud
                              inner join pre.tpresupuesto   p  on p.id_centro_costo = sd.id_centro_costo and sd.estado_reg = 'activo'
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
                    va_monto[v_i]  = v_registros.precio_ga; --RAC Cambio por moneda de la solicitud , v_registros.precio_ga_mb;
                    va_id_moneda[v_i]  = v_registros.id_moneda;        --  RAC Cambio por moneda de la solicitud , v_id_moneda_base;
                  
                    va_columna_relacion[v_i]= 'id_solicitud_compra';
                    va_fk_llave[v_i] = v_registros.id_solicitud;
                    va_id_solicitud_det[v_i]= v_registros.id_solicitud_det;
                    va_num_tramite[v_i] = v_reg_sol.num_tramite;
                    
                    
                   
                    -- la fecha de solictud es la fecha de compromiso 
                    IF  now()  < v_registros.fecha_soli THEN
                      va_fecha[v_i] = v_registros.fecha_soli::date;
                    ELSE
                       -- la fecha de reversion como maximo puede ser el 31 de diciembre   
                       va_fecha[v_i] = now()::date;
                       v_ano_1 =  EXTRACT(YEAR FROM  now()::date);
                       v_ano_2 =  EXTRACT(YEAR FROM  v_registros.fecha_soli::date);
                       
                       IF  v_ano_1  >  v_ano_2 THEN
                         va_fecha[v_i] = ('31-12-'|| v_ano_2::varchar)::date;
                       END IF;
                    END IF;
                    
                   
             
             
             END LOOP;
             
              IF v_i > 0 THEN 
              
                    --llamada a la funcion de compromiso
                    va_resp_ges =  pre.f_gestionar_presupuesto(p_id_usuario,
                    										   NULL, --tipo cambio
                                                               va_id_presupuesto, 
                                                               va_id_partida, 
                                                               va_id_moneda, 
                                                               va_monto, 
                                                               va_fecha, --p_fecha
                                                               va_momento, 
                                                               NULL,--  p_id_partida_ejecucion 
                                                               va_columna_relacion, 
                                                               va_fk_llave,
                                                               va_num_tramite,--nro_tramite
                                                               NULL,
                                                               p_conexion);
                 
                
                 
                 --actualizacion de los id_partida_ejecucion en el detalle de solicitud
               
                 
                   FOR v_cont IN 1..v_i LOOP
                   
                      
                      update adq.tsolicitud_det  s set
                         id_partida_ejecucion = va_resp_ges[v_cont],
                         fecha_mod = now(),
                         id_usuario_mod = p_id_usuario,
                         revertido_mb = 0,     -- inicializa el monto de reversion
                         revertido_mo = 0     -- inicializa el monto de reversion  
                      where s.id_solicitud_det =  va_id_solicitud_det[v_cont];
                   
                     
                   END LOOP;
             END IF;
      
      
      
        ELSEIF p_operacion = 'revertir' THEN
       
       --revierte al revveertir la probacion de la solicitud
       
           v_i = 0;
           v_men_presu = '';
           FOR v_registros in ( 
                            SELECT
                              sd.id_solicitud_det,
                              sd.id_centro_costo,
                              s.id_gestion,
                              s.id_solicitud,
                              sd.id_partida,
                              sd.precio_ga_mb,
                              p.id_presupuesto,
                              sd.id_partida_ejecucion,
                              sd.revertido_mb,
                              sd.revertido_mo,
                              s.id_moneda,
                              sd.precio_ga,
                              s.fecha_soli,
                              s.num_tramite as nro_tramite
                            FROM  adq.tsolicitud s 
                            INNER JOIN adq.tsolicitud_det sd on s.id_solicitud = sd.id_solicitud and sd.estado_reg = 'activo'
                            inner join pre.tpresupuesto   p  on p.id_centro_costo = sd.id_centro_costo 
                            WHERE  sd.id_solicitud = p_id_solicitud_compra
                                     and sd.estado_reg = 'activo' 
                                     and sd.cantidad > 0 ) LOOP
                                     
                     IF(v_registros.id_partida_ejecucion is not  NULL) THEN                     
                       
                           
                           v_comprometido=0;
                           v_ejecutado=0;
                           
                                
                           
                           SELECT 
                                 COALESCE(ps_comprometido,0), 
                                 COALESCE(ps_ejecutado,0)  
                             into 
                                 v_comprometido,
                                 v_ejecutado
                           FROM pre.f_verificar_com_eje_pag(v_registros.id_partida_ejecucion,v_registros.id_moneda);   --  RAC,  v_id_moneda_base);
                           
                           
                           v_monto_a_revertir = COALESCE(v_comprometido,0) - COALESCE(v_ejecutado,0);  
                           
                           
                          --armamos los array para enviar a presupuestos          
                          IF v_monto_a_revertir != 0 THEN
                           
                              v_i = v_i +1;                
                             
                              va_id_presupuesto[v_i] = v_registros.id_presupuesto;
                              va_id_partida[v_i]= v_registros.id_partida;
                              va_momento[v_i]	= 2; --el momento 2 con signo positivo es revertir
                              va_monto[v_i]  = (v_monto_a_revertir)*-1;  -- considera la posibilidad de que a este item se le aya revertido algun monto
                              va_id_moneda[v_i]  = v_registros.id_moneda; -- RAC,  v_id_moneda_base;
                              va_id_partida_ejecucion[v_i]= v_registros.id_partida_ejecucion;
                              va_columna_relacion[v_i]= 'id_solicitud_compra';
                              va_fk_llave[v_i] = v_registros.id_solicitud;
                              va_id_solicitud_det[v_i]= v_registros.id_solicitud_det;
                              va_num_tramite[v_i] = v_reg_sol.num_tramite;
                              
                              
                               -- la fecha de solictud es la fecha de compromiso 
                              IF  now()  < v_registros.fecha_soli THEN
                                va_fecha[v_i] = v_registros.fecha_soli::date;
                              ELSE
                                 -- la fecha de reversion como maximo puede ser el 31 de diciembre   
                                 va_fecha[v_i] = now()::date;
                                 v_ano_1 =  EXTRACT(YEAR FROM  now()::date);
                                 v_ano_2 =  EXTRACT(YEAR FROM  v_registros.fecha_soli::date);
                                 
                                 IF  v_ano_1  >  v_ano_2 THEN
                                   va_fecha[v_i] = ('31-12-'|| v_ano_2::varchar)::date;
                                 END IF;
                              END IF;
                          
                              
                          END IF;
                          
                          
                          v_men_presu = ' comprometido: '||COALESCE(v_comprometido,0)::varchar||'  ejecutado: '||COALESCE(v_ejecutado,0)::varchar||' \n'||v_men_presu;
                          
                     
                   ELSE  
                        raise notice 'El presupuesto del detalle con el identificador (%)  no se encuntra comprometido',v_registros.id_solicitud_det;
                   END IF;
                    
             
             END LOOP;
             
               --raise exception '%', v_men_presu;
             
             --llamada a la funcion de para reversion
               IF v_i > 0 THEN 
                  va_resp_ges =  pre.f_gestionar_presupuesto(p_id_usuario,
                    										 NULL, --tipo cambio
                  											 va_id_presupuesto, 
                                                             va_id_partida, 
                                                             va_id_moneda, 
                                                             va_monto, 
                                                             va_fecha, --p_fecha
                                                             va_momento, 
                                                             va_id_partida_ejecucion,--  p_id_partida_ejecucion 
                                                             va_columna_relacion, 
                                                             va_fk_llave,
                                                             va_num_tramite,--nro_tramite
                                                             NULL,
                                                             p_conexion);
               END IF;
             
       ELSEIF p_operacion = 'revertir_sobrante' THEN
       
       -- revierte el sobrante no adjudicado en el proceso
               
           --1)  lista todos los detalle de las solicitudes agrupatadas por partida y presupeusto
             
            
            v_i = 0;
            FOR v_registros in ( 
                          SELECT
                                      sd.id_solicitud_det,
                                      sd.id_centro_costo,
                                      s.id_gestion,
                                      s.id_solicitud,
                                      sd.id_partida,
                                      p.id_presupuesto,
                                      sd.id_partida_ejecucion,
                                      sd.revertido_mb,
                                      sd.revertido_mo,
                                      sd.precio_ga_mb,
                                      sd.precio_sg_mb,
                                      sd.precio_ga,
                                      sd.precio_sg,
                                      s.id_moneda,
                                      s.tipo,
                                      s.fecha_soli
                                      
                                      FROM  adq.tsolicitud s 
                                      INNER JOIN adq.tsolicitud_det sd on s.id_solicitud = sd.id_solicitud
                                      inner join pre.tpresupuesto   p  on p.id_centro_costo = sd.id_centro_costo
                                      WHERE  sd.id_solicitud = p_id_solicitud_compra
                                             and sd.estado_reg = 'activo' 
                                             and sd.cantidad > 0 
                                             ) LOOP
                                             
                             IF(v_registros.id_partida_ejecucion is NULL) THEN
                             
                                raise exception 'El presupuesto del detalle con el identificador (%)  no se encuntra comprometido',v_registros.id_solicitud_det;
                             
                             END IF;
                             
                             --calculamos el total adudicado
                             v_total_adjudicado = 0;
                             --  suma la adjdicaciones en diferentes solicitudes  (puede no tener ningna adjudicacion)
            
                                    
                             select  sum (cd.cantidad_adju* cd.precio_unitario) into v_total_adjudicado
                             from adq.tcotizacion_det cd
                             where cd.id_solicitud_det = v_registros.id_solicitud_det
                                   and cd.estado_reg = 'activo';
                             
                             
                             v_comprometido_ga=0;
                             v_ejecutado=0;
                             
                             SELECT 
                                   COALESCE(ps_comprometido,0), 
                                   COALESCE(ps_ejecutado,0)  
                               into 
                                   v_comprometido_ga,
                                   v_ejecutado
                             FROM pre.f_verificar_com_eje_pag(v_registros.id_partida_ejecucion, v_registros.id_moneda);
                             
                             
                             v_monto_a_revertir =  v_comprometido_ga - COALESCE(v_total_adjudicado,0);
                             
                             
                             --solo se revierte si el monto es mayor a cero
                             IF v_monto_a_revertir > 0 THEN 
                             
                                 v_i = v_i +1;                
                               
                                -- armamos los array para enviar a presupuestos          
                       
                                va_id_presupuesto[v_i] = v_registros.id_presupuesto;
                                va_id_partida[v_i]= v_registros.id_partida;
                                va_momento[v_i]	= 2; --el momento 2 con signo positivo es revertir
                                va_monto[v_i]  = (v_monto_a_revertir)*-1;
                                va_id_moneda[v_i]  =  v_registros.id_moneda;
                                va_id_partida_ejecucion[v_i]= v_registros.id_partida_ejecucion;
                                va_columna_relacion[v_i]= 'id_solicitud_compra';
                                va_fk_llave[v_i] = v_registros.id_solicitud;
                                va_id_solicitud_det[v_i]= v_registros.id_solicitud_det;
                                
                                
                                
                                 -- la fecha de solictud es la fecha de compromiso 
                                IF  now()  < v_registros.fecha_soli THEN
                                  va_fecha[v_i] = v_registros.fecha_soli::date;
                                ELSE
                                   -- la fecha de reversion como maximo puede ser el 31 de diciembre   
                                   va_fecha[v_i] = now()::date;
                                   v_ano_1 =  EXTRACT(YEAR FROM  now()::date);
                                   v_ano_2 =  EXTRACT(YEAR FROM  v_registros.fecha_soli::date);
                                   
                                   IF  v_ano_1  >  v_ano_2 THEN
                                     va_fecha[v_i] = ('31-12-'|| v_ano_2::varchar)::date;
                                   END IF;
                                END IF;
                                
                                 -- actualizamos  el total revertido
                                 
                                 v_monto_a_revertir_mb= param.f_convertir_moneda(
                                          v_registros.id_moneda, 
                                          NULL,   --por defecto moenda base
                                          v_monto_a_revertir, 
                                          v_registros.fecha_soli, 
                                          'O',-- tipo oficial, venta, compra 
                                          NULL);
                                 
                                 
                                 
                                
                                 UPDATE adq.tsolicitud_det sd set
                                   revertido_mb = revertido_mb + v_monto_a_revertir_mb,
                                   revertido_mo = revertido_mo + v_monto_a_revertir
                                 WHERE  sd.id_solicitud_det = v_registros.id_solicitud_det;
                     
                             END IF; 
                             
                             
                     END LOOP;
                     
                   
                     
                       IF v_i > 0 THEN                  
                     
                       --llamada a la funcion de para reversion
                        va_resp_ges =  pre.f_gestionar_presupuesto(p_id_usuario,
                    										       NULL, --tipo cambio
                                                                   va_id_presupuesto, 
                                                                   va_id_partida, 
                                                                   va_id_moneda, 
                                                                   va_monto, 
                                                                   va_fecha, --p_fecha
                                                                   va_momento, 
                                                                   va_id_partida_ejecucion,--  p_id_partida_ejecucion 
                                                                   va_columna_relacion, 
                                                                   va_fk_llave,
                                                                   v_reg_sol.num_tramite,--nro_tramite
                                                                   NULL,
                                                                   p_conexion);
                      END IF;
       
       ELSIF p_operacion = 'verificar' THEN
        
           --verifica si tenemos suficiente presupeusto para comprometer
          v_i = 0;
          v_mensage_error = '';
          v_sw_error = false;
           
           
          v_pre_verificar_categoria = pxp.f_get_variable_global('pre_verificar_categoria');
          v_pre_verificar_tipo_cc = pxp.f_get_variable_global('pre_verificar_tipo_cc');
          v_control_partida = 'si'; --por defeto controlamos los monstos por partidas 
          
          IF   v_pre_verificar_categoria = 'si' THEN
          
            		-- verifica  por categoria programatica     
                      FOR v_registros in (
                                         SELECT                                   
                                            p.id_categoria_prog ,
                                            s.id_gestion,
                                            s.id_solicitud,
                                            sd.id_partida,
                                            sum(sd.precio_ga_mb) as precio_ga_mb,                                   
                                            s.id_moneda,
                                            sum(sd.precio_ga) as precio_ga,
                                            par.codigo,
                                            par.nombre_partida,
                                            p.codigo_cc,
                                           pxp.aggarray(p.id_centro_costo) AS id_centro_costos 
                                          FROM  adq.tsolicitud s 
                                          INNER JOIN adq.tsolicitud_det sd on s.id_solicitud = sd.id_solicitud
                                          inner join pre.tpartida par on par.id_partida = sd.id_partida
                                          inner join pre.vpresupuesto_cc   p  on p.id_centro_costo = sd.id_centro_costo and sd.estado_reg = 'activo'
                                          WHERE  sd.id_solicitud = p_id_solicitud_compra
                                                 and sd.estado_reg = 'activo' 
                                                 and sd.cantidad > 0
                                          
                                          group by 
                                          
                                          p.id_categoria_prog,
                                          s.id_gestion,
                                          s.id_solicitud,
                                          sd.id_partida,                             
                                          s.id_moneda,
                                          par.codigo,
                                          par.nombre_partida,
                                           p.codigo_cc ) 
                                      LOOP
                                             
                                          select  
                                                sd.id_centro_costo
                                            INTO
                                                v_id_centro_costo
                                          from  adq.tsolicitud_det sd
                                          where  sd.id_solicitud = p_id_solicitud_compra
                                          limit 1 offset 0;   
                                            
                                          v_resp_pre = pre.f_verificar_presupuesto_partida ( v_registros.id_centro_costos[1],
                                                                    v_registros.id_partida,
                                                                    v_registros.id_moneda,
                                                                    v_registros.precio_ga);
                                                                    
                                                                    
                                          IF   v_resp_pre = 'false' THEN        
                                               v_mensage_error = v_mensage_error||format('Presupuesto:  %s, partida (%s) %s <BR/>', v_registros.codigo_cc, v_registros.codigo,v_registros.nombre_partida);    
                                               v_sw_error = true;
                                          
                                          END IF;                         
                               
                         
                         
                         END LOOP;
          
                     
          
          
          
          ELSE
          
              IF   v_pre_verificar_tipo_cc = 'si' THEN
                  
                   --la verificacion sea por tipo de centro de costo del tipo techo, ademas se verifica si es necesario validar por partida 
                 
                   FOR v_registros in (SELECT                                   
                                          tcc.id_tipo_cc_techo, 
                                          s.id_gestion,
                                          s.id_solicitud,     
                                          sum(sd.precio_ga_mb) as precio_ga_mb,                                   
                                          s.id_moneda,
                                          sum(sd.precio_ga) as precio_ga,                                         
                                          tcc.codigo_techo,
                                          CASE
                                             WHEN  tcc.control_partida::text = 'no' THEN
                                                0
                                            ELSE 
                                              sd.id_partida
                                         END AS id_par,
                                         CASE
                                             WHEN  tcc.control_partida::text = 'no' THEN
                                                'No se considera partida'::varchar
                                            ELSE 
                                               par.nombre_partida
                                         END AS nombre_partida_desc,
                                         pxp.aggarray(p.id_centro_costo) AS id_centro_costos 
                                        FROM  adq.tsolicitud s 
                                        INNER JOIN adq.tsolicitud_det sd on s.id_solicitud = sd.id_solicitud
                                        inner join pre.tpartida par on par.id_partida = sd.id_partida
                                        --inner join pre.vpresupuesto_cc   p  on p.id_centro_costo = sd.id_centro_costo and sd.estado_reg = 'activo'
                                        JOIN param.tcentro_costo p ON p.id_centro_costo = sd.id_centro_costo and sd.estado_reg = 'activo'
                                        JOIN param.vtipo_cc_techo tcc ON tcc.id_tipo_cc = p.id_tipo_cc
                                        WHERE  sd.id_solicitud =  p_id_solicitud_compra
                                               and sd.estado_reg = 'activo' 
                                               and sd.cantidad > 0
                                                                              
                                        group by 
                                                                              
                                       tcc.id_tipo_cc_techo, 
                                       tcc.control_partida,
                                       s.id_gestion,
                                       s.id_solicitud,
                                       id_par,                             
                                       s.id_moneda,
                                       nombre_partida_desc,
                                       tcc.codigo_techo) 
                            LOOP
                                          
                                            
                                          v_resp_pre = pre.f_verificar_presupuesto_partida ( v_registros.id_centro_costos[1],
                                                                    v_registros.id_par,
                                                                    v_registros.id_moneda,
                                                                    v_registros.precio_ga);
                                                                    
                                                                    
                                          IF   v_resp_pre = 'false' THEN        
                                               v_mensage_error = v_mensage_error||format('Presupuesto:  %s,  (%s)  <BR/>', v_registros.codigo_techo, v_registros.nombre_partida_desc);    
                                               v_sw_error = true;
                                          
                                          END IF;                         
                               
                         
                         
                         END LOOP;
                    
                   
              
              
              ELSE
              
                  -- Laverificaion es sencilla por presupeusto y por partida
                   FOR v_registros in (SELECT
                                                sd.id_centro_costo,
                                                s.id_gestion,
                                                s.id_solicitud,
                                                sd.id_partida,
                                                sum(sd.precio_ga_mb) as precio_ga_mb,
                                                p.id_presupuesto,
                                                s.id_moneda,
                                                sum(sd.precio_ga) as precio_ga,
                                                par.codigo,
                                                par.nombre_partida,
                                                p.codigo_cc
                                                
                                                                
                                          FROM  adq.tsolicitud s 
                                          INNER JOIN adq.tsolicitud_det sd on s.id_solicitud = sd.id_solicitud
                                          inner join pre.tpartida par on par.id_partida = sd.id_partida
                                          inner join pre.vpresupuesto_cc   p  on p.id_centro_costo = sd.id_centro_costo and sd.estado_reg = 'activo'
                                          WHERE  sd.id_solicitud = p_id_solicitud_compra
                                                 and sd.estado_reg = 'activo' 
                                                 and sd.cantidad > 0
                                          
                                          group by 
                                          
                                          sd.id_centro_costo,
                                          s.id_gestion,
                                          s.id_solicitud,
                                          sd.id_partida,
                                          p.id_presupuesto,
                                          s.id_moneda,
                                          par.codigo,
                                          par.nombre_partida,
                                          p.codigo_cc) 
                            LOOP
                                             
                                          select  
                                                sd.id_centro_costo
                                            INTO
                                                v_id_centro_costo
                                          from  adq.tsolicitud_det sd
                                          where  sd.id_solicitud = p_id_solicitud_compra;   
                                            
                                          v_resp_pre = pre.f_verificar_presupuesto_partida ( v_id_centro_costo,
                                                                    v_registros.id_partida,
                                                                    v_registros.id_moneda,
                                                                    v_registros.precio_ga);
                                                                    
                                                                    
                                          IF   v_resp_pre = 'false' THEN        
                                               v_mensage_error = v_mensage_error||format('Presupuesto:  %s, partida (%s) %s <BR/>', v_registros.codigo_cc, v_registros.codigo,v_registros.nombre_partida);    
                                               v_sw_error = true;
                                          
                                          END IF;                         
                               
                         
                         
                         END LOOP;
                  
                 
          
              END IF;
          END IF;
         
          
             
             
             IF v_sw_error THEN
                 raise exception 'No se tiene suficiente presupeusto para; <BR/>%', v_mensage_error;
             END IF;
              
       
             return TRUE;
       
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