--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.ft_comision_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.ft_comision_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'adq.tcomision'
 AUTOR: 		 (admin)
 FECHA:	        13-04-2017 14:36:54
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

	v_nombre_funcion = 'adq.ft_comision_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_COM_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		13-04-2017 14:36:54
	***********************************/

	if(p_transaccion='ADQ_COM_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						tc.id_integrante,
						tc.id_funcionario,
                        tc.orden,
						tc.estado_reg,
						tc.fecha_reg,
						tc.usuario_ai,
						tc.id_usuario_reg,
						tc.id_usuario_ai,
						tc.fecha_mod,
						tc.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        vf.desc_funcionario1::varchar AS desc_funcionario1	
						from adq.tcomision tc
						inner join segu.tusuario usu1 on usu1.id_usuario = tc.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tc.id_usuario_mod
                        LEFT JOIN orga.vfuncionario vf ON vf.id_funcionario = tc.id_funcionario
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_COM_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		13-04-2017 14:36:54
	***********************************/

	elsif(p_transaccion='ADQ_COM_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_integrante)
					    from adq.tcomision tc
					    inner join segu.tusuario usu1 on usu1.id_usuario = tc.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tc.id_usuario_mod
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