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



/***********************************I-SCP-RAC-ADQ-0-08/05/2015****************************************/

--------------- SQL ---------------

ALTER TABLE adq.tcotizacion
ADD COLUMN correo_oc VARCHAR(20) DEFAULT 'ninguno' NOT NULL;

COMMENT ON COLUMN adq.tcotizacion.correo_oc
IS 'valores ninguno, bloqueado, pendiente, acuse';

ALTER TABLE adq.tsolicitud
ADD COLUMN codigo_poa VARCHAR;

COMMENT ON COLUMN adq.tsolicitud.codigo_poa
IS 'para cruzar con las actividades de POA';

ALTER TABLE adq.tsolicitud
ADD COLUMN obs_poa VARCHAR;

COMMENT ON COLUMN adq.tsolicitud.obs_poa
IS 'Observacion en visto bueno POA';

/***********************************F-SCP-RAC-ADQ-0-08/05/2015****************************************/

/***********************************I-SCP-GSS-ADQ-0-04/11/2015****************************************/

--------------- SQL ---------------

ALTER TABLE param.tproveedor
ADD COLUMN contacto TEXT;

COMMENT ON COLUMN param.tproveedor.contacto
IS 'contacto del proveedor';

/***********************************F-SCP-GSS-ADQ-0-04/11/2015****************************************/


/***********************************I-SCP-RAV-ADQ-0-08/12/2015****************************************/

--------------- SQL ---------------

ALTER TABLE adq.tcotizacion
ALTER COLUMN tipo_cambio_conv TYPE NUMERIC;

/***********************************F-SCP-RAC-ADQ-0-08/12/2015****************************************/



/***********************************I-SCP-RAC-ADQ-0-27/07/2017****************************************/
--Algun chapulin (o varios) se olvido subir estos script al pacht

CREATE SEQUENCE adq.tcomision_id_integrante_seq
INCREMENT 1 MINVALUE 1
MAXVALUE 9223372036854775807 START 1
CACHE 1;

ALTER SEQUENCE adq.tcomision_id_integrante_seq RESTART WITH 5;

CREATE SEQUENCE adq.tinforme_especificacion_id_informe_especificacion_seq
INCREMENT 1 MINVALUE 1
MAXVALUE 9223372036854775807 START 1
CACHE 1;

ALTER SEQUENCE adq.tinforme_especificacion_id_informe_especificacion_seq RESTART WITH 39;


CREATE TABLE adq.tcomision (
id_usuario_reg INTEGER,
id_usuario_mod INTEGER,
fecha_reg TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
fecha_mod TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
estado_reg VARCHAR(10) DEFAULT 'activo'::character varying,
id_usuario_ai INTEGER,
usuario_ai VARCHAR(300),
id_integrante INTEGER DEFAULT nextval('adq.tcomision_id_integrante_seq'::regclass) NOT NULL,
id_funcionario INTEGER NOT NULL,
orden NUMERIC(4,2),
CONSTRAINT tcomision_pkey PRIMARY KEY(id_integrante)
) INHERITS (pxp.tbase)
;

ALTER SEQUENCE adq.tcomision_id_integrante_seq OWNED BY adq.tcomision.id_integrante;

CREATE TABLE adq.tinformacion_secundaria (
id_usuario_reg INTEGER,
id_usuario_mod INTEGER,
fecha_reg TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
fecha_mod TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
estado_reg VARCHAR(10) DEFAULT 'activo'::character varying,
id_usuario_ai INTEGER,
usuario_ai VARCHAR(300),
id_informacion_sec INTEGER DEFAULT nextval('adq.tinforme_especificacion_id_informe_especificacion_seq'::regclass) NOT NULL,
id_solicitud INTEGER,
nro_cite VARCHAR(25),
antecedentes TEXT,
necesidad_contra TEXT,
beneficios_contra TEXT,
resultados TEXT,
concluciones_r TEXT,
validez_oferta TEXT,
garantias TEXT,
multas TEXT,
forma_pago TEXT,
CONSTRAINT tinforme_especificacion_pkey PRIMARY KEY(id_informacion_sec)
) INHERITS (pxp.tbase)
;



