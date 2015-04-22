/***********************************I-SCP-RAC-ADQ-1-01/01/2013****************************************/
CREATE TABLE adq.tcategoria_compra(
    id_categoria_compra SERIAL NOT NULL,
    codigo varchar(15),
    nombre varchar(255),
    min numeric(19, 0),
    max numeric(19, 0),
    obs varchar(255),
    PRIMARY KEY (id_categoria_compra))INHERITS (pxp.tbase);

   
CREATE TABLE adq.tdocumento_sol(
    id_documento_sol SERIAL NOT NULL,
    id_solicitud int4,
    id_categoria_compra int4 NOT NULL,
    nombre_tipo_doc varchar(255),
    nombre_doc varchar(255),
    nombre_arch_doc varchar(150),
    chequeado varchar(5),
    archivo BYTEA,
    extension VARCHAR(10),
    PRIMARY KEY (id_documento_sol))INHERITS (pxp.tbase);   

  
  CREATE TABLE adq.tsolicitud (
	  id_solicitud SERIAL, 
	  id_funcionario INTEGER NOT NULL, 
	  id_uo INTEGER,
	  id_solicitud_ext INTEGER, 
	  id_categoria_compra INTEGER NOT NULL, 
	  id_moneda INTEGER NOT NULL, 
	  id_proceso_macro INTEGER NOT NULL, 
	  id_gestion INTEGER NOT NULL, 
	  id_funcionario_aprobador INTEGER, 
	  id_funcionario_rpc INTEGER, 
	  id_depto INTEGER NOT NULL, 
	  id_estado_wf INTEGER,
	  id_proceso_wf INTEGER,  
	  numero varchar(100),
	  extendida VARCHAR(2), 
	  tipo VARCHAR(50), 
	  estado VARCHAR(50), 
	  fecha_soli DATE, 
	  fecha_apro DATE, 
	  lugar_entrega VARCHAR(255), 
	  justificacion TEXT, 
	  posibles_proveedores TEXT, 
	  comite_calificacion TEXT, 
	  presu_revertido VARCHAR(2), 
	  num_tramite VARCHAR(200), 
	  presu_comprometido VARCHAR(2) NOT NULL  DEFAULT 'no'::varchar,
	  instruc_rpc VARCHAR(100), 
	  PRIMARY KEY (id_solicitud)
	  
	) INHERITS (pxp.tbase)
	WITHOUT OIDS;
  
  

CREATE TABLE adq.tsolicitud_det(
    id_solicitud_det SERIAL NOT NULL,
    id_solicitud int4 NOT NULL,
    id_centro_costo int4 NOT NULL,
    id_partida int4 NOT NULL,
    id_cuenta int4 NOT NULL,
    id_auxiliar int4 NOT NULL,
    id_concepto_ingas int4 NOT NULL,
    id_partida_ejecucion int4,
    id_orden_trabajo int4,
   
    precio_unitario numeric(19, 2),
    precio_unitario_mb numeric(19,2),
    cantidad int4,
    precio_total numeric(19, 2),
    precio_ga numeric(19, 2),
    precio_sg numeric(19, 2),
    precio_ga_mb numeric(19,2),
    precio_sg_mb numeric(19,2),
    descripcion text,
    PRIMARY KEY (id_solicitud_det))INHERITS (pxp.tbase);
    
 CREATE TABLE adq.tproceso_compra(
    id_proceso_compra SERIAL NOT NULL,
    id_solicitud int4 NOT NULL,
    id_depto int4 NOT NULL,
    id_estado_wf int4,
    id_proceso_wf int4,
    codigo_proceso varchar(50),
    obs_proceso varchar(500),
    estado varchar(30),
    fecha_ini_proc date,
    num_cotizacion varchar(30),
    num_convocatoria varchar(30),
    num_tramite varchar(200),
    PRIMARY KEY (id_proceso_compra)
    )INHERITS (pxp.tbase); 
    
      
    
 CREATE TABLE adq.tcotizacion(
    id_cotizacion SERIAL NOT NULL,
    id_proceso_compra int4 NOT NULL,
    id_proveedor int4 NOT NULL,
    id_moneda int4 NOT NULL,
    id_estado_wf int4,
    id_proceso_wf int4 ,
    id_obligacion_pago int4,
    numero_oc varchar(50),
    estado varchar(30),
    fecha_coti date,
    fecha_adju date,
    fecha_entrega date,
    obs text,
    fecha_venc date,
    lugar_entrega varchar(500),
    tipo_entrega varchar(40),
    nro_contrato varchar(50),
    tipo_cambio_conv NUMERIC(18,2),
    PRIMARY KEY (id_cotizacion))INHERITS (pxp.tbase);
    
 

