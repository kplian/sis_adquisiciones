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
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_COTOC_REP', 'PROC.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_HABPAG_IME', 'PROC.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_ANTEST_IME', 'PROC.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_ADJTODO_IME', 'PROC.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_TOTALADJ_IME', 'PROC.1.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_ADJDET_IME', 'PROC.1.1');
select pxp.f_insert_trol_procedimiento_gui ('Proceso de compra encargado', 'ADQ_GENOC_IME', 'PROC.1');
-------------------------------------------
-- FIN ROLES 
-- Autor Gonzalo Sarmiento Sejas
------------------------------------------


-------------------------------------
-- DATOS PARA BOA
-- Autor Gonzalo Sarmiento Sejas
--------------------------------------

INSERT INTO wf.tfuncionario_tipo_estado ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_funcionario_tipo_estado", "id_tipo_estado", "id_funcionario", "id_depto", "id_labores_tipo_proceso")
VALUES (1, NULL, E'2013-04-30 16:28:35.283', NULL, E'activo', 1, 6, 64, 5, NULL);

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