ALTER TABLE adq.tinformacion_secundaria
ADD CONSTRAINT tinforme_especificacion_fk FOREIGN KEY (id_solicitud)
REFERENCES adq.tsolicitud(id_solicitud)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



ALTER TABLE adq.tsolicitud
ALTER COLUMN dias_plazo_entrega TYPE VARCHAR(50) COLLATE pg_catalog."default";

ALTER TABLE adq.tsolicitud
ALTER COLUMN precontrato SET DEFAULT 'no_necesita'::character varying;


COMMENT ON COLUMN adq.tsolicitud.obs_poa
IS 'Observacion en bisto bueno POA';

ALTER TABLE adq.tsolicitud
ADD COLUMN nro_po VARCHAR(25);

ALTER TABLE adq.tsolicitud
ADD COLUMN fecha_po DATE;


ALTER TABLE adq.tsolicitud
ADD COLUMN nro_cite_rpc VARCHAR(30);

COMMENT ON COLUMN adq.tsolicitud.nro_cite_rpc
IS 'Guarda el numero de cite para memorandum de designacion';

ALTER TABLE adq.tsolicitud
ADD COLUMN nro_cite_informe VARCHAR(30);

COMMENT ON COLUMN adq.tsolicitud.nro_cite_informe
IS 'Guarda el numero de cite para Informe de una solicitud.';

ALTER TABLE adq.tsolicitud
ADD COLUMN fecha_fin DATE;


ALTER TABLE adq.tsolicitud
ADD COLUMN proveedor_unico BOOLEAN;

ALTER TABLE adq.tsolicitud
ADD COLUMN nro_cuotas INTEGER;

COMMENT ON COLUMN adq.tsolicitud.nro_cuotas
IS 'Guarda el Nro. de Cuotas Totales para que luego sea copiado en obligaciones de pago';

ALTER TABLE adq.tsolicitud
ADD COLUMN fecha_ini_cot DATE;


ALTER TABLE adq.tsolicitud
ADD COLUMN fecha_ven_cot DATE;



ALTER TABLE adq.tcotizacion
ALTER COLUMN lugar_entrega SET DEFAULT 'Oficinas Cochabamba'::character varying;



ALTER TABLE adq.tcotizacion
ALTER COLUMN lugar_entrega SET DEFAULT 'Oficinas Cochabamba'::character varying;


/***********************************F-SCP-RAC-ADQ-0-27/07/2017****************************************/


/***********************************I-SCP-RAC-ADQ-0-28/07/2017****************************************/


ALTER TABLE adq.tsolicitud_det
ALTER COLUMN id_auxiliar DROP NOT NULL;

/***********************************F-SCP-RAC-ADQ-0-28/07/2017****************************************/



/***********************************I-SCP-RAC-ADQ-0-09/01/2017****************************************/

ALTER TABLE adq.tsolicitud_det
ADD COLUMN saldo_pre_mt NUMERIC;

COMMENT ON COLUMN adq.tsolicitud_det.saldo_pre_mt
IS 'saldo de presupeusto despues de comprometer en moenda de la trasaccion';


ALTER TABLE adq.tsolicitud_det
ADD COLUMN saldo_pre_mb NUMERIC;

COMMENT ON COLUMN adq.tsolicitud_det.saldo_pre_mb
IS 'saldo presupeustario en moenda base despues de comprometer';


--------------- SQL ---------------

ALTER TABLE adq.tsolicitud_det
ADD COLUMN fecha_comp TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL;


/***********************************F-SCP-RAC-ADQ-0-09/01/2017****************************************/


/***********************************I-SCP-RAC-ADQ-0-13/02/2018****************************************/


--------------- SQL ---------------

ALTER TABLE adq.tsolicitud_det
ADD COLUMN saldo_vigente NUMERIC DEFAULT 0 NOT NULL;

COMMENT ON COLUMN adq.tsolicitud_det.saldo_vigente
IS 'saldo vigente de presupuesto';


--------------- SQL ---------------

ALTER TABLE adq.tsolicitud_det
ADD COLUMN saldo_vigente_mb NUMERIC DEFAULT 0 NOT NULL;

