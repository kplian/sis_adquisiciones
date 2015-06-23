CREATE OR REPLACE FUNCTION adq.f_wfobs_cot (
  p_id_obs integer
)
RETURNS void AS
$body$
DECLARE  
  v_resp					varchar;
  v_nombre_funcion			varchar;
  
  v_sol 					record;
  v_obs						record;
BEGIN
	
	v_nombre_funcion = 'adq."f_wfobs_cot"';
	select s.* into v_sol
    from wf.tobs obs
    inner join wf.testado_wf ewf on obs.id_estado_wf = ewf.id_estado_wf
    inner join adq.tcotizacion c on c.id_proceso_wf = ewf.id_proceso_wf
    inner join adq.tproceso_compra pc on pc.id_proceso_compra = c.id_proceso_compra
    inner join adq.tsolicitud s on pc.id_solicitud = s.id_solicitud
    where obs.id_obs = p_id_obs;
    
    select * into v_obs
    from wf.tobs obs
    where obs.id_obs = p_id_obs;
    --Si la persona observada es el solicitante, el estado_reg de la observacion es activo
    --y la observacion no esta cerrada habilitamos la bandera
    if (v_obs.id_funcionario_resp = v_sol.id_funcionario and v_obs.estado_reg = 'activo' and
    	v_obs.estado = 'abierto') then
        
        update adq.tsolicitud set update_enable = 'si'
        where id_solicitud = v_sol.id_solicitud;
    
    elsif(v_obs.id_funcionario_resp = v_sol.id_funcionario and (v_obs.estado_reg = 'inactivo' or
    	v_obs.estado = 'cerrado')) then    
   --Si la persona observada es el solicitante, el estado_reg de la observacion es inactivo
    --o la observacion esta cerrada deshabilitamos la bandera
    	update adq.tsolicitud set update_enable = 'no'
        where id_solicitud = v_sol.id_solicitud;
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