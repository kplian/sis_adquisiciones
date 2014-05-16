--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_get_desc_cotizaciones (
  p_id_proceso_compra integer
)
RETURNS text AS
$body$
DECLARE
  
    v_consulta    		varchar;
	v_nombre_funcion   	text;
	v_resp				varchar;
    
   
			    
BEGIN

	v_nombre_funcion = 'adq.f_get_desc_cotizaciones';
    
    IF p_id_proceso_compra is not NULL THEN
        
        select 
            pxp.list(COALESCE(c.numero_oc,'S/N') || '[' ||c.estado||']')
        into
        v_resp
        from   adq.tcotizacion c 
            where c.id_proceso_compra = p_id_proceso_compra;
        
        return v_resp;
    
    ELSE
    
    	return '';
    
    END IF;
    
    
    
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
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;