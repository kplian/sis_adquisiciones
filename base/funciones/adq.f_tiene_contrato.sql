CREATE OR REPLACE FUNCTION adq.f_tiene_contrato (
  p_id_usuario integer,
  p_id_proceso_wf integer
)
RETURNS varchar AS
$body$
DECLARE
  v_registro		record;
  v_resp			 				varchar;
  v_nombre_funcion 				varchar;
BEGIN
  v_nombre_funcion='adq.f_tiene_contrato';	
  select * into v_registro
  from adq.tcotizacion
  where id_proceso_wf = p_id_proceso_wf;
  
  if (v_registro.requiere_contrato = 'si') then  	
    return 'true';
  else
  	return 'false';
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