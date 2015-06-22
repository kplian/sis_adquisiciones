------------------------------
--               APROBADORES (EN PARAMETROS)
--------------------------



/* Data for the 'param.taprobador' table  (Records 1 - 1) */

INSERT INTO param.taprobador ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_aprobador", "id_funcionario", "id_subsistema", "id_centro_costo", "monto_min", "monto_max", "fecha_ini", "fecha_fin", "id_uo", "obs", "id_ep")
VALUES (1, NULL, E'2013-04-30 16:03:43.643', NULL, E'activo', 1, 300, 7, NULL, '0', NULL, E'2013-02-01', NULL, 39, E'', NULL);

---------------------------------------------------
-- DEPTOS (EN PARAMETROS)
------------------------------------------------

/* Data for the 'param.tdepto' table  (Records 1 - 1) */

INSERT INTO param.tdepto ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_depto", "id_subsistema", "codigo", "nombre", "nombre_corto")
VALUES (1, NULL, E'2013-04-30 00:00:00', E'2013-04-30 15:46:26.154', E'activo', 5, 7, E'ADQ-CEN', E'Adquisiciones Central', E'');

/* Data for the 'param.tdepto_usuario' table  (Records 1 - 3) */

INSERT INTO param.tdepto_usuario ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_depto_usuario", "id_depto", "id_usuario", "funcion", "cargo")
VALUES (1, NULL, E'2013-04-30 15:46:58.360', NULL, E'activo', 1, 5, 51, NULL, E'Solicitante');

INSERT INTO param.tdepto_usuario ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_depto_usuario", "id_depto", "id_usuario", "funcion", "cargo")
VALUES (1, NULL, E'2013-04-30 16:52:12.692', NULL, E'activo', 2, 5, 55, NULL, E'responsable proceso compra');

INSERT INTO param.tdepto_usuario ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_depto_usuario", "id_depto", "id_usuario", "funcion", "cargo")
VALUES (1, NULL, E'2013-04-30 18:49:37.675', NULL, E'activo', 3, 5, 52, NULL, E'visto bueno');

-------------------------------------------
-- INICIO ROLES 
-- Autor Gonzalo Sarmiento Sejas
------------------------------------------

--roles--

select pxp.f_insert_trol ('solicitante de compra', 'Solicitante de Compra', 'ADQ');
select pxp.f_insert_trol ('visto bueno de solicitud de compra', 'Visto Bueno Solicitud', 'ADQ');
select pxp.f_insert_trol ('proceso de compra', 'Proceso de compra encargado', 'ADQ');
select pxp.f_insert_trol ('visto bueno cotizacion', 'Visto Bueno Cotizacion', 'ADQ');

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
select pxp.f_insert_tgui_rol ('VBCOT', 'Visto Bueno Cotizacion');
select pxp.f_insert_tgui_rol ('ADQ', 'Visto Bueno Cotizacion');

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
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'PROC.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_ESTSOL_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_ESTSOL_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_CONT', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLAPRO_IME', 'PROC.1', 'no');

select pxp.f_insert_tprocedimiento_gui ('ADQ_COTRPC_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GENOC_IME', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTOC_REP', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTREP_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_ANTEST_IME', 'VBCOT', 'no');

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
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_COTOC_REP', 'PROC.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_HABPAG_IME', 'PROC.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_ANTEST_IME', 'PROC.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_ADJTODO_IME', 'PROC.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_TOTALADJ_IME', 'PROC.1.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_ADJDET_IME', 'PROC.1.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_GENOC_IME', 'PROC.1');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'PM_DEPUSUCOMB_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'ADQ_ESTSOL_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('Visto Bueno Solicitud', 'ADQ_ESTSOL_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'PM_DEPUSUCOMB_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'PM_CECCOM_SEL', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('Solicitante de Compra', 'PM_CECCOM_CONT', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_SOLAPRO_IME', 'PROC.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_PROCPED_SEL', 'PROC');

select pxp.f_insert_trol_procedimiento_gui ('Visto Bueno Cotizacion', 'ADQ_CTD_SEL', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('Visto Bueno Cotizacion', 'ADQ_COTREP_SEL', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('Visto Bueno Cotizacion', 'ADQ_COTOC_REP', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('Visto Bueno Cotizacion', 'ADQ_GENOC_IME', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('Visto Bueno Cotizacion', 'ADQ_ANTEST_IME', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('Visto Bueno Cotizacion', 'ADQ_COTRPC_SEL', 'VBCOT');

-------------------------------------------
-- FIN ROLES 
-- Autor Gonzalo Sarmiento Sejas
------------------------------------------

INSERT INTO wf.tfuncionario_tipo_estado ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_funcionario_tipo_estado", "id_tipo_estado", "id_funcionario", "id_depto", "id_labores_tipo_proceso")
VALUES (1, NULL, E'2013-05-07 15:02:49.151', NULL, E'activo', 1, 6, 64, 5, NULL);

-------------------------------------
-- DATOS PARA BOA
-- Autor Gonzalo Sarmiento Sejas
--------------------------------------

/* Data for the 'segu.tusuario_rol' table  (Records 1 - 6) */

--usuario-rol

INSERT INTO segu.tusuario_rol ("id_usuario_rol", "id_rol", "id_usuario", "fecha_reg", "estado_reg")
VALUES (3, 4, 51, NULL, E'activo');

INSERT INTO segu.tusuario_rol ("id_usuario_rol", "id_rol", "id_usuario", "fecha_reg", "estado_reg")
VALUES (4, 5, 52, NULL, E'activo');

INSERT INTO segu.tusuario_rol ("id_usuario_rol", "id_rol", "id_usuario", "fecha_reg", "estado_reg")
VALUES (5, 5, 53, NULL, E'activo');

INSERT INTO segu.tusuario_rol ("id_usuario_rol", "id_rol", "id_usuario", "fecha_reg", "estado_reg")
VALUES (6, 5, 54, NULL, E'activo');

INSERT INTO segu.tusuario_rol ("id_usuario_rol", "id_rol", "id_usuario", "fecha_reg", "estado_reg")
VALUES (7, 6, 55, NULL, E'activo');

INSERT INTO segu.tusuario_rol ("id_usuario_rol", "id_rol", "id_usuario", "fecha_reg", "estado_reg")
VALUES (8, 8, 56, NULL, E'activo');

INSERT INTO segu.tusuario_rol ("id_usuario_rol", "id_rol", "id_usuario", "fecha_reg", "estado_reg")
VALUES (9, 7, 54, NULL, E'activo');
