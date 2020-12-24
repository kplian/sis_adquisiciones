--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_plan_pago_rep_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Tesoreria
 FUNCION:         tes.f_plan_pago_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'tes.tplan_pago'
 AUTOR:          (admin)
 FECHA:            10-04-2013 15:43:23
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
ISSUE             FECHA:             AUTOR:                        DESCRIPCION:
***************************************************************************/

DECLARE

    v_consulta            varchar;
    v_parametros          record;
    v_nombre_funcion       text;
    v_resp                varchar;
    v_filtro            varchar;

    v_historico        varchar;
    v_inner            varchar;
    v_strg_pp         varchar;
    v_strg_obs         varchar;
    va_id_depto        integer[];
    v_techo            record;

BEGIN

    v_nombre_funcion = 'adq.f_plan_pago_rep_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'TES_PLAPAREP_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        admin
     #FECHA:        10-04-2013 15:43:23
    ***********************************/

    if(p_transaccion='ADQ_PLAPAREP_SEL')then

        begin


            -- obtiene los departamentos del usuario
            select
                pxp.aggarray(depu.id_depto)
            into
                va_id_depto
            from param.tdepto_usuario depu
            where depu.id_usuario =  p_id_usuario;

            IF (v_parametros.id_funcionario_usu is null) then

                v_parametros.id_funcionario_usu = -1;

            END IF;

            --Sentencia de la consulta
            v_consulta:='

            	select
                          num_tramite,
                          id_depto,
                          nombre_depto_obp,
                          id_proveedor,
                          desc_proveedor,
                          id_plan_pago,
                          estado_reg,
                          nro_cuota,
                          monto_ejecutar_total_mb,
                          nro_sol_pago,
                          tipo_cambio,
                          fecha_pag,
                          id_proceso_wf,
                          fecha_dev,
                          estado,
                          tipo_pago,
                          monto_ejecutar_total_mo,
                          descuento_anticipo_mb,
                          obs_descuentos_anticipo,
                          id_plan_pago_fk,
                          id_obligacion_pago,
                          id_plantilla,
                          descuento_anticipo,
                          otros_descuentos,
                          tipo,
                          obs_monto_no_pagado,
                          obs_otros_descuentos,
                          monto,
                          id_int_comprobante,
                          nombre_pago,
                          monto_no_pagado_mb,
                          monto_mb,
                          id_estado_wf,
                          id_cuenta_bancaria,
                          otros_descuentos_mb,
                          forma_pago,
                          monto_no_pagado,
                          fecha_reg,
                          id_usuario_reg,
                          fecha_mod,
                          id_usuario_mod,
                          usr_reg,
                          usr_mod,
                          fecha_tentativa,
                          desc_plantilla,
                          liquido_pagable,
                          total_prorrateado,
                          total_pagado,
                          desc_cuenta_bancaria,
                          sinc_presupuesto,
                          monto_retgar_mb,
                          monto_retgar_mo,
                          descuento_ley,
                          obs_descuentos_ley,
                          descuento_ley_mb,
                          porc_descuento_ley,
                          nro_cheque,
                          nro_cuenta_bancaria,
                          id_cuenta_bancaria_mov,
                          desc_deposito,
                          numero_op,
                          id_depto_conta,
                          id_moneda,
                          tipo_moneda,
                          desc_moneda,
                          porc_monto_excento_var,
                          monto_excento,
                          obs_wf,
                          obs_descuento_inter_serv,
                          descuento_inter_serv,
                          porc_monto_retgar,
                          desc_funcionario1,
                          revisado_asistente,
                          conformidad,
                          fecha_conformidad,
                          tipo_obligacion,
                          monto_ajuste_ag,
                          monto_ajuste_siguiente_pago,
                          pago_variable,
                          monto_anticipo,
                          fecha_costo_ini,
                          fecha_costo_fin,
                          funcionario_wf,
                          tiene_form500,
                          id_depto_lb,
                          desc_depto_lb,
                          ultima_cuota_dev,
                          id_depto_conta_pp,
                          desc_depto_conta_pp,
                          contador_estados,
                          prioridad_lp,
                          id_gestion,
                          id_periodo,
                          pago_borrador,
                          codigo_tipo_anticipo,
                          cecos
                        from adq.vreporte_pago plapa
                        where  plapa.estado_reg=''activo''  and ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;


             If pxp.f_existe_parametro(p_tabla, 'groupBy') THEN

                IF v_parametros.groupBy = 'num_tramite' THEN
                  v_consulta:=v_consulta||' order by plapa.id_obligacion_pago DESC , num_tramite ' ||v_parametros.groupDir|| ', ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;

                ELSE

                  v_consulta:=v_consulta||' order by ' ||v_parametros.groupBy|| ' ' ||v_parametros.groupDir|| ', ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;
                END IF;
       		Else
             	v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;
    		End If;


            -- v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ', nro_cuota ASC limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            raise notice '%',v_consulta;

            --Devuelve la respuesta
            return v_consulta;

        end;

        /*********************************
          #TRANSACCION:  'TES_PLAPAREP_CONT'
          #DESCRIPCION:    Conteo de registros
          #AUTOR:        admin
          #FECHA:        10-04-2013 15:43:23
         ***********************************/

    elsif(p_transaccion='ADQ_PLAPAREP_CONT')then

        begin


            IF (v_parametros.id_funcionario_usu is null) then
                v_parametros.id_funcionario_usu = -1;
            END IF;

            --Sentencia de la consulta de conteo de registros
            v_consulta:='
            	     select count(plapa.id_plan_pago)
                        from adq.vreporte_pago plapa
                        where  plapa.estado_reg=''activo''   and ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;

            raise notice '% .',v_consulta;
            --Devuelve la respuesta
            return v_consulta;

        end;
        /*********************************
     #TRANSACCION:  'ADQ_OBPNUM_SEL'
     #DESCRIPCION:  Numero de tramite de las obligaciones de pago
     #AUTOR:        EGS
     #FECHA:        10/03/2020
    ***********************************/

    elsif(p_transaccion='ADQ_OBPNUM_SEL')then

        begin
            --RAISE EXCEPTION 'v_parametros.filtro %',v_parametros.filtro;
            IF v_parametros.filtro <> '0 = 0' THEN
                v_filtro = 'WHERE '||v_parametros.filtro;
            ELSE
                v_filtro = '';
            END IF;
            --Sentencia de la consulta de conteo de registros
            v_consulta:='SELECT
                         DISTINCT(obp.num_tramite)
                      FROM tes.tobligacion_pago obp
                      '||v_filtro||'
                      ORDER BY obp.num_tramite ASC';

            raise notice '% .',v_consulta;
            --Devuelve la respuesta
            return v_consulta;

        end;
        /*********************************
 #TRANSACCION:  'ADQ_OBPNUM_CONT'
 #DESCRIPCION:  Count Numero de tramite de las obligaciones de pago
 #AUTOR:        EGS
 #FECHA:        10/03/2020
***********************************/

    elsif(p_transaccion='ADQ_OBPNUM_CONT')then

        begin
            IF v_parametros.filtro <> '0 = 0' THEN
                v_filtro = 'WHERE '||v_parametros.filtro;
            ELSE
                v_filtro = '';
            END IF;
            --Sentencia de la consulta de conteo de registros
            v_consulta:='SELECT
                         COUNT (DISTINCT(obp.num_tramite))
                      FROM tes.tobligacion_pago obp
                      '||v_filtro;

            raise notice '% .',v_consulta;
            --Devuelve la respuesta
            return v_consulta;

        end;
        
	
        /*********************************
        #TRANSACCION:  'ADQ_CONSREP_SEL'
        #DESCRIPCION:    Consulta de datos
        #AUTOR:        admin
        #FECHA:        10-04-2013 15:43:23
        ***********************************/

    	ELSIF(p_transaccion='ADQ_CONSREP_SEL')THEN
        BEGIN

            --Sentencia de la consulta
            v_consulta:='SELECT 
                        DISTINCT 
                        sol.num_tramite::varchar,
                        sol.justificacion::varchar,
                        pxp.list(distinct p.desc_proveedor)::varchar as desc_proveedor,
                        fun.id_funcionario::integer,
                        fun.desc_funcionario1::varchar as desc_funcionario,
                        cot.id_moneda::integer,
                        mon.moneda::varchar,
                        cot.fecha_adju::date,
                        (
                        SELECT max(tesw.fecha_reg)
                        FROM wf.testado_wf tesw
                        JOIN wf.tproceso_wf pw ON pw.id_proceso_wf=tesw.id_proceso_wf
                        JOIN wf.ttipo_estado te ON te.id_tipo_estado=tesw.id_tipo_estado
                        WHERE
                        te.nombre_estado=''Solicitud Aprobada'' AND
                        tesw.id_proceso_wf=sol.id_proceso_wf
                        limit 1
                        )::date as fecha_apro,
                        pxp.list(distinct cc.codigo_cc)::varchar as cecos,
                        sol.id_proceso_wf::integer,
                        sol.id_categoria_compra::integer,                                                                        
                        COALESCE(sum(cdt.cantidad_adju * cdt.precio_unitario), 0::numeric) AS monto_total_adjudicado,
                        COALESCE(sum(cdt.cantidad_adju * cdt.precio_unitario_mb), 0::numeric) AS monto_total_adjudicado_mb
                        FROM adq.tcotizacion cot
                        JOIN adq.tproceso_compra proc ON proc.id_proceso_compra = cot.id_proceso_compra
                        JOIN adq.tsolicitud sol ON sol.id_solicitud = proc.id_solicitud
                        LEFT JOIN adq.tcotizacion_det cdt ON cdt.id_cotizacion = cot.id_cotizacion
                        LEFT JOIN adq.tsolicitud_det sd ON sd.id_solicitud_det = cdt.id_solicitud_det
                        LEFT JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas = sd.id_concepto_ingas
                        JOIN param.vcentro_costo cc ON cc.id_centro_costo = sd.id_centro_costo
                        JOIN param.tmoneda mon ON mon.id_moneda = sol.id_moneda
                        JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario = sol.id_funcionario AND fun.estado_reg_asi::text = ''activo''::text
                        JOIN param.vproveedor p ON p.id_proveedor = cot.id_proveedor
                        JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra = sol.id_categoria_compra
                        WHERE fun.fecha_asignacion <= sol.fecha_soli AND
                        fun.fecha_finalizacion >= sol.fecha_soli OR
                        fun.fecha_asignacion <= sol.fecha_soli AND
                        fun.fecha_finalizacion IS NULL AND '; 
            v_consulta:=v_consulta||v_parametros.filtro;           
            v_consulta:=v_consulta||'
            			GROUP BY
                        sol.num_tramite,
                        sol.justificacion,
                        fun.id_funcionario,
                        fun.desc_funcionario1,
                        cot.id_moneda,
                        mon.moneda,
                        cot.fecha_adju,
                        sol.id_categoria_compra,
                        sol.id_proceso_wf';
                        
            --Definicion de la respuesta
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            raise notice '%',v_consulta;
            --raise exception '%',v_consulta;
            --Devuelve la respuesta
            return v_consulta;
        END;
    
    	/*********************************
        #TRANSACCION:  'ADQ_CONSREP_CONT'
        #DESCRIPCION:    Consulta de datos
        #AUTOR:        admin
        #FECHA:        10-04-2013 15:43:23
        ***********************************/

    	ELSIF(p_transaccion='ADQ_CONSREP_CONT')THEN
        BEGIN

            --Sentencia de la consulta
            v_consulta:='WITH parcial AS (
            			SELECT 
                        DISTINCT 
                        sol.num_tramite,
                        sol.justificacion,
                        pxp.list(distinct p.desc_proveedor)::varchar as desc_proveedor,
                        fun.id_funcionario,
                        fun.desc_funcionario1 as desc_funcionario,
                        cot.id_moneda,
                        mon.moneda,
                        cot.fecha_adju,
                        (
                        SELECT max(tesw.fecha_reg)
                        FROM wf.testado_wf tesw
                        JOIN wf.tproceso_wf pw ON pw.id_proceso_wf=tesw.id_proceso_wf
                        JOIN wf.ttipo_estado te ON te.id_tipo_estado=tesw.id_tipo_estado
                        WHERE
                        te.nombre_estado=''Solicitud Aprobada'' AND
                        tesw.id_proceso_wf=sol.id_proceso_wf
                        limit 1
                        )::date as fecha_apro,
                        pxp.list(distinct cc.codigo_cc) as cecos,
                        sol.id_proceso_wf,
                        sol.id_categoria_compra,                                                                        
                        COALESCE(sum(cdt.cantidad_adju * cdt.precio_unitario), 0::numeric) AS monto_total_adjudicado,
                        COALESCE(sum(cdt.cantidad_adju * cdt.precio_unitario_mb), 0::numeric) AS monto_total_adjudicado_mb
                        FROM adq.tcotizacion cot
                        JOIN adq.tproceso_compra proc ON proc.id_proceso_compra = cot.id_proceso_compra
                        JOIN adq.tsolicitud sol ON sol.id_solicitud = proc.id_solicitud
                        LEFT JOIN adq.tcotizacion_det cdt ON cdt.id_cotizacion = cot.id_cotizacion
                        LEFT JOIN adq.tsolicitud_det sd ON sd.id_solicitud_det = cdt.id_solicitud_det
                        LEFT JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas = sd.id_concepto_ingas
                        JOIN param.vcentro_costo cc ON cc.id_centro_costo = sd.id_centro_costo
                        JOIN param.tmoneda mon ON mon.id_moneda = sol.id_moneda
                        JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario = sol.id_funcionario AND fun.estado_reg_asi::text = ''activo''::text
                        JOIN param.vproveedor p ON p.id_proveedor = cot.id_proveedor
                        JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra = sol.id_categoria_compra
                        WHERE fun.fecha_asignacion <= sol.fecha_soli AND
                        fun.fecha_finalizacion >= sol.fecha_soli OR
                        fun.fecha_asignacion <= sol.fecha_soli AND
                        fun.fecha_finalizacion IS NULL AND '; 
            v_consulta:=v_consulta||v_parametros.filtro;           
            v_consulta:=v_consulta||'
            		    GROUP BY
                        sol.num_tramite,
                        sol.justificacion,
                        fun.id_funcionario,
                        fun.desc_funcionario1,
                        cot.id_moneda,
                        mon.moneda,
                        cot.fecha_adju,
                        sol.id_categoria_compra,
                        sol.id_proceso_wf)
                        
                        SELECT
                        count(num_tramite) as total
                        FROM parcial';
          
            --Definicion de la respuesta
            raise notice '%',v_consulta;
            --raise exception '%',v_consulta;
            --Devuelve la respuesta
            return v_consulta;
        END;
        
        /*********************************
        #TRANSACCION:  'ADQ_CONSREP_REP'
        #DESCRIPCION:    Consulta de datos
        #AUTOR:        admin
        #FECHA:        10-04-2013 15:43:23
        ***********************************/

    	ELSIF(p_transaccion='ADQ_CONSREP_REP')THEN
        BEGIN

            --Sentencia de la consulta
            v_consulta:='SELECT 
                        DISTINCT 
                        sol.num_tramite::varchar,
                        sol.justificacion::varchar,
                        pxp.list(distinct p.desc_proveedor)::varchar as desc_proveedor,
                        fun.id_funcionario::integer,
                        fun.desc_funcionario1::varchar as desc_funcionario,
                        cot.id_moneda::integer,
                        mon.moneda::varchar,
                        cot.fecha_adju::date,
                        (
                        SELECT max(tesw.fecha_reg)
                        FROM wf.testado_wf tesw
                        JOIN wf.tproceso_wf pw ON pw.id_proceso_wf=tesw.id_proceso_wf
                        JOIN wf.ttipo_estado te ON te.id_tipo_estado=tesw.id_tipo_estado
                        WHERE
                        te.nombre_estado=''Solicitud Aprobada'' AND
                        tesw.id_proceso_wf=sol.id_proceso_wf
                        limit 1
                        )::date as fecha_apro,
                        pxp.list(distinct cc.codigo_cc)::varchar as cecos,
                        sol.id_proceso_wf::integer,
                        sol.id_categoria_compra::integer,                                                                        
                        COALESCE(sum(cdt.cantidad_adju * cdt.precio_unitario), 0::numeric) AS monto_total_adjudicado,
                        COALESCE(sum(cdt.cantidad_adju * cdt.precio_unitario_mb), 0::numeric) AS monto_total_adjudicado_mb
                        FROM adq.tcotizacion cot
                        JOIN adq.tproceso_compra proc ON proc.id_proceso_compra = cot.id_proceso_compra
                        JOIN adq.tsolicitud sol ON sol.id_solicitud = proc.id_solicitud
                        LEFT JOIN adq.tcotizacion_det cdt ON cdt.id_cotizacion = cot.id_cotizacion
                        LEFT JOIN adq.tsolicitud_det sd ON sd.id_solicitud_det = cdt.id_solicitud_det
                        LEFT JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas = sd.id_concepto_ingas
                        JOIN param.vcentro_costo cc ON cc.id_centro_costo = sd.id_centro_costo
                        JOIN param.tmoneda mon ON mon.id_moneda = sol.id_moneda
                        JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario = sol.id_funcionario AND fun.estado_reg_asi::text = ''activo''::text
                        JOIN param.vproveedor p ON p.id_proveedor = cot.id_proveedor
                        JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra = sol.id_categoria_compra
                        WHERE fun.fecha_asignacion <= sol.fecha_soli AND
                        fun.fecha_finalizacion >= sol.fecha_soli OR
                        fun.fecha_asignacion <= sol.fecha_soli AND
                        fun.fecha_finalizacion IS NULL AND '; 
            v_consulta:=v_consulta||v_parametros.filtro;           
            v_consulta:=v_consulta||'
                        GROUP BY
                        sol.num_tramite,
                        sol.justificacion,
                        fun.id_funcionario,
                        fun.desc_funcionario1,
                        cot.id_moneda,
                        mon.moneda,
                        cot.fecha_adju,
                        sol.id_categoria_compra,
                        sol.id_proceso_wf';
                        
            --Definicion de la respuesta
            --v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            raise notice '%',v_consulta;
            --raise exception '%',v_consulta;
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
PARALLEL UNSAFE
COST 100;