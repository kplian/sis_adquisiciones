--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_categoria_compra_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Adquisiciones
 FUNCION: 		adq.f_categoria_compra_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'adq.tcategoria_compra'
 AUTOR: 		 (admin)
 FECHA:	        06-02-2013 15:59:42
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
	v_id_categoria_compra	integer;
			    
BEGIN

    v_nombre_funcion = 'adq.f_categoria_compra_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_CATCOMP_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		06-02-2013 15:59:42
	***********************************/

	if(p_transaccion='ADQ_CATCOMP_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into adq.tcategoria_compra(
			codigo,
			nombre,
			obs,
			max,
			min,
			estado_reg,
			id_usuario_reg,
			fecha_reg,
			id_usuario_mod,
			fecha_mod,
			id_proceso_macro
          	) values(
			v_parametros.codigo,
			v_parametros.nombre,
			v_parametros.obs,
			v_parametros.max,
			v_parametros.min,
			'activo',
			p_id_usuario,
			now(),
			null,
			null,
			v_parametros.id_proceso_macro							
			)RETURNING id_categoria_compra into v_id_categoria_compra;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Categoria de Compra almacenado(a) con exito (id_categoria_compra'||v_id_categoria_compra||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_categoria_compra',v_id_categoria_compra::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_CATCOMP_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		06-02-2013 15:59:42
	***********************************/

	elsif(p_transaccion='ADQ_CATCOMP_MOD')then

		begin
			--Sentencia de la modificacion
			update adq.tcategoria_compra set
			codigo = v_parametros.codigo,
			nombre = v_parametros.nombre,
			obs = v_parametros.obs,
			max = v_parametros.max,
			min = v_parametros.min,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_proceso_macro = v_parametros.id_proceso_macro 
			where id_categoria_compra=v_parametros.id_categoria_compra;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Categoria de Compra modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_categoria_compra',v_parametros.id_categoria_compra::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_CATCOMP_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		06-02-2013 15:59:42
	***********************************/

	elsif(p_transaccion='ADQ_CATCOMP_ELI')then

		begin
			--Sentencia de la eliminacion
            
            update  adq.tcategoria_compra set
            estado_reg = 'inactivo',
            id_usuario_mod = p_id_usuario
            where id_categoria_compra=v_parametros.id_categoria_compra;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Categoria de Compra inactivada'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_categoria_compra',v_parametros.id_categoria_compra::varchar);
              
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