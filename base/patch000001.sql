/***********************************I-SCP-RAC-ADQ-1-01/01/2013****************************************/
CREATE TABLE adq.tcategoria_compra(
id_categoria_compra SERIAL NOT NULL,
codigo varchar(15),
nombre varchar(255),
min numeric(19, 0),
max numeric(19, 0),
obs varchar(255),
id_proceso_macro INTEGER NOT NULL,
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
id_proveedor INTEGER,
PRIMARY KEY (id_documento_sol))INHERITS (pxp.tbase);
COMMENT ON COLUMN adq.tdocumento_sol.id_proveedor
IS 'cuando el tipo de documento sea del tipo precotiacion,  este campo senhala el proveedor correspondiente';

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
id_proveedor INTEGER,
id_funcionario_supervisor INTEGER,
id_cargo_rpc INTEGER,
id_cargo_rpc_ai INTEGER,
ai_habilitado VARCHAR(4) DEFAULT 'no' NOT NULL,
tipo_concepto VARCHAR(50) DEFAULT 'normal' NOT NULL,
revisado_asistente VARCHAR(4) DEFAULT 'no' NOT NULL,
fecha_inicio DATE,
dias_plazo_entrega INTEGER,
obs_presupuestos VARCHAR,
precontrato VARCHAR(40) DEFAULT 'no_necesita'::character varying,
update_enable VARCHAR(2) DEFAULT 'no' NOT NULL,
codigo_poa VARCHAR,
obs_poa VARCHAR,
nro_po VARCHAR(25),
fecha_po DATE,
nro_cite_rpc VARCHAR(30),
nro_cite_informe VARCHAR(30),
fecha_fin DATE,
proveedor_unico BOOLEAN,
nro_cuotas INTEGER,
fecha_ini_cot DATE,
fecha_ven_cot DATE,
comprometer_87 VARCHAR(4) DEFAULT 'no' NOT NULL,
observacion TEXT,
PRIMARY KEY (id_solicitud)

) INHERITS (pxp.tbase)
WITHOUT OIDS;
COMMENT ON COLUMN adq.tsolicitud.id_proveedor
IS 'almacena el proveedor de la precotizacion';

COMMENT ON COLUMN adq.tsolicitud.revisado_asistente
IS 'sirve para indicar si el asistente reviso la documentacion';

COMMENT ON COLUMN adq.tsolicitud.fecha_inicio
IS 'Fecha estimada de entrega de la compra o inicio del servicio';

COMMENT ON COLUMN adq.tsolicitud.dias_plazo_entrega
IS 'Dias calendario para el plazo de entrega una vez emitida la orden de compra(solo se usa para bienes)';

COMMENT ON COLUMN adq.tsolicitud.obs_presupuestos
IS 'Observaciones del area de presupuesto que se van concatenando cada vez que pasa por el estado vbpresupeustos del WF';

COMMENT ON COLUMN adq.tsolicitud.precontrato
IS 'identifica si la solcitud va adjuntar un precontrato,  o contrato de adhesion';

COMMENT ON COLUMN adq.tsolicitud.codigo_poa
IS 'para cruzar con las actividades de POA';

COMMENT ON COLUMN adq.tsolicitud.obs_poa
IS 'Observacion en visto bueno POA';

COMMENT ON COLUMN adq.tsolicitud.obs_poa
IS 'Observacion en bisto bueno POA';

COMMENT ON COLUMN adq.tsolicitud.nro_cite_rpc
IS 'Guarda el numero de cite para memorandum de designacion';

COMMENT ON COLUMN adq.tsolicitud.nro_cite_informe
IS 'Guarda el numero de cite para Informe de una solicitud.';


COMMENT ON COLUMN adq.tsolicitud.nro_cuotas
IS 'Guarda el Nro. de Cuotas Totales para que luego sea copiado en obligaciones de pago';


COMMENT ON COLUMN adq.tsolicitud.comprometer_87
IS 'no compromete el 100 %, si comproemte solo el 87';