COMMENT ON COLUMN adq.tsolicitud_det.saldo_vigente_mb
IS 'saldo vigente de presupeusto en moneda base';

--------------- SQL ---------------

ALTER TABLE adq.tsolicitud_det
ADD COLUMN saldo_vigente_rep NUMERIC DEFAULT 0 NOT NULL;

COMMENT ON COLUMN adq.tsolicitud_det.saldo_vigente_rep
IS 'saldo vigente en moneda de trasaccion para reportes (es volatil dependiendo del momento de generacion del reporte)';


--------------- SQL ---------------

ALTER TABLE adq.tsolicitud_det
ADD COLUMN saldo_vigente_rep_mb NUMERIC DEFAULT 0 NOT NULL;

COMMENT ON COLUMN adq.tsolicitud_det.saldo_vigente_rep_mb
IS 'saldo vigente en moneda de trasaccion para reportes (es volatil dependiendo del momento de generacion del reporte) en moneda base';


--------------- SQL ---------------

ALTER TABLE adq.tsolicitud_det
ADD COLUMN saldo_comp NUMERIC DEFAULT 0 NOT NULL;

COMMENT ON COLUMN adq.tsolicitud_det.saldo_comp
IS 'saldo presupeusto comprometido en moenda de trasaccion, vigente - disopnible = comproemtido';



--------------- SQL ---------------

ALTER TABLE adq.tsolicitud_det
ADD COLUMN saldo_comp_mb NUMERIC DEFAULT 0 NOT NULL;

COMMENT ON COLUMN adq.tsolicitud_det.saldo_comp_mb
IS 'saldo presupeusto comprometido en moenda de trasaccion, vigente - disopnible = comproemtido en moenda base';


--------------- SQL ---------------

ALTER TABLE adq.tsolicitud_det
ADD COLUMN saldo_comp_rep NUMERIC DEFAULT 0 NOT NULL;

COMMENT ON COLUMN adq.tsolicitud_det.saldo_comp_rep
IS 'saldo presupeusto comprometido en moenda de trasaccion, vigente - disopnible = comproemtido . para reportes antes de ser aprobado  y comprometido el monto solicitado';


--------------- SQL ---------------

ALTER TABLE adq.tsolicitud_det
ADD COLUMN saldo_comp_rep_mb NUMERIC DEFAULT 0 NOT NULL;

COMMENT ON COLUMN adq.tsolicitud_det.saldo_comp_rep_mb
IS 'aldo presupeusto comprometido en moenda de trasaccion, vigente - disopnible = comproemtido . para reportes antes de ser aprobado  y comprometido el monto solicitado, en moneda base';





/***********************************F-SCP-RAC-ADQ-0-13/02/2018****************************************/






/***********************************I-SCP-RAC-ADQ-0-21/02/2018****************************************/

-- #10  ETR      21/02/2018          RAC         se incrementa columna para comproemter al 87 %

--------------- SQL ---------------

ALTER TABLE adq.tsolicitud
ADD COLUMN comprometer_87 VARCHAR(4) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN adq.tsolicitud.comprometer_87
IS 'no compromete el 100 %, si comproemte solo el 87';

--------------- SQL ---------------
ALTER TABLE adq.tsolicitud_det
ADD COLUMN monto_cmp NUMERIC DEFAULT 0 NOT NULL;

COMMENT ON COLUMN adq.tsolicitud_det.monto_cmp
IS 'monto comprometido en moenda original';


ALTER TABLE adq.tsolicitud_det
ADD COLUMN monto_cmp_mb NUMERIC DEFAULT 0 NOT NULL;

COMMENT ON COLUMN adq.tsolicitud_det.monto_cmp_mb
IS 'monto comprometido en moenda base';




/***********************************F-SCP-RAC-ADQ-0-21/02/2018****************************************/



/***********************************I-SCP-CAP-ADQ-0-01/12/2018****************************************/

ALTER TABLE adq.tcotizacion_det
ALTER COLUMN precio_unitario TYPE NUMERIC(19,4);

ALTER TABLE adq.tcotizacion_det
ALTER COLUMN precio_unitario_mb TYPE NUMERIC(19,4);

