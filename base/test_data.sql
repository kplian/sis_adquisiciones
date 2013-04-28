------------------------------
--               APROBADORES (EN PARAMETROS)
--------------------------



/* Data for the 'param.taprobador' table  (Records 1 - 3) */
/*
INSERT INTO param.taprobador ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_funcionario", "id_subsistema", "id_centro_costo", "monto_min", "monto_max", "fecha_ini", "fecha_fin", "id_uo", "obs", "id_ep")
VALUES (1, NULL, E'2013-03-20 13:40:10.761', NULL, E'activo', 2, 6, NULL, '0', NULL, E'2013-01-01', NULL, 2, E'', NULL);

INSERT INTO param.taprobador ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_funcionario", "id_subsistema", "id_centro_costo", "monto_min", "monto_max", "fecha_ini", "fecha_fin", "id_uo", "obs", "id_ep")
VALUES (1, NULL, E'2013-03-20 13:41:13.113', NULL, E'activo', 3, 6, NULL, '0', NULL, E'2012-11-01', NULL, 7, E'', NULL);

INSERT INTO param.taprobador ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_funcionario", "id_subsistema", "id_centro_costo", "monto_min", "monto_max", "fecha_ini", "fecha_fin", "id_uo", "obs", "id_ep")
VALUES (1, NULL, E'2013-03-20 13:41:21.555', NULL, E'activo', 3, 6, NULL, '0', NULL, E'2012-11-01', NULL, 9, E'', NULL);
*/

---------------------------------------------------
-- DEPTOS (EN PARAMETROS)
------------------------------------------------

/* Data for the 'param.tdepto' table  (Records 1 - 2) */
/*
INSERT INTO param.tdepto ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_subsistema", "codigo", "nombre", "nombre_corto")
VALUES (1, NULL, E'2013-03-20 00:00:00', E'2013-03-20 14:17:22.287', E'activo', 6, E'ADQ', E'Adquisiciones  Central', E'');

INSERT INTO param.tdepto ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_subsistema", "codigo", "nombre", "nombre_corto")
VALUES (1, NULL, E'2013-03-20 00:00:00', E'2013-03-20 14:17:45.392', E'activo', 6, E'ADQLP', E'Departamento de Adquisiciones La Paz', E'ADQLP');
*/
/* Data for the 'param.tdepto_usuario' table  (Records 1 - 2) */
/*
INSERT INTO param.tdepto_usuario ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_depto", "id_usuario", "funcion", "cargo")
VALUES (1, NULL, E'2013-03-20 14:17:55.046', NULL, E'activo', 2, 1, NULL, E'');

INSERT INTO param.tdepto_usuario ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_depto", "id_usuario", "funcion", "cargo")
VALUES (1, NULL, E'2013-03-20 14:18:01.481', NULL, E'activo', 1, 1, NULL, E'');
*/

-------------------------------------------
-- INICIO ROLES 
-- Autor Gonzalo Sarmiento Sejas
------------------------------------------

--roles--

select pxp.f_insert_trol ('solicitante de compra', 'Solicitante de Compra', 'ADQ');
select pxp.f_insert_trol ('visto bueno de solicitud de compra', 'Visto Bueno Solicitud', 'ADQ');
select pxp.f_insert_trol ('proceso de compra', 'Proceso de compra encargado', 'ADQ');

--roles_gui

select pxp.f_insert_tgui_rol ('ADQ.3', 'Solicitante de Compra');
select pxp.f_insert_tgui_rol ('ADQ', 'Solicitante de Compra');
select pxp.f_insert_tgui_rol ('ADQ.3.1', 'Solicitante de Compra');
select pxp.f_insert_tgui_rol ('VBSOL', 'Visto Bueno Solicitud');
select pxp.f_insert_tgui_rol ('ADQ', 'Visto Bueno Solicitud');
select pxp.f_insert_tgui_rol ('VBSOL.1', 'Visto Bueno Solicitud');
select pxp.f_insert_tgui_rol ('PROC', 'Proceso de compra encargado');
select pxp.f_insert_tgui_rol ('ADQ', 'Proceso de compra encargado');
select pxp.f_insert_tgui_rol ('PROC.1', 'Proceso de compra encargado');
select pxp.f_insert_tgui_rol ('PROC.1.1', 'Proceso de compra encargado');
select pxp.f_insert_tgui_rol ('PROC.2', 'Proceso de compra encargado');

--procedimientos_gui

