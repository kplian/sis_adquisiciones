--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.ft_rpc_uo_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.ft_rpc_uo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'adq.trpc_uo'
 AUTOR: 		 (admin)
 FECHA:	        29-05-2014 15:58:17
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

	v_nombre_funcion = 'adq.ft_rpc_uo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_RUO_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		29-05-2014 15:58:17
	***********************************/

	if(p_transaccion='ADQ_RUO_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						ruo.id_rpc_uo,
						ruo.id_rpc,
						ruo.id_uo,
						ruo.monto_max,
						ruo.estado_reg,
						ruo.fecha_fin,
						ruo.fecha_ini,
						ruo.monto_min,
						ruo.id_usuario_reg,
						ruo.id_usuario_ai,
						ruo.fecha_reg,
						ruo.usuario_ai,
						ruo.id_usuario_mod,
						ruo.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        uo.nombre_unidad  as desc_uo,
                        ruo.id_categoria_compra,	
                        cat.nombre as desc_categoria_compra
						from adq.trpc_uo ruo
						inner join segu.tusuario usu1 on usu1.id_usuario = ruo.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ruo.id_usuario_mod
                        inner join orga.tuo uo on uo.id_uo = ruo.id_uo
                        inner join adq.tcategoria_compra cat on cat.id_categoria_compra = ruo.id_categoria_compra 
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_RUO_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		29-05-2014 15:58:17
	***********************************/

	elsif(p_transaccion='ADQ_RUO_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_rpc_uo)
					    from adq.trpc_uo ruo
						inner join segu.tusuario usu1 on usu1.id_usuario = ruo.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ruo.id_usuario_mod
                        inner join orga.tuo uo on uo.id_uo = ruo.id_uo
                        inner join adq.tcategoria_compra cat on cat.id_categoria_compra = ruo.id_categoria_compra 
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