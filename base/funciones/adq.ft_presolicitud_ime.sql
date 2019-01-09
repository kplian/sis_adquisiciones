--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.ft_presolicitud_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.ft_presolicitud_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'adq.tpresolicitud'
 AUTOR: 		 (admin)
 FECHA:	        10-05-2013 05:03:41
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
ISSUE		FECHA:	         AUTOR:				 DESCRIPCION:	
#1			11/12/2018		 EGS				 Se modifico las funciones para que cuando consolide inserte con las validaciones en la funcion de insertar detalle de la solicitud ime
												 y al eliminar pase a estado inactivo
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_presolicitud	    integer;
    v_registros    		    record;
    v_estado  				varchar;
    v_consulta  			varchar;
    v_id_partida 			integer; 
    v_id_cuenta 			integer; 
    v_id_auxiliar   		integer;
    v_id_solicitud_det 		integer;
    v_aux 					varchar;
    v_registros_pre 		record;

    v_id_gestion 			integer;
    v_count_det  			integer;
    v_record_solicitud_det	record;
    v_existe_detalle		boolean;
    
    v_codigo_trans				varchar;
    v_tabla						varchar;
    v_precio_total			numeric;
    v_precio_ga				numeric;
    v_cantidad				integer;
    v_record_cig			record;
    v_record_solicitud	record;

			    
