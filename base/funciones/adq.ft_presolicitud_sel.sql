CREATE OR REPLACE FUNCTION adq.ft_presolicitud_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.ft_presolicitud_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'adq.tpresolicitud'
 AUTOR: 		 (admin)
 FECHA:	        10-05-2013 05:03:41
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
ISSUE		FECHA:	         AUTOR:				 DESCRIPCION:	
#1			11/12/2018		 EGS				 Se modifico el sel para que solo muestre registros activos 
#4	endeETR	19/02/2019		 EGS				 se elimino filtro para estados cuando la vista es de consolidacion,  
                                                 se modifico la sentencia de sql del sel 
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_filtro            varchar;
			    
BEGIN

	v_nombre_funcion = 'adq.ft_presolicitud_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_PRES_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		10-05-2013 05:03:41
	***********************************/

	if(p_transaccion='ADQ_PRES_SEL')then
     				
    	begin
        
          
        
           IF  v_parametros.tipo_interfaz = 'PresolicitudVb'   THEN
               IF p_administrador = 1 THEN
              	
                  v_filtro = '0=0';
             
               ELSE
             
                  v_filtro = ' id_funcionario_supervisor = ' ||v_parametros.id_funcionario_usu::varchar;
             
               END IF;
           
               v_filtro = v_filtro ||' and (pres.estado = ''pendiente'' or pres.estado =''aprobado'')';
           
           ELSEIF  v_parametros.tipo_interfaz = 'PresolicitudCon'   THEN
           
           
              IF p_administrador = 1 THEN
              	
                  v_filtro = '0=0';
             
               ELSE
             
                  v_filtro =  ' '|| p_id_usuario::varchar||'  in (select gu.id_usuario 
                                              from adq.tgrupo_usuario  gu 
                                              where gu.id_grupo = gru.id_grupo) ' ;
             
               END IF;
           
           
           
           ELSE
           
              IF p_administrador = 1 THEN
              	
                  v_filtro = '0=0';
             
             ELSE
             
                  v_filtro = ' pres.id_usuario_reg = ' ||p_id_usuario::varchar;
             
             END IF;
        
           END IF;
           
                
    		--Sentencia de la consulta
			v_consulta:='
                   with asignado (
                                        id_presolicitud,
                                        cantidad_asignado
                                        )as(
                                            Select
                                                presold.id_presolicitud,
                                                count(presold.id_solicitud_det)
                                            from  adq.tpresolicitud_det presold
                                            group by id_presolicitud
                                                ),
                 nro_item(
                                id_presolicitud,
                                nro_item
                                )as(
                                    Select
                                        presold.id_presolicitud,
                                        count(presold.id_presolicitud_det)
                                    from  adq.tpresolicitud_det presold
                                    group by id_presolicitud
                                        )
            select pres.id_presolicitud,
                                 pres.id_grupo,
                                 pres.id_funcionario_supervisor,
                                 pres.id_funcionario,
                                 pres.estado_reg,
                                 pres.obs,
                                 pres.id_uo,
                                 pres.estado,
                                 pres.id_solicitudes,
                                 pres.fecha_reg,
                                 pres.id_usuario_reg,
                                 pres.fecha_mod,
                                 pres.id_usuario_mod,
                                 usu1.cuenta as usr_reg,
                                 usu2.cuenta as usr_mod,
                                 gru.nombre as desc_grupo,
                                 fun.desc_funcionario1 as desc_funcionario,
                                 funs.desc_funcionario1 as desc_funcionario_supervisor,
                                 ''(''||uo.codigo ||'') ''||uo.descripcion as desc_uo,
                                 pres.fecha_soli,
                                 ( select  pxp.list(gp.id_partida::varchar) 
                                 from adq.tgrupo_partida gp 
                                 inner join param.tperiodo per on per.id_gestion = gp.id_gestion
                                 and per.fecha_ini <= pres.fecha_soli and per.fecha_fin >= pres.fecha_soli
                                 where gp.id_grupo = gru.id_grupo  and gp.estado_reg=''activo'')::varchar  as id_partidas,
                                 pres.id_depto,
                                 d.codigo||'' ''||d.nombre as desc_depto,
                                 pres.id_gestion,                --#4 EGS
                                 (asig.cantidad_asignado||'' de ''||nro.nro_item)::varchar  as asignado,     --#4 EGS
                                  pres.id_proceso_wf,    --#4 EGS
                                  pres.id_estado_wf,     --#4 EGS
                                  pres.nro_tramite      --#4 EGS
                          from adq.tpresolicitud pres
                               inner join segu.tusuario usu1 on usu1.id_usuario = pres.id_usuario_reg
                               inner join adq.tgrupo gru on gru.id_grupo = pres.id_grupo
                               inner join orga.vfuncionario fun on fun.id_funcionario = pres.id_funcionario
                               inner join orga.vfuncionario funs on funs.id_funcionario = pres.id_funcionario_supervisor
                               inner join orga.tuo uo on uo.id_uo = pres.id_uo 
                               inner join param.tdepto d on d.id_depto= pres.id_depto
                               left join segu.tusuario usu2 on usu2.id_usuario = pres.id_usuario_mod
                               left join asignado asig on asig.id_presolicitud = pres.id_presolicitud
                               left join nro_item nro   on nro.id_presolicitud = pres.id_presolicitud
				        where pres.estado_reg = ''activo'' and '||v_filtro||' and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            raise notice '%',v_consulta;
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_PRES_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		10-05-2013 05:03:41
	***********************************/

	elsif(p_transaccion='ADQ_PRES_CONT')then

		begin
        
           IF  v_parametros.tipo_interfaz = 'PresolicitudVb'   THEN
               IF p_administrador = 1 THEN
              	
                  v_filtro = '0=0';
             
               ELSE
             
                  v_filtro = ' id_funcionario_supervisor = ' ||v_parametros.id_funcionario_usu::varchar;
             
               END IF;
           
               v_filtro = v_filtro ||' and (pres.estado = ''pendiente'' or pres.estado =''aprobado'')';
           
           ELSEIF  v_parametros.tipo_interfaz = 'PresolicitudCon'   THEN
           
           
              IF p_administrador = 1 THEN
              	
                  v_filtro = '0=0';
             
               ELSE
             
                  v_filtro =  ' '|| p_id_usuario::varchar||'  in (select gu.id_usuario 
                                              from adq.tgrupo_usuario  gu 
                                              where gu.id_grupo = gru.id_grupo) ' ;
             
               END IF;
                     
           
           ELSE
           
              IF p_administrador = 1 THEN
              	
                  v_filtro = '0=0';
             
             ELSE
             
                  v_filtro = ' pres.id_usuario_reg = ' ||p_id_usuario::varchar;
             
             END IF;
        
           END IF;
        
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_presolicitud)
					     from adq.tpresolicitud pres
                               inner join segu.tusuario usu1 on usu1.id_usuario = pres.id_usuario_reg
                               inner join adq.tgrupo gru on gru.id_grupo = pres.id_grupo
                               inner join orga.vfuncionario fun on fun.id_funcionario = pres.id_funcionario
                               inner join orga.vfuncionario funs on funs.id_funcionario = pres.id_funcionario_supervisor
                               inner join orga.tuo uo on uo.id_uo = pres.id_uo 
                               left join segu.tusuario usu2 on usu2.id_usuario = pres.id_usuario_mod
                               inner join param.tdepto d on d.id_depto= pres.id_depto
					    where '||v_filtro||' and ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
        
    /*********************************    
 	#TRANSACCION:  'ADQ_PRESREP_SEL'
 	#DESCRIPCION:	Consulta de datos con id_presolicitud 
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		21-05-2013
	***********************************/
	
    elsif(p_transaccion='ADQ_PRESREP_SEL')then
    	begin
    		--Sentencia de la consulta de conteo de registros
			v_consulta:='select pres.id_presolicitud,
                                 pres.id_grupo,
                                 pres.id_funcionario_supervisor,
                                 pres.id_funcionario,
                                 pres.estado_reg,
                                 pres.obs,
                                 pres.id_uo,
                                 pres.estado,
                                 pres.id_solicitudes,
                                 pres.fecha_reg,
                                 pres.id_usuario_reg,
                                 pres.fecha_mod,
                                 pres.id_usuario_mod,
                                 usu1.cuenta as usr_reg,
                                 usu2.cuenta as usr_mod,
                                 gru.nombre as desc_grupo,
                                 fun.desc_funcionario1 as desc_funcionario,
                                 funs.desc_funcionario1 as desc_funcionario_supervisor,
                                 ''(''||uo.codigo ||'') ''||uo.descripcion as desc_uo,
                                 pres.fecha_soli,
                                 ( select  pxp.list(gp.id_partida::varchar) 
                                 from adq.tgrupo_partida gp 
                                 inner join param.tperiodo per on per.id_gestion = gp.id_gestion
                                 and per.fecha_ini <= pres.fecha_soli and per.fecha_fin >= pres.fecha_soli
                                 where gp.id_grupo = gru.id_grupo  and gp.estado_reg=''activo'')::varchar  as id_partidas
                          from adq.tpresolicitud pres
                               inner join segu.tusuario usu1 on usu1.id_usuario = pres.id_usuario_reg
                               inner join adq.tgrupo gru on gru.id_grupo = pres.id_grupo
                               inner join orga.vfuncionario fun on fun.id_funcionario = pres.id_funcionario
                               inner join orga.vfuncionario funs on funs.id_funcionario = pres.id_funcionario_supervisor
                               inner join orga.tuo uo on uo.id_uo = pres.id_uo 
                               left join segu.tusuario usu2 on usu2.id_usuario = pres.id_usuario_mod
				        where pres.id_presolicitud='||v_parametros.id_presolicitud||' and ';
			
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
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;