select pxp.f_insert_tprocedimiento_gui ('ADQ_CATCOMP_INS', 'ADQ.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CATCOMP_MOD', 'ADQ.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CATCOMP_ELI', 'ADQ.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CATCOMP_SEL', 'ADQ.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_INS', 'ADQ.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_MOD', 'ADQ.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_ELI', 'ADQ.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_SEL', 'ADQ.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOLAR_SEL', 'ADQ.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_FINSOL_IME', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SIGESOL_IME', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_ANTESOL_IME', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'ADQ.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'ADQ.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROVEE_INS', 'ADQ.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROVEE_MOD', 'ADQ.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROVEE_ELI', 'ADQ.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROVEE_SEL', 'ADQ.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROC_INS', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROC_MOD', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROC_ELI', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROC_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'PROC.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'PROC.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_INS', 'PROC.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_MOD', 'PROC.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_ELI', 'PROC.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_SEL', 'PROC.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTREP_SEL', 'PROC.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'PROC.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_INS', 'PROC.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_MOD', 'PROC.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_ELI', 'PROC.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'PROC.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'PROC.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_PROMAC_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GETGES_ELI', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPPTO_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_UO_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CATCOMP_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOLAR_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_INS', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_INS', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_MOD', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_ELI', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_MOD', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_ELI', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_OBTARPOBA_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_ODT_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_INS', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_MOD', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_ELI', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOLAR_MOD', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOLAR_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPPTO_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_FINREGC_IME', 'PROC', 'no');

select pxp.f_insert_tprocedimiento_gui ('ADQ_PROCPED_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_ADJTODO_IME', 'PROC.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTOC_REP', 'PROC.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GENOC_IME', 'PROC.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_ANTEST_IME', 'PROC.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_TOTALADJ_IME', 'PROC.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_ADJDET_IME', 'PROC.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_HABPAG_IME', 'PROC.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_CONT', 'ADQ.3', 'no');

--rol_procedimiento_gui

