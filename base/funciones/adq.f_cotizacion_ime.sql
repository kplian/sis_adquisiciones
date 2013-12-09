--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_cotizacion_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.f_cotizacion_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'adq.tcotizacion'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        21-03-2013 14:48:35
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
    v_id_cotizacion	integer;
            
    v_id_proceso_wf_pro integer;
    v_id_estado_wf_pro integer;
    v_num_tramite varchar;
    v_estado_pro varchar;
            
    va_id_tipo_estado_pro integer[];
    va_codigo_estado_pro varchar[];
    va_disparador_pro varchar[];
    va_regla_pro varchar[];
    va_prioridad_pro integer[];
              
    v_id_estado_actual integer;
              
    v_id_depto integer;
              
              
    v_id_proceso_wf integer;
    v_id_estado_wf integer;
    v_codigo_estado varchar;
               
    v_registros record;
               
    v_id_solicitud integer;
               
    v_total_detalle numeric;
    v_tipo_cambio_conv numeric;
               
    v_id_moneda integer;
               
    va_id_tipo_estado integer[];
    va_codigo_estado varchar[];
    va_disparador varchar[];
    va_regla varchar[];
    va_prioridad  integer[];
                
    v_id_proceso_compra integer;
    v_estado_cot varchar;
    v_total_adj integer;
    v_cantidad_adjudicada integer;
    v_numero_oc varchar;
    v_id_periodo integer;
    
    
     v_id_tipo_estado integer;
     v_id_funcionario integer;
     v_id_usuario_reg integer;
     v_id_estado_wf_ant  integer;
     
     
     v_id_proveedor integer;
    
     v_id_estado_wf_cot integer;
     v_id_proceso_wf_cot integer;
     v_id_subsistema integer;
     v_id_obligacion_pago integer;
     v_id_obligacion_det integer;
     v_id_gestion integer;
     v_id_funcionario_rpc integer;
     v_num_sol varchar;
     
     v_cad_ep varchar;
     v_cad_uo varchar;
     
     v_sw boolean;
     v_sw2 boolean;
     v_total_costo_mb numeric;
     v_comprometido_ga numeric;
     v_ejecutado numeric;
     v_id_moneda_base integer;
     v_result varchar;
     v_dec_proveedor text;
     
     
    
      v_perdir_obs varchar;
      v_num_estados integer;
      v_num_funcionarios integer;
      v_num_deptos integer;
      v_id_funcionario_estado integer;
      v_id_depto_estado integer;
      v_codigo_estado_siguiente varchar;
      v_obs varchar;
      v_fecha_coti date;
     
			    
