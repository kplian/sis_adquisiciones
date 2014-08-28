--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_categoria_compra_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Adquisiciones
 FUNCION: 		adq.f_categoria_compra_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'adq.tcategoria_compra'
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

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'adq.f_categoria_compra_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_CATCOMP_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		06-02-2013 15:59:42
	***********************************/

	if(p_transaccion='ADQ_CATCOMP_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						catcomp.id_categoria_compra,
						catcomp.codigo,
						catcomp.nombre,
						catcomp.obs,
						catcomp.max,
						catcomp.min,
						catcomp.estado_reg,
						catcomp.id_usuario_reg,
						catcomp.fecha_reg,
						catcomp.id_usuario_mod,
						catcomp.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        catcomp.id_proceso_macro,
                        pm.nombre
						from adq.tcategoria_compra catcomp
						inner join segu.tusuario usu1 on usu1.id_usuario = catcomp.id_usuario_reg
                        inner join wf.tproceso_macro  pm on pm.id_proceso_macro = catcomp.id_proceso_macro
						left join segu.tusuario usu2 on usu2.id_usuario = catcomp.id_usuario_mod
				        where  catcomp.estado_reg = ''activo'' and ' ;
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_CATCOMP_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		06-02-2013 15:59:42
	***********************************/

	elsif(p_transaccion='ADQ_CATCOMP_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_categoria_compra)
					    from adq.tcategoria_compra catcomp
					    inner join segu.tusuario usu1 on usu1.id_usuario = catcomp.id_usuario_reg
                        inner join wf.tproceso_macro  pm on pm.id_proceso_macro = catcomp.id_proceso_macro
						left join segu.tusuario usu2 on usu2.id_usuario = catcomp.id_usuario_mod
					    where catcomp.estado_reg = ''activo'' and ';
			
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