CREATE TABLE adq.tcotizacion_det(
    id_cotizacion_det SERIAL NOT NULL,
    id_cotizacion int4 NOT NULL,
    id_solicitud_det int4 NOT NULL,
    id_obligacion_det integer,
    precio_unitario numeric(19, 2),
    precio_unitario_mb numeric(19,2),
    cantidad_coti numeric(19, 0),
    cantidad_adju numeric(19, 0),
    obs varchar(500),
    PRIMARY KEY (id_cotizacion_det))INHERITS (pxp.tbase);
    

     

/***********************************F-SCP-RAC-ADQ-1-01/01/2013****************************************/

/***********************************I-SCP-JRR-ADQ-104-04/04/2013****************************************/

ALTER TABLE adq.tcategoria_compra
  ADD COLUMN id_proceso_macro INTEGER;
  
/***********************************F-SCP-JRR-ADQ-104-04/04/2013****************************************/



/***********************************I-SCP-RAC-ADQ-146-13/05/2013****************************************/

CREATE TABLE adq.tgrupo(
    id_grupo SERIAL NOT NULL,
    nombre varchar(200),
    obs text,
    PRIMARY KEY (id_grupo))
    INHERITS (pxp.tbase);


CREATE TABLE adq.tgrupo_usuario(
    id_grupo_usuario SERIAL NOT NULL,
    id_grupo int4 NOT NULL,
    id_usuario int4,
    obs text,
    PRIMARY KEY (id_grupo_usuario))INHERITS (pxp.tbase);


CREATE TABLE adq.tgrupo_partida(
    id_grupo_partida SERIAL NOT NULL,
    id_grupo int4 NOT NULL,
    id_partida int4,
    id_gestion int4,
    PRIMARY KEY (id_grupo_partida))
INHERITS (pxp.tbase);

CREATE TABLE adq.tpresolicitud(
    id_presolicitud SERIAL NOT NULL,
    id_grupo int4 NOT NULL,
    id_funcionario int4,
    id_funcionario_supervisor int4,
    id_uo int4,
    id_solicitudes int4,
    estado varchar(30),
    obs text,
    fecha_soli DATE DEFAULT now() NOT NULL, 
    PRIMARY KEY (id_presolicitud))
INHERITS (pxp.tbase);  

CREATE TABLE adq.tpresolicitud_det(
    id_presolicitud_det SERIAL NOT NULL,
    id_presolicitud int4 NOT NULL,
    id_solicitud_det int4,
    id_concepto_ingas int4,
    id_centro_costo int4,
    descripcion text,
    cantidad numeric(19, 2),
    estado varchar(30),
    PRIMARY KEY (id_presolicitud_det))
INHERITS (pxp.tbase);


/***********************************F-SCP-RAC-ADQ-146-13/05/2013****************************************/



/***********************************I-SCP-RAC-ADQ-0-05/05/2013****************************************/

ALTER TABLE adq.tpresolicitud
  ADD COLUMN id_depto INTEGER;
  
ALTER TABLE adq.tpresolicitud
  ADD COLUMN id_gestion INTEGER;  

--------------- SQL ---------------

ALTER TABLE adq.tpresolicitud
  ALTER COLUMN id_gestion SET NOT NULL;

/***********************************F-SCP-RAC-ADQ-0-05/05/2013****************************************/


/***********************************I-SCP-RAC-ADQ-0-27/06/2013****************************************/

ALTER TABLE adq.tsolicitud_det
  ADD COLUMN revertido_mb NUMERIC DEFAULT 0 NOT NULL;

/***********************************F-SCP-RAC-ADQ-0-27/06/2013****************************************/


/***********************************I-SCP-RAC-ADQ-0-06/12/2013****************************************/

--------------- SQL ---------------

ALTER TABLE adq.tproceso_compra
  ADD COLUMN id_usuario_auxiliar INTEGER;

