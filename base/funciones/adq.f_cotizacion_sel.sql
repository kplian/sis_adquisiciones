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
      
    v_historico        varchar;
    v_inner            varchar;
  
    v_strg_cot			varchar;
	v_filtro varchar;
    
    		    
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
            IF  pxp.f_existe_parametro(p_tabla, 'id_proceso_compra') THEN
            	v_filtro = 'cot.id_proceso_compra='||v_parametros.id_proceso_compra||' and ';
            ELSE
                v_filtro = '';
            END IF;
            
            
    		--Sentencia de la consulta
			v_consulta:='WITH detalle as (
                                       Select 
                                        cd.id_cotizacion,
                                        sum(cd.cantidad_adju *cd.precio_unitario) as total_adjudicado,
                                        sum(cd.cantidad_coti *cd.precio_unitario) as total_cotizado,
                                        sum(cd.cantidad_adju *cd.precio_unitario_mb) as total_adjudicado_mb
                                      FROM  adq.tcotizacion_det  cd
                                      WHERE cd.estado_reg = ''activo''
                                      GROUP by cd.id_cotizacion
                                      
                        )
                      select
						cot.id_cotizacion,
						cot.estado_reg,
						cot.estado,
						cot.lugar_entrega,
						cot.tipo_entrega,
						cot.fecha_coti,
						COALESCE(cot.numero_oc,''S/N''),
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
                        pro.email,
                        sol.numero,
                        sol.num_tramite,
                        cot.id_obligacion_pago,
                        cot.tiempo_entrega,
                        cot.funcionario_contacto,
                        cot.telefono_contacto,
                        cot.correo_contacto,
                        cot.prellenar_oferta,
                        cot.forma_pago,
                        cot.requiere_contrato,
                        d.total_adjudicado,
                        d.total_cotizado,
                        d.total_adjudicado_mb,
                        cot.tiene_form500,
                        cot.correo_oc
						from adq.tcotizacion cot
                        inner join adq.tproceso_compra proc on proc.id_proceso_compra = cot.id_proceso_compra
                        inner join adq.tsolicitud sol on sol.id_solicitud = proc.id_solicitud
						inner join segu.tusuario usu1 on usu1.id_usuario = cot.id_usuario_reg
						inner join detalle d on d.id_cotizacion = cot.id_cotizacion
				        inner join param.tmoneda mon on mon.id_moneda = cot.id_moneda
                        inner join param.vproveedor pro on pro.id_proveedor = cot.id_proveedor
                        left join segu.tusuario usu2 on usu2.id_usuario = cot.id_usuario_mod
                        
                        where '||v_filtro;
			
           
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
             raise notice '%', v_consulta;
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
        
            IF  pxp.f_existe_parametro(p_tabla, 'id_proceso_compra') THEN
            	v_filtro = 'cot.id_proceso_compra='||v_parametros.id_proceso_compra||' and ';
            ELSE
                v_filtro = '';
            END IF;
            
			--Sentencia de la consulta de conteo de registros
			v_consulta:='WITH detalle as (
                                       Select 
                                        cd.id_cotizacion,
                                        sum(cd.cantidad_adju *cd.precio_unitario) as total_adjudicado,
                                        sum(cd.cantidad_coti *cd.precio_unitario) as total_cotizado,
                                        sum(cd.cantidad_adju *cd.precio_unitario_mb) as total_adjudicado_mb
                                      FROM  adq.tcotizacion_det  cd
                                      WHERE cd.estado_reg = ''activo''
                                      GROUP by cd.id_cotizacion
                                      
                        )
                        SELECT count(cot.id_cotizacion)
					    from adq.tcotizacion cot
                        inner join adq.tproceso_compra proc on proc.id_proceso_compra = cot.id_proceso_compra
                        inner join adq.tsolicitud sol on sol.id_solicitud = proc.id_solicitud
						inner join segu.tusuario usu1 on usu1.id_usuario = cot.id_usuario_reg
						inner join detalle d on d.id_cotizacion = cot.id_cotizacion
				        inner join param.tmoneda mon on mon.id_moneda = cot.id_moneda
                        inner join param.vproveedor pro on pro.id_proveedor = cot.id_proveedor
                        left join segu.tusuario usu2 on usu2.id_usuario = cot.id_usuario_mod
                        
                        where '||v_filtro;
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

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
 	#DESCRIPCION:	Consulta de cotizaciones por estado dinamicos WF
 	#AUTOR:	     Rensi Arteaga Copari
 	#FECHA:		3-11-2013 14:48:35
	***********************************/

	elsif(p_transaccion='ADQ_COTRPC_SEL')then
     				
    	begin
        
           
            
            
            v_add_filtro='';
            
            if (v_parametros.id_funcionario_usu is null) then
              	
                v_parametros.id_funcionario_usu = -1;
            
            end if;
            
           
            IF  lower(v_parametros.tipo_interfaz) = 'cotizacionvb' THEN
                                        
               
                IF p_administrador != 1 THEN
            
            	    v_add_filtro = '(cot.estado=''recomendado''  or  cot.estado=''adjudicado'') and  sol.id_funcionario_rpc = '||v_parametros.id_funcionario_rpc||'  and  ';
                
                ELSE 
                    v_add_filtro='  (cot.estado=''recomendado''  or  cot.estado=''adjudicado'') and ';
            
                END IF;
            
            
            
            END IF;
            
            
            
            IF  lower(v_parametros.tipo_interfaz) = 'cotizacionvbdin' THEN
            
                       
                IF p_administrador !=1 THEN
                
                             
                      v_add_filtro = '  ( ( (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (lower(cot.estado)!=''borrador'') and  (lower(cot.estado)!=''recomendado'') and  (lower(cot.estado)!=''cotizado'') and  (lower(cot.estado)!=''adjudicado'') and  (lower(cot.estado)!=''pago_habilitado'')  and  (lower(cot.estado)!=''finalizado'') )  or    ((cot.estado=''recomendado''  or  cot.estado=''adjudicado'') and  sol.id_funcionario_rpc = '||v_parametros.id_funcionario_rpc||')) and ';
                  
                 
                 
                 ELSE
                      v_add_filtro = ' (lower(cot.estado)!=''borrador'') and   (lower(cot.estado)!=''cotizado'') and  (lower(cot.estado)!=''pago_habilitado'')  and  (lower(cot.estado)!=''finalizado'') and ';
                  
                END IF;
            
            END IF; 
            
            
            IF  pxp.f_existe_parametro(p_tabla,'historico') THEN
             
             v_historico =  v_parametros.historico;
            
            ELSE
            
            v_historico = 'no';
            
            END IF;
            
            IF v_historico =  'si' THEN
            
               v_inner =  'inner join wf.testado_wf ew on ew.id_proceso_wf = cot.id_proceso_wf';
               v_strg_cot = 'DISTINCT(cot.id_cotizacion)'; 
               IF p_administrador =1 THEN
               		v_add_filtro = ' (lower(cot.estado)!=''borrador'' ) and ';
               END IF;
            
            ELSE
            
               v_inner =  'inner join wf.testado_wf ew on ew.id_estado_wf = cot.id_estado_wf';
               v_strg_cot = 'cot.id_cotizacion';
               
               
             END IF;
            
            
             
            
            raise notice 'tipo interface %',v_parametros.tipo_interfaz;
        
    		--Sentencia de la consulta
			v_consulta:='
                          WITH detalle as (
                                                     Select 
                                                      cd.id_cotizacion,
                                                      sum(cd.cantidad_adju *cd.precio_unitario) as total_adjudicado,
                                                      sum(cd.cantidad_coti *cd.precio_unitario) as total_cotizado,
                                                      sum(cd.cantidad_adju *cd.precio_unitario_mb) as total_adjudicado_mb
                                                    FROM  adq.tcotizacion_det  cd
                                                    WHERE cd.estado_reg = ''activo''
                                                    GROUP by cd.id_cotizacion
                                              )
            
           				select
                            '||v_strg_cot||',  
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
                            sol.id_categoria_compra,
                            sol.numero,
                            sol.num_tramite,
                            cot.tiempo_entrega,
                            cot.requiere_contrato,
                            d.total_adjudicado,
                            d.total_cotizado,
                            d.total_adjudicado_mb
						from adq.tcotizacion cot
                        inner join detalle d on d.id_cotizacion = cot.id_cotizacion
						inner join segu.tusuario usu1 on usu1.id_usuario = cot.id_usuario_reg
                        inner join adq.tproceso_compra pc on pc.id_proceso_compra = cot.id_proceso_compra
                        inner join adq.tsolicitud sol on sol.id_solicitud = pc.id_solicitud
						left join segu.tusuario usu2 on usu2.id_usuario = cot.id_usuario_mod
				        inner join param.tmoneda mon on mon.id_moneda = cot.id_moneda
                        inner join param.vproveedor pro on pro.id_proveedor = cot.id_proveedor
                        '||v_inner||'   
                        where  '|| v_add_filtro ||' ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            raise notice  '%',v_consulta;

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
        
           
        
            v_add_filtro='';
            
            if (v_parametros.id_funcionario_usu is null) then
              	
                v_parametros.id_funcionario_usu = -1;
            
            end if;
            
           
            IF  lower(v_parametros.tipo_interfaz) = 'cotizacionvb' THEN
                                        
               
                IF p_administrador != 1 THEN
            
            	    v_add_filtro = '(cot.estado=''recomendado''  or  cot.estado=''adjudicado'') and  sol.id_funcionario_rpc = '||v_parametros.id_funcionario_rpc||'  and  ';
                
                ELSE 
                    v_add_filtro='  (cot.estado=''recomendado''  or  cot.estado=''adjudicado'') and ';
            
                END IF;
            
            
            
            END IF;
            
                        
            
            
            IF  lower(v_parametros.tipo_interfaz) = 'cotizacionvbdin' THEN
            
                       
                IF p_administrador !=1 THEN
                
                             
                      v_add_filtro = '  ( ( (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (lower(cot.estado)!=''borrador'') and  (lower(cot.estado)!=''recomendado'') and  (lower(cot.estado)!=''cotizado'') and  (lower(cot.estado)!=''adjudicado'') and  (lower(cot.estado)!=''pago_habilitado'')  and  (lower(cot.estado)!=''finalizado'') )  or    ((cot.estado=''recomendado''  or  cot.estado=''adjudicado'') and  sol.id_funcionario_rpc = '||v_parametros.id_funcionario_rpc||')) and ';
                  
                 
                 
                 ELSE
                      v_add_filtro = ' (lower(cot.estado)!=''borrador'') and   (lower(cot.estado)!=''cotizado'') and  (lower(cot.estado)!=''pago_habilitado'')  and  (lower(cot.estado)!=''finalizado'') and ';
                  
                END IF;
            
            END IF;
            
            
            IF  pxp.f_existe_parametro(p_tabla,'historico') THEN
             
             v_historico =  v_parametros.historico;
            
            ELSE
            
            v_historico = 'no';
            
            END IF;
            
            IF v_historico =  'si' THEN
            
               v_inner =  'inner join wf.testado_wf ew on ew.id_proceso_wf = cot.id_proceso_wf';
               v_strg_cot = 'DISTINCT(cot.id_cotizacion)'; 
              
               
               IF p_administrador =1 THEN
               		v_add_filtro = ' (lower(cot.estado)!=''borrador'' ) and ';
               END IF;
            
            ELSE
            
               v_inner =  'inner join wf.testado_wf ew on ew.id_estado_wf = cot.id_estado_wf';
               v_strg_cot = 'cot.id_cotizacion';
               
               
             END IF;  
        
        
			--Sentencia de la consulta de conteo de registros
			v_consulta:='
                         WITH detalle as (
                                                     Select 
                                                      cd.id_cotizacion,
                                                      sum(cd.cantidad_adju *cd.precio_unitario) as total_adjudicado,
                                                      sum(cd.cantidad_coti *cd.precio_unitario) as total_cotizado,
                                                      sum(cd.cantidad_adju *cd.precio_unitario_mb) as total_adjudicado_mb
                                                    FROM  adq.tcotizacion_det  cd
                                                    WHERE cd.estado_reg = ''activo''
                                                    GROUP by cd.id_cotizacion
                                              )
                        select count('||v_strg_cot||')
					    from adq.tcotizacion cot
                          inner join detalle d on d.id_cotizacion = cot.id_cotizacion
                          inner join segu.tusuario usu1 on usu1.id_usuario = cot.id_usuario_reg
                          inner join adq.tproceso_compra pc on pc.id_proceso_compra = cot.id_proceso_compra
                          inner join adq.tsolicitud sol on sol.id_solicitud = pc.id_solicitud
                          left join segu.tusuario usu2 on usu2.id_usuario = cot.id_usuario_mod
                          inner join param.tmoneda mon on mon.id_moneda = cot.id_moneda
                          inner join param.vproveedor pro on pro.id_proveedor = cot.id_proveedor
                          inner join wf.testado_wf ew on ew.id_estado_wf = cot.id_estado_wf
                          where (cot.estado=''recomendado''  or  cot.estado=''adjudicado'')  and '|| v_add_filtro ||' ';
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

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
        IF  pxp.f_existe_parametro(p_tabla,'id_cotizacion') THEN
             
                  v_filtro = 'cot.id_cotizacion='||v_parametros.id_cotizacion||' and ';
            ELSE
                  v_filtro = 'cot.id_proceso_wf='||v_parametros.id_proceso_wf||' and ';
            
            END IF;
            
		v_consulta:='select  
        			cot.id_cotizacion,
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
                    (cot.fecha_entrega - cot.fecha_adju) as dias_entrega,
                    cot.lugar_entrega,
                    cot.numero_oc,
                    cot.tipo_entrega,
                    cot.id_proceso_compra,
                    sol.tipo,
                    cot.fecha_adju as fecha_oc,
                    mon.moneda,
                    mon.codigo as codigo_moneda,
                    cot.tiempo_entrega,
                    sol.num_tramite,
                    cot.funcionario_contacto,
       				cot.telefono_contacto,
       				cot.correo_contacto,
                    tppc.codigo as codigo_proceso,
                    cot.forma_pago,
                    pc.objeto
              from adq.tcotizacion cot 
              inner join param.vproveedor pv on pv.id_proveedor=cot.id_proveedor
              left join segu.tpersona per on per.id_persona=pv.id_persona
              left join param.tinstitucion ins on ins.id_institucion= pv.id_institucion
              inner join adq.tproceso_compra pc on pc.id_proceso_compra=cot.id_proceso_compra
			  inner join adq.tsolicitud sol on sol.id_solicitud=pc.id_solicitud
			  inner join param.tmoneda mon on mon.id_moneda=cot.id_moneda
              inner join orga.tfuncionario fun on fun.id_funcionario=sol.id_funcionario
		      inner join segu.vpersona persol on persol.id_persona=fun.id_persona
              inner join wf.tproceso_wf pcwf on pcwf.id_proceso_wf=pc.id_proceso_wf
		      inner join wf.ttipo_proceso tppc on tppc.id_tipo_proceso=pcwf.id_tipo_proceso
              where '||v_filtro;
          
          --Definicion de la respuesta
          v_consulta:=v_consulta||v_parametros.filtro;
          v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
		  raise notice '%', v_consulta;	
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