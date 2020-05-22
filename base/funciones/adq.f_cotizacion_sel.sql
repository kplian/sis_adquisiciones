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
 AUTOR: 		Rensi Arteaga Copari
 FECHA:	        21-03-2013 14:48:35
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:

   HISTORIAL DE MODIFICACIONES:

 ISSUE            FECHA:              AUTOR                 DESCRIPCION

 #0               05/09/2013        RAC KPLIAN        Creación
 #16               20/01/2020        RAC KPLIAN        Mejor el rendimiento de la interface de Ordenes y Cotizaciones, issue #16
 #18			   20/05/2020			EGS				aumentando Filtros y agrupadores para cotizacones
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

    item		record;

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

            --#16 cambio de consulta

    		--Sentencia de la consulta
			v_consulta:='

            select
                        cot.id_cotizacion,
                        estado_reg,
                        estado,
                        lugar_entrega,
                        tipo_entrega,
                        fecha_coti,
                        numero_oc,
                        id_proveedor,
                        desc_proveedor,
                        fecha_entrega,
                        id_moneda,
                        moneda,
                        id_proceso_compra,
                        fecha_venc,
                        obs,
                        fecha_adju,
                        nro_contrato,
                        fecha_reg,
                        id_usuario_reg,
                        fecha_mod,
                        id_usuario_mod,
                        usr_reg,
                        usr_mod,
                        id_estado_wf,
                        id_proceso_wf,
                        desc_moneda,
                        tipo_cambio_conv,
                        email,
                        numero,
                        num_tramite,
                        id_obligacion_pago,
                        tiempo_entrega,
                        funcionario_contacto,
                        telefono_contacto,
                        correo_contacto,
                        prellenar_oferta,
                        forma_pago,
                        requiere_contrato,
                        total_adjudicado,
                        total_cotizado,
                        total_adjudicado_mb,
                        tiene_form500,
                        correo_oc,
                        cecos,
                        total,
                        nro_cuenta,
                        id_categoria_compra,
                        codigo_proceso,
                        desc_categoria_compra
                     from adq.vorden_compra cot
                     where '||v_filtro;


           v_consulta:=v_consulta||v_parametros.filtro;
            --#18;
           If pxp.f_existe_parametro(p_tabla, 'groupBy') THEN

                IF v_parametros.groupBy = 'num_tramite' THEN
                  v_consulta:=v_consulta||' order by num_tramite ' ||v_parametros.groupDir|| ', ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;

                ELSE

                  v_consulta:=v_consulta||' order by ' ||v_parametros.groupBy|| ' ' ||v_parametros.groupDir|| ', ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;
                END IF;
       		Else
             	v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;
    		End If;


			--Definicion de la respuesta

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
            --#16 cambio de consulta
			--Sentencia de la consulta de conteo de registros
			v_consulta:='
            			SELECT count(cot.id_cotizacion)
					    from adq.vorden_compra cot

                        where '||v_filtro;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
            raise notice '%',v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'ADQ_DFOR_CO_SEL'
 	#DESCRIPCION:  Insertar alarma segun orden de compra
 	#AUTOR:	        Juan
 	#FECHA:		    18-06-2018 14:48:35
	***********************************/

	elsif(p_transaccion='ADQ_DFOR_CO_SEL')then

		begin

            --RAISE NOTICE 'ERROR2 jj tr %',v_consulta;
            --RAISE EXCEPTION 'ERROR jj tr %',v_consulta;

              FOR item IN(select
                               (select ff.id_funcionario from
                               orga.vfuncionario f1
                               join orga.tfuncionario ff on ff.id_funcionario=f1.id_funcionario
                               join orga.tuo_funcionario uf1 on uf1.id_funcionario=ff.id_funcionario
                               join orga.tuo uo1 on uo1.id_uo=uf1.id_uo
                               left join segu.tusuario usu on usu.id_persona=ff.id_persona
                               where uo1.id_uo=(SELECT * FROM orga.f_get_uo_departamento(uo.id_uo,f.id_funcionario,null))::INTEGER and usu.estado_reg='activo' and ff.estado_reg='activo')::INTEGER  id_funcionario_departamento,

                               (select usu.id_usuario from
                               orga.vfuncionario f1
                               join orga.tfuncionario ff on ff.id_funcionario=f1.id_funcionario
                               join orga.tuo_funcionario uf1 on uf1.id_funcionario=ff.id_funcionario
                               join orga.tuo uo1 on uo1.id_uo=uf1.id_uo
                               left join segu.tusuario usu on usu.id_persona=ff.id_persona
                               where uo1.id_uo=(SELECT * FROM orga.f_get_uo_departamento(uo.id_uo,f.id_funcionario,null))::INTEGER and usu.estado_reg='activo' and ff.estado_reg='activo')::INTEGER as id_usuario_departamento,

                              (select ff.email_empresa from
                               orga.vfuncionario f1
                               join orga.tfuncionario ff on ff.id_funcionario=f1.id_funcionario
                               join orga.tuo_funcionario uf1 on uf1.id_funcionario=ff.id_funcionario
                               join orga.tuo uo1 on uo1.id_uo=uf1.id_uo
                               where uo1.id_uo=(SELECT * FROM orga.f_get_uo_departamento(uo.id_uo,f.id_funcionario,null))::INTEGER and  ff.estado_reg='activo')::VARCHAR as correo_departamento,

                               (select ff.id_funcionario from segu.tusuario usu
                               join orga.tfuncionario ff on ff.id_persona=usu.id_persona
                               where usu.id_usuario = cot.id_usuario_reg and usu.estado_reg='activo' and ff.estado_reg='activo')::INTEGER as id_funcionario_gestor,

                               (select usu.id_usuario from segu.tusuario usu
                               join orga.tfuncionario ff on ff.id_persona=usu.id_persona
                               where usu.id_usuario = cot.id_usuario_reg and usu.estado_reg='activo' and ff.estado_reg='activo')::INTEGER as id_usuario_gestor,

                               (SELECT ff.email_empresa from segu.tusuario uu
                               join orga.tfuncionario ff on ff.id_persona=uu.id_persona
                               where uu.id_usuario=cot.id_usuario_reg and uu.estado_reg='activo' and ff.estado_reg='activo')::VARCHAR as correo_gestor,

                               (SELECT ff.id_funcionario from segu.tusuario uu
                               join orga.tfuncionario ff on ff.id_persona=uu.id_persona
                               where ff.email_empresa like '%'||cot.correo_contacto||'%' and uu.estado_reg='activo' and ff.estado_reg='activo')::INTEGER as id_funcionario_solicitante,

                               (SELECT uu.id_usuario from segu.tusuario uu
                               join orga.tfuncionario ff on ff.id_persona=uu.id_persona
                               where ff.email_empresa like '%'||cot.correo_contacto||'%' and uu.estado_reg='activo' and ff.estado_reg='activo')::INTEGER as id_usuario_solicitante,
                               cot.correo_contacto::VARCHAR as correo_solicitante,
                               pro.desc_proveedor::VARCHAR as desc_proveedor,
                               (((EXTRACT(YEAR FROM cot.fecha_entrega))||'-'||(EXTRACT(MONTH FROM cot.fecha_entrega))||'-'||(EXTRACT(DAY FROM cot.fecha_entrega)))::TIMESTAMP -  ((EXTRACT(YEAR FROM now()))||'-'||(EXTRACT(MONTH FROM now()))||'-'||(EXTRACT(DAY FROM now())))::TIMESTAMP)::VARCHAR as dias_faltantes,
                               cot.num_tramite::VARCHAR AS num_tramite,
                               cot.fecha_entrega::VARCHAR as fecha_entrega,
                               sol.justificacion
                               from adq.tcotizacion cot
                               inner join adq.tproceso_compra proc on proc.id_proceso_compra = cot.id_proceso_compra
                               inner join adq.tsolicitud sol on sol.id_solicitud = proc.id_solicitud
                               inner join segu.tusuario usu1 on usu1.id_usuario = cot.id_usuario_reg
                               inner join param.tmoneda mon on mon.id_moneda = cot.id_moneda
                               inner join param.vproveedor pro on pro.id_proveedor = cot.id_proveedor
                               --left join segu.tusuario usu2 on usu2.id_usuario = cot.id_usuario_reg
                               --left join orga.vfuncionario_persona fp on fp.id_persona=pro.id_persona
                               join orga.vfuncionario f on f.id_funcionario=sol.id_funcionario
                               join orga.tuo_funcionario uf on uf.id_funcionario=f.id_funcionario
                               join orga.tuo uo on uo.id_uo=uf.id_uo
                               WHERE
                               usu1.estado_reg='activo' and f.estado_reg='activo' and
                               (
                               (((EXTRACT(YEAR FROM cot.fecha_entrega))||'-'||(EXTRACT(MONTH FROM cot.fecha_entrega))||'-'||(EXTRACT(DAY FROM cot.fecha_entrega)))::TIMESTAMP -  ((EXTRACT(YEAR FROM now()))||'-'||(EXTRACT(MONTH FROM now()))||'-'||(EXTRACT(DAY FROM now())))::TIMESTAMP) = '15 days'
                               OR (((EXTRACT(YEAR FROM cot.fecha_entrega))||'-'||(EXTRACT(MONTH FROM cot.fecha_entrega))||'-'||(EXTRACT(DAY FROM cot.fecha_entrega)))::TIMESTAMP -  ((EXTRACT(YEAR FROM now()))||'-'||(EXTRACT(MONTH FROM now()))||'-'||(EXTRACT(DAY FROM now())))::TIMESTAMP) = '10 days'
                               OR (((EXTRACT(YEAR FROM cot.fecha_entrega))||'-'||(EXTRACT(MONTH FROM cot.fecha_entrega))||'-'||(EXTRACT(DAY FROM cot.fecha_entrega)))::TIMESTAMP -  ((EXTRACT(YEAR FROM now()))||'-'||(EXTRACT(MONTH FROM now()))||'-'||(EXTRACT(DAY FROM now())))::TIMESTAMP) = '5 days'
                               OR (((EXTRACT(YEAR FROM cot.fecha_entrega))||'-'||(EXTRACT(MONTH FROM cot.fecha_entrega))||'-'||(EXTRACT(DAY FROM cot.fecha_entrega)))::TIMESTAMP -  ((EXTRACT(YEAR FROM now()))||'-'||(EXTRACT(MONTH FROM now()))||'-'||(EXTRACT(DAY FROM now())))::TIMESTAMP) = '0 days'
                               )) LOOP

                                   /*
                                   insert into param.talarma(
                                      acceso_directo,
                                      id_funcionario,
                                      fecha,
                                      estado_reg,
                                      descripcion,
                                      id_usuario_reg,
                                      fecha_reg,
                                      id_usuario_mod,
                                      fecha_mod,
                                      tipo,
                                      obs,
                                      clase,
                                      titulo,
                                      parametros,
                                      id_usuario,
                                      titulo_correo,
                                      correos,
                                      documentos,
                                      id_proceso_wf,
                                      id_estado_wf,
                                      id_plantilla_correo,
                                      estado_envio
                                      ) values(
                                      '',--acceso_directo
                                      591,--par_id_funcionario 591 juan
                                      now(),--par_fecha
                                      'activo',
                                      --'<font color="99CC00" size="5"><font size="4">Solicitud de Compra</font> </font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>ADQ-001129-2018</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RAMIRO PACO ESCOBAR </b>en estado<b>&nbsp; Evaluación de propuestas (Comité)<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>RAMIRO PACO ESCOBAR&nbsp; <br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; VoBo Control Proceso II</b><br><br><br>&nbsp;ADQ-CENTRAL-SOLC-5/149-2018 Obs:Favor revisar -  <br>',
                                      '<font color="99CC00" size="5"><font size="4">'||regexp_replace(regexp_replace(item.dias_faltantes,'00:00:00','0','g'),'days','','g')||' Dias para fin servicio </font> </font><br><br><b></b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b>'||item.num_tramite||'</b><br> Proveedor : <b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'||item.desc_proveedor||'</b><br>Fecha de entrega  : <b>&nbsp;&nbsp;'||item.fecha_entrega||'</b>',--par_descripcion
                                      1,--par_id_usuario admin
                                      now(),
                                      null,
                                      null,
                                      'notificacion',--par_tipo
                                      ''::varchar, --par_obs
                                      '',--par_clase
                                      item.justificacion,--par_titulo
                                      '',--par_parametros
                                      407,--par_id_usuario_alarma 407 juan
                                      item.justificacion,--par_titulo_correo
                                      '',--par_correos
                                      '',--par_documentos
                                      NULL,--p_id_proceso_wf
                                      NULL,--p_id_estado_wf
                                      NULL,--p_id_plantilla_correo
                                      'si'::character varying --v_estado_envio
                                    );

                                    */

                                   -- Jefe de departamento
                                   insert into param.talarma(
                                      acceso_directo,
                                      id_funcionario,
                                      fecha,
                                      estado_reg,
                                      descripcion,
                                      id_usuario_reg,
                                      fecha_reg,
                                      id_usuario_mod,
                                      fecha_mod,
                                      tipo,
                                      obs,
                                      clase,
                                      titulo,
                                      parametros,
                                      id_usuario,
                                      titulo_correo,
                                      correos,
                                      documentos,
                                      id_proceso_wf,
                                      id_estado_wf,
                                      id_plantilla_correo,
                                      estado_envio
                                      ) values(
                                      '',--acceso_directo
                                      item.id_funcionario_departamento::INTEGER,--par_id_funcionario 591 juan
                                      now(),--par_fecha
                                      'activo',
                                      '<font color="99CC00" size="5"><font size="4">'||regexp_replace(regexp_replace(item.dias_faltantes,'00:00:00','0','g'),'days','','g')||' Dias para fin servicio </font> </font><br><br><b></b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b>'||item.num_tramite||'</b><br> Proveedor : <b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'||item.desc_proveedor||'</b><br>Fecha de entrega  : <b>&nbsp;&nbsp;'||item.fecha_entrega||'</b>',--par_descripcion
                                      1,--par_id_usuario admin
                                      now(),
                                      null,
                                      null,
                                      'notificacion',--par_tipo
                                      ''::varchar, --par_obs
                                      '',--par_clase
                                      item.justificacion,--par_titulo
                                      '',--par_parametros
                                      item.id_usuario_departamento::INTEGER,--par_id_usuario_alarma 407 juan
                                      item.justificacion,--par_titulo correo
                                      item.correo_departamento::VARCHAR,--par_correos
                                      '',--par_documentos
                                      NULL,--p_id_proceso_wf
                                      NULL,--p_id_estado_wf
                                      NULL,--p_id_plantilla_correo
                                      'si'::character varying --v_estado_envio
                                    );


                                   -- Gestor
                                   insert into param.talarma(
                                      acceso_directo,
                                      id_funcionario,
                                      fecha,
                                      estado_reg,
                                      descripcion,
                                      id_usuario_reg,
                                      fecha_reg,
                                      id_usuario_mod,
                                      fecha_mod,
                                      tipo,
                                      obs,
                                      clase,
                                      titulo,
                                      parametros,
                                      id_usuario,
                                      titulo_correo,
                                      correos,
                                      documentos,
                                      id_proceso_wf,
                                      id_estado_wf,
                                      id_plantilla_correo,
                                      estado_envio
                                      ) values(
                                      '',--acceso_directo
                                      item.id_funcionario_gestor::INTEGER,--par_id_funcionario 591 juan
                                      now(),--par_fecha
                                      'activo',
                                      '<font color="99CC00" size="5"><font size="4">'||regexp_replace(regexp_replace(item.dias_faltantes,'00:00:00','0','g'),'days','','g')||' Dias para fin servicio </font> </font><br><br><b></b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b>'||item.num_tramite||'</b><br> Proveedor : <b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'||item.desc_proveedor||'</b><br>Fecha de entrega  : <b>&nbsp;&nbsp;'||item.fecha_entrega||'</b>',--par_descripcion
                                      1,--par_id_usuario admin
                                      now(),
                                      null,
                                      null,
                                      'notificacion',--par_tipo
                                      ''::varchar, --par_obs
                                      '',--par_clase
                                      item.justificacion,--par_titulo
                                      '',--par_parametros
                                      item.id_usuario_gestor::INTEGER,--par_id_usuario_alarma 407 juan
                                      item.justificacion,--par_titulo correo
                                      item.correo_gestor::VARCHAR,--par_correos
                                      '',--par_documentos
                                      NULL,--p_id_proceso_wf
                                      NULL,--p_id_estado_wf
                                      NULL,--p_id_plantilla_correo
                                      'si'::character varying --v_estado_envio
                                    );


                                   -- solicitante
                                   insert into param.talarma(
                                      acceso_directo,
                                      id_funcionario,
                                      fecha,
                                      estado_reg,
                                      descripcion,
                                      id_usuario_reg,
                                      fecha_reg,
                                      id_usuario_mod,
                                      fecha_mod,
                                      tipo,
                                      obs,
                                      clase,
                                      titulo,
                                      parametros,
                                      id_usuario,
                                      titulo_correo,
                                      correos,
                                      documentos,
                                      id_proceso_wf,
                                      id_estado_wf,
                                      id_plantilla_correo,
                                      estado_envio
                                      ) values(
                                      '',--acceso_directo
                                      item.id_funcionario_solicitante::INTEGER,--par_id_funcionario 591 juan
                                      now(),--par_fecha
                                      'activo',
                                      '<font color="99CC00" size="5"><font size="4">'||regexp_replace(regexp_replace(item.dias_faltantes,'00:00:00','0','g'),'days','','g')||' Dias para fin servicio </font> </font><br><br><b></b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b>'||item.num_tramite||'</b><br> Proveedor : <b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'||item.desc_proveedor||'</b><br>Fecha de entrega  : <b>&nbsp;&nbsp;'||item.fecha_entrega||'</b>',--par_descripcion
                                      1,--par_id_usuario admin
                                      now(),
                                      null,
                                      null,
                                      'notificacion',--par_tipo
                                      ''::varchar, --par_obs
                                      '',--par_clase
                                      item.justificacion,--par_titulo
                                      '',--par_parametros
                                      item.id_usuario_solicitante::INTEGER,--par_id_usuario_alarma 407 juan
                                      item.justificacion,--par_titulo correo
                                      item.correo_solicitante::VARCHAR,--par_correos
                                      '',--par_documentos
                                      NULL,--p_id_proceso_wf
                                      NULL,--p_id_estado_wf
                                      NULL,--p_id_plantilla_correo
                                      'si'::character varying --v_estado_envio
                                    );



           	   END LOOP;



            --Definicion de la respuesta

            v_consulta:='select
                               (select ff.id_funcionario from
                               orga.vfuncionario f1
                               join orga.tfuncionario ff on ff.id_funcionario=f1.id_funcionario
                               join orga.tuo_funcionario uf1 on uf1.id_funcionario=ff.id_funcionario
                               join orga.tuo uo1 on uo1.id_uo=uf1.id_uo
                               left join segu.tusuario usu on usu.id_persona=ff.id_persona
                               where uo1.id_uo=(SELECT * FROM orga.f_get_uo_departamento(uo.id_uo,f.id_funcionario,null))::INTEGER and usu.estado_reg=''activo'' and ff.estado_reg=''activo'')::INTEGER  id_funcionario_departamento,

                               (select usu.id_usuario from
                               orga.vfuncionario f1
                               join orga.tfuncionario ff on ff.id_funcionario=f1.id_funcionario
                               join orga.tuo_funcionario uf1 on uf1.id_funcionario=ff.id_funcionario
                               join orga.tuo uo1 on uo1.id_uo=uf1.id_uo
                               left join segu.tusuario usu on usu.id_persona=ff.id_persona
                               where uo1.id_uo=(SELECT * FROM orga.f_get_uo_departamento(uo.id_uo,f.id_funcionario,null))::INTEGER and usu.estado_reg=''activo'' and ff.estado_reg=''activo'')::INTEGER as id_usuario_departamento,

                              (select ff.email_empresa from
                               orga.vfuncionario f1
                               join orga.tfuncionario ff on ff.id_funcionario=f1.id_funcionario
                               join orga.tuo_funcionario uf1 on uf1.id_funcionario=ff.id_funcionario
                               join orga.tuo uo1 on uo1.id_uo=uf1.id_uo
                               where uo1.id_uo=(SELECT * FROM orga.f_get_uo_departamento(uo.id_uo,f.id_funcionario,null))::INTEGER  and ff.estado_reg=''activo'')::VARCHAR as coreo_departamento,

                               (select ff.id_funcionario from segu.tusuario usu
                               join orga.tfuncionario ff on ff.id_persona=usu.id_persona
                               where usu.id_usuario = cot.id_usuario_reg and usu.estado_reg=''activo'' and ff.estado_reg=''activo'')::INTEGER as id_funcionario_gestor,

                               (select usu.id_usuario from segu.tusuario usu
                               join orga.tfuncionario ff on ff.id_persona=usu.id_persona
                               where usu.id_usuario = cot.id_usuario_reg and usu.estado_reg=''activo'' and ff.estado_reg=''activo'')::INTEGER as id_usuario_gestor,

                               (SELECT ff.email_empresa from segu.tusuario uu
                               join orga.tfuncionario ff on ff.id_persona=uu.id_persona
                               where uu.id_usuario=cot.id_usuario_reg and uu.estado_reg=''activo'' and ff.estado_reg=''activo'')::VARCHAR as correo_gestor,

                               (SELECT ff.id_funcionario from segu.tusuario uu
                               join orga.tfuncionario ff on ff.id_persona=uu.id_persona
                               where ff.email_empresa like ''%''||cot.correo_contacto||''%'' and uu.estado_reg=''activo'' and ff.estado_reg=''activo'')::INTEGER as id_funcionario_solicitante,

                               (SELECT uu.id_usuario from segu.tusuario uu
                               join orga.tfuncionario ff on ff.id_persona=uu.id_persona
                               where ff.email_empresa like ''%''||cot.correo_contacto||''%'' and uu.estado_reg=''activo'' and ff.estado_reg=''activo'')::INTEGER as id_usuario_solicitante,
                               cot.correo_contacto::VARCHAR as correo_solicitante,
                               pro.desc_proveedor::VARCHAR,
                               (((EXTRACT(YEAR FROM cot.fecha_entrega))||''-''||(EXTRACT(MONTH FROM cot.fecha_entrega))||''-''||(EXTRACT(DAY FROM cot.fecha_entrega)))::TIMESTAMP -  ((EXTRACT(YEAR FROM now()))||''-''||(EXTRACT(MONTH FROM now()))||''-''||(EXTRACT(DAY FROM now())))::TIMESTAMP)::VARCHAR as dias_faltantes
                               from adq.tcotizacion cot
                               inner join adq.tproceso_compra proc on proc.id_proceso_compra = cot.id_proceso_compra
                               inner join adq.tsolicitud sol on sol.id_solicitud = proc.id_solicitud
                               inner join segu.tusuario usu1 on usu1.id_usuario = cot.id_usuario_reg
                               inner join param.tmoneda mon on mon.id_moneda = cot.id_moneda
                               inner join param.vproveedor pro on pro.id_proveedor = cot.id_proveedor
                               --left join segu.tusuario usu2 on usu2.id_usuario = cot.id_usuario_reg
                               --left join orga.vfuncionario_persona fp on fp.id_persona=pro.id_persona
                               join orga.vfuncionario f on f.id_funcionario=sol.id_funcionario
                               join orga.tuo_funcionario uf on uf.id_funcionario=f.id_funcionario
                               join orga.tuo uo on uo.id_uo=uf.id_uo
                               WHERE
                               usu1.estado_reg=''activo'' and f.estado_reg=''activo'' and
                               (
                               (((EXTRACT(YEAR FROM cot.fecha_entrega))||''-''||(EXTRACT(MONTH FROM cot.fecha_entrega))||''-''||(EXTRACT(DAY FROM cot.fecha_entrega)))::TIMESTAMP -  ((EXTRACT(YEAR FROM now()))||''-''||(EXTRACT(MONTH FROM now()))||''-''||(EXTRACT(DAY FROM now())))::TIMESTAMP) = ''15 days''
                               OR (((EXTRACT(YEAR FROM cot.fecha_entrega))||''-''||(EXTRACT(MONTH FROM cot.fecha_entrega))||''-''||(EXTRACT(DAY FROM cot.fecha_entrega)))::TIMESTAMP -  ((EXTRACT(YEAR FROM now()))||''-''||(EXTRACT(MONTH FROM now()))||''-''||(EXTRACT(DAY FROM now())))::TIMESTAMP) = ''10 days''
                               OR (((EXTRACT(YEAR FROM cot.fecha_entrega))||''-''||(EXTRACT(MONTH FROM cot.fecha_entrega))||''-''||(EXTRACT(DAY FROM cot.fecha_entrega)))::TIMESTAMP -  ((EXTRACT(YEAR FROM now()))||''-''||(EXTRACT(MONTH FROM now()))||''-''||(EXTRACT(DAY FROM now())))::TIMESTAMP) = ''5 days''
                               OR (((EXTRACT(YEAR FROM cot.fecha_entrega))||''-''||(EXTRACT(MONTH FROM cot.fecha_entrega))||''-''||(EXTRACT(DAY FROM cot.fecha_entrega)))::TIMESTAMP -  ((EXTRACT(YEAR FROM now()))||''-''||(EXTRACT(MONTH FROM now()))||''-''||(EXTRACT(DAY FROM now())))::TIMESTAMP) = ''0 days''
                               )  ';

			--v_consulta:=v_consulta||v_parametros.filtro;
			--v_consulta:=v_consulta||' order by cot.correo_contacto asc limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
