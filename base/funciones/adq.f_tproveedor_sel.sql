--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_tproveedor_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Parametros Generales
 FUNCION: 		param.f_tproveedor_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'param.tproveedor'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        01-03-2013 10:44:58
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
    v_where 			varchar;
			    
BEGIN

	v_nombre_funcion = 'adq.f_tproveedor_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_PROVEE_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		01-03-2013 10:44:58
	***********************************/

    if v_parametros.tipo='persona' then
        v_where:= 'provee.id_institucion is null';
    elsif v_parametros.tipo='institucion' then
        v_where:= 'provee.id_persona is null';
    end if;
	if(p_transaccion='ADQ_PROVEE_SEL')then
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						provee.id_proveedor,
						provee.id_institucion,
						provee.id_persona,
						provee.tipo,
					    provee.numero_sigma,
						provee.codigo,
                        provee.nit,
                        provee.id_lugar,
						provee.estado_reg,
						provee.id_usuario_reg,
						provee.fecha_reg,
						provee.id_usuario_mod,
						provee.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        person.nombre_completo1,
                        instit.nombre,
                        lug.nombre as lugar,
                        (case when person.id_persona is null then
                        	instit.nombre
                        else
                        	person.nombre_completo1
                        end):: varchar as nombre_proveedor,
                        provee.rotulo_comercial,
                        person.ci,
                        (case when person.id_persona is null then
                        	instit.direccion
                        else
                        	person.direccion
                        end):: varchar as desc_dir_proveedor,
						provee.contacto,
                        provee.tipo as tipo_prov
                        from param.tproveedor provee
						inner join segu.tusuario usu1 on usu1.id_usuario = provee.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = provee.id_usuario_mod   
                        left join segu.vpersona2 person on person.id_persona=provee.id_persona
                        left join param.tinstitucion instit on instit.id_institucion=provee.id_institucion
                        left join param.tlugar lug on lug.id_lugar = provee.id_lugar
				        where '||v_where||' and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_PROVEE_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		01-03-2013 10:44:58
	***********************************/

	elsif(p_transaccion='ADQ_PROVEE_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_proveedor)
					    from param.tproveedor provee
						inner join segu.tusuario usu1 on usu1.id_usuario = provee.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = provee.id_usuario_mod   
                        left join segu.vpersona2 person on person.id_persona=provee.id_persona
                        left join param.tinstitucion instit on instit.id_institucion=provee.id_institucion
                        left join param.tlugar lug on lug.id_lugar = provee.id_lugar
				        where '||v_where||' and ';
			
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