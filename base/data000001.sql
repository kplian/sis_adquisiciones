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


/***********************************I-DAT-JRR-ADQ-104-04/04/2013****************************************/
update adq.tcategoria_compra
set id_proceso_macro = (select id_proceso_macro 
						from wf.tproceso_macro
						where codigo = 'COMINT');
  
/***********************************F-DAT-JRR-ADQ-104-04/04/2013****************************************/



/***********************************I-DAT-RAC-ADQ-0-04/02/2015*****************************************/


INSERT INTO pxp.variable_global ( "variable", "valor", "descripcion")
VALUES ( E'adq_aprobacion', E'gerencia', E'aprobaciones: gerencia o presupuesto,  para determinar si aprueban solo genretens o dueños de presupeustos');

/***********************************F-DAT-RAC-ADQ-0-04/02/2015*****************************************/




/***********************************I-DAT-RAC-ADQ-0-02/03/2015*****************************************/

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'adq_tope_compra', E'1000000', E'Monto maximo decomprar por adquisiciones en moneda base');

/***********************************F-DAT-RAC-ADQ-0-02/03/2015*****************************************/




/***********************************I-DAT-RAC-ADQ-0-17/04/2015*****************************************/

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'adq_tope_compra_regional', E'40000', E'define el monto maximo de compra en moneda base para las regionales');

/***********************************F-DAT-RAC-ADQ-0-17/04/2015*****************************************/




/***********************************I-DAT-RAC-ADQ-0-08/06/2015*****************************************/

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'adq_tope_compra_lista_blanca', E' ', E'lista de codigos  UOs  que pueden comprar por encima del tope');

/***********************************F-DAT-RAC-ADQ-0-08/06/2015*****************************************/



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
  
  
 
/***********************************I-DAT-RAC-ADQ-0-19/10/2017*****************************************/
  
INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'adq_estado_reversion', E'desierto', E'codigo de estado de solicitud de compra donde se revierte el presupuesto, por ejemplo desierto');
   
/***********************************F-DAT-RAC-ADQ-0-19/10/2017*****************************************/
  
  
  
  
/***********************************I-DAT-RAC-ADQ-0-09/01/2018*****************************************/
 
 INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'adq_estado_comprometido_sol', E'borrador', E'estao en el que se va compromter el presupuesto de la solicitud de compra');
  

/***********************************F-DAT-RAC-ADQ-0-09/01/2018*****************************************/
   
   
/***********************************I-DAT-CAP-ADQ-0-13/08/2018*****************************************/
INSERT INTO pxp.variable_global ( "variable", "valor", "descripcion")
VALUES ( E'adq_adjudicar_con_presupuesto', E'si', E'no: para que NO verifique si existe monto disponible a momento de adjudicar un proveedor. si:valor por defecto para que SI verifique monto disponible a momento de adjudicar un proveedor');
/***********************************F-DAT-CAP-ADQ-0-13/08/2018*****************************************/


   
/***********************************I-DAT-CAP-ADQ-0-03/12/2018*****************************************/