CREATE TABLE adq.tsolicitud_det(
id_solicitud_det SERIAL NOT NULL,
id_solicitud int4 NOT NULL,
id_centro_costo int4 NOT NULL,
id_partida int4 NOT NULL,
id_cuenta int4 NOT NULL,
id_auxiliar int4 ,
id_concepto_ingas int4 NOT NULL,
id_partida_ejecucion int4,
id_orden_trabajo int4,

precio_unitario NUMERIC(19,3),
precio_unitario_mb NUMERIC(19,3),
cantidad NUMERIC(19,2),
precio_total numeric(19, 2),
precio_ga numeric(19, 2),
precio_sg numeric(19, 2),
precio_ga_mb numeric(19,2),
precio_sg_mb numeric(19,2),
descripcion text,
revertido_mb NUMERIC DEFAULT 0 NOT NULL,
revertido_mo NUMERIC(12,2) DEFAULT 0 NOT NULL,
saldo_pre_mt NUMERIC,
saldo_pre_mb NUMERIC,
fecha_comp TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
saldo_vigente NUMERIC DEFAULT 0 NOT NULL,
saldo_vigente_mb NUMERIC DEFAULT 0 NOT NULL,
saldo_vigente_rep NUMERIC DEFAULT 0 NOT NULL,
saldo_vigente_rep_mb NUMERIC DEFAULT 0 NOT NULL,
saldo_comp NUMERIC DEFAULT 0 NOT NULL,
saldo_comp_mb NUMERIC DEFAULT 0 NOT NULL,
saldo_comp_rep NUMERIC DEFAULT 0 NOT NULL,
saldo_comp_rep_mb NUMERIC DEFAULT 0 NOT NULL,
monto_cmp NUMERIC DEFAULT 0 NOT NULL,
monto_cmp_mb NUMERIC DEFAULT 0 NOT NULL,
PRIMARY KEY (id_solicitud_det))INHERITS (pxp.tbase);
COMMENT ON COLUMN adq.tsolicitud_det.saldo_pre_mt
IS 'saldo de presupeusto despues de comprometer en moenda de la trasaccion';

COMMENT ON COLUMN adq.tsolicitud_det.saldo_pre_mb
IS 'saldo presupeustario en moenda base despues de comprometer';

COMMENT ON COLUMN adq.tsolicitud_det.saldo_vigente
IS 'saldo vigente de presupuesto';

COMMENT ON COLUMN adq.tsolicitud_det.saldo_vigente_mb
IS 'saldo vigente de presupeusto en moneda base';

COMMENT ON COLUMN adq.tsolicitud_det.saldo_vigente_rep
IS 'saldo vigente en moneda de trasaccion para reportes (es volatil dependiendo del momento de generacion del reporte)';

COMMENT ON COLUMN adq.tsolicitud_det.saldo_vigente_rep_mb
IS 'saldo vigente en moneda de trasaccion para reportes (es volatil dependiendo del momento de generacion del reporte) en moneda base';

COMMENT ON COLUMN adq.tsolicitud_det.saldo_comp
IS 'saldo presupeusto comprometido en moenda de trasaccion, vigente - disopnible = comproemtido';

COMMENT ON COLUMN adq.tsolicitud_det.saldo_comp_mb
IS 'saldo presupeusto comprometido en moenda de trasaccion, vigente - disopnible = comproemtido en moenda base';

COMMENT ON COLUMN adq.tsolicitud_det.saldo_comp_rep
IS 'saldo presupeusto comprometido en moenda de trasaccion, vigente - disopnible = comproemtido . para reportes antes de ser aprobado  y comprometido el monto solicitado';

COMMENT ON COLUMN adq.tsolicitud_det.saldo_comp_rep_mb
IS 'aldo presupeusto comprometido en moenda de trasaccion, vigente - disopnible = comproemtido . para reportes antes de ser aprobado  y comprometido el monto solicitado, en moneda base';

COMMENT ON COLUMN adq.tsolicitud_det.monto_cmp
IS 'monto comprometido en moenda original';

COMMENT ON COLUMN adq.tsolicitud_det.monto_cmp_mb
IS 'monto comprometido en moenda base';

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
id_usuario_auxiliar INTEGER,
objeto VARCHAR,
PRIMARY KEY (id_proceso_compra)
)INHERITS (pxp.tbase);
COMMENT ON COLUMN adq.tproceso_compra.id_usuario_auxiliar
IS 'este campo identifica el usuario que pueden trabajar en el proceso de compra, ser ecupera de la configuracion del depto_usuario';

COMMENT ON COLUMN adq.tproceso_compra.objeto
IS 'Campo opcional para resumir el objeto del contrato, este campo se  refleja en la carta de adjudicacion';


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
lugar_entrega varchar(500) DEFAULT 'Oficinas Cochabamba'::character varying,
tipo_entrega varchar(40),
nro_contrato varchar(50) DEFAULT '0',
tipo_cambio_conv NUMERIC,
num_tramite VARCHAR(100),
tiempo_entrega VARCHAR(350) DEFAULT 'xx dias a partir de la recepción de la presente',
forma_pago VARCHAR(500),
funcionario_contacto VARCHAR(500),
telefono_contacto VARCHAR(200),
correo_contacto VARCHAR(200),
prellenar_oferta VARCHAR(4) DEFAULT 'no' NOT NULL,
requiere_contrato VARCHAR(2) DEFAULT 'no' NOT NULL,
tiene_form500 VARCHAR(13) DEFAULT 'no' NOT NULL,
correo_oc VARCHAR(20) DEFAULT 'ninguno' NOT NULL,
PRIMARY KEY (id_cotizacion))INHERITS (pxp.tbase);
COMMENT ON COLUMN adq.tcotizacion.funcionario_contacto
IS 'funcionario de contacto para el proveedor';

