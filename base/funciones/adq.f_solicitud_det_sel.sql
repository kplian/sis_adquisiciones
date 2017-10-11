--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_solicitud_det_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.f_solicitud_det_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'adq.tsolicitud_det'
 AUTOR: 		 (admin)
 FECHA:	        05-03-2013 01:28:10
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
    v_registro			record;
			    
BEGIN

	v_nombre_funcion = 'adq.f_solicitud_det_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_SOLD_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		05-03-2013 01:28:10
	***********************************/

	if(p_transaccion='ADQ_SOLD_SEL')then
     				
       begin
    		--Sentencia de la consulta
			v_consulta:='select
                            sold.id_solicitud_det,
                            sold.id_centro_costo,
                            sold.descripcion,
                            sold.precio_unitario,
                            sold.id_solicitud,
                            sold.id_partida,
                            sold.id_orden_trabajo,
                            sold.precio_sg,
                            sold.id_concepto_ingas,
                            sold.id_cuenta,
                            sold.precio_total,
                            sold.cantidad,
                            sold.id_auxiliar,
                            sold.precio_ga_mb,
                            sold.estado_reg,
                            sold.id_partida_ejecucion,
                            ''false''::varchar as disponible,
                            sold.precio_ga,
                            sold.id_usuario_reg,
                            sold.fecha_reg,
                            sold.fecha_mod,
                            sold.id_usuario_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            cc.codigo_cc as desc_centro_costo,
                            par.codigo as codigo_partida,
                            par.nombre_partida,
                            cta.nro_cuenta,
                            cta.nombre_cuenta,
                            aux.codigo_auxiliar,
                            aux.nombre_auxiliar,
                            cig.desc_ingas as desc_concepto_ingas,
                            ot.desc_orden as desc_orden_trabajo,
                            sold.revertido_mb,
                            sold.revertido_mo,
                            pre.id_presupuesto,
                            pre.id_categoria_prog,
                            c.codigo_categoria
            			from adq.tsolicitud_det sold
                        left join param.tconcepto_ingas cig on cig.id_concepto_ingas = sold.id_concepto_ingas
						inner join segu.tusuario usu1 on usu1.id_usuario = sold.id_usuario_reg
                        left join param.vcentro_costo cc on cc.id_centro_costo = sold.id_centro_costo
                        left join pre.tpartida par on par.id_partida = sold.id_partida
                        left join conta.tcuenta cta on cta.id_cuenta = sold.id_cuenta
                        left join conta.tauxiliar aux on aux.id_auxiliar = sold.id_auxiliar
                        left join pre.tpresupuesto pre on pre.id_centro_costo = cc.id_centro_costo 
						left join segu.tusuario usu2 on usu2.id_usuario = sold.id_usuario_mod
                        left join conta.torden_trabajo ot on ot.id_orden_trabajo = sold.id_orden_trabajo
                        left join pre.vcategoria_programatica c on c.id_categoria_programatica = pre.id_categoria_prog
                        where sold.estado_reg= ''activo'' and sold.id_solicitud ='||v_parametros.id_solicitud||' and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;
		
	
	/*********************************    
 	#TRANSACCION:  'ADQ_SOLD_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		05-03-2013 01:28:10
	***********************************/

	elsif(p_transaccion='ADQ_SOLD_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_solicitud_det) as total,
                        sum(sold.precio_total) as precio_total
					     from adq.tsolicitud_det sold
                        left join param.tconcepto_ingas cig on cig.id_concepto_ingas = sold.id_concepto_ingas
						inner join segu.tusuario usu1 on usu1.id_usuario = sold.id_usuario_reg
                        left join param.vcentro_costo cc on cc.id_centro_costo = sold.id_centro_costo
                        left join pre.tpartida par on par.id_partida = sold.id_partida
                        left join conta.tcuenta cta on cta.id_cuenta = sold.id_cuenta
                        left join conta.tauxiliar aux on aux.id_auxiliar = sold.id_auxiliar
                        left join pre.tpresupuesto pre on pre.id_centro_costo = cc.id_centro_costo 
						left join segu.tusuario usu2 on usu2.id_usuario = sold.id_usuario_mod
                        left join conta.torden_trabajo ot on ot.id_orden_trabajo = sold.id_orden_trabajo
                        left join pre.vcategoria_programatica c on c.id_categoria_programatica = pre.id_categoria_prog
                        where sold.estado_reg= ''activo'' and sold.id_solicitud ='||v_parametros.id_solicitud||' and ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
        
    /*********************************    
 	#TRANSACCION:  'ADQ_SOLDETCOT_SEL'
 	#DESCRIPCION:	Consulta de datos en base al id_cotizacion
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		05-03-2013 01:28:10
	***********************************/
        
    elsif(p_transaccion='ADQ_SOLDETCOT_SEL')then
    	begin
          v_consulta:='select
						sold.id_solicitud_det,
                        sold.descripcion,
                        cc.codigo_cc as desc_centro_costo,
                        cig.desc_ingas as desc_concepto_ingas
						from adq.tsolicitud_det sold
                        inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = sold.id_concepto_ingas
						inner join param.vcentro_costo cc on cc.id_centro_costo = sold.id_centro_costo
                        inner join adq.tproceso_compra pc on pc.id_solicitud = sold.id_solicitud
                        inner join adq.tcotizacion cot on cot.id_proceso_compra = pc.id_proceso_compra
                        where cot.id_cotizacion='||v_parametros.id_cotizacion||' and ';
			--Definicion de la repuesta
            v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            return v_consulta;        	
        end;    
	
    /*********************************    
 	#TRANSACCION:  'ADQ_SOLDETCOT_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		05-03-2013 01:28:10
	***********************************/

	elsif(p_transaccion='ADQ_SOLDETCOT_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_solicitud_det)
					    from adq.tsolicitud_det sold
                        inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = sold.id_concepto_ingas
						inner join param.vcentro_costo cc on cc.id_centro_costo = sold.id_centro_costo
                        inner join adq.tproceso_compra pc on pc.id_solicitud = sold.id_solicitud
                        inner join adq.tcotizacion cot on cot.id_proceso_compra = pc.id_proceso_compra
                        where cot.id_cotizacion='||v_parametros.id_cotizacion||' and ';
			
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