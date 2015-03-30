--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_solicitud_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.f_solicitud_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'adq.tsolicitud'
 AUTOR: 		 (RAC)
 FECHA:	        19-02-2013 12:12:51
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
    v_registros 	        record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_solicitud	integer;
    
    v_num_sol   varchar;
    v_id_periodo integer;
    v_num_tramite varchar;
    v_id_proceso_wf integer;
    v_id_estado_wf integer;
    v_id_proceso_macro	integer;
    v_codigo_estado varchar;
     v_codigo_estado_siguiente varchar;
    v_codigo_tipo_proceso varchar;
    v_total_soli numeric;
    
    va_id_tipo_estado integer [];
    va_codigo_estado varchar [];
    va_disparador varchar [];
    va_regla varchar [];
    va_prioridad integer [];
    
    
    v_id_estado_actual  integer;
    
    v_id_funcionario_aprobador integer;
    v_id_tipo_estado integer;
    
   
     v_id_funcionario integer;
     v_id_usuario_reg integer;
     v_id_depto integer;
     v_id_estado_wf_ant integer;
     
     v_presu_comprometido varchar;
     v_id_tipo_proceso integer;
     
     
      v_num_estados integer;
      v_num_funcionarios bigint;
      v_num_deptos integer;
      v_fecha_soli date;
      
      v_id_funcionario_estado integer;
      
      v_id_depto_estado integer;
      v_perdir_obs varchar;
     
      v_uo_sol varchar;
      v_obs text;
      
      v_numero_sol					varchar;
      v_id_subsistema 				integer;
      v_id_uo  						integer;
      v_cont  						integer;
      v_mensaje_resp  				varchar;
      

       v_acceso_directo  			varchar;
       v_clase   					varchar;
       v_parametros_ad   			varchar;
       v_tipo_noti  				varchar;
       v_titulo   					varchar;
       v_estado_actual   			varchar;
       v_id_categoria_compra   		integer;
       v_resp_doc					boolean;
       v_revisado 					varchar;
       va_id_funcionario_gerente  	INTEGER[];
       v_tope_compra 				numeric;

			    
