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
select wf.f_insert_ttipo_proceso ('Habilitado para pagar', 'Obligacion de Pago', 'OBLI', 'tes.tobligacion_pago', 'id_obligacion_pago', 'activo', 'si', 'COMINT');
select wf.f_insert_ttipo_proceso ('En pago', 'ADQ. Plan de Pago Devengado', 'APLAD', 'tes.tplan_pago', 'id_plan_pago', 'activo', 'no', 'COMINT');
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
select wf.f_insert_ttipo_estado ('en_pago', 'En Pago', 'no', 'si', 'no', 'anterior', '', 'anterior', '', '', 'activo', 'OBLI', 'TPLAP');
select wf.f_insert_ttipo_estado ('anulado', 'Anulado', 'no', 'no', 'si', 'anterior', '', 'anterior', '', '', 'activo', 'COT', '');
select wf.f_insert_ttipo_estado ('anulado', 'Anulado', 'no', 'no', 'si', 'anterior', '', 'anterior', '', '', 'activo', 'SOLCO', '');
select wf.f_insert_ttipo_estado ('borrador', 'Borrador', 'si', 'no', 'no', 'anterior', '', 'anterior', '', '', 'activo', 'OBLI', '');
select wf.f_insert_ttipo_estado ('finalizado', 'Finalizado', 'no', 'no', 'si', 'anterior', '', 'anterior', '', '', 'activo', 'OBLI', '');
select wf.f_insert_ttipo_estado ('anulado', 'Anulado', 'no', 'no', 'si', 'anterior', '', 'anterior', '', '', 'activo', 'OBLI', '');
select wf.f_insert_ttipo_estado ('borrador', 'Borrador', 'si', 'no', 'no', 'anterior', '', 'anterior', '', '', 'activo', 'APLAD', '');
select wf.f_insert_ttipo_estado ('pendiente', 'Pendiente', 'no', 'no', 'no', 'anterior', '', 'anterior', '', '', 'activo', 'APLAD', '');
select wf.f_insert_ttipo_estado ('devengado', 'Devengado', 'no', 'si', 'no', 'anterior', '', 'anterior', '', '', 'activo', 'APLAD', '');
select wf.f_insert_ttipo_estado ('finalizado', 'Finalizado', 'no', 'no', 'si', 'anterior', '', 'anterior', '', '', 'activo', 'APLAD', '');
select wf.f_insert_ttipo_estado ('anulado', 'Anlado', 'no', 'no', 'si', 'anterior', '', 'anterior', '', '', 'activo', 'APLAD', '');
select wf.f_insert_testructura_estado ('proceso', 'SOLCO', 'finalizado', 'SOLCO', '2', 'ff2', 'activo');
select wf.f_insert_testructura_estado ('pendiente', 'SOLCO', 'vbactif', 'SOLCO', '3', '', 'activo');
select wf.f_insert_testructura_estado ('borrador', 'SOLCO', 'pendiente', 'SOLCO', '0', '', 'activo');
select wf.f_insert_testructura_estado ('vbactif', 'SOLCO', 'vbrpc', 'SOLCO', '1', '', 'activo');
select wf.f_insert_testructura_estado ('vbrpc', 'SOLCO', 'aprobado', 'SOLCO', '1', '', 'activo');
select wf.f_insert_testructura_estado ('aprobado', 'SOLCO', 'proceso', 'SOLCO', '1', '', 'activo');
select wf.f_insert_testructura_estado ('pendiente', 'PROC', 'proceso', 'PROC', '1', '', 'activo');
select wf.f_insert_testructura_estado ('borrador', 'COT', 'cotizado', 'COT', '1', '', 'activo');
select wf.f_insert_testructura_estado ('cotizado', 'COT', 'adjudicado', 'COT', '1', '', 'activo');
select wf.f_insert_testructura_estado ('adjudicado', 'COT', 'pago_habilitado', 'COT', '1', '', 'activo');
select wf.f_insert_testructura_estado ('proceso', 'PROC', 'finalizado', 'PROC', '1', '', 'activo');
select wf.f_insert_testructura_estado ('registrado', 'OBLI', 'en_pago', 'OBLI', '1', '', 'activo');
select wf.f_insert_testructura_estado ('pago_habilitado', 'COT', 'finalizada', 'COT', '1', '', 'activo');
select wf.f_insert_testructura_estado ('borrador', 'OBLI', 'registrado', 'OBLI', '1', '', 'activo');
select wf.f_insert_testructura_estado ('en_pago', 'OBLI', 'finalizado', 'OBLI', '1', '', 'activo');
select wf.f_insert_testructura_estado ('borrador', 'APLAD', 'pendiente', 'APLAD', '1', '', 'activo');
select wf.f_insert_testructura_estado ('pendiente', 'APLAD', 'devengado', 'APLAD', '1', '', 'activo');
select wf.f_insert_testructura_estado ('devengado', 'APLAD', 'finalizado', 'APLAD', 1, '', 'activo');

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