select pxp.f_insert_tgui ('<i class="fa fa-cart-arrow-down fa-2x"></i> ADQUISICIONES', '', 'ADQ', 'si', 1, '', 1, '', '', 'ADQ');
select pxp.f_insert_tgui ('Configuración', 'Configuración varios', 'ADQ.1', 'si', 1, '', 2, '', '', 'ADQ');
select pxp.f_insert_tgui ('Categorías de Compra', 'Categorías de Compra', 'ADQ.1.1', 'si', 1, 'sis_adquisiciones/vista/categoria_compra/CategoriaCompra.php', 3, '', 'CategoriaCompra', 'ADQ');
select pxp.f_insert_tgui ('Documento de Solicitud', 'Documento de Solicitud', 'ADQ.2', 'no', 20, 'sis_adquisiciones/vista/documento_sol/DocumentoSol.php', 2, '', 'DocumentoSol', 'ADQ');
select pxp.f_insert_tgui ('Solicitud de Compra', 'Solicitud de Compra', 'ADQ.3', 'si', 6, 'sis_adquisiciones/vista/solicitud/SolicitudReq.php', 2, '', 'SolicitudReq', 'ADQ');
select pxp.f_insert_tgui ('Visto Bueno Solicitud', 'Solicitud de Compra', 'VBSOL', 'si', 7, 'sis_adquisiciones/vista/solicitud/SolicitudVb.php', 2, '', 'SolicitudVb', 'ADQ');
select pxp.f_insert_tgui ('Proveedores', 'Proveedores de compra', 'ADQ.4', 'si', 2, 'sis_parametros/vista/proveedor/Proveedor.php', 2, '', 'proveedor', 'ADQ');
select pxp.f_insert_tgui ('Proceso Compra', 'Proceso de Compra', 'PROC', 'si', 9, 'sis_adquisiciones/vista/proceso_compra/ProcesoCompra.php', 2, '', 'ProcesoCompra', 'ADQ');
select pxp.f_insert_tgui ('TipoDocumento', 'TipoDocumento', 'ADQ.1.1.1', 'no', 0, 'sis_adquisiciones/vista/documento_sol/TipoDocumento.php', 4, '', '40%', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'ADQ.3.1', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/SolicitudReqDet.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'VBSOL.1', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/SolicitudVbDet.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Cotizacion de solicitud de compra', 'Cotizacion de solicitud de compra', 'PROC.1', 'no', 0, 'sis_adquisiciones/vista/cotizacion/Cotizacion.php', 3, '', 'Cotizacion', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'PROC.2', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/SolicitudVbDet.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Detalles Cotizacion', 'Detalles Cotizacion', 'PROC.1.1', 'no', 0, 'sis_adquisiciones/vista/cotizacion_det/CotizacionDet.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Visto Bueno Cotizacion', 'Visto Bueno Cotizacion', 'VBCOT', 'si', 10, 'sis_adquisiciones/vista/cotizacion/CotizacionVbDin.php', 2, '', 'CotizacionVbDin', 'ADQ');
select pxp.f_insert_tgui ('Grupos de Presolicitudes', 'Configurar de grupos para presolicitudes', 'GRUP', 'si', 2, 'sis_adquisiciones/vista/grupo/Grupo.php', 3, '', 'Grupo', 'ADQ');
select pxp.f_insert_tgui ('Presolicitud de Compra', 'Presolicitud de Compra', 'PRECOM', 'si', 3, 'sis_adquisiciones/vista/presolicitud/PresolicitudReq.php', 2, '', 'PresolicitudReq', 'ADQ');
select pxp.f_insert_tgui ('Visto Bueno Presolicitud', 'Visto bueno de presolicitudes', 'VBPRE', 'si', 4, 'sis_adquisiciones/vista/presolicitud/PresolicitudVb.php', 2, '', 'PresolicitudVb', 'ADQ');
select pxp.f_insert_tgui ('Consolidad Presolicitudes', 'Consolidar presolicitudes', 'COPRE', 'si', 5, 'sis_adquisiciones/vista/solicitud/SolicitudReqCon.php', 2, '', 'SolicitudReqCon', 'ADQ');
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
select pxp.f_insert_tgui ('Solicitudes Pendientes', 'Solicitudes de compra aprobadas, pendientes de iniciio de proceso', 'SOLPEN', 'si', 8, 'sis_adquisiciones/vista/solicitud/SolicitudApro.php', 2, '', 'SolicitudApro', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'SOLPEN.1', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/SolicitudVbDet.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'SOLPEN.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', 'DocumentoWf', 'ADQ');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'SOLPEN.3', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 3, '', 'proveedor', 'ADQ');
select pxp.f_insert_tgui ('Subir Archivo', 'Subir Archivo', 'SOLPEN.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 4, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Items/Servicios ofertados', 'Items/Servicios ofertados', 'SOLPEN.3.1', 'no', 0, 'sis_parametros/vista/proveedor_item_servicio/ProveedorItemServicio.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLPEN.3.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'SOLPEN.3.3', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 4, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'SOLPEN.3.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 5, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLPEN.3.3.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Obligaciones de Pago', 'Obligaciones de Pago', 'OBPAGOA', 'si', 11, 'sis_tesoreria/vista/obligacion_pago/ObligacionPagoAdq.php', 2, '', 'ObligacionPagoAdq', 'ADQ');
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
select pxp.f_insert_tgui ('Prorrateo ...', 'Prorrateo ...', 'OBPAGOA.1.1', 'no', 0, 'sis_tesoreria/vista/tipo_prorrateo/WizardProrrateo.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Visto Bueno Solicitud (Presupuestos)', 'Visto Bueno Solicitud (Presupuestos)', 'VBSOLP', 'si', 7, 'sis_adquisiciones/vista/solicitud/SolicitudVb.php', 2, '', 'SolicitudVb', 'ADQ');
select pxp.f_insert_tgui ('Reportes', 'Reportes', 'REPADQ', 'si', 45, '', 2, '', '', 'ADQ');
select pxp.f_insert_tgui ('Ejecución presupuestaria', 'Ejecución presupuestaria', 'ADQELEPRE', 'si', 1, 'sis_adquisiciones/vista/solicitud/SolReporteEje.php', 3, '', 'SolReporteEje', 'ADQ');
select pxp.f_insert_tgui ('Cotizaciones/Ordenes', 'Cotizaciones y Ordenes de Compra', 'COTOC', 'si', 10, 'sis_adquisiciones/vista/cotizacion/CotizacionOC.php', 2, '', 'CotizacionOC', 'ADQ');
select pxp.f_insert_tgui ('VoBo Solicitud (Poa)', 'VoBo Solicitud (Poa)', 'VBPOA', 'si', 7, 'sis_adquisiciones/vista/solicitud/SolicitudVb.php', 3, '', 'SolicitudVb', 'ADQ');
select pxp.f_insert_tgui ('Solicitud Compra Múltiples  Gestiones', 'Solicitud Compra Múltiples  Gestiones', 'SOLMG', 'si', 1, 'sis_adquisiciones/vista/solicitud/SolicitudReqMulGes.php', 2, '', 'SolicitudReqMulGes', 'ADQ');
select pxp.f_insert_tgui ('Formulario de Solicitud de Compra', 'Formulario de Solicitud de Compra', 'ADQ.3.5', 'no', 0, 'sis_adquisiciones/vista/solicitud/FormSolicitud.php', 3, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Subir Detalle Gasto', 'Subir Detalle Gasto', 'ADQ.3.6', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/FormDetalleGastoSolicitud.php', 3, '', 'FormDetalleGastoSolicitud', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'ADQ.3.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 3, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'ADQ.3.5.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'ADQ.3.5.2', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 4, '', 'proveedor', 'ADQ');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'ADQ.3.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'ADQ.3.5.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'ADQ.3.5.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 5, '', '30%', 'ADQ');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'ADQ.3.5.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', '40%', 'ADQ');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'ADQ.3.5.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 5, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('73%', '73%', 'ADQ.3.5.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 6, '', 'RepPlanPago', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'ADQ.3.5.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Cta Bancaria', 'Cta Bancaria', 'ADQ.3.5.2.1', 'no', 0, 'sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php', 5, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'ADQ.3.5.2.2', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 5, '', 'AntFormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'ADQ.3.5.2.3', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 5, '', 'FormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'ADQ.3.5.2.4', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'ADQ.3.5.2.5', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 5, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'ADQ.3.5.2.6', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'ADQ.3.5.2.7', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'ADQ.3.5.2.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'ADQ.3.5.2.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'ADQ.3.5.2.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 8, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'ADQ.3.5.2.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 8, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'ADQ.3.5.2.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 9, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'ADQ.3.5.2.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 9, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'ADQ.3.5.2.3.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'ADQ.3.5.2.5.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'ADQ');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'ADQ.3.5.2.5.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 7, '', 'FuncionarioCuentaBancaria', 'ADQ');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'ADQ.3.5.2.5.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 7, '', 'FuncionarioEspecialidad', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'ADQ.3.5.2.5.1.3', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'ADQ.3.5.2.5.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 8, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBSOL.5', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 3, '', '../../sis_adquisiciones/control/Solicitud/verficarSigEstSolWf', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBSOL.6', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 3, '', 'AntFormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'VBSOL.7', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/SolicitudReqDet.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Subir Detalle Gasto', 'Subir Detalle Gasto', 'VBSOL.8', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/FormDetalleGastoSolicitud.php', 3, '', 'FormDetalleGastoSolicitud', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBSOL.9', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 3, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBSOL.5.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'VBSOL.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'VBSOL.5.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'VBSOL.5.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 5, '', '30%', 'ADQ');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBSOL.5.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', '40%', 'ADQ');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBSOL.5.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 5, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('73%', '73%', 'VBSOL.5.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 6, '', 'RepPlanPago', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBSOL.5.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'VBSOL.9.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 4, '', 'funcionario', 'ADQ');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'VBSOL.9.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 5, '', 'FuncionarioCuentaBancaria', 'ADQ');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'VBSOL.9.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 5, '', 'FuncionarioEspecialidad', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBSOL.9.1.3', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBSOL.9.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBSOL.9.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBSOL.9.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 8, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBSOL.9.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 8, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'VBSOL.9.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 9, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'VBSOL.9.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 9, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('Cta Bancaria', 'Cta Bancaria', 'VBSOL.3.4', 'no', 0, 'sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBSOL.3.5', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBSOL.3.6', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBSOL.3.7', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBSOL.3.8', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBSOL.3.4.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'ADQ.4.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 4, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'ADQ.4.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 5, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'ADQ.4.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 5, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'PROC.3.3', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'PROC.3.4', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 4, '', '30%', 'ADQ');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'PROC.3.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('73%', '73%', 'PROC.3.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 5, '', 'RepPlanPago', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'PROC.3.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'PROC.4.5', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Correos enviados', 'Correos enviados', 'PROC.4.6', 'no', 0, 'sis_parametros/vista/alarma/CorreoWf.php', 4, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'PROC.4.4.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'PROC.4.5.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 5, '', 'funcionario', 'ADQ');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'PROC.4.5.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 6, '', 'FuncionarioCuentaBancaria', 'ADQ');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'PROC.4.5.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 6, '', 'FuncionarioEspecialidad', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'PROC.4.5.1.3', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'PROC.4.5.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 7, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'PROC.4.5.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'PROC.4.5.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'PROC.4.5.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'PROC.4.5.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'PROC.4.5.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'VBCOT.2.3', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'VBCOT.2.4', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 4, '', '30%', 'ADQ');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBCOT.2.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('73%', '73%', 'VBCOT.2.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 5, '', 'RepPlanPago', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBCOT.2.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Usuario Externo', 'Usuario Externo', 'GRUP.2.1.4', 'no', 0, 'sis_seguridad/vista/usuario_externo/UsuarioExterno.php', 6, '', 'UsuarioExterno', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'GRUP.2.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 7, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'GRUP.2.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 8, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'GRUP.2.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 8, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'GRUP.2.1.4.1', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 7, '', 'Catalogo', 'ADQ');
select pxp.f_insert_tgui ('Subir Detalle Gasto', 'Subir Detalle Gasto', 'COPRE.7', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/FormDetalleGastoSolicitud.php', 3, '', 'FormDetalleGastoSolicitud', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'COPRE.8', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 3, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'COPRE.4.3', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'COPRE.4.4', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 4, '', '30%', 'ADQ');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'COPRE.4.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('73%', '73%', 'COPRE.4.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 5, '', 'RepPlanPago', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'COPRE.4.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'COPRE.8.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 4, '', 'funcionario', 'ADQ');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'COPRE.8.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 5, '', 'FuncionarioCuentaBancaria', 'ADQ');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'COPRE.8.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 5, '', 'FuncionarioEspecialidad', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'COPRE.8.1.3', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'COPRE.8.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'COPRE.8.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'COPRE.8.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 8, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'COPRE.8.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 8, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'COPRE.8.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 9, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'COPRE.8.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 9, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('Cta Bancaria', 'Cta Bancaria', 'COPRE.5.4', 'no', 0, 'sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'COPRE.5.5', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'COPRE.5.6', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'COPRE.5.7', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'COPRE.5.8', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'COPRE.5.4.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'COPRE.5.6.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Subir Detalle Gasto', 'Subir Detalle Gasto', 'SOLPEN.5', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/FormDetalleGastoSolicitud.php', 3, '', 'FormDetalleGastoSolicitud', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'SOLPEN.6', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 3, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'SOLPEN.2.3', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'SOLPEN.2.4', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 4, '', '30%', 'ADQ');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'SOLPEN.2.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('73%', '73%', 'SOLPEN.2.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 5, '', 'RepPlanPago', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'SOLPEN.2.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'SOLPEN.6.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 4, '', 'funcionario', 'ADQ');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'SOLPEN.6.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 5, '', 'FuncionarioCuentaBancaria', 'ADQ');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'SOLPEN.6.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 5, '', 'FuncionarioEspecialidad', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLPEN.6.1.3', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'SOLPEN.6.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLPEN.6.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'SOLPEN.6.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 8, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'SOLPEN.6.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 8, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'SOLPEN.6.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 9, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'SOLPEN.6.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 9, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('Cta Bancaria', 'Cta Bancaria', 'SOLPEN.3.4', 'no', 0, 'sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'SOLPEN.3.5', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'SOLPEN.3.6', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'SOLPEN.3.7', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'SOLPEN.3.8', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'SOLPEN.3.4.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'SOLPEN.3.6.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Evolución presupuestaria (', 'Evolución presupuestaria (', 'OBPAGOA.9', 'no', 0, 'sis_tesoreria/vista/presupuesto/CheckPresupuesto.php', 3, '', ')', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OBPAGOA.10', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 3, '', 'FormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'OBPAGOA.11', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 3, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'OBPAGOA.2.6', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'OBPAGOA.2.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'OBPAGOA.2.5.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'OBPAGOA.2.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'OBPAGOA.2.5.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'OBPAGOA.2.5.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'ADQ');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'OBPAGOA.2.5.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'ADQ');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'OBPAGOA.2.5.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('73%', '73%', 'OBPAGOA.2.5.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'OBPAGOA.2.5.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'OBPAGOA.2.7.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 5, '', 'funcionario', 'ADQ');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'OBPAGOA.2.7.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 6, '', 'FuncionarioCuentaBancaria', 'ADQ');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'OBPAGOA.2.7.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 6, '', 'FuncionarioEspecialidad', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OBPAGOA.2.7.1.3', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'OBPAGOA.2.7.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 7, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OBPAGOA.2.7.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'OBPAGOA.2.7.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'OBPAGOA.2.7.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'OBPAGOA.2.7.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'OBPAGOA.2.7.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'OBPAGOA.4.6', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'OBPAGOA.4.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Cta Bancaria', 'Cta Bancaria', 'OBPAGOA.7.4', 'no', 0, 'sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OBPAGOA.7.5', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'OBPAGOA.7.6', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'OBPAGOA.7.7', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'OBPAGOA.7.8', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'OBPAGOA.7.4.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Subir Detalle Gasto', 'Subir Detalle Gasto', 'RPCI.2.4', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/FormDetalleGastoSolicitud.php', 5, '', 'FormDetalleGastoSolicitud', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'RPCI.2.5', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 5, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'RPCI.2.1.3', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'RPCI.2.1.4', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'ADQ');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'RPCI.2.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('73%', '73%', 'RPCI.2.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'RPCI.2.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'RPCI.2.5.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'ADQ');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'RPCI.2.5.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 7, '', 'FuncionarioCuentaBancaria', 'ADQ');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'RPCI.2.5.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 7, '', 'FuncionarioEspecialidad', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'RPCI.2.5.1.3', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'RPCI.2.5.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 8, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'RPCI.2.5.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'RPCI.2.5.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'RPCI.2.5.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'RPCI.2.5.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'RPCI.2.5.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('Cta Bancaria', 'Cta Bancaria', 'RPCI.2.3.4', 'no', 0, 'sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php', 6, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'RPCI.2.3.5', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 6, '', 'AntFormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'RPCI.2.3.6', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 6, '', 'FormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'RPCI.2.3.7', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'RPCI.2.3.8', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 6, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'RPCI.2.3.4.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 7, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'RPCI.2.3.6.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBSOLP.1', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 3, '', '../../sis_adquisiciones/control/Solicitud/verficarSigEstSolWf', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBSOLP.2', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 3, '', 'AntFormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'VBSOLP.3', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/SolicitudReqDet.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBSOLP.4', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Subir Detalle Gasto', 'Subir Detalle Gasto', 'VBSOLP.5', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/FormDetalleGastoSolicitud.php', 3, '', 'FormDetalleGastoSolicitud', 'ADQ');
select pxp.f_insert_tgui ('Solicitar Traspaso presupuestario', 'Solicitar Traspaso presupuestario', 'VBSOLP.6', 'no', 0, 'sis_adquisiciones/vista/solicitud/SolModPresupuesto.php', 3, '', 'SolModPresupuesto', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBSOLP.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 3, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'VBSOLP.8', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 3, '', 'proveedor', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBSOLP.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'VBSOLP.1.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'VBSOLP.1.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'VBSOLP.1.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 5, '', '30%', 'ADQ');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBSOLP.1.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', '40%', 'ADQ');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBSOLP.1.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 5, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('73%', '73%', 'VBSOLP.1.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 6, '', 'RepPlanPago', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBSOLP.1.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'VBSOLP.7.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 4, '', 'funcionario', 'ADQ');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'VBSOLP.7.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 5, '', 'FuncionarioCuentaBancaria', 'ADQ');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'VBSOLP.7.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 5, '', 'FuncionarioEspecialidad', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBSOLP.7.1.3', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBSOLP.7.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBSOLP.7.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBSOLP.7.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 8, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBSOLP.7.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 8, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'VBSOLP.7.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 9, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'VBSOLP.7.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 9, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('Cta Bancaria', 'Cta Bancaria', 'VBSOLP.8.1', 'no', 0, 'sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBSOLP.8.2', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBSOLP.8.3', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBSOLP.8.4', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBSOLP.8.5', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBSOLP.8.6', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBSOLP.8.7', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 4, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBSOLP.8.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'COTOC.1', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 3, '', 'si', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'COTOC.2', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 3, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'COTOC.3', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Detalles Cotizacion', 'Detalles Cotizacion', 'COTOC.4', 'no', 0, 'sis_adquisiciones/vista/cotizacion_det/CotizacionDet.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'COTOC.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'COTOC.1.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'COTOC.1.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'COTOC.1.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 5, '', '30%', 'ADQ');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'COTOC.1.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', '40%', 'ADQ');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'COTOC.1.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 5, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('73%', '73%', 'COTOC.1.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 6, '', 'RepPlanPago', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'COTOC.1.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'COTOC.2.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 4, '', 'funcionario', 'ADQ');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'COTOC.2.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 5, '', 'FuncionarioCuentaBancaria', 'ADQ');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'COTOC.2.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 5, '', 'FuncionarioEspecialidad', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'COTOC.2.1.3', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'COTOC.2.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'COTOC.2.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'COTOC.2.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 8, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'COTOC.2.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 8, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'COTOC.2.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 9, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'COTOC.2.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 9, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBPOA.1', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', '../../sis_adquisiciones/control/Solicitud/verficarSigEstSolWf', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBPOA.2', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'VBPOA.3', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/SolicitudReqDet.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBPOA.4', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Subir Detalle Gasto', 'Subir Detalle Gasto', 'VBPOA.5', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/FormDetalleGastoSolicitud.php', 4, '', 'FormDetalleGastoSolicitud', 'ADQ');
select pxp.f_insert_tgui ('Solicitar Traspaso presupuestario', 'Solicitar Traspaso presupuestario', 'VBPOA.6', 'no', 0, 'sis_adquisiciones/vista/solicitud/SolModPresupuesto.php', 4, '', 'SolModPresupuesto', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBPOA.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'VBPOA.8', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 4, '', 'proveedor', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBPOA.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'VBPOA.1.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'VBPOA.1.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'VBPOA.1.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'ADQ');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBPOA.1.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'ADQ');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBPOA.1.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('73%', '73%', 'VBPOA.1.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBPOA.1.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'VBPOA.7.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 5, '', 'funcionario', 'ADQ');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'VBPOA.7.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 6, '', 'FuncionarioCuentaBancaria', 'ADQ');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'VBPOA.7.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 6, '', 'FuncionarioEspecialidad', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBPOA.7.1.3', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBPOA.7.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 7, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBPOA.7.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBPOA.7.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBPOA.7.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'VBPOA.7.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'VBPOA.7.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('Cta Bancaria', 'Cta Bancaria', 'VBPOA.8.1', 'no', 0, 'sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php', 5, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBPOA.8.2', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 5, '', 'AntFormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBPOA.8.3', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 5, '', 'FormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBPOA.8.4', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBPOA.8.5', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 5, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBPOA.8.6', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBPOA.8.7', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBPOA.8.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Formulario de Solicitud de Compra', 'Formulario de Solicitud de Compra', 'SOLMG.1', 'no', 0, 'sis_adquisiciones/vista/solicitud/FormSolicitud.php', 3, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'SOLMG.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'SOLMG.3', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/SolicitudReqDetMulGes.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Subir Detalle Gasto', 'Subir Detalle Gasto', 'SOLMG.4', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/FormDetalleGastoSolicitud.php', 3, '', 'FormDetalleGastoSolicitud', 'ADQ');
select pxp.f_insert_tgui ('Solicitar Traspaso presupuestario', 'Solicitar Traspaso presupuestario', 'SOLMG.5', 'no', 0, 'sis_adquisiciones/vista/solicitud/SolModPresupuesto.php', 3, '', 'SolModPresupuesto', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'SOLMG.6', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 3, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'SOLMG.7', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 3, '', 'proveedor', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'SOLMG.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'SOLMG.1.2', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 4, '', 'proveedor', 'ADQ');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'SOLMG.1.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'SOLMG.1.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'SOLMG.1.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 5, '', '30%', 'ADQ');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'SOLMG.1.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', '40%', 'ADQ');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'SOLMG.1.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 5, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('73%', '73%', 'SOLMG.1.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 6, '', 'RepPlanPago', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'SOLMG.1.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Cta Bancaria', 'Cta Bancaria', 'SOLMG.1.2.1', 'no', 0, 'sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php', 5, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'SOLMG.1.2.2', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 5, '', 'AntFormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'SOLMG.1.2.3', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 5, '', 'FormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'SOLMG.1.2.4', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'SOLMG.1.2.5', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 5, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLMG.1.2.6', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'SOLMG.1.2.7', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'SOLMG.1.2.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLMG.1.2.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'SOLMG.1.2.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 8, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'SOLMG.1.2.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 8, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'SOLMG.1.2.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 9, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'SOLMG.1.2.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 9, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'SOLMG.1.2.3.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'SOLMG.1.2.5.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'ADQ');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'SOLMG.1.2.5.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 7, '', 'FuncionarioCuentaBancaria', 'ADQ');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'SOLMG.1.2.5.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 7, '', 'FuncionarioEspecialidad', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLMG.1.2.5.1.3', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'SOLMG.1.2.5.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 8, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'ADQ.3.5.2.5.1.4', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 7, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBSOL.9.1.4', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 5, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'PROC.4.5.1.4', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 6, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'COPRE.8.1.4', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 5, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'SOLPEN.6.1.4', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 5, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'OBPAGOA.2.7.1.4', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 6, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'RPCI.2.5.1.4', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 7, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBSOLP.7.1.4', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 5, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'COTOC.2.1.4', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 5, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBPOA.7.1.4', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 6, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'SOLMG.1.2.5.1.4', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 7, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'ADQ.3.8', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 3, '', 'ChkPresupuesto', 'ADQ');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'VBSOL.10', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 3, '', 'ChkPresupuesto', 'ADQ');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'PROC.5', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 3, '', 'ChkPresupuesto', 'ADQ');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'COPRE.9', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 3, '', 'ChkPresupuesto', 'ADQ');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'SOLPEN.7', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 3, '', 'ChkPresupuesto', 'ADQ');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'OBPAGOA.12', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 3, '', 'ChkPresupuesto', 'ADQ');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'RPCI.2.6', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 5, '', 'ChkPresupuesto', 'ADQ');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'VBSOLP.9', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 3, '', 'ChkPresupuesto', 'ADQ');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'VBPOA.9', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 4, '', 'ChkPresupuesto', 'ADQ');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'SOLMG.8', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 3, '', 'ChkPresupuesto', 'ADQ');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'ADQ.3.5.2.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 7, '', 'Persona Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'ADQ.3.5.2.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'ADQ.3.5.2.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'ADQ.3.5.2.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'ADQ.3.5.2.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'ADQ.3.5.2.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'VBSOL.9.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 7, '', 'Persona Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBSOL.9.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBSOL.9.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBSOL.9.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'VBSOL.9.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'VBSOL.9.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('Cta Bancaria', 'Cta Bancaria', 'ADQ.4.3', 'no', 0, 'sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'ADQ.4.4', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 3, '', 'AntFormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'ADQ.4.5', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 3, '', 'FormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'ADQ.4.6', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'ADQ.4.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 3, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'ADQ.4.3.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 4, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'ADQ.4.3.1.1', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 5, '', 'Persona Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'ADQ.4.3.1.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'ADQ.4.3.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'ADQ.4.3.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 7, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'ADQ.4.3.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 7, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'ADQ.4.3.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 8, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'ADQ.4.3.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 8, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'ADQ.4.5.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'ADQ.4.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'ADQ.4.5.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'ADQ.4.5.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 5, '', '30%', 'ADQ');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'ADQ.4.5.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', '40%', 'ADQ');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'ADQ.4.5.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 5, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('73%', '73%', 'ADQ.4.5.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 6, '', 'RepPlanPago', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'ADQ.4.5.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'ADQ.4.7.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 4, '', 'funcionario', 'ADQ');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'ADQ.4.7.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 5, '', 'FuncionarioCuentaBancaria', 'ADQ');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'ADQ.4.7.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 5, '', 'FuncionarioEspecialidad', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'ADQ.4.7.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 5, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'ADQ.4.7.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'ADQ.4.7.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'PROC.4.5.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 8, '', 'Persona Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'PROC.4.5.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'PROC.4.5.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'PROC.4.5.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'PROC.4.5.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'PROC.4.5.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'COPRE.8.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 7, '', 'Persona Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'COPRE.8.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'COPRE.8.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'COPRE.8.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'COPRE.8.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'COPRE.8.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'SOLPEN.6.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 7, '', 'Persona Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLPEN.6.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'SOLPEN.6.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'SOLPEN.6.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'SOLPEN.6.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'SOLPEN.6.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'OBPAGOA.2.7.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 8, '', 'Persona Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OBPAGOA.2.7.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'OBPAGOA.2.7.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'OBPAGOA.2.7.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'OBPAGOA.2.7.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'OBPAGOA.2.7.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'RPCI.2.5.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 9, '', 'Persona Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'RPCI.2.5.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 10, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'RPCI.2.5.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 11, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'RPCI.2.5.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 11, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'RPCI.2.5.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 12, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'RPCI.2.5.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 12, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'VBSOLP.7.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 7, '', 'Persona Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBSOLP.7.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBSOLP.7.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBSOLP.7.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'VBSOLP.7.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'VBSOLP.7.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'COTOC.2.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 7, '', 'Persona Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'COTOC.2.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'COTOC.2.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'COTOC.2.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'COTOC.2.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'COTOC.2.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'VBPOA.7.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 8, '', 'Persona Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBPOA.7.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBPOA.7.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBPOA.7.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'VBPOA.7.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'VBPOA.7.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'SOLMG.1.2.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 7, '', 'Persona Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLMG.1.2.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'SOLMG.1.2.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'SOLMG.1.2.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'SOLMG.1.2.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'SOLMG.1.2.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('Facturas/Recibos', 'Facturas/Recibos', 'OBPAGOA.2.8', 'no', 0, 'sis_tesoreria/vista/plan_pago_doc_compra/PlanPagoDocCompra.php', 4, '', 'PlanPagoDocCompra', 'ADQ');
select pxp.f_insert_tgui ('90%', '90%', 'OBPAGOA.2.8.1', 'no', 0, 'sis_contabilidad/vista/doc_compra_venta/FormCompraVentaCustom.php', 5, '', 'si', 'ADQ');
select pxp.f_insert_tgui ('90%', '90%', 'OBPAGOA.2.8.2', 'no', 0, 'sis_contabilidad/vista/doc_compra_venta/FormCompraVenta.php', 5, '', 'si', 'ADQ');
select pxp.f_insert_tgui ('Generar comprobante', 'Generar comprobante', 'OBPAGOA.2.8.3', 'no', 0, 'sis_contabilidad/vista/agrupador/WizardAgrupador.php', 5, '', '40%', 'ADQ');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'OBPAGOA.2.8.1.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'ADQ');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'OBPAGOA.2.8.1.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 7, '', 'FuncionarioCuentaBancaria', 'ADQ');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'OBPAGOA.2.8.1.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 7, '', 'FuncionarioEspecialidad', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'OBPAGOA.2.8.1.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 7, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OBPAGOA.2.8.1.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'OBPAGOA.2.8.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 8, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'OBPAGOA.2.8.1.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 9, '', 'Persona Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OBPAGOA.2.8.1.1.1.1.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'OBPAGOA.2.8.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 10, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'OBPAGOA.2.8.1.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 11, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'OBPAGOA.2.8.1.1.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 11, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'OBPAGOA.2.8.1.1.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 12, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'OBPAGOA.2.8.1.1.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 12, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'OBPAGOA.2.8.2.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'ADQ');
select pxp.f_insert_tgui ('Generar comprobante', 'Generar comprobante', 'OBPAGOA.2.8.3.1', 'no', 0, 'sis_contabilidad/vista/agrupador_doc/AgrupadorDoc.php', 6, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Consulta de Solicitudes', 'Consulta de Solicitudes', 'SOLHIS', 'si', 15, 'sis_adquisiciones/vista/solicitud/SolicitudHistorico.php', 2, '', 'SolicitudHistorico', 'ADQ');
select pxp.f_insert_tgui ('Detalle', 'Detalle', 'SOLHIS.1', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/SolicitudVbDet.php', 3, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'SOLHIS.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Subir Detalle Gasto', 'Subir Detalle Gasto', 'SOLHIS.3', 'no', 0, 'sis_adquisiciones/vista/solicitud_det/FormDetalleGastoSolicitud.php', 3, '', 'FormDetalleGastoSolicitud', 'ADQ');
select pxp.f_insert_tgui ('Solicitar Traspaso presupuestario', 'Solicitar Traspaso presupuestario', 'SOLHIS.4', 'no', 0, 'sis_adquisiciones/vista/solicitud/SolModPresupuesto.php', 3, '', 'SolModPresupuesto', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'SOLHIS.5', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 3, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'SOLHIS.6', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 3, '', 'ChkPresupuesto', 'ADQ');
select pxp.f_insert_tgui ('Proveedor', 'Proveedor', 'SOLHIS.7', 'no', 0, 'sis_parametros/vista/proveedor/Proveedor.php', 3, '', 'proveedor', 'ADQ');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'SOLHIS.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 4, '', 'SubirArchivoWf', 'ADQ');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'SOLHIS.2.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'SOLHIS.2.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 4, '', '30%', 'ADQ');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'SOLHIS.2.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 4, '', '40%', 'ADQ');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'SOLHIS.2.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('73%', '73%', 'SOLHIS.2.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 5, '', 'RepPlanPago', 'ADQ');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'SOLHIS.2.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'SOLHIS.5.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 4, '', 'funcionario', 'ADQ');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'SOLHIS.5.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 5, '', 'FuncionarioCuentaBancaria', 'ADQ');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'SOLHIS.5.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 5, '', 'FuncionarioEspecialidad', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'SOLHIS.5.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 5, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLHIS.5.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'SOLHIS.5.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'SOLHIS.5.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 7, '', 'Persona Institucion', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLHIS.5.1.1.1.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLHIS.5.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'SOLHIS.5.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'ADQ');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'SOLHIS.5.1.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'ADQ');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'SOLHIS.5.1.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'ADQ');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'SOLHIS.5.1.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'ADQ');
select pxp.f_insert_tgui ('Cta Bancaria', 'Cta Bancaria', 'SOLHIS.7.1', 'no', 0, 'sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php', 4, '', '50%', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'SOLHIS.7.2', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'SOLHIS.7.3', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'SOLHIS.7.4', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'ADQ');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'SOLHIS.7.5', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'ADQ');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLHIS.7.6', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'SOLHIS.7.7', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 4, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'SOLHIS.7.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 5, '', 'Institucion', 'ADQ');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'SOLHIS.7.3.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'ADQ');


