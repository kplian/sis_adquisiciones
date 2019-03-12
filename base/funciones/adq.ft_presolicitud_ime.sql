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
#4 endeETR  19/02/2019       EGS                 -Se elimino transsaciones antiguas del flujo antiguo y se implento el nuevo flujo WF
                                                 - se hizo validaciones para consolidar y desconsolidar items   
                                                 
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
    v_id_solicitud_det 		varchar;
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
    v_record_solicitud	    record;
    v_partida_nuevo         record;
    v_partida_actual        record;
    v_bandera               boolean;
    v_nombre_grupo          varchar;
    v_descripcion           varchar;
    v_nro_item_asignado     integer;
    v_presolicitud_det      record;
    v_nro_items             INTEGER;
    
    --#4 variables wf  
	v_id_proceso_macro		integer;
    v_num_tramite			varchar;
    v_codigo_tipo_proceso	varchar;
    v_fecha                 date;
    v_codigo_estado			varchar;
    v_id_proceso_wf         integer;
	v_id_estado_wf          integer;
    
    --#4 variables de sig y ant estado de Wf
    v_id_tipo_estado		integer;    
    v_codigo_estado_siguiente	varchar;
    v_id_depto 				integer;
    v_obs					varchar;
    v_acceso_directo		varchar;
    v_clase					varchar;
    v_codigo_estados		varchar;
    v_id_cuenta_bancaria	integer;
    v_id_depto_lb			integer;
    v_parametros_ad			varchar;
    v_tipo_noti				varchar;
    v_titulo  				varchar;
    v_id_estado_actual		integer;
    v_registros_proc		record;
    v_codigo_tipo_pro		varchar;
    v_id_usuario_reg		integer;
    v_id_estado_wf_ant		integer;
    v_id_funcionario        integer;
   
    --#4 variables para cambio de estado automatico
    va_id_tipo_estado 		integer[];
    va_codigo_estado 		varchar[];
    va_disparador    		varchar[];
    va_regla         		varchar[]; 
    va_prioridad     		integer[];
    p_id_usuario_ai         integer;
    p_usuario_ai            varchar;

   
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
        
            --#4 codigo de proceso WF de presolicitudes de compra
            v_codigo_tipo_proceso = 'PRESOL';           
            --Recoleccion de datos para el proceso WF #4
             --obtener id del proceso macro

             select
             pm.id_proceso_macro
             into
             v_id_proceso_macro
             from wf.tproceso_macro pm
             left join wf.ttipo_proceso tp on tp.id_proceso_macro  = pm.id_proceso_macro
             where tp.codigo = v_codigo_tipo_proceso;
                          
             If v_id_proceso_macro is NULL THEN
               raise exception 'El proceso macro  de codigo % no esta configurado en el sistema WF',v_codigo_tipo_proceso;
             END IF;        	 	
            --Obtencion de la gestion #4
             v_fecha= now()::date;
              select
                per.id_gestion
                into
                v_id_gestion
                from param.tperiodo per
                where per.fecha_ini <=v_fecha and per.fecha_fin >= v_fecha
                limit 1 offset 0;            
  	        	
             -- inciar el tramite en el sistema de WF   #4        
            SELECT
                   ps_num_tramite ,
                   ps_id_proceso_wf ,
                   ps_id_estado_wf ,
                   ps_codigo_estado
                into
                   v_num_tramite,
                   v_id_proceso_wf,
                   v_id_estado_wf,
                   v_codigo_estado

            FROM wf.f_inicia_tramite(
                   p_id_usuario,
                   v_parametros._id_usuario_ai,
                   v_parametros._nombre_usuario_ai,
                   v_id_gestion,
                   v_codigo_tipo_proceso,
                   v_parametros.id_funcionario,
                   null,
                   'Inicio de Presolicitud de Compra',
                   '' );
                   
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
            id_gestion,
            id_proceso_wf,
            id_estado_wf,
            nro_tramite
          	) values(
			v_parametros.id_grupo,
			v_parametros.id_funcionario_supervisor,
			v_parametros.id_funcionario,
			'activo',
			v_parametros.obs,
			v_parametros.id_uo,
			v_codigo_estado,
		
			now(),
			p_id_usuario,
			null,
			null,
            v_parametros.fecha_soli,
            v_parametros.id_depto,
            v_parametros.id_gestion,
            v_id_proceso_wf,
            v_id_estado_wf,
            v_num_tramite							
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
           --#4 validamos que al modificar el grupo el nuevo grupo tenga configurada las partidas del detalle
           --recuperamos la gestion de la presolicitud
            SELECT 
                pred.id_gestion
            INTO
                v_id_gestion
            FROM adq.tpresolicitud pred
            WHERE pred.id_presolicitud=v_parametros.id_presolicitud;
            
           --recuperamos los datos del grupo al que se quiere cambiar la presolicitud 
            SELECT 
                grupo.nombre
            INTO
                v_nombre_grupo
            FROM adq.tgrupo grupo
            WHERE grupo.id_grupo=v_parametros.id_grupo;
            
            --recuperamos las partidas del detalle de la presolicitud 
            FOR v_partida_actual in (
                 SELECT
                    predet.id_presolicitud_det,
                    conpa.id_partida,
                    conpa.id_concepto_ingas,
                    coing.desc_ingas,
                    gru.nombre
                  FROM adq.tpresolicitud_det predet
                  left join adq.tpresolicitud pres on pres.id_presolicitud = predet.id_presolicitud
                  left join pre.tconcepto_partida conpa on conpa.id_concepto_ingas = predet.id_concepto_ingas
                  left join param.tconcepto_ingas coing on coing.id_concepto_ingas = predet.id_concepto_ingas
                  left join adq.tgrupo_partida grupa on grupa.id_partida = conpa.id_partida
                  left join adq.tgrupo gru on gru.id_grupo = grupa.id_grupo
                  LEFT join pre.tpartida par on par.id_partida = conpa.id_partida          
                  WHERE predet.id_presolicitud = v_parametros.id_presolicitud  and par.id_gestion = v_id_gestion
                  ORDER BY conpa.id_partida ASC
            )LOOP v_bandera = false;
            --recuperamos las partidas del nuevo grupo
                FOR v_partida_nuevo in(
                     SELECT
                        grupar.id_partida  
                      FROM adq.tgrupo_partida grupar
                      WHERE grupar.id_grupo = v_parametros.id_grupo and grupar.id_gestion = v_id_gestion 
                      ORDER BY grupar.id_partida ASC 
                  )LOOP
                       --si existe la partida en el grupo cambiamos la bandera a true
                        IF v_partida_nuevo.id_partida = v_partida_actual.id_partida THEN
                            v_bandera = true;
                        END IF;
                  END LOOP;
                    -- si no existe la partida en el grupo nuevo se notifica
                   IF v_bandera = false THEN
                        RAISE EXCEPTION 'No se encuentra la partida del concepto de gasto % configurado en el grupo %',v_partida_actual.desc_ingas,v_nombre_grupo;
                   END IF;           
            END LOOP;
           --#4
			
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
        --Al eliminar directo la presolicitud el detalle de esta actualiza a inactivo
            UPDATE adq.tpresolicitud_det
            Set estado_reg = 'inactivo',
            	id_usuario_mod = p_id_usuario,
                fecha_mod = now()
            where id_presolicitud = v_parametros.id_presolicitud;
            
            UPDATE adq.tpresolicitud
            Set estado_reg = 'inactivo',
            	id_usuario_mod = p_id_usuario,
                fecha_mod = now()
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
 	#TRANSACCION:  'ADQ_CONSOL_IME'
 	#DESCRIPCION:	consolida presolicitudes
 	#AUTOR:		rac	 
    #Modificado: EGS
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
            pre.id_depto,
            pre.id_estado_wf,
            pre.id_proceso_wf,
            pre.id_presolicitud
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
           		  --recuperamos el tipo del detalle de la presolicitud
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
                    sold.precio_unitario,
                    sol.num_tramite
               	    from adq.tsolicitud_det sold
                    left join adq.tsolicitud sol on sol.id_solicitud = sold.id_solicitud
                    where sold.estado_reg = 'activo' AND sold.id_solicitud = v_parametros.id_solicitud
				  ) LOOP   
                  	          
        			
                      ---si es de igual centro de costo,precio y concepto de gasto a un detalle de la solicitud se actualiza sumando solo las cantidades
                      IF v_record_solicitud_det.id_centro_costo = v_registros.id_centro_costo  and 
                         v_record_solicitud_det.id_concepto_ingas = v_registros.id_concepto_ingas  and
                         v_record_solicitud_det.precio_unitario = v_registros.precio	 THEN
                         
                        
                          
                         v_cantidad =  v_record_solicitud_det.cantidad + v_registros.cantidad;
                         v_precio_total = (v_record_solicitud_det.cantidad + v_registros.cantidad)*v_record_solicitud_det.precio_unitario;
                         v_precio_ga = (v_record_solicitud_det.cantidad + v_registros.cantidad)*v_record_solicitud_det.precio_unitario;
                         --modificamos el detalle de la solicitud con las mismas carateristicas de la presolicitud

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
                                        'estado_reg',
                                        'id_usuario_mod'
                           			
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
                                        ''::varchar,--'estado_reg'
                                        p_id_usuario::varchar--'id_usuario_mod'
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
                                            'varchar',--'estado_reg',
                                            'int4'--'id_usuario_mod'
                                           ]
                           						 );
                      
            			v_resp= adq.f_solicitud_det_ime(p_administrador,p_id_usuario,v_tabla,v_codigo_trans);
                        v_id_solicitud_det = v_record_solicitud_det.id_solicitud_det;                     
                        v_existe_detalle = TRUE;
                      END IF;	
               
             	
            
                
           
                   
           		END LOOP;

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
                                       COALESCE(v_registros.descripcion,' ')::varchar,--'descripcion'
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
                        v_id_solicitud_det  = pxp.f_recupera_clave(v_resp,'id_solicitud_det');
                        v_id_solicitud_det	=  split_part(v_id_solicitud_det, '{', 2);
                        v_id_solicitud_det	=  split_part(v_id_solicitud_det, '}', 1);                  
					-- #1	1/12/2018		 EGS
                  END IF;    
                	 update  adq.tpresolicitud_det  set
                      estado = 'consolidado',
                      id_solicitud_det = v_id_solicitud_det::integer,
                      id_usuario_mod = p_id_usuario,
                      fecha_mod = now()
                    where id_presolicitud_det = v_registros.id_presolicitud_det;
           	
           END LOOP; 
           --cuando se consolida la presolicitud pasa a estado de asignado automaticamente cuando es el primer item
           -- ya que ingreso uno en el count tiene que ser 1 si tiene mas de un item ya no avanza un estado
           
           SELECT
            count(presd.id_solicitud_det)
            INTO
            v_nro_items
           FROM adq.tpresolicitud_det presd        
           WHERE presd.id_presolicitud = v_registros_pre.id_presolicitud;
         
          IF v_nro_items = 1 THEN          
                SELECT 
                     *
                  into
                    va_id_tipo_estado,
                    va_codigo_estado,
                    va_disparador,
                    va_regla,
                    va_prioridad
                
                FROM wf.f_obtener_estado_wf(v_registros_pre.id_proceso_wf, v_registros_pre.id_estado_wf,NULL,'siguiente');
                IF va_codigo_estado[2] is not null THEN             
                 raise exception 'El proceso de WF esta mal parametrizado,  solo admite un estado siguiente para el estado: %', v_registros_pre.estado;             
                END IF;                
                 IF va_codigo_estado[1] is  null THEN
                
                 raise exception 'El proceso de WF esta mal parametrizado, no se encuentra el estado siguiente,  para el estado: %', v_registros_pre.estado;           
                END IF;  
                 SELECT
                    fun.id_funcionario
                 into
                    v_id_funcionario
                 FROM orga.tfuncionario fun
                 left join segu.tusuario usu on usu.id_persona = fun.id_persona
                WHERE usu.id_usuario = p_id_usuario;
                
                 p_id_usuario_ai = 1;
                 p_usuario_ai = null; 
                -- estado siguiente
             v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado[1], 
                                                               v_id_funcionario, 
                                                               v_registros_pre.id_estado_wf, 
                                                               v_registros_pre.id_proceso_wf,
                                                               p_id_usuario,
                                                               p_id_usuario_ai, -- id_usuario_ai
                                                               p_usuario_ai, -- usuario_ai
                                                               v_registros_pre.id_depto,
                                                               'Asignacion de items');
            
                -- actualiza estado en la solicitud
            update adq.tpresolicitud pp  set 
                             id_estado_wf =  v_id_estado_actual,
                             estado = va_codigo_estado[1],
                             id_usuario_mod=p_id_usuario,
                             fecha_mod=now(),
                             id_usuario_ai = p_id_usuario_ai,
                             usuario_ai = p_usuario_ai
                           where id_presolicitud  = v_registros_pre.id_presolicitud; 
             
           
           END IF;  
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','consolidacion de solictud de comrpa'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presolicitud',v_parametros.id_presolicitud::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end; 
            /*********************************    
 	#TRANSACCION:  'ADQ_DESCONSOL_IME'
 	#DESCRIPCION:	desconsolida presolicitudes
 	#AUTOR:		    EGS	
 	#FECHA:		    14/02/2019
    #ISSUE:           #4
	***********************************/

	elsif(p_transaccion='ADQ_DESCONSOL_IME')then
    
		begin
		   -- Raise exception 'hola %',v_parametros;	
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
             pd.estado,
             pd.id_solicitud_det,
             sold.id_solicitud    
            from adq.tpresolicitud_det pd
            left join adq.tsolicitud_det sold on sold.id_solicitud_det = pd.id_solicitud_det
            where pd.id_presolicitud = '||v_parametros.id_presolicitud||'
               and pd.estado_reg = ''activo'' and
                   pd.id_presolicitud_det in ('||v_aux||')';

           FOR  v_registros in  execute(v_consulta) LOOP
                   --validando la solicitud       
                   select
                    s.estado,
                    s.num_tramite
                    into 
                    v_record_solicitud 
                    from adq.tsolicitud s
                    where s.id_solicitud = v_registros.id_solicitud;
                
                    IF v_record_solicitud.estado != 'borrador' THEN
                    
                       raise exception 'La solictud de compra (%) bede estar en estado borrador para desconsolidar, actualice su interface de solicitudes',v_record_solicitud.num_tramite;
                    
                    END IF;
                    ---recobrando datos la presolicitud
                     SELECT
                        sold.cantidad,
                        sold.id_concepto_ingas,
                        sold.id_centro_costo,
                        sold.precio_unitario
                     INTO
                        v_record_solicitud_det
                     FROM adq.tsolicitud_det sold
                     WHERE sold.id_solicitud_det = v_registros.id_solicitud_det;
                     --validamos que el detalle de la solicitud asociada a la presolicitud tenga los mismo atributos
                     IF v_record_solicitud_det.id_concepto_ingas = v_registros.id_concepto_ingas and
                        v_record_solicitud_det.id_centro_costo = v_registros.id_centro_costo and 
                        v_record_solicitud_det.precio_unitario = v_registros.precio
                      THEN
                                 IF v_record_solicitud_det.cantidad > v_registros.cantidad THEN
                                   ---guardamos la descripcion
                                     v_descripcion = v_registros.descripcion;
                                     --actualizamos la cantidad y descripcion con la bandera de desconsolidarETR en la descripcion para que el raise del triger no salte cuando se edite la cantidad
                                     --esto para que no restringa si el triguer de proyectos esta funcional  pro.f_tr_ime_soldet   
                                     --si no esta funcional no salta ningun triguer                    
                                     update adq.tsolicitud_det set
                                        cantidad = cantidad - v_registros.cantidad,
                                        descripcion = 'desconsolidarETR'
                                     WHERE  id_solicitud_det = v_registros.id_solicitud_det;
                                     
                                     --actualizamos la descripcion con su original
                                     update adq.tsolicitud_det set
                                        descripcion = v_descripcion
                                     WHERE  id_solicitud_det = v_registros.id_solicitud_det;  
                                 
                                 ELSIF  v_record_solicitud_det.cantidad = v_registros.cantidad  THEN
                                 --nota cuando se desconsolida el detalle y se inactiva el triguer adq.tr_delete_soldet_up_presoldet
                                 --ejecuta una serie de reglas
                                      update adq.tsolicitud_det set
                                        estado_reg = 'inactivo',
                                        id_usuario_mod = p_id_usuario,
                                        fecha_mod = now()
                                     WHERE  id_solicitud_det = v_registros.id_solicitud_det;
                                 ELSIF v_record_solicitud_det.cantidad < v_registros.cantidad THEN
                                      Raise exception 'El detalle de la solicitud asociada a la presolicitud es menor a la cantidad de la presolicitud.Por favor consulte con el administrador';
                                 END IF;           

                                 update  adq.tpresolicitud_det  set
                                  estado = 'pendiente',
                                  id_solicitud_det = null,
                                  id_usuario_mod = p_id_usuario,
                                  fecha_mod = now()
                                where id_presolicitud_det = v_registros.id_presolicitud_det;
                    ELSE 
                        RAISE EXCEPTION 'El Centro de de Costo o el concepto de gasto o el precio, asociados a la Presolicitud fueron modificados';
           	        END IF;
           END LOOP;
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','consolidacion de solictud de comrpa'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presolicitud',v_parametros.id_presolicitud::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
                      
          /*********************************
          #TRANSACCION:  	'ADQ_SIGEPRESOL_INS'
          #DESCRIPCION:  	Controla el cambio al siguiente estado
          #AUTOR:   		EGS
          #FECHA:   		19/02/2019
          #ISSUE:           #4
          ***********************************/

        	
          elseif(p_transaccion='ADQ_SIGEPRESOL_INS')then
              
              begin
                --raise exception 'entra';
                  --Obtenemos datos basico                                
                  select
                  ew.id_proceso_wf,	
                  c.id_estado_wf,
                  c.estado    
                  into
                  v_id_proceso_wf,
                  v_id_estado_wf,
                  v_codigo_estado
                  from adq.tpresolicitud c
                  inner join wf.testado_wf ew on ew.id_estado_wf = c.id_estado_wf  
                  where c.id_presolicitud = v_parametros.id_presolicitud;

                  --Recupera datos del estado
                  select
                  ew.id_tipo_estado,
                  te.codigo
                  into
                  v_id_tipo_estado,
                  v_codigo_estados
                  from wf.testado_wf ew
                  inner join wf.ttipo_estado te on te.id_tipo_estado = ew.id_tipo_estado
                  where ew.id_estado_wf = v_parametros.id_estado_wf_act;
                  
                  -- obtener datos tipo estado
                  select
                  te.codigo
                  into
                  v_codigo_estado_siguiente
                  from wf.ttipo_estado te
                  where te.id_tipo_estado = v_parametros.id_tipo_estado;
                  
                  if pxp.f_existe_parametro(p_tabla,'id_depto_wf') then
                      v_id_depto = v_parametros.id_depto_wf;
                  end if;

                  if pxp.f_existe_parametro(p_tabla,'obs') then
                      v_obs=v_parametros.obs;
                  else
                      v_obs='---';
                  end if;

                  --Acciones por estado siguiente que podrian realizarse
                  if v_codigo_estado_siguiente in ('') then
                  end if;
      			
                  ---------------------------------------
                  -- REGISTRA EL SIGUIENTE ESTADO DEL WF
                  ---------------------------------------
                  --Configurar acceso directo para la alarma
                  v_acceso_directo = '';
                  v_clase = '';
                  v_parametros_ad = '';
                  v_tipo_noti = 'notificacion';
                  v_titulo  = 'Visto Bueno';

                  if v_codigo_estado_siguiente not in('borrador','finalizado','anulado') then
                      v_acceso_directo = '../../../sis_adquisiciones/vista/presolicitud/PresolicitudReq.php';
                      v_clase = 'PresolicitudReq';
                      v_parametros_ad = '{filtro_directo:{campo:"pres.id_proceso_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
                      v_tipo_noti = 'notificacion';
                      v_titulo  = 'Visto Bueno';
                  end if;
                  v_id_estado_actual = wf.f_registra_estado_wf(
                                                         v_parametros.id_tipo_estado,
                                                         v_parametros.id_funcionario_wf,
                                                         v_parametros.id_estado_wf_act,
                                                         v_id_proceso_wf,
                                                         p_id_usuario,
                                                         v_parametros._id_usuario_ai,
                                                         v_parametros._nombre_usuario_ai,
                                                         v_id_depto,                       --depto del estado anterior
                                                         v_obs,
                                                         v_acceso_directo,
                                                         v_clase,
                                                         v_parametros_ad,
                                                         v_tipo_noti,
                                                         v_titulo);

                      --raise exception 'v_id_estado_actual %',v_id_estado_actual;
                  --------------------------------------
                  -- Registra los procesos disparados
                  --------------------------------------
                  for v_registros_proc in ( select * from json_populate_recordset(null::wf.proceso_disparado_wf, v_parametros.json_procesos::json)) loop

                      --Obtencion del codigo tipo proceso
                      select
                      tp.codigo
                      into
                      v_codigo_tipo_pro
                      from wf.ttipo_proceso tp
                      where tp.id_tipo_proceso =  v_registros_proc.id_tipo_proceso_pro;

                      --Disparar creacion de procesos seleccionados
                      select
                      ps_id_proceso_wf,
                      ps_id_estado_wf,
                      ps_codigo_estado
                      into
                      v_id_proceso_wf,
                      v_id_estado_wf,
                      v_codigo_estado
                      from wf.f_registra_proceso_disparado_wf(
                      p_id_usuario,
                      v_parametros._id_usuario_ai,
                      v_parametros._nombre_usuario_ai,
                      v_id_estado_actual,
                      v_registros_proc.id_funcionario_wf_pro,
                      v_registros_proc.id_depto_wf_pro,
                      v_registros_proc.obs_pro,
                      v_codigo_tipo_pro,
                      v_codigo_tipo_pro);

                  end loop;

                  --------------------------------------------------
                  --  ACTUALIZA EL NUEVO ESTADO DE LA CUENTA DOCUMENTADA
                  ----------------------------------------------------
                  IF pxp.f_existe_parametro(p_tabla,'id_cuenta_bancaria') THEN
                      v_id_cuenta_bancaria =  v_parametros.id_cuenta_bancaria;
                  END IF;

                  IF pxp.f_existe_parametro(p_tabla,'id_depto_lb') THEN
                      v_id_depto_lb =  v_parametros.id_depto_lb;
                  END IF;
                      if adq.f_fun_inicio_presolicitud_wf(
                              v_parametros.id_presolicitud,
                              p_id_usuario,
                              v_parametros._id_usuario_ai,
                              v_parametros._nombre_usuario_ai,
                              v_id_estado_actual,
                              v_id_proceso_wf,
                              v_codigo_estado_siguiente,
                              v_id_depto_lb,
                              v_id_cuenta_bancaria,
                              v_codigo_estado
                          ) then

                      end if;
                  -- si hay mas de un estado disponible  preguntamos al usuario
                  v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado del pago simple id='||v_parametros.id_presolicitud);
                  v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
                  -- Devuelve la respuesta
                  return v_resp;
              end;
              
          /*********************************
          #TRANSACCION:  	'PRO_ANTEPRESOL_IME'
          #DESCRIPCION: 	Retrocede el estado proyectos
          #AUTOR:   		EGS
          #FECHA:   		19/02/2019
          #ISSUE:           #4
          ***********************************/

          elseif(p_transaccion='ADQ_ANTEPRESOL_IME')then

              begin
				 --raise exception'entra';
                  --Obtenemos datos basicos
                  select
                  c.id_presolicitud,
                  ew.id_proceso_wf,	
                  c.id_estado_wf,
                  c.estado    
                  into
                  v_registros_proc
                  from adq.tpresolicitud c
                  inner join wf.testado_wf ew on ew.id_estado_wf = c.id_estado_wf  
                  where c.id_presolicitud = v_parametros.id_presolicitud;
                  
                  v_id_proceso_wf = v_registros_proc.id_proceso_wf;                  
               --cuando el estado es asignado se desconsolida todo y automaticamente vuelve a aprobado
               -- por el triguer adq.tr_delete_soldet_up_presoldet
               IF v_registros_proc.estado = 'asignado' THEN
              --buscamos los detalles consolidados y las desconsolidamos una a una
                     for v_presolicitud_det in (
                             SELECT
                                  presold.id_presolicitud_det,
                                  presold.id_solicitud_det,
                                  sold.id_solicitud
                             FROM adq.tpresolicitud_det presold
                             left join adq.tsolicitud_det sold on sold.id_solicitud_det = presold.id_solicitud_det
                             WHERE presold.id_solicitud_det is not null and presold.id_presolicitud = v_parametros.id_presolicitud
                                          )LOOP
                              v_codigo_trans ='ADQ_DESCONSOL_IME';
                              v_tabla = pxp.f_crear_parametro(ARRAY[	
                                            'id_presolicitud',
                                            'id_solicitud',
                                            'id_presolicitud_dets'
                                                      ],
                                              ARRAY[	
                                            v_parametros.id_presolicitud::varchar,--'id_presolicitud'
                                            v_presolicitud_det.id_solicitud::varchar,--'id_solicitud'
                                            v_presolicitud_det.id_presolicitud_det::varchar--'id_presolicitud_dets'
                                                  ],
                                              ARRAY[   
                                            'int4',--'id_presolicitud'
                                            'int4',--'id_solicitud'
                                            'varchar'--'id_presolicitud_dets'
                                                 ]
                                          );
                            
                              v_resp= adq.ft_presolicitud_ime(p_administrador,p_id_usuario,v_tabla,v_codigo_trans);
                       END LOOP;
                 ELSE
                   --se vuelve atras si el estado normalmente si es diferente a asignado    
                        --raise EXCEPTION 'v_id_proceso_wf %',v_id_proceso_wf;
                        --------------------------------------------------
                        --Retrocede al estado inmediatamente anterior
                        -------------------------------------------------
                        --recupera estado anterior segun Log del WF
                        select
                          ps_id_tipo_estado,
                          ps_id_funcionario,
                          ps_id_usuario_reg,
                          ps_id_depto,
                          ps_codigo_estado,
                          ps_id_estado_wf_ant
                        into
                          v_id_tipo_estado,
                          v_id_funcionario,
                          v_id_usuario_reg,
                          v_id_depto,
                          v_codigo_estado,
                          v_id_estado_wf_ant
                        from wf.f_obtener_estado_ant_log_wf(v_parametros.id_estado_wf);

                        --Configurar acceso directo para la alarma
                        v_acceso_directo = '';
                        v_clase = '';
                        v_parametros_ad = '';
                        v_tipo_noti = 'notificacion';
                        v_titulo  = 'Visto Bueno';

                        if v_codigo_estado_siguiente not in('borrador','finalizado','anulado') then
            	
                            v_acceso_directo = '../../../sis_adquisiciones/vista/presolicitud/PresolicitudReq.php';
                            v_clase = 'PresolicitudReq';
                            v_parametros_ad = '{filtro_directo:{campo:"pres.id_proceso_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
                            v_tipo_noti = 'notificacion';
                            v_titulo  = 'Visto Bueno';
                        end if;


                        --Registra nuevo estado
                        v_id_estado_actual = wf.f_registra_estado_wf(
                            v_id_tipo_estado,                --  id_tipo_estado al que retrocede
                            v_id_funcionario,                --  funcionario del estado anterior
                            v_parametros.id_estado_wf,       --  estado actual ...
                            v_id_proceso_wf,                 --  id del proceso actual
                            p_id_usuario,                    -- usuario que registra
                            v_parametros._id_usuario_ai,
                            v_parametros._nombre_usuario_ai,
                            v_id_depto,                       --depto del estado anterior
                            '[RETROCESO] '|| v_parametros.obs,
                            v_acceso_directo,
                            v_clase,
                            v_parametros_ad,
                            v_tipo_noti,
                            v_titulo);
                        --raise exception 'v_id_estado_actual %', v_id_estado_actual;
                        if not adq.f_fun_regreso_presolicitud_wf(
                                                            v_parametros.id_presolicitud,
                                                            p_id_usuario,
                                                            v_parametros._id_usuario_ai,
                                                            v_parametros._nombre_usuario_ai,
                                                            v_id_estado_actual,
                                                            v_parametros.id_proceso_wf,
                                                            v_codigo_estado) then

                            raise exception 'Error al retroceder estado';

                        end if; 
                 END IF;
                  v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado del pago simple)');
                  v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');

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