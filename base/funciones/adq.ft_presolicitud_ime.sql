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
	v_id_presolicitud	    integer;
    v_registros    		    record;
    v_estado  varchar;
    v_consulta  varchar;
    v_id_partida integer; 
    v_id_cuenta integer; 
    v_id_auxiliar   integer;
    v_id_solicitud_det integer;
    v_aux varchar;
    v_registros_pre record;
    v_id_gestion integer;
			    
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
			--Sentencia de la eliminacion
			delete from adq.tpresolicitud
            where id_presolicitud=v_parametros.id_presolicitud;
               
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
            s.id_gestion
            into 
            v_registros 
            from adq.tsolicitud s
            where s.id_solicitud = v_parametros.id_solicitud;
            
            v_id_gestion = v_registros.id_gestion;
            
            IF v_registros.estado != 'borrador' THEN
            
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
            
            IF v_registros_pre.id_depto != v_registros.id_depto   THEN
            
             
               raise exception 'Solo puede consolidar presolicitudes del mismo departamento que la solicitud';
            
            
            END IF;
            
            
        
        v_aux = COALESCE(v_parametros.id_presolicitud_dets,'0');
       
        IF v_aux = '' THEN
           v_aux = 0;
        END IF;
        
        
           v_consulta = 'select
             pd.id_presolicitud_det,
             pd.id_centro_costo,
             pd.id_concepto_ingas,
             pd.descripcion,
             pd.cantidad,
             pd.estado    
            from adq.tpresolicitud_det pd
            where pd.id_presolicitud = '||v_parametros.id_presolicitud||'
               and pd.estado_reg = ''activo'' and
                   pd.id_presolicitud_det in ('||v_aux||')';
        
           --raise exception '%',v_consulta;
        
           FOR  v_registros in  execute(v_consulta) LOOP
           
              
                  
           
                  SELECT 
                    ps_id_partida ,
                    ps_id_cuenta,
                    ps_id_auxiliar
                  into 
                    v_id_partida,
                    v_id_cuenta, 
                    v_id_auxiliar
                FROM conta.f_get_config_relacion_contable('CUECOMP', v_id_gestion, v_registros.id_concepto_ingas, v_registros.id_centro_costo);
                
        
           
             
                 --Sentencia de la insercion
                  insert into adq.tsolicitud_det(
                  id_centro_costo,
                  descripcion,
                  precio_unitario,
                  id_solicitud,
                  id_partida,
                  id_orden_trabajo,
      			
                  id_concepto_ingas,
                  id_cuenta,
                  precio_total,
                  cantidad,
                  id_auxiliar,
                  estado_reg,
                  precio_ga,
                  precio_sg,
                  id_usuario_reg,
                  fecha_reg,
                  fecha_mod,
                  id_usuario_mod,
                  precio_ga_mb,
                  precio_sg_mb,
                  precio_unitario_mb
                  
                  
                  ) values(
                  v_registros.id_centro_costo,
                  v_registros.descripcion,
                  0,
                  v_parametros.id_solicitud,
                  v_id_partida,
                  NULL,
      			
                  v_registros.id_concepto_ingas,
                  v_id_cuenta,
                  0,
                  v_registros.cantidad,
                  v_id_auxiliar,
                  'activo',
                  0,
                  0,
                  p_id_usuario,
                  now(),
                  null,
                  null,
                  0,
                  0,
                  0
      							
                  )RETURNING id_solicitud_det into v_id_solicitud_det;
                
           
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