--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_proceso_compra_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.f_proceso_compra_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'adq.tproceso_compra'
 AUTOR: 		 (admin)
 FECHA:	        19-03-2013 12:55:30
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
    
    v_filadd 			varchar;
    
    va_id_depto integer[];
			    
BEGIN

	v_nombre_funcion = 'adq.f_proceso_compra_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_PROC_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		19-03-2013 12:55:30
	***********************************/

	if(p_transaccion='ADQ_PROC_SEL')then
     				
    	begin
        
        v_filadd='';
        
           IF   p_administrador != 1 THEN
           
             select  
                 pxp.aggarray(depu.id_depto)
              into 
                 va_id_depto
             from param.tdepto_usuario depu 
             where depu.id_usuario =  p_id_usuario; 
        
           v_filadd='(dep.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||')) and';
          
          END IF;
        
        
    		--Sentencia de la consulta
			v_consulta:='select proc.id_proceso_compra,
                         proc.id_depto,
                         proc.num_convocatoria,
                         proc.id_solicitud,
                         proc.id_estado_wf,
                         proc.fecha_ini_proc,
                         proc.obs_proceso,
                         proc.id_proceso_wf,
                         proc.num_tramite,
                         proc.codigo_proceso,
                         proc.estado_reg,
                         proc.estado,
                         proc.num_cotizacion,
                         proc.id_usuario_reg,
                         proc.fecha_reg,
                         proc.fecha_mod,
                         proc.id_usuario_mod,
                         usu1.cuenta as usr_reg,
                         usu2.cuenta as usr_mod,
                         dep.codigo as desc_depto,
                         fun.desc_funcionario1 as desc_funcionario,
                         sol.numero as desc_solicitud,
                         mon.codigo as desc_moneda
                   from adq.tproceso_compra proc
                       inner join segu.tusuario usu1 on usu1.id_usuario = proc.id_usuario_reg
                       inner join param.tdepto dep on dep.id_depto = proc.id_depto 
                       inner join adq.tsolicitud sol on sol.id_solicitud = proc.id_solicitud
                       inner join orga.vfuncionario fun on  fun.id_funcionario = sol.id_funcionario
                       inner join param.tmoneda mon on mon.id_moneda = sol.id_moneda
                       left join segu.tusuario usu2 on usu2.id_usuario = proc.id_usuario_mod
                       where  '||v_filadd||'  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;
        
        
    /*********************************    
 	#TRANSACCION:  'ADQ_PROCPED_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		10-04-2013 12:55:30
	***********************************/

	elsif(p_transaccion='ADQ_PROCPED_SEL')then
     				
    	begin
        
        v_filadd='';
        
           IF   p_administrador != 1 THEN
           
             select  
                 pxp.aggarray(depu.id_depto)
              into 
                 va_id_depto
             from param.tdepto_usuario depu 
             where depu.id_usuario =  p_id_usuario; 
        
           v_filadd='(dep.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||')) and';
          
          END IF;
        
        
    		--Sentencia de la consulta
			v_consulta:='select proc.id_proceso_compra,
                         proc.id_depto,
                         proc.num_convocatoria,
                         proc.id_solicitud,
                         proc.id_estado_wf,
                         proc.fecha_ini_proc,
                         proc.obs_proceso,
                         proc.id_proceso_wf,
                         proc.num_tramite,
                         proc.codigo_proceso,
                         proc.estado_reg,
                         proc.estado,
                         proc.num_cotizacion,
                         proc.id_usuario_reg,
                         proc.fecha_reg,
                         proc.fecha_mod,
                         proc.id_usuario_mod,
                         usu1.cuenta as usr_reg,
                         usu2.cuenta as usr_mod,
                         dep.codigo as desc_depto,
                         fun.desc_funcionario1 as desc_funcionario,
                         sol.numero as desc_solicitud,
                         mon.codigo as desc_moneda
                   from adq.tproceso_compra proc
                       inner join segu.tusuario usu1 on usu1.id_usuario = proc.id_usuario_reg
                       inner join param.tdepto dep on dep.id_depto = proc.id_depto 
                       inner join adq.tsolicitud sol on sol.id_solicitud = proc.id_solicitud
                       inner join orga.vfuncionario fun on  fun.id_funcionario = sol.id_funcionario
                       inner join param.tmoneda mon on mon.id_moneda = sol.id_moneda
                       left join segu.tusuario usu2 on usu2.id_usuario = proc.id_usuario_mod
                       where proc.id_proceso_compra='||v_parametros.id_proceso_compra||' and '||v_filadd||'  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_PROC_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		19-03-2013 12:55:30
	***********************************/

	elsif(p_transaccion='ADQ_PROC_CONT')then

		begin
           v_filadd='';
        
           IF   p_administrador != 1 THEN
          
           select  
                 pxp.aggarray(depu.id_depto)
              into 
                 va_id_depto
             from param.tdepto_usuario depu 
             where depu.id_usuario =  p_id_usuario; 
        
           v_filadd='(dep.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||')) and';
          
          END IF;
        
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(proc.id_proceso_compra)
					    
                        from adq.tproceso_compra proc
                       inner join segu.tusuario usu1 on usu1.id_usuario = proc.id_usuario_reg
                       inner join param.tdepto dep on dep.id_depto = proc.id_depto 
                       inner join adq.tsolicitud sol on sol.id_solicitud = proc.id_solicitud
                       inner join orga.vfuncionario fun on  fun.id_funcionario = sol.id_funcionario
                       inner join param.tmoneda mon on mon.id_moneda = sol.id_moneda
                       left join segu.tusuario usu2 on usu2.id_usuario = proc.id_usuario_mod
                       where  '||v_filadd||'  ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

            raise notice '%',v_consulta;
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