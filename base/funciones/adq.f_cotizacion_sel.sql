--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_cotizacion_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.f_cotizacion_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'adq.tcotizacion'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        21-03-2013 14:48:35
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
    v_add_filtro 		varchar;
    v_cotizaciones		record;
			    
BEGIN

	v_nombre_funcion = 'adq.f_cotizacion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_COT_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		21-03-2013 14:48:35
	***********************************/

	if(p_transaccion='ADQ_COT_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						cot.id_cotizacion,
						cot.estado_reg,
						cot.estado,
						cot.lugar_entrega,
						cot.tipo_entrega,
						cot.fecha_coti,
						cot.numero_oc,
						cot.id_proveedor,
                        pro.desc_proveedor,
						
						
						cot.fecha_entrega,
						cot.id_moneda,
                        mon.moneda,
						cot.id_proceso_compra,
						cot.fecha_venc,
						cot.obs,
						cot.fecha_adju,
						cot.nro_contrato,
						
						cot.fecha_reg,
						cot.id_usuario_reg,
						cot.fecha_mod,
						cot.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        cot.id_estado_wf,
                        cot.id_proceso_wf,
                        mon.codigo as desc_moneda,
                        cot.tipo_cambio_conv,
                        pro.email
						from adq.tcotizacion cot
						inner join segu.tusuario usu1 on usu1.id_usuario = cot.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cot.id_usuario_mod
				        inner join param.tmoneda mon on mon.id_moneda = cot.id_moneda
                        inner join param.vproveedor pro on pro.id_proveedor = cot.id_proveedor
                        
                        where cot.id_proceso_compra='||v_parametros.id_proceso_compra||' and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;
        
    /*********************************    
 	#TRANSACCION:  'ADQ_COTPROC_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		06-06-2013 12:55:30
	***********************************/

	elsif(p_transaccion='ADQ_COTPROC_SEL')then
     				
    	begin
        
    		--Sentencia de la consulta
			v_consulta:='select cot.id_cotizacion
                        from adq.tcotizacion cot
                        inner join adq.tproceso_compra pc on pc.id_proceso_compra=cot.id_proceso_compra 
                        where pc.id_proceso_compra='||v_parametros.id_proceso_compra||' and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			
			--Devuelve la respuesta
			return v_consulta;
						
		end;
        
     /*********************************    
 	#TRANSACCION:  'ADQ_OBPGCOT_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		06-06-2013 12:55:30
	***********************************/

	elsif(p_transaccion='ADQ_OBPGCOT_SEL')then
     				
    	begin
        
    		--Sentencia de la consulta
			v_consulta:='select op.id_obligacion_pago
                        from adq.tcotizacion cot
                        inner join tes.tobligacion_pago op on op.id_obligacion_pago=cot.id_obligacion_pago
                        where cot.id_cotizacion='||v_parametros.id_cotizacion||' and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			
			--Devuelve la respuesta
			return v_consulta;
						
		end;   
         
    
	/*********************************    
 	#TRANSACCION:  'ADQ_COTRPC_SEL'
 	#DESCRIPCION:	Consulta de datos para los funcionarios rpc
 	#AUTOR:	     Rensi Arteaga Copari
 	#FECHA:		07-05-2013 14:48:35
	***********************************/

	elsif(p_transaccion='ADQ_COTRPC_SEL')then
     				
    	begin
        
            IF p_administrador != 1 THEN
            
            	v_add_filtro = 'sol.id_funcionario_rpc = '||v_parametros.id_funcionario_rpc||'  and  ';
                
            ELSE 
               v_add_filtro='  ';
            
            END IF;
        
    		--Sentencia de la consulta
			v_consulta:='select
						cot.id_cotizacion,
						cot.estado_reg,
						cot.estado,
						cot.lugar_entrega,
						cot.tipo_entrega,
						cot.fecha_coti,
						cot.numero_oc,
						cot.id_proveedor,
                        pro.desc_proveedor,
						
						
						cot.fecha_entrega,
						cot.id_moneda,
                        mon.moneda,
						cot.id_proceso_compra,
						cot.fecha_venc,
						cot.obs,
						cot.fecha_adju,
						cot.nro_contrato,
						
						cot.fecha_reg,
						cot.id_usuario_reg,
						cot.fecha_mod,
						cot.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        cot.id_estado_wf,
                        cot.id_proceso_wf,
                        mon.codigo as desc_moneda,
                        cot.tipo_cambio_conv,
                        sol.id_solicitud,
                        sol.id_categoria_compra
						from adq.tcotizacion cot
						inner join segu.tusuario usu1 on usu1.id_usuario = cot.id_usuario_reg
                        inner join adq.tproceso_compra pc on pc.id_proceso_compra = cot.id_proceso_compra
                        inner join adq.tsolicitud sol on sol.id_solicitud = pc.id_solicitud
						left join segu.tusuario usu2 on usu2.id_usuario = cot.id_usuario_mod
				        inner join param.tmoneda mon on mon.id_moneda = cot.id_moneda
                        inner join param.vproveedor pro on pro.id_proveedor = cot.id_proveedor
                        where  (cot.estado=''recomendado''  or  cot.estado=''adjudicado'') and '|| v_add_filtro ||' ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;
    /*********************************    
 	#TRANSACCION:  'ADQ_COTREP_SEL'
 	#DESCRIPCION:	Consulta de registros para los reportes
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		22-03-2013
	***********************************/
	elsif (p_transaccion='ADQ_COTREP_SEL')then
    	begin
        	v_consulta:='select cot.estado,
        						cot.fecha_adju,
        					    cot.fecha_coti,
        						cot.fecha_entrega,
        						cot.fecha_venc,
        					    cot.id_moneda,
        						mon.moneda,
        						cot.id_proceso_compra,
                                pc.codigo_proceso,
        						pc.num_cotizacion,
        						pc.num_tramite,
        						cot.id_proveedor,
                                pv.desc_proveedor,
                                pv.id_persona,
                                pv.id_institucion,
                                per.direccion as dir_per,
                                per.telefono1 as tel_per1,
                                per.telefono2 as tel_per2,
                                per.celular1 as cel_per,
                                per.correo,
                                ins.nombre as nombre_ins,
                                ins.celular1 as cel_ins,
                                ins.direccion as dir_ins,
                                ins.fax,
                                ins.email1 as email_ins,
                                ins.telefono1 as tel_ins1,
                                ins.telefono2 as tel_ins2,
        						cot.lugar_entrega,
        						cot.nro_contrato,
        						cot.numero_oc,
        						cot.obs,
                                cot.tipo_entrega
						from adq.tcotizacion cot
                        inner join param.tmoneda mon on mon.id_moneda=cot.id_moneda
                        inner join adq.tproceso_compra pc on pc.id_proceso_compra=cot.id_proceso_compra
                        inner join param.vproveedor pv on pv.id_proveedor=cot.id_proveedor
                        left join segu.tpersona per on per.id_persona=pv.id_persona
                        left join param.tinstitucion ins on ins.id_institucion=pv.id_institucion
                        where     cot.id_cotizacion='||v_parametros.id_cotizacion||' and ';
                        
            --Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
        end;
        
   /*********************************    
 	#TRANSACCION:  'ADQ_ESTCOT_SEL'
 	#DESCRIPCION:	Consulta de registros para los reportes
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		31-04-2013
	***********************************/
	elsif (p_transaccion='ADQ_ESTCOT_SEL')then
    	begin
        
        create temporary table flujo_cotizaciones(
        funcionario text,
        nombre text,
        nombre_estado varchar,
        fecha_reg date,
        id_tipo_estado int4,
        id_estado_wf int4,
        id_estado_anterior int4
        ) on commit drop;   
    
    	--recupera el flujo de control de las cotizaciones
        
    	FOR v_cotizaciones IN( 
            select cot.id_estado_wf,cot.numero_oc, prv.desc_proveedor
            from adq.tcotizacion cot
            inner join param.vproveedor prv on prv.id_proveedor=cot.id_proveedor
            where cot.id_cotizacion=v_parametros.id_cotizacion
        )LOOP
        	   INSERT INTO flujo_cotizaciones(
        	   WITH RECURSIVE estados_solicitud(id_depto, id_proceso_wf, id_tipo_estado,id_estado_wf, id_estado_anterior, fecha_reg)AS(
                  SELECT et.id_depto, et.id_proceso_wf, et.id_tipo_estado, et.id_estado_wf, et.id_estado_anterior, et.fecha_reg
                  FROM wf.testado_wf et
                  WHERE et.id_estado_wf=v_cotizaciones.id_estado_wf     
               UNION ALL        
                  SELECT et.id_depto, et.id_proceso_wf, et.id_tipo_estado, et.id_estado_wf, et.id_estado_anterior, et.fecha_reg
                  FROM wf.testado_wf et, estados_solicitud
                  WHERE et.id_estado_wf=estados_solicitud.id_estado_anterior         
               )SELECT dep.nombre::text, tp.nombre||'-'||prv.desc_proveedor, te.nombre_estado, es.fecha_reg, es.id_tipo_estado, es.id_estado_wf, COALESCE(es.id_estado_anterior,NULL) as id_estado_anterior
                      FROM estados_solicitud es
                      INNER JOIN wf.ttipo_estado te on te.id_tipo_estado= es.id_tipo_estado
                      INNER JOIN wf.tproceso_wf pwf on pwf.id_proceso_wf=es.id_proceso_wf
                      INNER JOIN wf.ttipo_proceso tp on tp.id_tipo_proceso=pwf.id_tipo_proceso
                      INNER JOIN adq.tcotizacion cot on  cot.id_proceso_wf=pwf.id_proceso_wf
                      INNER JOIN param.vproveedor prv on prv.id_proveedor=cot.id_proveedor
                      INNER JOIN param.tdepto dep on dep.id_depto=es.id_depto
                      ORDER BY es.id_estado_wf ASC
                      );      
        END LOOP;
        	
        	v_consulta:='select * from flujo_cotizaciones';
			--Devuelve la respuesta
			return v_consulta;
        end;

	/*********************************    
 	#TRANSACCION:  'ADQ_COTOC_REP'
 	#DESCRIPCION:	Reporte Orden Compra
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		08-04-2013
	***********************************/
	elsif(p_transaccion='ADQ_COTOC_REP')then
    	begin
		v_consulta:='select  
        			pv.desc_proveedor,
                    per.id_persona,
					per.direccion as dir_persona,
			        per.telefono1 as telf1_persona,
                    per.telefono2 as telf2_persona,
                    per.celular1 as cel_persona,
                    per.correo as correo_persona,
                    ins.id_institucion,
                    ins.direccion as dir_institucion,
                    ins.telefono1 as telf1_institucion,
                    ins.telefono2 as telf2_institucion,
                    ins.celular1 as cel_institucion,
                    ins.email1 as email_institucion,
                    ins.fax as fax_institucion,
                    cot.fecha_entrega,
                    sol.lugar_entrega,
                    cot.numero_oc,
                    cot.tipo_entrega,
                    cot.id_proceso_compra,
                    sol.tipo,
                    current_date as fecha_oc,
                    mon.moneda
              from adq.tcotizacion cot 
              inner join param.vproveedor pv on pv.id_proveedor=cot.id_proveedor
              left join segu.tpersona per on per.id_persona=pv.id_persona
              left join param.tinstitucion ins on ins.id_institucion= pv.id_institucion
              inner join adq.tproceso_compra pc on pc.id_proceso_compra=cot.id_proceso_compra
			  inner join adq.tsolicitud sol on sol.id_solicitud=pc.id_solicitud
			  inner join param.tmoneda mon on mon.id_moneda=cot.id_moneda
              where cot.estado=''adjudicado'' or cot.estado=''pago_habilitado'' and cot.id_cotizacion='||v_parametros.id_cotizacion|| ' and ';
          
          --Definicion de la respuesta
          v_consulta:=v_consulta||v_parametros.filtro;
          v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

          --Devuelve la respuesta
          return v_consulta;
        end;
        
	/*********************************    
 	#TRANSACCION:  'ADQ_COTRPC_CONT'
 	#DESCRIPCION:	Conteo de registros de la consulta de cotizaciones por RPC
 	#AUTOR:		    Rensi Arteaga Copari
 	#FECHA:		21-03-2013 14:48:35
	***********************************/

	elsif(p_transaccion='ADQ_COTRPC_CONT')then

		begin
        
            IF p_administrador != 1 THEN
            
            	v_add_filtro = 'sol.id_funcionario_rpc = '||v_parametros.id_funcionario_rpc||'  and';
                
            ELSE 
               v_add_filtro='  ';
            
            END IF;
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_cotizacion)
					    from adq.tcotizacion cot
						inner join segu.tusuario usu1 on usu1.id_usuario = cot.id_usuario_reg
                        inner join adq.tproceso_compra pc on pc.id_proceso_compra = cot.id_proceso_compra
                        inner join adq.tsolicitud sol on sol.id_solicitud = pc.id_solicitud
						left join segu.tusuario usu2 on usu2.id_usuario = cot.id_usuario_mod
				        inner join param.tmoneda mon on mon.id_moneda = cot.id_moneda
                        inner join param.vproveedor pro on pro.id_proveedor = cot.id_proveedor
                        where (cot.estado=''recomendado''  or  cot.estado=''adjudicado'')  and '|| v_add_filtro ||' ';
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
        
      
	/*********************************    
 	#TRANSACCION:  'ADQ_COT_CONT'
 	#DESCRIPCION:	Conteo de registros de la consulta de cotizaciones 
 	#AUTOR:	 	Gonzalo Sarmiento Sejas
 	#FECHA:		21-03-2013 14:48:35
	***********************************/

	elsif(p_transaccion='ADQ_COT_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_cotizacion)
					    from adq.tcotizacion cot
						inner join segu.tusuario usu1 on usu1.id_usuario = cot.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cot.id_usuario_mod
				        inner join param.tmoneda mon on mon.id_moneda = cot.id_moneda
                        inner join param.vproveedor pro on pro.id_proveedor = cot.id_proveedor
                        where cot.id_proceso_compra='||v_parametros.id_proceso_compra||' and ';
			
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