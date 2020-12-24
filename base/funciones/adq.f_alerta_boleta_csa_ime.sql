--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_alerta_boleta_csa_ime (
)
    RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:
 FUNCION:
 DESCRIPCION: Envia correos segun configuracion Estado
 AUTOR:
 FECHA:
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
     ISSUE            FECHA            AUTHOR                     DESCRIPCION
    #143            29/05/2020      EGS                     Creacion
***************************************************************************/

DECLARE

    v_parametros               record;
    v_resp                    varchar;
    v_nombre_funcion        text;

    v_acceso_directo        varchar;
    v_clase                 varchar;
    v_parametros_ad         varchar;
    v_tipo_noti             varchar;
    v_titulo                varchar;
    v_id_alarma             integer;
    v_descripcion_correo    varchar;
    v_record                record;
    v_fecha_now             date;
    v_consulta_dia          varchar;
    v_dia_semana            integer;
    v_dia_feriado           integer;
    v_dias_transcurridos    integer;
    v_dias_restantes        integer;
    v_array                 INTEGER[];
    v_tamano                integer;
    v_i                        integer;
    v_envio                 BOOLEAN;
    v_hora                  integer;
    v_minuto                integer;
    v_hora_actual           integer;
    v_minuto_actual         integer;
    v_tiempo_restante       time;
    v_consulta_hora         varchar;
    v_incremento_fecha      date;
    v_valor_incremento      varchar;
    v_domingo               INTEGER = 0;
    v_sabado                INTEGER = 6;
    v_cant_dias             numeric=0;
    v_dias_habiles          integer;
    v_fecha_aux             date;
    v_fecha_fin             date;
    v_pais_base             VARCHAR;
    v_id_lugar              integer;
    p_id_lugar              integer;
    v_dia                   integer;
    p_id_usuario            integer = 1;
    v_hrs_restantes          time;
    v_array_hrs             varchar[];
    v_existe                integer;
    v_dias_envio            varchar;
    v_dias_consecutivo      integer;
    v_habilitado            VARCHAR;
    v_id_tipo_envio_correo   integer;
    v_copia                 record;
    v_fecha_limite          date;
    v_dias_vencimiento      integer;
    v_year                  varchar;
    v_month                 varchar;
    v_day                   varchar;
    v_consulta              varchar;
    v_cargo                 varchar;
    v_id_funcionario        integer;
    v_year_ini              varchar;
    v_month_ini             varchar;
    v_day_ini               varchar;
    v_fecha_inicio          date;
    v_fecha_accion          date;
    v_year_acc              varchar;
    v_month_acc             varchar;
    v_day_acc               varchar;
    v_fecha_acc             varchar;


