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
			    
BEGIN

    v_nombre_funcion = 'adq.f_solicitud_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_SOL_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		RAC	
 	#FECHA:		19-02-2013 12:12:51
	***********************************/

	if(p_transaccion='ADQ_SOL_INS')then
					
        begin
        
        --determina la fecha del periodo
        
         select id_periodo into v_id_periodo from
                        param.tperiodo per 
                       where per.fecha_ini <= v_parametros.fecha_soli 
                         and per.fecha_fin >=  v_parametros.fecha_soli
                         limit 1 offset 0;
        
        
        --obtener correlativo
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
             v_parametros.id_gestion, 
             v_codigo_tipo_proceso, 
             v_parametros.id_funcionario);
        
        -- obtiene el funcionario aprobador
        
        
        	insert into adq.tsolicitud(
			estado_reg,
			--id_solicitud_ext,
			--presu_revertido,
			--fecha_apro,
			estado,
			id_funcionario_aprobador,
			id_moneda,
			id_gestion,
			tipo,
			num_tramite,
			justificacion,
			id_depto,
			lugar_entrega,
			extendida,
			numero,
			posibles_proveedores,
			id_proceso_wf,
			comite_calificacion,
			id_categoria_compra,
			id_funcionario,
			id_estado_wf,
			fecha_soli,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod,
            id_uo,
            id_proceso_macro
          	) values(
			'activo',
			--v_parametros.id_solicitud_ext,
			--v_parametros.presu_revertido,
			--v_parametros.fecha_apro,
			v_codigo_estado,
			v_parametros.id_funcionario_aprobador,
			v_parametros.id_moneda,
			v_parametros.id_gestion,
			v_parametros.tipo,
			v_num_tramite,
			v_parametros.justificacion,
			v_parametros.id_depto,
			v_parametros.lugar_entrega,
			'no',
			v_num_sol,--v_parametros.numero,
			v_parametros.posibles_proveedores,
			v_id_proceso_wf,
			v_parametros.comite_calificacion,
			v_parametros.id_categoria_compra,
			v_parametros.id_funcionario,
			v_id_estado_wf,
			v_parametros.fecha_soli,
			now(),
			p_id_usuario,
			null,
			null,
            v_parametros.id_uo,
            v_id_proceso_macro
							
			)RETURNING id_solicitud into v_id_solicitud;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Solicitud de Compras almacenado(a) con exito (id_solicitud'||v_id_solicitud||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud',v_id_solicitud::varchar);

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
			--Sentencia de la modificacion
			update adq.tsolicitud set
			--id_solicitud_ext = v_parametros.id_solicitud_ext,
			--presu_revertido = v_parametros.presu_revertido,
			--fecha_apro = v_parametros.fecha_apro,
			--estado = v_parametros.estado,
			id_funcionario_aprobador = v_parametros.id_funcionario_aprobador,
			id_moneda = v_parametros.id_moneda,
			id_gestion = v_parametros.id_gestion,
			tipo = v_parametros.tipo,
			--num_tramite = v_parametros.num_tramite,
			justificacion = v_parametros.justificacion,
			id_depto = v_parametros.id_depto,
			lugar_entrega = v_parametros.lugar_entrega,
			--extendida = v_parametros.extendida,
			--numero = v_parametros.numero,
			posibles_proveedores = v_parametros.posibles_proveedores,
			--id_proceso_wf = v_parametros.id_proceso_wf,
			comite_calificacion = v_parametros.comite_calificacion,
			id_funcionario = v_parametros.id_funcionario,
			--id_estado_wf = v_parametros.id_estado_wf,
			fecha_soli = v_parametros.fecha_soli,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
            id_uo = v_parametros.id_uo,
            id_proceso_macro=id_proceso_macro
			where id_solicitud=v_parametros.id_solicitud;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Solicitud de Compras modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud',v_parametros.id_solicitud::varchar);
               
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
          
          
          --obtenemos datos bascios
            select 
            	s.id_estado_wf,
            	s.id_proceso_wf,
            	s.estado,
            	s.id_depto,
                s.id_solicitud
            into
            	v_id_estado_wf,
                v_id_proceso_wf,
                v_codigo_estado,
                v_id_depto,
                v_id_solicitud
            
            from adq.tsolicitud s 
            where s.id_solicitud = v_parametros.id_solicitud;
        
            IF v_codigo_estado !='borrador' THEN
            
               raise exception 'Solo pueden anularce solicitud de en borrador';
              
            
            END IF;
        
        
        
			-- si todas las cotizaciones estan anuladas anulamos el proceso
            
             select 
              te.id_tipo_estado
             into
              v_id_tipo_estado
             from wf.tproceso_wf pw 
             inner join wf.ttipo_proceso tp on pw.id_tipo_proceso = tp.id_tipo_proceso
             inner join wf.ttipo_estado te on te.id_tipo_proceso = tp.id_tipo_proceso and te.codigo = 'anulado'               
             where pw.id_proceso_wf = v_id_proceso_wf;
               
              
              
               -- pasamos la cotizacion al siguiente estado
           
               v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado, 
                                                           NULL, 
                                                           v_id_estado_wf, 
                                                           v_id_proceso_wf,
                                                           p_id_usuario,
                                                           v_id_depto);
            
            
               -- actualiza estado en la cotizacion
              
               update adq.tsolicitud  set 
                 id_estado_wf =  v_id_estado_actual,
                 estado = 'anulado',
                 id_usuario_mod=p_id_usuario,
                 fecha_mod=now()
               where id_solicitud  = v_parametros.id_solicitud;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Solicitud de Compras anulada'); 
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
          
              select sum( COALESCE( sd.precio_ga_mb,0)  + COALESCE(sd.precio_sg_mb,0)) into  v_total_soli
              from adq.tsolicitud_det sd
              where sd.id_solicitud = v_parametros.id_solicitud
              and sd.estado_reg = 'activo';
              
              
              IF  v_total_soli=0  THEN
              	raise exception ' La Solicitud  tiene que ser por un valor mayor a 0';
              END IF;
            --  
             IF exists ( select 1
              from adq.tsolicitud_det sd
              where sd.id_solicitud = v_parametros.id_solicitud
              and sd.estado_reg = 'activo' and (COALESCE( sd.precio_ga_mb,0)  + COALESCE(sd.precio_sg_mb,0)=0)) THEN
                
                  raise exception 'Al menos uno del los items tiene un precio total de 0, verifique e intentelo nuevamente';
              
              END IF;
              
               --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Verificacionde finalizacion)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'total',v_total_soli::varchar);
              
          
          ELSEIF  v_parametros.operacion = 'finalizar' THEN
          
          --obtenermos datos basicos
          
          select
            s.id_proceso_wf,
            s.id_estado_wf,
            s.estado,
            s.id_funcionario_aprobador
          into 
          
            v_id_proceso_wf,
            v_id_estado_wf,
            v_codigo_estado,
            v_id_funcionario_aprobador
            
          from adq.tsolicitud s
          where s.id_solicitud=v_parametros.id_solicitud;
          
                 
          
          
          --buscamos siguiente estado correpondiente al proceso del WF
         
          
          
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
        
        FROM wf.f_obtener_estado_wf(v_id_proceso_wf, v_id_estado_wf,NULL,'siguiente');
          
          --cambiamos estado de la solicitud
          
          
        --     raise exception '% /% /%  /% /%',va_id_tipo_estado[1],va_codigo_estado[1], va_disparador[1], va_regla[1],va_prioridad[1];
          
          
          IF  va_id_tipo_estado[2] is not null  THEN
           
            raise exception 'El proceso se encuentra mal parametrizado dentro de Work Flow,  la finalizacion de solicitud solo admite un estado siguiente';
          
          END IF;
          
          IF  va_id_tipo_estado[1] is  null  THEN
           
            raise exception ' El proceso de Work Flow esta mal parametrizado, no tiene un estado siguiente para la finalizacion';
          
          END IF;
          
            
          IF  va_disparador[1]='si'  THEN
           
            raise exception ' El proceso de Work Flow esta mal parametrizado, antes de iniciar el proceso de compra necesita comprometer el presupuesto';
          
          END IF;
          
          
          --registra estado eactual en el WF
          
          
          /*
            p_id_tipo_estado_siguiente integer,
            p_id_funcionario integer,
            p_id_estado_wf_anterior integer,
            p_id_proceso_wf integer,
            p_id_usuario integer,
            p_id_depto integer = NULL::integer,
            p_obs text = ''::text,
            p_acceso_directo varchar = ''::character varying,
            p_clase varchar = NULL::character varying,
            p_parametros varchar = '{}'::character varying,
            p_tipo varchar = 'notificacion'::character varying,
            p_titulo varchar = 'Visto Bueno'::character varying
          */
          
           v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado[1], 
                                                         v_id_funcionario_aprobador, 
                                                         v_id_estado_wf, 
                                                         v_id_proceso_wf,
                                                         p_id_usuario,
                                                         NULL,
                                                         'Solicitud a espera de aprobación',
                                                         '../../../sis_adquisiciones/vista/solicitud/SolicitudVb.php',
                                                         'SolicitudVb');
                                                         
                                                         
                                                         
                                                         
         
        
           -- actualiza estado en la solicitud
          
           update adq.tsolicitud  s set 
             id_estado_wf =  v_id_estado_actual,
             estado = va_codigo_estado[1],
             id_funcionario_rpc=v_parametros.id_funcionario_rpc,
             id_usuario_mod=p_id_usuario,
             fecha_mod=now()
           where id_solicitud = v_parametros.id_solicitud;
        
        
        
        
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
            s.id_estado_wf,
            s.estado,
            s.fecha_soli
          into 
          
            v_id_proceso_wf,
            v_id_estado_wf,
            v_codigo_estado,
            v_fecha_soli
            
          from adq.tsolicitud s
          where s.id_solicitud=v_parametros.id_solicitud;
          
           select 
            ew.id_tipo_estado ,
            te.pedir_obs
           into 
            v_id_tipo_estado,
            v_perdir_obs
          from wf.testado_wf ew
          inner join wf.ttipo_estado te on te.id_tipo_estado = ew.id_tipo_estado
          where ew.id_estado_wf = v_id_estado_wf;
          
          
        
         --------------------------------------------- 
         -- Verifica  los posibles estados sigueintes para que desde la interfza se tome la decision si es necesario
         --------------------------------------------------
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
                         v_id_estado_wf,
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
                             v_id_estado_wf,
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
                       v_id_estado_wf,
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
                               v_id_estado_wf,
                               FALSE) 
                               AS (id_depto integer,
                                 codigo_depto varchar,
                                 nombre_corto_depto varchar,
                                 nombre_depto varchar,
                                 prioridad integer);
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
            
            
           ----------------------------------------
           --Se se solicita cambiar de estado a la solicitud
           ------------------------------------------
           ELSEIF  v_parametros.operacion = 'cambiar' THEN
          
          
            
            -- obtener datos tipo estado
            
            select
             te.codigo
            into
             v_codigo_estado_siguiente
            from wf.ttipo_estado te
            where te.id_tipo_estado = v_parametros.id_tipo_estado;
            
            IF  pxp.f_existe_parametro('p_tabla','id_depto') THEN
             
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
            
           
            
            -- hay que recuperar el supervidor que seria el estado inmediato,...
             v_id_estado_actual =  wf.f_registra_estado_wf(v_parametros.id_tipo_estado, 
                                                           v_parametros.id_funcionario, 
                                                           v_id_estado_wf, 
                                                           v_id_proceso_wf,
                                                           p_id_usuario,
                                                           v_id_depto,
                                                           v_obs);
            
            
             -- actualiza estado en la solicitud
            
             update adq.tsolicitud  s set 
               id_estado_wf =  v_id_estado_actual,
               estado = v_codigo_estado_siguiente,
               id_usuario_mod=p_id_usuario,
               fecha_mod=now(),
               instruc_rpc=v_parametros.instruc_rpc
               
             where id_solicitud = v_parametros.id_solicitud;
             
             
             
             -- TO DO comprometer presupuesto cuando el estado anterior es el pendiente)
             IF v_codigo_estado =  'pendiente' THEN 
              
               -- Comprometer Presupuesto
              
              
                 IF not adq.f_gestionar_presupuesto_solicitud(v_parametros.id_solicitud, p_id_usuario, 'comprometer')  THEN
                 
                   raise exception 'Error al comprometer el presupeusto';
                 
                 END IF;
              
              
              --modifca bandera de comprometido  
           
                   update adq.tsolicitud  s set 
                     presu_comprometido =  'si'
                   where id_solicitud = v_parametros.id_solicitud;
            
            
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
        
        --------------------------------------------------
        --REtrocede al estado inmediatamente anterior
        -------------------------------------------------
         IF  v_parametros.operacion = 'cambiar' THEN
               
               raise notice 'es_estaado_wf %',v_parametros.id_estado_wf;
              
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
                      
                      -- registra nuevo estado
                      
                      v_id_estado_actual = wf.f_registra_estado_wf(
                          v_id_tipo_estado, 
                          v_id_funcionario, 
                          v_parametros.id_estado_wf, 
                          v_id_proceso_wf, 
                          p_id_usuario,
                          v_id_depto,
                          v_parametros.obs);
                      
                    
                      
                      -- actualiza estado en la solicitud
                        update adq.tsolicitud  s set 
                           id_estado_wf =  v_id_estado_actual,
                           estado = v_codigo_estado,
                           id_usuario_mod=p_id_usuario,
                           fecha_mod=now()
                         where id_solicitud = v_parametros.id_solicitud;
                         
                         
                        --TO DO,  cuando revertir????
                      
                        -- cuando el estado al que regresa es pendiente revierte presusupesto comprometido
                         IF v_codigo_estado = 'pendiente'  THEN
                         
                            -- actualiza estado en la solicitud
                            update adq.tsolicitud  s set 
                               id_estado_wf =  v_id_estado_actual,
                               estado = v_codigo_estado,
                               id_usuario_mod=p_id_usuario,
                               fecha_mod=now()
                             where id_solicitud = v_parametros.id_solicitud;
                         
                         
                           --  llamar a funciond erevertir presupuesto
                           
                           
                           --  modifica bandera de presupuesto comprometido
                            
                           --modifca bandera de comprometido  
                             update adq.tsolicitud  s set 
                               presu_comprometido =  'no'
                             where id_solicitud = v_parametros.id_solicitud;
                           
                         
                         END IF;
                         
                         
                        -- si hay mas de un estado disponible  preguntamos al usuario
                        v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado)'); 
                        v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
                        
                              
                      --Devuelve la respuesta
                        return v_resp;
                        
           ----------------------------------------------------------------------
           -- PAra retornar al estado borrador de la solicitud de manera directa
           ---------------------------------------------------------------------
           ELSEIF  v_parametros.operacion = 'inicio' THEN
             
           SELECT
            sol.id_estado_wf,
            sol.presu_comprometido,
            pw.id_tipo_proceso,
           	pw.id_proceso_wf
           into
            v_id_estado_wf,
            v_presu_comprometido,
            v_id_tipo_proceso,
            v_id_proceso_wf
             
           FROM adq.tsolicitud sol
           inner join wf.tproceso_wf pw on pw.id_proceso_wf = sol.id_proceso_wf
           WHERE  sol.id_solicitud = v_parametros.id_solicitud;
           
           
           
             raise notice 'BUSCAMOS EL INICIO PARA %',v_id_tipo_proceso;
             
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
             
             --registra estado borrador
              v_id_estado_actual = wf.f_registra_estado_wf(
                  v_id_tipo_estado, 
                  v_id_funcionario, 
                  v_parametros.id_estado_wf, 
                  v_id_proceso_wf, 
                  p_id_usuario,
                  v_id_depto,
                  v_parametros.obs);
                      
                    
                      
              -- actualiza estado en la solicitud
                update adq.tsolicitud  s set 
                   id_estado_wf =  v_id_estado_actual,
                   estado = v_codigo_estado,
                   id_usuario_mod=p_id_usuario,
                   fecha_mod=now()
                 where id_solicitud = v_parametros.id_solicitud;
             
                       
             
             
             --si bandera de comprometido activa revertimos
           
              IF v_presu_comprometido ='si'  THEN
              
                --TO DO llamada a funcion de reversion de presupuesto
                   
                   
                 --modifca bandera de comprometido  
                   update adq.tsolicitud  s set 
                     presu_comprometido =  'no'
                   where id_solicitud = v_parametros.id_solicitud;
              END IF;
              
               -- si hay mas de un estado disponible  preguntamos al usuario
                v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se regresoa borrador con exito)'); 
                v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
                        
                              
              --Devuelve la respuesta
                return v_resp;
              
           
           
           ELSE
           
           		raise exception 'Operacion no reconocida %',v_parametros.operacion;
           
           END IF;
        
        
        
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