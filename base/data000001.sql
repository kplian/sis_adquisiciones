/***********************************I-DAT-FRH-ADQ-0-06/02/2013*****************************************/

/*
*	Author: Freddy Rojas FRH
*	Date: 06/02/2013
*	Description: Build the menu definition and the composition
*/
/*

Para  definir la la metadata, menus, roles, etc

1) sincronize ls funciones y procedimientos del sistema
2)  verifique que la primera linea de los datos sea la insercion del sistema correspondiente
3)  exporte los datos a archivo SQL (desde la interface de sistema en sis_seguridad), 
    verifique que la codificacion  se mantenga en UTF8 para no distorcionar los caracteres especiales
4)  remplaze los sectores correspondientes en este archivo en su totalidad:  (el orden es importante)  
                             menu, 
                             funciones, 
                             procedimietnos

*/

INSERT INTO segu.tsubsistema ( codigo, nombre, fecha_reg, prefijo, estado_reg, nombre_carpeta, id_subsis_orig)
VALUES ('ADQ', 'Adquisiciones', '2013-02-06', 'ADQ', 'activo', 'adquisiciones', NULL);

-------------------------------------
--DEFINICION DE INTERFACES
-------------------------------------

select pxp.f_insert_tgui ('ADQUISICIONES', '', 'ADQ', 'si', 1, '', 1, '', '', 'ADQ');
select pxp.f_insert_tgui ('Configuración', 'Configuración varios', 'ADQ.1', 'si', 1, '', 2, '', '', 'ADQ');
select pxp.f_insert_tgui ('Categorías de Compra', 'Categorías de Compra', 'ADQ.1.1', 'si', 1, 'sis_adquisiciones/vista/categoria_compra/CategoriaCompra.php', 3, '', 'CategoriaCompra', 'ADQ');
select pxp.f_insert_tgui ('Documento de Solicitud', 'Documento de Solicitud', 'ADQ.2', 'no', 1, 'sis_adquisiciones/vista/documento_sol/DocumentoSol.php', 2, '', 'DocumentoSol', 'ADQ');
select pxp.f_insert_tgui ('Solicitud de Compra', 'Solicitud de Compra', 'ADQ.3', 'si', 1, 'sis_adquisiciones/vista/solicitud/SolicitudReq.php', 2, '', 'SolicitudReq', 'ADQ');
select pxp.f_insert_tgui ('Visto Bueno', 'Solicitud de Compra', 'VBSOL', 'si', 1, 'sis_adquisiciones/vista/solicitud/SolicitudVb.php', 2, '', 'SolicitudVb', 'ADQ');
select pxp.f_insert_tgui ('Proveedores', 'Proveedores de compra', 'ADQ.4', 'si', 1, 'sis_adquisiciones/vista/proveedor/Proveedor.php', 2, '', 'Proveedor', 'ADQ');
select pxp.f_insert_tgui ('Proceso Compra', 'Proceso de Compra', 'PROC', 'si', 4, 'sis_adquisiciones/vista/proceso_compra/ProcesoCompra.php', 2, '', 'ProcesoCompra', 'ADQ');


-------------------------------------
select pxp.f_insert_testructura_gui ('ADQ', 'SISTEMA');
select pxp.f_insert_testructura_gui ('ADQ.1', 'ADQ');
select pxp.f_insert_testructura_gui ('ADQ.1.1', 'ADQ.1');
select pxp.f_insert_testructura_gui ('ADQ.2', 'ADQ');
select pxp.f_insert_testructura_gui ('ADQ.3', 'ADQ');
select pxp.f_insert_testructura_gui ('VBSOL', 'ADQ');
select pxp.f_insert_testructura_gui ('ADQ.4', 'ADQ');
select pxp.f_insert_testructura_gui ('PROC', 'ADQ');


----------------------------------------------
--  DEF DE FUNCIONES
----------------------------------------------

select pxp.f_insert_tfuncion ('adq.f_categoria_compra_ime', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_categoria_compra_sel', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_documento_sol_ime', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_documento_sol_sel', 'Funcion para tabla     ', 'ADQ');

/***********************************F-DAT-FRH-ADQ-0-06/02/2013*****************************************/



/***********************************I-DAT-RAC-ADQ-0-25/02/2013*****************************************/

--INSERTAR CATEGORIAS DE COMPRA

INSERT INTO adq.tcategoria_compra ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "codigo", "nombre", "min", "max", "obs")
VALUES (1, NULL, E'2013-02-25 09:22:56.914', NULL, E'activo', E'CLOC', E'Compra Local', '0', NULL, E'Para todas las compras Locales');

INSERT INTO adq.tcategoria_compra ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "codigo", "nombre", "min", "max", "obs")
VALUES (1, NULL, E'2013-02-25 09:23:20.583', NULL, E'activo', E'CINT', E'Compras Internacionales', '0', NULL, E'Para todas las compras Internacionales');

INSERT INTO adq.tcategoria_compra ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "codigo", "nombre", "min", "max", "obs")
VALUES (1, NULL, E'2013-02-25 09:23:51.125', NULL, E'activo', E'CMIM', E'Compra Minima', '1', '20000', E'Prueba con rangode compras');


---------------------------------
--   (WF)  PROCESO MACRO, TIPOS DE PROCESO
-----------------------------------------
---------------------------------
--COPY LINES TO data.sql FILE  
---------------------------------

select wf.f_insert_tproceso_macro ('COMINT', 'Compra internacional', 'SI', 'activo', 'Adquisiciones');
select wf.f_insert_ttipo_proceso ('', 'Solicitud de compra', 'SOLCO', 'adq.tsolicitud', 'id_solicitud', 'activo', 'si', 'COMINT');
select wf.f_insert_ttipo_proceso ('En_Proceso', 'Proceso de Compra', 'PROC', 'adq.tproceso_compra', 'id_proceso_compra', 'activo', 'no', 'COMINT');
select wf.f_insert_ttipo_proceso ('Inicio de Proceso de COmpra', 'Cotizacion', 'COT', 'adq.tcotizacion', 'id_cotizacion', 'activo', '', 'COMINT');
select wf.f_insert_ttipo_proceso ('Habilitado para pagar', 'ADQ Obligacion de Pago', 'OBLI', 'tes.tobligacion_pago', 'id_obligacion_pago', 'activo', 'si', 'COMINT');

select wf.f_insert_ttipo_proceso ('En Pago', 'ADQ. Plan de Pago Devengado', 'APLAD', 'tes.tplan_pago', 'id_plan_pago', 'activo', 'no', 'COMINT');

