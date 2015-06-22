--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_documento_sol_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:   Adquisiciones
 FUNCION:     adq.f_documento_sol_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'adq.tdocumento_sol'
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

  v_nro_requerimiento     integer;
  v_parametros            record;
  v_id_requerimiento      integer;
  v_resp                varchar;
  v_nombre_funcion        text;
  v_mensaje_error         text;
  v_id_documento_sol  integer;
  
  v_id_proveedor integer;
          
BEGIN

    v_nombre_funcion = 'adq.f_documento_sol_ime';
    v_parametros = pxp.f_get_record(p_tabla);

  /*********************************    
  #TRANSACCION:  'ADQ_DOCSOL_INS'
  #DESCRIPCION: Insercion de registros
  #AUTOR:   admin 
  #FECHA:   08-02-2013 19:01:00
  ***********************************/

  if(p_transaccion='ADQ_DOCSOL_INS')then
          
        begin
        
        IF pxp.f_existe_parametro(p_tabla, 'id_proveedor') THEN
          v_id_proveedor =  v_parametros.id_proveedor;
        ELSE
          v_id_proveedor =  NULL;
        END IF;
        
        
        
        	if (v_parametros.id_solicitud is not null)then
            	select id_categoria_compra
                into v_parametros.id_categoria_compra
                from adq.tsolicitud s
                where s.id_solicitud = v_parametros.id_solicitud;
            end if;
          --Sentencia de la insercion
          insert into adq.tdocumento_sol(
      id_solicitud,
      id_categoria_compra,
      nombre_doc,
      nombre_arch_doc,
      nombre_tipo_doc,
      chequeado,
      estado_reg,
      id_usuario_reg,
      fecha_reg,
      id_usuario_mod,
      fecha_mod,
      id_proveedor
            ) values(
      v_parametros.id_solicitud,
      v_parametros.id_categoria_compra,
      v_parametros.nombre_doc,
      v_parametros.nombre_arch_doc,
      v_parametros.nombre_tipo_doc,
      v_parametros.chequeado,
      'activo',
      p_id_usuario,
      now(),
      null,
      null,
      v_id_proveedor
              
      )RETURNING id_documento_sol into v_id_documento_sol;
      
      --Definicion de la respuesta
      v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Documento de Solicitud almacenado(a) con exito (id_documento_sol'||v_id_documento_sol||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_documento_sol',v_id_documento_sol::varchar);

            --Devuelve la respuesta
            return v_resp;

    end;

  /*********************************    
  #TRANSACCION:  'ADQ_DOCSOL_MOD'
  #DESCRIPCION: Modificacion de registros
  #AUTOR:   admin 
  #FECHA:   08-02-2013 19:01:00
  ***********************************/

  elsif(p_transaccion='ADQ_DOCSOL_MOD')then

    begin  
     IF pxp.f_existe_parametro(p_tabla, 'id_proveedor') THEN
          v_id_proveedor =  v_parametros.id_proveedor;
     ELSE
          v_id_proveedor =  NULL;
     END IF;
    
      	
      --Sentencia de la modificacion
      update adq.tdocumento_sol set
      id_solicitud = v_parametros.id_solicitud,
      id_categoria_compra = v_parametros.id_categoria_compra,
      nombre_doc = v_parametros.nombre_doc,
      nombre_arch_doc = v_parametros.nombre_arch_doc,
      nombre_tipo_doc = v_parametros.nombre_tipo_doc,
      chequeado = v_parametros.chequeado,
      id_usuario_mod = p_id_usuario,
      fecha_mod = now(),
      id_proveedor = v_id_proveedor
      where id_documento_sol=v_parametros.id_documento_sol;
               
      --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Documento de Solicitud modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_documento_sol',v_parametros.id_documento_sol::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
    end;

  /*********************************    
  #TRANSACCION:  'ADQ_DOCSOL_ELI'
  #DESCRIPCION: Eliminacion de registros
  #AUTOR:   admin 
  #FECHA:   08-02-2013 19:01:00
  ***********************************/

  elsif(p_transaccion='ADQ_DOCSOL_ELI')then

    begin
      --Sentencia de la eliminacion
      delete from adq.tdocumento_sol
            where id_documento_sol=v_parametros.id_documento_sol;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Documento de Solicitud eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_documento_sol',v_parametros.id_documento_sol::varchar);
              
            --Devuelve la respuesta
            return v_resp;

    end;
        
  /*********************************    
  #TRANSACCION:  'ADQ_DOCSOLAR_MOD'
  #DESCRIPCION: upload de archivo
  #AUTOR:   admin 
  #FECHA:   08-02-2013 19:01:00
  ***********************************/
    
     elsif(p_transaccion='ADQ_DOCSOLAR_MOD')then
      begin
          
          update adq.tdocumento_sol set
            --archivo=v_parametros.archivo,
            extension=v_parametros.extension,
            chequeado = 'true'
            where id_documento_sol=v_parametros.id_documento_sol;
            
             v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Archivo modificado con exito '||v_parametros.id_documento_sol); 
             v_resp = pxp.f_agrega_clave(v_resp,'id_documento_sol',v_parametros.id_documento_sol::varchar);
             
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