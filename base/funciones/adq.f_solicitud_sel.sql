--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_solicitud_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.f_solicitud_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'adq.tsolicitud'
 AUTOR: 		 (admin)
 FECHA:	        19-02-2013 12:12:51
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
    v_filtro varchar;
    v_id_estados		record;
    v_resultado 		record;
	v_cotizaciones		record;
    v_obligaciones		record;
			    
BEGIN

	v_nombre_funcion = 'adq.f_solicitud_sel';
    v_parametros = pxp.f_get_record(p_tabla);
    
  

	/*********************************    
 	#TRANSACCION:  'ADQ_SOL_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Rensi Arteaga Copari	
 	#FECHA:		19-02-2013 12:12:51
	***********************************/

	if(p_transaccion='ADQ_SOL_SEL')then
     				
    	begin
          --si es administrador
            
            v_filtro='';
            if (v_parametros.id_funcionario_usu is null) then
              	v_parametros.id_funcionario_usu = -1;
            end if;
            IF p_administrador !=1  and lower(v_parametros.tipo_interfaz) = 'solicitudrq' THEN
                                        
              v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||'  or sol.id_usuario_reg='||p_id_usuario||' ) and ';
            
               
            END IF;
            
            IF  lower(v_parametros.tipo_interfaz) = 'solicitudvb' THEN
            
                       
                IF p_administrador !=1 THEN
                
                              
                      v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (lower(sol.estado)!=''borrador'') and ';
                  
                 ELSE
                    v_filtro = ' (lower(sol.estado)!=''borrador''  and lower(sol.estado)!=''proceso'' and lower(sol.estado)!=''finalizado'') and ';
                  
                END IF;
                
                
            END IF;
           
        
        
        
    		--Sentencia de la consulta
			v_consulta:='select
						sol.id_solicitud,
						sol.estado_reg,
						sol.id_solicitud_ext,
						sol.presu_revertido,
						sol.fecha_apro,
						sol.estado,
						sol.id_funcionario_aprobador,
						sol.id_moneda,
						sol.id_gestion,
						sol.tipo,
						sol.num_tramite,
						sol.justificacion,
						sol.id_depto,
						sol.lugar_entrega,
						sol.extendida,
					
						sol.posibles_proveedores,
						sol.id_proceso_wf,
						sol.comite_calificacion,
						sol.id_categoria_compra,
						sol.id_funcionario,
						sol.id_estado_wf,
						sol.fecha_soli,
						sol.fecha_reg,
						sol.id_usuario_reg,
						sol.fecha_mod,
						sol.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        sol.id_uo,	
						fun.desc_funcionario1 as desc_funcionario,
                        funa.desc_funcionario1 as desc_funcionario_apro,
                        uo.codigo||''-''||uo.nombre_unidad as desc_uo,
                        ges.gestion as desc_gestion,
                        mon.codigo as desc_moneda,
						dep.codigo as desc_depto,
                        pm.nombre as desc_proceso_macro,
                        cat.nombre as desc_categoria_compra,
                        sol.id_proceso_macro,
                        sol.numero,
                        funrpc.desc_funcionario1 as desc_funcionario_rpc,
                        ew.obs
                        	
						from adq.tsolicitud sol
						inner join segu.tusuario usu1 on usu1.id_usuario = sol.id_usuario_reg
                        
                        inner join orga.vfuncionario fun on fun.id_funcionario = sol.id_funcionario
                        inner join orga.tuo uo on uo.id_uo = sol.id_uo
                        inner join param.tmoneda mon on mon.id_moneda = sol.id_moneda
                        inner join param.tgestion ges on ges.id_gestion = sol.id_gestion
                        inner join param.tdepto dep on dep.id_depto = sol.id_depto 
                        inner join wf.tproceso_macro pm on pm.id_proceso_macro = sol.id_proceso_macro
                        inner join adq.tcategoria_compra cat on cat.id_categoria_compra = sol.id_categoria_compra
                        
                        left join orga.vfuncionario funrpc on funrpc.id_funcionario = sol.id_funcionario_rpc
                        inner join orga.vfuncionario funa on funa.id_funcionario = sol.id_funcionario_aprobador
                        
						left join segu.tusuario usu2 on usu2.id_usuario = sol.id_usuario_mod
                        
                        inner join wf.testado_wf ew on ew.id_estado_wf = sol.id_estado_wf
                        
				        where  '||v_filtro;
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

             raise notice '%',v_consulta;
			--Devuelve la respuesta
			return v_consulta;
						
		end;
        
    /*********************************    
 	#TRANSACCION:  'ADQ_SOLREP_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		13-03-2013 12:12:51
	***********************************/

	elsif(p_transaccion='ADQ_SOLREP_SEL')then
    
    begin
    --Sentencia de la consulta
			v_consulta:='select
						sol.id_solicitud,
						sol.estado_reg,
						sol.id_solicitud_ext,
						sol.presu_revertido,
						sol.fecha_apro,
						sol.estado,
						sol.id_funcionario_aprobador,
						sol.id_moneda,
						sol.id_gestion,
						sol.tipo,
						sol.num_tramite,
						sol.justificacion,
						sol.id_depto,
						sol.lugar_entrega,
						sol.extendida,
					
						sol.posibles_proveedores,
						sol.id_proceso_wf,
						sol.comite_calificacion,
						sol.id_categoria_compra,
						sol.id_funcionario,
						sol.id_estado_wf,
						sol.fecha_soli,
						sol.fecha_reg,
						sol.id_usuario_reg,
						sol.fecha_mod,
						sol.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        sol.id_uo,	
						fun.desc_funcionario1 as desc_funcionario,
                        
                        funa.desc_funcionario1 as desc_funcionario_apro,
                        uo.codigo||''-''||uo.nombre_unidad as desc_uo,
                        ges.gestion as desc_gestion,
                        mon.codigo as desc_moneda,
						dep.codigo as desc_depto,
                        pm.nombre as desc_proceso_macro,
                        cat.nombre as desc_categoria_compra,
                        sol.id_proceso_macro,
                        sol.numero,
                        funrpc.desc_funcionario1 as desc_funcionario_rpc
                        	
						from adq.tsolicitud sol
						inner join segu.tusuario usu1 on usu1.id_usuario = sol.id_usuario_reg
                        
                        inner join orga.vfuncionario fun on fun.id_funcionario = sol.id_funcionario
                        inner join orga.tuo uo on uo.id_uo = sol.id_uo
                        inner join param.tmoneda mon on mon.id_moneda = sol.id_moneda
                        inner join param.tgestion ges on ges.id_gestion = sol.id_gestion
                        inner join param.tdepto dep on dep.id_depto = sol.id_depto 
                        inner join wf.tproceso_macro pm on pm.id_proceso_macro = sol.id_proceso_macro
                        inner join adq.tcategoria_compra cat on cat.id_categoria_compra = sol.id_categoria_compra
                        
                        left join orga.vfuncionario funrpc on funrpc.id_funcionario = sol.id_funcionario_rpc
                        inner join orga.vfuncionario funa on funa.id_funcionario = sol.id_funcionario_aprobador
                        
						left join segu.tusuario usu2 on usu2.id_usuario = sol.id_usuario_mod
                        
                        inner join wf.testado_wf ew on ew.id_estado_wf = sol.id_estado_wf
                        
				        where sol.id_solicitud='||v_parametros.id_solicitud||' and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;			
    end;    

	/*********************************    
 	#TRANSACCION:  'ADQ_SOL_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Rensi Arteaga Copari	
 	#FECHA:		19-02-2013 12:12:51
	***********************************/

	elsif(p_transaccion='ADQ_SOL_CONT')then

		begin
            v_filtro='';
            
         
            
           v_filtro='';
            
         	if (v_parametros.id_funcionario_usu is null) then
            	v_parametros.id_funcionario_usu = -1;
            end if;
            
            IF p_administrador !=1  and lower(v_parametros.tipo_interfaz) = 'solicitudrq' THEN
                                        
              v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||'  or sol.id_usuario_reg='||p_id_usuario||' ) and ';
            
               
            END IF;
            
            IF  lower(v_parametros.tipo_interfaz) = 'solicitudvb' THEN
            
                       
                IF p_administrador !=1 THEN
                
                              
                      v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (lower(sol.estado)!=''borrador'') and ';
                  
                 ELSE
                    v_filtro = ' (lower(sol.estado)!=''borrador''  and lower(sol.estado)!=''proceso'' and lower(sol.estado)!=''finalizado'') and ';
                  
                END IF;
                
                
            END IF;
        
        
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_solicitud)
			            from adq.tsolicitud sol
						inner join segu.tusuario usu1 on usu1.id_usuario = sol.id_usuario_reg
                        
                        inner join orga.vfuncionario fun on fun.id_funcionario = sol.id_funcionario
                        inner join orga.tuo uo on uo.id_uo = sol.id_uo
                        inner join param.tmoneda mon on mon.id_moneda = sol.id_moneda
                        inner join param.tgestion ges on ges.id_gestion = sol.id_gestion
                        inner join param.tdepto dep on dep.id_depto = sol.id_depto 
                        inner join wf.tproceso_macro pm on pm.id_proceso_macro = sol.id_proceso_macro
                        inner join adq.tcategoria_compra cat on cat.id_categoria_compra = sol.id_categoria_compra
                        
                        left join orga.vfuncionario funrpc on funrpc.id_funcionario = sol.id_funcionario_rpc
                        inner join orga.vfuncionario funa on funa.id_funcionario = sol.id_funcionario_aprobador
                        
						left join segu.tusuario usu2 on usu2.id_usuario = sol.id_usuario_mod
				        inner join wf.testado_wf ew on ew.id_estado_wf = sol.id_estado_wf
                        
				        where  '||v_filtro;
			
			--Definicion de la respuesta		   
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
        
   	/*********************************    
 	#TRANSACCION:  'ADQ_ESTSOL_SEL'
 	#DESCRIPCION:	Consulta estado de solicitud
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		02-05-2013
	***********************************/

	elsif(p_transaccion='ADQ_ESTSOL_SEL')then
    begin 
		select sol.id_estado_wf as ult_est_sol, pc.id_estado_wf as ult_est_prc, pc.id_proceso_compra as id_proceso_compra into v_id_estados
        from adq.tsolicitud sol
        left join adq.tproceso_compra pc on pc.id_solicitud=sol.id_solicitud
        where sol.id_solicitud=v_parametros.id_solicitud;

        create temp table flujo_sol_proc(
        	funcionario text,
            nombre text,
            nombre_estado varchar,
            fecha_reg date,
            id_tipo_estado int4,
            id_estado_wf int4,
            id_estado_anterior int4
        ) on commit drop;	
        
		--recupera el flujo de control de las solicitudes y del proceso de compra
		INSERT INTO flujo_sol_proc(
        WITH RECURSIVE estados_solicitud_proceso(id_funcionario, id_proceso_wf, id_tipo_estado,id_estado_wf, id_estado_anterior, fecha_reg)AS(
     		SELECT et.id_funcionario, et.id_proceso_wf, et.id_tipo_estado, et.id_estado_wf, et.id_estado_anterior, et.fecha_reg
    		FROM wf.testado_wf et
     		WHERE et.id_estado_wf  in (v_id_estados.ult_est_sol,v_id_estados.ult_est_prc)     
     	UNION ALL        
      		SELECT et.id_funcionario, et.id_proceso_wf, et.id_tipo_estado, et.id_estado_wf, et.id_estado_anterior, et.fecha_reg
        	FROM wf.testado_wf et, estados_solicitud_proceso
      		WHERE et.id_estado_wf=estados_solicitud_proceso.id_estado_anterior         
     	)SELECT perf.nombre_completo1 as funcionario, tp.nombre,te.nombre_estado, es.fecha_reg,es.id_tipo_estado, es.id_estado_wf, COALESCE(es.id_estado_anterior,NULL) as id_estado_anterior
         FROM estados_solicitud_proceso es
         INNER JOIN wf.tproceso_wf pwf on pwf.id_proceso_wf=es.id_proceso_wf
         INNER JOIN wf.ttipo_proceso tp on tp.id_tipo_proceso=pwf.id_tipo_proceso
         INNER JOIN wf.ttipo_estado te on te.id_tipo_estado=es.id_tipo_estado
         INNER JOIN orga.tfuncionario fun on fun.id_funcionario=es.id_funcionario
         INNER JOIN segu.vpersona perf on perf.id_persona=fun.id_persona
         order by id_estado_wf);         
    
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
            where cot.id_proceso_compra=v_id_estados.id_proceso_compra
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
       
    
   		create temporary table flujo_obligaciones(
        	funcionario text,
            nombre text,
            nombre_estado varchar,
            fecha_reg date,
            id_tipo_estado int4,
            id_estado_wf int4,
            id_estado_anterior int4
        ) on commit drop;   
    
    	--recupera el flujo de control de las obligaciones
        
    	FOR v_obligaciones IN( 
            select op.id_estado_wf, prv.desc_proveedor
            from adq.tcotizacion cot
            inner join tes.tobligacion_pago op on op.numero=cot.numero_oc
            inner join param.vproveedor prv on prv.id_proveedor=cot.id_proveedor
            where cot.id_proceso_compra=v_id_estados.id_proceso_compra
        )LOOP
        	   INSERT INTO flujo_obligaciones(
               WITH RECURSIVE estados_obligaciones(id_depto, id_proceso_wf, id_tipo_estado,id_estado_wf, id_estado_anterior, fecha_reg)AS(
                   SELECT et.id_depto, et.id_proceso_wf, et.id_tipo_estado, et.id_estado_wf, et.id_estado_anterior, et.fecha_reg
                   FROM wf.testado_wf et
                   WHERE et.id_estado_wf=v_obligaciones.id_estado_wf
                UNION ALL        
                   SELECT et.id_depto, et.id_proceso_wf, et.id_tipo_estado, et.id_estado_wf, et.id_estado_anterior, et.fecha_reg
                   FROM wf.testado_wf et, estados_obligaciones
                   WHERE et.id_estado_wf=estados_obligaciones.id_estado_anterior         
                )SELECT dep.nombre::text, tp.nombre||'-'||prv.desc_proveedor, te.nombre_estado, eo.fecha_reg, eo.id_tipo_estado, eo.id_estado_wf, COALESCE(eo.id_estado_anterior,NULL) as id_estado_anterior
                 FROM estados_obligaciones eo
                 INNER JOIN wf.ttipo_estado te on te.id_tipo_estado= eo.id_tipo_estado
                 INNER JOIN wf.tproceso_wf pwf on pwf.id_proceso_wf=eo.id_proceso_wf
                 INNER JOIN wf.ttipo_proceso tp on tp.id_tipo_proceso=pwf.id_tipo_proceso         
                 INNER JOIN tes.tobligacion_pago op on op.id_proceso_wf=pwf.id_proceso_wf
                 INNER JOIN param.vproveedor prv on prv.id_proveedor=op.id_proveedor
                 INNER JOIN param.tdepto dep on dep.id_depto=eo.id_depto
                 ORDER BY eo.id_estado_wf ASC
                 );      
        END LOOP;    
    
    	create temporary table respuesta(
	        funcionario	text,
            nombre text,
            nombre_estado varchar,
            fecha_reg date,
            id_tipo_estado int4,
            id_estado_wf int4,
            id_estado_anterior int4
        ) on commit drop; 
        
        INSERT INTO respuesta(
        SELECT * FROM flujo_sol_proc
        UNION ALL
        SELECT * FROM flujo_cotizaciones
        UNION ALL
		SELECT * FROM flujo_obligaciones
        );
        
        --Definicion de la respuesta         	
        v_consulta:='select * from respuesta';

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