BEGIN

    v_nombre_funcion = 'adq.f_solicitud_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_SOL_INS'
 	#DESCRIPCION:	Insercion de la cabecera de las solicitudes de compra ....
 	#AUTOR:		RAC	
 	#FECHA:		19-02-2013 12:12:51
	***********************************/

	if (p_transaccion='ADQ_SOL_INS') then
					
        begin
        
        -- determina la fecha del periodo
        
         select id_periodo into v_id_periodo from
                        param.tperiodo per 
                       where per.fecha_ini <= v_parametros.fecha_soli 
                         and per.fecha_fin >=  v_parametros.fecha_soli
                         limit 1 offset 0;
        
        
        -- obtener correlativo
         v_num_sol =   param.f_obtener_correlativo(
                  'SOLC', 
                   v_id_periodo,-- par_id, 
                   NULL, --id_uo 
                   v_parametros.id_depto,    -- id_depto
                   p_id_usuario, 
                   'ADQ', 
                   NULL);
      
        
        IF (v_num_sol is NULL or v_num_sol ='') THEN
           raise exception 'No se pudo obtener un numero correlativo para la solicitud consulte con el administrador';
        END IF;
        
        -- obtener el codigo del tipo_proceso
       
        select   tp.codigo, pm.id_proceso_macro 
            into v_codigo_tipo_proceso, v_id_proceso_macro
        from  adq.tcategoria_compra cc
        inner join wf.tproceso_macro pm
        	on pm.id_proceso_macro =  cc.id_proceso_macro
        inner join wf.ttipo_proceso tp
        	on tp.id_proceso_macro = pm.id_proceso_macro
        where   cc.id_categoria_compra = v_parametros.id_categoria_compra
                and tp.estado_reg = 'activo' and tp.inicio = 'si';
            
         
        IF v_codigo_tipo_proceso is NULL THEN
        
           raise exception 'No existe un proceso inicial para el proceso macro indicado (Revise la configuración)';
        
        END IF;
        
        -- recupera la uo gerencia del funcionario
        v_id_uo =   orga.f_get_uo_gerencia(NULL, v_parametros.id_funcionario, v_parametros.fecha_soli::Date);
        
        ------------------------------------
        -- recuepra el funcionario aprobador
        -------------------------------------
        
        -- si el funcionario que solicita es un gerente .... es el mimso encargado de aprobar
                
                 IF exists(select 1 from orga.tuo_funcionario uof 
                           inner join orga.tuo uo on uo.id_uo = uof.id_uo and uo.estado_reg = 'activo'
                           inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional and no.numero_nivel in (1,2)
                           where  uof.estado_reg = 'activo' and  uof.id_funcionario = v_parametros.id_funcionario ) THEN
                  
                      va_id_funcionario_gerente[1] = v_parametros.id_funcionario;
                 
                 ELSE
                    --si tiene funcionario identificar el gerente correspondientes
                    IF v_parametros.id_funcionario is not NULL THEN
                    
                        SELECT  
                           pxp.aggarray(id_funcionario) 
                         into
                           va_id_funcionario_gerente
                         FROM orga.f_get_aprobadores_x_funcionario(v_parametros.fecha_soli, v_parametros.id_funcionario , 'todos', 'si', 'todos', 'ninguno') AS (id_funcionario integer);      
                        --NOTA el valor en la primera posicion del array es el gerente  de menor nivel
                    END IF;  
                END IF;
        
        --inserta solicitud
        insert into adq.tsolicitud(
			estado_reg,
			--id_solicitud_ext,
			--presu_revertido,
			--fecha_apro,
			--estado,
			id_funcionario_aprobador,
			id_moneda,
			id_gestion,
			tipo,
			--num_tramite,
			justificacion,
			id_depto,
			lugar_entrega,
			extendida,
			numero,
			--posibles_proveedores,
			--id_proceso_wf,
			--comite_calificacion,
			id_categoria_compra,
			id_funcionario,
			--id_estado_wf,
			fecha_soli,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod,
            id_uo,
            id_proceso_macro,
            id_proveedor,
            id_funcionario_supervisor,
            id_usuario_ai,
            usuario_ai,
            tipo_concepto,
            fecha_inicio,
            dias_plazo_entrega,
            precontrato
          	) values(
			'activo',
			--v_parametros.id_solicitud_ext,
			--v_parametros.presu_revertido,
			--v_parametros.fecha_apro,
			--v_codigo_estado,
			va_id_funcionario_gerente[1],   --v_parametros.id_funcionario_aprobador,
			v_parametros.id_moneda,
			v_parametros.id_gestion,
			v_parametros.tipo,
			--v_num_tramite,
			v_parametros.justificacion,
			v_parametros.id_depto,
			v_parametros.lugar_entrega,
			'no',
			v_num_sol,--v_parametros.numero,
			--v_parametros.posibles_proveedores,
			--v_id_proceso_wf,
			--v_parametros.comite_calificacion,
			v_parametros.id_categoria_compra,
			v_parametros.id_funcionario,
			--v_id_estado_wf,
			v_parametros.fecha_soli,
			now(),
			p_id_usuario,
			null,
			null,
            v_id_uo,
            v_id_proceso_macro,
            v_parametros.id_proveedor,
            NULL,  --  .id_funcionario_supervisor  ya nose maneja funcionarios pre aprobadores ....  04022015
            v_parametros._id_usuario_ai,
            v_parametros._nombre_usuario_ai,
            v_parametros.tipo_concepto,
            v_parametros.fecha_inicio,
            v_parametros.dias_plazo_entrega,
            COALESCE(v_parametros.precontrato,'no')
							
			)RETURNING id_solicitud into v_id_solicitud;
        
        
        
        -- inciiar el tramite en el sistema de WF
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
             v_parametros.id_gestion, 
             v_codigo_tipo_proceso, 
             v_parametros.id_funcionario,
             NULL,
             'Solicitud de Compra '||v_num_sol,
             v_num_sol);
        
        -- UPDATE DATOS wf
        
          UPDATE adq.tsolicitud  SET
             num_tramite = v_num_tramite,
             id_proceso_wf = v_id_proceso_wf,
             id_estado_wf = v_id_estado_wf,
             estado = v_codigo_estado
          
          WHERE id_solicitud = v_id_solicitud;
          
          
          -- inserta documentos en estado borrador si estan configurados
           v_resp_doc =  wf.f_inserta_documento_wf(p_id_usuario, v_id_proceso_wf, v_id_estado_wf);
           
           -- verificar documentos
           v_resp_doc = wf.f_verifica_documento(p_id_usuario, v_id_estado_wf); 
        
        	
		   --Definicion de la respuesta
		   v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Solicitud de Compras almacenado(a) con exito (id_solicitud'||v_id_solicitud||')'); 
           v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud',v_id_solicitud::varchar);
           v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_wf',v_id_proceso_wf::varchar);
           v_resp = pxp.f_agrega_clave(v_resp,'num_tramite',v_num_tramite::varchar);
           v_resp = pxp.f_agrega_clave(v_resp,'estado',v_codigo_estado::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_SOL_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		RAC	
 	#FECHA:		19-02-2013 12:12:51
	***********************************/

	elsif(p_transaccion='ADQ_SOL_MOD')then

		begin
        
            select
             s.estado,
             s.num_tramite
            into
             v_registros
            from 
            adq.tsolicitud  s
            where id_solicitud = v_parametros.id_solicitud;
            
            
            -- recupera la uo gerencia del funcionario
            v_id_uo =   orga.f_get_uo_gerencia(NULL, v_parametros.id_funcionario, v_parametros.fecha_soli::Date);
        
          --------------------------------------
          -- recuepra el funcionario aprobador
          -------------------------------------
          
           -- si el funcionario que solicita es un gerente .... es el mimso encargado de aprobar
                  
             IF exists(select 1 from orga.tuo_funcionario uof 
                       inner join orga.tuo uo on uo.id_uo = uof.id_uo and uo.estado_reg = 'activo'
                       inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional and no.numero_nivel in (1,2)
                       where  uof.estado_reg = 'activo' and  uof.id_funcionario = v_parametros.id_funcionario ) THEN
                    
                  va_id_funcionario_gerente[1] = v_parametros.id_funcionario;
                   
             ELSE
                --si tiene funcionario identificar el gerente correspondientes
                IF v_parametros.id_funcionario is not NULL THEN
                      
                    SELECT  
                       pxp.aggarray(id_funcionario) 
                     into
                       va_id_funcionario_gerente
                     FROM orga.f_get_aprobadores_x_funcionario(v_parametros.fecha_soli, v_parametros.id_funcionario , 'todos', 'si', 'todos', 'ninguno') AS (id_funcionario integer);      
                    --NOTA el valor en la primera posicion del array es el gerente  de menor nivel
                END IF;  
            END IF;
            
			--Sentencia de la modificacion
			update adq.tsolicitud set
			id_funcionario_aprobador = va_id_funcionario_gerente[1],
			id_moneda = v_parametros.id_moneda,
			id_gestion = v_parametros.id_gestion,
			tipo = v_parametros.tipo,
			justificacion = v_parametros.justificacion,
			id_depto = v_parametros.id_depto,
			lugar_entrega = v_parametros.lugar_entrega,
			--posibles_proveedores = v_parametros.posibles_proveedores,
			--comite_calificacion = v_parametros.comite_calificacion,
			id_funcionario = v_parametros.id_funcionario,
			fecha_soli = v_parametros.fecha_soli,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
            id_uo = v_id_uo,
            id_proceso_macro=id_proceso_macro,
            id_proveedor=v_parametros.id_proveedor,
            id_usuario_ai= v_parametros._id_usuario_ai,
            usuario_ai = v_parametros._nombre_usuario_ai,
            tipo_concepto =  v_parametros.tipo_concepto,
            fecha_inicio = v_parametros.fecha_inicio,
            dias_plazo_entrega = v_parametros.dias_plazo_entrega,
            precontrato = COALESCE(v_parametros.precontrato,'no')
			where id_solicitud = v_parametros.id_solicitud;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Solicitud de Compras modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud',v_parametros.id_solicitud::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'num_tramite',v_registros.num_tramite);
            v_resp = pxp.f_agrega_clave(v_resp,'estado',v_registros.estado);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_SOL_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		RAC	
 	#FECHA:		19-02-2013 12:12:51
	***********************************/

	elsif(p_transaccion='ADQ_SOL_ELI')then

		begin
          
          
          --obtenemos datos basicos
            select 
            	s.id_estado_wf,
            	s.id_proceso_wf,
            	s.estado,
            	s.id_depto,
                s.id_solicitud,
                s.numero,
                s.num_tramite
            into
            	v_id_estado_wf,
                v_id_proceso_wf,
                v_codigo_estado,
                v_id_depto,
                v_id_solicitud,
                v_numero_sol,
                v_num_tramite
            
            from adq.tsolicitud s 
            where s.id_solicitud = v_parametros.id_solicitud;
        
            IF v_codigo_estado !='borrador' THEN
            
               raise exception 'Solo pueden anularce solicitud de en borrador';
              
            
            END IF;
        
        
        
			-- obtenemos el tipo del estado anulado
            
             select 
              te.id_tipo_estado
             into
              v_id_tipo_estado
             from wf.tproceso_wf pw 
             inner join wf.ttipo_proceso tp on pw.id_tipo_proceso = tp.id_tipo_proceso
             inner join wf.ttipo_estado te on te.id_tipo_proceso = tp.id_tipo_proceso and te.codigo = 'anulado'               
             where pw.id_proceso_wf = v_id_proceso_wf;
               
              
             IF v_id_tipo_estado is NULL  THEN
             
                raise exception 'No se parametrizo es estado "anulado" para la solicitud de compra';
             
             END IF;
             
                          
               -- pasamos la solicitud  al siguiente anulado
           
               v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado, 
                                                           NULL, 
                                                           v_id_estado_wf, 
                                                           v_id_proceso_wf,
                                                           p_id_usuario,
                                                           v_parametros._id_usuario_ai,
                                                           v_parametros._nombre_usuario_ai,
                                                           v_id_depto,
                                                           'Eliminacion de la solicitud '|| COALESCE(v_numero_sol,'SN')::text);
            
            
               -- actualiza estado en la solicitud
              
               update adq.tsolicitud  set 
                 id_estado_wf =  v_id_estado_actual,
                 estado = 'anulado',
                 id_usuario_mod=p_id_usuario,
                 fecha_mod=now()
               where id_solicitud  = v_parametros.id_solicitud;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Solicitud de Compras anulada' ||COALESCE(v_numero_sol,'SN')); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud',v_parametros.id_solicitud::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
     /*********************************    
 	#TRANSACCION:  'ADQ_REVSOL_IME'
 	#DESCRIPCION:	Marca la revision de las solicitudes de compra
 	#AUTOR:		RAC	
 	#FECHA:		23-09-2014 12:12:51
	***********************************/

	elsif(p_transaccion='ADQ_REVSOL_IME')then

		begin
          
          
          --obtenemos datos basicos
            select 
            	s.revisado_asistente,
                s.id_proceso_wf
            into
            	v_registros
            from adq.tsolicitud s 
            where s.id_solicitud = v_parametros.id_solicitud;
        
            IF v_registros.revisado_asistente = 'si' THEN
               v_revisado = 'no';
            ELSE
               v_revisado = 'si';
            END IF;
            
             -- actualiza estado en la solicitud
              
             update adq.tsolicitud  set 
               revisado_asistente = v_revisado,
               id_usuario_mod=p_id_usuario,
               fecha_mod=now()
             where id_solicitud  = v_parametros.id_solicitud;
             
             
             --modifica el proeso wf para actulizar el mismo campo
             update wf.tproceso_wf  set 
               revisado_asistente = v_revisado
             where id_proceso_wf  = v_registros.id_proceso_wf;
             
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Revision de solicitud de compra'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud',v_parametros.id_solicitud::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;   
     /*********************************    
 	#TRANSACCION:  'ADQ_FINSOL_IME'
 	#DESCRIPCION:	Finalizar solicitud de Compras
 	#AUTOR:		RAC	
 	#FECHA:		19-02-2013 12:12:51
	***********************************/

	elseif(p_transaccion='ADQ_FINSOL_IME')then   
        begin
        
          IF  v_parametros.operacion = 'verificar' THEN
          
          --  29/01/2014  RAC
          --  Se quita la opcion de que el solcitante eescoja un RPC en un combo
          --  en su lugar se configura por defecto el RPC de manea Unica, si deveulve mas de una opcion de RPC
          --  bota un error
          
          
                  select 
                  sum( COALESCE( sd.precio_ga_mb,0)  + COALESCE(sd.precio_sg_mb,0)) 
                  into  
                  v_total_soli
                  from adq.tsolicitud_det sd
                  where sd.id_solicitud = v_parametros.id_solicitud
                  and sd.estado_reg = 'activo';
                  
                  v_total_soli =  COALESCE(v_total_soli,0);
                  
                  
                  IF  v_total_soli = 0  THEN
                    raise exception ' La Solicitud  tiene que ser por un valor mayor a 0';
                  END IF;
                  
                  -- validamos que el monsto de la oslicitud no supere el tope configurado
                  
                  v_tope_compra = pxp.f_get_variable_global('adq_tope_compra')::numeric; 
                
                  IF  v_total_soli  >= v_tope_compra  THEN
                  
                    raise exception 'Las compras por encima de % (moneda base) no pueden realizarse  por el sistema de adquisiciones',v_tope_compra;
                  
                  END IF;
                
                
                  IF exists ( select 1
                  from adq.tsolicitud_det sd
                  where sd.id_solicitud = v_parametros.id_solicitud
                  and sd.estado_reg = 'activo' and (COALESCE( sd.precio_ga_mb,0)  + COALESCE(sd.precio_sg_mb,0)=0)) THEN
                    
                      raise exception 'Al menos uno del los items tiene un precio total de 0, verifique e intentelo nuevamente';
                  
                  END IF;
                  
                  
                  -- obtiene parametros para definir aprobador
                  
                   select 
                      s.id_subsistema
                    into 
                      v_id_subsistema
                    from segu.tsubsistema s
                    where s.codigo = 'ADQ'
                    and s.estado_reg = 'activo' 
                    limit 1 offset 0; 
                    
                    --obener UO, id_proceso_macro y fecha de la solictud
                    select 
                     sol.fecha_soli,
                     sol.id_proceso_macro,
                     sol.id_uo,
                     sol.id_categoria_compra
                    INTO
                     v_fecha_soli,
                     v_id_proceso_macro,
                     v_id_uo,
                     v_id_categoria_compra 
                    from adq.tsolicitud sol
                    where sol.id_solicitud = v_parametros.id_solicitud;
                  
                  
                   v_cont = 0;
                   v_mensaje_resp = '';
                    --  obtener listado de RPC
                    
                    /*
                            p_id_usuario integer,
                            p_id_uo integer,
                            p_fecha date,
                            p_monto numeric,
                            p_id_categoria_compra integer,
                    
                    */
                    
                  
                   	FOR v_registros in (
                            SELECT 
                                  DISTINCT (id_funcionario),
                                  id_rpc,
                                  id_rpc_uo,
                                  desc_funcionario,
                                  fecha_ini,
                                  fecha_fin,
                                  monto_min,
                                  monto_max,
                                  id_cargo,
                                  id_cargo_ai,
                                  ai_habilitado 
                                  
                            FROM adq.f_obtener_listado_rpc(
                                  p_id_usuario,
                                  v_id_uo, --id_uo
                                  v_fecha_soli, 
                                  COALESCE(v_total_soli,0),
                                  v_id_categoria_compra)
                                  AS ( id_rpc   integer,
                                       id_rpc_uo integer,
                                       id_funcionario integer,
                                       desc_funcionario text,
                                       fecha_ini date,
                                       fecha_fin date,
                                       monto_min numeric,
                                       monto_max numeric,
                                       id_cargo integer,
                                       id_cargo_ai integer,
                                       ai_habilitado varchar)
                                  )LOOP     
                                  
                     
                       v_cont = v_cont +1;
                       
                       IF v_cont = 1 THEN
                 
                         v_resp =  adq.f_finalizar_reg_solicitud(
                                            p_administrador, 
                                            p_id_usuario,
                                            v_parametros._id_usuario_ai,
                                            v_parametros._nombre_usuario_ai,
                                            v_registros.id_funcionario, 
                                            v_parametros.id_solicitud,
                                            v_parametros.id_estado_wf,
                                            v_registros.id_cargo,
                                            v_registros.id_cargo_ai,
                                            v_registros.ai_habilitado);
                  
                       END IF;
                       
                       v_mensaje_resp = v_mensaje_resp||' - '||v_registros.desc_funcionario||' <br>';
                   
                   
                   
                   END LOOP;
                  
                  
                  -- si existe mas de un posible aprobador lanzamos un error
                  IF v_cont > 1 THEN
                  
                      raise exception 'Existe mas de un aprobador para el monto (%), revice la configuracion para los funcionarios: <br> %',v_total_soli,v_mensaje_resp;
                  
                  
                  END IF;
                  
                  -- si existe mas de un posible aprobador lanzamos un error
                  IF v_cont = 0 THEN
                  
                      raise exception 'No se encontro RPC para esta solicitud';
                  
                  
                  END IF;
                  
               
                --Definicion de la respuesta
                v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Verificacionde finalizacion)'); 
                v_resp = pxp.f_agrega_clave(v_resp,'total',v_total_soli::varchar);
              
          
          ELSEIF  v_parametros.operacion = 'finalizar' THEN
          
           raise exception 'fin';
        
             v_resp =  adq.f_finalizar_reg_solicitud(p_administrador, 
                                           p_id_usuario, 
                                           v_parametros.id_solicitud,
                                           v_parametros.id_funcionario_rpc, 
                                           v_parametros.id_solicitud);
        
        
         ELSE
          
            raise exception 'operacion no identificada %',COALESCE( v_parametros.operacion,'--');
          
          END IF;
        
        
        --Devuelve la respuesta
            return v_resp;
        
        end;   
    
      /*********************************    
 	#TRANSACCION:  'ADQ_SIGESOL_IME'
 	#DESCRIPCION:	funcion que controla el cambio al Siguiente esado de la solicitud, integrado con el WF
 	#AUTOR:		RAC	
 	#FECHA:		19-02-2013 12:12:51
	***********************************/

	elseif(p_transaccion='ADQ_SIGESOL_IME')then   
        begin
        
        --obtenermos datos basicos
          
          select
            s.id_proceso_wf,
            s.fecha_soli,
            s.numero,
            s.estado
          into 
            v_id_proceso_wf,
            v_fecha_soli,
            v_numero_sol,
            v_estado_actual
            
          from adq.tsolicitud s
          where s.id_solicitud=v_parametros.id_solicitud;
          
           select 
            ew.id_tipo_estado ,
            te.pedir_obs,
            te.codigo
           into 
            v_id_tipo_estado,
            v_perdir_obs,
            v_codigo_estado
          from wf.testado_wf ew
          inner join wf.ttipo_estado te on te.id_tipo_estado = ew.id_tipo_estado
          where ew.id_estado_wf = v_parametros.id_estado_wf;
          
          
       
         ------------------------------------------------------------------------------ 
         -- Verifica  los posibles estados siguientes para que desde la interfza se tome la decision si es necesario
         --------------------------------------------------------------------------------
          IF  v_parametros.operacion = 'verificar' THEN
          
                        --buscamos siguiente estado correpondiente al proceso del WF
                       
                        ----- variables de retorno------
                        
                        v_num_estados=0;
                        v_num_funcionarios=0;
                        v_num_deptos=0;
                        
                        --------------------------------- 
                        
                       SELECT  
                           ps_id_tipo_estado,
                           ps_codigo_estado,
                           ps_disparador,
                           ps_regla,
                           ps_prioridad
                        into
                          va_id_tipo_estado,
                          va_codigo_estado,
                          va_disparador,
                          va_regla,
                          va_prioridad 
                        FROM adq.f_obtener_sig_estado_sol_rec(v_parametros.id_solicitud, v_id_proceso_wf, v_id_tipo_estado); 
                    
                      
                      v_num_estados= array_length(va_id_tipo_estado, 1);
                      
                       IF v_perdir_obs = 'no' THEN
                      
                          IF v_num_estados = 1 then
                                -- si solo hay un estado,  verificamos si tiene mas de un funcionario por este estado
                               SELECT 
                               *
                                into
                               v_num_funcionarios 
                               FROM wf.f_funcionario_wf_sel(
                                   p_id_usuario, 
                                   va_id_tipo_estado[1], 
                                   v_fecha_soli,
                                   v_parametros.id_estado_wf,
                                   TRUE) AS (total bigint);
                                   
                              IF v_num_funcionarios = 1 THEN
                              -- si solo es un funcionario, recuperamos el funcionario correspondiente
                                   SELECT 
                                       id_funcionario
                                         into
                                       v_id_funcionario_estado
                                   FROM wf.f_funcionario_wf_sel(
                                       p_id_usuario, 
                                       va_id_tipo_estado[1], 
                                       v_fecha_soli,
                                       v_parametros.id_estado_wf,
                                       FALSE) 
                                       AS (id_funcionario integer,
                                         desc_funcionario text,
                                         desc_funcionario_cargo text,
                                         prioridad integer);
                              END IF;    
                                   
                            
                            --verificamos el numero de deptos
                            
                              SELECT 
                              *
                              into
                                v_num_deptos 
                             FROM wf.f_depto_wf_sel(
                                 p_id_usuario, 
                                 va_id_tipo_estado[1], 
                                 v_fecha_soli,
                                 v_parametros.id_estado_wf,
                                 TRUE) AS (total bigint);
                                 
                            IF v_num_deptos = 1 THEN
                                -- si solo es un funcionario, recuperamos el funcionario correspondiente
                                     SELECT 
                                         id_depto
                                           into
                                         v_id_depto_estado
                                    FROM wf.f_depto_wf_sel(
                                         p_id_usuario, 
                                         va_id_tipo_estado[1], 
                                         v_fecha_soli,
                                         v_parametros.id_estado_wf,
                                         FALSE) 
                                         AS (id_depto integer,
                                           codigo_depto varchar,
                                           nombre_corto_depto varchar,
                                           nombre_depto varchar,
                                           prioridad integer,
                                           subsistema varchar);
                              END IF;
                            
                            
                            
                            
                           
                           END IF;
                     
                     END IF;
                      
                      -- si hay mas de un estado disponible  preguntamos al usuario
                      v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Verificacion para el siguiente estado)'); 
                      v_resp = pxp.f_agrega_clave(v_resp,'estados', array_to_string(va_id_tipo_estado, ','));
                      v_resp = pxp.f_agrega_clave(v_resp,'operacion','preguntar_todo');
                      v_resp = pxp.f_agrega_clave(v_resp,'num_estados',v_num_estados::varchar);
                      v_resp = pxp.f_agrega_clave(v_resp,'num_funcionarios',v_num_funcionarios::varchar);
                      v_resp = pxp.f_agrega_clave(v_resp,'num_deptos',v_num_deptos::varchar);
                      v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario_estado',v_id_funcionario_estado::varchar);
                      v_resp = pxp.f_agrega_clave(v_resp,'id_depto_estado',v_id_depto_estado::varchar);
                      v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_estado', va_id_tipo_estado[1]::varchar);
                
                
               -------------------------------------------------
               --Se se solicita cambiar de estado a la solicitud
               --------------------------------------------------
           ELSEIF  v_parametros.operacion = 'cambiar' THEN
          
           
                    
                    -- obtener datos tipo estado
                    
                    select
                     te.codigo
                    into
                     v_codigo_estado_siguiente
                    from wf.ttipo_estado te
                    where te.id_tipo_estado = v_parametros.id_tipo_estado;
                    
                    IF  pxp.f_existe_parametro(p_tabla,'id_depto') THEN
                     
                     v_id_depto = v_parametros.id_depto;
                    
                    END IF;
                    
                    
                    v_obs=v_parametros.obs;
                    
                    IF v_codigo_estado_siguiente =  'aprobado' THEN
                        --si el siguient estado es aprobado obtenemos el depto que le correponde de la solictud de compra
                        
                          select 
                             s.id_depto,
                             s.numero,
                             uo.nombre_unidad 
                          into 
                             v_id_depto,
                             v_num_sol,
                             v_uo_sol
                          from  adq.tsolicitud s
                          inner join orga.tuo uo on uo.id_uo = s.id_uo 
                          where s.id_solicitud = v_parametros.id_solicitud;
                          
                          v_obs =  'La solicitud '||v_num_sol||' fue aprobada para la uo '||v_uo_sol||' ('||v_parametros.obs||')';
                    END IF;
                    
                     
                     --v_acceso_directo = '../../../sis_adquisiciones/vista/solicitud/SolicitudVb.php';
                     --v_clases_acceso_directo = 'SolicitudVb';
                    
                   if v_obs ='' THEN
                   
                      v_obs = ' Cambio de estado de la solicitud '||COALESCE(v_numero_sol,'S/N')||'  de  la uo '||COALESCE(v_uo_sol,'-');
                   
                   ELSE
                   
                      v_obs = 'Solicitud  de compra '||COALESCE(v_numero_sol,'S/N')||'  para  la uo OBS:'||COALESCE(v_uo_sol,'-')||' ('|| COALESCE(v_obs,'S/O')||')';
                   
                   
                   END IF;
                   
                   
                   
                   --configurar acceso directo para la alarma   
                   v_acceso_directo = '';
                   v_clase = '';
                   v_parametros_ad = '';
                   v_tipo_noti = 'notificacion';
                   v_titulo  = 'Visto Bueno';
                               
                             
                   IF  v_codigo_estado_siguiente not in('borrador','aprobado','en_proceso','finalizado','anulado')   THEN
                       v_acceso_directo = '../../../sis_adquisiciones/vista/solicitud/SolicitudVb.php';
                       v_clase = 'SolicitudVb';
                       v_parametros_ad = '{filtro_directo:{campo:"sol.id_proceso_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
                       v_tipo_noti = 'notificacion';
                       v_titulo  = 'Visto Bueno';
                               
                    END IF;
                    
                    
                    
                   
                   -- registra nuevo estado
                   v_id_estado_actual =  wf.f_registra_estado_wf(v_parametros.id_tipo_estado, 
                                                                   v_parametros.id_funcionario, 
                                                                   v_parametros.id_estado_wf, 
                                                                   v_id_proceso_wf,
                                                                   p_id_usuario,
                                                                   v_parametros._id_usuario_ai,
                                                                   v_parametros._nombre_usuario_ai,
                                                                   v_id_depto,
                                                                   v_obs,
                                                                   v_acceso_directo ,
                                                                   v_clase,
                                                                   v_parametros_ad,
                                                                   v_tipo_noti,
                                                                   v_titulo);
                    
                  
                   
                     IF v_estado_actual = 'vbpresupuestos' THEN
                           update adq.tsolicitud  s set 
                            obs_presupuestos = v_parametros.obs
                           where id_solicitud = v_parametros.id_solicitud;
                     
                     END IF;
                  
                     IF  not adq.f_fun_inicio_solicitud_wf(p_id_usuario, 
                                                   v_parametros._id_usuario_ai, 
                                                   v_parametros._nombre_usuario_ai, 
                                                   v_id_estado_actual, 
                                                   v_id_proceso_wf, 
                                                   v_codigo_estado_siguiente,
                                                   v_parametros.instruc_rpc) THEN
            
                             raise exception 'Error al retroceder estado';
            
                    END IF;
                    
                  
                     -- si hay mas de un estado disponible  preguntamos al usuario
                    v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado)'); 
                    v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
                  
          
          END IF;

        
          --Devuelve la respuesta
            return v_resp;
        
        end;
    
    /*********************************    
 	#TRANSACCION:  'ADQ_ANTESOL_IME'
 	#DESCRIPCION:	Trasaacion utilizada  pasar a  estados anterior es de la solicitud
                    segun la operacion definida
 	#AUTOR:		RAC	
 	#FECHA:		19-02-2013 12:12:51
	***********************************/

	elseif(p_transaccion='ADQ_ANTESOL_IME')then   
        begin
        

        SELECT
            sol.id_estado_wf,
            sol.presu_comprometido,
            pw.id_tipo_proceso,
           	pw.id_proceso_wf,
            sol.numero
           into
            v_id_estado_wf,
            v_presu_comprometido,
            v_id_tipo_proceso,
            v_id_proceso_wf,
            v_numero_sol
             
       FROM adq.tsolicitud sol
       inner join wf.tproceso_wf pw on pw.id_proceso_wf = sol.id_proceso_wf
       WHERE  sol.id_solicitud = v_parametros.id_solicitud;
       
       --configurar acceso directo para la alarma   
       v_acceso_directo = '';
       v_clase = '';
       v_parametros_ad = '';
       v_tipo_noti = 'notificacion';
       v_titulo  = 'Visto Bueno'; 
       
       
      

        --------------------------------------------------
        --Retrocede al estado inmediatamente anterior
        -------------------------------------------------
         IF  v_parametros.operacion = 'cambiar' THEN
               
              
              
                      --recuperaq estado anterior segun Log del WF
                        SELECT  
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
                        FROM wf.f_obtener_estado_ant_log_wf(v_parametros.id_estado_wf);
                        
                        
                        --
                      select 
                           ew.id_proceso_wf 
                        into 
                           v_id_proceso_wf
                      from wf.testado_wf ew
                      where ew.id_estado_wf= v_id_estado_wf_ant;
                      
                      
                       
                     
                       IF  v_codigo_estado not in('borrador','aprobado','en_proceso','finalizado','anulado')   THEN
                           
                           v_acceso_directo = '../../../sis_adquisiciones/vista/solicitud/SolicitudVb.php';
                           v_clase = 'SolicitudVb';
                           v_parametros_ad = '{filtro_directo:{campo:"sol.id_proceso_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
                           v_tipo_noti = 'notificacion';
                           v_titulo  = 'Visto Bueno';
                       
                        END IF;
                        
                        IF v_codigo_estado  in('borrador')   THEN
                           
                           v_acceso_directo = '../../../sis_adquisiciones/vista/solicitud/SolicitudReq.php';
                           v_clase = 'SolicitudReq';
                           v_parametros_ad = '{filtro_directo:{campo:"sol.id_proceso_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
                           v_tipo_noti = 'notificacion';
                           v_titulo  = 'Solicitud de Compra';
                       
                        END IF;
                        
                        
                       
                      
                       -- registra nuevo estado
                      
                      v_id_estado_actual = wf.f_registra_estado_wf(
                          v_id_tipo_estado, 
                          v_id_funcionario, 
                          v_parametros.id_estado_wf, 
                          v_id_proceso_wf, 
                          p_id_usuario,
                          v_parametros._id_usuario_ai,
                          v_parametros._nombre_usuario_ai,
                          v_id_depto,
                          '[RETROCEDE]: #'|| COALESCE(v_numero_sol,'S/N')||' - '||v_parametros.obs,
                           v_acceso_directo ,
                           v_clase,
                           v_parametros_ad,
                           v_tipo_noti,
                           v_titulo);
                      
                    
               -- raise exception 'test';
                        
           ----------------------------------------------------------------------
           -- PAra retornar al estado borrador de la solicitud de manera directa
           ---------------------------------------------------------------------
           ELSEIF  v_parametros.operacion = 'inicio' THEN
             
             -- recuperamos el estado inicial segun tipo_proceso
             
             SELECT  
               ps_id_tipo_estado,
               ps_codigo_estado
             into
               v_id_tipo_estado,
               v_codigo_estado
             FROM wf.f_obtener_tipo_estado_inicial_del_tipo_proceso(v_id_tipo_proceso);
             
             --recupera el funcionario segun ultimo log borrador
             raise notice 'CODIGO ESTADO BUSCADO %',v_codigo_estado ;
             
             SELECT 
               ps_id_funcionario,
               ps_codigo_estado ,
               ps_id_depto
             into
              v_id_funcionario,
              v_codigo_estado,
              v_id_depto
               
                
             FROM wf.f_obtener_estado_segun_log_wf(v_id_estado_wf, v_id_tipo_estado);
            
              raise notice 'CODIGO ESTADO ENCONTRADO %',v_codigo_estado ;
              
              
              IF   v_codigo_estado  = 'borrador'  THEN
                           v_acceso_directo = '../../../sis_adquisiciones/vista/solicitud/SolicitudReq.php';
                           v_clase = 'SolicitudReq';
                           v_parametros_ad = '{filtro_directo:{campo:"sol.id_proceso_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
                           v_tipo_noti = 'notificacion';
                           v_titulo  = 'Visto Bueno';
                       
              END IF;
              
             
             --registra estado borrador
              v_id_estado_actual = wf.f_registra_estado_wf(
                  v_id_tipo_estado, 
                  v_id_funcionario, 
                  v_parametros.id_estado_wf, 
                  v_id_proceso_wf, 
                  p_id_usuario,
                  v_parametros._id_usuario_ai,
                  v_parametros._nombre_usuario_ai,
                  v_id_depto,
                  'RETRO: #'|| COALESCE(v_numero_sol,'S/N')||' - '||v_parametros.obs,
                  v_acceso_directo ,
                  v_clase,
                  v_parametros_ad,
                  v_tipo_noti,
                  v_titulo);
                      
             
           ELSE
           
           		raise exception 'Operacion no reconocida %',v_parametros.operacion;
           
           END IF;
           
          
         
            IF  not adq.f_fun_regreso_solicitud_wf(p_id_usuario, 
                                                   v_parametros._id_usuario_ai, 
                                                   v_parametros._nombre_usuario_ai, 
                                                   v_id_estado_actual, 
                                                   v_id_proceso_wf, 
                                                   v_codigo_estado) THEN
            
               raise exception 'Error al retroceder estado';
            
            END IF;
           
           
           
           
           
              -- si hay mas de un estado disponible  preguntamos al usuario
             v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se regresoa borrador con exito)'); 
             v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
                        
                              
             --Devuelve la respuesta
             return v_resp;
        
        
        end;
    
    /*********************************    
 	#TRANSACCION:  'ADQ_MODOBS_MOD'
 	#DESCRIPCION:	Modificar observacion de área de presupuestos
 	#AUTOR:		RAC	
 	#FECHA:		19-02-2013 12:12:51
	***********************************/

	elsif(p_transaccion='ADQ_MODOBS_MOD')then

		begin
			--Sentencia de la modificacion
			update adq.tsolicitud set
			obs_presupuestos = v_parametros.obs
			where id_solicitud = v_parametros.id_solicitud;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','obs de presupuestos modificada'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud',v_parametros.id_solicitud::varchar);
               
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