select pxp.f_insert_trol_procedimiento_gui ('Responsable Visto Bueno', 'ADQ_SIGESOL_IME', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('Responsable Visto Bueno', 'ADQ_ANTESOL_IME', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('Responsable Visto Bueno', 'ADQ_SOL_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'ADQ_FINSOL_IME', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'ADQ_SOL_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'ADQ_SOLD_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'PM_MONEDA_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'WF_PROMAC_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'PM_GETGES_ELI', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'PM_DEPPTO_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'RH_FUNCIO_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'RH_UO_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'RH_FUNCIOCAR_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'ADQ_CATCOMP_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'ADQ_DOCSOLAR_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'ADQ_DOCSOL_INS', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'ADQ_SOL_INS', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'ADQ_SOL_MOD', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'ADQ_SOL_ELI', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'ADQ_SOLREP_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'ADQ_DOCSOL_MOD', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'ADQ_DOCSOL_ELI', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'PM_OBTARPOBA_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'PM_CEC_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'PM_CONIG_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'CONTA_ODT_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'ADQ_SOLD_INS', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'ADQ_SOLD_MOD', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'ADQ_SOLD_ELI', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'ADQ_SOL_CONT', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'ADQ_DOCSOLAR_MOD', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Visto Bueno Solicitud', 'ADQ_SIGESOL_IME', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('Visto Bueno Solicitud', 'ADQ_ANTESOL_IME', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('Visto Bueno Solicitud', 'ADQ_SOL_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('Visto Bueno Solicitud', 'WF_TIPES_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('Visto Bueno Solicitud', 'WF_FUNTIPES_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('Visto Bueno Solicitud', 'ADQ_SOLD_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('Visto Bueno Solicitud', 'ADQ_SOLREP_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('Visto Bueno Solicitud', 'ADQ_DOCSOLAR_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_SOL_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_PROC_INS', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_PROC_MOD', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_PROC_ELI', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_PROC_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'PM_PROVEEV_SEL', 'PROC.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'PM_MONEDA_SEL', 'PROC.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_COT_INS', 'PROC.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_COT_MOD', 'PROC.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_COT_ELI', 'PROC.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_COT_SEL', 'PROC.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_COTREP_SEL', 'PROC.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_CTD_SEL', 'PROC.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_SOLDETCOT_SEL', 'PROC.1.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_CTD_INS', 'PROC.1.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_CTD_MOD', 'PROC.1.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_CTD_ELI', 'PROC.1.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_CTD_SEL', 'PROC.1.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'PM_DEPPTO_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_SOLD_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_FINREGC_IME', 'PROC');
--select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_ANTEST_IME', 'PROC');
--select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_GENOC_IME', 'PROC');
--select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_TOTALADJ_IME', 'PROC');
--select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_ADJDET_IME', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_COTOC_REP', 'PROC.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_HABPAG_IME', 'PROC.1');
-------------------------------------------
-- FIN ROLES 
-- Autor Gonzalo Sarmiento Sejas
------------------------------------------


-------------------------------------------
-- INICIO USUARIOS DE PRUEBA 
-- Autor Gonzalo Sarmiento Sejas
------------------------------------------
/*
INSERT INTO segu.tusuario ("id_usuario", "id_clasificador", "cuenta", "contrasena", "fecha_caducidad", "fecha_reg", "estilo", "contrasena_anterior", "id_persona", "estado_reg", "autentificacion")
VALUES (2, 1, E'juan', E'a94652aa97c7211ba8954dd15a3cf838', E'2014-04-29', E'2013-03-28', E'xtheme-blue.css', NULL, 2, E'activo', E'local');

INSERT INTO segu.tusuario ("id_usuario", "id_clasificador", "cuenta", "contrasena", "fecha_caducidad", "fecha_reg", "estilo", "contrasena_anterior", "id_persona", "estado_reg", "autentificacion")
VALUES (3, 1, E'ga', E'32d7508fe69220cb40af28441ef746d9', E'2014-04-29', E'2013-03-28', E'xtheme-blue.css', NULL, 4, E'activo', E'local');

INSERT INTO segu.tusuario ("id_usuario", "id_clasificador", "cuenta", "contrasena", "fecha_caducidad", "fecha_reg", "estilo", "contrasena_anterior", "id_persona", "estado_reg", "autentificacion")
VALUES (4, 1, E'jo', E'674f33841e2309ffdd24c85dc3b999de', E'2014-04-29', E'2013-03-28', E'xtheme-blue.css', NULL, 5, E'activo', E'local');

INSERT INTO segu.tusuario ("id_usuario", "id_clasificador", "cuenta", "contrasena", "fecha_caducidad", "fecha_reg", "estilo", "contrasena_anterior", "id_persona", "estado_reg", "autentificacion")
VALUES (5, 1, E'edu', E'379ef4bd50c30e261ccfb18dfc626d9f', E'2014-04-29', E'2013-03-28', E'xtheme-blue.css', NULL, 6, E'activo', E'local');
*/
/*
INSERT INTO segu.tusuario_rol ("id_usuario_rol", "id_rol", "id_usuario", "fecha_reg", "estado_reg")
VALUES (2, 2, 2, NULL, E'activo');

INSERT INTO segu.tusuario_rol ("id_usuario_rol", "id_rol", "id_usuario", "fecha_reg", "estado_reg")
VALUES (3, 3, 3, NULL, E'activo');

INSERT INTO segu.tusuario_rol ("id_usuario_rol", "id_rol", "id_usuario", "fecha_reg", "estado_reg")
VALUES (4, 3, 4, NULL, E'activo');

INSERT INTO segu.tusuario_rol ("id_usuario_rol", "id_rol", "id_usuario", "fecha_reg", "estado_reg")
VALUES (5, 4, 5, NULL, E'activo');
*/
-------------------------------------------
-- FIN USUARIOS DE PRUEBA 
-- Autor Gonzalo Sarmiento Sejas
------------------------------------------

-------------------------------------
-- DATOS PARA BOA
-- Autor Gonzalo Sarmiento Sejas
--------------------------------------
/*
INSERT INTO segu.tpersona ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_persona", "nombre", "apellido_paterno", "apellido_materno", "ci", "correo", "celular1", "num_documento", "telefono1", "telefono2", "celular2", "foto", "extension", "genero", "fecha_nacimiento", "direccion")
VALUES (1, NULL, E'2012-05-20 00:00:00', NULL, E'activo', 8466, E'MARCO ANTONIO', E'MENDOZA', E'SALAZAR', E'4417656', E'marco_mendoza77@hotmail.com', E'72242710', NULL, E'4490612', E'4140873', E'72242710', NULL, NULL, E'', E'1977-08-10', E'ZENOBIO GALLARDO 3403');

INSERT INTO orga.tfuncionario ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_funcionario", "id_persona", "codigo", "email_empresa", "interno", "fecha_ingreso", "telefono_ofi")
VALUES (1, NULL, E'2012-06-04 00:00:00', NULL, E'activo', 69, 8466, E'77-0810-MSM', NULL, NULL, E'2013-04-22', NULL);

INSERT INTO param.taprobador ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_aprobador", "id_funcionario", "id_subsistema", "id_centro_costo", "monto_min", "monto_max", "fecha_ini", "fecha_fin", "id_uo", "obs", "id_ep")
VALUES (1, 1, E'2013-04-22 16:33:51.600', E'2013-04-22 16:42:06.048', E'activo', 3, 69, 6, NULL, '0', NULL, E'2013-04-22', NULL, 9, E'', NULL);

INSERT INTO param.tdepto ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_depto", "id_subsistema", "codigo", "nombre", "nombre_corto")
VALUES (1, NULL, E'2013-04-22 00:00:00', E'2013-04-22 12:25:30.633', E'activo', 13, 6, E'DAQ-CENTRAL', E'Departamento de Adquisiciones', E'Adquisiciones');

INSERT INTO param.tdepto ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_depto", "id_subsistema", "codigo", "nombre", "nombre_corto")
VALUES (1, NULL, E'2013-04-22 00:00:00', E'2013-04-22 19:41:33.152', E'activo', 15, 11, E'tesor', E'tesoreria', E'tesorer');

INSERT INTO param.tdepto_usuario ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_depto_usuario", "id_depto", "id_usuario", "funcion", "cargo")
VALUES (1, NULL, E'2013-04-22 12:26:11.378', NULL, E'activo', 1, 13, 5, NULL, E'Gerencia de Mantenimiento');

INSERT INTO orga.testructura_uo ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_estructura_uo", "id_uo_padre", "id_uo_hijo")
VALUES (1, NULL, E'2012-05-17 00:00:00', NULL, E'activo', 36, 2, 39);

INSERT INTO orga.tuo ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_uo", "nombre_unidad", "nombre_cargo", "cargo_individual", "descripcion", "presupuesta", "codigo", "nodo_base", "gerencia", "correspondencia")
VALUES (1, NULL, E'2012-05-17 00:00:00', NULL, E'activo', 39, E'Departamento de Mantenimiento', E'Jefe Departamento de Mantenimiento', E'si', E'Jefe Departamento de Mantenimiento', E'si', E'MD', E'no', E'no', E'no');

INSERT INTO orga.tuo_funcionario ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_uo_funcionario", "id_uo", "id_funcionario", "fecha_asignacion", "fecha_finalizacion")
VALUES (NULL, NULL, E'2013-04-23 12:19:22.685', E'2013-04-23 12:19:22.685', E'activo', 4, 39, 69, E'2013-04-23', NULL);

INSERT INTO param.tdepto_uo ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_depto_uo", "id_depto", "id_uo")
VALUES (1, NULL, E'2013-04-22 12:26:50.907', NULL, E'activo', 1, 13, 39);

INSERT INTO segu.tpersona ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_persona", "nombre", "apellido_paterno", "apellido_materno", "ci", "correo", "celular1", "num_documento", "telefono1", "telefono2", "celular2", "foto", "extension", "genero", "fecha_nacimiento", "direccion")
VALUES (1, NULL, E'2012-05-22 00:00:00', NULL, E'activo', 8716, E'ROGER WILMER', E'BALDERRAMA', E'ANGULO', E'3006828', E'wilmer.balderrama@gmail.com', E'71727872', NULL, E'4450210', E'4141968', E'72242020', NULL, NULL, E'', E'1963-05-26', E'CALLE SCHILLER NO. 0394');

INSERT INTO segu.tpersona ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_persona", "nombre", "apellido_paterno", "apellido_materno", "ci", "correo", "celular1", "num_documento", "telefono1", "telefono2", "celular2", "foto", "extension", "genero", "fecha_nacimiento", "direccion")
VALUES (1, NULL, E'2012-05-21 00:00:00', NULL, E'activo', 8560, E'CAROLINA VANESSA', E'JORDAN', E'CARDONA', E'5308868', E'cjordan@boa.bo', E'70303805', NULL, E'4242157', NULL, NULL, NULL, NULL, E'', E'1983-01-09', E'pasaje luis calvo');

INSERT INTO segu.tpersona ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_persona", "nombre", "apellido_paterno", "apellido_materno", "ci", "correo", "celular1", "num_documento", "telefono1", "telefono2", "celular2", "foto", "extension", "genero", "fecha_nacimiento", "direccion")
VALUES (1, NULL, E'2012-05-22 00:00:00', NULL, E'activo', 8786, E'PASTOR JAIME', E'LAZARTE', E'VILLAGRA', E'3136291', E'pjlazarte@hotmail.com', E'72249882', NULL, E'4712718', E'4159321', E'72249882', NULL, NULL, E'', E'1966-06-05', E'URB.LOS OLIVOS');

--INSERT INTO segu.tpersona ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_persona", "nombre", "apellido_paterno", "apellido_materno", "ci", "correo", "celular1", "num_documento", "telefono1", "telefono2", "celular2", "foto", "extension", "genero", "fecha_nacimiento", "direccion")
--VALUES (1, NULL, E'2012-05-20 00:00:00', NULL, E'activo', 8465, E'VICTOR', E'MAMANI', E'VARGAS', E'2228187', E'vmamani@boa.bo', E'72201285', NULL, E'4122438', NULL, NULL, NULL, NULL, E'', E'1954-11-08', E'GabrielReneMoreno106');

INSERT INTO segu.tpersona ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_persona", "nombre", "apellido_paterno", "apellido_materno", "ci", "correo", "celular1", "num_documento", "telefono1", "telefono2", "celular2", "foto", "extension", "genero", "fecha_nacimiento", "direccion")
VALUES (1, NULL, E'2012-05-17 00:00:00', E'2012-05-17 00:00:00', E'activo', 8415, E'ROCIO ESDENKA', E'CLAURE', E'CASTELLON', NULL, E'rclaure@boa.bo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, E'', E'2012-05-07', NULL);

INSERT INTO segu.tusuario ("id_usuario", "id_clasificador", "cuenta", "contrasena", "fecha_caducidad", "fecha_reg", "estilo", "contrasena_anterior", "id_persona", "estado_reg", "autentificacion")
VALUES (6, 1, E'roger', E'b911af807c2df88d671bd7004c54c1c2', E'2013-04-30', E'2013-04-22', E'xtheme-gray.css', NULL, 8716, E'activo', E'local');

INSERT INTO segu.tusuario ("id_usuario", "id_clasificador", "cuenta", "contrasena", "fecha_caducidad", "fecha_reg", "estilo", "contrasena_anterior", "id_persona", "estado_reg", "autentificacion")
VALUES (3, 1, E'caro', E'437612e345ed8c59db6e905a8dc0d1c6', E'2013-04-30', E'2013-04-22', E'xtheme-blue.css', NULL, 8560, E'activo', E'local');

INSERT INTO segu.tusuario ("id_usuario", "id_clasificador", "cuenta", "contrasena", "fecha_caducidad", "fecha_reg", "estilo", "contrasena_anterior", "id_persona", "estado_reg", "autentificacion")
VALUES (5, 1, E'jaime', E'fde2fdb1dbf604aede0ffee76d26e4ce', E'2013-04-30', E'2013-04-22', E'xtheme-blue.css', NULL, 8786, E'activo', E'local');

--INSERT INTO segu.tusuario ("id_usuario", "id_clasificador", "cuenta", "contrasena", "fecha_caducidad", "fecha_reg", "estilo", "contrasena_anterior", "id_persona", "estado_reg", "autentificacion")
--VALUES (9, 1, E'victor', E'ffc150a160d37e92012c196b6af4160d', E'2013-04-30', E'2013-04-22', E'xtheme-blue.css', NULL, 8465, E'activo', E'local');

INSERT INTO segu.tusuario ("id_usuario", "id_clasificador", "cuenta", "contrasena", "fecha_caducidad", "fecha_reg", "estilo", "contrasena_anterior", "id_persona", "estado_reg", "autentificacion")
VALUES (4, 1, E'marco', E'f5888d0bb58d611107e11f7cbc41c97a', E'2013-04-30', E'2013-04-22', E'xtheme-gray.css', NULL, 8466, E'activo', E'local');

INSERT INTO segu.tusuario ("id_usuario", "id_clasificador", "cuenta", "contrasena", "fecha_caducidad", "fecha_reg", "estilo", "contrasena_anterior", "id_persona", "estado_reg", "autentificacion")
VALUES (75, 2, E'rocio', E'325daa03a34823cef2fc367c779561ba', E'2013-04-30', E'2013-04-22', E'xtheme-gray.css', E'85741b002a62a335b970190271b9cadf', 8415, E'activo', E'local');

INSERT INTO orga.tfuncionario ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_funcionario", "id_persona", "codigo", "email_empresa", "interno", "fecha_ingreso", "telefono_ofi")
VALUES (1, NULL, E'2012-06-04 00:00:00', NULL, E'activo', 300, 8716, E'63-0526-BAR', NULL, NULL, E'2013-04-22', NULL);

INSERT INTO param.tgestion ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_gestion", "gestion", "estado", "id_moneda_base", "id_empresa")
VALUES (1, NULL, E'2013-04-22 11:23:43.102', NULL, E'activo', 11, 2013, E'abierto', 1, 1);

INSERT INTO conta.tauxiliar ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_auxiliar", "id_empresa", "codigo_auxiliar", "nombre_auxiliar")
VALUES (1, NULL, E'2012-09-21 14:56:29.672', NULL, E'activo', 2051, 1, E'80000030', E'ANGLES AOIZ SAMUEL ENRIQUE');

INSERT INTO param.tcentro_costo ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_centro_costo", "id_ep", "id_uo", "id_gestion")
VALUES (18, NULL, E'2012-06-11 06:14:31.319', NULL, E'activo', 35, 33, 1, 9);

INSERT INTO param.tconcepto_ingas ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_concepto_ingas", "tipo", "desc_ingas", "movimiento", "sw_tes", "id_oec")
VALUES (18, 1, E'2012-06-12 03:55:51.952', E'2013-04-22 12:56:46.953', E'activo', 608, E'Bien', E'Sillas giratorias', E'gasto', E'2', NULL);

INSERT INTO conta.tcuenta ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_cuenta", "id_empresa", "id_parametro", "id_cuenta_padre", "nro_cuenta", "id_gestion", "id_moneda", "nombre_cuenta", "desc_cuenta", "nivel_cuenta", "tipo_cuenta", "sw_transaccional", "sw_oec", "sw_auxiliar", "tipo_cuenta_pat", "cuenta_sigma", "sw_sigma", "id_cuenta_actualizacion", "id_auxliar_actualizacion", "sw_sistema_actualizacion", "id_cuenta_dif", "id_auxiliar_dif", "id_cuenta_sigma", "cuenta_flujo_sigma")
VALUES (1, NULL, E'2013-04-22 14:44:56.174', NULL, E'activo', 18044, 1, 5, NULL, E'1', 11, NULL, E'ACTIVO - 2013', E'ACTIVO 2013', 1, E'activo', E'movimiento', 2, E'2', NULL, E'10000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO conta.tcuenta ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_cuenta", "id_empresa", "id_parametro", "id_cuenta_padre", "nro_cuenta", "id_gestion", "id_moneda", "nombre_cuenta", "desc_cuenta", "nivel_cuenta", "tipo_cuenta", "sw_transaccional", "sw_oec", "sw_auxiliar", "tipo_cuenta_pat", "cuenta_sigma", "sw_sigma", "id_cuenta_actualizacion", "id_auxliar_actualizacion", "sw_sistema_actualizacion", "id_cuenta_dif", "id_auxiliar_dif", "id_cuenta_sigma", "cuenta_flujo_sigma")
VALUES (1, NULL, E'2013-04-22 14:44:56.174', NULL, E'activo', 18060, 1, 5, 18044, E'12', 11, 1, E'Activo No Corriente', E'Activo No Corriente', 2, E'activo', E'movimiento', 2, E'2', NULL, E'12000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO conta.tcuenta ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_cuenta", "id_empresa", "id_parametro", "id_cuenta_padre", "nro_cuenta", "id_gestion", "id_moneda", "nombre_cuenta", "desc_cuenta", "nivel_cuenta", "tipo_cuenta", "sw_transaccional", "sw_oec", "sw_auxiliar", "tipo_cuenta_pat", "cuenta_sigma", "sw_sigma", "id_cuenta_actualizacion", "id_auxliar_actualizacion", "sw_sistema_actualizacion", "id_cuenta_dif", "id_auxiliar_dif", "id_cuenta_sigma", "cuenta_flujo_sigma")
VALUES (1, NULL, E'2013-04-22 14:44:56.174', NULL, E'activo', 18163, 1, 5, 18060, E'124', 11, 1, E'(Depreciación Acumulada del Activo Fijo)', E'(Depreciación Acumulada del Activo Fijo)', 3, E'activo', E'movimiento', 2, E'2', NULL, E'12400', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO conta.tcuenta ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_cuenta", "id_empresa", "id_parametro", "id_cuenta_padre", "nro_cuenta", "id_gestion", "id_moneda", "nombre_cuenta", "desc_cuenta", "nivel_cuenta", "tipo_cuenta", "sw_transaccional", "sw_oec", "sw_auxiliar", "tipo_cuenta_pat", "cuenta_sigma", "sw_sigma", "id_cuenta_actualizacion", "id_auxliar_actualizacion", "sw_sistema_actualizacion", "id_cuenta_dif", "id_auxiliar_dif", "id_cuenta_sigma", "cuenta_flujo_sigma")
VALUES (1, NULL, E'2013-04-22 14:44:56.174', NULL, E'activo', 18302, 1, 5, 18163, E'1242', 11, 1, E'(Equipo de Oficina y Muebles)', E'(Equipo de Oficina y Muebles)', 4, E'activo', E'movimiento', 2, E'1', NULL, E'12420', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO conta.tcuenta ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_cuenta", "id_empresa", "id_parametro", "id_cuenta_padre", "nro_cuenta", "id_gestion", "id_moneda", "nombre_cuenta", "desc_cuenta", "nivel_cuenta", "tipo_cuenta", "sw_transaccional", "sw_oec", "sw_auxiliar", "tipo_cuenta_pat", "cuenta_sigma", "sw_sigma", "id_cuenta_actualizacion", "id_auxliar_actualizacion", "sw_sistema_actualizacion", "id_cuenta_dif", "id_auxiliar_dif", "id_cuenta_sigma", "cuenta_flujo_sigma")
VALUES (1, NULL, E'2013-04-22 14:44:56.174', NULL, E'activo', 18434, 1, 5, 18302, E'12420.01', 11, 1, E'(Equipo de Oficina y Muebles)', E'(Equipo de Oficina y Muebles)', 6, E'activo', E'movimiento', 2, E'1', E'capital', E'12420', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO pre.tpartida ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_partida", "id_partida_fk", "id_gestion", "id_parametros", "codigo", "nombre_partida", "descripcion", "nivel_partida", "sw_transaccional", "tipo", "sw_movimiento", "cod_trans", "cod_ascii", "cod_excel", "ent_trf")
VALUES (83, NULL, E'2012-07-25 06:40:52.070', NULL, E'activo', 6029, NULL, 11, 5, E'', E'CLASIFICADOR PRESUPUESTARIO POR OBJETO DEL GASTO 2013', E'.', 0, E'titular', E'gasto', E'presupuestaria', E'0000', E'no', E'no', E'0');

INSERT INTO pre.tpartida ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_partida", "id_partida_fk", "id_gestion", "id_parametros", "codigo", "nombre_partida", "descripcion", "nivel_partida", "sw_transaccional", "tipo", "sw_movimiento", "cod_trans", "cod_ascii", "cod_excel", "ent_trf")
VALUES (83, NULL, E'2012-07-25 06:40:52.070', NULL, E'activo', 6316, 6029, 11, 5, E'40000', E'ACTIVOS REALES', E'Gastos para la adquisición de bienes duraderos, construcción de obras por terceros, compra de maquinaria y equipo y semovientes. Se incluyen los estudios, investigaciones y proyectos realizados por terceros y la contratación de servicios de supervisión de construcciones y mejoras de bienes públicos de dominio privado y público, cuando corresponda incluirlos como parte del activo institucional. Comprende asimismo los activos intangibles.', 1, E'titular', E'gasto', E'presupuestaria', E'0000', E'si', E'no', E'0');

INSERT INTO pre.tpartida ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_partida", "id_partida_fk", "id_gestion", "id_parametros", "codigo", "nombre_partida", "descripcion", "nivel_partida", "sw_transaccional", "tipo", "sw_movimiento", "cod_trans", "cod_ascii", "cod_excel", "ent_trf")
VALUES (83, NULL, E'2012-07-25 06:40:52.070', NULL, E'activo', 6324, 6316, 11, 5, E'43000', E'Maquinaria y Equipo', E'Gastos para la adquisición de maquinarias, equipos y aditamentos que se usan o complementan a la unidad principal, comprendiendo: maquinaria y equipo de oficina, de producción, equipos agropecuarios, industriales, de transporte en general, energía, riego, frigoríficos, de comunicaciones, médicos, odontológicos, educativos y otros similares.', 2, E'titular', E'gasto', E'presupuestaria', E'0000', E'no', E'no', E'0');

INSERT INTO pre.tpartida ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_partida", "id_partida_fk", "id_gestion", "id_parametros", "codigo", "nombre_partida", "descripcion", "nivel_partida", "sw_transaccional", "tipo", "sw_movimiento", "cod_trans", "cod_ascii", "cod_excel", "ent_trf")
VALUES (83, NULL, E'2012-07-25 06:40:52.070', NULL, E'activo', 6325, 6324, 11, 5, E'43100', E'Equipo de Oficina y Muebles', E'Gastos para la adquisición de muebles, equipos de computación, fotocopiadoras, máquinas de escribir, calculadoras, relojes para control, calentadores de ambiente, enceradoras, refrigeradores, cocinas, aspiradoras, mesas para dibujo y otros similares.', 3, E'titular', E'gasto', E'presupuestaria', E'0000', E'no', E'no', E'0');

INSERT INTO pre.tpartida ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_partida", "id_partida_fk", "id_gestion", "id_parametros", "codigo", "nombre_partida", "descripcion", "nivel_partida", "sw_transaccional", "tipo", "sw_movimiento", "cod_trans", "cod_ascii", "cod_excel", "ent_trf")
VALUES (1, 1, E'2012-07-25 06:40:52.070', E'2013-04-22 14:23:54.335', E'activo', 6326, 6325, 11, 5, E'43110', E'Equipo de Oficina y Muebles', E'Gastos para la adquisición de muebles y enseres para el equipamiento de oficina.', 4, E'movimiento', E'gasto', E'presupuestaria', E'0000', E'si', E'no', E'0');

INSERT INTO param.tinstitucion ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_institucion", "doc_id", "nombre", "casilla", "telefono1", "telefono2", "celular1", "celular2", "fax", "email1", "email2", "pag_web", "observaciones", "id_persona", "direccion", "codigo_banco", "es_banco", "codigo", "cargo_representante")
VALUES (1, NULL, E'2008-10-01 00:00:00', NULL, E'activo', 32, NULL, E'ACCESS NET', NULL, E'2310084', NULL, NULL, NULL, E'2310084', E'accessnetbolivia@hotmail.com', NULL, NULL, NULL, NULL, E'CALLE MURILLO Nº 1379', NULL, E'no', E'ACCESSNET', NULL);

INSERT INTO param.tproveedor ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_proveedor", "id_institucion", "id_persona", "tipo", "numero_sigma", "codigo", "nit", "id_lugar")
VALUES (1, NULL, E'2008-10-01 00:00:00', NULL, E'activo', 21, 32, NULL, NULL, NULL, E'PROV0021', NULL, NULL);

*/
/* Data for the 'segu.tusuario_rol' table  (Records 1 - 9) */
/*
--INSERT INTO segu.tusuario_rol ("id_usuario_rol", "id_rol", "id_usuario", "fecha_reg", "estado_reg")
--VALUES (1, 1, 1, E'2011-05-17', E'activo');

INSERT INTO segu.tusuario_rol ("id_usuario_rol", "id_rol", "id_usuario", "fecha_reg", "estado_reg")
VALUES (3, 2, 3, NULL, E'activo');

INSERT INTO segu.tusuario_rol ("id_usuario_rol", "id_rol", "id_usuario", "fecha_reg", "estado_reg")
VALUES (4, 3, 4, NULL, E'activo');

INSERT INTO segu.tusuario_rol ("id_usuario_rol", "id_rol", "id_usuario", "fecha_reg", "estado_reg")
VALUES (5, 3, 6, NULL, E'activo');

--INSERT INTO segu.tusuario_rol ("id_usuario_rol", "id_rol", "id_usuario", "fecha_reg", "estado_reg")
--VALUES (6, 3, 7, NULL, E'activo');

--INSERT INTO segu.tusuario_rol ("id_usuario_rol", "id_rol", "id_usuario", "fecha_reg", "estado_reg")
--VALUES (7, 4, 9, NULL, E'activo');

--INSERT INTO segu.tusuario_rol ("id_usuario_rol", "id_rol", "id_usuario", "fecha_reg", "estado_reg")
--VALUES (2, 2, 2, NULL, E'inactivo');

INSERT INTO segu.tusuario_rol ("id_usuario_rol", "id_rol", "id_usuario", "fecha_reg", "estado_reg")
VALUES (8, 4, 5, NULL, E'activo');

INSERT INTO segu.tusuario_rol ("id_usuario_rol", "id_rol", "id_usuario", "fecha_reg", "estado_reg")
VALUES (9, 5, 75, NULL, E'activo');*/
