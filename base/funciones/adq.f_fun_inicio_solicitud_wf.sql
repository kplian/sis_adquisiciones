--------------- SQL ---------------

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

	v_nombre_funcion   		text;
    v_resp    				varchar;
    v_mensaje 				varchar;
    
    v_registros record;
    v_monto_ejecutar_mo 	 numeric;
    v_estado_anterior		 varchar;
    v_sw_presu_comprometido	 varchar;
    v_total_soli				numeric;
    v_tope_compra 				numeric;
    v_tope_compra_lista			varchar;
    v_adq_comprometer_presupuesto		varchar;
   
	
    
BEGIN

	 v_nombre_funcion = 'adq.f_fun_inicio_solicitud_wf';
     v_adq_comprometer_presupuesto = pxp.f_get_variable_global('adq_comprometer_presupuesto');
  
     
           select
            s.id_solicitud,
            s.id_proceso_wf,
            s.fecha_soli,
            s.numero,
            s.estado,
            s.presu_comprometido,
            uo.codigo as codigo_uo,
            dep.prioridad,
            uo.codigo as codigo_uo
          into 
            v_registros
            
          from adq.tsolicitud s
          inner join orga.tuo uo on uo.id_uo = s.id_uo
          inner join param.tdepto dep on dep.id_depto = s.id_depto
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
             
              select 
              sum( COALESCE( sd.precio_ga_mb,0)  + COALESCE(sd.precio_sg_mb,0)) 
              into  
              v_total_soli
              from adq.tsolicitud_det sd
              where sd.id_solicitud = v_registros.id_solicitud
              and sd.estado_reg = 'activo';
                  
              v_total_soli =  COALESCE(v_total_soli,0);
             
             
             
             --valida que no se compre por encima de 40 000 en la regionales
             v_tope_compra = pxp.f_get_variable_global('adq_tope_compra_regional')::integer;
              
             IF v_tope_compra is NULL THEN
                raise exception 'revise la configuracion globa de la variable adq_tope_compra_regional para compras en regioanles no puede ser nula';
             END IF;
           
             IF  v_registros.prioridad = 2 and  (v_total_soli  >= v_tope_compra and v_tope_compra != 0)   THEN
                 raise exception 'Las compras en las regionales no pueden estar por encima de % (moneda base)',v_tope_compra;
             END IF;
            
                  
             -- validamos que el monsto de la oslicitud no supere el tope configurado
             v_tope_compra = pxp.f_get_variable_global('adq_tope_compra')::numeric; 
             v_tope_compra_lista = pxp.f_get_variable_global('adq_tope_compra_lista_blanca');
             
             IF v_tope_compra is NULL or  v_tope_compra_lista is NULL THEN
                raise exception 'revise la configuracion global de la variable adq_tope_compra y adq_tope_compra_lista_blanca  no pueden ser nulas';
             END IF;
             
             --raise exception '%', v_registros_sol.codigo_uo;
            IF  v_total_soli  >= v_tope_compra  and (v_registros.codigo_uo != ANY( string_to_array(v_tope_compra_lista,',')))  THEN
              raise exception 'Las compras por encima de % (moneda base) no pueden realizarse  por el sistema de adquisiciones',v_tope_compra;
            END IF;
            
      
          -- comprometer presupuesto cuando el estado anterior es el vbpresupuestos)
             IF v_estado_anterior =  'vbpresupuestos'  and v_registros.presu_comprometido = 'no' and v_adq_comprometer_presupuesto = 'si' THEN 

               -- como en presupeustos puede mover los montos validamos que nose pase del monto tope
                   select 
                      sum( COALESCE( sd.precio_ga_mb,0)  + COALESCE(sd.precio_sg_mb,0)) 
                    into  
                      v_total_soli
                    from adq.tsolicitud_det sd
                    where sd.id_solicitud = v_registros.id_solicitud
                    and sd.estado_reg = 'activo';
                  
                  v_total_soli =  COALESCE(v_total_soli,0);
                  
                  
                  IF  v_total_soli = 0  THEN
                    raise exception ' La Solicitud  tiene que ser por un valor mayor a 0';
                  END IF;
                  
                  
              
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
            
            
            --RAC 11/08/2017  
           -- si llega al estado aprobacion y el presupeusto todavia noe sta comprometido, y el sistema esta configurado para comproemter,
           -- comprometemos  
            IF p_codigo_estado = 'aprobado' and v_registros.presu_comprometido = 'no' and v_adq_comprometer_presupuesto = 'si' THEN
                  
                  -- Comprometer Presupuesto                  
                  IF not adq.f_gestionar_presupuesto_solicitud( v_registros.id_solicitud, p_id_usuario, 'comprometer')  THEN                     
                       raise exception 'Error al comprometer el presupeusto';                     
                  END IF;

                  --modifca bandera de comprometido  
                   update adq.tsolicitud  s set 
                        presu_comprometido =  'si',
                        fecha_apro = now()
                   where id_solicitud =  v_registros.id_solicitud;
                   
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