COMMENT ON COLUMN adq.tproceso_compra.id_usuario_auxiliar
IS 'este campo identifica el usuario que pueden trabajar en el proceso de compra, ser ecupera de la configuracion del depto_usuario';

/***********************************F-SCP-RAC-ADQ-0-06/12/2013****************************************/



/***********************************I-SCP-RAC-ADQ-0-12/01/2014****************************************/

ALTER TABLE adq.tdocumento_sol
  ADD COLUMN id_proveedor INTEGER;
  
--------------- SQL ---------------

COMMENT ON COLUMN adq.tdocumento_sol.id_proveedor
IS 'cuando el tipo de documento sea del tipo precotiacion,  este campo senhala el proveedor correspondiente';  
  
/***********************************F-SCP-RAC-ADQ-0-12/01/2014****************************************/



/***********************************I-SCP-RAC-ADQ-0-17/01/2014****************************************/


ALTER TABLE adq.tcotizacion
  ADD COLUMN num_tramite VARCHAR(100);
  


/***********************************F-SCP-RAC-ADQ-0-17/01/2014****************************************/


/***********************************I-SCP-RAC-ADQ-0-26/01/2014****************************************/

--------------- SQL ---------------

ALTER TABLE adq.tsolicitud
  ADD COLUMN id_proveedor INTEGER;

COMMENT ON COLUMN adq.tsolicitud.id_proveedor
IS 'almacena el proveedor de la precotizacion';

/***********************************F-SCP-RAC-ADQ-0-26/01/2014****************************************/



/***********************************I-SCP-RAC-ADQ-0-29/01/2014****************************************/


ALTER TABLE adq.tsolicitud_det
  ADD COLUMN revertido_mo NUMERIC(12,2) DEFAULT 0 NOT NULL;
  
/***********************************F-SCP-RAC-ADQ-0-29/01/2014****************************************/

/***********************************I-SCP-RAC-ADQ-0-27/03/2014****************************************/

ALTER TABLE adq.tsolicitud
  ADD COLUMN id_funcionario_supervisor INTEGER;

/***********************************F-SCP-RAC-ADQ-0-27/03/2014****************************************/



/***********************************I-SCP-RAC-ADQ-0-19/05/2014****************************************/

--------------- SQL ---------------

ALTER TABLE adq.tcotizacion
  ADD COLUMN tiempo_entrega VARCHAR(350);

ALTER TABLE adq.tcotizacion
  ALTER COLUMN tiempo_entrega SET DEFAULT 'xx dias a partir de la recepción de la presente';

/***********************************F-SCP-RAC-ADQ-0-19/05/2014****************************************/





/***********************************I-SCP-RAC-ADQ-0-29/05/2014****************************************/


