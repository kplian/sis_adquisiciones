--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_trig_rpc (
)
RETURNS trigger AS
$body$
DECLARE
 v_operacion varchar;
 v_descripcion text;  
BEGIN

 IF TG_OP = 'INSERT' THEN
  v_operacion = 'INSERT RPC'; 
  v_descripcion = 'Inserta nuevos cargo de RPC ';
 ELSIF TG_OP = 'UPDATE' THEN
   
     IF  NEW.estado_reg = 'activo' then
        
        v_operacion = 'UPDATE RPC';
   
       IF  NEW.ai_habilitado = 'si' and OLD.ai_habilitado = 'no' then
          v_descripcion = 'Habilitar el RPC suplente'; 
       ELSIF  NEW.ai_habilitado = 'no' and OLD.ai_habilitado = 'si' then
          v_descripcion = 'Deshabilitar el RPC suplente'; 
       ELSE
          v_descripcion = 'Modifica el RPC'; 
       END IF;
 
  
     ELSE
       v_operacion = 'INACTIVA RPC';
       v_descripcion = 'inactiva el RPC'; 
  
     END IF;
  
 
 ELSIF TG_OP = 'DELETE' THEN
  v_operacion = 'Elimina RPC'; 
  v_descripcion = 'Se elimina RPC desde base de datos, ya que no es posible hacerlo por interface de usuario';
 END IF;
 
INSERT INTO 
  adq.trpc_uo_log
(
  id_usuario_reg,
  id_usuario_mod,
  fecha_reg,
  fecha_mod,
  estado_reg,
  id_usuario_ai,
  usuario_ai,
  
  id_rpc_uo,
  id_rpc,
  fecha_ini,
  fecha_fin,
  monto_min,
  monto_max,
  id_uo,
  id_categoria_compra,
  operacion,
  descripcion,
  id_cargo_ai,
  id_cargo,
  ai_habilitado
) 
VALUES (
  
  
  NEW.id_usuario_reg,
  NEW.id_usuario_mod,
  NEW.fecha_reg,
  NEW.fecha_mod,
  'activo',
  NEW.id_usuario_ai,
  NEW.usuario_ai,
 
  NULL,--:id_rpc_uo,
  NEW.id_rpc,
  NULL,--fecha_ini,
  NULL,--fecha_fin,
  NULL,--monto_min,
  NULL,--monto_max,
  NULL,--id_uo,
  NULL,--id_categoria_compra,
  v_operacion,
  v_descripcion,
  NEW.id_cargo_ai,
  NEW.id_cargo,
  NEW.ai_habilitado
);

  

 RETURN NULL;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;