--raise notice 'err %',v_consulta;
--raise EXCEPTION 'err %',v_consulta;


            return v_consulta;


	 end;

    /*********************************
 	#TRANSACCION:  'ADQ_DFOR_CO_CONT'
 	#DESCRIPCION:	Conteo de registros de la consulta de cotizaciones
 	#AUTOR:	 	Gonzalo Sarmiento Sejas
 	#FECHA:		21-03-2013 14:48:35
	***********************************/

	elsif(p_transaccion='ADQ_DFOR_CO_CONT')then

		begin

			--Sentencia de la consulta de conteo de registros
			v_consulta:='
                     select count(cot.id_cotizacion)
                          from adq.tcotizacion cot
                           inner join adq.tproceso_compra proc on proc.id_proceso_compra = cot.id_proceso_compra
                           inner join adq.tsolicitud sol on sol.id_solicitud = proc.id_solicitud
                           inner join segu.tusuario usu1 on usu1.id_usuario = cot.id_usuario_reg
                           inner join param.tmoneda mon on mon.id_moneda = cot.id_moneda
                           inner join param.vproveedor pro on pro.id_proveedor = cot.id_proveedor

                           join orga.vfuncionario f on f.id_funcionario=sol.id_funcionario
                           join orga.tuo_funcionario uf on uf.id_funcionario=f.id_funcionario
                           join orga.tuo uo on uo.id_uo=uf.id_uo
                           WHERE (((EXTRACT(YEAR FROM cot.fecha_entrega))||''-''||(EXTRACT(MONTH FROM cot.fecha_entrega))||''-''||(EXTRACT(DAY FROM cot.fecha_entrega)))::TIMESTAMP -  ((EXTRACT(YEAR FROM now()))||''-''||(EXTRACT(MONTH FROM now()))||''-''||(EXTRACT(DAY FROM now())))::TIMESTAMP) = ''15 days''
                               OR (((EXTRACT(YEAR FROM cot.fecha_entrega))||''-''||(EXTRACT(MONTH FROM cot.fecha_entrega))||''-''||(EXTRACT(DAY FROM cot.fecha_entrega)))::TIMESTAMP -  ((EXTRACT(YEAR FROM now()))||''-''||(EXTRACT(MONTH FROM now()))||''-''||(EXTRACT(DAY FROM now())))::TIMESTAMP) = ''10 days''
                               OR (((EXTRACT(YEAR FROM cot.fecha_entrega))||''-''||(EXTRACT(MONTH FROM cot.fecha_entrega))||''-''||(EXTRACT(DAY FROM cot.fecha_entrega)))::TIMESTAMP -  ((EXTRACT(YEAR FROM now()))||''-''||(EXTRACT(MONTH FROM now()))||''-''||(EXTRACT(DAY FROM now())))::TIMESTAMP) = ''5 days''
                               OR (((EXTRACT(YEAR FROM cot.fecha_entrega))||''-''||(EXTRACT(MONTH FROM cot.fecha_entrega))||''-''||(EXTRACT(DAY FROM cot.fecha_entrega)))::TIMESTAMP -  ((EXTRACT(YEAR FROM now()))||''-''||(EXTRACT(MONTH FROM now()))||''-''||(EXTRACT(DAY FROM now())))::TIMESTAMP) = ''0 days''  ';


			--Definicion de la respuesta
			--v_consulta:=v_consulta||v_parametros.filtro;

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
                    sol.id_categoria_compra,
                    cot.funcionario_contacto,
                    cot.telefono_contacto,
                    cot.correo_contacto,
                    tppc.codigo as codigo_proceso,
                    cot.forma_pago,
                    pc.objeto,
                    uo.codigo as codigo_uo,
                    sol.observacion::varchar,
                    cot.obs::varchar
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
              inner join orga.tuo uo on uo.id_uo=sol.id_uo
              where '||v_filtro;

          --Definicion de la respuesta
          v_consulta:=v_consulta||v_parametros.filtro;
          v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
      raise notice '%', v_consulta;

          --Devuelve la respuesta
          return v_consulta;
        end;

  		/*********************************
 	#TRANSACCION:  'ADQ_NUMCOT_SEL'
 	#DESCRIPCION:	Numeros de tramite que hay en cotizaciones
 	#AUTOR:		EGS
 	#FECHA:		20/04/2020
	***********************************/

	elsif(p_transaccion='ADQ_NUMCOT_SEL')then

    	begin

    		--Sentencia de la consulta
			v_consulta:='
        			 select
                        DISTINCT (num_tramite)
                     from adq.vorden_compra cot
                     where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
             raise notice '%', v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;
	/*********************************
 	#TRANSACCION:  'ADQ_NUMCOT_CONT'
 	#DESCRIPCION:	Conteo de registros de la consulta de numero de tramites cotizaciones
 	#AUTOR:	 	EGS
 	#FECHA:		20/04/2020
	***********************************/

	elsif(p_transaccion='ADQ_NUMCOT_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='SELECT
            			  count(DISTINCT cot.num_tramite)
					    from adq.vorden_compra cot
                        where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
            raise notice '%',v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;
    	/*********************************
 	#TRANSACCION:  'ADQ_CODPRCOT_SEL'
 	#DESCRIPCION:	Codigos de proceso que hay en cotizaciones
 	#AUTOR:		EGS
 	#FECHA:		20/04/2020
    #ISSUE:		#18
	***********************************/

	elsif(p_transaccion='ADQ_CODPRCOT_SEL')then

    	begin

    		--Sentencia de la consulta
			v_consulta:='
        			 select
                        DISTINCT (codigo_proceso)
                     from adq.vorden_compra cot
                     where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
             raise notice '%', v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;
	/*********************************
 	#TRANSACCION:  'ADQ_CODPRCOT_CONT'
 	#DESCRIPCION:	Conteo de registros de la consulta de codigo de proceso cotizaciones
 	#AUTOR:	 	EGS
 	#FECHA:		20/04/2020
    #ISSUE:		#18
	***********************************/

	elsif(p_transaccion='ADQ_CODPRCOT_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='SELECT
            			  count(DISTINCT cot.codigo_proceso)
					    from adq.vorden_compra cot
                        where ';

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