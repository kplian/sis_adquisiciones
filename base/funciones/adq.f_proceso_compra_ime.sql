--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_proceso_compra_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
  /**************************************************************************
   SISTEMA:		Adquisiciones
   FUNCION: 		adq.f_proceso_compra_ime
   DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'adq.tproceso_compra'
   AUTOR: 		 (admin)
   FECHA:	        19-03-2013 12:55:29
   COMENTARIOS:
  ***************************************************************************
   HISTORIAL DE MODIFICACIONES:

   DESCRIPCION:
   AUTOR:
   FECHA:
  ***************************************************************************/

  DECLARE

    v_nro_requerimiento    	integer;
    v_parametros           	record;
    v_id_requerimiento     	integer;
    v_resp		            varchar;
    v_nombre_funcion        text;
    v_mensaje_error         text;
    v_id_proceso_compra		integer;
    v_id_funcionario_aux	integer;


    v_num_cot varchar;
    v_id_periodo integer;
    v_estado_sol varchar;
    v_id_estado_wf_sol integer;
    v_id_proceso_wf_sol integer;


    va_id_tipo_estado_sol integer[];
    va_codigo_estado_sol varchar[];
    va_disparador_sol varchar[];
    va_regla_sol varchar[];
    va_prioridad_sol integer[];

    v_id_funcionario integer;
    v_id_estado_actual integer;

    v_id_proceso_wf integer;
    v_id_estado_wf integer;
    v_codigo_estado varchar;
    v_id_depto integer;
    v_coun_num_cot integer;
    v_estado  varchar;
    v_id_tipo_estado integer;
    v_id_solicitud integer;
    v_id_usuario_reg integer;
    v_id_estado_wf_ant  integer;
    v_registros record;
    v_id_usuario integer;
    v_id_proveedor integer;
    v_hstore_coti  public.hstore;

    v_id_moneda  integer;

    v_tipo_cambio  numeric;
    v_id_alarma  integer;
    v_resp_doc  boolean;
    v_precontrato varchar;

  BEGIN

    v_nombre_funcion = 'adq.f_proceso_compra_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'ADQ_PROC_INS'
     #DESCRIPCION:	Inicia procesos de compra
     #AUTOR:		admin
     #FECHA:		19-03-2013 12:55:29
    ***********************************/

    if(p_transaccion='ADQ_PROC_INS')then

      begin

        --recupera datos de la solictud


        select
          s.id_estado_wf,
          s.id_proceso_wf,
          s.estado,
          s.id_funcionario,
          s.id_proveedor,
          s.id_moneda,
          s.precontrato
        into
          v_id_estado_wf_sol,
          v_id_proceso_wf_sol,
          v_estado_sol,
          v_id_funcionario,
          v_id_proveedor,
          v_id_moneda,
          v_precontrato
        from adq.tsolicitud s
        where s.id_solicitud = v_parametros.id_solicitud;

        --recupera el periodo

        select
          id_periodo
        into
          v_id_periodo
        from
          param.tperiodo per
        where per.fecha_ini <= v_parametros.fecha_ini_proc
              and per.fecha_fin >=  v_parametros.fecha_ini_proc
        limit 1 offset 0;



        --obtener el numero de cotizacion

        v_num_cot =   param.f_obtener_correlativo(
            'COT',
            v_id_periodo,-- par_id,
            NULL, --id_uo
            v_parametros.id_depto,    -- id_depto
            p_id_usuario,
            'ADQ',
            NULL);

        --pasa al siguiente estado la solcitud


        SELECT
          ps_id_tipo_estado,
          ps_codigo_estado,
          ps_disparador,
          ps_regla,
          ps_prioridad
        into
          va_id_tipo_estado_sol,
          va_codigo_estado_sol,
          va_disparador_sol,
          va_regla_sol,
          va_prioridad_sol

        FROM wf.f_obtener_estado_wf(v_id_proceso_wf_sol, v_id_estado_wf_sol,NULL,'siguiente');






        IF  va_id_tipo_estado_sol[2] is not null  THEN

          raise exception 'El proceso se encuentra mal parametrizado dentro de Work Flow,  la finalizacion de solicitud solo admite un estado siguiente';

        END IF;



        IF  va_codigo_estado_sol[1] != 'proceso'  THEN
          raise exception 'El proceso se encuentra mal parametrizado dentro de Work Flow, elsiguiente estado para la solicitud deberia ser "proceso" y no % ',va_codigo_estado_sol[1];
        END IF;


        -- registra estado eactual en el WF para la solicitud


        v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado_sol[1],
                                                      v_id_funcionario,
                                                      v_id_estado_wf_sol,
                                                      v_id_proceso_wf_sol,
                                                      p_id_usuario,
                                                      v_parametros._id_usuario_ai,
                                                      v_parametros._nombre_usuario_ai,
                                                      v_parametros.id_depto);


        -- actuliaza el stado en la solictud
        update adq.tsolicitud  s set
          id_estado_wf =  v_id_estado_actual,
          estado = va_codigo_estado_sol[1],
          id_usuario_mod=p_id_usuario,
          fecha_mod=now()
        where id_solicitud = v_parametros.id_solicitud;

        -- recupera el funcionario responsable del proceso segun auxiliar asginado ...

        SELECT
          fun.id_funcionario
        into
          v_id_funcionario_aux
        FROM param.tdepto_usuario du
          INNER JOIN segu.tusuario u on u.id_usuario = du.id_usuario
          INNER JOIN orga.tfuncionario fun on fun.id_persona = u.id_persona
        WHERE du.id_depto_usuario =  v_parametros.id_depto_usuario
        OFFSET 0 LIMIT 1;


        --iniciar el proceso WF

        raise notice '>>>>>>              registra proceso disparado % %',v_id_estado_wf_sol,v_parametros.id_depto;

        SELECT
          ps_id_proceso_wf,
          ps_id_estado_wf,
          ps_codigo_estado
        into
          v_id_proceso_wf,
          v_id_estado_wf,
          v_codigo_estado
        FROM wf.f_registra_proceso_disparado_wf(
            p_id_usuario,
            v_parametros._id_usuario_ai,
            v_parametros._nombre_usuario_ai,
            v_id_estado_actual,
            v_id_funcionario_aux,
            v_parametros.id_depto,
            'Proceso de Compra '||v_parametros.codigo_proceso,
            '',
            v_parametros.codigo_proceso
        );


        --registra el estado del WF para el proceso




        --cambiar de estado a la solicitud y registrar en log del WF


       --Sentencia de la insercion
        insert into adq.tproceso_compra(
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
          id_usuario_ai,
          usuario_ai,
          objeto
        ) values(
          v_parametros.id_depto,
          '1',
          v_parametros.id_solicitud,
          v_id_estado_wf,
          v_parametros.fecha_ini_proc,
          v_parametros.obs_proceso,
          v_id_proceso_wf,
          v_parametros.num_tramite,
          v_parametros.codigo_proceso,
          'activo',
          v_codigo_estado,
          v_num_cot,
          p_id_usuario,
          now(),
          null,
          null,
          v_parametros._id_usuario_ai,
          v_parametros._nombre_usuario_ai,
          v_parametros.objeto

        )RETURNING id_proceso_compra into v_id_proceso_compra;

        -- inserta documentos en estado borrador si estan configurados
        v_resp_doc =  wf.f_inserta_documento_wf(p_id_usuario, v_id_proceso_wf, v_id_estado_wf);
        -- verificar documentos
        v_resp_doc = wf.f_verifica_documento(p_id_usuario, v_id_estado_wf);


        --registra el auxiliar en adquisiciones

        IF  pxp.f_existe_parametro(p_tabla,'id_depto_usuario') THEN
          IF adq.f_registrar_auxiliar_adq(p_id_usuario,  v_parametros.id_depto_usuario, v_parametros.id_solicitud ) != 'true' THEN
            raise exception 'No se pudo asignar el usuario';
          END IF;
        END IF;

        --chequear que si la solicitud de compra tiene proveedor

        IF v_id_proveedor is not NULL THEN


          --tipo de cambio

          v_tipo_cambio =  param.f_get_tipo_cambio(v_id_moneda, now()::date, 'O');

          IF  v_tipo_cambio is NULL  THEN

            raise exception 'No existe tipo de cambio para la fecha %',  now();

          END IF;

          --si tienes proveedor registra una cotizacion

          v_hstore_coti =   hstore(ARRAY['id_proceso_compra',v_id_proceso_compra::varchar,
          'id_proveedor', v_id_proveedor::varchar,
          'nro_contrato',NULL::varchar,
          'lugar_entrega',NULL::varchar,
          'tipo_entrega',NULL::varchar,
          'fecha_coti',(now()::date)::varchar,
          'fecha_entrega',NULL::varchar,
          'id_moneda',v_id_moneda::varchar,
          'fecha_venc',NULL::varchar,
          'tipo_cambio_conv',v_tipo_cambio::varchar,
          'obs','generado a partir de la precotización',
          'fecha_adju',NULL::varchar,
          'nro_contrato',NULL::varchar,
          '_id_usuario_ai',v_parametros._id_usuario_ai::varchar,
          '_nombre_usuario_ai',v_parametros._nombre_usuario_ai::varchar,
          'precontrato', v_precontrato::varchar
          ]);


          v_resp = adq.f_inserta_cotizacion(p_administrador, p_id_usuario,v_hstore_coti);

        END IF;







        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Proceso de Compra almacenado(a) con exito (id_proceso_compra'||v_id_proceso_compra||')');
        v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_compra',v_id_proceso_compra::varchar);

        --Devuelve la respuesta
        return v_resp;

      end;




    /*********************************
  #TRANSACCION:  'ADQ_ASIGPROC_IME'
  #DESCRIPCION:	Asignacion de usuarios auxiliares responsables del proceso de compra
  #AUTOR:		admin
  #FECHA:		19-03-2013 12:55:29
 ***********************************/

    elsif(p_transaccion='ADQ_ASIGPROC_IME')then

      begin


        IF adq.f_registrar_auxiliar_adq(p_id_usuario,  v_parametros.id_depto_usuario, v_parametros.id_solicitud ) != 'true' THEN

          raise exception 'No se pudo asignar el usuario';
        END IF;

        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Usuario asignado al proceso)');
        v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud',v_parametros.id_solicitud::varchar);

        --Devuelve la respuesta
        return v_resp;

      end;



    /*********************************
     #TRANSACCION:  'ADQ_PROC_MOD'
     #DESCRIPCION:	Modificacion de registros
     #AUTOR:		admin
     #FECHA:		19-03-2013 12:55:29
    ***********************************/

    elsif(p_transaccion='ADQ_PROC_MOD')then

      begin
        --Sentencia de la modificacion
        update adq.tproceso_compra set

          fecha_ini_proc = v_parametros.fecha_ini_proc,
          obs_proceso = v_parametros.obs_proceso,
          codigo_proceso = v_parametros.codigo_proceso,

          fecha_mod = now(),
          id_usuario_mod = p_id_usuario,
          id_usuario_ai = v_parametros._id_usuario_ai,
          usuario_ai =  v_parametros._nombre_usuario_ai,
          objeto = v_parametros.objeto
        where id_proceso_compra=v_parametros.id_proceso_compra;

        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Proceso de Compra modificado(a)');
        v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_compra',v_parametros.id_proceso_compra::varchar);

        --Devuelve la respuesta
        return v_resp;

      end;




    /*********************************
     #TRANSACCION:  'ADQ_PROC_ELI'
     #DESCRIPCION:	Eliminacion de registros
     #AUTOR:		admin
     #FECHA:		19-03-2013 12:55:29
    ***********************************/

    elsif(p_transaccion='ADQ_PROC_ELI')then

      begin



        --obtenemos datos bascios
        select
          p.id_estado_wf,
          p.id_proceso_wf,
          p.estado,
          p.id_depto,
          p.id_solicitud
        into
          v_id_estado_wf,
          v_id_proceso_wf,
          v_codigo_estado,
          v_id_depto,
          v_id_solicitud

        from adq.tproceso_compra p
        where p.id_proceso_compra = v_parametros.id_proceso_compra;

        -- verificamos si tiene cotizacion

        select
          count(c.id_cotizacion)
        into
          v_coun_num_cot
        from adq.tcotizacion c
        where c.id_proceso_compra = v_parametros.id_proceso_compra;

        IF v_coun_num_cot > 0 THEN

          v_estado = 'anulado';

        ELSE
          -- sino tiene cotizacion se declara desierto
          v_estado = 'desierto';

        END IF;


        -- si tiene cotizacion verificamos que todas estan a nuladas
        IF v_estado = 'anulado' THEN
          select
            count(c.id_cotizacion)
          into
            v_coun_num_cot
          from adq.tcotizacion c
          where c.id_proceso_compra = v_parametros.id_proceso_compra and c.estado !='anulado';


          IF v_coun_num_cot >0 THEN

            raise exception 'Todas las cotizaciones tienen que estar anuladas primero';

          END IF;


        END IF;

        -- si todas las cotizaciones estan anuladas anulamos el proceso

        select
          te.id_tipo_estado
        into
          v_id_tipo_estado
        from wf.tproceso_wf pw
          inner join wf.ttipo_proceso tp on pw.id_tipo_proceso = tp.id_tipo_proceso
          inner join wf.ttipo_estado te on te.id_tipo_proceso = tp.id_tipo_proceso and te.codigo = v_estado
        where pw.id_proceso_wf = v_id_proceso_wf;



        -- pasamos la cotizacion al siguiente estado

        v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado,
                                                      NULL,
                                                      v_id_estado_wf,
                                                      v_id_proceso_wf,
                                                      p_id_usuario,
                                                      v_parametros._id_usuario_ai,
                                                      v_parametros._nombre_usuario_ai,
                                                      v_id_depto);


        -- actualiza estado en la cotizacion

        update adq.tproceso_compra  set
          id_estado_wf =  v_id_estado_actual,
          estado = v_estado,
          id_usuario_mod=p_id_usuario,
          fecha_mod=now(),
          id_usuario_ai = v_parametros._id_usuario_ai,
          usuario_ai =  v_parametros._nombre_usuario_ai
        where id_proceso_compra  = v_parametros.id_proceso_compra;

        -------------------------------------------------
         --liberamos la solicitud de compra
        --------------------------------------------------

        --recuperamos datos de la solicitud

        select
          s.id_estado_wf,
          s.id_proceso_wf
        into
          v_id_estado_wf,
          v_id_proceso_wf
        from adq.tsolicitud s
        where s.id_solicitud = v_id_solicitud;

        --recuperaq estado anterior segun Log del WF
        SELECT
          ps_id_tipo_estado,
          ps_id_funcionario,
          ps_id_usuario_reg,
          ps_id_depto,
          ps_codigo_estado,
          ps_id_estado_wf_ant
        into
          v_id_tipo_estado,
          v_id_funcionario,
          v_id_usuario_reg,
          v_id_depto,
          v_codigo_estado,
          v_id_estado_wf_ant
        FROM wf.f_obtener_estado_ant_log_wf(v_id_estado_wf);

        -- registra nuevo estado



        v_id_estado_actual = wf.f_registra_estado_wf(
            v_id_tipo_estado,
            v_id_funcionario,
            v_id_estado_wf,
            v_id_proceso_wf,
            p_id_usuario,
            v_parametros._id_usuario_ai,
            v_parametros._nombre_usuario_ai,
            v_id_depto);



        -- actualiza estado en la solicitud
        update adq.tsolicitud  s set
          id_estado_wf =  v_id_estado_actual,
          estado = v_codigo_estado,
          id_usuario_mod=p_id_usuario,
          fecha_mod=now()
        where id_solicitud =v_id_solicitud;



        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Proceso de Compra '||v_estado);
        v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_compra',v_parametros.id_proceso_compra::varchar);

        --Devuelve la respuesta
        return v_resp;

      end;

    /*********************************
  #TRANSACCION:  'ADQ_FINPRO_IME'
  #DESCRIPCION:	Finaliza el proceso de compra, la solictud y revierte el presupeusto sobrante.
  #AUTOR:		rac
  #FECHA:		10-07-2013 12:55:29
 ***********************************/

    elsif(p_transaccion='ADQ_FINPRO_IME')then

      begin

        --obtenemos datos bascios
        select
          p.id_estado_wf,
          p.id_proceso_wf,
          p.estado,
          p.id_depto,
          p.id_solicitud
        into
          v_id_estado_wf,
          v_id_proceso_wf,
          v_codigo_estado,
          v_id_depto,
          v_id_solicitud

        from adq.tproceso_compra p
        where p.id_proceso_compra = v_parametros.id_proceso_compra;

        -- verificamos si tiene cotizacion

        select
          count(c.id_cotizacion)
        into
          v_coun_num_cot
        from adq.tcotizacion c
        where c.id_proceso_compra = v_parametros.id_proceso_compra and c.estado_reg = 'activo';

        IF v_coun_num_cot > 0 THEN

          v_estado = 'finalizado';

        ELSE
          -- sino tiene cotizacion se declara desierto
          v_estado = 'desierto';

        END IF;




        -- si tiene cotizacion verificamos que todas estan anuladas o finalizadas
        IF v_estado = 'finalizado' THEN
          select
            count(c.id_cotizacion)
          into
            v_coun_num_cot
          from adq.tcotizacion c
          where c.id_proceso_compra = v_parametros.id_proceso_compra and c.estado_reg = 'activo' and c.estado not in ('anulado','finalizado','finalizada', 'contrato_elaborado');

          /*jrr(18/10/2016): las cotizacion en contrato_elaborado tb se dejan finalizar ya q en algunos casos
                   el proceso terminara con la elaboracion del contrato y el pago se realizara por obligaciones de pago*/
          IF v_coun_num_cot >0 THEN

            raise exception 'Todas las cotizaciones tienen que estar anuladas, finalizadas o con contrato_elaborado, idProceso =  %', v_parametros.id_proceso_compra;

          END IF;


        END IF;

        -- si todas las cotizaciones estan anuladas o finzalidas,  finzalimos el proceso

        select
          te.id_tipo_estado
        into
          v_id_tipo_estado
        from wf.tproceso_wf pw
          inner join wf.ttipo_proceso tp on pw.id_tipo_proceso = tp.id_tipo_proceso
          inner join wf.ttipo_estado te on te.id_tipo_proceso = tp.id_tipo_proceso and te.codigo = v_estado
        where pw.id_proceso_wf = v_id_proceso_wf and te.estado_reg = 'activo' and tp.estado_reg = 'activo';



        -- pasamos la cotizacion al siguiente estado

        v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado,
                                                      NULL,
                                                      v_id_estado_wf,
                                                      v_id_proceso_wf,
                                                      p_id_usuario,
                                                      v_parametros._id_usuario_ai,
                                                      v_parametros._nombre_usuario_ai,
                                                      v_id_depto);


        -- actualiza estado en la cotizacion

        update adq.tproceso_compra  set
          id_estado_wf =  v_id_estado_actual,
          estado = v_estado,
          id_usuario_mod=p_id_usuario,
          fecha_mod=now(),
          id_usuario_ai = v_parametros._id_usuario_ai,
          usuario_ai = v_parametros._nombre_usuario_ai
        where id_proceso_compra  = v_parametros.id_proceso_compra;

        -------------------------------------------------
         -- Finalizamos la solictud de Compra
        --------------------------------------------------

        --recuperamos datos de la solicitud

        select
          s.id_estado_wf,
          s.id_proceso_wf
        into
          v_id_estado_wf,
          v_id_proceso_wf
        from adq.tsolicitud s
        where s.id_solicitud = v_id_solicitud;

        --recupera estado  finalizado

        v_id_tipo_estado = NULL;
        select
          te.id_tipo_estado
        into
          v_id_tipo_estado
        from wf.tproceso_wf pw
          inner join wf.ttipo_proceso tp on pw.id_tipo_proceso = tp.id_tipo_proceso
          inner join wf.ttipo_estado te on te.id_tipo_proceso = tp.id_tipo_proceso and te.codigo = 'finalizado'
        where pw.id_proceso_wf = v_id_proceso_wf and te.estado_reg = 'activo' and tp.estado_reg = 'activo';


        IF v_id_tipo_estado is NULL THEN

          raise exception '?No se encontro el estado finalizado para la solictud en WF';


        END IF;
        -- registra nuevo estado



        v_id_estado_actual = wf.f_registra_estado_wf(
            v_id_tipo_estado,
            v_id_funcionario,
            v_id_estado_wf,
            v_id_proceso_wf,
            p_id_usuario,
            v_parametros._id_usuario_ai,
            v_parametros._nombre_usuario_ai,
            v_id_depto);



        -- actualiza estado en la solicitud
        update adq.tsolicitud  s set
          id_estado_wf =  v_id_estado_actual,
          estado = 'finalizado',
          id_usuario_mod=p_id_usuario,
          fecha_mod=now()
        where id_solicitud =v_id_solicitud;


        ----------------------------------------------------
        -- REVIERTE EL PRESUPUESTO SOBRANTE DE LA SOLICITUD
        -----------------------------------------------------
        --llamada a la funcion de reversion
        IF not adq.f_gestionar_presupuesto_solicitud(v_id_solicitud, p_id_usuario, 'revertir')  THEN

          raise exception 'Error al revertir  el presupeusto sobrante';

        END IF;


        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Usuario asginado al procesortido');
        v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_compra',v_parametros.id_proceso_compra::varchar);

        --Devuelve la respuesta
        return v_resp;

      end;

    /*********************************
 	#TRANSACCION:   'ADQ_REVPRE_IME'
 	#DESCRIPCION:	 Reversion del presupuesto sobrante no adjudicado en el proceso
 	#AUTOR:		Rensi ARteaga Copari
 	#FECHA:		29-06-2013 12:55:29
	***********************************/

    elsif(p_transaccion='ADQ_REVPRE_IME')then

      begin

        --verifico que el proceso este activo


        select
          pc.id_solicitud,
          pc.estado_reg ,
          pc.estado
        into
          v_registros
        from
          adq.tproceso_compra pc
        where pc.id_proceso_compra = v_parametros.id_proceso_compra;

        IF v_registros.estado_reg != 'activo' THEN

          raise exception 'El proceso no se encuentra activo';

        END IF;

        IF v_registros.estado in  ('anulado','desierto') THEN

          raise exception 'El proceso esta naulado o es desierto';

        END IF;

        --llamada a la funcion de reversion
        IF not adq.f_gestionar_presupuesto_solicitud(v_registros.id_solicitud, p_id_usuario, 'revertir_sobrante')  THEN

          raise exception 'Error al revertir  el presupeusto sobrante';

        END IF;

        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje','REversion de presupuesto sobrante para la solicitud id '||v_registros.id_solicitud);
        v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_compra',v_parametros.id_proceso_compra::varchar);

        --Devuelve la respuesta
        return v_resp;

      end;
    else

      raise exception 'Transaccion inexistente: %',p_transaccion;

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