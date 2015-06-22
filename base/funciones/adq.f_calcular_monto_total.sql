CREATE OR REPLACE FUNCTION adq.f_calcular_monto_total (
  p_id_presupuesto integer,
  p_id_partida integer,
  p_id_moneda integer
)
RETURNS numeric AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Adquisiciones
 FUNCION: 		adq.f_calcular_monto_total
 DESCRIPCION:   Funcion que calcula el monto total de una partida dentro de un centro de costo
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        13-03-2013
 COMENTARIOS:	
***************************************************************************/

DECLARE
  registro record;
BEGIN
  select soldet.id_centro_costo, soldet.id_partida, sum(soldet.precio_ga_mb) as monto_total into registro 
            from adq.tsolicitud_det soldet 
            where soldet.id_centro_costo=p_id_presupuesto and soldet.id_partida=p_id_partida
            group by soldet.id_partida, soldet.id_centro_costo order by soldet.id_centro_costo asc;
  
  return registro.monto_total;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;