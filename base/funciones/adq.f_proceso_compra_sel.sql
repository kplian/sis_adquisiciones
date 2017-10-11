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
    v_filtro			varchar;

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
               where depu.id_usuario =  p_id_usuario and depu.cargo = 'responsable';


               v_filadd='( (id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||'))   or   id_usuario_auxiliar = '||p_id_usuario::varchar ||' ) and ';

          END IF;


    		--Sentencia de la consulta
			v_consulta:='select
                              id_proceso_compra,
                              id_depto,
                              num_convocatoria,
                              id_solicitud,
                              id_estado_wf,
                              fecha_ini_proc,
                              obs_proceso,
                              id_proceso_wf,
                              num_tramite,
                              codigo_proceso,
                              estado_reg,
                              estado,
                              num_cotizacion,
                              id_usuario_reg,
                              fecha_reg,
                              fecha_mod,
                              id_usuario_mod,
                              usr_reg,
                              usr_mod,
                              desc_depto,
                              desc_funcionario,
                              desc_solicitud,
                              desc_moneda,
                              instruc_rpc,
                              id_categoria_compra,
                              usr_aux,
                              id_moneda,
                              id_funcionario,
                              id_usuario_auxiliar,
                              objeto,
                              estados_cotizacion,
                              numeros_oc,
                              proveedores_cot
                   from adq.vproceso_compra
                   where  '||v_filadd||'  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --raise exception 'sss';
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

           --TODO, RAC, me parece que el codigo comentado no es util,.... que fue solo una copia del proceso consulta para grilla
           --si se habilitar evita que otros usuarios que no sean del depto de adquisiciones vean
           --el reporte de cuadro comparativo...

           /*IF   p_administrador != 1 THEN

               -- recupera los usuarios miembros del depto
               select
                   pxp.aggarray(depu.id_depto)
                into
                   va_id_depto
               from param.tdepto_usuario depu
               where depu.id_usuario =  p_id_usuario;


              if va_id_depto is null then

                 raise exception 'El usuario no se encuetra asignado a nigun depto de adquisiciones';

              end if;



            --recupera el cargo del usuario



          	 v_filadd='(dep.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||')) and';

          END IF;*/


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
 	#TRANSACCION:  'ADQ_PROCSOL_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		31-05-2013 12:55:30
	***********************************/

	elsif(p_transaccion='ADQ_PROCSOL_SEL')then

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
			v_consulta:='select proc.id_proceso_compra
                   from adq.tproceso_compra proc
                       inner join adq.tsolicitud sol on sol.id_solicitud = proc.id_solicitud
                       where sol.id_solicitud='||v_parametros.id_solicitud||' and '||v_filadd||'  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

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


             --seleciona los departamentos donde el usuario es responsable
              select
                 pxp.aggarray(depu.id_depto)
              into
                 va_id_depto
             from param.tdepto_usuario depu
             where depu.id_usuario =  p_id_usuario and depu.cargo = 'responsable';

             v_filadd='( (id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||'))   or   id_usuario_auxiliar = '||p_id_usuario::varchar ||' ) and ';


          END IF;

			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_proceso_compra)

                        from adq.vproceso_compra
                        where  '||v_filadd||'  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

            raise notice '%',v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;
    /*********************************
 	#TRANSACCION:  'ADQ_PROCESTIE_SEL'
 	#DESCRIPCION:	Obtener detalle y resumen de tiempos por proceso de compra atendido
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		10-04-2013 12:55:30
	***********************************/

	elsif(p_transaccion='ADQ_PROCESTIE_SEL')then

    	begin

        	v_consulta =
            'with observaciones as (
				select o.id_estado_wf , round((EXTRACT(EPOCH FROM (coalesce(o.fecha_fin,now()) - o.fecha_reg))/3600)::numeric,0) as tiempo_observacion
    			from wf.tobs o
    			where o.estado_reg = ''activo''
    			group by o.id_estado_wf,o.fecha_fin,o.fecha_reg
			),

            borrador as (
				select
				distinct on (sol.num_tramite) sol.num_tramite,
				sol.justificacion,
				prov.desc_proveedor,
				usu.desc_persona as usuario_asignado,
                pc.fecha_ini_proc as fecha_inicio_proceso,
                co.id_cotizacion,
                esso.id_estado_wf,
                round ((EXTRACT(EPOCH FROM (essosi.fecha_reg - esso.fecha_reg))/3600)::numeric,0) as tiempo_asignacion,
                coalesce(obssol.tiempo_observacion,0) as tiempo_observacion_asignacion,
                tes.codigo as estado_cotizacion,
                round ((case when essi.id_estado_wf is null then
                    EXTRACT(EPOCH FROM (now() - es.fecha_reg))/3600
                else
                    EXTRACT(EPOCH FROM (essi.fecha_reg - es.fecha_reg))/3600
                end)::numeric,0) as tiempo_estado_cotizacion,
                coalesce(obsco.tiempo_observacion,0) as tiempo_observacion_estado,
                (case when cot.precio_total_mb >= 20000 then
                    ''si''
                else
                    ''no''
                end) as mayor_20


                from adq.tproceso_compra pc
                inner join adq.tsolicitud sol on pc.id_solicitud = sol.id_solicitud
                inner join wf.testado_wf esso on esso.id_proceso_wf = sol.id_proceso_wf
                inner join wf.ttipo_estado tesso on tesso.id_tipo_estado = esso.id_tipo_estado and
                    tesso.codigo in (''aprobado'')
                left join observaciones obssol on obssol.id_estado_wf = esso.id_estado_wf
                inner join wf.testado_wf essosi on essosi.id_estado_anterior = esso.id_estado_wf
                inner join wf.ttipo_estado tessosi on tessosi.id_tipo_estado = essosi.id_tipo_estado and
                    tessosi.codigo in (''proceso'')
                inner join param.vproveedor prov on prov.id_proveedor = sol.id_proveedor
                inner join adq.tcotizacion co on pc.id_proceso_compra = co.id_proceso_compra
                inner join adq.vcotizacion cot on cot.id_cotizacion = co.id_cotizacion
                inner join wf.testado_wf es on es.id_proceso_wf = co.id_proceso_wf
                left join observaciones obsco on obsco.id_estado_wf = es.id_estado_wf
                left join wf.testado_wf essi on essi.id_estado_anterior = es.id_estado_wf
                inner join wf.ttipo_estado tes on tes.id_tipo_estado = es.id_tipo_estado and
                    tes.codigo in (''borrador'')
                inner join segu.vusuario usu on usu.id_usuario = pc.id_usuario_auxiliar
                where pc.fecha_ini_proc::date >= ''' || v_parametros.fecha_ini || '''::date and
                	pc.fecha_ini_proc::date <= ''' || v_parametros.fecha_fin || '''::date and
                	pc.id_depto = ' || v_parametros.id_depto ||' and co.estado!= ''anulado''
                order by sol.num_tramite,esso.fecha_reg DESC
			),

			cotizado as (
                select
                distinct on (co.id_cotizacion) co.id_cotizacion,
                round ((case when essi.id_estado_wf is null then
                    EXTRACT(EPOCH FROM (now() - es.fecha_reg))/3600
                else
                    EXTRACT(EPOCH FROM (essi.fecha_reg - es.fecha_reg))/3600
                end)::numeric,0) as tiempo_estado_cotizacion,
                coalesce(obsco.tiempo_observacion,0) as tiempo_observacion_estado

                from adq.tproceso_compra pc
                inner join adq.tcotizacion co on pc.id_proceso_compra = co.id_proceso_compra
                inner join wf.testado_wf es on es.id_proceso_wf = co.id_proceso_wf
                left join observaciones obsco on obsco.id_estado_wf = es.id_estado_wf
                left join wf.testado_wf essi on essi.id_estado_anterior = es.id_estado_wf
                inner join wf.ttipo_estado tes on tes.id_tipo_estado = es.id_tipo_estado and
                    tes.codigo in (''cotizado'')
                where pc.fecha_ini_proc::date >= ''' || v_parametros.fecha_ini || '''::date and
                	pc.fecha_ini_proc::date <= ''' || v_parametros.fecha_fin || '''::date and
                	pc.id_depto = ' || v_parametros.id_depto ||' and co.estado!= ''anulado''
                order by co.id_cotizacion,es.fecha_reg DESC),

			recomendado as (

                select

                distinct on (co.id_cotizacion) co.id_cotizacion,
                round ((case when essi.id_estado_wf is null then
                    EXTRACT(EPOCH FROM (now() - es.fecha_reg))/3600
                else
                    EXTRACT(EPOCH FROM (essi.fecha_reg - es.fecha_reg))/3600
                end)::numeric,0) as tiempo_estado_cotizacion,
                coalesce(obsco.tiempo_observacion,0) as tiempo_observacion_estado

                from adq.tproceso_compra pc
                inner join adq.tcotizacion co on pc.id_proceso_compra = co.id_proceso_compra
                inner join wf.testado_wf es on es.id_proceso_wf = co.id_proceso_wf
                left join observaciones obsco on obsco.id_estado_wf = es.id_estado_wf
                left join wf.testado_wf essi on essi.id_estado_anterior = es.id_estado_wf
                inner join wf.ttipo_estado tes on tes.id_tipo_estado = es.id_tipo_estado and
                    tes.codigo in (''recomendado'')
                where pc.fecha_ini_proc::date >= ''' || v_parametros.fecha_ini || '''::date and
                	pc.fecha_ini_proc::date <= ''' || v_parametros.fecha_fin || '''::date and
                	pc.id_depto = ' || v_parametros.id_depto ||' and co.estado!= ''anulado''
                order by co.id_cotizacion,es.fecha_reg DESC),

			adjudicado as (

                select

                distinct on (co.id_cotizacion) co.id_cotizacion,
                round ((case when essi.id_estado_wf is null then
                    EXTRACT(EPOCH FROM (now() - es.fecha_reg))/3600
                else
                    EXTRACT(EPOCH FROM (essi.fecha_reg - es.fecha_reg))/3600
                end)::numeric,0) as tiempo_estado_cotizacion,
                coalesce(obsco.tiempo_observacion,0) as tiempo_observacion_estado

                from adq.tproceso_compra pc
                inner join adq.tcotizacion co on pc.id_proceso_compra = co.id_proceso_compra
                inner join wf.testado_wf es on es.id_proceso_wf = co.id_proceso_wf
                left join observaciones obsco on obsco.id_estado_wf = es.id_estado_wf
                left join wf.testado_wf essi on essi.id_estado_anterior = es.id_estado_wf
                inner join wf.ttipo_estado tes on tes.id_tipo_estado = es.id_tipo_estado and
                    tes.codigo in (''adjudicado'')
                where pc.fecha_ini_proc::date >= ''' || v_parametros.fecha_ini || '''::date and
                	pc.fecha_ini_proc::date <= ''' || v_parametros.fecha_fin || '''::date and
                	pc.id_depto = ' || v_parametros.id_depto ||' and co.estado!= ''anulado''
                order by co.id_cotizacion,es.fecha_reg DESC),

			contrato_pendiente as (

                select

                distinct on (co.id_cotizacion) co.id_cotizacion,
                round ((case when essi.id_estado_wf is null then
                    EXTRACT(EPOCH FROM (now() - es.fecha_reg))/3600
                else
                    EXTRACT(EPOCH FROM (essi.fecha_reg - es.fecha_reg))/3600
                end)::numeric,0) as tiempo_estado_cotizacion,
                coalesce(obsco.tiempo_observacion,0) as tiempo_observacion_estado

                from adq.tproceso_compra pc
                inner join adq.tcotizacion co on pc.id_proceso_compra = co.id_proceso_compra
                inner join wf.testado_wf es on es.id_proceso_wf = co.id_proceso_wf
                left join observaciones obsco on obsco.id_estado_wf = es.id_estado_wf
                left join wf.testado_wf essi on essi.id_estado_anterior = es.id_estado_wf
                inner join wf.ttipo_estado tes on tes.id_tipo_estado = es.id_tipo_estado and
                    tes.codigo in (''contrato_pendiente'')
                where pc.fecha_ini_proc::date >= ''' || v_parametros.fecha_ini || '''::date and
                	pc.fecha_ini_proc::date <= ''' || v_parametros.fecha_fin || '''::date and
                	pc.id_depto = ' || v_parametros.id_depto ||' and co.estado!= ''anulado''
                order by co.id_cotizacion,es.fecha_reg DESC),

			contrato_elaborado as (

                select

                distinct on (co.id_cotizacion) co.id_cotizacion,
                round ((case when essi.id_estado_wf is null then
                    EXTRACT(EPOCH FROM (now() - es.fecha_reg))/3600
                else
                    EXTRACT(EPOCH FROM (essi.fecha_reg - es.fecha_reg))/3600
                end)::numeric,0) as tiempo_estado_cotizacion,
                coalesce(obsco.tiempo_observacion,0) as tiempo_observacion_estado

                from adq.tproceso_compra pc
                inner join adq.tcotizacion co on pc.id_proceso_compra = co.id_proceso_compra
                inner join wf.testado_wf es on es.id_proceso_wf = co.id_proceso_wf
                left join observaciones obsco on obsco.id_estado_wf = es.id_estado_wf
                left join wf.testado_wf essi on essi.id_estado_anterior = es.id_estado_wf
                inner join wf.ttipo_estado tes on tes.id_tipo_estado = es.id_tipo_estado and
                    tes.codigo in (''contrato_elaborado'')
                where pc.fecha_ini_proc::date >= ''' || v_parametros.fecha_ini || '''::date and
                	pc.fecha_ini_proc::date <= ''' || v_parametros.fecha_fin || '''::date and
                	pc.id_depto = ' || v_parametros.id_depto ||' and co.estado!= ''anulado''
                order by co.id_cotizacion,es.fecha_reg DESC)';

		if (v_parametros.tipo = 'resumen') then
        	v_consulta = v_consulta || ', detalle as (';
        end if;

        v_consulta = v_consulta || '
            select
            b.num_tramite::varchar,
            b.justificacion::varchar,
            b.desc_proveedor::varchar,
            b.usuario_asignado::varchar,
            b.fecha_inicio_proceso::date,
            b.mayor_20::varchar,
            coalesce (b.tiempo_asignacion,0) - coalesce (b.tiempo_observacion_asignacion,0)::integer as tiempo_asignacion,

            (coalesce(b.tiempo_estado_cotizacion,0)+
            coalesce(c.tiempo_estado_cotizacion,0)+
            coalesce(r.tiempo_estado_cotizacion,0)+
            coalesce(a.tiempo_estado_cotizacion,0)+
            coalesce(ce.tiempo_estado_cotizacion,0))
            -
            (coalesce(b.tiempo_observacion_estado,0)+
            coalesce(c.tiempo_observacion_estado,0)+
            coalesce(r.tiempo_observacion_estado,0)+
            coalesce(a.tiempo_observacion_estado,0)+
            coalesce(ce.tiempo_observacion_estado,0))::integer as tiempo_total_atencion,
            cp.tiempo_estado_cotizacion::integer as tiempo_total_legal

            from borrador b
            left join cotizado c on c.id_cotizacion = b.id_cotizacion
            left join recomendado r  on r.id_cotizacion = b.id_cotizacion
            left join adjudicado a  on a.id_cotizacion = b.id_cotizacion
            left join contrato_pendiente cp  on cp.id_cotizacion = b.id_cotizacion
            left join contrato_elaborado ce  on ce.id_cotizacion = b.id_cotizacion

            order by b.usuario_asignado,b.fecha_inicio_proceso,b.num_tramite';
       if (v_parametros.tipo = 'resumen') then
        	v_consulta = v_consulta || ')
                select usuario_asignado::varchar,mayor_20::varchar,
                count(*)::integer as cantidad_atendidos,
                round(avg(tiempo_asignacion),2)::numeric as promedio_asignacion,
                round(avg(tiempo_total_atencion),2)::numeric as promedio_atencion,
                round(avg(tiempo_total_legal),2)::numeric as promedio_legal_sin_0
                from detalle
                group by usuario_asignado, mayor_20
                order by usuario_asignado, mayor_20';
       end if;

		return v_consulta;

	end;
	/*********************************
 	#TRANSACCION:  'ADQ_PROINIADEJE_SEL'
 	#DESCRIPCION:	Obtener procesos iniciados, adjudicados y ejecutados
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		24-11-2016
	***********************************/

	elsif(p_transaccion='ADQ_PROINIADEJE_SEL')then

    	begin
        	IF v_parametros.tipo='iniciados' THEN
	        	v_filtro = ' and (pro.estados_cotizacion not like ''%adjudicado%'' and pro.estados_cotizacion not like ''%contrato_pendiente%''
            				and pro.estados_cotizacion not like ''%contrato_elaborado%'' and pro.estados_cotizacion not like ''%pago_habilitado%''
            				and pro.estados_cotizacion not like ''%finalizada%'' or pro.estados_cotizacion is null)';
            ELSIF v_parametros.tipo='adjudicados' THEN
            	v_filtro = ' and (pro.estados_cotizacion like ''%adjudicado%'' or pro.estados_cotizacion like ''%contrato_pendiente%''
                			or pro.estados_cotizacion like ''%contrato_elaborado%'')';
            ELSIF v_parametros.tipo='ejecutados' THEN
            	v_filtro = ' and (pro.estados_cotizacion like ''%pago_habilitado%'' or pro.estados_cotizacion like ''%finalizada%'')';
            END IF;

        	v_consulta = 'select sol.num_tramite, sol.justificacion, sol.desc_funcionario1 as solicitante,
       		  usu.desc_persona as tecnico_adquisiciones, sol.desc_proveedor as proveedor_recomendado,
            pro.proveedores_cot as proveedor_adjudicado,  pro.fecha_ini_proc, sol.precio_total_mb as precio_bs,
            sol.precio_total as precio_moneda_solicitada, sol.codigo as moneda_solicitada,
            case when pro.requiere_contrato = ''si'' then ''Contrato''
                 else case when sol.tipo=''bien'' then ''Orden de Bien''
                      when sol.tipo=''servicio'' then ''Orden de Servicio''
                      end
                 end as contrato_orden
            from adq.vsolicitud_compra sol
            left join adq.vproceso_compra pro on pro.id_solicitud=sol.id_solicitud and pro.estados_cotizacion!=''anulado''
            inner join segu.vusuario usu on usu.cuenta=pro.usr_aux
            where pro.fecha_ini_proc BETWEEN '''||v_parametros.fecha_ini||''' and '''||v_parametros.fecha_fin ||'''
            and sol.precio_total_mb > ' || v_parametros.monto_mayor ||'
            and pro.estado != ''anulado'' and pro.id_depto='||v_parametros.id_depto||v_filtro||'
            order by pro.fecha_ini_proc, pro.num_tramite';

        	return v_consulta;
        end;

    /*********************************
 	#TRANSACCION:  'ADQ_INADEJRES_SEL'
 	#DESCRIPCION:	Obtener resumen de procesos iniciados, adjudicados y ejecutados
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		28-11-2016
	***********************************/

	elsif(p_transaccion='ADQ_INADEJRES_SEL')then

    	begin

            v_consulta = 'select ''Iniciados'' as estado, cc.nombre, count(pro.id_proceso_compra) as total
						  from adq.vsolicitud_compra sol
			left join adq.vproceso_compra pro on pro.id_solicitud=sol.id_solicitud and pro.estados_cotizacion!=''anulado''
			inner join adq.tcategoria_compra cc on cc.id_categoria_compra=pro.id_categoria_compra
			where pro.fecha_ini_proc BETWEEN '''||v_parametros.fecha_ini||''' and '''||v_parametros.fecha_fin||'''
			and sol.precio_total_mb > ' || v_parametros.monto_mayor || '
			and pro.estado != ''anulado'' and pro.id_depto=' ||v_parametros.id_depto||'
			and (pro.estados_cotizacion not like ''%adjudicado%'' and pro.estados_cotizacion not like ''%contrato_pendiente%''
			and pro.estados_cotizacion not like ''%contrato_elaborado%'' and pro.estados_cotizacion not like ''%pago_habilitado%''
			and pro.estados_cotizacion not like ''%finalizada%'' or pro.estados_cotizacion is null)
			group by cc.nombre UNION ALL
			select ''Adjudicados'' as estado, cc.nombre, count(pro.id_proceso_compra) as total
			from adq.vsolicitud_compra sol
			left join adq.vproceso_compra pro on pro.id_solicitud=sol.id_solicitud and pro.estados_cotizacion!=''anulado''
			inner join adq.tcategoria_compra cc on cc.id_categoria_compra=pro.id_categoria_compra
			where pro.fecha_ini_proc BETWEEN '''||v_parametros.fecha_ini||''' and '''||v_parametros.fecha_fin||'''
			and sol.precio_total_mb > '||v_parametros.monto_mayor||'
            and pro.estado != ''anulado'' and pro.id_depto='||v_parametros.id_depto||'
			and (pro.estados_cotizacion like ''%adjudicado%'' or pro.estados_cotizacion like ''%contrato_pendiente%''
			or pro.estados_cotizacion like ''%contrato_elaborado%'')
			group by cc.nombre UNION ALL
			select ''Ejecutados'' as estado, cc.nombre, count(pro.id_proceso_compra) as total
			from adq.vsolicitud_compra sol
			left join adq.vproceso_compra pro on pro.id_solicitud=sol.id_solicitud and pro.estados_cotizacion!=''anulado''
			inner join adq.tcategoria_compra cc on cc.id_categoria_compra=pro.id_categoria_compra
			where pro.fecha_ini_proc BETWEEN '''||v_parametros.fecha_ini||''' and '''||v_parametros.fecha_fin||'''
			and sol.precio_total_mb > '||v_parametros.monto_mayor||'
			and pro.estado != ''anulado'' and pro.id_depto=' ||v_parametros.id_depto||'
			and (pro.estados_cotizacion like ''%pago_habilitado%'' or pro.estados_cotizacion like ''%finalizada%'')
			group by cc.nombre';

        	return v_consulta;
        end;
  ELSIF (p_transaccion='ADQ_RMEMODCR_SEL')THEN
    	BEGIN


        	--Sentencia de la consulta
			   v_consulta:='SELECT
            vf.desc_funcionario1 as funcionario,
            p.desc_proveedor as proveedor,
            param.f_obtener_correlativo(
                          ''MEM'',
                           ts.id_gestion,
                           NULL,
                           tpc.id_depto,
                           tc.id_usuario_reg,
                           ''ADQ'',
                           NULL) as tramite
            FROM adq.tcotizacion tc
            LEFT JOIN adq.tproceso_compra tpc ON tpc.id_proceso_compra = tc.id_proceso_compra
            LEFT JOIN adq.tsolicitud ts ON ts.id_solicitud = tpc.id_solicitud
            LEFT JOIN orga.vfuncionario vf ON vf.id_funcionario = ts.id_funcionario_rpc
            LEFT JOIN param.vproveedor p ON p.id_proveedor = tc.id_proveedor
            WHERE  tc.id_proceso_wf = '||v_parametros.id_proceso_wf;


			  --Devuelve la respuesta
			   return v_consulta;
      END;

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