BEGIN

    v_nombre_funcion = 'adq.f_alerta_boleta_csa_ime';

    begin
        SELECT
            tc.id_tipo_envio_correo,
            tc.dias_envio,
            tc.dias_consecutivo,
            tc.habilitado,
            tc.dias_vencimiento
        into
            v_id_tipo_envio_correo,
            v_dias_envio,
            v_dias_consecutivo,
            v_habilitado,
            v_dias_vencimiento
        FROM param.ttipo_envio_correo tc
        WHERE tc.codigo = 'BCSA';

        IF v_habilitado = 'si' THEN

            FOR  v_record IN(
                with diasR (idboleta,
                            diasRestantes)as(
                    SELECT
                        b.idboleta,
                        (b.fechafin::date - now()::date)::integer AS diasRestantes
                    FROM sql_server.boleta b
                )
                SELECT
                    b.idboleta,
                    dr.diasRestantes,
                    b.fechafin::date,
                    dg.correo,
                    b.idboleta,
                    b.nrodoc,
                    b.fechaaccion,
                    b.fechainicio,
                    b.fechafin,
                    convert_from(btd.tipodocumento, 'LATIN1'::name)::character varying as tipodocumento,
                    convert_from(b.otorgante, 'LATIN1'::name)::character varying as otorgante,
                    convert_from(b.paragarantizar, 'LATIN1'::name)::character varying as paragarantizar,
                    COALESCE(dgi.Primer_Nombre,'')||' '||COALESCE(dgi.Apellido_P,'') AS gestor,
                    i.Cd_empleado_gestor::varchar,
                    b.estado
                FROM sql_server.boleta b
                         JOIN sql_server.datosgenerales dg ON dg.cd_empleado = b.codresponsable
                         JOIN sql_server.boletatipodoc btd ON btd.idTipoDoc = b.idTipoDoc
                         LEFT JOIN sql_server.invitacion i ON i.IDInvitacion=  b.IDInvitacion
                         LEFT JOIN sql_server.datosgenerales dgi ON dgi.Cd_Empleado = i.Cd_empleado_gestor::varchar
                         LEFT JOIN diasR dr on dr.idboleta = b.idboleta
                WHERE
                        diasRestantes <= 30 and
                        b.estado::INTEGER in (1,2)
                ORDER BY diasRestantes DESC

            )LOOP
                    v_fecha_inicio = v_record.fechainicio ;
                    v_fecha_limite = v_record.fechafin ;
                    v_dias_restantes = v_record.diasRestantes ;
                    v_existe = 0;
                    v_envio = false;

                    IF v_fecha_limite is null THEN
                        v_fecha_limite = NOW();
                    END IF;
                    v_consulta = 'SELECT
                                    date_part(''year'', '||COALESCE(''''||v_fecha_limite::varchar||'''','')||'::date) as year,
                                    to_char(date_part(''month'','||COALESCE(''''||v_fecha_limite::varchar||'''','')||'::date),''fm000'') as month,
                                    to_char(date_part(''day'', '||COALESCE(''''||v_fecha_limite::varchar||'''','')||'::date), ''fm000'') as day
                                    ';
                    execute(v_consulta) into v_year,v_month,v_day ;

                    v_consulta = 'SELECT
                                    date_part(''year'', '||COALESCE(''''||v_fecha_inicio::varchar||'''','')||'::date) as year,
                                    to_char(date_part(''month'','||COALESCE(''''||v_fecha_inicio::varchar||'''','')||'::date),''fm000'') as month,
                                    to_char(date_part(''day'', '||COALESCE(''''||v_fecha_inicio::varchar||'''','')||'::date), ''fm000'') as day
                                    ';
                    execute(v_consulta) into v_year_ini,v_month_ini,v_day_ini ;




                    --recuperamos que dias se enviaran las alertas
                    v_array = string_to_array(v_dias_envio,',');
                    v_tamano:=array_upper(v_array,1);

                    --cuando se envia los dias configurados
                    For i in 1..(v_tamano) loop

                            v_dia = v_array[i]::integer;
                            IF (v_dia = v_dias_restantes) THEN

                                v_envio = true;
                            END IF;

                            v_descripcion_correo ='La <b>'||v_record.tipodocumento::VARCHAR||'</b>, del <b>'||v_record.otorgante::VARCHAR||'</b> emitida por <b>'||v_record.otorgante::VARCHAR||'</b> el <b>'||SUBSTRING(v_day_ini,length(v_day_ini)-2+1,2)||'/'||SUBSTRING(v_month_ini,length(v_month_ini)-2+1,2)||'/'||v_year_ini||'</b>, para garantizar: <b>'||v_record.paragarantizar::VARCHAR||'</b>. Tiene fecha de vencimiento el: <b>'||SUBSTRING(v_day,length(v_day)-2+1,2)||'/'||SUBSTRING(v_month,length(v_month)-2+1,2)||'/'||v_year||'</b> (<b>'||v_record.diasrestantes::VARCHAR||'</b> a partir de hoy).</br>Agradeceremos comunicar si procederemos a solicitar su renovación u otra instrucción que consideren conveniente.</br>Los datos adicionales estan en siguiente enlace <a href="http://172.18.78.11/csa/index.php/boleta/formulario/'||v_record.idboleta::VARCHAR||'">Boleta - '||v_record.nrodoc::VARCHAR||'</a> o ponerse en contacto con la Unidad de Aprovisionamientos y Almacenes.</br>Cordiales Saludos';

                        End loop;

                    --cuando se configura cada dia desde uno determinado para cumplir el tiempo limite

                    IF v_dias_consecutivo is not null THEN

                        IF v_dias_restantes::INTEGER <= v_dias_consecutivo::integer and v_dias_restantes::integer >= 0 THEN
                            v_envio = true;

                            v_descripcion_correo ='La <b>'||v_record.tipodocumento::VARCHAR||'</b>, del <b>'||v_record.otorgante::VARCHAR||'</b> emitida por <b>'||v_record.otorgante::VARCHAR||'</b> el <b>'||SUBSTRING(v_day_ini,length(v_day_ini)-2+1,2)||'/'||SUBSTRING(v_month_ini,length(v_month_ini)-2+1,2)||'/'||v_year_ini||'</b>, para garantizar: <b>'||v_record.paragarantizar::VARCHAR||'</b>. Tiene fecha de vencimiento el: <b>'||SUBSTRING(v_day,length(v_day)-2+1,2)||'/'||SUBSTRING(v_month,length(v_month)-2+1,2)||'/'||v_year||'</b> (<b>'||v_record.diasrestantes::VARCHAR||'</b> a partir de hoy).</br>Agradeceremos comunicar si procederemos a solicitar su renovación u otra instrucción que consideren conveniente.</br>Los datos adicionales estan en siguiente enlace <a href="http://172.18.78.11/csa/index.php/boleta/formulario/'||v_record.idboleta::VARCHAR||'">Boleta - '||v_record.nrodoc::VARCHAR||'</a> o ponerse en contacto con la Unidad de Aprovisionamientos y Almacenes.</br>Cordiales Saludos';

                        END IF;
                    END IF;

                    --cuando ya paso el tiempo limite
                    IF v_dias_vencimiento is not null  THEN
                        IF v_dias_restantes < 0 and v_dias_vencimiento >= abs(v_dias_restantes) THEN

                            v_envio = true;

                            v_descripcion_correo ='La <b>'||v_record.tipodocumento::VARCHAR||'</b>, del <b>'||v_record.otorgante::VARCHAR||'</b> emitida por <b>'||v_record.otorgante::VARCHAR||'</b> el <b>'||SUBSTRING(v_day_ini,length(v_day_ini)-2+1,2)||'/'||SUBSTRING(v_month_ini,length(v_month_ini)-2+1,2)||'/'||v_year_ini||'</b>, para garantizar: <b>'||v_record.paragarantizar::VARCHAR||'</b>. Tiene fecha de vencimiento el: <b>'||SUBSTRING(v_day,length(v_day)-2+1,2)||'/'||SUBSTRING(v_month,length(v_month)-2+1,2)||'/'||v_year||'</b> (<b>'||v_record.diasrestantes::VARCHAR||'</b> a partir de hoy).</br>Agradeceremos comunicar si procederemos a solicitar su renovación u otra instrucción que consideren conveniente.</br>Los datos adicionales estan en siguiente enlace <a href="http://172.18.78.11/csa/index.php/boleta/formulario/'||v_record.idboleta::VARCHAR||'">Boleta - '||v_record.nrodoc::VARCHAR||'</a> o ponerse en contacto con la Unidad de Aprovisionamientos y Almacenes.</br>Cordiales Saludos';

                        END IF;
                    END IF;

                    IF v_envio = true THEN

                        SELECT
                            f.id_funcionario
                        INTO
                            v_id_funcionario
                        FROM orga.tfuncionario f
                        WHERE lower(replace(f.email_empresa,' ','')) = lower(replace(v_record.correo,' ',''));

                        v_acceso_directo = '';
                        v_clase = '';
                        v_parametros_ad = '';
                        v_tipo_noti = 'notificacion';

                        IF v_record.fechaaccion is not null THEN
                            v_fecha_accion = v_record.fechaaccion ;
                            v_consulta = 'SELECT
                                    date_part(''year'', '||COALESCE(''''||v_fecha_accion::varchar||'''','')||'::date) as year,
                                    to_char(date_part(''month'','||COALESCE(''''||v_fecha_accion::varchar||'''','')||'::date),''fm000'') as month,
                                    to_char(date_part(''day'', '||COALESCE(''''||v_fecha_accion::varchar||'''','')||'::date), ''fm000'') as day
                                    ';
                            execute(v_consulta) into v_year_acc,v_month_acc,v_day_acc ;


                            v_fecha_acc = 'EL '||SUBSTRING(v_day_acc,length(v_day_acc)-2+1,2)||'/'||SUBSTRING(v_month_acc,length(v_month_acc)-2+1,2)||'/'||v_year_acc||'';
                        END IF;

                        v_titulo = 'BOLETA POR VENCER-GESTOR '||COALESCE(v_record.gestor,'')||'- INICIO DE PROCESO DE CIERRE '||COALESCE(v_fecha_acc::VARCHAR,'')||'';
                        --v_descripcion_correo =translate(v_descripcion_correo,'áéíóúÁÉÍÓÚäëïöüÄËÏÖÜ','aeiouAEIOUaeiouAEIOU');
                        --envio responsable
                        v_id_alarma = param.f_inserta_alarma(
                                v_id_funcionario,
                                v_descripcion_correo,--par_descripcion
                                v_acceso_directo,--acceso directo
                                now()::date,--par_fecha: Indica la fecha de vencimiento de la alarma
                                v_tipo_noti, --notificacion
                                v_titulo,  --asunto
                                p_id_usuario,
                                v_clase, --clase
                                v_titulo,--titulo
                                v_parametros_ad,--par_parametros varchar,   parametros a mandar a la interface de acceso directo
                                null, --usuario a quien va dirigida la alarma
                                v_titulo,--titulo correo
                                v_record.correo, --correo funcionario
                                null,--#9
                                null,
                                null
                            );

                        --enviamos las copias del correo a funcionarios
                        FOR v_copia IN(
                            SELECT
                                cor.id_funcionario,
                                cor.correo,
                                f.email_empresa
                            FROM param.tagrupacion_correo cor
                                     left join orga.vfuncionario fun on fun.id_funcionario = cor.id_funcionario
                                     left join orga.tfuncionario f on f.id_funcionario = cor.id_funcionario
                            Where cor.id_tipo_envio_correo = v_id_tipo_envio_correo::integer
                              and cor.id_depto is null
                        )LOOP

                                v_id_alarma = param.f_inserta_alarma(
                                        v_copia.id_funcionario,
                                        v_descripcion_correo,--par_descripcion
                                        v_acceso_directo,--acceso directo
                                        now()::date,--par_fecha: Indica la fecha de vencimiento de la alarma
                                        v_tipo_noti, --notificacion
                                        v_titulo,  --asunto
                                        p_id_usuario,
                                        v_clase, --clase
                                        v_titulo,--titulo
                                        v_parametros_ad,--par_parametros varchar,   parametros a mandar a la interface de acceso directo
                                        null, --usuario a quien va dirigida la alarma
                                        v_titulo,--titulo correo
                                        v_copia.email_empresa, --correo funcionario
                                        null,--#9
                                        null,
                                        null
                                    );




                            END LOOP;


                        --envio de correo a depto
                        SELECT
                            cor.cargo
                        INTO
                            v_cargo
                        FROM param.tagrupacion_correo cor
                        Where cor.id_tipo_envio_correo = v_id_tipo_envio_correo::integer
                          and cor.id_depto is not null;

                        IF v_cargo is not null THEN
                            v_cargo = REPLACE(v_cargo,',',''',''');
                            v_cargo = ''''||v_cargo||'''';
                        ELSE
                            v_cargo = '''''';
                        END IF;
                        v_consulta='SELECT
                          f.id_funcionario,
                          cor.correo,
                          f.email_empresa
                        FROM param.tagrupacion_correo cor
                        left JOIN param.tdepto_usuario depusu on depusu.id_depto = cor.id_depto
                        left join segu.tusuario usu on usu.id_usuario = depusu.id_usuario
                        left join orga.tfuncionario f on f.id_persona = usu.id_persona
                        left join orga.vfuncionario fun on fun.id_funcionario = f.id_funcionario
                        Where cor.id_tipo_envio_correo = '||v_id_tipo_envio_correo::integer||'
                        and depusu.cargo in ('||v_cargo||')
                        and cor.id_depto is not null';

                        FOR v_copia IN EXECUTE(
                            v_consulta
                            )LOOP

                                v_id_alarma = param.f_inserta_alarma(
                                        v_copia.id_funcionario,
                                        v_descripcion_correo,--par_descripcion
                                        v_acceso_directo,--acceso directo
                                        now()::date,--par_fecha: Indica la fecha de vencimiento de la alarma
                                        v_tipo_noti, --notificacion
                                        v_titulo,  --asunto
                                        p_id_usuario,
                                        v_clase, --clase
                                        v_titulo,--titulo
                                        v_parametros_ad,--par_parametros varchar,   parametros a mandar a la interface de acceso directo
                                        null, --usuario a quien va dirigida la alarma
                                        v_titulo,--titulo correo
                                        v_copia.email_empresa, --correo funcionario
                                        null,
                                        null,
                                        null
                                    );




                            END LOOP;

                    END IF;

                END LOOP;




        ELSE
            v_resp = 'no esta habilitado la opcion de desactivado automatico';
        END IF;
        v_resp='exito';
        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje',v_resp);

        --Devuelve la respuesta
        return v_resp;


    end;

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