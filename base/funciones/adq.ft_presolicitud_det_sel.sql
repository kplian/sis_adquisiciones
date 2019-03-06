CREATE OR REPLACE FUNCTION adq.ft_presolicitud_det_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.ft_presolicitud_det_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'adq.tpresolicitud_det'
 AUTOR: 		 (admin)
 FECHA:	        10-05-2013 05:04:17
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
  ISSUE			 FECHA:	  	 	AUTOR:				DESCRIPCION:
 #1				10/12/2018		EGS					Se aumento el campo de precio	
			
		
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_filtro varchar;
			    
BEGIN

	v_nombre_funcion = 'adq.ft_presolicitud_det_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_PRED_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		10-05-2013 05:04:17
	***********************************/

	if(p_transaccion='ADQ_PRED_SEL')then
     				
    	begin
        
       			
    		--Sentencia de la consulta
			v_consulta:='select pred.id_presolicitud_det,
                                 pred.descripcion,
                                 pred.cantidad,
                                 pred.id_centro_costo,
                                 pred.estado_reg,
                                 pred.estado,
                                 pred.id_solicitud_det,
                                 pred.id_presolicitud,
                                 pred.id_concepto_ingas,
                                 pred.fecha_reg,
                                 pred.id_usuario_reg,
                                 pred.id_usuario_mod,
                                 pred.fecha_mod,
                                 usu1.cuenta as usr_reg,
                                 usu2.cuenta as usr_mod,
                                 cc.codigo_cc,
                                 cig.desc_ingas,
                                 pred.precio,
                                 sol.num_tramite, 	--#1 10/12/2018	EGS	
                                 sol.id_solicitud
                          from adq.tpresolicitud_det pred
                               inner join segu.tusuario usu1 on usu1.id_usuario = pred.id_usuario_reg
                               inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = pred.id_concepto_ingas
                               inner join param.vcentro_costo cc on cc.id_centro_costo = pred.id_centro_costo
                               left join adq.tsolicitud_det sold on sold.id_solicitud_det = pred.id_solicitud_det
                               left join adq.tsolicitud sol on sol.id_solicitud = sold.id_solicitud 
                               left join segu.tusuario usu2 on usu2.id_usuario = pred.id_usuario_mod
				        where   ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_PRED_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		10-05-2013 05:04:17
	***********************************/

	elsif(p_transaccion='ADQ_PRED_CONT')then

		begin
        
          
        
        
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_presolicitud_det)
					     from adq.tpresolicitud_det pred
                               inner join segu.tusuario usu1 on usu1.id_usuario = pred.id_usuario_reg
                               inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = pred.id_concepto_ingas
                               inner join param.vcentro_costo cc on cc.id_centro_costo = pred.id_centro_costo
                               left join segu.tusuario usu2 on usu2.id_usuario = pred.id_usuario_mod
				         where  ';
			
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