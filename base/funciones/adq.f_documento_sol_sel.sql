--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_documento_sol_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:   Adquisiciones
 FUNCION:     adq.f_documento_sol_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'adq.tdocumento_sol'
 AUTOR:      (admin)
 FECHA:         08-02-2013 19:01:00
 COMENTARIOS: 
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION: 
 AUTOR:     
 FECHA:   
***************************************************************************/

DECLARE

  v_consulta        varchar;
  v_parametros      record;
  v_nombre_funcion    text;
  v_resp        varchar;
          
BEGIN

  v_nombre_funcion = 'adq.f_documento_sol_sel';
    v_parametros = pxp.f_get_record(p_tabla);

  /*********************************    
  #TRANSACCION:  'ADQ_DOCSOL_SEL'
  #DESCRIPCION: Consulta de datos
  #AUTOR:   admin 
  #FECHA:   08-02-2013 19:01:00
  ***********************************/
  
  if(p_transaccion='ADQ_DOCSOL_SEL')then            
      begin
        --Sentencia de la consulta
              v_consulta:='SELECT docsol.id_documento_sol,
                                          docsol.id_solicitud,
                                          docsol.id_categoria_compra,
                                          docsol.nombre_doc,
                                          docsol.nombre_arch_doc,                                         
                                          docsol.nombre_tipo_doc,                                          
                                          docsol.chequeado,
                                          docsol.estado_reg,
                                          docsol.id_usuario_reg,
                                          docsol.fecha_reg,
                                          docsol.id_usuario_mod,
                                          docsol.fecha_mod,
                                          usu1.cuenta as usr_reg,
                                          usu2.cuenta as usr_mod                                      
                                          from adq.tdocumento_sol docsol
                                          inner join segu.tusuario usu1 on usu1.id_usuario = docsol.id_usuario_reg
                                          left join segu.tusuario usu2 on usu2.id_usuario = docsol.id_usuario_mod 
                                          
                                          where  ';
      
      --Definicion de la respuesta
      v_consulta:=v_consulta||v_parametros.filtro;
      v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

      --Devuelve la respuesta
      return v_consulta;
            
    end;
    
  /*********************************    
  #TRANSACCION:  'ADQ_DOCSOLAR_SEL'
  #DESCRIPCION: Consulta de datos
  #AUTOR:   admin 
  #FECHA:   08-02-2013 19:01:00
  ***********************************/
  
  elseif(p_transaccion='ADQ_DOCSOLAR_SEL')then            
      begin
     
        --Sentencia de la consulta
              v_consulta:='SELECT docsol.id_documento_sol,
                                          docsol.id_solicitud,
                                          docsol.id_categoria_compra,
                                          docsol.nombre_doc,
                                          docsol.nombre_arch_doc,
                                          docsol.archivo,
                                          docsol.nombre_tipo_doc,
                                          docsol.extension,
                                          docsol.chequeado,
                                          docsol.estado_reg,
                                          docsol.id_usuario_reg,
                                          docsol.fecha_reg,
                                          docsol.id_usuario_mod,
                                          docsol.fecha_mod,
                                          usu1.cuenta as usr_reg,
                                          usu2.cuenta as usr_mod ,
                                          cc.nombre as desc_categoria_compra,
                                          pro.id_proveedor, 
                                          pro.desc_proveedor                                         
                                          from adq.tdocumento_sol docsol
                                          inner join segu.tusuario usu1 on usu1.id_usuario = docsol.id_usuario_reg
                                          left join segu.tusuario usu2 on usu2.id_usuario = docsol.id_usuario_mod
                                          left join adq.tcategoria_compra cc ON cc.id_categoria_compra = docsol.id_categoria_compra
                                          left join param.vproveedor pro on pro.id_proveedor = docsol.id_proveedor 
             where  ';
      
      --Definicion de la respuesta
      v_consulta:=v_consulta||v_parametros.filtro;
      v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

      --Devuelve la respuesta
      return v_consulta;
            
    end;

  /*********************************    
  #TRANSACCION:  'ADQ_DOCSOL_CONT'
  #DESCRIPCION: Conteo de registros
  #AUTOR:   admin 
  #FECHA:   08-02-2013 19:01:00
  ***********************************/

  elsif(p_transaccion='ADQ_DOCSOL_CONT')then

    begin
      --Sentencia de la consulta de conteo de registros
      v_consulta:='select count(id_documento_sol)
                    from adq.tdocumento_sol docsol
                    inner join segu.tusuario usu1 on usu1.id_usuario = docsol.id_usuario_reg
                    left join segu.tusuario usu2 on usu2.id_usuario = docsol.id_usuario_mod 
                  where ';
      
      --Definicion de la respuesta        
      v_consulta:=v_consulta||v_parametros.filtro;

      --Devuelve la respuesta
      return v_consulta;

    end;
    
  /*********************************    
    #TRANSACCION:  'ADQ_DOCSOLAR_CONT'
    #DESCRIPCION: Conteo de registros
    #AUTOR:   admin 
    #FECHA:   08-02-2013 19:01:00
    ***********************************/

  elsif(p_transaccion='ADQ_DOCSOLAR_CONT')then

    begin
      --Sentencia de la consulta de conteo de registros
      v_consulta:='select count(id_documento_sol)
                                from adq.tdocumento_sol docsol
                                inner join segu.tusuario usu1 on usu1.id_usuario = docsol.id_usuario_reg
                                left join segu.tusuario usu2 on usu2.id_usuario = docsol.id_usuario_mod
                                left join adq.tcategoria_compra cc ON cc.id_categoria_compra = docsol.id_categoria_compra                       
                                left join param.vproveedor pro on pro.id_proveedor = docsol.id_proveedor 
            
               where ';
      
      --Definicion de la respuesta        
      v_consulta:=v_consulta||v_parametros.filtro;

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