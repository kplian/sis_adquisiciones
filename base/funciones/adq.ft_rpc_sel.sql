--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.ft_rpc_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.ft_rpc_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'adq.trpc'
 AUTOR: 		 (admin)
 FECHA:	        29-05-2014 15:57:51
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'adq.ft_rpc_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_RPC_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		29-05-2014 15:57:51
	***********************************/

	if(p_transaccion='ADQ_RPC_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						rpc.id_rpc,
						rpc.id_cargo,
						rpc.id_cargo_ai,
						rpc.estado_reg,
						rpc.ai_habilitado,
						rpc.id_usuario_reg,
						rpc.id_usuario_ai,
						rpc.usuario_ai,
						rpc.fecha_reg,
						rpc.id_usuario_mod,
						rpc.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        car.nombre as desc_cargo,
                        COALESCE(cars.nombre,'''') as desc_cargo_suplente	
						from adq.trpc rpc
						inner join segu.tusuario usu1 on usu1.id_usuario = rpc.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = rpc.id_usuario_mod
                        inner join orga.tcargo car on car.id_cargo = rpc.id_cargo
                        left join orga.tcargo cars on cars.id_cargo = rpc.id_cargo_ai
                        where  rpc.estado_reg = ''activo'' and';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_RPC_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		29-05-2014 15:57:51
	***********************************/

	elsif(p_transaccion='ADQ_RPC_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_rpc)
					    from adq.trpc rpc
						inner join segu.tusuario usu1 on usu1.id_usuario = rpc.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = rpc.id_usuario_mod
                        inner join orga.tcargo car on car.id_cargo = rpc.id_cargo
                        left join orga.tcargo cars on cars.id_cargo = rpc.id_cargo_ai
                        where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
					
	else
					     
		raise exception 'Transaccion inexistente';
					         
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