COMMENT ON COLUMN adq.tcotizacion.prellenar_oferta
IS 'si o no, cuando le damos si copia los precios y cantidad de la solicitud de compra';

COMMENT ON COLUMN adq.tcotizacion.tiene_form500
IS 'no, requiere, o si';

COMMENT ON COLUMN adq.tcotizacion.correo_oc
IS 'valores ninguno, bloqueado, pendiente, acuse';


CREATE TABLE adq.tcotizacion_det(
id_cotizacion_det SERIAL NOT NULL,
id_cotizacion int4 NOT NULL,
id_solicitud_det int4 NOT NULL,
id_obligacion_det integer,
precio_unitario NUMERIC(19,4),
precio_unitario_mb NUMERIC(19,4),
cantidad_coti numeric(19, 2),
cantidad_adju numeric(19, 2),
obs varchar(500),
PRIMARY KEY (id_cotizacion_det))INHERITS (pxp.tbase);

/***********************************F-SCP-RAC-ADQ-1-01/01/2013****************************************/




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
id_depto INTEGER,
id_gestion INTEGER NOT NULL,
id_estado_wf INTEGER,
id_proceso_wf INTEGER,
nro_tramite VARCHAR(150),
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
precio NUMERIC(18,2),
PRIMARY KEY (id_presolicitud_det))
INHERITS (pxp.tbase);


/***********************************F-SCP-RAC-ADQ-146-13/05/2013****************************************/


/***********************************I-SCP-RAC-ADQ-0-29/05/2014****************************************/


CREATE TABLE adq.trpc (
id_rpc SERIAL NOT NULL,
id_cargo INTEGER NOT NULL,
id_cargo_ai INTEGER,
ai_habilitado VARCHAR(3) NOT NULL DEFAULT 'no',
PRIMARY KEY(id_rpc)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

ALTER TABLE adq.trpc
ALTER COLUMN id_cargo_ai SET STATISTICS 0;


CREATE TABLE adq.trpc_uo (
id_rpc_uo SERIAL NOT NULL,
id_rpc INTEGER NOT NULL,
id_uo INTEGER NOT NULL,
fecha_ini DATE NOT NULL,
fecha_fin date,
monto_min numeric NOT NULL,
monto_max numeric,
id_categoria_compra INTEGER NOT NULL,
PRIMARY KEY(id_rpc_uo)
) INHERITS (pxp.tbase)
WITHOUT OIDS;
/***********************************F-SCP-RAC-ADQ-0-29/05/2014****************************************/


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
ai_habilitado varchar,
PRIMARY KEY (id_rpc_uo_log)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

/***********************************F-SCP-RAC-ADQ-0-02/06/2014****************************************/


/***********************************I-SCP-RAC-ADQ-0-27/07/2017****************************************/
--Algun chapulin (o varios) se olvido subir estos script al pacht

/*
CREATE SEQUENCE adq.tinforme_especificacion_id_informe_especificacion_seq
INCREMENT 1 MINVALUE 1
MAXVALUE 9223372036854775807 START 1
CACHE 1;

ALTER SEQUENCE adq.tinforme_especificacion_id_informe_especificacion_seq RESTART WITH 39;*/


CREATE TABLE adq.tcomision (
id_integrante SERIAL NOT NULL,
id_funcionario INTEGER NOT NULL,
orden NUMERIC(4,2),
CONSTRAINT tcomision_pkey PRIMARY KEY(id_integrante)
) INHERITS (pxp.tbase)
;


CREATE TABLE adq.tinformacion_secundaria (
id_usuario_reg INTEGER,
id_usuario_mod INTEGER,
fecha_reg TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
fecha_mod TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
estado_reg VARCHAR(10) DEFAULT 'activo'::character varying,
id_usuario_ai INTEGER,
usuario_ai VARCHAR(300),
id_informacion_sec SERIAL NOT NULL,
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

/***********************************F-SCP-RAC-ADQ-0-27/07/2017****************************************/


/***********************************I-SCP-EGS-ADQ-ETR-2176-22/12/2020****************************************/
/*CREATE SCHEMA sql_server AUTHORIZATION postgres;
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
  OWNER TO postgres;*/

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
     codinvitacion VARCHAR,
     CONSTRAINT tboleta_csa_pkey PRIMARY KEY(id_boleta_csa)
)
    WITH (oids = false);
/***********************************F-SCP-EGS-ADQ-ETR-4294-29/06/2021****************************************/


/***********************************I-SCP-YMR-ADQ-ETR-4294-3-05/07/2021****************************************/

/*CREATE FOREIGN TABLE sql_server.gestor (
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
  */
/***********************************F-SCP-YMR-ADQ-ETR-4294-3-05/07/2021****************************************/


