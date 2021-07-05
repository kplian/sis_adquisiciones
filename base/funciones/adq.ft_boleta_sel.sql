CREATE OR REPLACE FUNCTION adq.ft_boleta_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
    /**************************************************************************
     SISTEMA:        Adquisiciones
     FUNCION:         adq.ft_boleta_sel
     DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'adq.tboleta'
     AUTOR:          (ymedina)
     FECHA:            25-03-2021 13:42:09
     COMENTARIOS:    
    ***************************************************************************
     HISTORIAL DE MODIFICACIONES:
     #ISSUE                FECHA                AUTOR                DESCRIPCION
     #0                25-03-2021 13:42:09    ymedina             Creacion    
     #
     ***************************************************************************/
    
    DECLARE
    
    v_consulta VARCHAR;
    v_parametros     RECORD;
    v_nombre_funcion TEXT;
    v_resp           VARCHAR;
    v_filtro         varchar;
BEGIN

    v_nombre_funcion = 'adq.ft_boleta_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'ADQ_BOLG_SEL'
     #DESCRIPCION:    Consulta de datos boletas
     #AUTOR:        ymedina
     #FECHA:        25-03-2021 13:42:09
    ***********************************/

    IF (p_transaccion = 'ADQ_BOLG_SEL') THEN
    
        BEGIN
            --Sentencia de la consulta
            v_consulta := ' with 
 boletas(idboleta, diasRestantes, fechainicio, fechafin, estado, codresponsable, otorgante, nrodoc, fechaaccion, paragarantizar, idTipoDoc, IDInvitacion) as
                           (SELECT b.idboleta,
                                   (b.fechafin ::date - now() ::date) ::integer AS diasRestantes,
                                   b.fechainicio ::date,
                                   b.fechafin ::date,
                                   b.estado ::integer,
                                   b.codresponsable ::varchar,
                                   convert_from(b.otorgante, ''LATIN1'' ::name) ::character varying as otorgante,
								   convert_from(b.nrodoc::bytea, ''LATIN1'' ::name)::character varying as nrodoc,
                                   b.fechaaccion ::date,
                                   convert_from(b.paragarantizar, ''LATIN1'' ::name) ::character varying as paragarantizar,
                                   b.idTipoDoc ::integer,
                                   b.IDInvitacion ::integer
                              FROM sql_server.boleta b),
                          invitacion(IDInvitacion, Cd_empleado_gestor) as
                           (select i.IDInvitacion ::integer, i.Cd_empleado_gestor ::varchar
                              from sql_server.invitacion i),
                          tipoBoleta(idTipoDoc, tipodocumento) as
                           (select btd.idTipoDoc ::integer,
                                   convert_from(btd.tipodocumento, ''LATIN1'' ::name) ::character varying as tipodocumento
                              from sql_server.boletatipodoc btd),
                              datosgenerales(cd_empleado, completo) as
                             (SELECT dd.cd_empleado ::integer,
                                   (convert_from(dd.primer_nombre::bytea, ''LATIN1'' ::name) || '' '' ||
                                   convert_from(dd.segundo_nombre::bytea, ''LATIN1'' ::name) || '' '' ||
                                   convert_from(dd.apellido_p::bytea, ''LATIN1'' ::name) || '' '' ||
                                   convert_from(dd.apellido_m::bytea, ''LATIN1'' ::name))::varchar AS completo
                              FROM sql_server.datosgenerales dd)
                          SELECT b.idboleta,
                                 b.nrodoc,
                                 tb.tipodocumento,
                                 b.otorgante,
                                 case
                                     when b.diasRestantes < 0 then
                                      0
                                     else
                                      b.diasRestantes
                                 end as diasRestantes,
                                 b.fechainicio ::date,
                                 b.fechafin ::date,
                                 b.estado,
                                 case
                                     when b.estado = 1 then
                                      ''Abierto''
                                     when b.estado = 2 then
                                      ''Por Vencer''
                                     when b.estado = 3 then
                                      ''Vencido''
                                     when b.estado = 4 then
                                      ''Cerrado''
                                     ELSE
                                      ''Sin Estado''
                                 end ::varchar as desc_estado,
                                 b.fechaaccion,
                                 b.paragarantizar,
                                 i.Cd_empleado_gestor ::varchar,
                                 (i.Cd_empleado_gestor::varchar || '' - '' || COALESCE(uu.completo::varchar,''''))::varchar AS gestor,
                                 b.codresponsable,
                                 u2.completo ::varchar as responsable
                            FROM boletas b
                            left join invitacion i ON i.IDInvitacion = b.IDInvitacion
                            left join tipoBoleta tb on tb.idTipoDoc = b.idTipoDoc
                            left join datosgenerales uu on uu.cd_empleado::varchar = i.Cd_empleado_gestor::varchar
                            left join datosgenerales u2 on u2.cd_empleado::varchar = b.codresponsable ::varchar
                           WHERE ';
        
            --Definicion de la respuesta
            v_consulta := v_consulta || v_parametros.filtro;
            v_consulta := v_consulta || ' order by ' || v_parametros.ordenacion || ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;
        
            --Devuelve la respuesta
            RETURN v_consulta;
        
        END;
    
    /*********************************    
     #TRANSACCION:  'ADQ_BOLG_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        ymedina
     #FECHA:        25-03-2021 13:42:09
    ***********************************/
    ELSIF (p_transaccion = 'ADQ_BOLG_CONT') THEN
    
        BEGIN
            --Sentencia de la consulta de conteo de registros
            v_consulta := ' with 
 boletas(idboleta, diasRestantes, fechainicio, fechafin, estado, codresponsable, otorgante, nrodoc, fechaaccion, paragarantizar, idTipoDoc, IDInvitacion) as
                           (SELECT b.idboleta,
                                   (b.fechafin ::date - now() ::date) ::integer AS diasRestantes,
                                   b.fechainicio ::date,
                                   b.fechafin ::date,
                                   b.estado ::integer,
                                   b.codresponsable ::varchar,
                                   convert_from(b.otorgante, ''LATIN1'' ::name) ::character varying as otorgante,
								   convert_from(b.nrodoc::bytea, ''LATIN1'' ::name)::character varying as nrodoc,
                                   b.fechaaccion ::date,
                                   convert_from(b.paragarantizar, ''LATIN1'' ::name) ::character varying as paragarantizar,
                                   b.idTipoDoc ::integer,
                                   b.IDInvitacion ::integer
                              FROM sql_server.boleta b),
                          invitacion(IDInvitacion, Cd_empleado_gestor) as
                           (select i.IDInvitacion ::integer, i.Cd_empleado_gestor ::varchar
                              from sql_server.invitacion i),
                          tipoBoleta(idTipoDoc, tipodocumento) as
                           (select btd.idTipoDoc ::integer,
                                   convert_from(btd.tipodocumento, ''LATIN1'' ::name) ::character varying as tipodocumento
                              from sql_server.boletatipodoc btd),
                              datosgenerales(cd_empleado, completo) as
                             (SELECT dd.cd_empleado ::integer,
                                   (convert_from(dd.primer_nombre::bytea, ''LATIN1'' ::name) || '' '' ||
                                   convert_from(dd.segundo_nombre::bytea, ''LATIN1'' ::name) || '' '' ||
                                   convert_from(dd.apellido_p::bytea, ''LATIN1'' ::name) || '' '' ||
                                   convert_from(dd.apellido_m::bytea, ''LATIN1'' ::name))::varchar AS completo
                              FROM sql_server.datosgenerales dd)
                          SELECT count(*)
                            FROM boletas b
                            left join invitacion i ON i.IDInvitacion = b.IDInvitacion
                            left join tipoBoleta tb on tb.idTipoDoc = b.idTipoDoc
                            left join datosgenerales uu on uu.cd_empleado::varchar = i.Cd_empleado_gestor::varchar
                            left join datosgenerales u2 on u2.cd_empleado::varchar = b.codresponsable ::varchar
                           WHERE     ';
        
            --Definicion de la respuesta            
            v_consulta := v_consulta || v_parametros.filtro;
        
            --Devuelve la respuesta
            RETURN v_consulta;
        
        END;
    
    /*******************************
     #TRANSACCION:  ADQ_PERSON_SEL
     #DESCRIPCION:  Selecciona Personas
     #AUTOR:    ymedina
     #FECHA:    25/08/20
    ***********************************/
    ELSIF (p_transaccion = 'ADQ_PERSON_SEL') then
        BEGIN
        
            v_consulta := 'with ges(cd_empleado, estado) as                             
                            (select g.cd_empleado::integer,
                                    g.estado::integer
                            from sql_server.gestor g),
                            usuarios(cd_empleado, completo) as
                             (SELECT dd.cd_empleado ::integer,
                                     (convert_from(dd.primer_nombre::bytea, ''LATIN1'' ::name) || '' '' ||
                                   convert_from(dd.segundo_nombre::bytea, ''LATIN1'' ::name) || '' '' ||
                                   convert_from(dd.apellido_p::bytea, ''LATIN1'' ::name) || '' '' ||
                                   convert_from(dd.apellido_m::bytea, ''LATIN1'' ::name))::varchar AS completo
                                FROM sql_server.datosgenerales dd)
                            select g.cd_empleado  ::integer as id_persona,
                            		u.completo::varchar as nom,
                                   (g.cd_empleado::integer  || '' - '' || COALESCE(u.completo::varchar, ''''))::varchar as nombre
                            from ges g
                            LEFT JOIN usuarios u on u.cd_empleado = g.cd_empleado
                             where ';
        
            v_consulta := v_consulta || v_parametros.filtro;
            
            v_consulta := v_consulta || ' order by ' || v_parametros.ordenacion || ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;
            
            return v_consulta;
        
        END;
    
    /*********************************
     #TRANSACCION:  'ADQ_PERSON_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        ymedina
     #FECHA:        15-07-2020 15:06:16
    ***********************************/
    ELSIF (p_transaccion = 'ADQ_PERSON_CONT') THEN
    
        BEGIN
        
            v_consulta := 'with ges(cd_empleado, estado) as                             
                            (select g.cd_empleado::integer,
                                    g.estado::integer
                            from sql_server.gestor g),
                            usuarios(cd_empleado, completo) as
                             (SELECT dd.cd_empleado ::integer,
                                     (convert_from(dd.primer_nombre::bytea, ''LATIN1'' ::name) || '' '' ||
                                   convert_from(dd.segundo_nombre::bytea, ''LATIN1'' ::name) || '' '' ||
                                   convert_from(dd.apellido_p::bytea, ''LATIN1'' ::name) || '' '' ||
                                   convert_from(dd.apellido_m::bytea, ''LATIN1'' ::name))::varchar AS completo
                                FROM sql_server.datosgenerales dd)
                            select count(*)
                            from ges g
                            LEFT JOIN usuarios u on u.cd_empleado = g.cd_empleado
                             where ';
            v_consulta := v_consulta || v_parametros.filtro;
            
            --Devuelve la respuesta
            RETURN v_consulta;
        
        END;
    
    /*******************************
     #TRANSACCION:  ADQ_PERRES_SEL
     #DESCRIPCION:  Selecciona Personas
     #AUTOR:    ymedina
     #FECHA:    25/08/20
    ***********************************/
    ELSIF (p_transaccion = 'ADQ_PERRES_SEL') then
        BEGIN
       
       		v_consulta := 'with usuarios(cd_empleado, completo) as
                           (SELECT dd.cd_empleado ::integer,
                                   (convert_from(dd.primer_nombre::bytea, ''LATIN1'' ::name) || '' '' ||
                                   convert_from(dd.segundo_nombre::bytea, ''LATIN1'' ::name) || '' '' ||
                                   convert_from(dd.apellido_p::bytea, ''LATIN1'' ::name) || '' '' ||
                                   convert_from(dd.apellido_m::bytea, ''LATIN1'' ::name))::varchar AS completo
                              FROM sql_server.datosgenerales dd
                              join sql_server.boleta b on b.codresponsable::varchar = dd.cd_empleado::varchar
                              )
                          SELECT distinct(pt.cd_empleado) ::integer as id_persona, vf.desc_funcionario1::varchar as nombre
                            FROM usuarios as pt
                            JOIN orga.vfuncionario vf on vf.codigo like concat(''%'', pt.cd_empleado ::varchar)
                           where vf.desc_funcionario1 is not null and ';
        	
            v_consulta := v_consulta || v_parametros.filtro;
            
            v_consulta := v_consulta || ' order by ' || v_parametros.ordenacion || ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;
            raise notice 'dd %', v_consulta;
            return v_consulta;
        
        END;
    
    /*********************************
     #TRANSACCION:  'ADQ_PERRES_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        ymedina
     #FECHA:        15-07-2020 15:06:16
    ***********************************/
    ELSIF (p_transaccion = 'ADQ_PERRES_CONT') THEN
    
        BEGIN
        
            v_consulta := ' with usuarios(cd_empleado, completo) as
                           (SELECT dd.cd_empleado ::integer,
                                   (convert_from(dd.primer_nombre::bytea, ''LATIN1'' ::name) || '' '' ||
                                   convert_from(dd.segundo_nombre::bytea, ''LATIN1'' ::name) || '' '' ||
                                   convert_from(dd.apellido_p::bytea, ''LATIN1'' ::name) || '' '' ||
                                   convert_from(dd.apellido_m::bytea, ''LATIN1'' ::name))::varchar AS completo
                              FROM sql_server.datosgenerales dd
                              join sql_server.boleta b on b.codresponsable::varchar = dd.cd_empleado::varchar
                              )
                          SELECT count(distinct(pt.cd_empleado)::integer)
                            FROM usuarios as pt
                            JOIN orga.vfuncionario vf on vf.codigo like concat(''%'', pt.cd_empleado ::varchar)
                           where vf.desc_funcionario1 is not null and ';
                           
            v_consulta := v_consulta || v_parametros.filtro;
            
            --Devuelve la respuesta
            RETURN v_consulta;
        
        END;
        
    /*******************************
     #TRANSACCION:  ADQ_BOTOR_SEL
     #DESCRIPCION:  Selecciona Personas
     #AUTOR:    YMR
     #FECHA:    25/08/20
    ***********************************/
    ELSIF (p_transaccion = 'ADQ_BOTOR_SEL') then
        BEGIN
        
            v_consulta := ' with banco(otorgante) as
                           (SELECT b.otorgante::varchar
                              FROM sql_server.boleta b)
                          SELECT DISTINCT(bb.otorgante::varchar)
                            FROM banco as bb
                           where bb.otorgante::varchar is not null
                           and bb.otorgante::varchar != '' '' 
                           and ';
            v_consulta := v_consulta || v_parametros.filtro;
        
            v_consulta := v_consulta || ' order by ' || v_parametros.ordenacion || ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;
            
            return v_consulta;
        
        END;
    
    /*********************************
     #TRANSACCION:  'ADQ_BOTOR_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        ymedina
     #FECHA:        15-07-2020 15:06:16
    ***********************************/
    ELSIF (p_transaccion = 'ADQ_BOTOR_CONT') THEN
        BEGIN
        
            v_consulta := ' with banco(otorgante) as
                           (SELECT b.otorgante::varchar
                              FROM sql_server.boleta b)
                          SELECT count(DISTINCT(bb.otorgante::varchar))
                            FROM banco as bb
                           where bb.otorgante::varchar is not null
                           and bb.otorgante::varchar != '' '' 
                           and ';
            v_consulta := v_consulta || v_parametros.filtro;
        
            --Devuelve la respuesta
            RETURN v_consulta;
        
        END;
    ELSE
    
        RAISE EXCEPTION 'Transaccion inexistente';
    
    END IF;

EXCEPTION

    WHEN OTHERS THEN
        v_resp = '';
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp, 'codigo_error', SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp,
                                    'procedimientos',
                                    v_nombre_funcion);
        RAISE EXCEPTION '%', v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100;