ALTER TABLE adq.tsolicitud
ALTER COLUMN dias_plazo_entrega TYPE INTEGER USING dias_plazo_entrega::INTEGER;

ALTER TABLE adq.tsolicitud
ADD COLUMN observacion TEXT;

/***********************************F-SCP-CAP-ADQ-0-01/12/2018****************************************/

/***********************************I-SCP-EGS-ADQ-1-24/12/2018****************************************/

ALTER TABLE adq.tpresolicitud_det
  ADD COLUMN precio NUMERIC(18,2);
  
/***********************************F-SCP-EGS-ADQ-1-24/12/2018****************************************/
/***********************************I-SCP-EGS-ADQ-2-19/02/2019****************************************/
ALTER TABLE adq.tpresolicitud
  ADD COLUMN id_estado_wf INTEGER;

ALTER TABLE adq.tpresolicitud
  ADD COLUMN id_proceso_wf INTEGER;

ALTER TABLE adq.tpresolicitud
  ADD COLUMN nro_tramite VARCHAR(150);
/***********************************F-SCP-EGS-ADQ-2-19/02/2019****************************************/

/***********************************I-SCP-EGS-ADQ-3-28/08/2019****************************************/
/**
 * Como el patch es el que se ejecuta primero se eliminan algunas views que dependen del campo de cantidad
 Y se las restaura en dependencias
  */
DROP VIEW   IF EXISTS adq.vproceso_compra_wf;
DROP VIEW   IF EXISTS adq.vcotizacion;
DROP VIEW  IF EXISTS adq.vsolicitud_compra;
/*Este es un Triguer que se existe al instalar el sistema de proyectos si existe este se elimina si no no hace nada
*/
DROP TRIGGER IF EXISTS tr_ime_soldet
ON adq.tsolicitud_det;

ALTER TABLE adq.tsolicitud_det
  ALTER COLUMN cantidad TYPE NUMERIC(19,2);
ALTER TABLE adq.tcotizacion_det
  ALTER COLUMN cantidad_coti TYPE NUMERIC(19,2);
ALTER TABLE adq.tcotizacion_det
  ALTER COLUMN cantidad_adju TYPE NUMERIC(19,2);

