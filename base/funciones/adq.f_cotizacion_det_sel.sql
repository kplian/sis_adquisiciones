--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_cotizacion_det_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.f_cotizacion_det_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'adq.tcotizacion_det'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        21-03-2013 21:44:43
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

	v_nombre_funcion = 'adq.f_cotizacion_det_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_CTD_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		21-03-2013 21:44:43
	***********************************/

	if(p_transaccion='ADQ_CTD_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						ctd.id_cotizacion_det,
						ctd.estado_reg,
						ctd.id_cotizacion,
						ctd.precio_unitario,
						ctd.cantidad_adju,
						ctd.cantidad_coti,
						ctd.obs,
						ctd.id_solicitud_det,
                        cig.desc_ingas, 
						ctd.fecha_reg,
						ctd.id_usuario_reg,
						ctd.fecha_mod,
						ctd.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        cc.codigo_cc as desc_centro_costo,
                        sold.cantidad as cantidad_sol,
                        sold.precio_unitario as precio_unitario_sol,
                        sold.descripcion as descripcion_sol,
                        ctd.precio_unitario_mb ,
                        sold.precio_unitario_mb as precio_unitario_mb_sol,
                        sold.revertido_mb,
                        sold.revertido_mo		
						from adq.tcotizacion_det ctd
						inner join segu.tusuario usu1 on usu1.id_usuario = ctd.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ctd.id_usuario_mod
				        inner join adq.tsolicitud_det sold on sold.id_solicitud_det=  ctd.id_solicitud_det
				        inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = sold.id_concepto_ingas
						inner join param.vcentro_costo cc on cc.id_centro_costo = sold.id_centro_costo
                        where ctd.id_cotizacion='||v_parametros.id_cotizacion||' and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
             
            RAISE notice '%',v_consulta;
            
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_CTD_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		21-03-2013 21:44:43
	***********************************/

	elsif(p_transaccion='ADQ_CTD_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_cotizacion_det)
					    from adq.tcotizacion_det ctd
						inner join segu.tusuario usu1 on usu1.id_usuario = ctd.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ctd.id_usuario_mod
				        inner join adq.tsolicitud_det sold on sold.id_solicitud_det=  ctd.id_solicitud_det
				        inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = sold.id_concepto_ingas
						inner join param.vcentro_costo cc on cc.id_centro_costo = sold.id_centro_costo
                        where ctd.id_cotizacion='||v_parametros.id_cotizacion||' and ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
	/*********************************    
 	#TRANSACCION:  'ADQ_CTDAGR_SEL'
 	#DESCRIPCION:	Consulta de datos agrupados
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		21-03-2013 21:44:43
	***********************************/

	elseif(p_transaccion='ADQ_CTDAGR_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                             sum(sold.cantidad) as cantidad_sol,
                             sold.precio_unitario as precio_unitario_sol,
                             sum(ctd.cantidad_coti) as cantidad_coti,
                             sum(ctd.cantidad_adju) as cantidad_adju,
                             ctd.precio_unitario,
                             cig.desc_ingas, 
                             lower(trim(sold.descripcion)) as descripcion_sol			
                          from adq.tcotizacion_det ctd
                          inner join segu.tusuario usu1 on usu1.id_usuario = ctd.id_usuario_reg
                          left join segu.tusuario usu2 on usu2.id_usuario = ctd.id_usuario_mod
                          inner join adq.tsolicitud_det sold on sold.id_solicitud_det=  ctd.id_solicitud_det
                          inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = sold.id_concepto_ingas
                          inner join param.vcentro_costo cc on cc.id_centro_costo = sold.id_centro_costo
                        WHERE ctd.id_cotizacion = '||v_parametros.id_cotizacion||' and ctd.estado_reg = ''activo'' 
                         ';
			
			--Definicion de la respuesta
			
			v_consulta:=v_consulta||'  GROUP BY
                                         ctd.precio_unitario,
                                         sold.precio_unitario,                                    
                  						 cig.desc_ingas, 
                                         lower(trim(sold.descripcion))
                                    ORDER BY descripcion_sol asc';

            --raise exception '%',v_consulta;
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