BEGIN

    v_nombre_funcion = 'adq.f_cotizacion_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_COT_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		21-03-2013 14:48:35
	***********************************/

	if(p_transaccion='ADQ_COT_INS')then
					
        begin
        
           --obtener datos del proceso de compra
           
           
           select
            pc.num_tramite,
            pc.id_proceso_wf,
            pc.id_estado_wf,
            pc.estado,
            pc.id_depto,
            pc.id_solicitud
           into
            v_num_tramite,
            v_id_proceso_wf_pro,
            v_id_estado_wf_pro,
            v_estado_pro,
            v_id_depto,
            v_id_solicitud
           from adq.tproceso_compra pc
           where pc.id_proceso_compra = v_parametros.id_proceso_compra;
           
           
           --recupera el nomber del proveedor
           
           select 
             p.desc_proveedor
           into
            v_dec_proveedor
           from param.vproveedor p 
           where p.id_proveedor= v_parametros.id_proveedor;
           
           

          -- raise exception ' xxxxxxxx   % - %', v_estado_pro, v_parametros.id_proceso_compra;

          IF  v_estado_pro = 'pendiente' THEN
                         
                         SELECT 
                           ps_id_tipo_estado,
                           ps_codigo_estado,
                           ps_disparador,
                           ps_regla,
                           ps_prioridad
                        into
                          va_id_tipo_estado_pro,
                          va_codigo_estado_pro,
                          va_disparador_pro,
                          va_regla_pro,
                          va_prioridad_pro
                      
                      FROM wf.f_obtener_estado_wf(v_id_proceso_wf_pro, v_id_estado_wf_pro,NULL,'siguiente');        
                    
                     IF  va_id_tipo_estado_pro[2] is not null  THEN
                       
                      raise exception 'El proceso se encuentra mal parametrizado dentro de Work Flow,  el estado pendiente de proceso solo  admite un estado siguiente,  no admitido (%)',va_codigo_estado_pro[2];
                      
                    END IF;
                      
                  
                  
                    IF  va_codigo_estado_pro[1] != 'proceso'  THEN
                      raise exception 'El proceso se encuentra mal parametrizado dentro de Work Flow, elsiguiente estado para el proceso de compra deberia ser "proceso" y no % ',va_codigo_estado_sol[1];
                    END IF;
                  
                  
                    -- registra estado eactual en el WF para rl procesod e compra
                    
                    
                     v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado_pro[1], 
                                                                   NULL, --id_funcionario
                                                                   v_id_estado_wf_pro, 
                                                                   v_id_proceso_wf_pro,
                                                                   p_id_usuario,
                                                                   v_id_depto);
                     
                    --actualiza el proceso
                    
                    -- actuliaza el stado en la solictud
                     update adq.tproceso_compra  p set 
                       id_estado_wf =  v_id_estado_actual,
                       estado = va_codigo_estado_pro[1],
                       id_usuario_mod=p_id_usuario,
                       fecha_mod=now()
                     where id_proceso_compra = v_parametros.id_proceso_compra; 
                  
                    --iniciar el proceso WF
                     
                               
                   --registra estado de cotizacion 
                    
                     SELECT
                               ps_id_proceso_wf,
                               ps_id_estado_wf,
                               ps_codigo_estado
                         into
                               v_id_proceso_wf,
                               v_id_estado_wf,
                               v_codigo_estado
                      FROM wf.f_registra_proceso_disparado_wf(
                               p_id_usuario,
                               v_id_estado_actual, 
                               NULL, 
                               v_id_depto, 
                               v_dec_proveedor::varchar);
                  
          
           ELSEIF  v_estado_pro = 'proceso' THEN
          
                 --registra estado de cotizacion
          
                 SELECT
                           ps_id_proceso_wf,
                           ps_id_estado_wf,
                           ps_codigo_estado
                     into
                           v_id_proceso_wf,
                           v_id_estado_wf,
                           v_codigo_estado
                  FROM wf.f_registra_proceso_disparado_wf(
                           p_id_usuario,
                           v_id_estado_wf_pro, 
                           NULL, 
                           v_id_depto,
                           v_dec_proveedor::varchar);
          ELSE
        
          
           		 raise exception 'Estado no reconocido % ', v_estado_pro;
          
          END IF;
          
          
          
           
            
        
        
        	--Sentencia de la insercion
        	insert into adq.tcotizacion(
			estado_reg,
			estado,
			lugar_entrega,
			tipo_entrega,
			fecha_coti,
		
			id_proveedor,
			--porc_anticipo,
			--precio_total,
			fecha_entrega,
			id_moneda,
			id_proceso_compra,
			fecha_venc,
			obs,
			fecha_adju,
			nro_contrato,
			--porc_retgar,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod,
            id_estado_wf,
            id_proceso_wf,
            tipo_cambio_conv
          	) values(
			'activo',
			v_codigo_estado,
			v_parametros.lugar_entrega,
			v_parametros.tipo_entrega,
			v_parametros.fecha_coti,
		
			v_parametros.id_proveedor,
			--v_parametros.porc_anticipo,
			--v_parametros.precio_total,
			v_parametros.fecha_entrega,
			v_parametros.id_moneda,
			v_parametros.id_proceso_compra,
			v_parametros.fecha_venc,
			v_parametros.obs,
			v_parametros.fecha_adju,
			v_parametros.nro_contrato,
			--v_parametros.porc_retgar,
			now(),
			p_id_usuario,
			null,
			null,
            v_id_estado_wf,
            v_id_proceso_wf,
            v_parametros.tipo_cambio_conv
							
			)RETURNING id_cotizacion into v_id_cotizacion;
            
            
            --registrar el detalle de la cotizacion con precio 0 y cantidad 0
            
            
            
           FOR v_registros in  SELECT
               sd.id_solicitud_det
            from adq.tsolicitud_det sd
            where sd.id_solicitud =v_id_solicitud and sd.estado_reg = 'activo' LOOP
                  
                  INSERT INTO 
                    adq.tcotizacion_det
                  (
                    id_usuario_reg,
                    fecha_reg,
                    estado_reg,
                    id_cotizacion,
                    id_solicitud_det,
                    precio_unitario,
                    cantidad_coti,
                    cantidad_adju
                   ) 
                  VALUES (
                    p_id_usuario,
                    now(),
                   'activo',
                    v_id_cotizacion,
                    v_registros.id_solicitud_det,-- :id_solicitud_det,
                    0,--:precio_unitario,
                    0,--:cantidad_coti,
                    0   --cantidad_aduj
                    );
            
            END LOOP;
            
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cotizaciones almacenado(a) con exito (id_cotizacion'||v_id_cotizacion||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cotizacion',v_id_cotizacion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_COT_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		21-03-2013 14:48:35
	***********************************/

	elsif(p_transaccion='ADQ_COT_MOD')then

		begin
        
          
             select 
              c.id_moneda,
              c.tipo_cambio_conv
             into
              v_id_moneda,
              v_tipo_cambio_conv
             from
             adq.tcotizacion c
             where c.id_cotizacion = v_parametros.id_cotizacion;
           
           
           IF  v_id_moneda != v_parametros.id_moneda or v_tipo_cambio_conv !=v_parametros.tipo_cambio_conv THEN
           
                --la moneda y el tipo de cambio no pueden cambiar cambiar si tiene detalles registrados
            
                select 
                  sum(COALESCE(cd.precio_unitario,0)* COALESCE(cd.cantidad_coti,0))
                INTO
                 v_total_detalle  
                 from adq.tcotizacion_det cd 
                where cd.id_cotizacion = v_parametros.id_cotizacion;
            
                IF (v_total_detalle >0  )THEN
                
                	raise exception 'No puede cambiar ni la moneda,  ni el tipo de cambio si existen items cotizados';
                
                END IF;
             
           
           END IF;             
           
        
			--Sentencia de la modificacion
			update adq.tcotizacion set
		
			lugar_entrega = v_parametros.lugar_entrega,
			tipo_entrega = v_parametros.tipo_entrega,
			fecha_coti = v_parametros.fecha_coti,
			id_proveedor = v_parametros.id_proveedor,
			fecha_entrega = v_parametros.fecha_entrega,
			id_moneda = v_parametros.id_moneda,
			id_proceso_compra = v_parametros.id_proceso_compra,
			fecha_venc = v_parametros.fecha_venc,
			obs = v_parametros.obs,
			fecha_adju = v_parametros.fecha_adju,
			nro_contrato = v_parametros.nro_contrato,
			fecha_mod = now(),
            tipo_cambio_conv = v_parametros.tipo_cambio_conv,
			id_usuario_mod = p_id_usuario
			where id_cotizacion=v_parametros.id_cotizacion;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cotizaciones modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cotizacion',v_parametros.id_cotizacion::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_COT_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		21-03-2013 14:48:35
	***********************************/

	elsif(p_transaccion='ADQ_COT_ELI')then

		begin
			--Sentencia de la eliminacion
			
            --recupepramos datos de la cotizacion
            
            SELECT
              c.id_estado_wf,
              c.id_proceso_wf,
              c.estado,
              pc.id_depto
            into
              v_id_estado_wf,
              v_id_proceso_wf,
              v_estado_cot,
              v_id_depto
            from adq.tcotizacion c
            inner join adq.tproceso_compra pc on pc.id_proceso_compra = c.id_proceso_compra
            where  c.id_cotizacion = v_parametros.id_cotizacion;
            
            
            
            -- preguntamos por los estados validos para anular 
            
            IF  v_estado_cot = 'borrador' or  v_estado_cot = 'cotizado' or  v_estado_cot = 'adjudicado' THEN
            
               --recuperamos el id_tipo_proceso en el WF para el estado anulado
               --ya que este es un estado especial que no tiene padres definidos
               
               
               select 
               	te.id_tipo_estado
               into
               	v_id_tipo_estado
               from wf.tproceso_wf pw 
               inner join wf.ttipo_proceso tp on pw.id_tipo_proceso = tp.id_tipo_proceso
               inner join wf.ttipo_estado te on te.id_tipo_proceso = tp.id_tipo_proceso and te.codigo = 'anulado'               
               where pw.id_proceso_wf = v_id_proceso_wf;
               
              
              
               -- pasamos la cotizacion al siguiente estado
           
               v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado, 
                                                           NULL, 
                                                           v_id_estado_wf, 
                                                           v_id_proceso_wf,
                                                           p_id_usuario,
                                                           v_id_depto);
            
            
               -- actualiza estado en la cotizacion
              
               update adq.tcotizacion  c set 
                 id_estado_wf =  v_id_estado_actual,
                 estado = 'anulado',
                 id_usuario_mod=p_id_usuario,
                 fecha_mod=now()
               where c.id_cotizacion  = v_parametros.id_cotizacion;
               
               
            
               --modifiamos las adjudicaciones si existen 
                update adq.tcotizacion_det  set 
                cantidad_adju = 0 ,
                id_usuario_mod = p_id_usuario,
                fecha_mod = now()
                where id_cotizacion = v_parametros.id_cotizacion;
            
            ELSE
            
            raise exception 'solo se puede anular cotizaciones en estado borrador, cotizado o adjudicado';
            
            
            END IF;
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cotizacion anulada'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cotizacion',v_parametros.id_cotizacion::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
        
    /*********************************    
 	#TRANSACCION:  'ADQ_ADJTODO_IME'
 	#DESCRIPCION:	Adjudica todo el detalle de la cotizacion disponible
 	#AUTOR:	        Rensi Arteaga Copari
 	#FECHA:		    1-4-2013 14:48:35
	***********************************/

	elsif(p_transaccion='ADQ_ADJTODO_IME')then

		begin
			v_sw = FALSE;
            v_sw2 = FALSE;
            v_id_moneda_base =  param.f_get_moneda_base();
               
           --si ya tien item adjudicados no se los toca
           
            FOR v_registros in (
                                 select  
                                   cd.id_cotizacion_det,
                                   sd.id_solicitud_det, 
                                   sd.cantidad,
                                   cd.cantidad_coti,
                                   cd.cantidad_adju,
                                   sd.precio_unitario_mb as precio_unitario_mb_sol,
                                   cd.precio_unitario_mb as precio_unitario_mb_coti,
                                   sd.revertido_mb,
                                   sd.precio_ga_mb,
                                   sd.precio_sg_mb,
                                   sd.id_partida_ejecucion
                                 from adq.tcotizacion_det cd 
                                 inner join adq.tsolicitud_det sd on sd.id_solicitud_det = cd.id_solicitud_det and cd.estado_reg = 'activo'
                                 where  cd.id_cotizacion = v_parametros.id_cotizacion and cd.estado_reg = 'activo') LOOP
                                 
            
            
               v_total_adj = adq.f_calcular_total_adj_cot_det(v_registros.id_cotizacion_det);
               v_total_costo_mb= adq.f_calcular_total_costo_mb_adj_cot_det(v_registros.id_cotizacion_det);
            
               --si ya tien item adjudicados no se los toca
                IF v_registros.cantidad_adju = 0   THEN
                
                      --si el precio oferta es menor que el precio referencial
                      IF v_registros.precio_unitario_mb_sol >= v_registros.precio_unitario_mb_coti THEN
                
                          IF  (v_registros.cantidad - v_total_adj) <  v_registros.cantidad_coti THEN
                          
                              v_cantidad_adjudicada = v_registros.cantidad - v_total_adj;
                           
                          ELSE    
                              v_cantidad_adjudicada =v_registros.cantidad_coti;
                         
                         
                          END IF;
                          
                            IF  v_cantidad_adjudicada > 0 THEN
                                --calcula el comprometido
                                 v_comprometido_ga=0;
                                 v_ejecutado=0;
                                                 
                                 SELECT 
                                       COALESCE(ps_comprometido,0), 
                                       COALESCE(ps_ejecutado,0)  
                                   into 
                                       v_comprometido_ga,    --esta en moneda base
                                       v_ejecutado
                                 FROM pre.f_verificar_com_eje_pag(v_registros.id_partida_ejecucion, v_id_moneda_base);
                                
                                 --validamos que el total revertido no afecte la adjudicacion            
                                 --en caso contrario no se adjudicada nada
                                IF  ((v_comprometido_ga + COALESCE(v_registros.precio_sg_mb,0)) - v_total_costo_mb)  >= (v_cantidad_adjudicada * v_registros.precio_unitario_mb_coti)   THEN
                                     
                                     update adq.tcotizacion_det set
                                     cantidad_adju = v_cantidad_adjudicada
                                     where id_cotizacion_det = v_registros.id_cotizacion_det;
                               
                                    v_sw  = TRUE;
                                ELSE
                                    v_sw2 = TRUE;
                                END IF;
                                
                          END IF;
                      
                      END IF;     
                
                
                END   IF;
             END LOOP;
        
             
             IF not v_sw  THEN
             
                IF  v_sw2 THEN
                
                   raise exception 'No puede adjudicarse nada (Verifique el presupuesto comprometido y revertido)';
                ELSE
                  raise exception 'No puede adjudicarse nada';
                END If;
             END IF;
           
             --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cotizaciones eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cotizacion',v_parametros.id_cotizacion::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
        
     
	/*********************************    
 	#TRANSACCION:  'ADQ_GENOC_IME'
 	#DESCRIPCION:	Generar el numero secuencial de Orden de compra y pasa al siguiente estado la cotizacion
 	#AUTOR:	        Rensi Arteaga Copari	
 	#FECHA:		    1-04-2013 14:48:35
	***********************************/

	elsif(p_transaccion='ADQ_GENOC_IME')then

		begin
        
           select
            c.numero_oc,
            c.id_estado_wf,
            c.id_proceso_wf,
            pc.id_depto,
            c.estado
           into 
            v_numero_oc,
            v_id_estado_wf,
            v_id_proceso_wf,
            v_id_depto,
            v_estado_cot
           from adq.tcotizacion c
           inner join adq.tproceso_compra pc on pc.id_proceso_compra = c.id_proceso_compra
           where c.id_cotizacion = v_parametros.id_cotizacion;
           
           --validamos que la cotizacion por lo menos tenga un item adjudicado
                    select 
                    sum(cd.cantidad_adju)
                    into
                    v_total_adj
                   from adq.tcotizacion_det cd
                   where cd.id_cotizacion = v_parametros.id_cotizacion and cd.estado_reg='activo';
                   
                   
                   IF v_total_adj  <= 0  or v_total_adj is null THEN
                   
                     raise exception 'La cotización no tiene items adjudicados';
                   
                   END IF;
           
           
           --si no existe un numero de oc obtenemos uno
           IF  v_numero_oc is NULL THEN
           
               
                   
                   
                   -- determina la fecha del periodo
                  
                   select id_periodo into v_id_periodo from
                                  param.tperiodo per 
                                 where per.fecha_ini <= v_parametros.fecha_oc 
                                   and per.fecha_fin >=  v_parametros.fecha_oc
                                   limit 1 offset 0;
                  
                  
               
               
               
                  --obtener correlativo
                   v_numero_oc =   param.f_obtener_correlativo(
                            'OC', 
                             v_id_periodo,-- par_id, 
                             NULL, --id_uo 
                             v_id_depto,    -- id_depto
                             p_id_usuario, 
                             'ADQ', 
                             NULL);
                             
                             
                    update adq.tcotizacion set
                    fecha_adju = v_parametros.fecha_oc,
                    numero_oc = v_numero_oc
                    where id_cotizacion = v_parametros.id_cotizacion;
           
           
           END IF;
           
             IF  v_estado_cot != 'recomendado' THEN
             
              raise exception 'Solo se admiten cotizaciones en estado cotizado';
             END IF;
             
             --obtenemos el estado siguiente
             SELECT 
                 *
              into
                va_id_tipo_estado,
                va_codigo_estado,
                va_disparador,
                va_regla,
                va_prioridad
            
            FROM wf.f_obtener_estado_wf(v_id_proceso_wf, v_id_estado_wf,NULL,'siguiente');
            
            
            
            IF va_codigo_estado[2] is not null THEN
            
             raise exception 'El proceso de WF esta mal parametrizado, el estado cotizado de la cotizacion solo admite un estado siguiente';
            
            END IF;
            
             IF va_codigo_estado[1] is  null THEN
            
             raise exception 'El proceso de WF esta mal parametrizado, no se encuentra el estado siguiente ';
            
            END IF;
			
           --pasamos la cotizacion al siguiente estado
           
             v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado[1], 
                                                           NULL, 
                                                           v_id_estado_wf, 
                                                           v_id_proceso_wf,
                                                           p_id_usuario,
                                                           v_id_depto);
            
            
             -- actualiza estado en la solicitud
            
             update adq.tcotizacion  c set 
               id_estado_wf =  v_id_estado_actual,
               estado = va_codigo_estado[1],
               id_usuario_mod=p_id_usuario,
               fecha_mod=now()
             where c.id_cotizacion  = v_parametros.id_cotizacion;
           
              
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Numero de Orden de Compra generado'); 
            v_resp = pxp.f_agrega_clave(v_resp,'cantidad',v_total_adj::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end; 
    
    
    /*********************************    
 	#TRANSACCION:  'ADQ_SOLAPRO_IME'
 	#DESCRIPCION:	depues de (Recomendar)adjudicar pasa al siguiente estado, de solicitud de aprobacion
 	#AUTOR:	        Rensi Arteaga Copari	
 	#FECHA:		    7-05-2013 14:48:35
	***********************************/

	elsif(p_transaccion='ADQ_SOLAPRO_IME')then

		begin
        
           select
            c.numero_oc,
            c.id_estado_wf,
            c.id_proceso_wf,
            pc.id_depto,
            c.estado,
            sc.id_funcionario_rpc,
            sc.numero
           into 
            v_numero_oc,
            v_id_estado_wf,
            v_id_proceso_wf,
            v_id_depto,
            v_estado_cot,
            v_id_funcionario_rpc,
            v_num_sol
            
           from adq.tcotizacion c
           inner join adq.tproceso_compra pc on pc.id_proceso_compra = c.id_proceso_compra
           inner join adq.tsolicitud sc on sc.id_solicitud = pc.id_solicitud 
           where c.id_cotizacion = v_parametros.id_cotizacion;
           
           
           --validamos que la cotizacion por lo menos tenga un item adjudicado
           select 
            sum(cd.cantidad_adju)
            into
            v_total_adj
           from adq.tcotizacion_det cd
           where cd.id_cotizacion = v_parametros.id_cotizacion and cd.estado_reg='activo';
                   
                   
           IF v_total_adj  <= 0  or v_total_adj is null THEN
                   
             raise exception 'La cotización no tiene items adjudicados';
                   
           END IF;
           
           
                      
             IF  v_estado_cot != 'cotizado' THEN
             
              raise exception 'Solo se admiten cotizaciones en estado cotizado';
             END IF;
             
             --obtenemos el estado siguiente
             SELECT 
                 *
              into
                va_id_tipo_estado,
                va_codigo_estado,
                va_disparador,
                va_regla,
                va_prioridad
            
            FROM wf.f_obtener_estado_wf(v_id_proceso_wf, v_id_estado_wf,NULL,'siguiente');
            
            
            
            IF va_codigo_estado[2] is not null THEN
            
             raise exception 'El proceso de WF esta mal parametrizado, el estado cotizado de la cotizacion solo admite un estado siguiente';
            
            END IF;
            
             IF va_codigo_estado[1] is  null THEN
            
             raise exception 'El proceso de WF esta mal parametrizado, no se encuentra el estado siguiente ';
            
            END IF;
			
             
             --  pasamos la cotizacion al siguiente estado
           
             v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado[1], 
                                                           v_id_funcionario_rpc, 
                                                           v_id_estado_wf, 
                                                           v_id_proceso_wf,
                                                           p_id_usuario,
                                                           v_id_depto,
                                                           'Se requiere la aprobacion de la solicitud '||v_num_sol,
                                                           '../../../sis_adquisiciones/vista/cotizacion/CotizacionVbDin.php',
                                                           'CotizacionVbDin');
            
            
             -- actualiza estado en la solicitud
            
             update adq.tcotizacion  c set 
               id_estado_wf =  v_id_estado_actual,
               estado = va_codigo_estado[1],
               id_usuario_mod=p_id_usuario,
               fecha_mod=now()
             where c.id_cotizacion  = v_parametros.id_cotizacion;
           
              
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Solicitud de Aprobacion enviada'); 
            v_resp = pxp.f_agrega_clave(v_resp,'cantidad',v_total_adj::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
    
    
     /*********************************    
 	#TRANSACCION:  'ADQ_SIGECOT_IME'
 	#DESCRIPCION:	funcion que controla el cambio al Siguiente esado de la solicitud, integrado con el WF
 	#AUTOR:		RAC	
 	#FECHA:		19-02-2013 12:12:51
	***********************************/

	elseif(p_transaccion='ADQ_SIGECOT_IME')then   
        begin
        
        --obtenermos datos basicos
          
           select
            c.numero_oc,
            c.id_estado_wf,
            c.id_proceso_wf,
            pc.id_depto,
            c.estado,
            sc.id_funcionario_rpc,
            sc.numero,
            c.fecha_coti
           into 
            v_numero_oc,
            v_id_estado_wf,
            v_id_proceso_wf,
            v_id_depto,
            v_estado_cot,
            v_id_funcionario_rpc,
            v_num_sol,
            v_fecha_coti
            
           from adq.tcotizacion c
           inner join adq.tproceso_compra pc on pc.id_proceso_compra = c.id_proceso_compra
           inner join adq.tsolicitud sc on sc.id_solicitud = pc.id_solicitud 
           where c.id_cotizacion = v_parametros.id_cotizacion;
          
         
           --obtiene datos de la configuracion del  estado
           select 
            ew.id_tipo_estado ,
            te.pedir_obs
           into 
            v_id_tipo_estado,
            v_perdir_obs
          from wf.testado_wf ew
          inner join wf.ttipo_estado te on te.id_tipo_estado = ew.id_tipo_estado
          where ew.id_estado_wf = v_id_estado_wf;
          
          
          --validamos de adjudicaciones
          
          IF v_estado_cot = 'cotizado' THEN
               
               --validamos que la cotizacion por lo menos tenga un item adjudicado
               select 
                sum(cd.cantidad_adju)
                into
                v_total_adj
               from adq.tcotizacion_det cd
               where cd.id_cotizacion = v_parametros.id_cotizacion and cd.estado_reg='activo';
                       
                       
               IF v_total_adj  <= 0  or v_total_adj is null THEN
                       
                 raise exception 'La cotización no tiene items adjudicados';
                       
               END IF;
               
               
                --si no existe un numero de oc obtenemos uno
               IF  v_numero_oc is NULL THEN
               
                   
                       
                       /*
                       -- determina la fecha del periodo
                      
                       select id_periodo into v_id_periodo from
                                      param.tperiodo per 
                                     where per.fecha_ini <= v_parametros.fecha_oc 
                                       and per.fecha_fin >=  v_parametros.fecha_oc
                                       limit 1 offset 0;
                      
                      
                   
                   
                   
                      --obtener correlativo
                       v_numero_oc =   param.f_obtener_correlativo(
                                'OC', 
                                 v_id_periodo,-- par_id, 
                                 NULL, --id_uo 
                                 v_id_depto,    -- id_depto
                                 p_id_usuario, 
                                 'ADQ', 
                                 NULL);
                                 
                                 
                        update adq.tcotizacion set
                        fecha_adju = v_parametros.fecha_oc,
                        numero_oc = v_numero_oc
                        where id_cotizacion = v_parametros.id_cotizacion;*/
               
               
               END IF;
               
            
          
           --  si el numero de orden de compra se genera an solicitar aprobacion 
        
         END IF;
          
          
          
          
        
         --------------------------------------------- 
         -- Verifica  los posibles estados sigueintes para que desde la interfza se tome la decision si es necesario
         --------------------------------------------------
          IF  v_parametros.operacion = 'verificar' THEN
          
                  --buscamos siguiente estado correpondiente al proceso del WF
                 
                  ----- variables de retorno------
                  
                  v_num_estados=0;
                  v_num_funcionarios=0;
                  v_num_deptos=0;
                  
                  --------------------------------- 
                  
                 --obtenemos el estado siguiente
                 SELECT 
                     *
                  into
                    va_id_tipo_estado,
                    va_codigo_estado,
                    va_disparador,
                    va_regla,
                    va_prioridad
                
                FROM wf.f_obtener_estado_wf(v_id_proceso_wf, v_id_estado_wf,NULL,'siguiente'); 
                  
                          
                
                v_num_estados= array_length(va_id_tipo_estado, 1);
                
                IF v_perdir_obs = 'no' THEN
                
                    IF v_num_estados = 1 then
                          -- si solo hay un estado,  verificamos si tiene mas de un funcionario por este estado
                         SELECT 
                         *
                          into
                         v_num_funcionarios 
                         FROM wf.f_funcionario_wf_sel(
                             p_id_usuario, 
                             va_id_tipo_estado[1], 
                             v_fecha_coti, --OJO verificar si la fecha actul nos sir ve o utilizamos la fecha de la solcitud
                             v_id_estado_wf,
                             TRUE) AS (total bigint);
                             
                        IF v_num_funcionarios = 1 THEN
                        -- si solo es un funcionario, recuperamos el funcionario correspondiente
                             SELECT 
                                 id_funcionario
                                   into
                                 v_id_funcionario_estado
                             FROM wf.f_funcionario_wf_sel(
                                 p_id_usuario, 
                                 va_id_tipo_estado[1], 
                                 v_fecha_coti, --OJO verificar si la fecha actul nos sir ve o utilizamos la fecha de la solcitud
                                 v_id_estado_wf,
                                 FALSE) 
                                 AS (id_funcionario integer,
                                   desc_funcionario text,
                                   desc_funcionario_cargo text,
                                   prioridad integer);
                        END IF;    
                             
                      
                      --verificamos el numero de deptos
                      
                        SELECT 
                        *
                        into
                          v_num_deptos 
                       FROM wf.f_depto_wf_sel(
                           p_id_usuario, 
                           va_id_tipo_estado[1], 
                           v_fecha_coti, --OJO verificar si la fecha actul nos sir ve o utilizamos la fecha de la solcitud
                           v_id_estado_wf,
                           TRUE) AS (total bigint);
                           
                      IF v_num_deptos = 1 THEN
                          -- si solo es un funcionario, recuperamos el funcionario correspondiente
                               SELECT 
                                   id_depto
                                     into
                                   v_id_depto_estado
                              FROM wf.f_depto_wf_sel(
                                   p_id_usuario, 
                                   va_id_tipo_estado[1], 
                                   v_fecha_coti, --OJO verificar si la fecha actul nos sir ve o utilizamos la fecha de la solcitud
                                   v_id_estado_wf,
                                   FALSE) 
                                   AS (id_depto integer,
                                     codigo_depto varchar,
                                     nombre_corto_depto varchar,
                                     nombre_depto varchar,
                                     prioridad integer);
                        END IF;
                      
                      
                      
                      
                     
                     END IF;
               
               END IF;
                
                -- si hay mas de un estado disponible  preguntamos al usuario
                v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Verificacion para el siguiente estado)'); 
                v_resp = pxp.f_agrega_clave(v_resp,'estados', array_to_string(va_id_tipo_estado, ','));
                v_resp = pxp.f_agrega_clave(v_resp,'operacion','preguntar_todo');
                v_resp = pxp.f_agrega_clave(v_resp,'num_estados',v_num_estados::varchar);
                v_resp = pxp.f_agrega_clave(v_resp,'num_funcionarios',v_num_funcionarios::varchar);
                v_resp = pxp.f_agrega_clave(v_resp,'num_deptos',v_num_deptos::varchar);
                v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario_estado',v_id_funcionario_estado::varchar);
                v_resp = pxp.f_agrega_clave(v_resp,'id_depto_estado',v_id_depto_estado::varchar);
                v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_estado', va_id_tipo_estado[1]::varchar);
            
            
           ----------------------------------------
           --Se se solicita cambiar de estado a la solicitud
           ------------------------------------------
           ELSEIF  v_parametros.operacion = 'cambiar' THEN
          
          
            
                -- obtener datos tipo estado
                
                select
                 te.codigo
                into
                 v_codigo_estado_siguiente
                from wf.ttipo_estado te
                where te.id_tipo_estado = v_parametros.id_tipo_estado;
                
                IF  pxp.f_existe_parametro('p_tabla','id_depto') THEN
                 
                 v_id_depto = v_parametros.id_depto;
                
                END IF;
                
                
                v_obs=v_parametros.obs;
                
                 
                --pasamos la cotizacion al siguiente estado
           
                 v_id_estado_actual =  wf.f_registra_estado_wf(v_parametros.id_tipo_estado, 
                                                            v_parametros.id_funcionario, 
                                                            v_id_estado_wf, 
                                                            v_id_proceso_wf,
                                                            p_id_usuario,
                                                            v_id_depto,
                                                           'Se requiere VB '||v_num_sol||' Obs:'||v_obs,
                                                           '../../../sis_adquisiciones/vista/cotizacion/CotizacionVbDin.php',
                                                           'CotizacionVbDin');              
               
                
                                
                
                 -- actualiza estado en la solicitud
                
                 -- actualiza estado en la solicitud
            
                 update adq.tcotizacion  c set 
                   id_estado_wf =  v_id_estado_actual,
                   estado = v_codigo_estado_siguiente,
                   id_usuario_mod=p_id_usuario,
                   fecha_mod=now()
                 where c.id_cotizacion  = v_parametros.id_cotizacion;
                 
                 
                 
                            
              
              
               -- si hay mas de un estado disponible  preguntamos al usuario
                v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado)'); 
                v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
          
          
          END IF;

        
          --Devuelve la respuesta
            return v_resp;
        
        end;
    
    
    
    
    /*********************************    
 	#TRANSACCION:  'ADQ_ANTEST_IME'
 	#DESCRIPCION:	Retrocede estados en la cotizacion
 	#AUTOR:	        Rensi Arteaga
 	#FECHA:		21-03-2013 14:48:35
	***********************************/

	elsif(p_transaccion='ADQ_ANTEST_IME')then

		begin
		--------------------------------------------------
        --REtrocede al estado inmediatamente anterior
        -------------------------------------------------
         IF  v_parametros.operacion = 'cambiar' THEN
               
               raise notice 'es_estaado_wf %',v_parametros.id_estado_wf;
              
                      --recuperaq estado anterior segun Log del WF
                      
                        SELECT  
                           ps_id_tipo_estado,
                           ps_id_funcionario,
                           ps_id_usuario_reg,
                           ps_id_depto,
                           ps_codigo_estado,
                           ps_id_estado_wf_ant
                        into
                           v_id_tipo_estado,
                           v_id_funcionario,
                           v_id_usuario_reg,
                           v_id_depto,
                           v_codigo_estado,
                           v_id_estado_wf_ant 
                        FROM wf.f_obtener_estado_ant_log_wf(v_parametros.id_estado_wf);
                     
                     
                       --  recupera el estado actual
                        SELECT
                        co.estado
                        into
                        v_registros
                        FROM adq.tcotizacion co
                        where co.id_cotizacion =v_parametros.id_cotizacion; 
                     
                    
                     
                       IF  v_registros.estado = 'pago_habilitado'  THEN
                       
                         raise exception 'No puede retroceder cuando el pago esta habilitado';
                       
                       END IF;  
                      
                       
                        
                      -- recupera el proceso_wf
                      
                      select 
                           ew.id_proceso_wf 
                        into 
                           v_id_proceso_wf
                      from wf.testado_wf ew
                      where ew.id_estado_wf= v_id_estado_wf_ant;
                      
                      
                      -- registra nuevo estado
                      
                      v_id_estado_actual = wf.f_registra_estado_wf(
                          v_id_tipo_estado, 
                          v_id_funcionario, 
                          v_parametros.id_estado_wf, 
                          v_id_proceso_wf, 
                          p_id_usuario,
                          v_id_depto,
                          'Solictud de Correción/Revisión por retroceso de estado en la cotiazacion');
                      
                    
                      
                        -- actualiza estado en la solicitud
                        update adq.tcotizacion  s set 
                           id_estado_wf =  v_id_estado_actual,
                           estado = v_codigo_estado,
                           id_usuario_mod=p_id_usuario,
                           fecha_mod=now()
                         where id_cotizacion = v_parametros.id_cotizacion;
                         
                         
                      
                      
                        -- cuando el estado al que regresa es  borrador pone en cero las adjudicaciones
                         IF v_codigo_estado = 'borrador'  THEN
                         
                          update adq.tcotizacion_det c set
                            cantidad_adju = 0
                          where id_cotizacion = v_parametros.id_cotizacion;                          
                         
                         END IF;
                         
                         
                        -- si hay mas de un estado disponible  preguntamos al usuario
                        v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado)'); 
                        v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
                        
                              
                      --Devuelve la respuesta
                        return v_resp;
                        
            
             ELSEIF  v_parametros.operacion = 'inicio' THEN
        			 
                   raise exception 'Operacion no implementada';
            
             ELSE
              
                   raise exception 'Operacion no implementada';   
        	 END IF;
        
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cotizaciones eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cotizacion',v_parametros.id_cotizacion::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;   
          
        
            
        
	/*********************************    
 	#TRANSACCION:  'ADQ_FINREGC_IME'
 	#DESCRIPCION:	Finaliza el registro de la cotizacion y pasa al siguiente este que es totizado
                    donde estara listo para adjudicar
 	#AUTOR:	Rensi Arteaga Copari	
 	#FECHA:		21-03-2013 14:48:35
	***********************************/

	elsif(p_transaccion = 'ADQ_FINREGC_IME')then

		begin
			--recupera parametros
			
             select 
              c.id_proceso_wf,
              c.id_estado_wf,
              c.id_proceso_compra,
              c.estado
              
             into
              v_id_proceso_wf,
              v_id_estado_wf,
              v_id_proceso_compra,
              v_estado_cot
             from adq.tcotizacion c
             where c.id_cotizacion = v_parametros.id_cotizacion; 
             
             --VALIDACIONES
             
             IF  v_estado_cot != 'borrador' THEN
             
              raise exception 'Solo se admiten cotizaciones en borrador';
             END IF;
             
             
             --validamos que el detalle tenga por lo menos un item con valor
             
             select 
              sum(cd.precio_unitario*cd.cantidad_coti)
             into
              v_total_detalle
             from adq.tcotizacion_det cd
             where cd.id_cotizacion = v_parametros.id_cotizacion; 
             
             IF v_total_detalle = 0 or v_total_detalle is null THEN
             
                 raise exception 'No hay nada cotizado...';
             
             END IF; 
             
             
             select 
             	pc.id_depto
             into 
             	v_id_depto
             from adq.tproceso_compra pc where pc.id_proceso_compra = v_id_proceso_compra;
             
             
             SELECT 
                 *
              into
                va_id_tipo_estado,
                va_codigo_estado,
                va_disparador,
                va_regla,
                va_prioridad
            
            FROM wf.f_obtener_estado_wf(v_id_proceso_wf, v_id_estado_wf,NULL,'siguiente');
            
            
            
            IF va_codigo_estado[2] is not null THEN
            
             raise exception 'El proceso de WF esta mal parametrizado, el estado borrador de cotizacion solo admite un estado ';
            
            END IF;
            
             IF va_codigo_estado[1] is  null THEN
            
             raise exception 'El proceso de WF esta mal parametrizado, no se encuentra el estado siguiente ';
            
            END IF;
            
            
          
            
            -- hay que recuperar el supervidor que seria el estado inmediato,...
             v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado[1], 
                                                           NULL, 
                                                           v_id_estado_wf, 
                                                           v_id_proceso_wf,
                                                           p_id_usuario,
                                                           v_id_depto);
            
            
             -- actualiza estado en la solicitud
            
             update adq.tcotizacion  c set 
               id_estado_wf =  v_id_estado_actual,
               estado = va_codigo_estado[1],
               id_usuario_mod=p_id_usuario,
               fecha_mod=now()
             where c.id_cotizacion  = v_parametros.id_cotizacion;
            
           
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Finalizacion del registro de la cotizacion'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cotizacion',v_parametros.id_cotizacion::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;     
	     
	/*********************************    
 	#TRANSACCION:  'ADQ_HABPAG_IME'
 	#DESCRIPCION:	Habilita los pagos en tesoreria en modulo de cuentas por pagar
 	#AUTOR:     	Rensi Arteaga Copari	
 	#FECHA:		    05-04-2013 14:48:35
	***********************************/

	elsif(p_transaccion = 'ADQ_HABPAG_IME')then

		begin
			--recupera parametros
			
            select 
           	 s.id_subsistema
            into
            	v_id_subsistema
            from segu.tsubsistema s 
            where s.codigo = 'ADQ';
            
            
            ----------------------------------
            --recuperar datos de la cotizacion e inserta en oblligacion
            --------------------------
      
            select 
              c.numero_oc,
              c.id_proveedor,
              c.id_estado_wf,
              c.id_proceso_wf,
              c.id_moneda,
              pc.id_depto,
              pc.num_tramite,
              c.estado,
              c.tipo_cambio_conv,
              sol.id_gestion
            into
             v_numero_oc,
             v_id_proveedor,
             v_id_estado_wf_cot,
             v_id_proceso_wf_cot,
             v_id_moneda,
             v_id_depto,
             v_num_tramite,
             v_codigo_estado,
             v_tipo_cambio_conv,
             v_id_gestion
            from adq.tcotizacion c
            inner join adq.tproceso_compra pc on pc.id_proceso_compra = c.id_proceso_compra
            inner join adq.tsolicitud sol on sol.id_solicitud = pc.id_solicitud
            WHERE c.id_cotizacion = v_parametros.id_cotizacion;            
            
            IF  v_codigo_estado != 'adjudicado' THEN
            
          	  raise exception 'Solo pueden habilitarce pago para cotizaciones adjudicadas';
            
            END IF;
            
            
            INSERT INTO 
              tes.tobligacion_pago
            (
              id_usuario_reg,
              fecha_reg,
              estado_reg,
              id_proveedor,
              id_subsistema,
              id_moneda,
              id_depto,
              tipo_obligacion,
              fecha,
              numero,
              tipo_cambio_conv,
              num_tramite,
              id_gestion,
              comprometido
            ) 
            VALUES (
              p_id_usuario,
              now(),
              'activo',
              v_id_proveedor,
              v_id_subsistema,
              v_id_moneda,
              v_parametros.id_depto_tes,
              'adquisiciones',
              now(),
              v_numero_oc,
              v_tipo_cambio_conv,
              v_num_tramite,
              v_id_gestion,
              'si'
            ) RETURNING id_obligacion_pago into v_id_obligacion_pago;
    
            
            
            update adq.tcotizacion set
            id_obligacion_pago = v_id_obligacion_pago
            where id_cotizacion = v_parametros.id_cotizacion;
            
            
            -----------------------------------------------------------------------------
            --recupera datos del detalle de cotizacion e inserta en detalle de obligacion
            -----------------------------------------------------------------------------
            
            FOR v_registros in (
              select 
                cd.id_cotizacion_det,
                sd.id_concepto_ingas,
                sd.id_cuenta,
                sd.id_auxiliar,
                sd.id_partida,
                sd.id_partida_ejecucion,
                cd.cantidad_adju,
                cd.precio_unitario,
                cd.precio_unitario_mb,
                sd.id_centro_costo,
                sd.descripcion
              from adq.tcotizacion_det cd
              inner join adq.tsolicitud_det sd on sd.id_solicitud_det = cd.id_solicitud_det
              where cd.id_cotizacion = v_parametros.id_cotizacion 
                    and cd.estado_reg='activo'
              
            )LOOP
            
            
              --TO DO,  para el pago de dos gestion  gestion hay que  
              --        mandar solamente el total comprometido  de la gestion actual menos el revrtido
              --         o el monto total adjudicado, el que sea menor.  
            
               -- inserta detalle obligacion
                IF((v_registros.cantidad_adju *v_registros.precio_unitario) > 0)THEN
                   
                       INSERT INTO 
                        tes.tobligacion_det
                      (
                        id_usuario_reg,
                        fecha_reg,
                         estado_reg,
                        id_obligacion_pago,
                        id_concepto_ingas,
                        id_centro_costo,
                        id_partida,
                        id_cuenta,
                        id_auxiliar,
                        id_partida_ejecucion_com,
                        monto_pago_mo,
                        monto_pago_mb,
                        descripcion) 
                      VALUES (
                        p_id_usuario,
                        now(),
                        'activo',
                        v_id_obligacion_pago,
                        v_registros.id_concepto_ingas,
                        v_registros.id_centro_costo,
                        v_registros.id_partida,
                        v_registros.id_cuenta,
                        v_registros.id_auxiliar,
                        v_registros.id_partida_ejecucion,
                        (v_registros.cantidad_adju *v_registros.precio_unitario), 
                        (v_registros.cantidad_adju *v_registros.precio_unitario_mb),
                        v_registros.descripcion
                      )RETURNING id_obligacion_det into v_id_obligacion_det;
                       
                       -- actulizar detalle de cotizacion
                       
                       update adq.tcotizacion_det set 
                       id_obligacion_det = v_id_obligacion_det
                       where id_cotizacion_det=v_registros.id_cotizacion_det;
                   
               END IF;
            
            END LOOP;
            -----------------------------------------
            --cambia de estado la cotizacion
            ----------------------------------------
            
            SELECT 
                 *
              into
                va_id_tipo_estado,
                va_codigo_estado,
                va_disparador,
                va_regla,
                va_prioridad
            
            FROM wf.f_obtener_estado_wf(v_id_proceso_wf_cot, v_id_estado_wf_cot,NULL,'siguiente');
            
            
            
            IF va_codigo_estado[2] is not null THEN
            
             raise exception 'El proceso de WF esta mal parametrizado, el estado adjudicado de la cotizacion solo admite un estado ';
            
            END IF;
            
             IF va_codigo_estado[1] is  null THEN
            
             raise exception 'El proceso de WF esta mal parametrizado, no se encuentra el estado siguiente ';
            
            END IF;
            
            -- hay que registrar el estado actual de la cotizacion..
             v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado[1], 
                                                           NULL, 
                                                           v_id_estado_wf_cot, 
                                                           v_id_proceso_wf_cot,
                                                           p_id_usuario,
                                                           v_id_depto);
            
            
             -- actualiza estado en la solicitud
            
             update adq.tcotizacion  c set 
               id_estado_wf =  v_id_estado_actual,
                estado = va_codigo_estado[1],
               id_usuario_mod=p_id_usuario,
               fecha_mod=now()
             where c.id_cotizacion  = v_parametros.id_cotizacion;
            
            
            -----------------------------------------
            --inicia tramite para obligacion, y registra el estado de la obligacion
            ----------------------------------------
             
            --registra estado de cotizacion

             SELECT
                       ps_id_proceso_wf,
                       ps_id_estado_wf,
                       ps_codigo_estado
                 into
                       v_id_proceso_wf,
                       v_id_estado_wf,
                       v_codigo_estado
              FROM wf.f_registra_proceso_disparado_wf(
                       p_id_usuario,
                       v_id_estado_actual, 
                       NULL, 
                       v_parametros.id_depto_tes,
                       '---',
                       'OBLI');
        
             update tes.tobligacion_pago  o set 
               id_estado_wf =  v_id_estado_wf,
               id_proceso_wf = v_id_proceso_wf,
               estado = v_codigo_estado,
               id_usuario_mod=p_id_usuario,
               fecha_mod=now()
             where o.id_obligacion_pago  = v_id_obligacion_pago;
        
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Finalizacion del registro de la cotizacion'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cotizacion',v_parametros.id_cotizacion::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
     /*********************************    
 	#TRANSACCION:  'ADQ_OBEPUO_IME'
 	#DESCRIPCION:	Obtener listado de up y ep correspondientes a los centros de costo
                    del detalle de la cotizacion adjudicados al proveedor 
                    
 	#AUTOR:	        Rensi Arteaga Copari
 	#FECHA:		    1-4-2013 14:48:35
	***********************************/

	elsif(p_transaccion='ADQ_OBEPUO_IME')then

		begin
			
         
        
            select 
              pxp.list(cc.id_uo::text),
              pxp.list(cc.id_ep::text)
            into
              v_cad_uo,
              v_cad_ep
            from adq.tcotizacion_det cd
            inner join adq.tsolicitud_det sd on sd.id_solicitud_det = cd.id_solicitud_det
            inner join param.tcentro_costo cc on sd.id_centro_costo = cc.id_centro_costo
            where cd.id_cotizacion = v_parametros.id_cotizacion 
            and cd.estado_reg = 'activo' and cd.cantidad_adju > 0;
        
           
             --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','UOs, EPs retornados'); 
            v_resp = pxp.f_agrega_clave(v_resp,'eps',v_cad_ep::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'uos',v_cad_uo::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
		
	/*********************************    
 	#TRANSACCION:  'ADQ_PREING_GEN'
 	#DESCRIPCION:	Genera el preingreso a almacén o activos
 	#AUTOR:	        RCM
 	#FECHA:		    02/10/2013
	***********************************/

	elsif(p_transaccion='ADQ_PREING_GEN')then

		begin

			--Llamada a función de generación del preingreso			
         	v_result = adq.f_genera_preingreso(p_id_usuario, v_parametros.id_cotizacion);
        
             --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje',v_result); 
              
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