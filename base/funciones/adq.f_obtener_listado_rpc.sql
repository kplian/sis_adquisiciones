CREATE OR REPLACE FUNCTION adq.f_obtener_listado_rpc (
  p_id_usuario integer,
  p_id_uo integer,
  p_fecha date,
  p_monto numeric,
  p_id_categoria_compra integer,
  p_tipo varchar = 'obtener'::character varying
)
  RETURNS SETOF record AS
  $body$
  DECLARE

    v_sw_aprobador boolean;

    v_consulta varchar;

    v_registros record;

    v_id_uo integer;




    v_fun_array integer[];

    v_i integer;

    v_resp varchar;
    v_nombre_funcion varchar;
    v_desc_funcionario varchar;
    v_id_cargo_identificado  integer;
    v_cargo_nombre           varchar;

  BEGIN




    /*
    0)   crea una tabla temporal con los resultados


    1)  busca si algun rpc_uo satisface los requerimiento
    
    2)  IF p_tipo = obtener
    
      2.1) si no hay ninguno bota un error indicado que no existe una configuracion con este parametros

      2.2) si existe mas de uno bota un error indicando que solo puede haber un rpc posible
      
    
    3) otener los  funcionarios correpondiente al cargo segun la fecha indicada
    
 		3.1)insertar  en tabla temporal


   
       */


    v_sw_aprobador = false;

    v_nombre_funcion = 'adq.f_obtener_listado_rpc';

    -- crea tabla temporal

           --Creación de tabla temporal
    v_consulta = '
        DROP TABLE IF EXISTS tt_rpc_'||p_id_usuario||';
        create temp table tt_rpc_'||p_id_usuario||'(
                 id_rpc   integer,
                 id_rpc_uo integer,
			     id_funcionario integer,
			     desc_funcionario text,
                 fecha_ini date,
                 fecha_fin date,
                 monto_min numeric,
                 monto_max numeric,
                 id_cargo integer,
                 id_cargo_ai integer,
                 ai_habilitado varchar
			)on commit drop;';

    execute(v_consulta);



    --  buscamos con la uo  especifica y categoria de compras especificas para la fecha y monto indicado
    FOR v_registros in(
      SELECT
        ruo.id_rpc,
        ruo.id_rpc_uo,
        ruo.fecha_ini,
        ruo.fecha_fin,
        ruo.monto_min,
        ruo.monto_max,
        rpc.id_cargo,
        rpc.id_cargo_ai,
        rpc.ai_habilitado

      FROM adq.trpc_uo ruo
        inner join adq.trpc rpc on rpc.id_rpc = ruo.id_rpc
      WHERE
        ruo.estado_reg = 'activo'
        and  ruo.id_uo = p_id_uo
        and  ruo.id_categoria_compra = p_id_categoria_compra
        and ((ruo.fecha_ini <= p_fecha  and ruo.fecha_fin >=p_fecha )
             or
             (ruo.fecha_ini <= p_fecha and ruo.fecha_fin is null ))
        and ((ruo.monto_min <=  p_monto and ruo.monto_max >= p_monto )
             or
             ( ruo.monto_min <= p_monto and ruo.monto_max is null ))
    )


    LOOP


      IF v_registros.ai_habilitado = 'si' THEN
        v_id_cargo_identificado = v_registros.id_cargo_ai;
      ELSE
        v_id_cargo_identificado = v_registros.id_cargo;

      END IF;
      --jrr(27/10/2016):Se cambia por la fecha actual para q obtenga el rpc a la fecha en q se finalzia la solicitud
      v_fun_array =  orga.f_get_funcionarios_x_cargo(v_id_cargo_identificado, now()::date);



      IF v_fun_array is NULL  and p_tipo = 'obtener' THEN

        select
          c.nombre into v_cargo_nombre
        from orga.tcargo c
        where  c.id_cargo = v_id_cargo_identificado;

        raise exception 'No se encontraron funcionarios par el  cargo, revise la asignacion del cargo (%) en el organigrama', v_cargo_nombre;

      END IF;



      --recorremos el array de funcionarios
      FOR v_i IN 1 .. array_upper(v_fun_array, 1)  LOOP


        select
          fun.desc_funcionario1
        into
          v_desc_funcionario
        from orga.vfuncionario fun where fun.id_funcionario = v_fun_array[v_i];

        v_consulta=  'INSERT INTO  tt_rpc_'||p_id_usuario||'(
                                         id_rpc,
                                         id_rpc_uo,
                                         id_funcionario,
                                         desc_funcionario,
                                         fecha_ini,
                                         fecha_fin,
                                         monto_min,
                                         monto_max,
                                         id_cargo,
                                         id_cargo_ai,
                                         ai_habilitado
                                      )
                                      VALUES
                                      (
                                      '||COALESCE(v_registros.id_rpc::varchar,'NULL')||',
                                      '||COALESCE(v_registros.id_rpc_uo::varchar,'NULL')||',
                                      '||COALESCE(v_fun_array[v_i]::varchar,'NULL')||',
                                      '''||COALESCE(v_desc_funcionario,'---')||''',
                                      '||COALESCE(''''||v_registros.fecha_ini::VARCHAR||'''','NULL')||',
                                      '||COALESCE(''''||v_registros.fecha_fin::varchar||'''','NULL')||',
                                      '||COALESCE(v_registros.monto_min::varchar,'NULL')||',
                                      '||COALESCE(v_registros.monto_max::varchar,'NULL')||',
                                      '||COALESCE(v_registros.id_cargo::varchar,'NULL')||',
                                      '||COALESCE(v_registros.id_cargo_ai::varchar,'NULL')||',
                                      '''||COALESCE(v_registros.ai_habilitado,'---')||'''
                                      );';

        --raise exception 'xxxx %',v_consulta;
        execute(v_consulta);
      END LOOP;

    END LOOP;


    --consulta de la tabla temporal,
    v_consulta=  'SELECT
                 id_rpc,
                 id_rpc_uo,
                 id_funcionario,
                 desc_funcionario,
                 fecha_ini,
                 fecha_fin,
                 monto_min,
                 monto_max,
                 id_cargo,
                 id_cargo_ai,
                 ai_habilitado 
              FROM tt_rpc_'||p_id_usuario;




    FOR v_registros in execute (v_consulta) LOOP
      RETURN NEXT v_registros;
    END LOOP;



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
COST 100 ROWS 1000;