BEGIN

    v_nombre_funcion = 'adq.ft_presolicitud_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_PRES_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		10-05-2013 05:03:41
	***********************************/

	if(p_transaccion='ADQ_PRES_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into adq.tpresolicitud(
			id_grupo,
			id_funcionario_supervisor,
			id_funcionario,
			estado_reg,
			obs,
			id_uo,
			estado,
		
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod,
            fecha_soli,
            id_depto,
            id_gestion
          	) values(
			v_parametros.id_grupo,
			v_parametros.id_funcionario_supervisor,
			v_parametros.id_funcionario,
			'activo',
			v_parametros.obs,
			v_parametros.id_uo,
			'borrador',
		
			now(),
			p_id_usuario,
			null,
			null,
            v_parametros.fecha_soli,
            v_parametros.id_depto,
            v_parametros.id_gestion
							
			)RETURNING id_presolicitud into v_id_presolicitud;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Presolicitud almacenado(a) con exito (id_presolicitud'||v_id_presolicitud||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presolicitud',v_id_presolicitud::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_PRES_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		10-05-2013 05:03:41
	***********************************/

	elsif(p_transaccion='ADQ_PRES_MOD')then

		begin
			--Sentencia de la modificacion
			update adq.tpresolicitud set
			id_grupo = v_parametros.id_grupo,
			id_funcionario_supervisor = v_parametros.id_funcionario_supervisor,
			id_funcionario = v_parametros.id_funcionario,
			obs = v_parametros.obs,
			id_uo = v_parametros.id_uo,
			
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
            id_depto=  v_parametros.id_depto
            
			where id_presolicitud=v_parametros.id_presolicitud;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Presolicitud modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presolicitud',v_parametros.id_presolicitud::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_PRES_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		10-05-2013 05:03:41
	***********************************/

	elsif(p_transaccion='ADQ_PRES_ELI')then

		begin
        	--verificando si tiene detalles la presolicitud
            IF (Select
            	count(pred.id_presolicitud_det)
            from adq.tpresolicitud_det pred
            where pred.id_presolicitud = v_parametros.id_presolicitud)<> 0 THEN
             Raise Exception 'La presolicitud  no puede ser eliminada revise que no tenga detalle';
            END IF; 
            
            UPDATE adq.tpresolicitud
            Set estado_reg = 'inactivo',
            	id_usuario_mod = p_id_usuario
            where id_presolicitud = v_parametros.id_presolicitud;
            /*
			--Sentencia de la eliminacion
			delete from adq.tpresolicitud
            where id_presolicitud = v_parametros.id_presolicitud;
               */
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Presolicitud eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presolicitud',v_parametros.id_presolicitud::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
        
        
     /*********************************    
 	#TRANSACCION:  'ADQ_FINPRES_IME'
 	#DESCRIPCION:	Finalizacion de presolicitud
 	#AUTOR:		admin	
 	#FECHA:		10-05-2013 05:03:41
	***********************************/

	elsif(p_transaccion='ADQ_FINPRES_IME')then

		begin
			--Sentencia de la eliminacion
			
            select
            pre.estado
            into 
            v_registros 
            from adq.tpresolicitud pre
            where pre.id_presolicitud = v_parametros.id_presolicitud;
            
            IF v_registros.estado != 'borrador' THEN
            
               raise exception 'Solo puede finalizar registros en borrador';
            
            END IF;
            
            --validar que tenga items en la solicitud
            
            
            select 
              count(pd.id_presolicitud_det)
            into
              v_count_det
            from adq.tpresolicitud_det pd
            where pd.id_presolicitud = v_parametros.id_presolicitud 
                  and pd.estado_reg = 'activo';
            
            
            IF  v_count_det = 0  THEN
            
               raise exception 'La presolictud tiene elementos...';
            
            END IF;
            
            
            update adq.tpresolicitud 
            set
            estado = 'pendiente',
            id_usuario_mod = p_id_usuario,
            fecha_mod = now()
            where id_presolicitud = v_parametros.id_presolicitud;
            
            
            
            
            
            
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Presolictud enviada para aprobacion'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presolicitud',v_parametros.id_presolicitud::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;  
    
      /*********************************    
 	#TRANSACCION:  'ADQ_RETPRES_IME'
 	#DESCRIPCION:	retroceder presolicitud
 	#AUTOR:		admin	
 	#FECHA:		10-05-2013 05:03:41
	***********************************/

	elsif(p_transaccion='ADQ_RETPRES_IME')then

		begin
			--Sentencia de la eliminacion
            
            
            IF  v_parametros.estado = 'aprobado' THEN
            
              v_estado = 'pendiente';
            
            ELSEIF  v_parametros.estado = 'pendiente' THEN
              
              v_estado = 'borrador';
              
            ELSEIF  v_parametros.estado = 'asignado' THEN
              
              v_estado = 'aprobado';  
              
            
            ELSEIF  v_parametros.estado = 'borrador' THEN
            
               raise exception 'No puede retroceder el estado borrador' ;  
            
            ELSE
              
              raise exception 'Estado no identificado';
            
            END IF;
			
            
          
            
            select
            pre.estado
            into 
            v_registros 
            from adq.tpresolicitud pre
            where pre.id_presolicitud = v_parametros.id_presolicitud;
            
            
            
            update adq.tpresolicitud 
            set
            estado = v_estado::varchar,
            id_usuario_mod = p_id_usuario,
            fecha_mod = now()
            where id_presolicitud = v_parametros.id_presolicitud;
            
            
            
            -- if si el estado al que retorna es de aporobado verifica el detalle y las libera
            
            IF v_estado = 'aprobado' THEN
            
              update adq.tpresolicitud_det 
              set
              estado = 'pendiente',
              id_usuario_mod = p_id_usuario,
              fecha_mod = now()
              where id_presolicitud = v_parametros.id_presolicitud;
                 
            
            END IF;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Retrocede el estado de presolicitud a '||v_estado::varchar); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presolicitud',v_parametros.id_presolicitud::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;  
        
         /*********************************    
 	#TRANSACCION:  'ADQ_APRPRES_IME'
 	#DESCRIPCION:	aprobar  presolicitud
 	#AUTOR:		admin	
 	#FECHA:		10-05-2013 05:03:41
	***********************************/

	elsif(p_transaccion='ADQ_APRPRES_IME')then

		begin
			--Sentencia de la eliminacion
            
           
          IF  v_parametros.operacion = 'aprobado' or  v_parametros.operacion='finalizado' THEN 
        
           v_estado =  v_parametros.operacion;
            
          ELSE
          
            raise exception 'estado no reconocido';
          END IF;
          
          
            select
            pre.estado
            into 
            v_registros 
            from adq.tpresolicitud pre
            where pre.id_presolicitud = v_parametros.id_presolicitud;
            
            
            
            IF v_registros.estado != 'pendiente' and  v_registros.estado != 'asignado' THEN
            
               raise exception 'EL estado precedente no corresponde con lo esperado (pendiente o asignado)';
            
            END IF;
            
            update adq.tpresolicitud 
            set
            estado = v_estado,
            id_usuario_reg = p_id_usuario,
            id_usuario_mod = p_id_usuario,
            fecha_mod = now()
            where id_presolicitud = v_parametros.id_presolicitud;
            
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','cambio de estado de presolicitud ('||v_estado::varchar||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presolicitud',v_parametros.id_presolicitud::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;  
    /*********************************    
 	#TRANSACCION:  'ADQ_CONSOL_IME'
 	#DESCRIPCION:	consolida presolicitudes
 	#AUTOR:		rac	
 	#FECHA:		15-05-2013 05:03:41
	***********************************/

	elsif(p_transaccion='ADQ_CONSOL_IME')then

		begin
			
           --validar solilctud
           
           select
            s.estado,
            s.id_depto,
            s.id_gestion,
            s.tipo
            into 
            v_record_solicitud 
            from adq.tsolicitud s
            where s.id_solicitud = v_parametros.id_solicitud;
            

            v_id_gestion = v_record_solicitud.id_gestion;

            
            IF v_record_solicitud.estado != 'borrador' THEN
            
               raise exception 'La solictud de compra bede estar en estado borrador para consolidar, actualice su interface de solicitudes';
            
            END IF;
           
           
           
            select
            pre.estado,
            pre.id_depto
            into 
            v_registros_pre 
            from adq.tpresolicitud pre
            where pre.id_presolicitud = v_parametros.id_presolicitud;
            
            
            
            IF v_registros_pre.estado != 'aprobado' and v_registros_pre.estado != 'asignado' THEN
            
               raise exception 'Solo pueden consolidarce presolicitudes aprobadas';
            
            END IF;
            
            IF v_registros_pre.id_depto != v_record_solicitud.id_depto   THEN
            
             
               raise exception 'Solo puede consolidar presolicitudes del mismo departamento que la solicitud';
            
            
            END IF;
            
            
        
        v_aux = COALESCE(v_parametros.id_presolicitud_dets,'0');
       
        IF v_aux = '' THEN
           v_aux = 0;
        END IF;
        
           v_existe_detalle = false;
           v_consulta = 'select
             pd.id_presolicitud_det,
             pd.id_centro_costo,
             pd.id_concepto_ingas,
             pd.descripcion,
             pd.cantidad,
             pd.precio,
             pd.estado    
            from adq.tpresolicitud_det pd
            where pd.id_presolicitud = '||v_parametros.id_presolicitud||'
               and pd.estado_reg = ''activo'' and
                   pd.id_presolicitud_det in ('||v_aux||')';
        
           --raise exception '%',v_consulta;
        	
           FOR  v_registros in  execute(v_consulta) LOOP
           		  --recuperamos el tipo de la solicitud
           		  Select
                       congas.tipo
                  INTO
                       v_record_cig
                  From param.tconcepto_ingas congas
                  Where congas.id_concepto_ingas = v_registros.id_concepto_ingas ;
                  
                  --si los tipos son diferentes no deberia insertar
                  IF  UPPER(v_record_solicitud.tipo) <> UPPER(v_record_cig.tipo)  THEN
                         	raise exception 'El tipo de la Solicitud (%) es diferente al tipo del detalle de la Presolicitud(%)',v_record_solicitud.tipo,v_record_cig.tipo;
                  END IF; 			
           
           			
                  SELECT 
                    ps_id_partida ,
                    ps_id_cuenta,
                    ps_id_auxiliar
                  into 
                    v_id_partida,
                    v_id_cuenta, 
                    v_id_auxiliar

                FROM conta.f_get_config_relacion_contable('CUECOMP', v_id_gestion, v_registros.id_concepto_ingas, v_registros.id_centro_costo);
				-- #1	1/12/2018		 EGS	
              	-- Inserta el detalle a la solicitud  
                FOR v_record_solicitud_det IN(
                	Select
                    sold.id_solicitud_det,
                    sold.id_centro_costo,
                    sold.id_concepto_ingas,
                    sold.precio_unitario,
                    sold.cantidad,
                    sold.precio_unitario
               	    from adq.tsolicitud_det sold
                    where sold.estado_reg = 'activo' AND sold.id_solicitud = v_parametros.id_solicitud
				  ) LOOP   
                  	          
        			
                      ---si es de igual centro de costo,precio y concepto de gasto a un detalle de la solicitud se actualiza sumando solo las cantidades
                      IF v_record_solicitud_det.id_centro_costo = v_registros.id_centro_costo  and 
                         v_record_solicitud_det.id_concepto_ingas = v_registros.id_concepto_ingas  and
                         v_record_solicitud_det.precio_unitario = v_registros.precio	 THEN
                         
                        
                          
                         v_cantidad =  v_record_solicitud_det.cantidad + v_registros.cantidad;
                         v_precio_total = (v_record_solicitud_det.cantidad + v_registros.cantidad)*v_record_solicitud_det.precio_unitario;
                         v_precio_ga = (v_record_solicitud_det.cantidad + v_registros.cantidad)*v_record_solicitud_det.precio_unitario;
                         
                         v_codigo_trans ='ADQ_SOLD_MOD';
           				 v_tabla = pxp.f_crear_parametro(ARRAY[	
                         				'id_solicitud_det',
                                    	'id_centro_costo',
                                        'descripcion',
                                        'precio_unitario',
                                        'id_solicitud',
                                        'id_orden_trabajo',
                                        'precio_sg',
                                        'precio_ga',
                                        'id_concepto_ingas',
                                        'precio_total',
                                        'cantidad_sol',
                                        'estado_reg'
                           			
                                                ],
                                        ARRAY[	
                                        v_record_solicitud_det.id_solicitud_det::varchar,--'id_solicitud_det'
                                        v_registros.id_centro_costo::varchar,--'id_centro_costo'
                                        ''::varchar,--'descripcion'
                                        v_registros.precio::varchar,--'precio_unitario'
                                        v_parametros.id_solicitud::varchar,--'id_solicitud'
                                        ''::varchar,--'id_orden_trabajo'
                                        0::varchar,--'precio_sg'
                                        v_precio_ga::varchar,--'precio_ga'
                                        v_registros.id_concepto_ingas::varchar,--'id_concepto_ingas'
                                        v_precio_total::varchar,--'precio_total'
                                        v_cantidad::varchar,--'cantidad'
                                        ''::varchar--'estado_reg'
                                            ],
                                        ARRAY[   
                                        	'int4',--'id_solicitud_det'      
                                            'int4',--'id_centro_costo'
                                            'text',--'descripcion'
                                            'numeric',--'precio_unitario'
                                            'int4',--'id_solicitud'
                                            'int4',--'id_orden_trabajo'
                                            'numeric',--'precio_sg'
                                            'numeric',--'precio_ga'
                                            'int4',--'id_concepto_ingas'
                                            'numeric',--'precio_total'
                                            'int4',--'cantidad'
                                            'varchar'--'estado_reg'
                                           ]
                           						 );
                      
            			v_resp= adq.f_solicitud_det_ime(p_administrador,p_id_usuario,v_tabla,v_codigo_trans);
                        v_existe_detalle = TRUE;
                      END IF;	
               
             	
            
                
           
                   
           		END LOOP;
                
                -- raise EXCEPTION 'hola %',v_existe_detalle;
                IF (v_existe_detalle = false) then
                         v_precio_total=v_registros.precio * v_registros.cantidad;
                         v_precio_ga = v_registros.precio * v_registros.cantidad;
                     	 v_codigo_trans ='ADQ_SOLD_INS';
           				 v_tabla = pxp.f_crear_parametro(ARRAY[	
                         				
                                    	'id_centro_costo',
                                        'descripcion',
                                        'precio_unitario',
                                        'id_solicitud',
                                        'id_orden_trabajo',
                                        'precio_sg',
                                        'precio_ga',
                                        'id_concepto_ingas',
                                        'precio_total',
                                        'cantidad_sol'
                                                ],
                                        ARRAY[	
                                        
                                        v_registros.id_centro_costo::varchar,--'id_centro_costo'
                                        v_registros.descripcion::varchar,--'descripcion'
                                        v_registros.precio::varchar,--'precio_unitario'
                                        v_parametros.id_solicitud::varchar,--'id_solicitud'
                                        ''::varchar,--'id_orden_trabajo'
                                        0::varchar,--'precio_sg'
                                        v_precio_ga::varchar,--'precio_ga'
                                        v_registros.id_concepto_ingas::varchar,--'concepto_ingas'
                                        v_precio_total::varchar,--'precio_total'
                                        v_registros.cantidad::varchar--'cantidad'
                                       
                                            ],
                                        ARRAY[   
                                        	      
                                            'int4',--'id_centro_costo'
                                            'text',--'descripcion'
                                            'numeric',--'precio_unitario'
                                            'int4',--'id_solicitud'
                                            'int4',--'id_orden_trabajo'
                                            'numeric',--'precio_sg'
                                            'numeric',--'precio_ga'
                                            'int4',--'id_concepto_ingas'
                                            'numeric',--'precio_total'
                                            'int4'--'cantidad'
                                            
                                           ]
                           						 );
                      
            			v_resp= adq.f_solicitud_det_ime(p_administrador,p_id_usuario,v_tabla,v_codigo_trans);
					-- #1	1/12/2018		 EGS
                  END IF;    
                	 update  adq.tpresolicitud_det  set
                      estado = 'consolidado',
                      id_solicitud_det = v_id_solicitud_det,
                      id_usuario_mod = p_id_usuario,
                      fecha_mod = now()
                    where id_presolicitud_det = v_registros.id_presolicitud_det;
           	
           END LOOP;
           	
            update  adq.tpresolicitud p set
                  estado = 'asignado',
                  id_usuario_mod = p_id_usuario,
                  fecha_mod = now()
                where p.id_presolicitud = v_parametros.id_presolicitud;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','consolidacion de solictud de comrpa'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presolicitud',v_parametros.id_presolicitud::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;  
                 
         
	else
     
    	raise exception 'Transaccion inexistente: %',p_transaccion;

	end if;

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
