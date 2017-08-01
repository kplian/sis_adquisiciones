--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_cotizacion_det_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.f_cotizacion_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'adq.tcotizacion_det'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        21-03-2013 21:44:43
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_cotizacion_det	integer;
    
    
    v_cantidad_sol integer;
    v_precio_ga_mb_sol numeric;
    v_precio_unitario_sol numeric;
    v_precio_unitario_mb_sol numeric;
    v_id_moneda_sol integer;
    
    v_precio_unitario_mb_coti numeric;
    v_tipo_cambio_conv numeric;
	v_id_moneda_coti  integer;
    v_total_adj integer;
    
     
     v_id_solicitud_det integer;
     v_cantidad_coti integer;
     
     v_cantidad_adju integer;
     v_revertido_mb numeric;
     v_total_costo_mb numeric;
     v_id_partida_ejecucion integer;
     
     v_precio_sg_mb numeric;
     v_precio_ga_mb numeric;
     v_id_moneda_base integer;
     
     
     v_comprometido_ga numeric;
     v_ejecutado       numeric;
     
     
    
    
     v_precio_unitario_coti numeric;
     v_revertido_mo numeric;
     v_precio_sg numeric;
     v_precio_ga numeric;
     v_total_costo_mo numeric;
     v_id_moneda integer;
     
     
     v_adq_tolerancia_adjudicacion    varchar;
     v_adq_comprometer_presupuesto    varchar;
     
     
     
     
			    