CREATE TABLE adq.trpc (
  id_rpc SERIAL NOT NULL, 
  id_cargo INTEGER NOT NULL, 
  id_cargo_ai INTEGER, 
  ai_habilitado BOOLEAN NOT NULL, 
  PRIMARY KEY(id_rpc)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

ALTER TABLE adq.trpc
  ALTER COLUMN id_cargo_ai SET STATISTICS 0;

--------------- SQL ---------------

ALTER TABLE adq.trpc
  ALTER COLUMN ai_habilitado TYPE VARCHAR(3);
  
--------------- SQL ---------------
ALTER TABLE adq.trpc
  ALTER COLUMN ai_habilitado SET DEFAULT 'no';  


CREATE TABLE adq.trpc_uo (
  id_rpc_uo SERIAL NOT NULL, 
  id_rpc INTEGER NOT NULL, 
  id_uo INTEGER NOT NULL, 
  fecha_ini DATE NOT NULL,
  fecha_fin date,
  monto_min numeric NOT NULL,
  monto_max numeric,  
  PRIMARY KEY(id_rpc_uo)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

ALTER TABLE adq.trpc_uo
  ADD COLUMN id_categoria_compra INTEGER NOT NULL;



/***********************************F-SCP-RAC-ADQ-0-29/05/2014****************************************/


/***********************************I-SCP-RAC-ADQ-0-30/05/2014****************************************/
ALTER TABLE adq.tsolicitud
  ADD COLUMN id_cargo_rpc INTEGER;
  
 --------------- SQL ---------------

ALTER TABLE adq.tsolicitud
  ADD COLUMN id_cargo_rpc_ai INTEGER;

--------------- SQL ---------------

ALTER TABLE adq.tsolicitud
  ADD COLUMN ai_habilitado VARCHAR(4) DEFAULT 'no' NOT NULL;

/***********************************F-SCP-RAC-ADQ-0-30/05/2014****************************************/




/***********************************I-SCP-RAC-ADQ-0-02/06/2014****************************************/

CREATE TABLE adq.trpc_uo_log (
  id_rpc_uo_log SERIAL, 
  id_rpc_uo INTEGER, 
  id_rpc INTEGER, 
  fecha_ini DATE, 
  fecha_fin DATE, 
  monto_min NUMERIC, 
  monto_max NUMERIC, 
  id_uo INTEGER , 
  id_categoria_compra INTEGER,
  operacion varchar,
  descripcion text,
  id_cargo_ai INTEGER,
  id_cargo INTEGER,
  ai_habilitado varchar
) INHERITS (pxp.tbase)
WITHOUT OIDS;

/***********************************F-SCP-RAC-ADQ-0-02/06/2014****************************************/



/***********************************I-SCP-RAC-ADQ-0-03/06/2014****************************************/

--------------- SQL ---------------

ALTER TABLE adq.trpc_uo_log
  ADD PRIMARY KEY (id_rpc_uo_log);

/***********************************F-SCP-RAC-ADQ-0-03/06/2014****************************************/


/***********************************I-SCP-RAC-ADQ-0-08/08/2014****************************************/

--------------- SQL ---------------

ALTER TABLE adq.tsolicitud
  ADD COLUMN tipo_concepto VARCHAR(50) DEFAULT 'normal' NOT NULL;
  
ALTER TABLE adq.tcotizacion
  ADD COLUMN forma_pago VARCHAR(500);
/***********************************F-SCP-RAC-ADQ-0-08/08/2014****************************************/



/***********************************I-SCP-RAC-ADQ-0-23/09/2014****************************************/

--------------- SQL ---------------

ALTER TABLE adq.tsolicitud
  ADD COLUMN revisado_asistente VARCHAR(4) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN adq.tsolicitud.revisado_asistente
IS 'sirve para indicar si el asistente reviso la documentacion';

/***********************************F-SCP-RAC-ADQ-0-23/09/2014****************************************/



/***********************************I-SCP-RAC-ADQ-0-24/09/2014****************************************/

--------------- SQL ---------------

ALTER TABLE adq.tsolicitud
  ADD COLUMN fecha_inicio DATE;

COMMENT ON COLUMN adq.tsolicitud.fecha_inicio
IS 'Fecha estimada de entrega de la compra o inicio del servicio';


--------------- SQL ---------------

ALTER TABLE adq.tsolicitud
  ADD COLUMN dias_plazo_entrega INTEGER;

COMMENT ON COLUMN adq.tsolicitud.dias_plazo_entrega
IS 'Dias calendario para el plazo de entrega una vez emitida la orden de compra(solo se usa para bienes)';



/***********************************F-SCP-RAC-ADQ-0-24/09/2014****************************************/

/***********************************I-SCP-RAC-ADQ-0-26/09/2014****************************************/

--------------- SQL ---------------

ALTER TABLE adq.tcotizacion
  ADD COLUMN funcionario_contacto VARCHAR(500);

COMMENT ON COLUMN adq.tcotizacion.funcionario_contacto
IS 'funcionario de contacto para el proveedor';


--------------- SQL ---------------

ALTER TABLE adq.tcotizacion
  ADD COLUMN telefono_contacto VARCHAR(200);
  
  
--------------- SQL ---------------

ALTER TABLE adq.tcotizacion
  ADD COLUMN correo_contacto VARCHAR(200);


--------------- SQL ---------------

ALTER TABLE adq.tcotizacion
  ADD COLUMN prellenar_oferta VARCHAR(4) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN adq.tcotizacion.prellenar_oferta
IS 'si o no, cuando le damos si copia los precios y cantidad de la solicitud de compra';

--------------- SQL ---------------



/***********************************F-SCP-RAC-ADQ-0-26/09/2014****************************************/

/***********************************I-SCP-JRR-ADQ-0-01/10/2014****************************************/

ALTER TABLE adq.tcotizacion
  ADD COLUMN requiere_contrato VARCHAR(2) DEFAULT 'no' NOT NULL;
  
ALTER TABLE adq.tcotizacion
  ALTER COLUMN nro_contrato SET DEFAULT '0';
  
/***********************************F-SCP-JRR-ADQ-0-01/10/2014****************************************/



/***********************************I-SCP-RAC-ADQ-0-05/10/2014****************************************/

--------------- SQL ---------------

ALTER TABLE param.tconcepto_ingas
  ADD COLUMN id_grupo_ots INTEGER[];

COMMENT ON COLUMN param.tconcepto_ingas.id_grupo_ots
IS 'lamacena las ot que pueden relacionarce con este el concepto de gasto';

/***********************************F-SCP-RAC-ADQ-0-05/10/2014****************************************/

/***********************************I-SCP-RAC-ADQ-0-21/10/2014****************************************/

--------------- SQL ---------------

DROP VIEW IF EXISTS adq.vcotizacion;
--------------- SQL ---------------

DROP VIEW IF EXISTS adq.vproceso_compra;
--------------- SQL ---------------

DROP VIEW IF EXISTS adq.vproceso_compra_wf;
--------------- SQL ---------------

DROP VIEW IF EXISTS adq.vsolicitud_compra;

ALTER TABLE adq.tcotizacion_det
  ALTER COLUMN precio_unitario TYPE NUMERIC(19,3);
  
--------------- SQL ---------------

ALTER TABLE adq.tcotizacion_det
  ALTER COLUMN precio_unitario_mb TYPE NUMERIC(19,3);

--------------- SQL ---------------

ALTER TABLE adq.tsolicitud_det
  ALTER COLUMN precio_unitario TYPE NUMERIC(19,3);

--------------- SQL ---------------

ALTER TABLE adq.tsolicitud_det
  ALTER COLUMN precio_unitario_mb TYPE NUMERIC(19,3);

/***********************************F-SCP-RAC-ADQ-0-21/10/2014****************************************/



/***********************************I-SCP-RAC-ADQ-0-29/12/2014****************************************/

--------------- SQL ---------------

ALTER TABLE adq.tproceso_compra
  ADD COLUMN objeto VARCHAR;

COMMENT ON COLUMN adq.tproceso_compra.objeto
IS 'Campo opcional para resumir el objeto del contrato, este campo se  refleja en la carta de adjudicacion';

/***********************************F-SCP-RAC-ADQ-0-29/12/2014****************************************/

/***********************************I-SCP-RAC-ADQ-0-11/01/2015****************************************/

--------------- SQL ---------------

ALTER TABLE adq.tsolicitud
  ADD COLUMN obs_presupuestos VARCHAR;

COMMENT ON COLUMN adq.tsolicitud.obs_presupuestos
IS 'Observaciones del area de presupuesto que se van concatenando cada vez que pasa por el estado vbpresupeustos del WF';

/***********************************F-SCP-RAC-ADQ-0-11/01/2015****************************************/



/***********************************I-SCP-RAC-ADQ-0-24/03/2015****************************************/

--------------- SQL ---------------

ALTER TABLE adq.tsolicitud
  ADD COLUMN precontrato VARCHAR(4);

ALTER TABLE adq.tsolicitud
  ALTER COLUMN precontrato SET DEFAULT 'no';

COMMENT ON COLUMN adq.tsolicitud.precontrato
IS 'identifica si la solcitud va adjuntar un precontrato,  o contrato de adhesion';

/***********************************F-SCP-RAC-ADQ-0-24/03/2015****************************************/


/***********************************I-SCP-RAC-ADQ-0-25/03/2015****************************************/

--------------- SQL ---------------

ALTER TABLE adq.tcotizacion
  ADD COLUMN tiene_form500 VARCHAR(13) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN adq.tcotizacion.tiene_form500
IS 'no, requiere, o si';

/***********************************F-SCP-RAC-ADQ-0-25/03/2015****************************************/

/***********************************I-SCP-JRR-ADQ-0-22/04/2015****************************************/
ALTER TABLE adq.tsolicitud
  ADD COLUMN update_enable VARCHAR(2) DEFAULT 'no' NOT NULL;
/***********************************F-SCP-JRR-ADQ-0-22/04/2015****************************************/