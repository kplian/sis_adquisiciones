--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_trig_rpc_uo (
)
RETURNS trigger AS
$body$
DECLARE
 v_operacion varchar;
 v_descripcion text; 
 v_registros   record; 
BEGIN

 
 
 
 
 
 
 
 IF TG_OP = 'INSERT' THEN
        v_operacion = 'INSERT RPC'; 
        v_descripcion = 'Inserta nuevos cargo de RPC ';
        
        
        
        select 
        rpc.id_cargo,
        rpc.id_cargo_ai,
        rpc.ai_habilitado
        into
        v_registros
        from adq.trpc rpc 
        where rpc.id_rpc = NEW.id_rpc;
           
          
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
         
          NEW.id_rpc_uo,
          NEW.id_rpc,
          NEW.fecha_ini,
          NEW.fecha_fin,
          NEW.monto_min,
          NEW.monto_max,
          NEW.id_uo,
          NEW.id_categoria_compra,
          v_operacion,
          v_descripcion,
          v_registros.id_cargo_ai,
          v_registros.id_cargo,
          v_registros.ai_habilitado
        );
  


 ELSIF TG_OP = 'UPDATE' THEN
   
     IF  NEW.estado_reg = 'activo' then
        
        v_operacion = 'UPDATE RPC';
   
       /*IF  NEW.ai_habilitado = 'si' and OLD.ai_habilitado = 'no' then
          v_descripcion = 'Habilitar el RPC suplente'; 
       ELSIF  NEW.ai_habilitado = 'no' and OLD.ai_habilitado = 'si' then
          v_descripcion = 'Deshabilitar el RPC suplente'; 
       ELSE*/
          v_descripcion = 'Modifica el RPC'; 
       --END IF;
 
  
     ELSE
       v_operacion = 'INACTIVA RPC';
       v_descripcion = 'inactiva el RPC'; 
  
     END IF;
     
     
     select 
        rpc.id_cargo,
        rpc.id_cargo_ai,
        rpc.ai_habilitado
        into
        v_registros
        from adq.trpc rpc 
        where rpc.id_rpc = NEW.id_rpc;
        
        
     
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
         
          NEW.id_rpc_uo,
          NEW.id_rpc,
          NEW.fecha_ini,
          NEW.fecha_fin,
          NEW.monto_min,
          NEW.monto_max,
          NEW.id_uo,
          NEW.id_categoria_compra,
          v_operacion,
          v_descripcion,
          v_registros.id_cargo_ai,
          v_registros.id_cargo,
          v_registros.ai_habilitado
        );
  
 



 ELSIF TG_OP = 'DELETE' THEN
    v_operacion = 'Elimina RELACION  RPC'; 
    v_descripcion = 'Se elimina la relacion de RPC';
    
    select 
        rpc.id_cargo,
        rpc.id_cargo_ai,
        rpc.ai_habilitado
     into
        v_registros
     from adq.trpc rpc 
     where rpc.id_rpc = OLD.id_rpc;
    
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
      
      
      OLD.id_usuario_reg,
      OLD.id_usuario_mod,
      now(),
      now(),
      'activo',
      OLD.id_usuario_ai,
      OLD.usuario_ai,
     
      OLD.id_rpc_uo,
      OLD.id_rpc,
      OLD.fecha_ini,
      OLD.fecha_fin,
      OLD.monto_min,
      OLD.monto_max,
      OLD.id_uo,
      OLD.id_categoria_compra,
      v_operacion,
      v_descripcion,
      v_registros.id_cargo_ai,
      v_registros.id_cargo,
     v_registros.ai_habilitado
    );
 
 
 END IF;
 


  

 RETURN NULL;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;