/***********************************F-SCP-EGS-ADQ-3-28/08/2019****************************************/
/***********************************I-SCP-EGS-ADQ-ETR-2176-22/12/2020****************************************/
CREATE SCHEMA sql_server AUTHORIZATION postgres;
CREATE FOREIGN TABLE sql_server.boleta (
  idboleta INTEGER,
  idtipo INTEGER,
  idtipodoc INTEGER,
  nrodoc VARCHAR,
  otorgante BYTEA,
  monto NUMERIC,
  montomoneda INTEGER,
  acuentade VARCHAR,
  idgerencia INTEGER,
  codresponsable VARCHAR,
  responsable VARCHAR,
  paragarantizar BYTEA,
  fechaaccion DATE,
  fechainicio TIMESTAMP WITHOUT TIME ZONE,
  fechafin TIMESTAMP WITHOUT TIME ZONE,
  observaciones VARCHAR,
  estado INTEGER,
  beneficiario VARCHAR,
  idgarantizar INTEGER,
  idinvitacion INTEGER,
  idproyecto INTEGER
)
SERVER mssql_csa_prod
OPTIONS (query 'SELECT [idBoleta] as idboleta
      ,[idTipo] as idtipo
      ,[idTipoDoc] as idtipodoc
      ,[nroDoc] as nrodoc
      ,[otorgante]
      ,[monto]
      ,[montoMoneda] as montomoneda
      ,[aCuentaDe] as acuentade
      ,[idGerencia] as idgerencia
      ,[codResponsable] as codresponsable
      ,[responsable]
      ,[paraGarantizar] as paragarantizar
      ,[fechaAccion] as fechaaccion
      ,[fechaInicio] as fechainicio
      ,[fechaFin] as fechafin
      ,[observaciones]
      ,[estado]
      ,[beneficiario]
      ,[idGarantizar] as idgarantizar
      ,[IDInvitacion] as idinvitacion
      ,[IdProyecto] as idproyecto
  FROM [CSA_PROD].[dbo].[Boleta]');

ALTER TABLE sql_server.boleta
  OWNER TO postgres;

CREATE FOREIGN TABLE sql_server.boletatipodoc (
  idtipodoc INTEGER,
  tipodocumento BYTEA
)
SERVER mssql_csa_prod
OPTIONS (query 'SELECT [idTipoDoc] as idtipodoc
      ,[TipoDocumento] as tipodocumento
  FROM [CSA_PROD].[dbo].[BoletaTipoDoc]');

ALTER TABLE sql_server.boletatipodoc
  OWNER TO postgres;

  CREATE FOREIGN TABLE sql_server.datosgenerales (
  cd_empleado VARCHAR,
  primer_nombre VARCHAR,
  segundo_nombre VARCHAR,
  apellido_p VARCHAR,
  apellido_m VARCHAR,
  estado VARCHAR,
  correo VARCHAR
)
SERVER mssql_csa_prod
OPTIONS (query 'SELECT [Cd_Empleado] as cd_empleado
      ,[Primer_Nombre] as primer_nombre
      ,[Segundo_Nombre] as segundo_nombre
      ,[Apellido_P] as apellido_p
      ,[Apellido_M] as apellido_m
      ,[Estado] as estado
      ,[Correo] as correo
  FROM [BDSCP]..[DatosGenerales]');

ALTER TABLE sql_server.datosgenerales
  OWNER TO postgres;

  CREATE FOREIGN TABLE sql_server.invitacion (
  idinvitacion INTEGER,
  cd_empleado_gestor DOUBLE PRECISION,
  codinvitacion VARCHAR,
  codresponsable VARCHAR
)
SERVER mssql_csa_prod
OPTIONS (query 'SELECT [IDInvitacion] as idinvitacion
      ,[Cd_empleado_gestor] as cd_empleado_gestor
      ,[CodInvitacion] as codinvitacion
      ,[CodResponsable] as codresponsable
  FROM [CSA_PROD].[dbo].[Invitacion]');

ALTER TABLE sql_server.invitacion
  OWNER TO postgres;

/***********************************F-SCP-EGS-ADQ-ETR-2176-22/12/2020****************************************/
/***********************************I-SCP-EGS-ADQ-ETR-4294-29/06/2021****************************************/
CREATE TABLE adq.tboleta_csa (
     id_boleta_csa SERIAL NOT NULL,
     fecha_reg TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
     idboleta INTEGER,
     diasrestantes INTEGER,
     correo VARCHAR,
     nrodoc VARCHAR,
     fechaaccion DATE,
     fechainicio TIMESTAMP WITHOUT TIME ZONE,
     fechafin TIMESTAMP WITHOUT TIME ZONE,
     tipodocumento VARCHAR,
     otorgante VARCHAR,
     paragarantizar VARCHAR,
     gestor TEXT,
     cd_empleado_gestor VARCHAR,
     estado INTEGER,
     id_alarmas INTEGER [],
     correos VARCHAR [],
     CONSTRAINT tboleta_csa_pkey PRIMARY KEY(id_boleta_csa)
)
    WITH (oids = false);
/***********************************F-SCP-EGS-ADQ-ETR-4294-29/06/2021****************************************/
/***********************************I-SCP-EGS-ADQ-ETR-4294-1-29/06/2021****************************************/
ALTER TABLE adq.tboleta_csa
    ADD COLUMN codinvitacion VARCHAR;
/***********************************F-SCP-EGS-ADQ-ETR-4294-1-29/06/2021****************************************/

/***********************************I-SCP-YMR-ADQ-ETR-4294-3-05/07/2021****************************************/

CREATE FOREIGN TABLE sql_server.gestor (
  cd_empleado INTEGER,
  categoria INTEGER,
  orden INTEGER,
  estado INTEGER
) 
SERVER mssql_csa_prod
OPTIONS (query 'SELECT [Cd_Empleado] as cd_empleado
      ,[Categoria] as categoria
      ,[Orden] as orden
      ,[Activo] as estado
  FROM [CSA_PROD].[dbo].[GESTORES_gestores]');
  
/***********************************F-SCP-YMR-ADQ-ETR-4294-3-05/07/2021****************************************/


