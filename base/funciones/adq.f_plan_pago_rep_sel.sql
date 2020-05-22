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