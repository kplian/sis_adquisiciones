CREATE OR REPLACE FUNCTION adq.f_calcular_importe_detalle (
  p_id_solicitud integer
)
RETURNS numeric AS
$body$
DECLARE
  v_suma 	numeric(19,2) = 0;
  v_index 	numeric(19,2);
  v_resp	varchar;
BEGIN
  for v_index in (select tsd.precio_total
  				  from adq.tsolicitud_det tsd
                  where tsd.id_solicitud = p_id_solicitud and tsd.estado_reg = 'activo')loop
  	v_suma	= v_suma + v_index;
  end loop;
  return v_suma;
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