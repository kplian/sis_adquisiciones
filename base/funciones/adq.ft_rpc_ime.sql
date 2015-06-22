--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.ft_rpc_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.ft_rpc_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'adq.trpc'
 AUTOR: 		 (rac)
 FECHA:	        29-05-2014 15:57:51
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
	v_id_rpc	integer;
    v_registros          record;
    v_registros_det      record;
    v_registros_sol      record;
    v_id_rpc_uo 	integer;
    v_count         integer;
    v_total_soli    numeric;
    v_cont integer;
    v_mensaje_resp  varchar;
			    
BEGIN

    v_nombre_funcion = 'adq.ft_rpc_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_RPC_INS'
 	#DESCRIPCION:	Insercion de registros de rpc
 	#AUTOR:		rac	
 	#FECHA:		29-05-2014 15:57:51
	***********************************/

	if(p_transaccion='ADQ_RPC_INS')then
					
        begin
        	
            -- chequea que el cargo  no este duplicado
            
            
            IF exists(select 1 
                       from adq.trpc r   
                       where r.id_cargo = v_parametros.id_cargo 
                         and r.estado_reg = 'activo') THEN
                   
            
                raise exception 'El cargo ya se encuentra registrado como RPC';
                  
            END IF;  
            
            
            --Sentencia de la insercion
        	insert into adq.trpc(
			id_cargo,
			id_cargo_ai,
			estado_reg,
			ai_habilitado,
			id_usuario_reg,
			id_usuario_ai,
			usuario_ai,
			fecha_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_cargo,
			v_parametros.id_cargo_ai,
			'activo',
			v_parametros.ai_habilitado,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			now(),
			null,
			null
							
			
			
			)RETURNING id_rpc into v_id_rpc;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','RPC almacenado(a) con exito (id_rpc'||v_id_rpc||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_rpc',v_id_rpc::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_RPC_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		rac	
 	#FECHA:		29-05-2014 15:57:51
	***********************************/

	elsif(p_transaccion='ADQ_RPC_MOD')then

		begin
			
             -- chequea  que el cargo  no este duplicado
            IF exists(select 1 
                       from adq.trpc r   
                       where r.id_cargo = v_parametros.id_cargo 
                         and r.estado_reg = 'activo'  and  r.id_rpc != v_parametros.id_rpc ) THEN
                   
            
                raise exception 'El cargo ya se encuentra registrado como RPC';
                  
            END IF; 
            
            --Sentencia de la modificacion
			update adq.trpc set
			id_cargo = v_parametros.id_cargo,
			id_cargo_ai = v_parametros.id_cargo_ai,
			ai_habilitado = v_parametros.ai_habilitado,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_rpc=v_parametros.id_rpc;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','RPC modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_rpc',v_parametros.id_rpc::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;
        
        

	/*********************************    
 	#TRANSACCION:  'ADQ_RPC_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		rac	
 	#FECHA:		29-05-2014 15:57:51
	***********************************/

	elsif(p_transaccion='ADQ_RPC_ELI')then

		begin
			
            if exists(select 1 from adq.trpc_uo ruo where ruo.id_rpc =v_parametros.id_rpc and ruo.estado_reg = 'activo') then
            
              raise exception 'tiene rangos activos, primero elimine todos los rangos asignados' ; 
            
            end if;
            
            
            --Sentencia de la eliminacion
			update adq.trpc set
            estado_reg = 'inactivo'
            where id_rpc=v_parametros.id_rpc;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','RPC eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_rpc',v_parametros.id_rpc::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
        
    
    
    /*********************************    
 	#TRANSACCION:  'ADQ_CHARPC_IME'
 	#DESCRIPCION:	Cambia el RPC segun configuracion 
 	#AUTOR:		rac	
 	#FECHA:		03-06-2014 15:57:51
	***********************************/

	elsif(p_transaccion='ADQ_CHARPC_IME')then

		begin
			
             select
               sol.id_solicitud,
               sol.id_funcionario_rpc,
               sol.id_cargo_rpc,
               sol.id_cargo_rpc_ai,
               sol.ai_habilitado,
               sol.id_uo,
               sol.id_categoria_compra,
               sol.fecha_soli,
               sol.estado,
               sol.id_estado_wf
              
             INTO
               v_registros_sol
             from adq.tsolicitud sol
             where sol.id_solicitud = v_parametros.id_solicitud;
             
             
             select 
                  sum( COALESCE( sd.precio_ga_mb,0)  + COALESCE(sd.precio_sg_mb,0)) 
                  into  
                  v_total_soli
                  from adq.tsolicitud_det sd
                  where sd.id_solicitud = v_parametros.id_solicitud
                  and sd.estado_reg = 'activo';
             
             
             v_cont = 0;
             
             
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
                                  v_registros_sol.id_uo, --id_uo
                                  v_registros_sol.fecha_soli, 
                                  v_total_soli,
                                  v_registros_sol.id_categoria_compra)
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
                      v_mensaje_resp = v_mensaje_resp||' - '||v_registros.desc_funcionario||' <br>';
                   
                    END LOOP;
                  
                  
                  -- si existe mas de un posible aprobador lanzamos un error
                  IF v_cont > 1 THEN
                  
                      raise exception 'Existe mas de un aprobador para el monto (%), revice la configuracion para los funcionarios: <br> %',v_total_soli,v_mensaje_resp;
                  
                  ELSIF   v_cont = 0  THEN
                   
                    raise exception 'no se encontro ningun RPC par ael monto %',v_total_soli;
                  
                  ELSIF v_cont = 1 THEN
                    --actualiza 
                     -- actualiza el nuevo rpc
          
                     update adq.tsolicitud  set 
                       id_funcionario_rpc= v_registros.id_funcionario,
                       id_cargo_rpc= v_registros.id_cargo,
                       id_cargo_rpc_ai= v_registros.id_cargo_ai,
                       ai_habilitado= v_registros.ai_habilitado,
                       id_usuario_mod=p_id_usuario,
                       fecha_mod=now(),
                       id_usuario_ai= v_parametros._id_usuario_ai,
                       usuario_ai = v_parametros._nombre_usuario_ai
                      where id_solicitud = v_parametros.id_solicitud;
                  
                  --TODO segun el estado de la solicitud, si el RPC tiene un estado activo, cambiar el estado
                  IF v_registros_sol.estado = 'vbrpc' THEN
                       update  wf.testado_wf  set
                           id_funcionario =  v_registros.id_funcionario
                      where id_estado_wf = v_registros_sol.id_estado_wf;
                  END IF;
                  
                  --TODO segun el estado de la cotizacion, si el RPC tiene un estado activo, cambiar el estado
                  else
                    raise exception 'no reconocido';
                  
                  END IF;
            
        
            --Devuelve la respuesta
            return v_resp;

		end;    
       
        
        
    /*********************************    
 	#TRANSACCION:  'ADQ_CLONRPC_IME'
 	#DESCRIPCION:	clona el rpc selecionado en sus registros marcados con la fecha inicial y fecha fin,
                    hacia el id_cargo selecionado en las nueva fecha inicio y fecha fin
 	#AUTOR:		RAC	
 	#FECHA:		02-06-2014 15:57:51
	***********************************/

	elsif(p_transaccion='ADQ_CLONRPC_IME')then

		begin
			--inserta rpc con el cargo selecionado
             -- chequea que el cargo  no este duplicado
             
           
           select 
             r.id_rpc
           into 
              v_id_rpc
           from adq.trpc r   
           where r.id_cargo = v_parametros.id_cargo 
             and r.estado_reg = 'activo';  
             
          --si el cargo no existe como rpc creamos uno nuevo 
          IF v_id_rpc is NULL THEN
              --Sentencia de la insercion
              insert into adq.trpc(
                  id_cargo,
                  estado_reg,
                  ai_habilitado,
                  id_usuario_reg,
                  id_usuario_ai,
                  usuario_ai,
                  fecha_reg
      			
                  ) values(
                  v_parametros.id_cargo,
                  'activo',
                  'no',
                  p_id_usuario,
                  v_parametros._id_usuario_ai,
                  v_parametros._nombre_usuario_ai,
                  now()
  							
              )RETURNING id_rpc into v_id_rpc;
			
            END IF;
            
            v_count = 0;
            FOR v_registros in (
                                 SELECT
                                    ruo.fecha_ini,
                                    ruo.monto_min,
                                    ruo.monto_max,
                                    ruo.id_uo,
                                    ruo.id_categoria_compra
            
                                FROM adq.trpc_uo ruo
                                WHERE ruo.fecha_ini = v_parametros.fecha_ini   
                                and ruo.fecha_fin = v_parametros.fecha_fin 
                                and ruo.id_rpc = v_parametros.id_rpc
                                and ruo.estado_reg = 'activo'
                       )LOOP
            
                
                    select
                        v_registros.monto_min as monto_min,
                        v_registros.monto_max as monto_max,
                        v_parametros.new_fecha_ini as fecha_ini,
                        v_parametros.new_fecha_fin as fecha_fin,
                        v_registros.id_uo as id_uo,
                         v_registros.id_categoria_compra as id_categoria_compra,
                        v_parametros._id_usuario_ai as _id_usuario_ai,
                        v_parametros._nombre_usuario_ai as _nombre_usuario_ai,
                        v_id_rpc as id_rpc
                        
                    
                    into v_registros_det;
                    
                    
            
            
                    v_id_rpc_uo =  adq.f_inserta_rpc_uo(p_administrador, p_id_usuario, hstore(v_registros_det));
                
                    v_count = v_count +1;
            
            
            END LOOP;
            
            
            
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje',v_count::varchar||' rango(s) insertado'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_rpc',v_parametros.id_rpc::varchar);
              
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