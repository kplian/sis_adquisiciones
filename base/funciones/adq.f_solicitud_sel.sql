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


    v_historico        varchar;
    v_inner            varchar;
    v_strg_sol         varchar;
    v_strg_obs         varchar;
    v_exception_detail   varchar;
    v_exception_context    varchar;

BEGIN

	v_nombre_funcion = 'adq.f_solicitud_sel';
    v_parametros = pxp.f_get_record(p_tabla);



	/*********************************
 	#TRANSACCION:  'ADQ_SOL_SEL'
 	#DESCRIPCION:	Consulta de datos
    #DESCRIPCION_TEC:	 TIENE QUE DEVOLVER LAS MISMAS COLUMNAS QUE ADQ_HISSOL_SEL
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

            IF  pxp.f_existe_parametro(p_tabla,'historico') THEN

             v_historico =  v_parametros.historico;

            ELSE

            v_historico = 'no';

            END IF;

            IF p_administrador !=1  and lower(v_parametros.tipo_interfaz) = 'solicitudreq' THEN

              v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||'  or sol.id_usuario_reg='||p_id_usuario||' or sol.id_funcionario = '||v_parametros.id_funcionario_usu::varchar||') and ';


            END IF;

          IF  lower(v_parametros.tipo_interfaz) in ('solicitudvb','solicitudvbwzd','solicitudvbpoa','solicitudvbpresupuestos') THEN

                IF v_historico =  'no' THEN

                    IF p_administrador !=1 THEN
                      v_filtro = ' (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (lower(sol.estado)!=''borrador'') and (lower(sol.estado)!=''proceso'' ) and ';
                    ELSE
                        v_filtro = ' (lower(sol.estado)!=''borrador''  and lower(sol.estado)!=''proceso'' and lower(sol.estado)!=''finalizado'') and ';
                    END IF;
                ELSE
                    IF p_administrador !=1 THEN
                      v_filtro = ' (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (lower(sol.estado)!=''borrador'') ) and ';
                    ELSE
                        v_filtro = ' (lower(sol.estado) != ''borrador'') and ';
                    END IF;
               END IF;


         END IF;

         --la interface de vbpresupuestos mustra todas las solcitudes no importa el funcionario asignado
         IF  lower(v_parametros.tipo_interfaz) = 'solicitudvbpresupuestos' and v_historico =  'no' THEN
             v_filtro = v_filtro||' (lower(sol.estado)=''vbpresupuestos'' ) and ';
         END IF;

         --la interface de vbpresupuestos mustra todas las solcitudes no importa el funcionario asignado
         IF  lower(v_parametros.tipo_interfaz) = 'solicitudvbpoa' and v_historico =  'no'  THEN
             v_filtro = ' (lower(sol.estado)=''vbpoa'' ) and ';
         END IF;



            IF  lower(v_parametros.tipo_interfaz) = 'solicitudvbasistente' THEN


                v_filtro = ' (ew.id_funcionario  IN (select * FROM orga.f_get_funcionarios_x_usuario_asistente(now()::date,'||p_id_usuario||') AS (id_funcionario INTEGER))) and ';
                IF v_historico =  'no' THEN
                	v_filtro = v_filtro || ' lower(sol.estado)=''vbgerencia'' and ';
                END IF;
            END IF;




            IF v_historico =  'si' THEN

               v_inner =  'inner join wf.testado_wf ew on ew.id_proceso_wf = sol.id_proceso_wf';
               v_strg_sol = 'DISTINCT(sol.id_solicitud)';
               v_strg_obs = '''---''::text';

               IF p_administrador = 1 THEN

                  v_filtro = ' (lower(sol.estado)!=''borrador'' ) and ';

               END IF;



            ELSE

               v_inner =  'inner join wf.testado_wf ew on ew.id_estado_wf = sol.id_estado_wf';
               v_strg_sol = 'sol.id_solicitud';
               v_strg_obs = 'ew.obs';

             END IF;




    		--Sentencia de la consulta
			v_consulta:='select
						'||v_strg_sol||',
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
                        '||v_strg_obs||',
                        sol.instruc_rpc,
                        pro.desc_proveedor,
                        sol.id_proveedor,
                        sol.id_funcionario_supervisor,
                        funs.desc_funcionario1 as desc_funcionario_supervisor,
                        sol.ai_habilitado,
                        sol.id_cargo_rpc,
                        sol.id_cargo_rpc_ai,
                        sol.tipo_concepto,
                        sol.revisado_asistente,
                        sol.fecha_inicio,
                        sol.dias_plazo_entrega,
                        sol.obs_presupuestos,
                        sol.precontrato,
                        sol.update_enable,
                        sol.codigo_poa,
                        sol.obs_poa,
                        (select count(*)
                             from unnest(id_tipo_estado_wfs) elemento
                             where elemento = ew.id_tipo_estado) as contador_estados
						from adq.tsolicitud sol
						inner join segu.tusuario usu1 on usu1.id_usuario = sol.id_usuario_reg
                        inner join wf.tproceso_wf pwf on pwf.id_proceso_wf = sol.id_proceso_wf
                        inner join orga.vfuncionario fun on fun.id_funcionario = sol.id_funcionario
                        inner join orga.tuo uo on uo.id_uo = sol.id_uo
                        inner join param.tmoneda mon on mon.id_moneda = sol.id_moneda
                        inner join param.tgestion ges on ges.id_gestion = sol.id_gestion
                        inner join param.tdepto dep on dep.id_depto = sol.id_depto
                        inner join wf.tproceso_macro pm on pm.id_proceso_macro = sol.id_proceso_macro
                        inner join adq.tcategoria_compra cat on cat.id_categoria_compra = sol.id_categoria_compra

                        left join orga.vfuncionario funrpc on funrpc.id_funcionario = sol.id_funcionario_rpc
                        inner join orga.vfuncionario funa on funa.id_funcionario = sol.id_funcionario_aprobador
                        left join orga.vfuncionario funs on funs.id_funcionario = sol.id_funcionario_supervisor

						left join segu.tusuario usu2 on usu2.id_usuario = sol.id_usuario_mod
                        left join param.vproveedor pro on pro.id_proveedor = sol.id_proveedor
                        '||v_inner||'
                        where  '||v_filtro;

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

            IF  pxp.f_existe_parametro(p_tabla,'historico') THEN

             v_historico =  v_parametros.historico;

            ELSE

            v_historico = 'no';

            END IF;

            if (v_parametros.id_funcionario_usu is null) then
            	v_parametros.id_funcionario_usu = -1;
            end if;

            IF p_administrador !=1  and lower(v_parametros.tipo_interfaz) = 'solicitudreq' THEN

              v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||'  or sol.id_usuario_reg='||p_id_usuario||' ) and ';


            END IF;

            IF  lower(v_parametros.tipo_interfaz) in ('solicitudvb','solicitudvbwzd','solicitudvbpoa','solicitudvbpresupuestos') THEN

              IF v_historico =  'no' THEN

                IF p_administrador !=1 THEN
                  v_filtro = ' (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (lower(sol.estado)!=''borrador'') and (lower(sol.estado)!=''proceso'' ) and ';
                ELSE
                    v_filtro = ' (lower(sol.estado)!=''borrador''  and lower(sol.estado)!=''proceso'' and lower(sol.estado)!=''finalizado'') and ';
                END IF;
              ELSE
                IF p_administrador !=1 THEN
                  v_filtro = ' (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (lower(sol.estado)!=''borrador'') ) and ';
                ELSE
                    v_filtro = ' (lower(sol.estado)!=''borrador'') and ';
                END IF;
              END IF;


            END IF;

            --la interface de vbpresupuestos mustra todas las solcitudes no importa el funcionario asignado
            IF  lower(v_parametros.tipo_interfaz) = 'solicitudvbpresupuestos' and v_historico =  'no' THEN
                 v_filtro = v_filtro||' (lower(sol.estado)=''vbpresupuestos'' ) and ';
            END IF;

            --la interface de vbpresupuestos mustra todas las solcitudes no importa el funcionario asignado
            IF  lower(v_parametros.tipo_interfaz) = 'solicitudvbpoa' and v_historico =  'no'  THEN
                 v_filtro = ' (lower(sol.estado)=''vbpoa'' ) and ';
            END IF;



            IF  lower(v_parametros.tipo_interfaz) = 'solicitudvbasistente' THEN


                v_filtro = ' (ew.id_funcionario  IN (select * FROM orga.f_get_funcionarios_x_usuario_asistente(now()::date,'||p_id_usuario||') AS (id_funcionario INTEGER))) and ';
                IF v_historico =  'no' THEN
                	v_filtro = v_filtro || ' lower(sol.estado)=''vbgerencia'' and ';
                END IF;
            END IF;


            IF v_historico =  'si' THEN

               v_inner =  'inner join wf.testado_wf ew on ew.id_proceso_wf = sol.id_proceso_wf';
               v_strg_sol = 'DISTINCT(sol.id_solicitud)';
               v_strg_obs = '---';

               IF p_administrador =1 THEN

                  v_filtro = ' (lower(sol.estado)!=''borrador'' ) and ';

               END IF;

            ELSE

               v_inner =  'inner join wf.testado_wf ew on ew.id_estado_wf = sol.id_estado_wf';
               v_strg_sol = 'sol.id_solicitud';
               v_strg_obs = 'ew.obs';

            END IF;


			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count('||v_strg_sol||')
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
                        left join orga.vfuncionario funs on funs.id_funcionario = sol.id_funcionario_supervisor

						left join segu.tusuario usu2 on usu2.id_usuario = sol.id_usuario_mod
                        left join param.vproveedor pro on pro.id_proveedor = sol.id_proveedor
				       '||v_inner||'

				        where  '||v_filtro;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;



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

            IF  pxp.f_existe_parametro(p_tabla,'id_solicitud') THEN

                  v_filtro = 'sol.id_solicitud='||v_parametros.id_solicitud||' and ';
            ELSE
                  v_filtro = 'sol.id_proceso_wf='||v_parametros.id_proceso_wf||' and ';

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
                        COALESCE(sol.usuario_ai,'''')::varchar as nombre_usuario_ai,
                        uo.codigo as codigo_uo

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

				        where '||v_filtro;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            raise notice '%', v_consulta;

			--Devuelve la respuesta
			return v_consulta;
    end;


   	/*********************************
 	#TRANSACCION:  'ADQ_ESTSOL_SEL'
 	#DESCRIPCION:	Consulta estado de solicitud
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		02-06-2013
	***********************************/

	elsif(p_transaccion='ADQ_ESTSOL_SEL')then
    begin
		select sol.id_estado_wf as ult_est_sol into v_id_estados
        from adq.tsolicitud sol
        left join adq.tproceso_compra pc on pc.id_solicitud=sol.id_solicitud
        where sol.id_solicitud=v_parametros.id_solicitud;

        create temp table flujo_solicitud(
        	funcionario text,
            nombre text,
            nombre_estado varchar,
            fecha_reg date,
            id_tipo_estado int4,
            id_estado_wf int4,
            id_estado_anterior int4
        ) on commit drop;

		--recupera el flujo de control de las solicitudes y del proceso de compra
		INSERT INTO flujo_solicitud(
        WITH RECURSIVE estados_solicitud_proceso(id_funcionario, id_proceso_wf, id_tipo_estado,id_estado_wf, id_estado_anterior, fecha_reg)AS(
     		SELECT et.id_funcionario, et.id_proceso_wf, et.id_tipo_estado, et.id_estado_wf, et.id_estado_anterior, et.fecha_reg
    		FROM wf.testado_wf et
     		WHERE et.id_estado_wf  in (v_id_estados.ult_est_sol)
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

        --Definicion de la respuesta
        v_consulta:='select * from flujo_solicitud';

        --Devuelve la respuesta
        return v_consulta;

	end;

    /*********************************
 	#TRANSACCION:  'ADQ_SOLOC_REP'
 	#DESCRIPCION:	Reporte Pre Orden Compra
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		22-09-2014
	***********************************/
	elsif(p_transaccion='ADQ_SOLOC_REP')then
    	begin
		v_consulta:='select pv.desc_proveedor,
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
                     sol.lugar_entrega,
                     sol.tipo,
                     mon.moneda,
                     mon.codigo as codigo_moneda,
                     sol.num_tramite
                	 from adq.tsolicitud sol
                   	 inner join param.vproveedor pv on pv.id_proveedor = sol.id_proveedor
                   	 left join segu.tpersona per on per.id_persona = pv.id_persona
                   	 left join param.tinstitucion ins on ins.id_institucion = pv.id_institucion
                   	 inner join param.tmoneda mon on mon.id_moneda = sol.id_moneda
                	 where sol.id_solicitud ='||v_parametros.id_solicitud||' and ';

          --Definicion de la respuesta
          v_consulta:=v_consulta||v_parametros.filtro;
          v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

          --Devuelve la respuesta
          return v_consulta;
        end;

	/*********************************
 	#TRANSACCION:  'ADQ_ESTPROC_SEL'
 	#DESCRIPCION:	Consulta estado de procesos
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		31-05-2013
	***********************************/

	elsif(p_transaccion='ADQ_ESTPROC_SEL')then
    begin

        create temp table flujo_proceso(
        	funcionario text,
            nombre text,
            nombre_estado varchar,
            fecha_reg date,
            id_tipo_estado int4,
            id_estado_wf int4,
            id_estado_anterior int4
        ) on commit drop;

		--recupera el flujo de control de las solicitudes y del proceso de compra
		INSERT INTO flujo_proceso(
        WITH RECURSIVE estados_solicitud_proceso(id_funcionario, id_proceso_wf, id_tipo_estado,id_estado_wf, id_estado_anterior, fecha_reg)AS(
     		SELECT et.id_funcionario, et.id_proceso_wf, et.id_tipo_estado, et.id_estado_wf, et.id_estado_anterior, et.fecha_reg
    		FROM wf.testado_wf et
     		WHERE et.id_estado_wf  in (
            			select pc.id_estado_wf as ult_est_prc
				        from adq.tsolicitud sol
        				left join adq.tproceso_compra pc on pc.id_solicitud=sol.id_solicitud
        				where pc.id_proceso_compra=v_parametros.id_proceso_compra)
     	UNION ALL
      		SELECT et.id_funcionario, et.id_proceso_wf, et.id_tipo_estado, et.id_estado_wf, et.id_estado_anterior, et.fecha_reg
        	FROM wf.testado_wf et, estados_solicitud_proceso
      		WHERE et.id_estado_wf=estados_solicitud_proceso.id_estado_anterior
     	)SELECT perf.nombre_completo1 as funcionario, tp.nombre,te.nombre_estado, es.fecha_reg,es.id_tipo_estado, es.id_estado_wf, COALESCE(es.id_estado_anterior,NULL) as id_estado_anterior
         FROM estados_solicitud_proceso es
         INNER JOIN wf.tproceso_wf pwf on pwf.id_proceso_wf=es.id_proceso_wf
         INNER JOIN wf.ttipo_proceso tp on tp.id_tipo_proceso=pwf.id_tipo_proceso
         INNER JOIN wf.ttipo_estado te on te.id_tipo_estado=es.id_tipo_estado
         LEFT JOIN orga.tfuncionario fun on fun.id_funcionario=es.id_funcionario
         LEFT JOIN segu.vpersona perf on perf.id_persona=fun.id_persona
         order by id_estado_wf);

        --Definicion de la respuesta
        v_consulta:='select * from flujo_proceso';

        --Devuelve la respuesta
        return v_consulta;

	end;
    /*********************************
 	#TRANSACCION:  'ADQ_CERT_SEL'
 	#DESCRIPCION:	Cetificado Poa
 	#AUTOR:		MAM
 	#FECHA:		02-06-2013
	***********************************/
    elsif(p_transaccion='ADQ_CERT_SEL')then
    	begin
        v_consulta:='select
                            ad.id_solicitud,
                            ad.num_tramite,
                            to_char(ad.fecha_soli,''DD/MM/YYYY'')as fecha_soli,
                            ad.justificacion,
                            ad.codigo_poa,
                            (SELECT  pxp.list(ob.codigo|| '' ''||ob.descripcion||'' '')
                                from pre.tobjetivo ob
                                where ob.codigo = ANY (string_to_array(ad.codigo_poa,'',''))) as codigo_descripcion,
                            ge.gestion
                            from adq.tsolicitud ad
                            inner join param.tgestion ge on ge.id_gestion = ad.id_gestion
                            where ad.codigo_poa IS NOT NULL and ad.id_proceso_wf='||v_parametros.id_proceso_wf;
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