/***********************************F-DAT-CAP-ADQ-0-03/12/2018*****************************************/


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
  
  
 
/***********************************I-DAT-RAC-ADQ-0-19/10/2017*****************************************/
  
INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'adq_estado_reversion', E'desierto', E'codigo de estado de solicitud de compra donde se revierte el presupuesto, por ejemplo desierto');
   
/***********************************F-DAT-RAC-ADQ-0-19/10/2017*****************************************/
  
  
  
  
/***********************************I-DAT-RAC-ADQ-0-09/01/2018*****************************************/
 
 INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'adq_estado_comprometido_sol', E'borrador', E'estao en el que se va compromter el presupuesto de la solicitud de compra');
  

/***********************************F-DAT-RAC-ADQ-0-09/01/2018*****************************************/
   
   
/***********************************I-DAT-CAP-ADQ-0-13/08/2018*****************************************/
INSERT INTO pxp.variable_global ( "variable", "valor", "descripcion")
VALUES ( E'adq_adjudicar_con_presupuesto', E'si', E'no: para que NO verifique si existe monto disponible a momento de adjudicar un proveedor. si:valor por defecto para que SI verifique monto disponible a momento de adjudicar un proveedor');
/***********************************F-DAT-CAP-ADQ-0-13/08/2018*****************************************/



