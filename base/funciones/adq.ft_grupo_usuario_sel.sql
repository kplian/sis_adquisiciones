--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.ft_grupo_usuario_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.ft_grupo_usuario_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'adq.tgrupo_usuario'
 AUTOR: 		 (admin)
 FECHA:	        09-05-2013 22:46:48
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

	v_nombre_funcion = 'adq.ft_grupo_usuario_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_GRUS_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		09-05-2013 22:46:48
	***********************************/

	if(p_transaccion='ADQ_GRUS_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						grus.id_grupo_usuario,
						grus.estado_reg,
						grus.id_usuario,
						grus.obs,
						grus.id_grupo,
						grus.fecha_reg,
						grus.id_usuario_reg,
						grus.id_usuario_mod,
						grus.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        usu.desc_persona
						from adq.tgrupo_usuario grus
                        inner join segu.vusuario usu on usu.id_usuario = grus.id_usuario
                        inner join segu.tusuario usu1 on usu1.id_usuario = grus.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = grus.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_GRUS_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		09-05-2013 22:46:48
	***********************************/

	elsif(p_transaccion='ADQ_GRUS_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_grupo_usuario)
					    from adq.tgrupo_usuario grus
                        inner join segu.vusuario usu on usu.id_usuario = grus.id_usuario
                        inner join segu.tusuario usu1 on usu1.id_usuario = grus.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = grus.id_usuario_mod
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