BEGIN

    v_nombre_funcion = 'adq.f_cotizacion_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_CTD_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		21-03-2013 21:44:43
	***********************************/

	if(p_transaccion='ADQ_CTD_INS')then
					
        begin
        
           --recuperar datos de la solicitud
            select 
            sd.cantidad,
            sd.precio_ga_mb,
            sd.precio_unitario,
            sd.precio_unitario_mb,
            s.id_moneda
           into
            v_cantidad_sol,
            v_precio_ga_mb_sol,
            v_precio_unitario_sol,
            v_precio_unitario_mb_sol,
            v_id_moneda_sol
           from adq.tsolicitud_det sd
           inner join adq.tsolicitud s on s.id_solicitud = sd.id_solicitud
           where  sd.id_solicitud_det = v_parametros.id_solicitud_det;
           
           
           select 
          	 c.tipo_cambio_conv,
          	 c.id_moneda
           INTO
          	 v_tipo_cambio_conv,
           	 v_id_moneda_coti            
           from adq.tcotizacion c
           where c.id_cotizacion = v_parametros.id_cotizacion; 
         
        
            --validar que la cantidad cotizada no sea mayor a la cantidad solicitada
            
            IF( v_parametros.cantidad_coti > v_cantidad_sol ) THEN 
            
              raise exception 'No puede registrar una cantidad mayor que la solicitada';
            
            END IF;
            
            
            --calcular el precio unitario en moneda base
            
             v_precio_unitario_mb_coti= v_parametros.precio_unitario*v_tipo_cambio_conv;
             
         
            
               
        
        
        	--Sentencia de la insercion
        	insert into adq.tcotizacion_det(
			estado_reg,
			id_cotizacion,
			precio_unitario,
			--cantidad_aduj,
			cantidad_coti,
			obs,
			id_solicitud_det,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod,
            precio_unitario_mb,
            id_usuario_ai,
            usuario_ai
          	) values(
			'activo',
			v_parametros.id_cotizacion,
			v_parametros.precio_unitario,
			--v_parametros.cantidad_aduj,
			v_parametros.cantidad_coti,
			v_parametros.obs,
			v_parametros.id_solicitud_det,
			now(),
			p_id_usuario,
			null,
			null,
            v_precio_unitario_mb_coti,
            v_parametros._id_usuario_ai,
            v_parametros._nombre_usuario_ai
							
			)RETURNING id_cotizacion_det into v_id_cotizacion_det;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle cotizacion almacenado(a) con exito (id_cotizacion_det'||v_id_cotizacion_det||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cotizacion_det',v_id_cotizacion_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_CTD_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		21-03-2013 21:44:43
	***********************************/

	elsif(p_transaccion='ADQ_CTD_MOD')then

		begin
        
            --recuperar datos de la solicitud
            select 
            sd.cantidad,
            sd.precio_ga_mb,
            sd.precio_unitario,
            sd.precio_unitario_mb,
            s.id_moneda
           into
            v_cantidad_sol,
            v_precio_ga_mb_sol,
            v_precio_unitario_sol,
            v_precio_unitario_mb_sol,
            v_id_moneda_sol
           from adq.tsolicitud_det sd
           inner join adq.tsolicitud s on s.id_solicitud = sd.id_solicitud
           where  sd.id_solicitud_det = v_parametros.id_solicitud_det;
           
           
           select 
          	 c.tipo_cambio_conv,
          	 c.id_moneda
           INTO
          	 v_tipo_cambio_conv,
           	 v_id_moneda_coti            
           from adq.tcotizacion c
           where c.id_cotizacion = v_parametros.id_cotizacion; 
         
        
            --validar que la cantidad cotizada no sea mayor a la cantidad solicitada
            
            IF( v_parametros.cantidad_coti > v_cantidad_sol ) THEN 
            
              raise exception 'No puede registrar una cantidad mayor que la solicitada';
            
            END IF;
            
             --validar numeros negativos
            
            IF( v_parametros.cantidad_coti < 0  or   v_parametros.precio_unitario < 0 ) THEN 
            
              raise exception 'No se admiten numeros negativos';
            
            END IF;
            
            
            --calcular el precio unitario en moneda base
            
              v_precio_unitario_mb_coti= v_parametros.precio_unitario*v_tipo_cambio_conv;
            
        
			--Sentencia de la modificacion
			update adq.tcotizacion_det set
			id_cotizacion = v_parametros.id_cotizacion,
			precio_unitario = v_parametros.precio_unitario,
            precio_unitario_mb = v_precio_unitario_mb_coti,
			--cantidad_aduj = v_parametros.cantidad_aduj,
			cantidad_coti = v_parametros.cantidad_coti,
			obs = v_parametros.obs,
			id_solicitud_det = v_parametros.id_solicitud_det,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
            id_usuario_ai = v_parametros._id_usuario_ai,
            usuario_ai = v_parametros._nombre_usuario_ai
			where id_cotizacion_det=v_parametros.id_cotizacion_det;
			
			
			update adq.tsolicitud_det 
			set descripcion = v_parametros.descripcion_sol
            where id_solicitud_det = v_parametros.id_solicitud_det;
              
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle cotizacion modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cotizacion_det',v_parametros.id_cotizacion_det::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_CTD_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		21-03-2013 21:44:43
	***********************************/

	elsif(p_transaccion='ADQ_CTD_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from adq.tcotizacion_det
            where id_cotizacion_det=v_parametros.id_cotizacion_det;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle cotizacion eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cotizacion_det',v_parametros.id_cotizacion_det::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
    
    
        
    /*********************************    
 	#TRANSACCION:  'ADQ_TOTALADJ_IME'
 	#DESCRIPCION:	Recuperar Total adjudicado por item
 	#AUTOR:	    Rensi Arteaga Copari
 	#FECHA:		1-04-2013 21:44:43
	***********************************/

	elsif(p_transaccion='ADQ_TOTALADJ_IME')then

		begin
			
			
           v_total_adj = adq.f_calcular_total_adj_cot_det(v_parametros.id_cotizacion_det);
            
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Recupera Total Adjudicado'); 
            v_resp = pxp.f_agrega_clave(v_resp,'total_adj',v_total_adj::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;    
   

    /*********************************    
 	#TRANSACCION:  'ADQ_ADJDET_IME'
 	#DESCRIPCION:	Adjudicada por detalle de la cotizacion
 	#AUTOR:	    Rensi Arteaga Copari
 	#FECHA:		1-04-2013 21:44:43
	***********************************/

	elsif(p_transaccion='ADQ_ADJDET_IME')then

		begin
        
          
           
            --recupera datos de la solicitud y la cotizacion
            v_revertido_mb=0;
            v_id_moneda_base =  param.f_get_moneda_base();
            
            
            v_adq_tolerancia_adjudicacion  = pxp.f_get_variable_global('adq_tolerancia_adjudicacion');
            v_adq_comprometer_presupuesto = pxp.f_get_variable_global('adq_comprometer_presupuesto');
            
            select
               sd.id_solicitud_det, 
               sd.cantidad,
               cd.cantidad_coti,
               cd.cantidad_adju,
               sd.precio_unitario_mb,
               cd.precio_unitario_mb as precio_unitario_mb_coti,
               sd.precio_unitario,
               cd.precio_unitario as precio_unitario_coti,
               sd.revertido_mb,
               sd.revertido_mo,
               sd.id_partida_ejecucion,
               sd.precio_sg_mb,
               sd.precio_ga_mb,
               sd.precio_sg,
               sd.precio_ga,
               s.id_moneda
            into 
               v_id_solicitud_det,
               v_cantidad_sol,
               v_cantidad_coti,
               v_cantidad_adju,
               v_precio_unitario_mb_sol,
               v_precio_unitario_mb_coti,
               v_precio_unitario_sol,
               v_precio_unitario_coti,
               v_revertido_mb,
               v_revertido_mo,
               v_id_partida_ejecucion,
               v_precio_sg_mb,
               v_precio_ga_mb,
               v_precio_sg,
               v_precio_ga,
               v_id_moneda
            from adq.tsolicitud_det sd
            inner join adq.tcotizacion_det cd on  cd.id_solicitud_det = sd.id_solicitud_det
            inner join adq.tsolicitud s on s.id_solicitud = sd.id_solicitud
            where cd.id_cotizacion_det = v_parametros.id_cotizacion_det;
            
             
            
            IF v_precio_unitario_coti > v_precio_unitario_sol*( 1 + v_adq_tolerancia_adjudicacion::numeric) THEN 
              raise exception  'El precio referencial es menor que el precio cotizado ';
            END IF;
            
            
           
			--calcula el total adjudicado en otras cotizaciones
			
             v_total_adj = adq.f_calcular_total_adj_cot_det(v_parametros.id_cotizacion_det);
             v_total_costo_mo= adq.f_calcular_total_costo_mb_adj_cot_det(v_parametros.id_cotizacion_det,'MO');
             
             
            
            
            IF v_parametros.cantidad_adjudicada < 0 THEN
            
              raise exception 'No se admiten adjudicaciones negativas';
            
            END IF;
            
            --raise exception 'c% o %  sol %,  adj  %',v_cantidad_coti,v_parametros.cantidad_adjudicada,v_cantidad_sol,v_total_adj;
           
            IF  (v_cantidad_sol - v_total_adj) >= v_parametros.cantidad_adjudicada THEN
            
                 IF  v_cantidad_coti >= v_parametros.cantidad_adjudicada THEN
            
                      
                     --calcula el comprometido
                     v_comprometido_ga=0;
                     v_ejecutado=0;
                                     
                   
                     
                     SELECT 
                           COALESCE(ps_comprometido,0), 
                           COALESCE(ps_ejecutado,0)  
                       into 
                           v_comprometido_ga,    --esta en moneda base
                           v_ejecutado
                     FROM pre.f_verificar_com_eje_pag(v_id_partida_ejecucion, v_id_moneda);
                    
                     --validamos que el total revertido no afecte la adjudicacion 
                    IF  (((v_comprometido_ga + COALESCE(v_precio_sg,0)) - v_total_costo_mo)  >= (v_parametros.cantidad_adjudicada * v_precio_unitario_coti) ) OR v_adq_comprometer_presupuesto = 'no'  THEN
                       
                       update adq.tcotizacion_det set
                       cantidad_adju = v_parametros.cantidad_adjudicada
                       where id_cotizacion_det = v_parametros.id_cotizacion_det;
                    
                    ELSE
                      
                       raise exception 'La reversiones realizadas sobre este item no permiten adjudicar a este precio, solo dispone de un total  de: %',((v_comprometido_ga+ COALESCE(v_precio_sg,0)) - v_total_costo_mo) ;
                    
                    END IF;
                 
                 ELSE
                  raise exception 'la cantidad adjudicada tiene que ser menor o igual cotizada';
            
                 
                 END IF;
            ELSE
            
              raise exception 'la cantidad adjudicada tiene que ser menor o igual que la solicitada y que el total adjudicado';
            
            END IF;
           
            
            
            
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se adjudicaron los item indicados'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cotizacion_det',v_parametros.id_cotizacion_det::varchar);
              
            --Devuelve la respuesta
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