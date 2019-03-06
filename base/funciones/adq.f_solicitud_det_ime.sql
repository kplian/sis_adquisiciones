CREATE OR REPLACE FUNCTION adq.f_solicitud_det_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.f_solicitud_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'adq.tsolicitud_det'
 AUTOR: 		 (admin)
 FECHA:	        05-03-2013 01:28:10
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 ISSUE              FECHA:              AUTOR:              DESCRIPCION:
   #4   endeEtr    08/02/2019           EGS                 Validacion cuando el detalle sea consolidado por una presolicitud no puede ser modificado y cuando la presolicitud este en estado finalizado no puede ser eliminado

***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_solicitud_det	    integer;

    v_id_partida            integer;
    v_id_cuenta             integer;
    v_id_auxiliar           integer;
    v_id_moneda             integer;
    v_fecha_soli            date;
    v_monto_ga_mb           numeric;
    v_monto_sg_mb           numeric;
    v_precio_unitario_mb    numeric;
    v_id_gestion            integer;
    v_registros_cig         record;
    v_id_orden_trabajo		integer;
    v_record_presolicitud_det   record;
    v_record_solicitud_det      record;


BEGIN

    v_nombre_funcion = 'adq.f_solicitud_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ADQ_SOLD_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin
 	#FECHA:		05-03-2013 01:28:10
	***********************************/

	if(p_transaccion='ADQ_SOLD_INS')then

        begin

           -- obtener parametros de solicitud

            select
             s.id_moneda,
             s.fecha_soli,
             s.id_gestion
            into
              v_id_moneda,
              v_fecha_soli,
              v_id_gestion
            from adq.tsolicitud s
            where  s.id_solicitud = v_parametros.id_solicitud;

           --recupera el nombre del concepto de gasto

            select
            cig.desc_ingas
            into
            v_registros_cig
            from param.tconcepto_ingas cig
            where cig.id_concepto_ingas =  v_parametros.id_concepto_ingas;

             --obtener partida, cuenta auxiliar del concepto de gasto

             v_id_partida = NULL;

            --recueprar la partida de la parametrizacion

            SELECT
              ps_id_partida ,
              ps_id_cuenta,
              ps_id_auxiliar
            into
              v_id_partida,
              v_id_cuenta,
              v_id_auxiliar
           FROM conta.f_get_config_relacion_contable('CUECOMP', v_id_gestion, v_parametros.id_concepto_ingas, v_parametros.id_centro_costo,  'No se encontro relación contable para el conceto de gasto: '||v_registros_cig.desc_ingas||'. <br> Mensaje: ');



        IF  v_id_partida  is NULL  THEN

        	raise exception 'No se encontro partida para el concepto de gasto y el centro de costos solicitados';

        END IF;




            --obetener el precio en la moneda base del sistema



            v_monto_ga_mb= param.f_convertir_moneda(
                          v_id_moneda,
                          NULL,   --por defecto moenda base
                          v_parametros.precio_ga,
                          v_fecha_soli,
                          'O',-- tipo oficial, venta, compra
                           NULL);--defecto dos decimales

             v_monto_sg_mb= param.f_convertir_moneda(
                          v_id_moneda,
                          NULL,   --por defecto moenda base
                          v_parametros.precio_sg,
                          v_fecha_soli,
                          'O',-- tipo oficial, venta, compra
                           NULL);--defecto dos decimales

        v_precio_unitario_mb= param.f_convertir_moneda(
                            v_id_moneda,
                            NULL,   --por defecto moenda base
                            v_parametros.precio_unitario,
                            v_fecha_soli,
                            'O',-- tipo oficial, venta, compra
                             NULL);


        	--Sentencia de la insercion
        	insert into adq.tsolicitud_det(
			id_centro_costo,
			descripcion,
			precio_unitario,
			id_solicitud,
			id_partida,
			id_orden_trabajo,

			id_concepto_ingas,
			id_cuenta,
			precio_total,
			cantidad,
			id_auxiliar,
			estado_reg,
		    precio_ga,
            precio_sg,
			id_usuario_reg,
			fecha_reg,
			fecha_mod,
			id_usuario_mod,
            precio_ga_mb,
            precio_sg_mb,
            precio_unitario_mb


          	) values(
			v_parametros.id_centro_costo,
			v_parametros.descripcion,
			v_parametros.precio_unitario,
			v_parametros.id_solicitud,
			v_id_partida,
			v_parametros.id_orden_trabajo,

			v_parametros.id_concepto_ingas,
			v_id_cuenta,
			v_parametros.precio_total,
			v_parametros.cantidad_sol,
			v_id_auxiliar,
			'activo',
		    v_parametros.precio_ga,
            v_parametros.precio_sg,
			p_id_usuario,
			now(),
			null,
			null,
            v_monto_ga_mb,
            v_monto_sg_mb,
            v_precio_unitario_mb

			)RETURNING id_solicitud_det into v_id_solicitud_det;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle almacenado(a) con exito (id_solicitud_det'||v_id_solicitud_det||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_det',v_id_solicitud_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ADQ_DGSTSOL_INS'
 	#DESCRIPCION:	Insercion detalle gasto solicitud
 	#AUTOR:		Gonzalo Sarmiento
 	#FECHA:		06-06-2017
	***********************************/

	elsif(p_transaccion='ADQ_DGSTSOL_INS')then

        begin

           -- obtener parametros de solicitud

            select
             s.id_moneda,
             s.fecha_soli,
             s.id_gestion
            into
              v_id_moneda,
              v_fecha_soli,
              v_id_gestion
            from adq.tsolicitud s
            where  s.id_solicitud = v_parametros.id_solicitud;

           --recupera el nombre del concepto de gasto

            select
            cig.id_concepto_ingas, cig.desc_ingas
            into
            v_registros_cig
            from param.tconcepto_ingas cig
            where upper(cig.desc_ingas) =  upper(v_parametros.concepto_gasto)
            and 'adquisiciones' = ANY(cig.sw_autorizacion);

            IF v_registros_cig.id_concepto_ingas IS NULL THEN
            	raise exception 'No se encontro parametrizado el concepto de gasto %', v_parametros.concepto_gasto;
            END IF;

             --obtener partida, cuenta auxiliar del concepto de gasto

             v_id_partida = NULL;

            --recueprar la partida de la parametrizacion

            SELECT
              ps_id_partida ,
              ps_id_cuenta,
              ps_id_auxiliar
            into
              v_id_partida,
              v_id_cuenta,
              v_id_auxiliar
           FROM conta.f_get_config_relacion_contable('CUECOMP', v_id_gestion, v_registros_cig.id_concepto_ingas, v_parametros.id_centro_costo,  'No se encontro relación contable para el conceto de gasto: '||v_registros_cig.desc_ingas||'. <br> Mensaje: ');


        IF  v_id_partida  is NULL  THEN

        	raise exception 'No se encontro partida para el concepto de gasto y el centro de costos solicitados';

        END IF;

        	--recuperar la orden de trabajo

            select id_orden_trabajo into v_id_orden_trabajo
            from conta.torden_trabajo
            where upper(motivo_orden)=upper(v_parametros.orden_trabajo)
            or upper(codigo)=upper(v_parametros.orden_trabajo)
            or upper(desc_orden) = upper(v_parametros.orden_trabajo);

            IF v_id_orden_trabajo IS NULL THEN
            	raise exception 'No existe la orden de trabajo %', v_parametros.orden_trabajo;
            END IF;

            --obetener el precio en la moneda base del sistema

            v_monto_ga_mb= param.f_convertir_moneda(
                          v_id_moneda,
                          NULL,   --por defecto moenda base
                          v_parametros.precio_ga,
                          v_fecha_soli,
                          'O',-- tipo oficial, venta, compra
                           NULL);--defecto dos decimales

             v_monto_sg_mb= param.f_convertir_moneda(
                          v_id_moneda,
                          NULL,   --por defecto moenda base
                          v_parametros.precio_sg,
                          v_fecha_soli,
                          'O',-- tipo oficial, venta, compra
                           NULL);--defecto dos decimales

        v_precio_unitario_mb= param.f_convertir_moneda(
                            v_id_moneda,
                            NULL,   --por defecto moenda base
                            v_parametros.precio_unitario,
                            v_fecha_soli,
                            'O',-- tipo oficial, venta, compra
                             NULL);


        	--Sentencia de la insercion
        	insert into adq.tsolicitud_det(
			id_centro_costo,
			descripcion,
			precio_unitario,
			id_solicitud,
			id_partida,
			id_orden_trabajo,
			id_concepto_ingas,
			id_cuenta,
			precio_total,
			cantidad,
			id_auxiliar,
			estado_reg,
		    precio_ga,
            precio_sg,
			id_usuario_reg,
			fecha_reg,
			fecha_mod,
			id_usuario_mod,
            precio_ga_mb,
            precio_sg_mb,
            precio_unitario_mb


          	) values(
			v_parametros.id_centro_costo,
			v_parametros.descripcion,
			v_parametros.precio_unitario,
			v_parametros.id_solicitud,
			v_id_partida,
			v_id_orden_trabajo,
			v_registros_cig.id_concepto_ingas,
			v_id_cuenta,
			v_parametros.precio_total,
			v_parametros.cantidad_sol,
			v_id_auxiliar,
			'activo',
		    v_parametros.precio_ga,
            v_parametros.precio_sg,
			p_id_usuario,
			now(),
			null,
			null,
            v_monto_ga_mb,
            v_monto_sg_mb,
            v_precio_unitario_mb

			)RETURNING id_solicitud_det into v_id_solicitud_det;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle almacenado(a) con exito (id_solicitud_det'||v_id_solicitud_det||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_det',v_id_solicitud_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

    /*********************************
 	#TRANSACCION:  'ADQ_DGSTSOL_ELI'
 	#DESCRIPCION:	Insercion detalle gasto solicitud
 	#AUTOR:		Gonzalo Sarmiento
 	#FECHA:		07-07-2017
	***********************************/

	elsif(p_transaccion='ADQ_DGSTSOL_ELI')then

        begin

        	DELETE
            FROM adq.tsolicitud_det
            where id_solicitud=v_parametros.id_solicitud;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle de gastos de solicitud eliminados');
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud',v_parametros.id_solicitud::varchar);

            --Devuelve la respuesta
            return v_resp;
        end;

	/*********************************
 	#TRANSACCION:  'ADQ_SOLD_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin
 	#FECHA:		05-03-2013 01:28:10
	***********************************/

	elsif(p_transaccion='ADQ_SOLD_MOD')then

		begin
        -- #4
            --validando si el detalle fue consolidada desde una presolicitud o se sumo un item 
            SELECT
                presd.id_presolicitud_det
                into 
                v_record_presolicitud_det
            FROM adq.tpresolicitud_det presd
            WHERE presd.id_solicitud_det = v_parametros.id_solicitud_det;
            --recuperamos los datos de la solicitud
            SELECT
                sold.id_centro_costo,
                sold.id_concepto_ingas,
                sold.precio_unitario,
                sold.cantidad
                INTO
                v_record_solicitud_det
            From adq.tsolicitud_det sold
            WHERE sold.id_solicitud_det = v_parametros.id_solicitud_det; 
            
            IF v_record_presolicitud_det.id_presolicitud_det is not null THEN                 
                IF v_record_solicitud_det.id_centro_costo <> v_parametros.id_centro_costo or
                v_record_solicitud_det.id_concepto_ingas<> v_parametros.id_concepto_ingas or
                v_record_solicitud_det.precio_unitario<> v_parametros.precio_unitario or
                v_record_solicitud_det.cantidad<> v_parametros.cantidad_sol  THEN
                 RAISE EXCEPTION 'No puede editar este detalle solo la descripcion.Este detalle fue consolidada o tiene un item de una presolicitud.Eliminela o desconsolide la presolicitud';
                END IF;
            END IF;
            --#4
            -- obtener parametros de solicitud
            select s.id_moneda, s.fecha_soli,s.id_gestion  into v_id_moneda, v_fecha_soli, v_id_gestion
            from adq.tsolicitud s
            where  s.id_solicitud = v_parametros.id_solicitud;



           --recupera el nombre del concepto de gasto

            select
            cig.desc_ingas
            into
            v_registros_cig
            from param.tconcepto_ingas cig
            where cig.id_concepto_ingas =  v_parametros.id_concepto_ingas;

            --obtener partida, cuenta auxiliar del concepto de gasto
            SELECT
              ps_id_partida ,
              ps_id_cuenta,
              ps_id_auxiliar
            into
              v_id_partida,
              v_id_cuenta,
              v_id_auxiliar
          FROM conta.f_get_config_relacion_contable('CUECOMP', v_id_gestion, v_parametros.id_concepto_ingas, v_parametros.id_centro_costo,  'No se encontro relación contable para el conceto de gasto: '||v_registros_cig.desc_ingas||'. <br> Mensaje: ');



        IF  v_id_partida  is NULL  THEN

        	raise exception 'No se encontro partida para el concepto de gasto y el centro de costos solicitados,%, %, %',v_id_gestion, v_parametros.id_concepto_ingas, v_parametros.id_centro_costo;

        END IF;



            v_monto_ga_mb= param.f_convertir_moneda(
                          v_id_moneda,
                          NULL,   --por defecto moenda base
                          v_parametros.precio_ga,
                          v_fecha_soli,
                          'O',-- tipo oficial, venta, compra
                           NULL);--defecto dos decimales

             v_monto_sg_mb= param.f_convertir_moneda(
                          v_id_moneda,
                          NULL,   --por defecto moenda base
                          v_parametros.precio_sg,
                          v_fecha_soli,
                          'O',-- tipo oficial, venta, compra
                           NULL);--defecto dos decimales


            v_precio_unitario_mb= param.f_convertir_moneda(
                            v_id_moneda,
                            NULL,   --por defecto moenda base
                            v_parametros.precio_unitario,
                            v_fecha_soli,
                            'O',-- tipo oficial, venta, compra
                             NULL);

			--Sentencia de la modificacion
			update adq.tsolicitud_det set
			id_centro_costo = v_parametros.id_centro_costo,
			descripcion = v_parametros.descripcion,
			precio_unitario = v_parametros.precio_unitario,
			id_solicitud = v_parametros.id_solicitud,
			id_partida = v_id_partida,
			id_orden_trabajo = v_parametros.id_orden_trabajo,
			precio_sg = v_parametros.precio_sg,
            precio_ga = v_parametros.precio_ga,
            precio_ga_mb=v_monto_ga_mb,
            precio_sg_mb=v_monto_sg_mb,
			id_concepto_ingas = v_parametros.id_concepto_ingas,
			id_cuenta = v_id_cuenta,
			precio_total = v_parametros.precio_total,
			cantidad = v_parametros.cantidad_sol,
			id_auxiliar = v_id_auxiliar,
            precio_unitario_mb=v_precio_unitario_mb,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario
			where id_solicitud_det=v_parametros.id_solicitud_det;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_det',v_parametros.id_solicitud_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ADQ_SOLD_ELI'
 	#DESCRIPCION:	Eliminacion de detalles de la solicitud
 	#AUTOR:		rac (kplian)
 	#FECHA:		05-03-2013 01:28:10
	***********************************/

	elsif(p_transaccion='ADQ_SOLD_ELI')then

		begin
            -- #4 validamos si el detalle de la solicitud fue consolidada por una presolicitud y si esta esta en finalizado
            SELECT
                presd.id_presolicitud_det,
                pres.estado,
                pres.nro_tramite
                into 
                v_record_presolicitud_det
            FROM adq.tpresolicitud_det presd
            left join adq.tpresolicitud pres on pres.id_presolicitud = presd.id_presolicitud
            WHERE presd.id_solicitud_det = v_parametros.id_solicitud_det;
            IF v_record_presolicitud_det.estado = 'finalizado' THEN
                RAISE EXCEPTION 'No puede Eliminar El detalle de la solicitud la presolicitud % asociada a este detalle esta en estado de Finalizado',v_record_presolicitud_det.nro_tramite;
            END IF;

            --Sentencia de la eliminacion

            --delete from adq.tsolicitud_det
            --where id_solicitud_det=v_parametros.id_solicitud_det;
            update adq.tsolicitud_det set
            estado_reg = 'inactivo',
            id_usuario_mod = p_id_usuario,
            fecha_mod = now()
            where id_solicitud_det=v_parametros.id_solicitud_det;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle de solicitud inactivado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_solicitud_det',v_parametros.id_solicitud_det::varchar);

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