select wf.f_insert_ttipo_estado ('borrador', 'Borrador', 'si', 'no', 'no', 'ninguno', '', 'ninguno', '', '', 'activo', 'SOLCO', '');
select wf.f_insert_ttipo_estado ('proceso', 'En_Proceso', 'no', 'si', 'no', 'todos', '', 'ninguno', '', '', 'activo', 'SOLCO', 'PROC');
select wf.f_insert_ttipo_estado ('finalizado', 'Finalizado', 'no', 'no', 'si', 'anterior', '', 'anterior', '', '', 'activo', 'SOLCO', '');
select wf.f_insert_ttipo_estado ('pendiente', 'Aprobación Supervisor', 'no', 'no', 'no', 'funcion_listado', 'ADQ_APR_SOL_COMPRA', 'ninguno', '', '', 'activo', 'SOLCO', '');
select wf.f_insert_ttipo_estado ('vbrpc', 'Visto Bueno RPC', 'no', 'no', 'no', 'funcion_listado', 'ADQ_RPC_SOL_COMPRA', 'ninguno', '', '', 'activo', 'SOLCO', '');
select wf.f_insert_ttipo_estado ('vbactif', 'Visto Bueno Activos Fijos', 'no', 'no', 'no', 'listado', '', 'ninguno', '', '43120,43100,aaa,bb,1', 'activo', 'SOLCO', '');
select wf.f_insert_ttipo_estado ('aprobado', 'Solicitud de Aprobada', 'no', 'no', 'no', 'anterior', '', 'depto_func_list', 'ADQ_DEPTO_SOL', '', 'activo', 'SOLCO', '');
select wf.f_insert_ttipo_estado ('pendiente', 'Proceso pendiente', 'si', 'no', 'no', 'ninguno', '', 'depto_func_list', 'ADQ_DEPT_PROC', '', 'activo', 'PROC', '');
select wf.f_insert_ttipo_estado ('proceso', 'Inicio de Proceso de COmpra', 'no', 'si', 'no', 'ninguno', '', 'anterior', '', 'cuando el proceso se inicia', 'activo', 'PROC', 'COT');
select wf.f_insert_ttipo_estado ('finalizado', 'Proceso Finalizado', 'no', 'no', 'si', 'ninguno', '', 'anterior', '', 'El proceso esta finalizado  cuando, se declara decierto o cuando se finalizaron todas las 

solcitudes', 'activo', 'PROC', '');
select wf.f_insert_ttipo_estado ('desierto', 'Proceso Desierto', 'no', 'no', 'si', 'ninguno', '', 'anterior', '', '', 'activo', 'PROC', '');
select wf.f_insert_ttipo_estado ('borrador', 'Borrador de Cotizacion', 'si', 'no', 'no', 'ninguno', '', 'depto_func_list', 'PROCDEP', '', 'activo', 'COT', '');
select wf.f_insert_ttipo_estado ('cotizado', 'Cotizado', 'no', 'no', 'no', 'ninguno', '', 'anterior', '', '', 'activo', 'COT', '');
select wf.f_insert_ttipo_estado ('adjudicado', 'Adjudicado', 'no', 'no', 'no', 'ninguno', '', 'anterior', '', '', 'activo', 'COT', '');
select wf.f_insert_ttipo_estado ('pago_habilitado', 'Habilitado para pagar', 'no', 'si', 'no', 'ninguno', '', 'anterior', '', '', 'activo', 'COT', 'OBLI');
select wf.f_insert_ttipo_estado ('finalizada', 'Finalizada', 'no', 'no', 'si', 'ninguno', '', 'anterior', '', '', 'activo', 'COT', '');
select wf.f_insert_ttipo_estado ('anulado', 'Anulado', 'no', 'no', 'si', 'anterior', '', 'anterior', '', '', 'activo', 'PROC', '');
select wf.f_insert_ttipo_estado ('registrado', 'Registrado', 'no', 'no', 'no', 'anterior', '', 'anterior', '', '', 'activo', 'OBLI', '');
select wf.f_insert_ttipo_estado ('en_pago', 'En Pago', 'no', 'si', 'no', 'anterior', '', 'anterior', '', '', 'activo', 'OBLI', 'APLAD');
select wf.f_insert_ttipo_estado ('anulado', 'Anulado', 'no', 'no', 'si', 'anterior', '', 'anterior', '', '', 'activo', 'COT', '');
select wf.f_insert_ttipo_estado ('anulado', 'Anulado', 'no', 'no', 'si', 'anterior', '', 'anterior', '', '', 'activo', 'SOLCO', '');
select wf.f_insert_ttipo_estado ('borrador', 'Borrador', 'si', 'no', 'no', 'anterior', '', 'anterior', '', '', 'activo', 'OBLI', '');
select wf.f_insert_ttipo_estado ('finalizado', 'Finalizado', 'no', 'no', 'si', 'anterior', '', 'anterior', '', '', 'activo', 'OBLI', '');
select wf.f_insert_ttipo_estado ('anulado', 'Anulado', 'no', 'no', 'si', 'anterior', '', 'anterior', '', '', 'activo', 'OBLI', '');

select wf.f_insert_ttipo_estado ('borrador', 'Borrador', 'si', 'no', 'no', 'anterior', '', 'anterior', '', '', 'activo', 'APLAD', '');
select wf.f_insert_ttipo_estado ('pendiente', 'Pendiente', 'no', 'no', 'no', 'anterior', '', 'anterior', '', '', 'activo', 'APLAD', '');

select wf.f_insert_ttipo_estado ('devengado', 'Devengado', 'no', 'si', 'si', 'anterior', '', 'anterior', '', '', 'activo', 'APLAD', 'APLAP');


select wf.f_insert_ttipo_estado ('anulado', 'Anlado', 'no', 'no', 'si', 'anterior', '', 'anterior', '', '', 'activo', 'APLAD', '');

select wf.f_insert_ttipo_estado ('recomendado', 'Recomendado', 'no', 'no', 'no', 'anterior', '', 'anterior', '', '', 'activo', 'COT', '');

select wf.f_insert_testructura_estado ('proceso', 'SOLCO', 'finalizado', 'SOLCO', '2', 'ff2', 'activo');
select wf.f_insert_testructura_estado ('pendiente', 'SOLCO', 'vbactif', 'SOLCO', '3', '', 'activo');
select wf.f_insert_testructura_estado ('borrador', 'SOLCO', 'pendiente', 'SOLCO', '0', '', 'activo');
select wf.f_insert_testructura_estado ('vbactif', 'SOLCO', 'vbrpc', 'SOLCO', '1', '', 'activo');
select wf.f_insert_testructura_estado ('vbrpc', 'SOLCO', 'aprobado', 'SOLCO', '1', '', 'activo');
select wf.f_insert_testructura_estado ('aprobado', 'SOLCO', 'proceso', 'SOLCO', '1', '', 'activo');
select wf.f_insert_testructura_estado ('pendiente', 'PROC', 'proceso', 'PROC', '1', '', 'activo');
select wf.f_insert_testructura_estado ('borrador', 'COT', 'cotizado', 'COT', '1', '', 'activo');
select wf.f_insert_testructura_estado ('adjudicado', 'COT', 'pago_habilitado', 'COT', '1', '', 'activo');
select wf.f_insert_testructura_estado ('proceso', 'PROC', 'finalizado', 'PROC', '1', '', 'activo');
select wf.f_insert_testructura_estado ('registrado', 'OBLI', 'en_pago', 'OBLI', '1', '', 'activo');
select wf.f_insert_testructura_estado ('pago_habilitado', 'COT', 'finalizada', 'COT', '1', '', 'activo');
select wf.f_insert_testructura_estado ('borrador', 'OBLI', 'registrado', 'OBLI', '1', '', 'activo');
select wf.f_insert_testructura_estado ('en_pago', 'OBLI', 'finalizado', 'OBLI', '1', '', 'activo');
select wf.f_insert_testructura_estado ('borrador', 'APLAD', 'pendiente', 'APLAD', '1', '', 'activo');
select wf.f_insert_testructura_estado ('pendiente', 'APLAD', 'devengado', 'APLAD', '1', '', 'activo');
select wf.f_insert_testructura_estado ('cotizado', 'COT', 'recomendado', 'COT', '1', '', 'activo');
select wf.f_insert_testructura_estado ('recomendado', 'COT', 'adjudicado', 'COT', '1', '', 'activo');
-------------------------------------
-- DOCUMENTOS
---------------------------------


--inserta documentos de adquisiciones

SELECT * FROM param.f_inserta_documento('ADQ', 'SOLC', 'Solicitud de Compra', 'periodo', NULL, 'depto', NULL);

SELECT * FROM param.f_inserta_documento('ADQ', 'COT', 'Cotizacion de Compra', 'periodo', NULL, 'depto', NULL);

SELECT * FROM param.f_inserta_documento('ADQ', 'OC', 'Orden de Compra', 'periodo', NULL, 'depto', NULL);




/***********************************F-DAT-RAC-ADQ-0-07/03/2013*****************************************/

/***********************************I-DAT-GSS-ADQ-81-26/03/2013*****************************************/
--definicion de interfaces

select pxp.f_insert_tgui ('TipoDocumento', 'TipoDocumento', 'ADQ.1.1.1', 'no', 0, 'sis_adquisiciones/vista/documento_sol/TipoDocumento.php', 4, '', '40%', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'ADQ.3.1', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/SolicitudReqDet.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'VBSOL.1', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/SolicitudVbDet.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Cotizacion de solicitud de compra', 'Cotizacion de solicitud de compra', 'PROC.1', 'no', 0, 'sis_adquisiciones/vista/cotizacion/Cotizacion.php', 3, '', 'Cotizacion', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'PROC.2', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/SolicitudVbDet.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Detalles Cotizacion', 'Detalles Cotizacion', 'PROC.1.1', 'no', 0, 'sis_adquisiciones/vista/cotizacion_det/CotizacionDet.php', 4, '', '50%', 'ADQ');

--estructuras de interfaces

select pxp.f_insert_testructura_gui ('ADQ.1.1.1', 'ADQ.1.1');
select pxp.f_insert_testructura_gui ('ADQ.3.1', 'ADQ.3');
select pxp.f_insert_testructura_gui ('VBSOL.1', 'VBSOL');
select pxp.f_insert_testructura_gui ('PROC.1', 'PROC');
select pxp.f_insert_testructura_gui ('PROC.2', 'PROC');
select pxp.f_insert_testructura_gui ('PROC.1.1', 'PROC.1');

--funciones

select pxp.f_insert_tfuncion ('adq.f_solicitud_det_sel', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_proceso_compra_ime', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_solicitud_ime', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_tproveedor_ime', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_solicitud_sel', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_solicitud_det_ime', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_tproveedor_sel', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_calcular_monto_total', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_cotizacion_det_sel', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_cotizacion_sel', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_obtener_sig_estado_sol_rec', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_cotizacion_det_ime', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_cotizacion_ime', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_proceso_compra_sel', 'Funcion para tabla     ', 'ADQ');

--procedimientos

select pxp.f_insert_tprocedimiento ('ADQ_SOLD_SEL', 'Consulta de datos', 'si', '', '', 'adq.f_solicitud_det_sel');
select pxp.f_insert_tprocedimiento ('ADQ_SOLDETCOT_SEL', 'Consulta de datos en base al id_cotizacion', 'si', '', '', 'adq.f_solicitud_det_sel');
select pxp.f_insert_tprocedimiento ('ADQ_SOLD_CONT', 'Conteo de registros', 'si', '', '', 'adq.f_solicitud_det_sel');
select pxp.f_insert_tprocedimiento ('ADQ_PROC_INS', 'Insercion de registros', 'si', '', '', 'adq.f_proceso_compra_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PROC_MOD', 'Modificacion de registros', 'si', '', '', 'adq.f_proceso_compra_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PROC_ELI', 'Eliminacion de registros', 'si', '', '', 'adq.f_proceso_compra_ime');
select pxp.f_insert_tprocedimiento ('ADQ_SOL_INS', 'Insercion de registros', 'si', '', '', 'adq.f_solicitud_ime');
select pxp.f_insert_tprocedimiento ('ADQ_SOL_MOD', 'Modificacion de registros', 'si', '', '', 'adq.f_solicitud_ime');
select pxp.f_insert_tprocedimiento ('ADQ_SOL_ELI', 'Eliminacion de registros', 'si', '', '', 'adq.f_solicitud_ime');
select pxp.f_insert_tprocedimiento ('ADQ_FINSOL_IME', 'Finalizar solicitud de Compras', 'si', '', '', 'adq.f_solicitud_ime');
select pxp.f_insert_tprocedimiento ('ADQ_SIGESOL_IME', 'funcion que controla el cambio al Siguiente esado de la solicitud, integrado con el WF', 'si', '', '', 'adq.f_solicitud_ime');
select pxp.f_insert_tprocedimiento ('ADQ_ANTESOL_IME', 'Trasaacion utilizada  pasar a  estados anterior es de la solicitud
                    segun la operacion definida', 'si', '', '', 'adq.f_solicitud_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PROVEE_INS', 'Insercion de registros', 'si', '', '', 'adq.f_tproveedor_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PROVEE_MOD', 'Modificacion de registros', 'si', '', '', 'adq.f_tproveedor_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PROVEE_ELI', 'Eliminacion de registros', 'si', '', '', 'adq.f_tproveedor_ime');
select pxp.f_insert_tprocedimiento ('ADQ_SOL_SEL', 'Consulta de datos', 'si', '', '', 'adq.f_solicitud_sel');
select pxp.f_insert_tprocedimiento ('ADQ_SOLREP_SEL', 'Consulta de datos', 'si', '', '', 'adq.f_solicitud_sel');
select pxp.f_insert_tprocedimiento ('ADQ_SOL_CONT', 'Conteo de registros', 'si', '', '', 'adq.f_solicitud_sel');
select pxp.f_insert_tprocedimiento ('ADQ_SOLD_INS', 'Insercion de registros', 'si', '', '', 'adq.f_solicitud_det_ime');
select pxp.f_insert_tprocedimiento ('ADQ_SOLD_MOD', 'Modificacion de registros', 'si', '', '', 'adq.f_solicitud_det_ime');
select pxp.f_insert_tprocedimiento ('ADQ_SOLD_ELI', 'Eliminacion de registros', 'si', '', '', 'adq.f_solicitud_det_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PROVEE_SEL', 'Consulta de datos', 'si', '', '', 'adq.f_tproveedor_sel');
select pxp.f_insert_tprocedimiento ('ADQ_PROVEE_CONT', 'Conteo de registros', 'si', '', '', 'adq.f_tproveedor_sel');
select pxp.f_insert_tprocedimiento ('ADQ_CATCOMP_SEL', 'Consulta de datos', 'si', '', '', 'adq.f_categoria_compra_sel');
select pxp.f_insert_tprocedimiento ('ADQ_CATCOMP_CONT', 'Conteo de registros', 'si', '', '', 'adq.f_categoria_compra_sel');
select pxp.f_insert_tprocedimiento ('ADQ_CTD_SEL', 'Consulta de datos', 'si', '', '', 'adq.f_cotizacion_det_sel');
select pxp.f_insert_tprocedimiento ('ADQ_CTD_CONT', 'Conteo de registros', 'si', '', '', 'adq.f_cotizacion_det_sel');
select pxp.f_insert_tprocedimiento ('ADQ_COT_SEL', 'Consulta de datos', 'si', '', '', 'adq.f_cotizacion_sel');
select pxp.f_insert_tprocedimiento ('ADQ_COTREP_SEL', 'Consulta de registros para los reportes', 'si', '', '', 'adq.f_cotizacion_sel');
select pxp.f_insert_tprocedimiento ('ADQ_COT_CONT', 'Conteo de registros', 'si', '', '', 'adq.f_cotizacion_sel');
select pxp.f_insert_tprocedimiento ('ADQ_CTD_INS', 'Insercion de registros', 'si', '', '', 'adq.f_cotizacion_det_ime');
select pxp.f_insert_tprocedimiento ('ADQ_CTD_MOD', 'Modificacion de registros', 'si', '', '', 'adq.f_cotizacion_det_ime');
select pxp.f_insert_tprocedimiento ('ADQ_CTD_ELI', 'Eliminacion de registros', 'si', '', '', 'adq.f_cotizacion_det_ime');
select pxp.f_insert_tprocedimiento ('ADQ_DOCSOL_SEL', 'Consulta de datos', 'si', '', '', 'adq.f_documento_sol_sel');
select pxp.f_insert_tprocedimiento ('ADQ_DOCSOLAR_SEL', 'Consulta de datos', 'si', '', '', 'adq.f_documento_sol_sel');
select pxp.f_insert_tprocedimiento ('ADQ_DOCSOL_CONT', 'Conteo de registros', 'si', '', '', 'adq.f_documento_sol_sel');
select pxp.f_insert_tprocedimiento ('ADQ_DOCSOLAR_CONT', 'Conteo de registros', 'si', '', '', 'adq.f_documento_sol_sel');
select pxp.f_insert_tprocedimiento ('ADQ_CATCOMP_INS', 'Insercion de registros', 'si', '', '', 'adq.f_categoria_compra_ime');
select pxp.f_insert_tprocedimiento ('ADQ_CATCOMP_MOD', 'Modificacion de registros', 'si', '', '', 'adq.f_categoria_compra_ime');
select pxp.f_insert_tprocedimiento ('ADQ_CATCOMP_ELI', 'Eliminacion de registros', 'si', '', '', 'adq.f_categoria_compra_ime');
select pxp.f_insert_tprocedimiento ('ADQ_COT_INS', 'Insercion de registros', 'si', '', '', 'adq.f_cotizacion_ime');
select pxp.f_insert_tprocedimiento ('ADQ_COT_MOD', 'Modificacion de registros', 'si', '', '', 'adq.f_cotizacion_ime');
select pxp.f_insert_tprocedimiento ('ADQ_COT_ELI', 'Eliminacion de registros', 'si', '', '', 'adq.f_cotizacion_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PROC_SEL', 'Consulta de datos', 'si', '', '', 'adq.f_proceso_compra_sel');
select pxp.f_insert_tprocedimiento ('ADQ_PROC_CONT', 'Conteo de registros', 'si', '', '', 'adq.f_proceso_compra_sel');
select pxp.f_insert_tprocedimiento ('ADQ_DOCSOL_INS', 'Insercion de registros', 'si', '', '', 'adq.f_documento_sol_ime');
select pxp.f_insert_tprocedimiento ('ADQ_DOCSOL_MOD', 'Modificacion de registros', 'si', '', '', 'adq.f_documento_sol_ime');
select pxp.f_insert_tprocedimiento ('ADQ_DOCSOL_ELI', 'Eliminacion de registros', 'si', '', '', 'adq.f_documento_sol_ime');
select pxp.f_insert_tprocedimiento ('ADQ_DOCSOLAR_MOD', 'Eliminacion de registros', 'si', '', '', 'adq.f_documento_sol_ime');
select pxp.f_insert_tprocedimiento ('ADQ_COTRP_SEL', 'Consulta de registros para los reportes', 'si', '', '', 'adq.f_cotizacion_sel');
select pxp.f_insert_tprocedimiento ('ADQ_COTRP_CONT', 'Conteo de registros', 'si', '', '', 'adq.f_cotizacion_sel');
select pxp.f_insert_tprocedimiento ('ADQ_SOLDETCOT_CONT', 'Conteo de registros', 'si', '', '', 'adq.f_solicitud_det_sel');
select pxp.f_insert_tprocedimiento ('ADQ_FINREGC_IME', 'Finaliza el registro de la cotizacion y pasa al siguiente este que es totizado donde estara listo para adjudicar', 'si', '', '', 'adq.f_cotizacion_ime');

/***********************************F-DAT-GSS-ADQ-81-26/03/2013*****************************************/

/***********************************I-DAT-JRR-ADQ-104-04/04/2013****************************************/
update adq.tcategoria_compra
set id_proceso_macro = (select id_proceso_macro 
						from wf.tproceso_macro
						where codigo = 'COMINT');
  
/***********************************F-DAT-JRR-ADQ-104-04/04/2013****************************************/

/***********************************I-DAT-GSS-ADQ-101-22/04/2013*****************************************/

select pxp.f_insert_tfuncion ('adq.f_calcular_total_adj_cot_det', 'Funcion para tabla     ', 'ADQ');

select pxp.f_insert_tprocedimiento ('ADQ_SOLDETCOT_CONT', 'Conteo de registros', 'si', '', '', 'adq.f_solicitud_det_sel');
select pxp.f_insert_tprocedimiento ('ADQ_COTOC_REP', 'Reporte Orden Compra', 'si', '', '', 'adq.f_cotizacion_sel');
select pxp.f_insert_tprocedimiento ('ADQ_TOTALADJ_IME', 'Recuperar Total adjudicado por item', 'si', '', '', 'adq.f_cotizacion_det_ime');
select pxp.f_insert_tprocedimiento ('ADQ_ADJDET_IME', 'Adjudicada por detalle de la cotizacion', 'si', '', '', 'adq.f_cotizacion_det_ime');
select pxp.f_insert_tprocedimiento ('ADQ_ADJTODO_IME', 'Adjudica todo el detalle de la cotizacion disponible', 'si', '', '', 'adq.f_cotizacion_ime');
select pxp.f_insert_tprocedimiento ('ADQ_GENOC_IME', 'Generar el numero secuencial de Orden de compra y pasa al siguiente estado la cotizacion', 'si', '', '', 'adq.f_cotizacion_ime');
select pxp.f_insert_tprocedimiento ('ADQ_ANTEST_IME', 'Retrocede estados en la cotizacion', 'si', '', '', 'adq.f_cotizacion_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PROCPED_SEL', 'Consulta de datos', 'si', '', '', 'adq.f_proceso_compra_sel');
select pxp.f_insert_tprocedimiento ('ADQ_HABPAG_IME', 'Habilita los pagos en tesoreria en modulo de cuentas por pagar', 'si', '', '', 'adq.f_cotizacion_ime');

/***********************************F-DAT-GSS-ADQ-101-22/04/2013*****************************************/

/***********************************I-DAT-RAC-ADQ-00-07/05/2013*****************************************/

select pxp.f_insert_tgui ('Visto Bueno Cotizacion', 'Visto Bueno Cotizacion', 'VBCOT', 'si', 7, 'sis_adquisiciones/vista/cotizacion/CotizacionVb.php', 2, '', 'CotizacionVb', 'ADQ');
select pxp.f_insert_testructura_gui ('VBCOT', 'ADQ');

/***********************************F-DAT-RAC-ADQ-00-07/05/2013*****************************************/

/***********************************I-DAT-GSS-ADQ-00-07/05/2013*****************************************/

select pxp.f_insert_tprocedimiento ('ADQ_ESTSOL_SEL', 'Consulta estado de solicitud', 'si', '', '', 'adq.f_solicitud_sel');
select pxp.f_insert_tprocedimiento ('ADQ_SOLAPRO_IME', 'depues de adjudicar pasa al siguiente estado, de solicitud de aprobacion', 'si', '', '', 'adq.f_cotizacion_ime');
select pxp.f_insert_tprocedimiento ('ADQ_COTRPC_SEL', 'Consulta de datos para los funcionarios rpc', 'si', '', '', 'adq.f_cotizacion_sel');
select pxp.f_insert_tprocedimiento ('ADQ_COTRPC_CONT', 'Conteo de registros de la consulta de cotizaciones por RPC', 'si', '', '', 'adq.f_cotizacion_sel');

/***********************************F-DAT-GSS-ADQ-00-07/05/2013*****************************************/


/***********************************I-DAT-RAC-ADQ-00-29/05/2013*****************************************/

select pxp.f_insert_tgui ('Grupos de Presolicitudes', 'Configurar de grupos para presolicitudes', 'GRUP', 'si', 2, 'sis_adquisiciones/vista/grupo/Grupo.php', 3, '', 'Grupo', 'ADQ');
select pxp.f_insert_testructura_gui ('GRUP', 'ADQ.1');
select pxp.f_insert_tgui ('Presolicitud de Compra', 'Presolicitud de Compra', 'PRECOM', 'si', 8, 'sis_adquisiciones/vista/presolicitud/PresolicitudReq.php', 2, '', 'PresolicitudReq', 'ADQ');
select pxp.f_insert_tgui ('Visto Bueno Presolicitud', 'Visto bueno de presolicitudes', 'VBPRE', 'si', 9, 'sis_adquisiciones/vista/presolicitud/PresolicitudVb.php', 2, '', 'PresolicitudVb', 'ADQ');
select pxp.f_insert_tgui ('Consolidad Presolicitudes', 'Consolidar presolicitudes', 'COPRE', 'si', 10, 'sis_adquisiciones/vista/solicitud/SolicitudReqCon.php', 2, '', 'SolicitudReqCon', 'ADQ');
select pxp.f_insert_testructura_gui ('PRECOM', 'ADQ');
select pxp.f_insert_testructura_gui ('VBPRE', 'ADQ');
select pxp.f_insert_testructura_gui ('COPRE', 'ADQ');

/***********************************F-DAT-RAC-ADQ-00-29/05/2013*****************************************/



/***********************************I-DAT-RAC-ADQ-00-05/06/2013*****************************************/



select wf.f_insert_ttipo_proceso ('Devengado', 'ADQ Plan de Pago, Pagado ', 'APLAP', '', '', 'activo', 'no', 'COMINT');
select wf.f_insert_ttipo_estado ('borrador', 'Borrador', 'si', 'no', 'no', 'anterior', '', 'anterior', '', '', 'activo', 'APLAP', '');
select wf.f_insert_ttipo_estado ('pendiente', 'Pendiente', 'no', 'no', 'no', 'anterior', '', 'anterior', '', '', 'activo', 'APLAP', '');
select wf.f_insert_ttipo_estado ('pagado', 'Pagado', 'no', 'no', 'si', 'anterior', '', 'anterior', '', '', 'activo', 'APLAP', '');
select wf.f_insert_ttipo_estado ('anulado', 'Anulado', 'no', 'no', 'si', 'anterior', '', 'anterior', '', '', 'activo', 'APLAP', '');
select wf.f_insert_testructura_estado ('borrador', 'APLAP', 'pendiente', 'APLAP', '1', '', 'activo');
select wf.f_insert_testructura_estado ('pendiente', 'APLAP', 'pagado', 'APLAP', '1', '', 'activo');



/***********************************F-DAT-RAC-ADQ-00-05/06/2013*****************************************/




/***********************************I-DAT-RAC-ADQ-00-03/02/2014*****************************************/


----------------------------------
--COPY LINES TO data.sql FILE  
---------------------------------

select pxp.f_insert_tgui ('Visto Bueno Cotizacion', 'Visto Bueno Cotizacion', 'VBCOT', 'si', 7, 'sis_adquisiciones/vista/cotizacion/CotizacionVbDin.php', 2, '', 'CotizacionVbDin', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'ADQ.3.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', 'DocumentoWf', 'ADQ');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'ADQ.3.3', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 3, '', 'proveedor', 'ADQ');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'ADQ.3.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 4, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Items/Servicios ofertados', 'Items/Servicios ofertados', 'ADQ.3.3.1', 'no', 0, 'sis_parametros/vista/proveedor_item_servicio/ProveedorItemServicio.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'ADQ.3.3.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'ADQ.3.3.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 4, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'ADQ.3.3.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 5, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'ADQ.3.3.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBSOL.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', 'DocumentoWf', 'ADQ');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'VBSOL.3', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 3, '', 'proveedor', 'ADQ');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'VBSOL.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 4, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Items/Servicios ofertados', 'Items/Servicios ofertados', 'VBSOL.3.1', 'no', 0, 'sis_parametros/vista/proveedor_item_servicio/ProveedorItemServicio.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBSOL.3.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBSOL.3.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 4, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBSOL.3.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 5, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBSOL.3.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'ADQ.4.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 3, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'ADQ.4.2', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 3, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'ADQ.4.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 4, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'ADQ.4.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'PROC.3', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', 'DocumentoWf', 'ADQ');
select pxp.f_insert_tgui ('Cotizacion de solicitud de compra', 'Cotizacion de solicitud de compra', 'PROC.4', 'no', 0, 'sis_adquisiciones/vista/cotizacion/CotizacionAdq.php', 3, '', '98%', 'ADQ');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'PROC.3.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 4, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Solicitar Contrato', 'Solicitar Contrato', 'PROC.4.1', 'no', 0, 'sis_adquisiciones/vista/cotizacion/SolContrato.php', 4, '', 'SolContrato', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'PROC.4.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', 'DocumentoWf', 'ADQ');
select pxp.f_insert_tgui ('Detalles Cotizacion', 'Detalles Cotizacion', 'PROC.4.3', 'no', 0, 'sis_adquisiciones/vista/cotizacion_det/CotizacionDet.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Chequeo de documentos de la solicitud', 'Chequeo de documentos de la solicitud', 'VBCOT.1', 'no', 0, 'sis_adquisiciones/vista/documento_sol/ChequeoDocumentoSol.php', 3, '', 'ChequeoDocumentoSol', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBCOT.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', 'DocumentoWf', 'ADQ');
select pxp.f_insert_tgui ('Detalles Cotizacion', 'Detalles Cotizacion', 'VBCOT.3', 'no', 0, 'sis_adquisiciones/vista/cotizacion_det/CotizacionDet.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'VBCOT.1.1', 'no', 0, 'sis_adquisiciones/vista/documento_sol/SubirArchivo.php', 4, '', 'SubirArchivo', 'ADQ');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'VBCOT.1.2', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 4, '', 'proveedor', 'ADQ');
select pxp.f_insert_tgui ('Items/Servicios ofertados', 'Items/Servicios ofertados', 'VBCOT.1.2.1', 'no', 0, 'sis_parametros/vista/proveedor_item_servicio/ProveedorItemServicio.php', 5, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBCOT.1.2.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBCOT.1.2.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBCOT.1.2.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBCOT.1.2.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'VBCOT.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 4, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Partidas', 'Partidas', 'GRUP.1', 'no', 0, 'sis_adquisiciones/vista/grupo_partida/GrupoPartida.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Usuarios', 'Usuarios', 'GRUP.2', 'no', 0, 'sis_adquisiciones/vista/grupo_usuario/GrupoUsuario.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Usuarios', 'Usuarios', 'GRUP.2.1', 'no', 0, 'sis_seguridad/vista/usuario/Usuario.php', 5, '', 'usuario', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'GRUP.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Roles', 'Roles', 'GRUP.2.1.2', 'no', 0, 'sis_seguridad/vista/usuario_rol/UsuarioRol.php', 6, '', 'usuario_rol', 'ADQ');
select pxp.f_insert_tgui ('EP\', 'EP\', 'GRUP.2.1.3', 'no', 0, 'sis_seguridad/vista/usuario_grupo_ep/UsuarioGrupoEp.php', 6, '', ', 
          width:400,
          cls:', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'GRUP.2.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 7, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'PRECOM.1', 'no', 0, 'sis_adquisiciones/vista/presolicitud_det/PresolicitudReqDet.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'VBPRE.1', 'no', 0, 'sis_adquisiciones/vista/presolicitud_det/PresolicitudReqDet.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('fin_requerimiento', 'fin_requerimiento', 'COPRE.1', 'no', 0, 'west', 3, '', 'Finalizar', 'ADQ');
select pxp.f_insert_tgui ('Estados', 'Estados', 'COPRE.2', 'no', 0, 'sis_adquisiciones/vista/presolicitud/PresolicitudCon.php', 3, '', 'PresolicitudCon', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'COPRE.3', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/SolicitudReqDet.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'COPRE.4', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', 'DocumentoWf', 'ADQ');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'COPRE.5', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 3, '', 'proveedor', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'COPRE.2.1', 'no', 0, 'sis_adquisiciones/vista/presolicitud_det/PresolicitudConDet.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'COPRE.4.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 4, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Items/Servicios ofertados', 'Items/Servicios ofertados', 'COPRE.5.1', 'no', 0, 'sis_parametros/vista/proveedor_item_servicio/ProveedorItemServicio.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'COPRE.5.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'COPRE.5.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 4, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'COPRE.5.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 5, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'COPRE.5.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Solicitudes Pendientes', 'Solicitudes de compra aprobadas, pendientes de iniciio de proceso', 'SOLPEN', 'si', 5, 'sis_adquisiciones/vista/solicitud/SolicitudApro.php', 2, '', 'SolicitudApro', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'SOLPEN.1', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/SolicitudVbDet.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'SOLPEN.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', 'DocumentoWf', 'ADQ');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'SOLPEN.3', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 3, '', 'proveedor', 'ADQ');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'SOLPEN.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 4, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Items/Servicios ofertados', 'Items/Servicios ofertados', 'SOLPEN.3.1', 'no', 0, 'sis_parametros/vista/proveedor_item_servicio/ProveedorItemServicio.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLPEN.3.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'SOLPEN.3.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 4, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'SOLPEN.3.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 5, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLPEN.3.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Obligaciones de Pago', 'Obligaciones de Pago', 'OBPAGOA', 'si', 4, 'sis_tesoreria/vista/obligacion_pago/ObligacionPagoAdq.php', 2, '', 'ObligacionPagoAdq', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'OBPAGOA.1', 'no', 0, 'sis_tesoreria/vista/obligacion_det/ObligacionDet.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Plan de Pagos (Reg. Adq.)', 'Plan de Pagos (Reg. Adq.)', 'OBPAGOA.2', 'no', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoRegIni.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Reporte de Obligacion', 'Reporte de Obligacion', 'OBPAGOA.3', 'no', 0, 'sis_tesoreria/vista/obligacion_pago/ReporteComEjePag.php', 3, '', 'ReporteComEjePag', 'ADQ');
select pxp.f_insert_tgui ('Plan de Pagos', 'Plan de Pagos', 'OBPAGOA.4', 'no', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoReq.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'OBPAGOA.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', 'DocumentoWf', 'ADQ');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'OBPAGOA.6', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 3, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'OBPAGOA.7', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 3, '', 'proveedor', 'ADQ');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'OBPAGOA.8', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 3, '', 'funcionario', 'ADQ');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'OBPAGOA.2.1', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 4, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'OBPAGOA.2.2', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 4, '', 'Prorrateo', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'OBPAGOA.2.3', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', 'DocumentoWf', 'ADQ');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'OBPAGOA.2.3.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'OBPAGOA.4.1', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 4, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'OBPAGOA.4.2', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 4, '', 'Prorrateo', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'OBPAGOA.4.3', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', 'DocumentoWf', 'ADQ');
select pxp.f_insert_tgui ('Items/Servicios ofertados', 'Items/Servicios ofertados', 'OBPAGOA.7.1', 'no', 0, 'sis_parametros/vista/proveedor_item_servicio/ProveedorItemServicio.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OBPAGOA.7.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'OBPAGOA.7.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 4, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'OBPAGOA.7.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 5, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OBPAGOA.7.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'OBPAGOA.8.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 4, '', 'FuncionarioCuentaBancaria', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OBPAGOA.8.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'OBPAGOA.8.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_grupo_usuario_ime', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_grupo_partida_sel', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_calcular_total_costo_mb_adj_cot_det', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_gestionar_presupuesto_solicitud', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_grupo_sel', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_grupo_ime', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_inserta_cotizacion', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_finalizar_reg_solicitud', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_presolicitud_det_ime', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_grupo_usuario_sel', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_genera_preingreso', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_finalizar_cotizacion', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_grupo_partida_ime', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_presolicitud_ime', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_presolicitud_sel', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_presolicitud_det_sel', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tprocedimiento ('ADQ_SOL_SEL', 'Consulta de datos
    #DESCRIPCION_TEC:	 TIENE QUE DEVOLVER LAS MISMAS COLUMNAS QUE ADQ_HISSOL_SEL', 'si', '', '', 'adq.f_solicitud_sel');
select pxp.f_insert_tprocedimiento ('ADQ_COT_CONT', 'Conteo de registros de la consulta de cotizaciones', 'si', '', '', 'adq.f_cotizacion_sel');
select pxp.f_insert_tprocedimiento ('ADQ_DOCSOLAR_MOD', 'upload de archivo', 'si', '', '', 'adq.f_documento_sol_ime');
select pxp.f_insert_tprocedimiento ('ADQ_SOLAPRO_IME', 'depues de (Recomendar)adjudicar pasa al siguiente estado, de solicitud de aprobacion
    
    
    --  NO SE TIENE QUE USAR MAS ESTA TRASACCION', 'si', '', '', 'adq.f_cotizacion_ime');
select pxp.f_insert_tprocedimiento ('ADQ_COTRPC_SEL', 'Consulta de cotizaciones por estado dinamicos WF', 'si', '', '', 'adq.f_cotizacion_sel');
select pxp.f_insert_tprocedimiento ('ADQ_GRUS_INS', 'Insercion de registros', 'si', '', '', 'adq.ft_grupo_usuario_ime');
select pxp.f_insert_tprocedimiento ('ADQ_GRUS_MOD', 'Modificacion de registros', 'si', '', '', 'adq.ft_grupo_usuario_ime');
select pxp.f_insert_tprocedimiento ('ADQ_GRUS_ELI', 'Eliminacion de registros', 'si', '', '', 'adq.ft_grupo_usuario_ime');
select pxp.f_insert_tprocedimiento ('ADQ_GRPA_SEL', 'Consulta de datos', 'si', '', '', 'adq.ft_grupo_partida_sel');
select pxp.f_insert_tprocedimiento ('ADQ_GRPA_CONT', 'Conteo de registros', 'si', '', '', 'adq.ft_grupo_partida_sel');
select pxp.f_insert_tprocedimiento ('ADQ_ESTPROC_SEL', 'Consulta estado de procesos', 'si', '', '', 'adq.f_solicitud_sel');
select pxp.f_insert_tprocedimiento ('ADQ_GRU_SEL', 'Consulta de datos', 'si', '', '', 'adq.ft_grupo_sel');
select pxp.f_insert_tprocedimiento ('ADQ_GRU_CONT', 'Conteo de registros', 'si', '', '', 'adq.ft_grupo_sel');
select pxp.f_insert_tprocedimiento ('ADQ_GRU_INS', 'Insercion de registros', 'si', '', '', 'adq.ft_grupo_ime');
select pxp.f_insert_tprocedimiento ('ADQ_GRU_MOD', 'Modificacion de registros', 'si', '', '', 'adq.ft_grupo_ime');
select pxp.f_insert_tprocedimiento ('ADQ_GRU_ELI', 'Eliminacion de registros', 'si', '', '', 'adq.ft_grupo_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PROCSOL_SEL', 'Consulta de datos', 'si', '', '', 'adq.f_proceso_compra_sel');
select pxp.f_insert_tprocedimiento ('ADQ_PRED_INS', 'Insercion de registros', 'si', '', '', 'adq.ft_presolicitud_det_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PRED_MOD', 'Modificacion de registros', 'si', '', '', 'adq.ft_presolicitud_det_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PRED_ELI', 'Eliminacion de registros', 'si', '', '', 'adq.ft_presolicitud_det_ime');
select pxp.f_insert_tprocedimiento ('ADQ_GRUS_SEL', 'Consulta de datos', 'si', '', '', 'adq.ft_grupo_usuario_sel');
select pxp.f_insert_tprocedimiento ('ADQ_GRUS_CONT', 'Conteo de registros', 'si', '', '', 'adq.ft_grupo_usuario_sel');
select pxp.f_insert_tprocedimiento ('ADQ_GRPA_INS', 'Insercion de registros', 'si', '', '', 'adq.ft_grupo_partida_ime');
select pxp.f_insert_tprocedimiento ('ADQ_GRPA_MOD', 'Modificacion de registros', 'si', '', '', 'adq.ft_grupo_partida_ime');
select pxp.f_insert_tprocedimiento ('ADQ_GRPA_ELI', 'Eliminacion de registros', 'si', '', '', 'adq.ft_grupo_partida_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PRES_INS', 'Insercion de registros', 'si', '', '', 'adq.ft_presolicitud_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PRES_MOD', 'Modificacion de registros', 'si', '', '', 'adq.ft_presolicitud_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PRES_ELI', 'Eliminacion de registros', 'si', '', '', 'adq.ft_presolicitud_ime');
select pxp.f_insert_tprocedimiento ('ADQ_FINPRES_IME', 'Finalizacion de presolicitud', 'si', '', '', 'adq.ft_presolicitud_ime');
select pxp.f_insert_tprocedimiento ('ADQ_RETPRES_IME', 'retroceder presolicitud', 'si', '', '', 'adq.ft_presolicitud_ime');
select pxp.f_insert_tprocedimiento ('ADQ_APRPRES_IME', 'aprobar  presolicitud', 'si', '', '', 'adq.ft_presolicitud_ime');
select pxp.f_insert_tprocedimiento ('ADQ_CONSOL_IME', 'consolida presolicitudes', 'si', '', '', 'adq.ft_presolicitud_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PRES_SEL', 'Consulta de datos', 'si', '', '', 'adq.ft_presolicitud_sel');
select pxp.f_insert_tprocedimiento ('ADQ_PRES_CONT', 'Conteo de registros', 'si', '', '', 'adq.ft_presolicitud_sel');
select pxp.f_insert_tprocedimiento ('ADQ_PRESREP_SEL', 'Consulta de datos con id_presolicitud', 'si', '', '', 'adq.ft_presolicitud_sel');
select pxp.f_insert_tprocedimiento ('ADQ_ASIGPROC_IME', 'Asignacion de usuarios auxiliares responsables del proceso de compra', 'si', '', '', 'adq.f_proceso_compra_ime');
select pxp.f_insert_tprocedimiento ('ADQ_FINPRO_IME', 'Finaliza el proceso de compra, la solictud y revierte el presupeusto sobrante.', 'si', '', '', 'adq.f_proceso_compra_ime');
select pxp.f_insert_tprocedimiento ('ADQ_REVPRE_IME', 'Reversion del presupuesto sobrante no adjudicado en el proceso', 'si', '', '', 'adq.f_proceso_compra_ime');
select pxp.f_insert_tprocedimiento ('ADQ_SIGECOT_IME', 'funcion que controla el cambio al Siguiente esado de la solicitud, integrado con el WF', 'si', '', '', 'adq.f_cotizacion_ime');
select pxp.f_insert_tprocedimiento ('ADQ_OBEPUO_IME', 'Finaliza el registro de la cotizacion y pasa al siguiente este que es cotizado
                    donde estara listo para adjudicar', 'si', '', '', 'adq.f_cotizacion_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PREING_GEN', 'Habilita los pagos en tesoreria en modulo de cuentas por pagar', 'si', '', '', 'adq.f_cotizacion_ime');
select pxp.f_insert_tprocedimiento ('ADQ_SOLCON_IME', 'Obtener listado de up y ep correspondientes a los centros de costo
                    del detalle de la cotizacion adjudicados al proveedor', 'si', '', '', 'adq.f_cotizacion_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PRED_SEL', 'Consulta de datos', 'si', '', '', 'adq.ft_presolicitud_det_sel');
select pxp.f_insert_tprocedimiento ('ADQ_PRED_CONT', 'Conteo de registros', 'si', '', '', 'adq.ft_presolicitud_det_sel');
select pxp.f_insert_tprocedimiento ('ADQ_COTPROC_SEL', 'Consulta de datos', 'si', '', '', 'adq.f_cotizacion_sel');
select pxp.f_insert_tprocedimiento ('ADQ_OBPGCOT_SEL', 'Consulta de datos', 'si', '', '', 'adq.f_cotizacion_sel');
select pxp.f_insert_tprocedimiento ('ADQ_ESTCOT_SEL', 'Consulta de registros para los reportes', 'si', '', '', 'adq.f_cotizacion_sel');
select pxp.f_insert_trol ('Interface de Solicitud de Compra,  directos y secretarias', 'ADQ - Solicitud de Compra', 'ADQ');
select pxp.f_insert_trol ('Visto Bueno Solicitud de Compras', 'ADQ - Visto Bueno Sol', 'ADQ');
select pxp.f_insert_trol ('Visto bueno orden de compra cotizacion', 'ADQ - Visto Bueno OC/COT', 'ADQ');
select pxp.f_delete_trol ('ADQ - Visto Bueno DEV/PAG');
select pxp.f_insert_trol ('Resposnable de Adquisiciones', 'ADQ. RESP ADQ', 'ADQ');
select pxp.f_insert_trol ('ADQ - Aux Adquisiciones', 'ADQ - Aux Adquisiciones', 'ADQ');
select pxp.f_insert_trol ('Presolicitudes de Compra', 'ADQ - Presolicitud de Compra', 'ADQ');
select pxp.f_insert_trol ('Registro de Proveedores', 'ADQ - Registro Proveedores', 'ADQ');
select pxp.f_insert_trol ('Visto bueno presolicitudes de compra', 'ADQ - VioBo Presolicitud', 'ADQ');
select pxp.f_insert_trol ('Consolidador de presolicitudes de Compra', 'ADQ - Consolidaro Presolicitudes', 'ADQ');
select pxp.f_delete_trol ('OP - VoBo Plan de PAgos');


/***********************************F-DAT-RAC-ADQ-00-03/02/2014*****************************************/

/***********************************I-DAT-JRR-ADQ-0-24/04/2014*****************************************/
select pxp.f_insert_tgui ('Visto Bueno Cotizacion', 'Visto Bueno Cotizacion', 'VBCOT', 'si', 7, 'sis_adquisiciones/vista/cotizacion/CotizacionVbDin.php', 2, '', 'CotizacionVbDin', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'ADQ.3.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', 'DocumentoWf', 'ADQ');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'ADQ.3.3', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 3, '', 'proveedor', 'ADQ');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'ADQ.3.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 4, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Items/Servicios ofertados', 'Items/Servicios ofertados', 'ADQ.3.3.1', 'no', 0, 'sis_parametros/vista/proveedor_item_servicio/ProveedorItemServicio.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'ADQ.3.3.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'ADQ.3.3.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 4, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'ADQ.3.3.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 5, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'ADQ.3.3.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBSOL.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', 'DocumentoWf', 'ADQ');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'VBSOL.3', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 3, '', 'proveedor', 'ADQ');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'VBSOL.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 4, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Items/Servicios ofertados', 'Items/Servicios ofertados', 'VBSOL.3.1', 'no', 0, 'sis_parametros/vista/proveedor_item_servicio/ProveedorItemServicio.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBSOL.3.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBSOL.3.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 4, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBSOL.3.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 5, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBSOL.3.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'ADQ.4.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 3, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'ADQ.4.2', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 3, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'ADQ.4.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 4, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'ADQ.4.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'PROC.3', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', 'DocumentoWf', 'ADQ');
select pxp.f_insert_tgui ('Cotizacion de solicitud de compra', 'Cotizacion de solicitud de compra', 'PROC.4', 'no', 0, 'sis_adquisiciones/vista/cotizacion/CotizacionAdq.php', 3, '', '98%', 'ADQ');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'PROC.3.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 4, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Solicitar Contrato', 'Solicitar Contrato', 'PROC.4.1', 'no', 0, 'sis_adquisiciones/vista/cotizacion/SolContrato.php', 4, '', 'SolContrato', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'PROC.4.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', 'DocumentoWf', 'ADQ');
select pxp.f_insert_tgui ('Detalles Cotizacion', 'Detalles Cotizacion', 'PROC.4.3', 'no', 0, 'sis_adquisiciones/vista/cotizacion_det/CotizacionDet.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Chequeo de documentos de la solicitud', 'Chequeo de documentos de la solicitud', 'VBCOT.1', 'no', 0, 'sis_adquisiciones/vista/documento_sol/ChequeoDocumentoSol.php', 3, '', 'ChequeoDocumentoSol', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBCOT.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', 'DocumentoWf', 'ADQ');
select pxp.f_insert_tgui ('Detalles Cotizacion', 'Detalles Cotizacion', 'VBCOT.3', 'no', 0, 'sis_adquisiciones/vista/cotizacion_det/CotizacionDet.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'VBCOT.1.1', 'no', 0, 'sis_adquisiciones/vista/documento_sol/SubirArchivo.php', 4, '', 'SubirArchivo', 'ADQ');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'VBCOT.1.2', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 4, '', 'proveedor', 'ADQ');
select pxp.f_insert_tgui ('Items/Servicios ofertados', 'Items/Servicios ofertados', 'VBCOT.1.2.1', 'no', 0, 'sis_parametros/vista/proveedor_item_servicio/ProveedorItemServicio.php', 5, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBCOT.1.2.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBCOT.1.2.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBCOT.1.2.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBCOT.1.2.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'VBCOT.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 4, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Partidas', 'Partidas', 'GRUP.1', 'no', 0, 'sis_adquisiciones/vista/grupo_partida/GrupoPartida.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Usuarios', 'Usuarios', 'GRUP.2', 'no', 0, 'sis_adquisiciones/vista/grupo_usuario/GrupoUsuario.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Usuarios', 'Usuarios', 'GRUP.2.1', 'no', 0, 'sis_seguridad/vista/usuario/Usuario.php', 5, '', 'usuario', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'GRUP.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Roles', 'Roles', 'GRUP.2.1.2', 'no', 0, 'sis_seguridad/vista/usuario_rol/UsuarioRol.php', 6, '', 'usuario_rol', 'ADQ');
select pxp.f_insert_tgui ('EP\', 'EP\', 'GRUP.2.1.3', 'no', 0, 'sis_seguridad/vista/usuario_grupo_ep/UsuarioGrupoEp.php', 6, '', ', 
          width:400,
          cls:', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'GRUP.2.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 7, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'PRECOM.1', 'no', 0, 'sis_adquisiciones/vista/presolicitud_det/PresolicitudReqDet.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'VBPRE.1', 'no', 0, 'sis_adquisiciones/vista/presolicitud_det/PresolicitudReqDet.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('fin_requerimiento', 'fin_requerimiento', 'COPRE.1', 'no', 0, 'west', 3, '', 'Finalizar', 'ADQ');
select pxp.f_insert_tgui ('Estados', 'Estados', 'COPRE.2', 'no', 0, 'sis_adquisiciones/vista/presolicitud/PresolicitudCon.php', 3, '', 'PresolicitudCon', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'COPRE.3', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/SolicitudReqDet.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'COPRE.4', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', 'DocumentoWf', 'ADQ');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'COPRE.5', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 3, '', 'proveedor', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'COPRE.2.1', 'no', 0, 'sis_adquisiciones/vista/presolicitud_det/PresolicitudConDet.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'COPRE.4.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 4, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Items/Servicios ofertados', 'Items/Servicios ofertados', 'COPRE.5.1', 'no', 0, 'sis_parametros/vista/proveedor_item_servicio/ProveedorItemServicio.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'COPRE.5.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'COPRE.5.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 4, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'COPRE.5.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 5, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'COPRE.5.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Solicitudes Pendientes', 'Solicitudes de compra aprobadas, pendientes de iniciio de proceso', 'SOLPEN', 'si', 5, 'sis_adquisiciones/vista/solicitud/SolicitudApro.php', 2, '', 'SolicitudApro', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'SOLPEN.1', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/SolicitudVbDet.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'SOLPEN.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', 'DocumentoWf', 'ADQ');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'SOLPEN.3', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 3, '', 'proveedor', 'ADQ');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'SOLPEN.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 4, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Items/Servicios ofertados', 'Items/Servicios ofertados', 'SOLPEN.3.1', 'no', 0, 'sis_parametros/vista/proveedor_item_servicio/ProveedorItemServicio.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLPEN.3.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'SOLPEN.3.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 4, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'SOLPEN.3.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 5, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLPEN.3.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Obligaciones de Pago', 'Obligaciones de Pago', 'OBPAGOA', 'si', 4, 'sis_tesoreria/vista/obligacion_pago/ObligacionPagoAdq.php', 2, '', 'ObligacionPagoAdq', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'OBPAGOA.1', 'no', 0, 'sis_tesoreria/vista/obligacion_det/ObligacionDet.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Plan de Pagos (Reg. Adq.)', 'Plan de Pagos (Reg. Adq.)', 'OBPAGOA.2', 'no', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoRegIni.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Reporte de Obligacion', 'Reporte de Obligacion', 'OBPAGOA.3', 'no', 0, 'sis_tesoreria/vista/obligacion_pago/ReporteComEjePag.php', 3, '', 'ReporteComEjePag', 'ADQ');
select pxp.f_insert_tgui ('Plan de Pagos', 'Plan de Pagos', 'OBPAGOA.4', 'no', 0, 'sis_tesoreria/vista/plan_pago/PlanPagoReq.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'OBPAGOA.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', 'DocumentoWf', 'ADQ');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'OBPAGOA.6', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 3, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'OBPAGOA.7', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 3, '', 'proveedor', 'ADQ');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'OBPAGOA.8', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 3, '', 'funcionario', 'ADQ');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'OBPAGOA.2.1', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 4, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'OBPAGOA.2.2', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 4, '', 'Prorrateo', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'OBPAGOA.2.3', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', 'DocumentoWf', 'ADQ');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'OBPAGOA.2.3.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Disponibilidad Presupuestaria', 'Disponibilidad Presupuestaria', 'OBPAGOA.4.1', 'no', 0, 'sis_presupuestos/vista/verificacion_presup/VerificacionPresup.php', 4, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Prorrateo', 'Prorrateo', 'OBPAGOA.4.2', 'no', 0, 'sis_tesoreria/vista/prorrateo/Prorrateo.php', 4, '', 'Prorrateo', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'OBPAGOA.4.3', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', 'DocumentoWf', 'ADQ');
select pxp.f_insert_tgui ('Items/Servicios ofertados', 'Items/Servicios ofertados', 'OBPAGOA.7.1', 'no', 0, 'sis_parametros/vista/proveedor_item_servicio/ProveedorItemServicio.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OBPAGOA.7.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'OBPAGOA.7.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 4, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'OBPAGOA.7.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 5, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OBPAGOA.7.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'OBPAGOA.8.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 4, '', 'FuncionarioCuentaBancaria', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OBPAGOA.8.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'OBPAGOA.8.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'ADQ.3.2.2', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 4, '', 'TipoDocumentoEstadoWF', 'ADQ');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBSOL.2.2', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 4, '', 'TipoDocumentoEstadoWF', 'ADQ');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'PROC.3.2', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 4, '', 'TipoDocumentoEstadoWF', 'ADQ');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBCOT.2.2', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 4, '', 'TipoDocumentoEstadoWF', 'ADQ');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'COPRE.4.2', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 4, '', 'TipoDocumentoEstadoWF', 'ADQ');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'SOLPEN.2.2', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 4, '', 'TipoDocumentoEstadoWF', 'ADQ');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'OBPAGOA.2.3.2', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', 'TipoDocumentoEstadoWF', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'ADQ.3.3.3.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBSOL.3.3.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'ADQ.4.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 5, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'PROC.4.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'PROC.4.2.2', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', 'TipoDocumentoEstadoWF', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'COPRE.5.3.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'SOLPEN.3.3.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'OBPAGOA.4.3.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'OBPAGOA.4.3.2', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', 'TipoDocumentoEstadoWF', 'ADQ');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'OBPAGOA.5.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 4, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'OBPAGOA.5.2', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 4, '', 'TipoDocumentoEstadoWF', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'OBPAGOA.7.3.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OBPAGOA.8.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'OBPAGOA.8.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 7, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'OBPAGOA.8.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 5, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Solicitar Contrato', 'Solicitar Contrato', 'ADQ.3.4', 'no', 0, 'sis_adquisiciones/vista/solicitud/SolModPresupuesto.php', 3, '', 'SolModPresupuesto', 'ADQ');
select pxp.f_insert_tgui ('Solicitar Contrato', 'Solicitar Contrato', 'VBSOL.4', 'no', 0, 'sis_adquisiciones/vista/solicitud/SolModPresupuesto.php', 3, '', 'SolModPresupuesto', 'ADQ');
select pxp.f_insert_tgui ('Solicitar Contrato', 'Solicitar Contrato', 'COPRE.6', 'no', 0, 'sis_adquisiciones/vista/solicitud/SolModPresupuesto.php', 3, '', 'SolModPresupuesto', 'ADQ');
select pxp.f_insert_tgui ('Solicitar Contrato', 'Solicitar Contrato', 'SOLPEN.4', 'no', 0, 'sis_adquisiciones/vista/solicitud/SolModPresupuesto.php', 3, '', 'SolModPresupuesto', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_grupo_usuario_ime', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_grupo_partida_sel', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_calcular_total_costo_mb_adj_cot_det', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_gestionar_presupuesto_solicitud', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_grupo_sel', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_grupo_ime', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_inserta_cotizacion', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_finalizar_reg_solicitud', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_presolicitud_det_ime', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_grupo_usuario_sel', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_genera_preingreso', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_finalizar_cotizacion', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_grupo_partida_ime', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_presolicitud_ime', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_presolicitud_sel', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_presolicitud_det_sel', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tprocedimiento ('ADQ_SOL_SEL', 'Consulta de datos
    #DESCRIPCION_TEC:	 TIENE QUE DEVOLVER LAS MISMAS COLUMNAS QUE ADQ_HISSOL_SEL', 'si', '', '', 'adq.f_solicitud_sel');
select pxp.f_insert_tprocedimiento ('ADQ_COT_CONT', 'Conteo de registros de la consulta de cotizaciones', 'si', '', '', 'adq.f_cotizacion_sel');
select pxp.f_insert_tprocedimiento ('ADQ_DOCSOLAR_MOD', 'upload de archivo', 'si', '', '', 'adq.f_documento_sol_ime');
select pxp.f_insert_tprocedimiento ('ADQ_SOLAPRO_IME', 'depues de (Recomendar)adjudicar pasa al siguiente estado, de solicitud de aprobacion
    
    
    --  NO SE TIENE QUE USAR MAS ESTA TRASACCION', 'si', '', '', 'adq.f_cotizacion_ime');
select pxp.f_insert_tprocedimiento ('ADQ_COTRPC_SEL', 'Consulta de cotizaciones por estado dinamicos WF', 'si', '', '', 'adq.f_cotizacion_sel');
select pxp.f_insert_tprocedimiento ('ADQ_GRUS_INS', 'Insercion de registros', 'si', '', '', 'adq.ft_grupo_usuario_ime');
select pxp.f_insert_tprocedimiento ('ADQ_GRUS_MOD', 'Modificacion de registros', 'si', '', '', 'adq.ft_grupo_usuario_ime');
select pxp.f_insert_tprocedimiento ('ADQ_GRUS_ELI', 'Eliminacion de registros', 'si', '', '', 'adq.ft_grupo_usuario_ime');
select pxp.f_insert_tprocedimiento ('ADQ_GRPA_SEL', 'Consulta de datos', 'si', '', '', 'adq.ft_grupo_partida_sel');
select pxp.f_insert_tprocedimiento ('ADQ_GRPA_CONT', 'Conteo de registros', 'si', '', '', 'adq.ft_grupo_partida_sel');
select pxp.f_insert_tprocedimiento ('ADQ_ESTPROC_SEL', 'Consulta estado de procesos', 'si', '', '', 'adq.f_solicitud_sel');
select pxp.f_insert_tprocedimiento ('ADQ_GRU_SEL', 'Consulta de datos', 'si', '', '', 'adq.ft_grupo_sel');
select pxp.f_insert_tprocedimiento ('ADQ_GRU_CONT', 'Conteo de registros', 'si', '', '', 'adq.ft_grupo_sel');
select pxp.f_insert_tprocedimiento ('ADQ_GRU_INS', 'Insercion de registros', 'si', '', '', 'adq.ft_grupo_ime');
select pxp.f_insert_tprocedimiento ('ADQ_GRU_MOD', 'Modificacion de registros', 'si', '', '', 'adq.ft_grupo_ime');
select pxp.f_insert_tprocedimiento ('ADQ_GRU_ELI', 'Eliminacion de registros', 'si', '', '', 'adq.ft_grupo_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PROCSOL_SEL', 'Consulta de datos', 'si', '', '', 'adq.f_proceso_compra_sel');
select pxp.f_insert_tprocedimiento ('ADQ_PRED_INS', 'Insercion de registros', 'si', '', '', 'adq.ft_presolicitud_det_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PRED_MOD', 'Modificacion de registros', 'si', '', '', 'adq.ft_presolicitud_det_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PRED_ELI', 'Eliminacion de registros', 'si', '', '', 'adq.ft_presolicitud_det_ime');
select pxp.f_insert_tprocedimiento ('ADQ_GRUS_SEL', 'Consulta de datos', 'si', '', '', 'adq.ft_grupo_usuario_sel');
select pxp.f_insert_tprocedimiento ('ADQ_GRUS_CONT', 'Conteo de registros', 'si', '', '', 'adq.ft_grupo_usuario_sel');
select pxp.f_insert_tprocedimiento ('ADQ_GRPA_INS', 'Insercion de registros', 'si', '', '', 'adq.ft_grupo_partida_ime');
select pxp.f_insert_tprocedimiento ('ADQ_GRPA_MOD', 'Modificacion de registros', 'si', '', '', 'adq.ft_grupo_partida_ime');
select pxp.f_insert_tprocedimiento ('ADQ_GRPA_ELI', 'Eliminacion de registros', 'si', '', '', 'adq.ft_grupo_partida_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PRES_INS', 'Insercion de registros', 'si', '', '', 'adq.ft_presolicitud_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PRES_MOD', 'Modificacion de registros', 'si', '', '', 'adq.ft_presolicitud_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PRES_ELI', 'Eliminacion de registros', 'si', '', '', 'adq.ft_presolicitud_ime');
select pxp.f_insert_tprocedimiento ('ADQ_FINPRES_IME', 'Finalizacion de presolicitud', 'si', '', '', 'adq.ft_presolicitud_ime');
select pxp.f_insert_tprocedimiento ('ADQ_RETPRES_IME', 'retroceder presolicitud', 'si', '', '', 'adq.ft_presolicitud_ime');
select pxp.f_insert_tprocedimiento ('ADQ_APRPRES_IME', 'aprobar  presolicitud', 'si', '', '', 'adq.ft_presolicitud_ime');
select pxp.f_insert_tprocedimiento ('ADQ_CONSOL_IME', 'consolida presolicitudes', 'si', '', '', 'adq.ft_presolicitud_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PRES_SEL', 'Consulta de datos', 'si', '', '', 'adq.ft_presolicitud_sel');
select pxp.f_insert_tprocedimiento ('ADQ_PRES_CONT', 'Conteo de registros', 'si', '', '', 'adq.ft_presolicitud_sel');
select pxp.f_insert_tprocedimiento ('ADQ_PRESREP_SEL', 'Consulta de datos con id_presolicitud', 'si', '', '', 'adq.ft_presolicitud_sel');
select pxp.f_insert_tprocedimiento ('ADQ_ASIGPROC_IME', 'Asignacion de usuarios auxiliares responsables del proceso de compra', 'si', '', '', 'adq.f_proceso_compra_ime');
select pxp.f_insert_tprocedimiento ('ADQ_FINPRO_IME', 'Finaliza el proceso de compra, la solictud y revierte el presupeusto sobrante.', 'si', '', '', 'adq.f_proceso_compra_ime');
select pxp.f_insert_tprocedimiento ('ADQ_REVPRE_IME', 'Reversion del presupuesto sobrante no adjudicado en el proceso', 'si', '', '', 'adq.f_proceso_compra_ime');
select pxp.f_insert_tprocedimiento ('ADQ_SIGECOT_IME', 'funcion que controla el cambio al Siguiente esado de la solicitud, integrado con el WF', 'si', '', '', 'adq.f_cotizacion_ime');
select pxp.f_insert_tprocedimiento ('ADQ_OBEPUO_IME', 'Finaliza el registro de la cotizacion y pasa al siguiente este que es cotizado
                    donde estara listo para adjudicar', 'si', '', '', 'adq.f_cotizacion_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PREING_GEN', 'Habilita los pagos en tesoreria en modulo de cuentas por pagar', 'si', '', '', 'adq.f_cotizacion_ime');
select pxp.f_insert_tprocedimiento ('ADQ_SOLCON_IME', 'Obtener listado de up y ep correspondientes a los centros de costo
                    del detalle de la cotizacion adjudicados al proveedor', 'si', '', '', 'adq.f_cotizacion_ime');
select pxp.f_insert_tprocedimiento ('ADQ_PRED_SEL', 'Consulta de datos', 'si', '', '', 'adq.ft_presolicitud_det_sel');
select pxp.f_insert_tprocedimiento ('ADQ_PRED_CONT', 'Conteo de registros', 'si', '', '', 'adq.ft_presolicitud_det_sel');
select pxp.f_insert_tprocedimiento ('ADQ_COTPROC_SEL', 'Consulta de datos', 'si', '', '', 'adq.f_cotizacion_sel');
select pxp.f_insert_tprocedimiento ('ADQ_OBPGCOT_SEL', 'Consulta de datos', 'si', '', '', 'adq.f_cotizacion_sel');
select pxp.f_insert_tprocedimiento ('ADQ_ESTCOT_SEL', 'Consulta de registros para los reportes', 'si', '', '', 'adq.f_cotizacion_sel');
select pxp.f_insert_trol ('Interface de Solicitud de Compra,  directos y secretarias', 'ADQ - Solicitud de Compra', 'ADQ');
select pxp.f_insert_trol ('Visto Bueno Solicitud de Compras', 'ADQ - Visto Bueno Sol', 'ADQ');
select pxp.f_insert_trol ('Visto bueno orden de compra cotizacion', 'ADQ - Visto Bueno OC/COT', 'ADQ');
select pxp.f_delete_trol ('ADQ - Visto Bueno DEV/PAG');
select pxp.f_insert_trol ('Resposnable de Adquisiciones', 'ADQ. RESP ADQ', 'ADQ');
select pxp.f_insert_trol ('ADQ - Aux Adquisiciones', 'ADQ - Aux Adquisiciones', 'ADQ');
select pxp.f_insert_trol ('Presolicitudes de Compra', 'ADQ - Presolicitud de Compra', 'ADQ');
select pxp.f_insert_trol ('Registro de Proveedores', 'ADQ - Registro Proveedores', 'ADQ');
select pxp.f_insert_trol ('Visto bueno presolicitudes de compra', 'ADQ - VioBo Presolicitud', 'ADQ');
select pxp.f_insert_trol ('Consolidador de presolicitudes de Compra', 'ADQ - Consolidaro Presolicitudes', 'ADQ');
select pxp.f_delete_trol ('OP - VoBo Plan de PAgos');
select pxp.f_insert_trol ('Para el Encargado de habilitar los preingreso y enviarlos al modulo de activos fijos', 'ADQ - Preingreso AF', 'ADQ');


/***********************************F-DAT-JRR-ADQ-0-24/04/2014*****************************************/





/***********************************I-DAT-RAC-ADQ-0-05/06/2014*****************************************/


---------------------------------
--COPY LINES TO data.sql FILE  
---------------------------------

select pxp.f_insert_tgui ('RPC', 'Configuracion de RPC', 'RPCI', 'si', 3, 'sis_adquisiciones/vista/rpc/Rpc.php', 3, '', 'Rpc', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'PROC.4.4', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OBPAGOA.2.4', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OBPAGOA.2.5', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OBPAGOA.4.4', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OBPAGOA.4.5', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', '../../sis_tesoreria/control/PlanPago/siguienteEstadoPlanPago', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'RPCI.1', 'no', 0, 'sis_adquisiciones/vista/rpc_uo/RpcUo.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Solicitudes en proceso del RPC', 'Solicitudes en proceso del RPC', 'RPCI.2', 'no', 0, 'sis_adquisiciones/vista/solicitud/SolicitudRpc.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('LOG', 'LOG', 'RPCI.3', 'no', 0, 'sis_adquisiciones/vista/rpc_uo_log/RpcUoLog.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'RPCI.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Solicitar Traspaso presupuestario', 'Solicitar Traspaso presupuestario', 'RPCI.2.2', 'no', 0, 'sis_adquisiciones/vista/solicitud/SolModPresupuesto.php', 5, '', 'SolModPresupuesto', 'ADQ');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'RPCI.2.3', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 5, '', 'proveedor', 'ADQ');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'RPCI.2.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'RPCI.2.1.2', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', 'TipoDocumentoEstadoWF', 'ADQ');
select pxp.f_insert_tgui ('Items/Servicios ofertados', 'Items/Servicios ofertados', 'RPCI.2.3.1', 'no', 0, 'sis_parametros/vista/proveedor_item_servicio/ProveedorItemServicio.php', 6, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'RPCI.2.3.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'RPCI.2.3.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'RPCI.2.3.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 7, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'RPCI.2.3.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'RPCI.2.3.3.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 8, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_validar_preingreso_activo_fijo', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_lista_depto_tesoreria_wf_sel', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_genera_preingreso_af_al', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_validar_preingreso_almacen', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_get_desc_cotizaciones', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_inserta_rpc_uo', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_obtener_listado_rpc', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_trig_rpc', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_trig_rpc_uo', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_rpc_ime', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_rpc_sel', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_rpc_uo_ime', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_rpc_uo_log_sel', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.ft_rpc_uo_sel', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tprocedimiento ('ADQ_SIGECOT_IME', 'funcion que controla el cambio al Siguiente esado de la cotizacion, integrado con el WF', 'si', '', '', 'adq.f_cotizacion_ime');
select pxp.f_insert_tprocedimiento ('ADQ_RPC_INS', 'Insercion de registros de rpc', 'si', '', '', 'adq.ft_rpc_ime');
select pxp.f_insert_tprocedimiento ('ADQ_RPC_MOD', 'Modificacion de registros', 'si', '', '', 'adq.ft_rpc_ime');
select pxp.f_insert_tprocedimiento ('ADQ_RPC_ELI', 'Eliminacion de registros', 'si', '', '', 'adq.ft_rpc_ime');
select pxp.f_insert_tprocedimiento ('ADQ_CHARPC_IME', 'Cambia el RPC segun configuracion', 'si', '', '', 'adq.ft_rpc_ime');
select pxp.f_insert_tprocedimiento ('ADQ_CLONRPC_IME', 'clona el rpc selecionado en sus registros marcados con la fecha inicial y fecha fin,
                    hacia el id_cargo selecionado en las nueva fecha inicio y fecha fin', 'si', '', '', 'adq.ft_rpc_ime');
select pxp.f_insert_tprocedimiento ('ADQ_RPC_SEL', 'Consulta de datos', 'si', '', '', 'adq.ft_rpc_sel');
select pxp.f_insert_tprocedimiento ('ADQ_RPC_CONT', 'Conteo de registros', 'si', '', '', 'adq.ft_rpc_sel');
select pxp.f_insert_tprocedimiento ('ADQ_RUO_INS', 'Insercion de registros', 'si', '', '', 'adq.ft_rpc_uo_ime');
select pxp.f_insert_tprocedimiento ('ADQ_RUO_MOD', 'Modificacion de registros', 'si', '', '', 'adq.ft_rpc_uo_ime');
select pxp.f_insert_tprocedimiento ('ADQ_RUO_ELI', 'Eliminacion de registros', 'si', '', '', 'adq.ft_rpc_uo_ime');
select pxp.f_insert_tprocedimiento ('ADQ_RPCL_SEL', 'Consulta de datos', 'si', '', '', 'adq.ft_rpc_uo_log_sel');
select pxp.f_insert_tprocedimiento ('ADQ_RPCL_CONT', 'Conteo de registros', 'si', '', '', 'adq.ft_rpc_uo_log_sel');
select pxp.f_insert_tprocedimiento ('ADQ_RUO_SEL', 'Consulta de datos', 'si', '', '', 'adq.ft_rpc_uo_sel');
select pxp.f_insert_tprocedimiento ('ADQ_RUO_CONT', 'Conteo de registros', 'si', '', '', 'adq.ft_rpc_uo_sel');


/***********************************F-DAT-RAC-ADQ-0-05/06/2014*****************************************/


/***********************************I-DAT-RAC-ADQ-0-29/08/2014*****************************************/


select pxp.f_insert_tgui ('ADQUISICIONES', '', 'ADQ', 'si', 1, '', 1, '../../../lib/imagenes/adquisiciones.png', '', 'ADQ');
select pxp.f_insert_tgui ('Documento de Solicitud', 'Documento de Solicitud', 'ADQ.2', 'no', 20, 'sis_adquisiciones/vista/documento_sol/DocumentoSol.php', 2, '', 'DocumentoSol', 'ADQ');
select pxp.f_insert_tgui ('Solicitud de Compra', 'Solicitud de Compra', 'ADQ.3', 'si', 6, 'sis_adquisiciones/vista/solicitud/SolicitudReq.php', 2, '', 'SolicitudReq', 'ADQ');
select pxp.f_insert_tgui ('Visto Bueno Solicitud', 'Solicitud de Compra', 'VBSOL', 'si', 7, 'sis_adquisiciones/vista/solicitud/SolicitudVb.php', 2, '', 'SolicitudVb', 'ADQ');
select pxp.f_insert_tgui ('Proveedores', 'Proveedores de compra', 'ADQ.4', 'si', 2, 'sis_adquisiciones/vista/proveedor/Proveedor.php', 2, '', 'Proveedor', 'ADQ');
select pxp.f_insert_tgui ('Proceso Compra', 'Proceso de Compra', 'PROC', 'si', 9, 'sis_adquisiciones/vista/proceso_compra/ProcesoCompra.php', 2, '', 'ProcesoCompra', 'ADQ');
select pxp.f_insert_tgui ('Visto Bueno Cotizacion', 'Visto Bueno Cotizacion', 'VBCOT', 'si', 10, 'sis_adquisiciones/vista/cotizacion/CotizacionVbDin.php', 2, '', 'CotizacionVbDin', 'ADQ');
select pxp.f_insert_tgui ('Presolicitud de Compra', 'Presolicitud de Compra', 'PRECOM', 'si', 3, 'sis_adquisiciones/vista/presolicitud/PresolicitudReq.php', 2, '', 'PresolicitudReq', 'ADQ');
select pxp.f_insert_tgui ('Visto Bueno Presolicitud', 'Visto bueno de presolicitudes', 'VBPRE', 'si', 4, 'sis_adquisiciones/vista/presolicitud/PresolicitudVb.php', 2, '', 'PresolicitudVb', 'ADQ');
select pxp.f_insert_tgui ('Consolidad Presolicitudes', 'Consolidar presolicitudes', 'COPRE', 'si', 5, 'sis_adquisiciones/vista/solicitud/SolicitudReqCon.php', 2, '', 'SolicitudReqCon', 'ADQ');
select pxp.f_insert_tgui ('Solicitudes Pendientes', 'Solicitudes de compra aprobadas, pendientes de iniciio de proceso', 'SOLPEN', 'si', 8, 'sis_adquisiciones/vista/solicitud/SolicitudApro.php', 2, '', 'SolicitudApro', 'ADQ');
select pxp.f_insert_tgui ('Obligaciones de Pago', 'Obligaciones de Pago', 'OBPAGOA', 'si', 11, 'sis_tesoreria/vista/obligacion_pago/ObligacionPagoAdq.php', 2, '', 'ObligacionPagoAdq', 'ADQ');
select pxp.f_insert_tgui ('Prorrateo ...', 'Prorrateo ...', 'OBPAGOA.1.1', 'no', 0, 'sis_tesoreria/vista/tipo_prorrateo/WizardProrrateo.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_fun_inicio_solicitud_wf', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tfuncion ('adq.f_fun_regreso_solicitud_wf', 'Funcion para tabla     ', 'ADQ');
select pxp.f_insert_tprocedimiento ('ADQ_CLONRPC_IME', 'clona el rpc selecionado en sus registros marcados con la fecha inicial y fecha fin,
                    hacia el id_cargo selecionado en las nueva fecha inicio y fecha fin', 'si', '', '', 'adq.ft_rpc_ime');
select pxp.f_delete_trol ('ADQ - Visto Bueno DEV/PAG');
select pxp.f_delete_trol ('OP - VoBo Plan de PAgos');


/***********************************F-DAT-RAC-ADQ-0-29/08/2014*****************************************/



/***********************************I-DAT-RAC-ADQ-0-14/01/2015*****************************************/

select pxp.f_insert_tgui ('Visto Bueno Solicitud (Presupuestos)', 'Visto Bueno Solicitud (Presupuestos)', 'VBSOLP', 'si', 7, 'sis_adquisiciones/vista/solicitud/SolicitudVbPresupuesto.php', 2, '', 'SolicitudVbPresupuesto', 'ADQ');
select pxp.f_insert_testructura_gui ('VBSOLP', 'ADQ');

/***********************************F-DAT-RAC-ADQ-0-14/01/2015*****************************************/


/***********************************I-DAT-RAC-ADQ-0-04/02/2015*****************************************/


INSERT INTO pxp.variable_global ( "variable", "valor", "descripcion")
VALUES ( E'adq_aprobacion', E'gerencia', E'aprobaciones: gerencia o presupuesto,  para determinar si aprueban solo genretens o dueños de presupeustos');

/***********************************F-DAT-RAC-ADQ-0-04/02/2015*****************************************/


/***********************************I-DAT-RAC-ADQ-0-12/02/2015*****************************************/

select pxp.f_insert_tgui ('Reportes', 'Reportes', 'REPADQ', 'si', 45, '', 2, '', '', 'ADQ');
select pxp.f_insert_tgui ('Ejecución presupuestaria', 'Ejecución presupuestaria', 'ADQELEPRE', 'si', 1, 'sis_adquisiciones/vista/solicitud/SolReporteEje.php', 3, '', 'SolReporteEje', 'ADQ');
select pxp.f_insert_testructura_gui ('REPADQ', 'ADQ');
select pxp.f_insert_testructura_gui ('ADQELEPRE', 'REPADQ');


/***********************************F-DAT-RAC-ADQ-0-12/02/2015*****************************************/


/***********************************I-DAT-RAC-ADQ-0-02/03/2015*****************************************/

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'adq_tope_compra', E'1000000', E'Monto maximo decomprar por adquisiciones en moneda base');

/***********************************F-DAT-RAC-ADQ-0-02/03/2015*****************************************/



/***********************************I-DAT-RAC-ADQ-0-23/03/2015*****************************************/

select pxp.f_insert_tgui ('Cotizaciones/Ordenes', 'Cotizaciones y Ordenes de Compra', 'COTOC', 'si', 10, 'sis_adquisiciones/vista/cotizacion/CotizacionOC.php', 2, '', 'CotizacionOC', 'ADQ');
select pxp.f_insert_testructura_gui ('COTOC', 'ADQ');

/***********************************F-DAT-RAC-ADQ-0-23/03/2015*****************************************/


/***********************************I-DAT-RAC-ADQ-0-17/04/2015*****************************************/

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'adq_tope_compra_regional', E'40000', E'define el monto maximo de compra en moneda base para las regionales');

/***********************************F-DAT-RAC-ADQ-0-17/04/2015*****************************************/



/***********************************I-DAT-RAC-ADQ-0-06/05/2015*****************************************/

select pxp.f_insert_tgui ('VoBo Solicitud (Poa)', 'VoBo Solicitud (Poa)', 'VBPOA', 'si', 7, 'sis_adquisiciones/vista/solicitud/SolicitudVbPoa.php', 3, '', 'SolicitudVbPoa', 'ADQ');
select pxp.f_insert_testructura_gui ('VBPOA', 'ADQ');

/***********************************F-DAT-RAC-ADQ-0-06/05/2015*****************************************/



/***********************************I-DAT-RAC-ADQ-0-08/06/2015*****************************************/

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'adq_tope_compra_lista_blanca', E' ', E'lista de codigos  UOs  que pueden comprar por encima del tope');

/***********************************F-DAT-RAC-ADQ-0-08/06/2015*****************************************/



/***********************************I-DAT-RAC-ADQ-0-23/06/2015*****************************************/

select pxp.f_insert_tgui ('VoBo Solicitud (Poa)', 'VoBo Solicitud (Poa)', 'VBPOA', 'si', 7, 'sis_adquisiciones/vista/solicitud/SolicitudVb.php', 3, '', 'SolicitudVb', 'ADQ');
select pxp.f_insert_tgui ('Visto Bueno Solicitud (Presupuestos)', 'Visto Bueno Solicitud (Presupuestos)', 'VBSOLP', 'si', 7, 'sis_adquisiciones/vista/solicitud/SolicitudVb.php', 2, '', 'SolicitudVb', 'ADQ');

/***********************************F-DAT-RAC-ADQ-0-23/06/2015*****************************************/

/***********************************I-DAT-FEA-ADQ-0-25/01/2017*****************************************/
-- no existe este proceso en una restauracion limpia
--select wf.f_import_ttipo_documento ('insert','MEM','COTINPD','Memorándum de Designación Comité Recepcion','Memorándum de Designación Comité Recepcion','sis_adquisiciones/control/ProcesoCompra/reporteMemoDCR/','generado',1.00,'{}');

/***********************************F-DAT-FEA-ADQ-0-25/01/2017*****************************************/




/***********************************I-DAT-RAC-ADQ-0-01/08/2017*****************************************/


INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'adq_precotizacion_obligatorio', E'si', E'Obliga a registrar proveedor de precotizacion al solitar compras');


INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'adq_comprometer_presupuesto', E'si', E'indica si el sistema de adq compromete presupeustos con la solictud de compra');
  

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'adq_tolerancia_adjudicacion', E'0.2', E'% por el cual se puede adjudicar por demasia');  
  
  
  
  

/***********************************F-DAT-RAC-ADQ-0-01/08/2017*****************************************/




/***********************************I-DAT-RAC-ADQ-0-03/08/2017*****************************************/


INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'adq_requiere_rpc', E'si', E'Si requiere RPC al finzaliar al solicitud');
  


 
/***********************************F-DAT-RAC-ADQ-0-03/08/2017*****************************************/



/***********************************I-DAT-RAC-ADQ-0-12/10/2017*****************************************/
  
INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'adq_revisar_montos_categoria', E'no', E'revisar si el monto de la solcitud es coherente con la categoria seleccionado al fianlzar la  solicitud de compra');
  
/***********************************F-DAT-RAC-ADQ-0-12/10/2017*****************************************/
  
  
  