/***********************************I-DAT-EGS-ADQ-0-30/11/2018*****************************************/

select param.f_import_tcatalogo_tipo ('insert','ttipo_entrega','ADQ','tproceso_compra');
select param.f_import_tcatalogo ('insert','ADQ','CIP','CIP','ttipo_entrega');
select param.f_import_tcatalogo ('insert','ADQ','CIF','CIF','ttipo_entrega');
select param.f_import_tcatalogo ('insert','ADQ','DAP','DAP','ttipo_entrega');
select param.f_import_tcatalogo ('insert','ADQ','DDP','DDP','ttipo_entrega');
select param.f_import_tcatalogo ('insert','ADQ','DDU','DDU','ttipo_entrega');
select param.f_import_tcatalogo ('insert','ADQ','EXW','EXW','ttipo_entrega');
select param.f_import_tcatalogo ('insert','ADQ','FACTURADO','FACTURADO','ttipo_entrega');
select param.f_import_tcatalogo ('insert','ADQ','RETENCION IMPOSITIVA','RETENCION IMPOSITIVA','ttipo_entrega');
/***********************************F-DAT-EGS-ADQ-0-30/11/2018*****************************************/

/***********************************I-DAT-EGS-ADQ-1-19/02/2019*****************************************/
---Flujo Wf para presolicitudes de compra
select wf.f_import_tproceso_macro ('insert','PRESOL', 'ADQ', 'Presolicitud de Compra','si');
select wf.f_import_tcategoria_documento ('insert','legales', 'Legales');
select wf.f_import_tcategoria_documento ('insert','proceso', 'Proceso');
select wf.f_import_ttipo_proceso ('insert','PRESOL',NULL,NULL,'PRESOL','Presolicitud de Compra','','','si','','','','PRESOL',NULL);
select wf.f_import_ttipo_estado ('insert','borrador','PRESOL','borrador','si','no','no','todos','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','pendiente','PRESOL','pendiente','no','no','no','todos','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','aprobado','PRESOL','aprobado','no','no','no','todos','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','asignado','PRESOL','asignado','no','no','no','todos','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','finalizado','PRESOL','finalizado','no','no','si','todos','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_testructura_estado ('insert','borrador','pendiente','PRESOL',1,'');
select wf.f_import_testructura_estado ('insert','pendiente','aprobado','PRESOL',1,'');
select wf.f_import_testructura_estado ('insert','aprobado','asignado','PRESOL',1,'');
select wf.f_import_testructura_estado ('insert','asignado','finalizado','PRESOL',1,'');
/***********************************F-DAT-EGS-ADQ-1-19/02/2019*****************************************/
/***********************************I-DAT-EGS-ADQ-2-13/09/2019*****************************************/
select pxp.f_insert_tgui ('Proveedores', 'Proveedores de compra', 'ADQ.4', 'si', 2, 'sis_adquisiciones/vista/proveedor/ProveedorAdq.php', 2, '', 'ProveedorAdq', 'ADQ');
/***********************************F-DAT-EGS-ADQ-2-13/09/2019*****************************************/
/***********************************I-DAT-EGS-ADQ-3-11/03/2020*****************************************/
select pxp.f_insert_tgui ('Reporte Pagos', 'Reporte Pagos', 'REPPAG', 'si', 2, 'sis_adquisiciones/vista/reporte_pago/FormFiltro.php', 3, '', 'FormFiltro', 'ADQ');
select pxp.f_insert_tgui ('Cotizaciones/Ordenes', 'Cotizaciones y Ordenes de Compra', 'COTOC', 'si', 10, 'sis_adquisiciones/vista/reporte_cotizacion/FormFiltro.php', 2, '', 'FormFiltro', 'ADQ');
/***********************************F-DAT-EGS-ADQ-3-11/03/2020*****************************************/
/***********************************I-DAT-MGM-ADQ-1-21/12/2020*****************************************/
select pxp.f_insert_tgui ('Reporte Estado', 'Reporte Estado', 'REPEST', 'si', 5, 'sis_adquisiciones/vista/reporte_consulta/FormFiltro.php', 3, '', 'FormFiltro', 'ADQ');
/***********************************F-DAT-MGM-ADQ-1-21/12/2020*****************************************/
/***********************************I-DAT-EGS-ADQ-ETR-2176-22/12/2020*****************************************/
INSERT INTO param.ttipo_envio_correo ("id_usuario_reg", "estado_reg", "codigo", "descripcion", "dias_envio", "habilitado", "dias_vencimiento", "script", "plantilla_mensaje", "plantilla_mensaje_asunto", "script_habilitado", "columna_llave", "tabla", "dias_consecutivo")
VALUES
  (1, E'activo', E'BCSA', E'Recordatorio CSA boleta de garantias', E'5', E'no', NULL, E'adq.f_alerta_boleta_csa_ime', E'<font color=\"99CC00\" size=\"5\"><font size=\"4\">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>', E'Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})', E'si', E'', E'', NULL);
/***********************************F-DAT-EGS-ADQ-ETR-2176-22/12/2020*****************************************/
