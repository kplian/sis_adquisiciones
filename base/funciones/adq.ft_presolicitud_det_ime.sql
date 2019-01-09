--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.ft_presolicitud_det_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.ft_presolicitud_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'adq.tpresolicitud_det'
 AUTOR: 		 (admin)
 FECHA:	        10-05-2013 05:04:17
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
  ISSUE			 FECHA:	  	 	AUTOR:				DESCRIPCION:
 #1				10/12/2018		EGS					Se aumento el campo de precio	
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_presolicitud_det	integer;
			    
BEGIN

    v_nombre_funcion = 'adq.ft_presolicitud_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_PRED_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		10-05-2013 05:04:17
	***********************************/

	if(p_transaccion='ADQ_PRED_INS')then
					
        begin
        	
           IF v_parametros.cantidad_sol <=0 THEN
           
             raise exception 'La cantidad debe ser mayor a cero';
           
           END IF;
        
        	--Sentencia de la insercion
        	insert into adq.tpresolicitud_det(
			descripcion,
			cantidad,
            precio,	--#1 10/12/2018	EGS
			id_centro_costo,
			estado_reg,
			estado,
			id_presolicitud,
			id_concepto_ingas,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.descripcion,
			v_parametros.cantidad_sol,
            v_parametros.precio, --#1 10/12/2018	EGS
			v_parametros.id_centro_costo,
			'activo',
			'pendiente',
			v_parametros.id_presolicitud,
			v_parametros.id_concepto_ingas,
			now(),
			p_id_usuario,
			null,
			null
							
			)RETURNING id_presolicitud_det into v_id_presolicitud_det;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Presolicitud Detalle almacenado(a) con exito (id_presolicitud_det'||v_id_presolicitud_det||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presolicitud_det',v_id_presolicitud_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_PRED_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		10-05-2013 05:04:17
	***********************************/

	elsif(p_transaccion='ADQ_PRED_MOD')then

		begin
			--Sentencia de la modificacion
			update adq.tpresolicitud_det set
			descripcion = v_parametros.descripcion,
			cantidad = v_parametros.cantidad_sol,
			id_centro_costo = v_parametros.id_centro_costo,
			id_presolicitud = v_parametros.id_presolicitud,
			id_concepto_ingas = v_parametros.id_concepto_ingas,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
            precio = v_parametros.precio --#1 10/12/2018	EGS
			where id_presolicitud_det=v_parametros.id_presolicitud_det;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Presolicitud Detalle modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presolicitud_det',v_parametros.id_presolicitud_det::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_PRED_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		10-05-2013 05:04:17
	***********************************/

	elsif(p_transaccion='ADQ_PRED_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from adq.tpresolicitud_det
            where id_presolicitud_det=v_parametros.id_presolicitud_det;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Presolicitud Detalle eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presolicitud_det',v_parametros.id_presolicitud_det::varchar);
              
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
