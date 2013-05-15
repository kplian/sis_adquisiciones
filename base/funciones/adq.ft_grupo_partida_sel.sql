--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.ft_grupo_partida_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.ft_grupo_partida_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'adq.tgrupo_partida'
 AUTOR: 		 (admin)
 FECHA:	        09-05-2013 22:46:52
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

	v_nombre_funcion = 'adq.ft_grupo_partida_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_GRPA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		09-05-2013 22:46:52
	***********************************/

	if(p_transaccion='ADQ_GRPA_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						grpa.id_grupo_partida,
						grpa.id_partida,
						grpa.id_grupo,
						grpa.estado_reg,
						grpa.id_usuario_reg,
						grpa.fecha_reg,
						grpa.fecha_mod,
						grpa.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        par.nombre_partida,
                        par.codigo||'' - ''||  par.nombre_partida as desc_partida,
                        grpa.id_gestion		
						from adq.tgrupo_partida grpa
						inner join segu.tusuario usu1 on usu1.id_usuario = grpa.id_usuario_reg
                        inner join pre.tpartida par on par.id_partida = grpa.id_partida
						left join segu.tusuario usu2 on usu2.id_usuario = grpa.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_GRPA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		09-05-2013 22:46:52
	***********************************/

	elsif(p_transaccion='ADQ_GRPA_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_grupo_partida)
					    from adq.tgrupo_partida grpa
					    inner join segu.tusuario usu1 on usu1.id_usuario = grpa.id_usuario_reg
                        inner join pre.tpartida par on par.id_partida = grpa.id_partida
						left join segu.tusuario usu2 on usu2.id_usuario = grpa.id_usuario_mod
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