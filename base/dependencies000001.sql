

/***********************************I-DEP-FRH-ADQ-0-15/02/2013*****************************************/


ALTER TABLE adq.tsolicitud ADD CONSTRAINT 
  fk_solicitud__id_funcionario FOREIGN KEY (id_funcionario) REFERENCES orga.tfuncionario (id_funcionario);

ALTER TABLE adq.tsolicitud ADD CONSTRAINT 
  fk_solicitud__id_funcionario_solicitud FOREIGN KEY (id_funcionario_aprobador) REFERENCES orga.tfuncionario (id_funcionario);

ALTER TABLE adq.tsolicitud ADD CONSTRAINT 
  fk_solicitud__id_depto FOREIGN KEY (id_depto) REFERENCES param.tdepto (id_depto);

ALTER TABLE adq.tsolicitud ADD CONSTRAINT 
  fk_solicitud__id_gestion FOREIGN KEY (id_gestion) REFERENCES param.tgestion (id_gestion);

ALTER TABLE adq.tsolicitud ADD CONSTRAINT 
  fk_solicitud__id_categoria_compra FOREIGN KEY (id_categoria_compra) REFERENCES adq.tcategoria_compra (id_categoria_compra);

ALTER TABLE adq.tsolicitud ADD CONSTRAINT 
  fk_solicitud__id_moneda FOREIGN KEY (id_moneda) REFERENCES param.tmoneda (id_moneda);

ALTER TABLE adq.tsolicitud ADD CONSTRAINT 
  fk_solicitud__id_estado_wf FOREIGN KEY (id_estado_wf) REFERENCES wf.testado_wf (id_estado_wf);
  
ALTER TABLE adq.tsolicitud ADD CONSTRAINT 
  fk_solicitud__id_proceso_wf FOREIGN KEY (id_proceso_wf) REFERENCES wf.tproceso_wf (id_proceso_wf);
    
ALTER TABLE adq.tsolicitud ADD CONSTRAINT 
  fk_solicitud__id_solicitud_ext FOREIGN KEY (id_solicitud_ext) REFERENCES adq.tsolicitud (id_solicitud);


--------------- SQL ---------------

ALTER TABLE adq.tcotizacion_det
  ADD CONSTRAINT fk_tcotizacion_det__id_cotizacion FOREIGN KEY (id_cotizacion)
    REFERENCES adq.tcotizacion(id_cotizacion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--------------- SQL ---------------

ALTER TABLE adq.tcotizacion
  ADD CONSTRAINT fk_tcotizacion__id_proceo_compra FOREIGN KEY (id_proceso_compra)
    REFERENCES adq.tproceso_compra(id_proceso_compra)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
 --------------- SQL ---------------

ALTER TABLE adq.tproceso_compra
  ADD CONSTRAINT fk_tproceso_compra__id_solicitud FOREIGN KEY (id_solicitud)
    REFERENCES adq.tsolicitud(id_solicitud)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--------------- SQL ---------------
ALTER TABLE adq.tproceso_compra
  ADD CONSTRAINT fk_tproceso_compra__id_depto FOREIGN KEY (id_depto)
    REFERENCES param.tdepto(id_depto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE adq.tproceso_compra
  ADD CONSTRAINT fk_tproceso_compra__id_proceso_wf FOREIGN KEY (id_proceso_wf)
    REFERENCES wf.tproceso_wf(id_proceso_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--------------- SQL ---------------

ALTER TABLE adq.tsolicitud_det
  ADD CONSTRAINT fk_tsolicitud_det__id_solicitud FOREIGN KEY (id_solicitud)
    REFERENCES adq.tsolicitud(id_solicitud)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--------------- SQL ---------------

ALTER TABLE adq.tsolicitud_det
  ADD CONSTRAINT fk_tsolicitud_det__id_concepto_ingas FOREIGN KEY (id_concepto_ingas)
    REFERENCES param.tconcepto_ingas(id_concepto_ingas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--------------- SQL ---------------

ALTER TABLE adq.tsolicitud_det
  ADD CONSTRAINT fk_tsolicitud_det__id_partida FOREIGN KEY (id_partida)
    REFERENCES pre.tpartida(id_partida)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
--------------- SQL ---------------

ALTER TABLE adq.tsolicitud_det
  ADD CONSTRAINT fk_tsolicitud_det__id_cuenta FOREIGN KEY (id_cuenta)
    REFERENCES conta.tcuenta(id_cuenta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--------------- SQL ---------------

ALTER TABLE adq.tsolicitud_det
  ADD CONSTRAINT fk_tsolicitud_det__id_auxiliar FOREIGN KEY (id_auxiliar)
    REFERENCES conta.tauxiliar(id_auxiliar)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--------------- SQL ---------------

ALTER TABLE adq.tsolicitud_det
  ADD CONSTRAINT fk_tsolicitud_det__id_centro_costo FOREIGN KEY (id_centro_costo)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
 --------------- SQL ---------------
 
ALTER TABLE adq.tcotizacion_det ADD CONSTRAINT fk_cotizacion_det__id_obliacion_det FOREIGN
 KEY( id_obligacion_det) REFERENCES tes.tobligacion_det(id_obligacion_det);
 
 --------------- SQL ---------------

ALTER TABLE adq.tcotizacion_det
  ADD UNIQUE (id_obligacion_det);
 
 
/******************************F-DEP-FRH-ADQ-0-15/02/2013*****************************************/

/***********************************I-DEP-JRR-ADQ-104-04/04/2013****************************************/

ALTER TABLE adq.tcategoria_compra
  ALTER COLUMN id_proceso_macro SET NOT NULL;

ALTER TABLE adq.tcategoria_compra
  ADD CONSTRAINT fk_tcategoria_compra__id_proceso_macro FOREIGN KEY (id_proceso_macro)
    REFERENCES wf.tproceso_macro(id_proceso_macro)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
  
/***********************************F-DEP-JRR-ADQ-104-04/04/2013****************************************/




/***********************************I-DEP-RAC-ADQ-0-26/01/2014****************************************/

--------------- SQL ---------------

ALTER TABLE adq.tproceso_compra
  ADD CONSTRAINT fk_tproceso_compra__id_estado_wf FOREIGN KEY (id_estado_wf)
    REFERENCES wf.testado_wf(id_estado_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


--------------- SQL ---------------

ALTER TABLE adq.tsolicitud
  ADD CONSTRAINT fk_tsolicitud__id_proveedor FOREIGN KEY (id_proveedor)
    REFERENCES param.tproveedor(id_proveedor)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--------------- SQL ---------------

ALTER TABLE adq.tsolicitud
  ADD CONSTRAINT fk_tsolicitud__id_uo FOREIGN KEY (id_uo)
    REFERENCES orga.tuo(id_uo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


--------------- SQL ---------------

CREATE INDEX tsolicitud_idx ON adq.tsolicitud
  USING btree (id_funcionario);
  
  
 --------------- SQL ---------------

CREATE INDEX tsolicitud_idx1 ON adq.tsolicitud
  USING btree (id_estado_wf);
  
 --------------- SQL ---------------

CREATE INDEX tsolicitud_idx2 ON adq.tsolicitud
  USING btree (id_proceso_wf);
  
--------------- SQL ---------------

CREATE INDEX tsolicitud_idx3 ON adq.tsolicitud
  USING btree (id_uo);    
/***********************************F-DEP-RAC-ADQ-0-26/01/2014****************************************/

/***********************************I-DEP-RAC-ADQ-0-04/02/2014****************************************/

--------------- SQL ---------------

ALTER TABLE adq.tsolicitud
  ADD CONSTRAINT fk_tsolicitud__id_proceso_macro FOREIGN KEY (id_proceso_macro)
    REFERENCES wf.tproceso_macro(id_proceso_macro)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


--------------- SQL ---------------

ALTER TABLE adq.tsolicitud_det
  ADD CONSTRAINT fk_tsolicitud_det__id_usuario_reg FOREIGN KEY (id_usuario_reg)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE adq.tsolicitud_det
  ADD CONSTRAINT fk_tsolicitud_det__id_usuario_mod FOREIGN KEY (id_usuario_mod)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
 --------------- SQL ---------------

ALTER TABLE adq.tsolicitud_det
  ADD CONSTRAINT tsolicitud_det__id_centro_costo FOREIGN KEY (id_centro_costo)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    

    
--------------- SQL ---------------

ALTER TABLE adq.tsolicitud_det
  ADD CONSTRAINT tsolicitud_det__id_auxiliar FOREIGN KEY (id_auxiliar)
    REFERENCES conta.tauxiliar(id_auxiliar)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE adq.tsolicitud_det
  ADD CONSTRAINT tsolicitud_det__id_concepto_in_gas FOREIGN KEY (id_concepto_ingas)
    REFERENCES param.tconcepto_ingas(id_concepto_ingas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
 --------------- SQL ---------------

ALTER TABLE adq.tsolicitud_det
  ADD CONSTRAINT tsolicitud_det__id_orden_trabajo FOREIGN KEY (id_orden_trabajo)
    REFERENCES conta.torden_trabajo(id_orden_trabajo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE adq.tproceso_compra
  ADD CONSTRAINT fk_tproceso_compra__id_usuari_reg FOREIGN KEY (id_usuario_reg)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
--------------- SQL ---------------

ALTER TABLE adq.tproceso_compra
  ADD CONSTRAINT mod_tproceso_compra__id_usuario_mod FOREIGN KEY (id_usuario_mod)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
--------------- SQL ---------------

ALTER TABLE adq.tcotizacion
  ADD CONSTRAINT tcotizacion__id_usuario_reg FOREIGN KEY (id_usuario_reg)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE adq.tcotizacion
  ADD CONSTRAINT tcotizacion__id_usuario_mod FOREIGN KEY (id_usuario_mod)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    

    
--------------- SQL ---------------

ALTER TABLE adq.tcotizacion
  ADD CONSTRAINT tcotizacion__id_proveedor FOREIGN KEY (id_proveedor)
    REFERENCES param.tproveedor(id_proveedor)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE adq.tcotizacion
  ADD CONSTRAINT tcotizacion_fk FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    

--------------- SQL ---------------

ALTER TABLE adq.tcotizacion
  ADD CONSTRAINT tcotizacion__id_estado_wf FOREIGN KEY (id_estado_wf)
    REFERENCES wf.testado_wf(id_estado_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


--------------- SQL ---------------

ALTER TABLE adq.tcotizacion
  ADD CONSTRAINT tcotizacion__id_proceso_wf FOREIGN KEY (id_proceso_wf)
    REFERENCES wf.tproceso_wf(id_proceso_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--------------- SQL ---------------

ALTER TABLE adq.tcotizacion_det
  ADD CONSTRAINT tcotizacion_det__id_solicitud_det FOREIGN KEY (id_solicitud_det)
    REFERENCES adq.tsolicitud_det(id_solicitud_det)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
--------------- SQL ---------------

ALTER TABLE adq.tcotizacion_det
  ADD CONSTRAINT tcotizacion_det__id_usuario_reg FOREIGN KEY (id_usuario_reg)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE adq.tcotizacion_det
  ADD CONSTRAINT tcotizacion_det__id_usuario_mod FOREIGN KEY (id_usuario_mod)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE adq.tcategoria_compra
  ADD CONSTRAINT tcategoria_compra__id_usuario_reg FOREIGN KEY (id_usuario_reg)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
--------------- SQL ---------------

ALTER TABLE adq.tcategoria_compra
  ADD CONSTRAINT tcategoria_compra__id_usuario_mod FOREIGN KEY (id_usuario_mod)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


--------------- SQL ---------------

ALTER TABLE adq.tgrupo
  ADD CONSTRAINT tgrupo__id_usuario_reg FOREIGN KEY (id_usuario_reg)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE adq.tgrupo
  ADD CONSTRAINT tgrupo__id_usuario_mod FOREIGN KEY (id_usuario_mod)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--------------- SQL ---------------

ALTER TABLE adq.tgrupo_partida
  ADD CONSTRAINT tgrupo_partida__id_usuario_reg FOREIGN KEY (id_usuario_reg)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE adq.tgrupo_partida
  ADD CONSTRAINT tgrupo_partida__id_usuario_mod FOREIGN KEY (id_usuario_mod)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE adq.tgrupo_partida
  ADD CONSTRAINT tgrupo_partida__id_grupo FOREIGN KEY (id_grupo)
    REFERENCES adq.tgrupo(id_grupo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


--------------- SQL ---------------

ALTER TABLE adq.tgrupo_partida
  ADD CONSTRAINT tgrupo_partida__id_partida FOREIGN KEY (id_partida)
    REFERENCES pre.tpartida(id_partida)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE adq.tgrupo_partida
  ADD CONSTRAINT tgrupo_partida__id_gestion FOREIGN KEY (id_gestion)
    REFERENCES param.tgestion(id_gestion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
--------------- SQL ---------------

ALTER TABLE adq.tgrupo_usuario
  ADD CONSTRAINT tgrupo_usuario__is_usuario_reg FOREIGN KEY (id_usuario_reg)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;    
    
--------------- SQL ---------------

ALTER TABLE adq.tgrupo_usuario
  ADD CONSTRAINT tgrupo_usuario__id_usuario_mod FOREIGN KEY (id_usuario_mod)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    

--------------- SQL ---------------

ALTER TABLE adq.tgrupo_usuario
  ADD CONSTRAINT tgrupo_usuario__id_grupo FOREIGN KEY (id_grupo)
    REFERENCES adq.tgrupo(id_grupo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE adq.tgrupo_usuario
  ADD CONSTRAINT tgrupo_usuario__id_usuairo FOREIGN KEY (id_usuario)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;    
    
--------------- SQL ---------------

ALTER TABLE adq.tpresolicitud
  ADD CONSTRAINT tpresolicitud__id_usuario_reg FOREIGN KEY (id_usuario_reg)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--------------- SQL ---------------

ALTER TABLE adq.tpresolicitud
  ADD CONSTRAINT tpresolicitud__id_usuario_mod FOREIGN KEY (id_usuario_mod)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

 
--------------- SQL ---------------

ALTER TABLE adq.tpresolicitud
  ADD CONSTRAINT tpresolicitud__id_grupo FOREIGN KEY (id_grupo)
    REFERENCES adq.tgrupo(id_grupo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    

--------------- SQL ---------------

ALTER TABLE adq.tpresolicitud
  ADD CONSTRAINT tpresolicitud__id_funcionario FOREIGN KEY (id_funcionario)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
 
 
--------------- SQL ---------------

ALTER TABLE adq.tpresolicitud
  ADD CONSTRAINT tpresolicitud__id_funcionario_sup FOREIGN KEY (id_funcionario_supervisor)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE adq.tpresolicitud
  ADD CONSTRAINT tpresolicitud__id_uo FOREIGN KEY (id_uo)
    REFERENCES orga.tuo(id_uo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE adq.tpresolicitud
  ADD CONSTRAINT tpresolicitud__id_depto FOREIGN KEY (id_depto)
    REFERENCES param.tdepto(id_depto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE adq.tpresolicitud
  ADD CONSTRAINT tpresolicitud__id_gestion FOREIGN KEY (id_gestion)
    REFERENCES param.tgestion(id_gestion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
 --------------- SQL ---------------

ALTER TABLE adq.tpresolicitud_det
  ADD CONSTRAINT tpresolicitud_det_id_usuario_reg FOREIGN KEY (id_usuario_reg)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE; 
 
--------------- SQL ---------------

ALTER TABLE adq.tpresolicitud_det
  ADD CONSTRAINT tpresolicitud_det__id_usuario_mod FOREIGN KEY (id_usuario_mod)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE adq.tpresolicitud_det
  ADD CONSTRAINT tpresolicitud_det__id_presolicitud FOREIGN KEY (id_presolicitud)
    REFERENCES adq.tpresolicitud(id_presolicitud)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE adq.tpresolicitud_det
  ADD CONSTRAINT tpresolicitud_det__id_solicitud_det FOREIGN KEY (id_solicitud_det)
    REFERENCES adq.tsolicitud_det(id_solicitud_det)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;




--------------- SQL ---------------

ALTER TABLE adq.tpresolicitud_det
  ADD CONSTRAINT tpresolicitud_det__id_cocepto_gasto FOREIGN KEY (id_concepto_ingas)
    REFERENCES param.tconcepto_ingas(id_concepto_ingas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
--------------- SQL ---------------

ALTER TABLE adq.tpresolicitud_det
  ADD CONSTRAINT tpresolicitud_det__id_centro_costo FOREIGN KEY (id_centro_costo)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
        
/***********************************F-DEP-RAC-ADQ-0-04/02/2014****************************************/


/***********************************I-DEP-RAC-ADQ-0-17/03/2014****************************************/
--------------- SQL ---------------

ALTER TABLE adq.tsolicitud
  ADD CONSTRAINT fk_tsolicitud__id_funcionarrio_supervisor FOREIGN KEY (id_funcionario_supervisor)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
/***********************************F-DEP-RAC-ADQ-0-17/03/2014****************************************/

/***********************************I-DEP-JRR-ADQ-0-24/04/2014*****************************************/

select pxp.f_insert_testructura_gui ('ADQ.3.2', 'ADQ.3');
select pxp.f_insert_testructura_gui ('ADQ.3.3', 'ADQ.3');
select pxp.f_insert_testructura_gui ('ADQ.3.2.1', 'ADQ.3.2');
select pxp.f_insert_testructura_gui ('ADQ.3.3.1', 'ADQ.3.3');
select pxp.f_insert_testructura_gui ('ADQ.3.3.2', 'ADQ.3.3');
select pxp.f_insert_testructura_gui ('ADQ.3.3.3', 'ADQ.3.3');
select pxp.f_insert_testructura_gui ('ADQ.3.3.2.1', 'ADQ.3.3.2');
select pxp.f_insert_testructura_gui ('ADQ.3.3.3.1', 'ADQ.3.3.3');
select pxp.f_insert_testructura_gui ('VBSOL.2', 'VBSOL');
select pxp.f_insert_testructura_gui ('VBSOL.3', 'VBSOL');
select pxp.f_insert_testructura_gui ('VBSOL.2.1', 'VBSOL.2');
select pxp.f_insert_testructura_gui ('VBSOL.3.1', 'VBSOL.3');
select pxp.f_insert_testructura_gui ('VBSOL.3.2', 'VBSOL.3');
select pxp.f_insert_testructura_gui ('VBSOL.3.3', 'VBSOL.3');
select pxp.f_insert_testructura_gui ('VBSOL.3.2.1', 'VBSOL.3.2');
select pxp.f_insert_testructura_gui ('VBSOL.3.3.1', 'VBSOL.3.3');
select pxp.f_insert_testructura_gui ('ADQ.4.1', 'ADQ.4');
select pxp.f_insert_testructura_gui ('ADQ.4.2', 'ADQ.4');
select pxp.f_insert_testructura_gui ('ADQ.4.1.1', 'ADQ.4.1');
select pxp.f_insert_testructura_gui ('ADQ.4.2.1', 'ADQ.4.2');
select pxp.f_insert_testructura_gui ('PROC.3', 'PROC');
select pxp.f_insert_testructura_gui ('PROC.4', 'PROC');
select pxp.f_insert_testructura_gui ('PROC.3.1', 'PROC.3');
select pxp.f_insert_testructura_gui ('PROC.4.1', 'PROC.4');
select pxp.f_insert_testructura_gui ('PROC.4.2', 'PROC.4');
select pxp.f_insert_testructura_gui ('PROC.4.3', 'PROC.4');
select pxp.f_insert_testructura_gui ('VBCOT.1', 'VBCOT');
select pxp.f_insert_testructura_gui ('VBCOT.2', 'VBCOT');
select pxp.f_insert_testructura_gui ('VBCOT.3', 'VBCOT');
select pxp.f_insert_testructura_gui ('VBCOT.1.1', 'VBCOT.1');
select pxp.f_insert_testructura_gui ('VBCOT.1.2', 'VBCOT.1');
select pxp.f_insert_testructura_gui ('VBCOT.1.2.1', 'VBCOT.1.2');
select pxp.f_insert_testructura_gui ('VBCOT.1.2.2', 'VBCOT.1.2');
select pxp.f_insert_testructura_gui ('VBCOT.1.2.3', 'VBCOT.1.2');
select pxp.f_insert_testructura_gui ('VBCOT.1.2.2.1', 'VBCOT.1.2.2');
select pxp.f_insert_testructura_gui ('VBCOT.1.2.3.1', 'VBCOT.1.2.3');
select pxp.f_insert_testructura_gui ('VBCOT.2.1', 'VBCOT.2');
select pxp.f_insert_testructura_gui ('GRUP.1', 'GRUP');
select pxp.f_insert_testructura_gui ('GRUP.2', 'GRUP');
select pxp.f_insert_testructura_gui ('GRUP.2.1', 'GRUP.2');
select pxp.f_insert_testructura_gui ('GRUP.2.1.1', 'GRUP.2.1');
select pxp.f_insert_testructura_gui ('GRUP.2.1.2', 'GRUP.2.1');
select pxp.f_insert_testructura_gui ('GRUP.2.1.3', 'GRUP.2.1');
select pxp.f_insert_testructura_gui ('GRUP.2.1.1.1', 'GRUP.2.1.1');
select pxp.f_insert_testructura_gui ('PRECOM.1', 'PRECOM');
select pxp.f_insert_testructura_gui ('VBPRE.1', 'VBPRE');
select pxp.f_insert_testructura_gui ('COPRE.1', 'COPRE');
select pxp.f_insert_testructura_gui ('COPRE.2', 'COPRE');
select pxp.f_insert_testructura_gui ('COPRE.3', 'COPRE');
select pxp.f_insert_testructura_gui ('COPRE.4', 'COPRE');
select pxp.f_insert_testructura_gui ('COPRE.5', 'COPRE');
select pxp.f_insert_testructura_gui ('COPRE.2.1', 'COPRE.2');
select pxp.f_insert_testructura_gui ('COPRE.4.1', 'COPRE.4');
select pxp.f_insert_testructura_gui ('COPRE.5.1', 'COPRE.5');
select pxp.f_insert_testructura_gui ('COPRE.5.2', 'COPRE.5');
select pxp.f_insert_testructura_gui ('COPRE.5.3', 'COPRE.5');
select pxp.f_insert_testructura_gui ('COPRE.5.2.1', 'COPRE.5.2');
select pxp.f_insert_testructura_gui ('COPRE.5.3.1', 'COPRE.5.3');
select pxp.f_insert_testructura_gui ('SOLPEN', 'ADQ');
select pxp.f_insert_testructura_gui ('SOLPEN.1', 'SOLPEN');
select pxp.f_insert_testructura_gui ('SOLPEN.2', 'SOLPEN');
select pxp.f_insert_testructura_gui ('SOLPEN.3', 'SOLPEN');
select pxp.f_insert_testructura_gui ('SOLPEN.2.1', 'SOLPEN.2');
select pxp.f_insert_testructura_gui ('SOLPEN.3.1', 'SOLPEN.3');
select pxp.f_insert_testructura_gui ('SOLPEN.3.2', 'SOLPEN.3');
select pxp.f_insert_testructura_gui ('SOLPEN.3.3', 'SOLPEN.3');
select pxp.f_insert_testructura_gui ('SOLPEN.3.2.1', 'SOLPEN.3.2');
select pxp.f_insert_testructura_gui ('SOLPEN.3.3.1', 'SOLPEN.3.3');
select pxp.f_insert_testructura_gui ('OBPAGOA', 'ADQ');
select pxp.f_insert_testructura_gui ('OBPAGOA.1', 'OBPAGOA');
select pxp.f_insert_testructura_gui ('OBPAGOA.2', 'OBPAGOA');
select pxp.f_insert_testructura_gui ('OBPAGOA.3', 'OBPAGOA');
select pxp.f_insert_testructura_gui ('OBPAGOA.4', 'OBPAGOA');
select pxp.f_insert_testructura_gui ('OBPAGOA.5', 'OBPAGOA');
select pxp.f_insert_testructura_gui ('OBPAGOA.6', 'OBPAGOA');
select pxp.f_insert_testructura_gui ('OBPAGOA.7', 'OBPAGOA');
select pxp.f_insert_testructura_gui ('OBPAGOA.8', 'OBPAGOA');
select pxp.f_insert_testructura_gui ('OBPAGOA.2.1', 'OBPAGOA.2');
select pxp.f_insert_testructura_gui ('OBPAGOA.2.2', 'OBPAGOA.2');
select pxp.f_insert_testructura_gui ('OBPAGOA.2.3', 'OBPAGOA.2');
select pxp.f_insert_testructura_gui ('OBPAGOA.2.3.1', 'OBPAGOA.2.3');
select pxp.f_insert_testructura_gui ('OBPAGOA.4.1', 'OBPAGOA.4');
select pxp.f_insert_testructura_gui ('OBPAGOA.4.2', 'OBPAGOA.4');
select pxp.f_insert_testructura_gui ('OBPAGOA.4.3', 'OBPAGOA.4');
select pxp.f_insert_testructura_gui ('OBPAGOA.7.1', 'OBPAGOA.7');
select pxp.f_insert_testructura_gui ('OBPAGOA.7.2', 'OBPAGOA.7');
select pxp.f_insert_testructura_gui ('OBPAGOA.7.3', 'OBPAGOA.7');
select pxp.f_insert_testructura_gui ('OBPAGOA.7.2.1', 'OBPAGOA.7.2');
select pxp.f_insert_testructura_gui ('OBPAGOA.7.3.1', 'OBPAGOA.7.3');
select pxp.f_insert_testructura_gui ('OBPAGOA.8.1', 'OBPAGOA.8');
select pxp.f_insert_testructura_gui ('OBPAGOA.8.2', 'OBPAGOA.8');
select pxp.f_insert_testructura_gui ('OBPAGOA.8.1.1', 'OBPAGOA.8.1');
select pxp.f_insert_testructura_gui ('ADQ.3.2.2', 'ADQ.3.2');
select pxp.f_insert_testructura_gui ('VBSOL.2.2', 'VBSOL.2');
select pxp.f_insert_testructura_gui ('PROC.3.2', 'PROC.3');
select pxp.f_insert_testructura_gui ('VBCOT.2.2', 'VBCOT.2');
select pxp.f_insert_testructura_gui ('COPRE.4.2', 'COPRE.4');
select pxp.f_insert_testructura_gui ('SOLPEN.2.2', 'SOLPEN.2');
select pxp.f_insert_testructura_gui ('OBPAGOA.2.3.2', 'OBPAGOA.2.3');
select pxp.f_insert_testructura_gui ('ADQ.3.3.3.1.1', 'ADQ.3.3.3.1');
select pxp.f_insert_testructura_gui ('VBSOL.3.3.1.1', 'VBSOL.3.3.1');
select pxp.f_insert_testructura_gui ('ADQ.4.2.1.1', 'ADQ.4.2.1');
select pxp.f_insert_testructura_gui ('PROC.4.2.1', 'PROC.4.2');
select pxp.f_insert_testructura_gui ('PROC.4.2.2', 'PROC.4.2');
select pxp.f_insert_testructura_gui ('COPRE.5.3.1.1', 'COPRE.5.3.1');
select pxp.f_insert_testructura_gui ('SOLPEN.3.3.1.1', 'SOLPEN.3.3.1');
select pxp.f_insert_testructura_gui ('OBPAGOA.4.3.1', 'OBPAGOA.4.3');
select pxp.f_insert_testructura_gui ('OBPAGOA.4.3.2', 'OBPAGOA.4.3');
select pxp.f_insert_testructura_gui ('OBPAGOA.5.1', 'OBPAGOA.5');
select pxp.f_insert_testructura_gui ('OBPAGOA.5.2', 'OBPAGOA.5');
select pxp.f_insert_testructura_gui ('OBPAGOA.7.3.1.1', 'OBPAGOA.7.3.1');
select pxp.f_insert_testructura_gui ('OBPAGOA.8.1.1.1', 'OBPAGOA.8.1.1');
select pxp.f_insert_testructura_gui ('OBPAGOA.8.1.1.1.1', 'OBPAGOA.8.1.1.1');
select pxp.f_insert_testructura_gui ('OBPAGOA.8.2.1', 'OBPAGOA.8.2');
select pxp.f_insert_testructura_gui ('ADQ.3.4', 'ADQ.3');
select pxp.f_insert_testructura_gui ('VBSOL.4', 'VBSOL');
select pxp.f_insert_testructura_gui ('COPRE.6', 'COPRE');
select pxp.f_insert_testructura_gui ('SOLPEN.4', 'SOLPEN');
select pxp.f_insert_tprocedimiento_gui ('WF_PROMAC_SEL', 'ADQ.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CATCOMP_INS', 'ADQ.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CATCOMP_MOD', 'ADQ.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CATCOMP_ELI', 'ADQ.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CATCOMP_SEL', 'ADQ.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_INS', 'ADQ.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_MOD', 'ADQ.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_ELI', 'ADQ.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_SEL', 'ADQ.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOLAR_SEL', 'ADQ.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_OBTARPOBA_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_FINSOL_IME', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GETGES_ELI', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_GATNREP_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILUSU_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CATCOMP_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_INS', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_MOD', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_ELI', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_UO_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_INIUOARB_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_SEL', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPP_SEL', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_ODT_SEL', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_INS', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_MOD', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_ELI', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'ADQ.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'ADQ.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'ADQ.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'ADQ.3.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'ADQ.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'ADQ.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'ADQ.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'ADQ.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_INS', 'ADQ.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_MOD', 'ADQ.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_ELI', 'ADQ.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_SEL', 'ADQ.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'ADQ.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'ADQ.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'ADQ.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'ADQ.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_SEL', 'ADQ.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'ADQ.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'ADQ.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'ADQ.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_INS', 'ADQ.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_MOD', 'ADQ.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_ELI', 'ADQ.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_SEL', 'ADQ.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'ADQ.3.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'ADQ.3.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'ADQ.3.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'ADQ.3.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'ADQ.3.3.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'ADQ.3.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'ADQ.3.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'ADQ.3.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'ADQ.3.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'ADQ.3.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'ADQ.3.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'ADQ.3.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'ADQ.3.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'ADQ.3.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'ADQ.3.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SIGESOL_IME', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_ANTESOL_IME', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_GATNREP_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILUSU_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CATCOMP_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_INS', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_MOD', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_ELI', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_UO_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_INIUOARB_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_SEL', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPP_SEL', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_ODT_SEL', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_INS', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_MOD', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_ELI', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'VBSOL.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'VBSOL.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'VBSOL.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'VBSOL.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'VBSOL.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'VBSOL.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'VBSOL.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'VBSOL.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_INS', 'VBSOL.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_MOD', 'VBSOL.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_ELI', 'VBSOL.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_SEL', 'VBSOL.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'VBSOL.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'VBSOL.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBSOL.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'VBSOL.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_SEL', 'VBSOL.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'VBSOL.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'VBSOL.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'VBSOL.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_INS', 'VBSOL.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_MOD', 'VBSOL.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_ELI', 'VBSOL.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_SEL', 'VBSOL.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'VBSOL.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'VBSOL.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'VBSOL.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBSOL.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'VBSOL.3.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'VBSOL.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'VBSOL.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'VBSOL.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'VBSOL.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'VBSOL.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBSOL.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'VBSOL.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'VBSOL.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'VBSOL.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBSOL.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'ADQ.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'ADQ.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROVEE_INS', 'ADQ.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROVEE_MOD', 'ADQ.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROVEE_ELI', 'ADQ.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROVEE_SEL', 'ADQ.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'ADQ.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'ADQ.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'ADQ.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'ADQ.4.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'ADQ.4.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'ADQ.4.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'ADQ.4.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'ADQ.4.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'ADQ.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'ADQ.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'ADQ.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'ADQ.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'ADQ.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'ADQ.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'ADQ.4.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'ADQ.4.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'ADQ.4.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'ADQ.4.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_GATNREP_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROC_INS', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROC_MOD', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROC_ELI', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROC_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROCSOL_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROCPED_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_REVPRE_IME', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_FINPRO_IME', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTPROC_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTRPC_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'PROC.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'PROC.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'PROC.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'PROC.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_OBEPUO_IME', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILEPUO_SEL', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_OBTTCB_GET', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_FINREGC_IME', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SIGECOT_IME', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_ADJTODO_IME', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_HABPAG_IME', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PREING_GEN', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTREP_SEL', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_INS', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_MOD', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_ELI', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_SEL', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTPROC_SEL', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTRPC_SEL', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTOC_REP', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_ANTEST_IME', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLCON_IME', 'PROC.4.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTOC_REP', 'PROC.4.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'PROC.4.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'PROC.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'PROC.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'PROC.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_TOTALADJ_IME', 'PROC.4.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_ADJDET_IME', 'PROC.4.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'PROC.4.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_INS', 'PROC.4.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_MOD', 'PROC.4.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_ELI', 'PROC.4.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'PROC.4.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_SEL', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPP_SEL', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_ODT_SEL', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_INS', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_MOD', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_ELI', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTRPC_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GENOC_IME', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROCPED_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTPROC_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_INS', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_MOD', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_ELI', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTOC_REP', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTREP_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_ANTEST_IME', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_SEL', 'VBCOT.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOLAR_SEL', 'VBCOT.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_INS', 'VBCOT.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_MOD', 'VBCOT.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_ELI', 'VBCOT.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'VBCOT.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOLAR_MOD', 'VBCOT.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'VBCOT.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'VBCOT.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'VBCOT.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'VBCOT.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_INS', 'VBCOT.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_MOD', 'VBCOT.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_ELI', 'VBCOT.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_SEL', 'VBCOT.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'VBCOT.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'VBCOT.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBCOT.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'VBCOT.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_SEL', 'VBCOT.1.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'VBCOT.1.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'VBCOT.1.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'VBCOT.1.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_INS', 'VBCOT.1.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_MOD', 'VBCOT.1.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_ELI', 'VBCOT.1.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_SEL', 'VBCOT.1.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'VBCOT.1.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'VBCOT.1.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'VBCOT.1.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBCOT.1.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'VBCOT.1.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'VBCOT.1.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'VBCOT.1.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'VBCOT.1.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'VBCOT.1.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'VBCOT.1.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBCOT.1.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'VBCOT.1.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'VBCOT.1.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'VBCOT.1.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBCOT.1.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'VBCOT.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'VBCOT.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'VBCOT.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'VBCOT.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_TOTALADJ_IME', 'VBCOT.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_ADJDET_IME', 'VBCOT.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'VBCOT.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_INS', 'VBCOT.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_MOD', 'VBCOT.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_ELI', 'VBCOT.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'VBCOT.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRU_INS', 'GRUP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRU_MOD', 'GRUP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRU_ELI', 'GRUP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRU_SEL', 'GRUP', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_SEL', 'GRUP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRPA_INS', 'GRUP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRPA_MOD', 'GRUP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRPA_ELI', 'GRUP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRPA_SEL', 'GRUP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUARI_SEL', 'GRUP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRUS_INS', 'GRUP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRUS_MOD', 'GRUP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRUS_ELI', 'GRUP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRUS_SEL', 'GRUP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'GRUP.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'GRUP.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_CLASIF_SEL', 'GRUP.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_ROL_SEL', 'GRUP.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUARI_INS', 'GRUP.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUARI_MOD', 'GRUP.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUARI_ELI', 'GRUP.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUARI_SEL', 'GRUP.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'GRUP.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'GRUP.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'GRUP.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'GRUP.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'GRUP.2.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_ROL_SEL', 'GRUP.2.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUROL_INS', 'GRUP.2.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUROL_MOD', 'GRUP.2.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUROL_ELI', 'GRUP.2.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUROL_SEL', 'GRUP.2.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GRU_SEL', 'GRUP.2.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SG_UEP_INS', 'GRUP.2.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SG_UEP_MOD', 'GRUP.2.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SG_UEP_ELI', 'GRUP.2.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SG_UEP_SEL', 'GRUP.2.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_FINPRES_IME', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GETGES_ELI', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILUSU_SEL', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRU_SEL', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRES_INS', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRES_MOD', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRES_ELI', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRES_SEL', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_RETPRES_IME', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRESREP_SEL', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_SEL', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_UO_SEL', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_INIUOARB_SEL', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'PRECOM.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPP_SEL', 'PRECOM.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_INS', 'PRECOM.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_MOD', 'PRECOM.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_ELI', 'PRECOM.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_SEL', 'PRECOM.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'PRECOM.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'PRECOM.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'PRECOM.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_APRPRES_IME', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILUSU_SEL', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRU_SEL', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRES_INS', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRES_MOD', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRES_ELI', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRES_SEL', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_RETPRES_IME', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRESREP_SEL', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_SEL', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_UO_SEL', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_INIUOARB_SEL', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'VBPRE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPP_SEL', 'VBPRE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_INS', 'VBPRE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_MOD', 'VBPRE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_ELI', 'VBPRE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_SEL', 'VBPRE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'VBPRE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'VBPRE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'VBPRE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_OBTARPOBA_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_FINSOL_IME', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GETGES_ELI', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_GATNREP_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILUSU_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CATCOMP_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_INS', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_MOD', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_ELI', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_UO_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_INIUOARB_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_APRPRES_IME', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILUSU_SEL', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRU_SEL', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRES_INS', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRES_MOD', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRES_ELI', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRES_SEL', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_RETPRES_IME', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRESREP_SEL', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_SEL', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_UO_SEL', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_INIUOARB_SEL', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CONSOL_IME', 'COPRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'COPRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPP_SEL', 'COPRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_INS', 'COPRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_MOD', 'COPRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_ELI', 'COPRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_SEL', 'COPRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'COPRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'COPRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'COPRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_SEL', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPP_SEL', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_ODT_SEL', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_INS', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_MOD', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_ELI', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'COPRE.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'COPRE.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'COPRE.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'COPRE.4.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'COPRE.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'COPRE.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'COPRE.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'COPRE.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_INS', 'COPRE.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_MOD', 'COPRE.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_ELI', 'COPRE.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_SEL', 'COPRE.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'COPRE.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'COPRE.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'COPRE.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'COPRE.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_SEL', 'COPRE.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'COPRE.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'COPRE.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'COPRE.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_INS', 'COPRE.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_MOD', 'COPRE.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_ELI', 'COPRE.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_SEL', 'COPRE.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'COPRE.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'COPRE.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'COPRE.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'COPRE.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'COPRE.5.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'COPRE.5.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'COPRE.5.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'COPRE.5.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'COPRE.5.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'COPRE.5.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'COPRE.5.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'COPRE.5.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'COPRE.5.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'COPRE.5.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'COPRE.5.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSU_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SIGESOL_IME', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROC_INS', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROC_MOD', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_ASIGPROC_IME', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_ANTESOL_IME', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_GATNREP_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILUSU_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CATCOMP_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_INS', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_MOD', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_ELI', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_UO_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_INIUOARB_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_SEL', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPP_SEL', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_ODT_SEL', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_INS', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_MOD', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_ELI', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'SOLPEN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'SOLPEN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'SOLPEN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'SOLPEN.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'SOLPEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'SOLPEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'SOLPEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'SOLPEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_INS', 'SOLPEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_MOD', 'SOLPEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_ELI', 'SOLPEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_SEL', 'SOLPEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'SOLPEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'SOLPEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'SOLPEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'SOLPEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_SEL', 'SOLPEN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'SOLPEN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'SOLPEN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'SOLPEN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_INS', 'SOLPEN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_MOD', 'SOLPEN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_ELI', 'SOLPEN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_SEL', 'SOLPEN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'SOLPEN.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'SOLPEN.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'SOLPEN.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'SOLPEN.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'SOLPEN.3.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'SOLPEN.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'SOLPEN.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'SOLPEN.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'SOLPEN.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'SOLPEN.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'SOLPEN.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'SOLPEN.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'SOLPEN.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'SOLPEN.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'SOLPEN.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_GATNREP_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_INS', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_MOD', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_ELI', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPGSEL_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAOB_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_OBTTCB_GET', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_FINREG_IME', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_ANTEOB_IME', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_IDSEXT_GET', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTOC_REP', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTREP_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROCPED_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTPROC_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTRPC_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPP_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_ARB_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_ARB_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_AUXCTA_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_INS', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_MOD', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_ELI', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAREP_SEL', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PAFPP_IME', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_GETDEC_IME', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_SEL', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_SEL', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAPA_INS', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_INS', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_MOD', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_ELI', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_SEL', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SINPRE_IME', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SIGEPP_IME', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_ANTEPP_IME', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_SEL', 'OBPAGOA.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_MOD', 'OBPAGOA.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'OBPAGOA.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'OBPAGOA.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'OBPAGOA.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'OBPAGOA.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'OBPAGOA.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPGSEL_SEL', 'OBPAGOA.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_SEL', 'OBPAGOA.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_COMEJEPAG_SEL', 'OBPAGOA.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'OBPAGOA.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PAFPP_IME', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_GETDEC_IME', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_SEL', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_SEL', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAPA_INS', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_INS', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_MOD', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_ELI', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_SEL', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SINPRE_IME', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SIGEPP_IME', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_ANTEPP_IME', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAREP_SEL', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_SEL', 'OBPAGOA.4.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_MOD', 'OBPAGOA.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'OBPAGOA.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'OBPAGOA.4.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'OBPAGOA.4.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'OBPAGOA.4.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'OBPAGOA.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'OBPAGOA.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'OBPAGOA.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_SEL', 'OBPAGOA.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'OBPAGOA.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'OBPAGOA.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'OBPAGOA.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'OBPAGOA.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_INS', 'OBPAGOA.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_MOD', 'OBPAGOA.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_ELI', 'OBPAGOA.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_SEL', 'OBPAGOA.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'OBPAGOA.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'OBPAGOA.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPAGOA.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'OBPAGOA.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_SEL', 'OBPAGOA.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'OBPAGOA.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'OBPAGOA.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'OBPAGOA.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_INS', 'OBPAGOA.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_MOD', 'OBPAGOA.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_ELI', 'OBPAGOA.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_SEL', 'OBPAGOA.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'OBPAGOA.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'OBPAGOA.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'OBPAGOA.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPAGOA.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'OBPAGOA.7.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'OBPAGOA.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'OBPAGOA.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'OBPAGOA.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'OBPAGOA.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'OBPAGOA.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPAGOA.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'OBPAGOA.7.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'OBPAGOA.7.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'OBPAGOA.7.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPAGOA.7.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_INS', 'OBPAGOA.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_MOD', 'OBPAGOA.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_ELI', 'OBPAGOA.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_SEL', 'OBPAGOA.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'OBPAGOA.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'OBPAGOA.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPAGOA.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_INS', 'OBPAGOA.8.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_MOD', 'OBPAGOA.8.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_ELI', 'OBPAGOA.8.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_SEL', 'OBPAGOA.8.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'OBPAGOA.8.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'OBPAGOA.8.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'OBPAGOA.8.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'OBPAGOA.8.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'OBPAGOA.8.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'OBPAGOA.8.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPAGOA.8.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'OBPAGOA.8.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'OBPAGOA.8.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'OBPAGOA.8.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPAGOA.8.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CABMOM_IME', 'ADQ.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPPROC_SEL', 'ADQ.3.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'ADQ.3.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_INS', 'ADQ.3.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_MOD', 'ADQ.3.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_ELI', 'ADQ.3.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_SEL', 'ADQ.3.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CABMOM_IME', 'VBSOL.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPPROC_SEL', 'VBSOL.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'VBSOL.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_INS', 'VBSOL.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_MOD', 'VBSOL.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_ELI', 'VBSOL.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_SEL', 'VBSOL.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CABMOM_IME', 'PROC.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPPROC_SEL', 'PROC.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'PROC.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_INS', 'PROC.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_MOD', 'PROC.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_ELI', 'PROC.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_SEL', 'PROC.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CABMOM_IME', 'PROC.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_GATNREP_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SIGECOT_IME', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CABMOM_IME', 'VBCOT.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPPROC_SEL', 'VBCOT.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'VBCOT.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_INS', 'VBCOT.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_MOD', 'VBCOT.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_ELI', 'VBCOT.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_SEL', 'VBCOT.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CABMOM_IME', 'COPRE.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPPROC_SEL', 'COPRE.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'COPRE.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_INS', 'COPRE.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_MOD', 'COPRE.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_ELI', 'COPRE.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_SEL', 'COPRE.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CABMOM_IME', 'SOLPEN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPPROC_SEL', 'SOLPEN.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'SOLPEN.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_INS', 'SOLPEN.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_MOD', 'SOLPEN.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_ELI', 'SOLPEN.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_SEL', 'SOLPEN.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CABMOM_IME', 'OBPAGOA.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPPROC_SEL', 'OBPAGOA.2.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'OBPAGOA.2.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_INS', 'OBPAGOA.2.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_MOD', 'OBPAGOA.2.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_ELI', 'OBPAGOA.2.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_SEL', 'OBPAGOA.2.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CABMOM_IME', 'OBPAGOA.4.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CABMOM_IME', 'OBPAGOA.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_MAILFUN_GET', 'PROC.4.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'ADQ.3.3.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'VBSOL.3.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'ADQ.4.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'PROC.4.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPPROC_SEL', 'PROC.4.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'PROC.4.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_INS', 'PROC.4.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_MOD', 'PROC.4.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_ELI', 'PROC.4.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_SEL', 'PROC.4.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'COPRE.5.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'SOLPEN.3.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'OBPAGOA.4.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPPROC_SEL', 'OBPAGOA.4.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'OBPAGOA.4.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_INS', 'OBPAGOA.4.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_MOD', 'OBPAGOA.4.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_ELI', 'OBPAGOA.4.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_SEL', 'OBPAGOA.4.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'OBPAGOA.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPPROC_SEL', 'OBPAGOA.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'OBPAGOA.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_INS', 'OBPAGOA.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_MOD', 'OBPAGOA.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_ELI', 'OBPAGOA.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_SEL', 'OBPAGOA.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'OBPAGOA.7.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'OBPAGOA.8.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'OBPAGOA.8.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'OBPAGOA.8.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPAGOA.8.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'OBPAGOA.8.1.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'OBPAGOA.8.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_LISTUSU_SEG', 'GRUP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_LISTUSU_SEG', 'GRUP.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'ADQ.3.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'ADQ.3.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'ADQ.3.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'ADQ.3.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_MAILFUN_GET', 'ADQ.3.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'VBSOL.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'VBSOL.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'VBSOL.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'VBSOL.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_MAILFUN_GET', 'VBSOL.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'COPRE.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'COPRE.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'COPRE.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'COPRE.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_MAILFUN_GET', 'COPRE.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'SOLPEN.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'SOLPEN.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'SOLPEN.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'SOLPEN.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_MAILFUN_GET', 'SOLPEN.4', 'no');
select pxp.f_insert_tgui_rol ('VBSOL', 'ADQ - Visto Bueno Sol');
select pxp.f_insert_tgui_rol ('ADQ', 'ADQ - Visto Bueno Sol');
select pxp.f_insert_tgui_rol ('SISTEMA', 'ADQ - Visto Bueno Sol');
select pxp.f_insert_tgui_rol ('VBSOL.3', 'ADQ - Visto Bueno Sol');
select pxp.f_insert_tgui_rol ('VBSOL.3.3', 'ADQ - Visto Bueno Sol');
select pxp.f_insert_tgui_rol ('VBSOL.3.3.1', 'ADQ - Visto Bueno Sol');
select pxp.f_insert_tgui_rol ('VBSOL.3.2', 'ADQ - Visto Bueno Sol');
select pxp.f_insert_tgui_rol ('VBSOL.3.2.1', 'ADQ - Visto Bueno Sol');
select pxp.f_insert_tgui_rol ('VBSOL.3.1', 'ADQ - Visto Bueno Sol');
select pxp.f_insert_tgui_rol ('VBSOL.2', 'ADQ - Visto Bueno Sol');
select pxp.f_insert_tgui_rol ('VBSOL.1', 'ADQ - Visto Bueno Sol');
select pxp.f_insert_tgui_rol ('VBCOT', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('ADQ', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('SISTEMA', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('VBCOT.3', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('VBCOT.2', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('VBCOT.1', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('VBCOT.1.2', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('VBCOT.1.2.3', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('VBCOT.1.2.3.1', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('VBCOT.1.2.2', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('VBCOT.1.2.2.1', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('VBCOT.1.2.1', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('VBCOT.1.1', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('VBPRE', 'ADQ - VioBo Presolicitud');
select pxp.f_insert_tgui_rol ('ADQ', 'ADQ - VioBo Presolicitud');
select pxp.f_insert_tgui_rol ('SISTEMA', 'ADQ - VioBo Presolicitud');
select pxp.f_insert_tgui_rol ('VBPRE.1', 'ADQ - VioBo Presolicitud');
select pxp.f_insert_tgui_rol ('ADQ.3', 'ADQ - Solicitud de Compra');
select pxp.f_insert_tgui_rol ('ADQ', 'ADQ - Solicitud de Compra');
select pxp.f_insert_tgui_rol ('SISTEMA', 'ADQ - Solicitud de Compra');
select pxp.f_insert_tgui_rol ('ADQ.3.3', 'ADQ - Solicitud de Compra');
select pxp.f_insert_tgui_rol ('ADQ.3.3.3', 'ADQ - Solicitud de Compra');
select pxp.f_insert_tgui_rol ('ADQ.3.3.3.1', 'ADQ - Solicitud de Compra');
select pxp.f_insert_tgui_rol ('ADQ.3.3.2', 'ADQ - Solicitud de Compra');
select pxp.f_insert_tgui_rol ('ADQ.3.3.2.1', 'ADQ - Solicitud de Compra');
select pxp.f_insert_tgui_rol ('ADQ.3.3.1', 'ADQ - Solicitud de Compra');
select pxp.f_insert_tgui_rol ('ADQ.3.2', 'ADQ - Solicitud de Compra');
select pxp.f_insert_tgui_rol ('ADQ.3.2.1', 'ADQ - Solicitud de Compra');
select pxp.f_insert_tgui_rol ('ADQ.3.1', 'ADQ - Solicitud de Compra');
select pxp.f_insert_tgui_rol ('PROC', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('ADQ', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('SISTEMA', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('PROC.4', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('PROC.4.3', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('PROC.4.2', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('PROC.4.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('PROC.3', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('PROC.3.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('PROC.2', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('PROC.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('PROC.1.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('SOLPEN', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('SOLPEN.3', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('SOLPEN.3.3', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('SOLPEN.3.3.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('SOLPEN.3.2', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('SOLPEN.3.2.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('SOLPEN.3.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('SOLPEN.2', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('SOLPEN.2.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('SOLPEN.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('ADQ.4', 'ADQ - Registro Proveedores');
select pxp.f_insert_tgui_rol ('ADQ', 'ADQ - Registro Proveedores');
select pxp.f_insert_tgui_rol ('SISTEMA', 'ADQ - Registro Proveedores');
select pxp.f_insert_tgui_rol ('ADQ.4.2', 'ADQ - Registro Proveedores');
select pxp.f_insert_tgui_rol ('ADQ.4.2.1', 'ADQ - Registro Proveedores');
select pxp.f_insert_tgui_rol ('ADQ.4.1', 'ADQ - Registro Proveedores');
select pxp.f_insert_tgui_rol ('ADQ.4.1.1', 'ADQ - Registro Proveedores');
select pxp.f_insert_tgui_rol ('PRECOM', 'ADQ - Presolicitud de Compra');
select pxp.f_insert_tgui_rol ('ADQ', 'ADQ - Presolicitud de Compra');
select pxp.f_insert_tgui_rol ('SISTEMA', 'ADQ - Presolicitud de Compra');
select pxp.f_insert_tgui_rol ('PRECOM.1', 'ADQ - Presolicitud de Compra');
select pxp.f_insert_tgui_rol ('COPRE', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('ADQ', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('SISTEMA', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('COPRE.5', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('COPRE.5.3', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('COPRE.5.3.1', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('COPRE.5.2', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('COPRE.5.2.1', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('COPRE.5.1', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('COPRE.4', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('COPRE.4.1', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('COPRE.3', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('COPRE.2', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('COPRE.2.1', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('COPRE.1', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('PROC', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('ADQ', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('SISTEMA', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('PROC.4', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('PROC.4.3', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('PROC.4.2', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('PROC.4.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('PROC.3', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('PROC.3.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('PROC.2', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('PROC.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('PROC.1.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.8', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.8.2', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.8.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.8.1.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.7', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.7.3', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.7.3.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.7.2', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.7.2.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.7.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.6', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.5', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.4', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.4.3', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.4.2', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.4.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.3', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.2', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.2.3', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.2.3.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.2.2', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.2.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.8', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.8.2', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.8.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.8.1.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.7', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.7.3', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.7.3.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.7.2', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.7.2.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.7.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.6', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.5', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.4', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.4.3', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.4.2', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.4.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.3', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.2', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.2.3', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.2.3.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.2.2', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.2.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('ADQ.3.2.2', 'ADQ - Solicitud de Compra');
select pxp.f_insert_tgui_rol ('VBSOL.2.2', 'ADQ - Visto Bueno Sol');
select pxp.f_insert_tgui_rol ('PROC.3.2', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('PROC.3.2', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('VBCOT.2.2', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('ADQ.3.4', 'ADQ - Solicitud de Compra');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_TIPES_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_FUNTIPES_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SIGESOL_IME', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_ANTESOL_IME', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_GATNREP_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_DEPFILUSU_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_CATCOMP_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SOL_INS', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SOL_MOD', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SOL_ELI', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SOL_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SOLREP_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SOLD_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SOLDETCOT_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PRE_VERPRE_IME', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_MONEDA_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_DEPUSUCOMB_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'RH_FUNCIOCAR_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'RH_UO_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'RH_INIUOARB_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_PROVEEV_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_SERVIC_SEL', 'VBSOL.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SAL_ITEMNOTBASE_SEL', 'VBSOL.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_LUG_SEL', 'VBSOL.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_LUG_ARB_SEL', 'VBSOL.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_PROVEE_INS', 'VBSOL.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_PROVEE_MOD', 'VBSOL.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_PROVEE_ELI', 'VBSOL.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_PROVEE_SEL', 'VBSOL.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_PROVEEV_SEL', 'VBSOL.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_PERSON_SEL', 'VBSOL.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_PERSONMIN_SEL', 'VBSOL.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_INSTIT_SEL', 'VBSOL.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_INSTIT_INS', 'VBSOL.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_INSTIT_MOD', 'VBSOL.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_INSTIT_ELI', 'VBSOL.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_INSTIT_SEL', 'VBSOL.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_PERSON_SEL', 'VBSOL.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_PERSONMIN_SEL', 'VBSOL.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_PERSON_INS', 'VBSOL.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_PERSON_MOD', 'VBSOL.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_PERSON_ELI', 'VBSOL.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_PERSONMIN_SEL', 'VBSOL.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_PERSON_INS', 'VBSOL.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_PERSON_MOD', 'VBSOL.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_PERSON_ELI', 'VBSOL.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_PERSONMIN_SEL', 'VBSOL.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_UPFOTOPER_MOD', 'VBSOL.3.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SAL_ITEM_SEL', 'VBSOL.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SAL_ITEMNOTBASE_SEL', 'VBSOL.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SAL_ITMALM_SEL', 'VBSOL.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_SERVIC_SEL', 'VBSOL.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_PRITSE_INS', 'VBSOL.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_PRITSE_MOD', 'VBSOL.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_PRITSE_ELI', 'VBSOL.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_PRITSE_SEL', 'VBSOL.3.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_DWF_MOD', 'VBSOL.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_DWF_ELI', 'VBSOL.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_DWF_SEL', 'VBSOL.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_DOCWFAR_MOD', 'VBSOL.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_CCFILDEP_SEL', 'VBSOL.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_CONIG_SEL', 'VBSOL.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_CONIGPP_SEL', 'VBSOL.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'CONTA_ODT_SEL', 'VBSOL.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SOLD_INS', 'VBSOL.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SOLD_MOD', 'VBSOL.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SOLD_ELI', 'VBSOL.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SOLD_SEL', 'VBSOL.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SOLDETCOT_SEL', 'VBSOL.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_CEC_SEL', 'VBSOL.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_CECCOM_SEL', 'VBSOL.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_CECCOMFU_SEL', 'VBSOL.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_COTRPC_SEL', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_GENOC_IME', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_PROCPED_SEL', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_SOLD_SEL', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_SOLDETCOT_SEL', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_COT_SEL', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_COTPROC_SEL', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_CTD_SEL', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_PROVEEV_SEL', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_COT_INS', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_COT_MOD', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_COT_ELI', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_COTOC_REP', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_COTREP_SEL', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_ANTEST_IME', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_MONEDA_SEL', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_TOTALADJ_IME', 'VBCOT.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_ADJDET_IME', 'VBCOT.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_SOLDETCOT_SEL', 'VBCOT.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_CTD_INS', 'VBCOT.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_CTD_MOD', 'VBCOT.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_CTD_ELI', 'VBCOT.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_CTD_SEL', 'VBCOT.3');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'WF_DWF_MOD', 'VBCOT.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'WF_DWF_ELI', 'VBCOT.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'WF_DWF_SEL', 'VBCOT.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'WF_DOCWFAR_MOD', 'VBCOT.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_DOCSOL_SEL', 'VBCOT.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_DOCSOLAR_SEL', 'VBCOT.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_DOCSOL_INS', 'VBCOT.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_DOCSOL_MOD', 'VBCOT.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_DOCSOL_ELI', 'VBCOT.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_PROVEEV_SEL', 'VBCOT.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_SERVIC_SEL', 'VBCOT.1.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SAL_ITEMNOTBASE_SEL', 'VBCOT.1.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_LUG_SEL', 'VBCOT.1.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_LUG_ARB_SEL', 'VBCOT.1.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_PROVEE_INS', 'VBCOT.1.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_PROVEE_MOD', 'VBCOT.1.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_PROVEE_ELI', 'VBCOT.1.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_PROVEE_SEL', 'VBCOT.1.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_PROVEEV_SEL', 'VBCOT.1.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_PERSON_SEL', 'VBCOT.1.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_PERSONMIN_SEL', 'VBCOT.1.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_INSTIT_SEL', 'VBCOT.1.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_INSTIT_INS', 'VBCOT.1.2.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_INSTIT_MOD', 'VBCOT.1.2.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_INSTIT_ELI', 'VBCOT.1.2.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_INSTIT_SEL', 'VBCOT.1.2.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_PERSON_SEL', 'VBCOT.1.2.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_PERSONMIN_SEL', 'VBCOT.1.2.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_PERSON_INS', 'VBCOT.1.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_PERSON_MOD', 'VBCOT.1.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_PERSON_ELI', 'VBCOT.1.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_PERSONMIN_SEL', 'VBCOT.1.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_PERSON_INS', 'VBCOT.1.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_PERSON_MOD', 'VBCOT.1.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_PERSON_ELI', 'VBCOT.1.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_PERSONMIN_SEL', 'VBCOT.1.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_UPFOTOPER_MOD', 'VBCOT.1.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SAL_ITEM_SEL', 'VBCOT.1.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SAL_ITEMNOTBASE_SEL', 'VBCOT.1.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SAL_ITMALM_SEL', 'VBCOT.1.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_SERVIC_SEL', 'VBCOT.1.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_PRITSE_INS', 'VBCOT.1.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_PRITSE_MOD', 'VBCOT.1.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_PRITSE_ELI', 'VBCOT.1.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_PRITSE_SEL', 'VBCOT.1.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_DOCSOLAR_MOD', 'VBCOT.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_APRPRES_IME', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'PM_DEPFILUSU_SEL', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_GRU_SEL', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_PRES_INS', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_PRES_MOD', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_PRES_ELI', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_PRES_SEL', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_RETPRES_IME', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_PRESREP_SEL', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_PRED_SEL', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'PM_DEPUSUCOMB_SEL', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'RH_FUNCIOCAR_SEL', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'RH_UO_SEL', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'RH_INIUOARB_SEL', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'PM_CCFILDEP_SEL', 'VBPRE.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'PM_CONIGPP_SEL', 'VBPRE.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_PRED_INS', 'VBPRE.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_PRED_MOD', 'VBPRE.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_PRED_ELI', 'VBPRE.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_PRED_SEL', 'VBPRE.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'PM_CEC_SEL', 'VBPRE.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'PM_CECCOM_SEL', 'VBPRE.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'PM_CECCOMFU_SEL', 'VBPRE.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_OBTARPOBA_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_FINSOL_IME', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_GETGES_ELI', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_GATNREP_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_DEPFILUSU_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_CATCOMP_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOL_INS', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOL_MOD', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOL_ELI', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOL_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOLREP_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOLD_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOLDETCOT_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PRE_VERPRE_IME', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_MONEDA_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_DEPUSUCOMB_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'RH_FUNCIOCAR_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'RH_UO_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'RH_INIUOARB_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PROVEEV_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_SERVIC_SEL', 'ADQ.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SAL_ITEMNOTBASE_SEL', 'ADQ.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_LUG_SEL', 'ADQ.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_LUG_ARB_SEL', 'ADQ.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PROVEE_INS', 'ADQ.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PROVEE_MOD', 'ADQ.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PROVEE_ELI', 'ADQ.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PROVEE_SEL', 'ADQ.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PROVEEV_SEL', 'ADQ.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSON_SEL', 'ADQ.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSONMIN_SEL', 'ADQ.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_INSTIT_SEL', 'ADQ.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_INSTIT_INS', 'ADQ.3.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_INSTIT_MOD', 'ADQ.3.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_INSTIT_ELI', 'ADQ.3.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_INSTIT_SEL', 'ADQ.3.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSON_SEL', 'ADQ.3.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSONMIN_SEL', 'ADQ.3.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSON_INS', 'ADQ.3.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSON_MOD', 'ADQ.3.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSON_ELI', 'ADQ.3.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSONMIN_SEL', 'ADQ.3.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSON_INS', 'ADQ.3.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSON_MOD', 'ADQ.3.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSON_ELI', 'ADQ.3.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSONMIN_SEL', 'ADQ.3.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_UPFOTOPER_MOD', 'ADQ.3.3.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SAL_ITEM_SEL', 'ADQ.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SAL_ITEMNOTBASE_SEL', 'ADQ.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SAL_ITMALM_SEL', 'ADQ.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_SERVIC_SEL', 'ADQ.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PRITSE_INS', 'ADQ.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PRITSE_MOD', 'ADQ.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PRITSE_ELI', 'ADQ.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PRITSE_SEL', 'ADQ.3.3.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_DWF_MOD', 'ADQ.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_DWF_ELI', 'ADQ.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_DWF_SEL', 'ADQ.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_DOCWFAR_MOD', 'ADQ.3.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_CCFILDEP_SEL', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_CONIG_SEL', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_CONIGPP_SEL', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'CONTA_ODT_SEL', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOLD_INS', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOLD_MOD', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOLD_ELI', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOLD_SEL', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOLDETCOT_SEL', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_CEC_SEL', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_CECCOM_SEL', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_CECCOMFU_SEL', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_GATNREP_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOL_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_PROC_INS', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_PROC_MOD', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_PROC_ELI', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_PROC_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_PROCSOL_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_PROCPED_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_REVPRE_IME', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_FINPRO_IME', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLD_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLDETCOT_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COT_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COTPROC_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COTRPC_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_CTD_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_DEPUSUCOMB_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_OBEPUO_IME', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_DEPFILEPUO_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_OBTTCB_GET', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_FINREGC_IME', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SIGECOT_IME', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_ADJTODO_IME', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_HABPAG_IME', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_PREING_GEN', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COTREP_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_CTD_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEEV_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COT_INS', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COT_MOD', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COT_ELI', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COT_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COTPROC_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COTRPC_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COTOC_REP', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_ANTEST_IME', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_MONEDA_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_TOTALADJ_IME', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_ADJDET_IME', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLDETCOT_SEL', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_CTD_INS', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_CTD_MOD', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_CTD_ELI', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_CTD_SEL', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_MOD', 'PROC.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_ELI', 'PROC.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_SEL', 'PROC.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLCON_IME', 'PROC.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COTOC_REP', 'PROC.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_CTD_SEL', 'PROC.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_MOD', 'PROC.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_ELI', 'PROC.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_SEL', 'PROC.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DOCWFAR_MOD', 'PROC.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CCFILDEP_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CONIG_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CONIGPP_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'CONTA_ODT_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLD_INS', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLD_MOD', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLD_ELI', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLD_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLDETCOT_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CEC_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CECCOM_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CECCOMFU_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_TIPES_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_FUNTIPES_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_DEPUSU_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SIGESOL_IME', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_PROC_INS', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_PROC_MOD', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_ASIGPROC_IME', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_ANTESOL_IME', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_GATNREP_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_DEPFILUSU_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_CATCOMP_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOL_INS', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOL_MOD', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOL_ELI', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOL_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLREP_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLD_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLDETCOT_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PRE_VERPRE_IME', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_MONEDA_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_DEPUSUCOMB_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'RH_FUNCIOCAR_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'RH_UO_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'RH_INIUOARB_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEEV_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_SERVIC_SEL', 'SOLPEN.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SAL_ITEMNOTBASE_SEL', 'SOLPEN.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_LUG_SEL', 'SOLPEN.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_LUG_ARB_SEL', 'SOLPEN.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEE_INS', 'SOLPEN.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEE_MOD', 'SOLPEN.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEE_ELI', 'SOLPEN.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEE_SEL', 'SOLPEN.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEEV_SEL', 'SOLPEN.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_SEL', 'SOLPEN.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSONMIN_SEL', 'SOLPEN.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_SEL', 'SOLPEN.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_INS', 'SOLPEN.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_MOD', 'SOLPEN.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_ELI', 'SOLPEN.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_SEL', 'SOLPEN.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_SEL', 'SOLPEN.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSONMIN_SEL', 'SOLPEN.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_INS', 'SOLPEN.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_MOD', 'SOLPEN.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_ELI', 'SOLPEN.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSONMIN_SEL', 'SOLPEN.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_INS', 'SOLPEN.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_MOD', 'SOLPEN.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_ELI', 'SOLPEN.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSONMIN_SEL', 'SOLPEN.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_UPFOTOPER_MOD', 'SOLPEN.3.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SAL_ITEM_SEL', 'SOLPEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SAL_ITEMNOTBASE_SEL', 'SOLPEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SAL_ITMALM_SEL', 'SOLPEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_SERVIC_SEL', 'SOLPEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PRITSE_INS', 'SOLPEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PRITSE_MOD', 'SOLPEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PRITSE_ELI', 'SOLPEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PRITSE_SEL', 'SOLPEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_MOD', 'SOLPEN.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_ELI', 'SOLPEN.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_SEL', 'SOLPEN.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DOCWFAR_MOD', 'SOLPEN.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CCFILDEP_SEL', 'SOLPEN.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CONIG_SEL', 'SOLPEN.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CONIGPP_SEL', 'SOLPEN.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'CONTA_ODT_SEL', 'SOLPEN.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLD_INS', 'SOLPEN.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLD_MOD', 'SOLPEN.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLD_ELI', 'SOLPEN.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLD_SEL', 'SOLPEN.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLDETCOT_SEL', 'SOLPEN.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CEC_SEL', 'SOLPEN.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CECCOM_SEL', 'SOLPEN.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CECCOMFU_SEL', 'SOLPEN.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'PM_LUG_SEL', 'ADQ.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'PM_LUG_ARB_SEL', 'ADQ.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'ADQ_PROVEE_INS', 'ADQ.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'ADQ_PROVEE_MOD', 'ADQ.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'ADQ_PROVEE_ELI', 'ADQ.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'ADQ_PROVEE_SEL', 'ADQ.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_PERSON_SEL', 'ADQ.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_PERSONMIN_SEL', 'ADQ.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'PM_INSTIT_SEL', 'ADQ.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'PM_INSTIT_INS', 'ADQ.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'PM_INSTIT_MOD', 'ADQ.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'PM_INSTIT_ELI', 'ADQ.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'PM_INSTIT_SEL', 'ADQ.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_PERSON_SEL', 'ADQ.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_PERSONMIN_SEL', 'ADQ.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_PERSON_INS', 'ADQ.4.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_PERSON_MOD', 'ADQ.4.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_PERSON_ELI', 'ADQ.4.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_PERSONMIN_SEL', 'ADQ.4.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_PERSON_INS', 'ADQ.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_PERSON_MOD', 'ADQ.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_PERSON_ELI', 'ADQ.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_PERSONMIN_SEL', 'ADQ.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_UPFOTOPER_MOD', 'ADQ.4.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_FINPRES_IME', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'PM_GETGES_ELI', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'PM_DEPFILUSU_SEL', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_GRU_SEL', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_PRES_INS', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_PRES_MOD', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_PRES_ELI', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_PRES_SEL', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_RETPRES_IME', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_PRESREP_SEL', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_PRED_SEL', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'PM_DEPUSUCOMB_SEL', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'RH_FUNCIOCAR_SEL', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'RH_UO_SEL', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'RH_INIUOARB_SEL', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'PM_CCFILDEP_SEL', 'PRECOM.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'PM_CONIGPP_SEL', 'PRECOM.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_PRED_INS', 'PRECOM.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_PRED_MOD', 'PRECOM.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_PRED_ELI', 'PRECOM.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_PRED_SEL', 'PRECOM.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'PM_CEC_SEL', 'PRECOM.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'PM_CECCOM_SEL', 'PRECOM.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'PM_CECCOMFU_SEL', 'PRECOM.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_OBTARPOBA_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_FINSOL_IME', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_GETGES_ELI', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'WF_GATNREP_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_DEPFILUSU_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_CATCOMP_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_SOL_INS', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_SOL_MOD', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_SOL_ELI', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_SOL_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_SOLREP_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_SOLD_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_SOLDETCOT_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PRE_VERPRE_IME', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_MONEDA_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_DEPUSUCOMB_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'RH_FUNCIOCAR_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'RH_UO_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'RH_INIUOARB_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_PROVEEV_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_SERVIC_SEL', 'COPRE.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SAL_ITEMNOTBASE_SEL', 'COPRE.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_LUG_SEL', 'COPRE.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_LUG_ARB_SEL', 'COPRE.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_PROVEE_INS', 'COPRE.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_PROVEE_MOD', 'COPRE.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_PROVEE_ELI', 'COPRE.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_PROVEE_SEL', 'COPRE.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_PROVEEV_SEL', 'COPRE.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_PERSON_SEL', 'COPRE.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_PERSONMIN_SEL', 'COPRE.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_INSTIT_SEL', 'COPRE.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_INSTIT_INS', 'COPRE.5.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_INSTIT_MOD', 'COPRE.5.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_INSTIT_ELI', 'COPRE.5.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_INSTIT_SEL', 'COPRE.5.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_PERSON_SEL', 'COPRE.5.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_PERSONMIN_SEL', 'COPRE.5.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_PERSON_INS', 'COPRE.5.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_PERSON_MOD', 'COPRE.5.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_PERSON_ELI', 'COPRE.5.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_PERSONMIN_SEL', 'COPRE.5.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_PERSON_INS', 'COPRE.5.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_PERSON_MOD', 'COPRE.5.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_PERSON_ELI', 'COPRE.5.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_PERSONMIN_SEL', 'COPRE.5.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_UPFOTOPER_MOD', 'COPRE.5.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SAL_ITEM_SEL', 'COPRE.5.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SAL_ITEMNOTBASE_SEL', 'COPRE.5.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SAL_ITMALM_SEL', 'COPRE.5.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_SERVIC_SEL', 'COPRE.5.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_PRITSE_INS', 'COPRE.5.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_PRITSE_MOD', 'COPRE.5.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_PRITSE_ELI', 'COPRE.5.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_PRITSE_SEL', 'COPRE.5.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'WF_DWF_MOD', 'COPRE.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'WF_DWF_ELI', 'COPRE.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'WF_DWF_SEL', 'COPRE.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'WF_DOCWFAR_MOD', 'COPRE.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_CCFILDEP_SEL', 'COPRE.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_CONIG_SEL', 'COPRE.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_CONIGPP_SEL', 'COPRE.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'CONTA_ODT_SEL', 'COPRE.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_SOLD_INS', 'COPRE.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_SOLD_MOD', 'COPRE.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_SOLD_ELI', 'COPRE.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_SOLD_SEL', 'COPRE.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_SOLDETCOT_SEL', 'COPRE.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_CEC_SEL', 'COPRE.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_CECCOM_SEL', 'COPRE.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_CECCOMFU_SEL', 'COPRE.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_APRPRES_IME', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_DEPFILUSU_SEL', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_GRU_SEL', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_PRES_INS', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_PRES_MOD', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_PRES_ELI', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_PRES_SEL', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_RETPRES_IME', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_PRESREP_SEL', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_PRED_SEL', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_DEPUSUCOMB_SEL', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'RH_FUNCIOCAR_SEL', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'RH_UO_SEL', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'RH_INIUOARB_SEL', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_CONSOL_IME', 'COPRE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_CCFILDEP_SEL', 'COPRE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_CONIGPP_SEL', 'COPRE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_PRED_INS', 'COPRE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_PRED_MOD', 'COPRE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_PRED_ELI', 'COPRE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_PRED_SEL', 'COPRE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_CEC_SEL', 'COPRE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_CECCOM_SEL', 'COPRE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_CECCOMFU_SEL', 'COPRE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_GATNREP_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOL_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_PROC_INS', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_PROC_MOD', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_PROC_ELI', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_PROC_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_PROCSOL_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_PROCPED_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_REVPRE_IME', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_FINPRO_IME', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOLD_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOLDETCOT_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COT_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COTPROC_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COTRPC_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_CTD_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_DEPUSUCOMB_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_OBEPUO_IME', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_DEPFILEPUO_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_OBTTCB_GET', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_FINREGC_IME', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SIGECOT_IME', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_ADJTODO_IME', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_HABPAG_IME', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_PREING_GEN', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COTREP_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_CTD_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PROVEEV_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COT_INS', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COT_MOD', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COT_ELI', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COT_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COTPROC_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COTRPC_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COTOC_REP', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_ANTEST_IME', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_MONEDA_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_TOTALADJ_IME', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_ADJDET_IME', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOLDETCOT_SEL', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_CTD_INS', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_CTD_MOD', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_CTD_ELI', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_CTD_SEL', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_MOD', 'PROC.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_ELI', 'PROC.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_SEL', 'PROC.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOLCON_IME', 'PROC.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COTOC_REP', 'PROC.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_CTD_SEL', 'PROC.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_MOD', 'PROC.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_ELI', 'PROC.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_SEL', 'PROC.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DOCWFAR_MOD', 'PROC.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_CCFILDEP_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_CONIG_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_CONIGPP_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'CONTA_ODT_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOLD_INS', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOLD_MOD', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOLD_ELI', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOLD_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOLDETCOT_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_CEC_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_CECCOM_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_CECCOMFU_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_GATNREP_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_OBPG_INS', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_OBPG_MOD', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_OBPG_ELI', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_OBPG_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_OBPGSEL_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPAOB_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_OBTTCB_GET', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_FINREG_IME', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_ANTEOB_IME', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_IDSEXT_GET', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COTOC_REP', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_CTD_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COTREP_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOLREP_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOLD_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOLDETCOT_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PRE_VERPRE_IME', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_PROCPED_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COT_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COTPROC_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COTRPC_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_DEPUSUCOMB_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_MONEDA_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PROVEEV_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'RH_FUNCIO_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'RH_FUNCIOCAR_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'RH_FUNCIO_INS', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'RH_FUNCIO_MOD', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'RH_FUNCIO_ELI', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'RH_FUNCIO_SEL', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'RH_FUNCIOCAR_SEL', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_SEL', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSONMIN_SEL', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_INS', 'OBPAGOA.8.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_MOD', 'OBPAGOA.8.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_ELI', 'OBPAGOA.8.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSONMIN_SEL', 'OBPAGOA.8.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'OR_FUNCUE_INS', 'OBPAGOA.8.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'OR_FUNCUE_MOD', 'OBPAGOA.8.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'OR_FUNCUE_ELI', 'OBPAGOA.8.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'OR_FUNCUE_SEL', 'OBPAGOA.8.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_INSTIT_SEL', 'OBPAGOA.8.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_INSTIT_INS', 'OBPAGOA.8.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_INSTIT_MOD', 'OBPAGOA.8.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_INSTIT_ELI', 'OBPAGOA.8.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_INSTIT_SEL', 'OBPAGOA.8.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_SEL', 'OBPAGOA.8.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSONMIN_SEL', 'OBPAGOA.8.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_SERVIC_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SAL_ITEMNOTBASE_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_LUG_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_LUG_ARB_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PROVEE_INS', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PROVEE_MOD', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PROVEE_ELI', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PROVEE_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PROVEEV_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSONMIN_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_INSTIT_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_INSTIT_INS', 'OBPAGOA.7.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_INSTIT_MOD', 'OBPAGOA.7.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_INSTIT_ELI', 'OBPAGOA.7.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_INSTIT_SEL', 'OBPAGOA.7.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_SEL', 'OBPAGOA.7.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSONMIN_SEL', 'OBPAGOA.7.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_INS', 'OBPAGOA.7.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_MOD', 'OBPAGOA.7.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_ELI', 'OBPAGOA.7.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSONMIN_SEL', 'OBPAGOA.7.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_INS', 'OBPAGOA.7.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_MOD', 'OBPAGOA.7.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_ELI', 'OBPAGOA.7.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSONMIN_SEL', 'OBPAGOA.7.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_UPFOTOPER_MOD', 'OBPAGOA.7.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SAL_ITEM_SEL', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SAL_ITEMNOTBASE_SEL', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SAL_ITMALM_SEL', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_SERVIC_SEL', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PRITSE_INS', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PRITSE_MOD', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PRITSE_ELI', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PRITSE_SEL', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PRE_VERPRE_SEL', 'OBPAGOA.6');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_MOD', 'OBPAGOA.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_ELI', 'OBPAGOA.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_SEL', 'OBPAGOA.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PAFPP_IME', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'CONTA_GETDEC_IME', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PLT_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_CTABAN_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPAPA_INS', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPA_INS', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPA_MOD', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPA_ELI', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPA_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_TIPES_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_FUNTIPES_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_SINPRE_IME', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_SIGEPP_IME', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_ANTEPP_IME', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPAREP_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PRO_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_MOD', 'OBPAGOA.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_ELI', 'OBPAGOA.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_SEL', 'OBPAGOA.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PRO_MOD', 'OBPAGOA.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PRO_SEL', 'OBPAGOA.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PRE_VERPRE_SEL', 'OBPAGOA.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_OBPGSEL_SEL', 'OBPAGOA.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_OBPG_SEL', 'OBPAGOA.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_COMEJEPAG_SEL', 'OBPAGOA.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_MONEDA_SEL', 'OBPAGOA.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPAREP_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PRO_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PAFPP_IME', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'CONTA_GETDEC_IME', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PLT_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_CTABAN_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPAPA_INS', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPA_INS', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPA_MOD', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPA_ELI', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPA_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_TIPES_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_FUNTIPES_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_SINPRE_IME', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_SIGEPP_IME', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_ANTEPP_IME', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_MOD', 'OBPAGOA.2.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_ELI', 'OBPAGOA.2.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_SEL', 'OBPAGOA.2.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DOCWFAR_MOD', 'OBPAGOA.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PRO_MOD', 'OBPAGOA.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PRO_SEL', 'OBPAGOA.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PRE_VERPRE_SEL', 'OBPAGOA.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_CCFILDEP_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_CONIG_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_CONIGPP_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'CONTA_CTA_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'CONTA_CTA_ARB_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PRE_PAR_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PRE_PAR_ARB_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'CONTA_AUXCTA_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_OBDET_INS', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_OBDET_MOD', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_OBDET_ELI', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_OBDET_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_CEC_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_CECCOM_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_CECCOMFU_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_GATNREP_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_OBPG_INS', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_OBPG_MOD', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_OBPG_ELI', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_OBPG_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_OBPGSEL_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPAOB_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_OBTTCB_GET', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_FINREG_IME', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_ANTEOB_IME', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_IDSEXT_GET', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COTOC_REP', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_CTD_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COTREP_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLREP_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLD_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLDETCOT_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PRE_VERPRE_IME', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_PROCPED_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COT_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COTPROC_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COTRPC_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_DEPUSUCOMB_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_MONEDA_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEEV_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'RH_FUNCIO_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'RH_FUNCIOCAR_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'RH_FUNCIO_INS', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'RH_FUNCIO_MOD', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'RH_FUNCIO_ELI', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'RH_FUNCIO_SEL', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'RH_FUNCIOCAR_SEL', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_SEL', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSONMIN_SEL', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_INS', 'OBPAGOA.8.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_MOD', 'OBPAGOA.8.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_ELI', 'OBPAGOA.8.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSONMIN_SEL', 'OBPAGOA.8.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'OR_FUNCUE_INS', 'OBPAGOA.8.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'OR_FUNCUE_MOD', 'OBPAGOA.8.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'OR_FUNCUE_ELI', 'OBPAGOA.8.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'OR_FUNCUE_SEL', 'OBPAGOA.8.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_SEL', 'OBPAGOA.8.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_INS', 'OBPAGOA.8.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_MOD', 'OBPAGOA.8.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_ELI', 'OBPAGOA.8.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_SEL', 'OBPAGOA.8.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_SEL', 'OBPAGOA.8.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSONMIN_SEL', 'OBPAGOA.8.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_SERVIC_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SAL_ITEMNOTBASE_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_LUG_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_LUG_ARB_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEE_INS', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEE_MOD', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEE_ELI', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEE_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEEV_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSONMIN_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_INS', 'OBPAGOA.7.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_MOD', 'OBPAGOA.7.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_ELI', 'OBPAGOA.7.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_SEL', 'OBPAGOA.7.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_SEL', 'OBPAGOA.7.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSONMIN_SEL', 'OBPAGOA.7.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_INS', 'OBPAGOA.7.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_MOD', 'OBPAGOA.7.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_ELI', 'OBPAGOA.7.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSONMIN_SEL', 'OBPAGOA.7.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_INS', 'OBPAGOA.7.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_MOD', 'OBPAGOA.7.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_ELI', 'OBPAGOA.7.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSONMIN_SEL', 'OBPAGOA.7.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_UPFOTOPER_MOD', 'OBPAGOA.7.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SAL_ITEM_SEL', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SAL_ITEMNOTBASE_SEL', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SAL_ITMALM_SEL', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_SERVIC_SEL', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PRITSE_INS', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PRITSE_MOD', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PRITSE_ELI', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PRITSE_SEL', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PRE_VERPRE_SEL', 'OBPAGOA.6');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_MOD', 'OBPAGOA.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_ELI', 'OBPAGOA.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_SEL', 'OBPAGOA.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PAFPP_IME', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'CONTA_GETDEC_IME', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PLT_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_CTABAN_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPAPA_INS', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPA_INS', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPA_MOD', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPA_ELI', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPA_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_TIPES_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_FUNTIPES_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_SINPRE_IME', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_SIGEPP_IME', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_ANTEPP_IME', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPAREP_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PRO_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_MOD', 'OBPAGOA.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_ELI', 'OBPAGOA.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_SEL', 'OBPAGOA.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PRO_MOD', 'OBPAGOA.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PRO_SEL', 'OBPAGOA.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PRE_VERPRE_SEL', 'OBPAGOA.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_OBPGSEL_SEL', 'OBPAGOA.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_OBPG_SEL', 'OBPAGOA.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_COMEJEPAG_SEL', 'OBPAGOA.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_MONEDA_SEL', 'OBPAGOA.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPAREP_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PRO_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PAFPP_IME', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'CONTA_GETDEC_IME', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PLT_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_CTABAN_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPAPA_INS', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPA_INS', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPA_MOD', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPA_ELI', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPA_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_TIPES_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_FUNTIPES_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_SINPRE_IME', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_SIGEPP_IME', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_ANTEPP_IME', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_MOD', 'OBPAGOA.2.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_ELI', 'OBPAGOA.2.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_SEL', 'OBPAGOA.2.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DOCWFAR_MOD', 'OBPAGOA.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PRO_MOD', 'OBPAGOA.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PRO_SEL', 'OBPAGOA.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PRE_VERPRE_SEL', 'OBPAGOA.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CCFILDEP_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CONIG_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CONIGPP_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'CONTA_CTA_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'CONTA_CTA_ARB_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PRE_PAR_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PRE_PAR_ARB_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'CONTA_AUXCTA_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_OBDET_INS', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_OBDET_MOD', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_OBDET_ELI', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_OBDET_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CEC_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CECCOM_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CECCOMFU_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'RH_MAILFUN_GET', 'PROC.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_TIPPROC_SEL', 'ADQ.3.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_TIPES_SEL', 'ADQ.3.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_DES_SEL', 'ADQ.3.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_TIPES_SEL', 'VBSOL.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_TIPPROC_SEL', 'VBSOL.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_DES_INS', 'VBSOL.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_DES_MOD', 'VBSOL.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_DES_ELI', 'VBSOL.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_DES_SEL', 'VBSOL.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_TIPES_SEL', 'PROC.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_TIPPROC_SEL', 'PROC.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DES_INS', 'PROC.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DES_MOD', 'PROC.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DES_ELI', 'PROC.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DES_SEL', 'PROC.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_TIPES_SEL', 'PROC.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_TIPPROC_SEL', 'PROC.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DES_INS', 'PROC.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DES_MOD', 'PROC.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DES_ELI', 'PROC.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DES_SEL', 'PROC.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_CABMOM_IME', 'PROC.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'WF_TIPPROC_SEL', 'VBCOT.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'WF_TIPES_SEL', 'VBCOT.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'WF_DES_SEL', 'VBCOT.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'RH_MAILFUN_GET', 'PROC.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOLD_SEL', 'ADQ.3.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOLDETCOT_SEL', 'ADQ.3.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOLREP_SEL', 'ADQ.3.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PRE_VERPRE_IME', 'ADQ.3.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'RH_MAILFUN_GET', 'ADQ.3.4');


/***********************************F-DEP-JRR-ADQ-0-24/04/2014*****************************************/




/***********************************I-DEP-RAC-ADQ-0-29/05/2014*****************************************/


--------------- SQL ---------------

ALTER TABLE adq.trpc
  ADD CONSTRAINT trpc_id_cargo_fk FOREIGN KEY (id_cargo)
    REFERENCES orga.tcargo(id_cargo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    

--------------- SQL ---------------

ALTER TABLE adq.trpc
  ADD CONSTRAINT trpc_id_cargo_ai_fk FOREIGN KEY (id_cargo_ai)
    REFERENCES orga.tcargo(id_cargo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
    

--------------- SQL ---------------

ALTER TABLE adq.trpc
  ADD CONSTRAINT trpc_id_usuario_mod_fk FOREIGN KEY (id_usuario_mod)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
--------------- SQL ---------------

ALTER TABLE adq.trpc_uo
  ADD CONSTRAINT trpc_uo_id_usuario_reg_fk FOREIGN KEY (id_usuario_reg)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


--------------- SQL ---------------

ALTER TABLE adq.trpc_uo
  ADD CONSTRAINT trpc_uo_id_usuario_mod_fk FOREIGN KEY (id_usuario_mod)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE adq.trpc_uo
  ADD CONSTRAINT trpc_uo_id_rpc_fk FOREIGN KEY (id_rpc)
    REFERENCES adq.trpc(id_rpc)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE adq.trpc_uo
  ADD CONSTRAINT trpc_uo_gd_uo_fk FOREIGN KEY (id_uo)
    REFERENCES orga.tuo(id_uo)
    MATCH FULL
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE adq.trpc_uo
  ADD CONSTRAINT trpc_uo_id_usuario_ai_fk FOREIGN KEY (id_usuario_ai)
    REFERENCES segu.tusuario(id_usuario)
    MATCH FULL
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


--------------- SQL ---------------

ALTER TABLE adq.trpc_uo
  ADD CONSTRAINT trpc_uo_gategoria_fk FOREIGN KEY (id_categoria_compra)
    REFERENCES adq.tcategoria_compra(id_categoria_compra)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


/***********************************F-DEP-RAC-ADQ-0-29/05/2014*****************************************/


/***********************************I-DEP-RAC-ADQ-0-30/05/2014*****************************************/
--------------- SQL ---------------

ALTER TABLE adq.tsolicitud
  ADD CONSTRAINT tsolicitud_rd_cargo_rpc_fk FOREIGN KEY (id_cargo_rpc)
    REFERENCES orga.tcargo(id_cargo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--------------- SQL ---------------

ALTER TABLE adq.tsolicitud
  ADD CONSTRAINT tsolicitud_id_cargo_rpc_ai_fk FOREIGN KEY (id_cargo_rpc_ai)
    REFERENCES orga.tcargo(id_cargo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


/***********************************F-DEP-RAC-ADQ-0-30/05/2014*****************************************/



/***********************************I-DEP-RAC-ADQ-0-02/06/2014*****************************************/


CREATE TRIGGER trpc_tr
  AFTER INSERT OR UPDATE OR DELETE 
  ON adq.trpc FOR EACH ROW 
  EXECUTE PROCEDURE adq.f_trig_rpc();


/***********************************F-DEP-RAC-ADQ-0-02/06/2014*****************************************/


/***********************************I-DEP-RAC-ADQ-0-03/06/2014*****************************************/
  
  CREATE TRIGGER trpc_uo_tr
  AFTER INSERT OR UPDATE OR DELETE 
  ON adq.trpc_uo FOR EACH ROW 
  EXECUTE PROCEDURE adq.f_trig_rpc_uo();


/***********************************F-DEP-RAC-ADQ-0-03/06/2014*****************************************/

/***********************************I-DEP-RAC-ADQ-0-05/06/2014*****************************************/
 

select pxp.f_delete_trol ('ADQ - Visto Bueno DEV/PAG');
select pxp.f_delete_trol ('OP - VoBo Plan de PAgos');
select pxp.f_insert_testructura_gui ('RPCI', 'ADQ.1');
select pxp.f_insert_testructura_gui ('PROC.4.4', 'PROC.4');
select pxp.f_insert_testructura_gui ('OBPAGOA.2.4', 'OBPAGOA.2');
select pxp.f_insert_testructura_gui ('OBPAGOA.2.5', 'OBPAGOA.2');
select pxp.f_insert_testructura_gui ('OBPAGOA.4.4', 'OBPAGOA.4');
select pxp.f_insert_testructura_gui ('OBPAGOA.4.5', 'OBPAGOA.4');
select pxp.f_insert_testructura_gui ('RPCI.1', 'RPCI');
select pxp.f_insert_testructura_gui ('RPCI.2', 'RPCI');
select pxp.f_insert_testructura_gui ('RPCI.3', 'RPCI');
select pxp.f_insert_testructura_gui ('RPCI.2.1', 'RPCI.2');
select pxp.f_insert_testructura_gui ('RPCI.2.2', 'RPCI.2');
select pxp.f_insert_testructura_gui ('RPCI.2.3', 'RPCI.2');
select pxp.f_insert_testructura_gui ('RPCI.2.1.1', 'RPCI.2.1');
select pxp.f_insert_testructura_gui ('RPCI.2.1.2', 'RPCI.2.1');
select pxp.f_insert_testructura_gui ('RPCI.2.3.1', 'RPCI.2.3');
select pxp.f_insert_testructura_gui ('RPCI.2.3.2', 'RPCI.2.3');
select pxp.f_insert_testructura_gui ('RPCI.2.3.3', 'RPCI.2.3');
select pxp.f_insert_testructura_gui ('RPCI.2.3.2.1', 'RPCI.2.3.2');
select pxp.f_insert_testructura_gui ('RPCI.2.3.3.1', 'RPCI.2.3.3');
select pxp.f_insert_testructura_gui ('RPCI.2.3.3.1.1', 'RPCI.2.3.3.1');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'PROC.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_VERSIGPRO_IME', 'PROC.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CHKSTA_IME', 'PROC.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'PROC.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'PROC.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DEPTIPES_SEL', 'PROC.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('MIG_CBANESIS_SEL', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'OBPAGOA.2.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'OBPAGOA.2.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_VERSIGPRO_IME', 'OBPAGOA.2.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CHKSTA_IME', 'OBPAGOA.2.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'OBPAGOA.2.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'OBPAGOA.2.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DEPTIPES_SEL', 'OBPAGOA.2.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('MIG_CBANESIS_SEL', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'OBPAGOA.4.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'OBPAGOA.4.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_VERSIGPRO_IME', 'OBPAGOA.4.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CHKSTA_IME', 'OBPAGOA.4.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'OBPAGOA.4.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'OBPAGOA.4.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DEPTIPES_SEL', 'OBPAGOA.4.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_CARGO_SEL', 'RPCI', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_RPC_INS', 'RPCI', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_RPC_MOD', 'RPCI', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_RPC_ELI', 'RPCI', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_RPC_SEL', 'RPCI', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CLONRPC_IME', 'RPCI', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CATCOMP_SEL', 'RPCI.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_UO_SEL', 'RPCI.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_INIUOARB_SEL', 'RPCI.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_RUO_INS', 'RPCI.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_RUO_MOD', 'RPCI.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_RUO_ELI', 'RPCI.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_RUO_SEL', 'RPCI.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CHARPC_IME', 'RPCI.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_GATNREP_SEL', 'RPCI.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILUSU_SEL', 'RPCI.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CATCOMP_SEL', 'RPCI.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_INS', 'RPCI.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_MOD', 'RPCI.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_ELI', 'RPCI.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_SEL', 'RPCI.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'RPCI.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'RPCI.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'RPCI.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'RPCI.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'RPCI.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'RPCI.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'RPCI.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_UO_SEL', 'RPCI.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_INIUOARB_SEL', 'RPCI.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'RPCI.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'RPCI.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'RPCI.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'RPCI.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_CABMOM_IME', 'RPCI.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'RPCI.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPPROC_SEL', 'RPCI.2.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'RPCI.2.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_INS', 'RPCI.2.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_MOD', 'RPCI.2.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_ELI', 'RPCI.2.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DES_SEL', 'RPCI.2.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'RPCI.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'RPCI.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'RPCI.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'RPCI.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_MAILFUN_GET', 'RPCI.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'RPCI.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'RPCI.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'RPCI.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'RPCI.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_INS', 'RPCI.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_MOD', 'RPCI.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_ELI', 'RPCI.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_SEL', 'RPCI.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'RPCI.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'RPCI.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'RPCI.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'RPCI.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_SEL', 'RPCI.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'RPCI.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'RPCI.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'RPCI.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_INS', 'RPCI.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_MOD', 'RPCI.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_ELI', 'RPCI.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_SEL', 'RPCI.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'RPCI.2.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'RPCI.2.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'RPCI.2.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'RPCI.2.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'RPCI.2.3.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'RPCI.2.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'RPCI.2.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'RPCI.2.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'RPCI.2.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'RPCI.2.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'RPCI.2.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'RPCI.2.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'RPCI.2.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'RPCI.2.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'RPCI.2.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'RPCI.2.3.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_RPCL_SEL', 'RPCI.3', 'no');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_DWF_MOD', 'VBSOL.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_DOCWFAR_MOD', 'VBSOL.2.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'WF_DWF_MOD', 'VBCOT.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'WF_DOCWFAR_MOD', 'VBCOT.2.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_DWF_MOD', 'ADQ.3.2');
/***********************************F-DEP-RAC-ADQ-0-05/06/2014*****************************************/
 
 
 
 
 
 
 /***********************************I-DEP-RAC-ADQ-1-05/06/2014*****************************************/
 
 
 
 
 
 --------------- SQL ---------------

--------------- SQL ---------------

CREATE OR REPLACE VIEW tes.vcomp_devtesprov_plan_pago
AS
  SELECT pp.id_plan_pago,
         op.id_proveedor,
         p.desc_proveedor,
         op.id_moneda,
         op.id_depto_conta,
         op.numero,
         now() AS fecha_actual,
         pp.estado,
         pp.monto_ejecutar_total_mb,
         pp.monto_ejecutar_total_mo,
         pp.monto,
         pp.monto_mb,
         pp.monto_retgar_mb,
         pp.monto_retgar_mo,
         pp.monto_no_pagado,
         pp.monto_no_pagado_mb,
         pp.otros_descuentos,
         pp.otros_descuentos_mb,
         pp.id_plantilla,
         pp.id_cuenta_bancaria,
         pp.id_cuenta_bancaria_mov,
         pp.nro_cheque,
         pp.nro_cuenta_bancaria,
         op.num_tramite,
         pp.tipo,
         op.id_gestion AS id_gestion_cuentas,
         pp.id_int_comprobante,
         pp.liquido_pagable,
         pp.liquido_pagable_mb,
         pp.nombre_pago,
         pp.porc_monto_excento_var,
         (COALESCE(op.numero, '' )||' '|| COALESCE(pp.obs_monto_no_pagado, '' ))::character varying AS obs_pp
        
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago =
        op.id_obligacion_pago
       JOIN param.vproveedor p ON p.id_proveedor = op.id_proveedor;
/***********************************F-DEP-RAC-ADQ-1-05/06/2014*****************************************/
 
 
 
 
 
 
/***********************************I-DEP-RAC-ADQ-1-19/08/2014*****************************************/
 --------------- SQL ---------------

CREATE OR REPLACE VIEW adq.vsolicitud_compra
AS
  SELECT DISTINCT sol.id_solicitud,
         sol.id_proveedor,
         p.desc_proveedor,
         sol.id_moneda,
         sol.id_depto,
         sol.numero,
         sol.fecha_soli,
         sol.estado,
         sol.num_tramite,
         sol.id_gestion,
         sol.justificacion,
         p.rotulo_comercial,
         sol.id_categoria_compra,
         mon.codigo,
         sum(sd.precio_total) AS precio_total,
         sum(sd.precio_unitario_mb * sd.cantidad::numeric) AS precio_total_mb,
         COALESCE(cac.codigo, '' ::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, '' ::character varying) AS nombre_categoria,
         sol.id_proceso_wf,
         ('<table>' ::text || pxp.html_rows((((('<td>' ::text ||
          ci.desc_ingas::text) || ' <br>' ::text) || sd.descripcion) || '</td>'
           ::text) ::character varying) ::text) || '</table>' ::text AS detalle,
         fun.desc_funcionario1,
         uo.codigo AS codigo_uo,
         uo.nombre_unidad,
         lower(sol.tipo::text) AS tipo,
         lower(sol.tipo_concepto::text) AS tipo_concepto,
         fun.nombre_cargo,
         fun.nombre_unidad AS nombre_unidad_cargo
  FROM adq.tsolicitud sol
       JOIN adq.tsolicitud_det sd ON sd.id_solicitud = sol.id_solicitud
       JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas =
        sd.id_concepto_ingas
       JOIN param.tmoneda mon ON mon.id_moneda = sol.id_moneda
       JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario =
        sol.id_funcionario
       JOIN orga.tuo uo ON uo.id_uo = sol.id_uo
       LEFT JOIN param.vproveedor p ON p.id_proveedor = sol.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
        sol.id_categoria_compra
  WHERE fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion >= sol.fecha_soli OR
        fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion IS NULL
  GROUP BY sol.id_solicitud,
           sol.id_proveedor,
           p.desc_proveedor,
           sol.id_moneda,
           sol.id_depto,
           sol.numero,
           sol.fecha_soli,
           sol.estado,
           sol.num_tramite,
           sol.id_gestion,
           sol.justificacion,
           p.rotulo_comercial,
           sol.id_categoria_compra,
           cac.codigo,
           cac.nombre,
           mon.codigo,
           fun.desc_funcionario1,
           uo.codigo,
           uo.nombre_unidad,
           sol.tipo_concepto,
           sol.tipo,
           fun.nombre_cargo,
           fun.nombre_unidad;
/***********************************F-DEP-RAC-ADQ-1-19/08/2014*****************************************/
 
 
 
 
 
/***********************************I-DEP-RAC-ADQ-1-20/08/2014*****************************************/
 
 
--------------- SQL ---------------

CREATE OR REPLACE VIEW adq.vcotizacion(
    id_cotizacion,
    numero_oc,
    codigo_proceso,
    num_cotizacion,
    id_solicitud,
    id_proveedor,
    desc_proveedor,
    id_moneda,
    id_depto,
    numero,
    fecha_soli,
    estado,
    num_tramite,
    id_gestion,
    justificacion,
    rotulo_comercial,
    id_categoria_compra,
    codigo,
    precio_total,
    precio_total_mb,
    monto_total_adjudicado,
    monto_total_adjudicado_mb,
    codigo_categoria,
    nombre_categoria,
    id_proceso_wf_sol,
    id_proceso_wf,
    detalle,
    desc_funcionario1,
    codigo_uo,
    nombre_unidad,
    tipo,
    tipo_concepto,
    nombre_cargo,
    nombre_unidad_cargo)
AS
  SELECT DISTINCT cot.id_cotizacion,
         cot.numero_oc,
         pro.codigo_proceso,
         pro.num_cotizacion,
         sol.id_solicitud,
         p.id_proveedor,
         p.desc_proveedor,
         sol.id_moneda,
         sol.id_depto,
         sol.numero,
         sol.fecha_soli,
         sol.estado,
         sol.num_tramite,
         sol.id_gestion,
         sol.justificacion,
         p.rotulo_comercial,
         sol.id_categoria_compra,
         mon.codigo,
         sum(sd.precio_total) AS precio_total,
         sum(sd.precio_unitario_mb * sd.cantidad::numeric) AS precio_total_mb,
         sum(cd.cantidad_adju * cd.precio_unitario) AS monto_total_adjudicado,
         sum(cd.cantidad_adju * cd.precio_unitario_mb) AS
          monto_total_adjudicado_mb,
         COALESCE(cac.codigo, '' ::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, '' ::character varying) AS nombre_categoria,
         sol.id_proceso_wf AS id_proceso_wf_sol,
         cot.id_proceso_wf,
         ('<table>' ::text || pxp.html_rows((((('<td>' ::text ||
          ci.desc_ingas::text) || ' <br>' ::text) || sd.descripcion) || '</td>'
           ::text) ::character varying) ::text) || '</table>' ::text AS detalle,
         fun.desc_funcionario1,
         uo.codigo AS codigo_uo,
         uo.nombre_unidad,
         lower(sol.tipo::text) AS tipo,
         lower(sol.tipo_concepto::text) AS tipo_concepto,
         fun.nombre_cargo,
         fun.nombre_unidad AS nombre_unidad_cargo
  FROM adq.tcotizacion cot
       JOIN adq.tproceso_compra pro ON pro.id_proceso_compra =
        cot.id_proceso_compra
       JOIN adq.tsolicitud sol ON sol.id_solicitud = pro.id_solicitud
       JOIN adq.tcotizacion_det cd ON cd.id_cotizacion = cot.id_cotizacion
       JOIN adq.tsolicitud_det sd ON sd.id_solicitud_det = cd.id_solicitud_det
       JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas =
        sd.id_concepto_ingas
       JOIN param.tmoneda mon ON mon.id_moneda = sol.id_moneda
       JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario =
        sol.id_funcionario AND fun.estado_reg_asi::text = 'activo' ::text
       JOIN orga.tuo uo ON uo.id_uo = sol.id_uo
       JOIN param.vproveedor p ON p.id_proveedor = cot.id_proveedor
       JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
        sol.id_categoria_compra
  WHERE fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion >= sol.fecha_soli OR
        fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion IS NULL
  GROUP BY cot.id_cotizacion,
           cot.numero_oc,
           pro.codigo_proceso,
           pro.num_cotizacion,
           sol.id_solicitud,
           p.id_proveedor,
           p.desc_proveedor,
           sol.id_moneda,
           sol.id_depto,
           sol.numero,
           sol.fecha_soli,
           sol.estado,
           sol.num_tramite,
           sol.id_gestion,
           sol.justificacion,
           p.rotulo_comercial,
           sol.id_categoria_compra,
           cac.codigo,
           cac.nombre,
           mon.codigo,
           fun.desc_funcionario1,
           uo.codigo,
           uo.nombre_unidad,
           sol.tipo_concepto,
           sol.tipo,
           fun.nombre_cargo,
           fun.nombre_unidad;

--------------- SQL ---------------

CREATE OR REPLACE VIEW adq.vsolicitud_compra(
    id_solicitud,
    id_proveedor,
    desc_proveedor,
    id_moneda,
    id_depto,
    numero,
    fecha_soli,
    estado,
    num_tramite,
    id_gestion,
    justificacion,
    rotulo_comercial,
    id_categoria_compra,
    codigo,
    precio_total,
    precio_total_mb,
    codigo_categoria,
    nombre_categoria,
    id_proceso_wf,
    detalle,
    desc_funcionario1,
    codigo_uo,
    nombre_unidad,
    tipo,
    tipo_concepto,
    nombre_cargo,
    nombre_unidad_cargo)
AS
  SELECT DISTINCT sol.id_solicitud,
         sol.id_proveedor,
         p.desc_proveedor,
         sol.id_moneda,
         sol.id_depto,
         sol.numero,
         sol.fecha_soli,
         sol.estado,
         sol.num_tramite,
         sol.id_gestion,
         sol.justificacion,
         p.rotulo_comercial,
         sol.id_categoria_compra,
         mon.codigo,
         sum(sd.precio_total) AS precio_total,
         sum(sd.precio_unitario_mb * sd.cantidad::numeric) AS precio_total_mb,
         COALESCE(cac.codigo, '' ::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, '' ::character varying) AS nombre_categoria,
         sol.id_proceso_wf,
         ('<table>' ::text || pxp.html_rows((((('<td>' ::text ||
          ci.desc_ingas::text) || ' <br>' ::text) || sd.descripcion) || '</td>'
           ::text) ::character varying) ::text) || '</table>' ::text AS detalle,
         fun.desc_funcionario1,
         uo.codigo AS codigo_uo,
         uo.nombre_unidad,
         lower(sol.tipo::text) AS tipo,
         lower(sol.tipo_concepto::text) AS tipo_concepto,
         fun.nombre_cargo,
         fun.nombre_unidad AS nombre_unidad_cargo
  FROM adq.tsolicitud sol
       JOIN adq.tsolicitud_det sd ON sd.id_solicitud = sol.id_solicitud
       JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas =
        sd.id_concepto_ingas
       JOIN param.tmoneda mon ON mon.id_moneda = sol.id_moneda
       JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario =
        sol.id_funcionario AND fun.estado_reg_asi::text = 'activo' ::text
       JOIN orga.tuo uo ON uo.id_uo = sol.id_uo
       LEFT JOIN param.vproveedor p ON p.id_proveedor = sol.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
        sol.id_categoria_compra
  WHERE fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion >= sol.fecha_soli OR
        fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion IS NULL
  GROUP BY sol.id_solicitud,
           sol.id_proveedor,
           p.desc_proveedor,
           sol.id_moneda,
           sol.id_depto,
           sol.numero,
           sol.fecha_soli,
           sol.estado,
           sol.num_tramite,
           sol.id_gestion,
           sol.justificacion,
           p.rotulo_comercial,
           sol.id_categoria_compra,
           cac.codigo,
           cac.nombre,
           mon.codigo,
           fun.desc_funcionario1,
           uo.codigo,
           uo.nombre_unidad,
           sol.tipo_concepto,
           sol.tipo,
           fun.nombre_cargo,
           fun.nombre_unidad;

 /***********************************F-DEP-RAC-ADQ-1-20/08/2014*****************************************/
 





/***********************************I-DEP-RAC-ADQ-1-22/08/2014*****************************************/
 

--------------- SQL ---------------

CREATE OR REPLACE VIEW adq.vproceso_compra_wf(
    id_proceso_compra,
    codigo_proceso,
    num_cotizacion,
    id_solicitud,
    id_proveedor_solicitud,
    des_proveedor_solicitud,
    id_moneda,
    id_depto,
    numero,
    fecha_soli,
    estado,
    num_tramite,
    id_gestion,
    justificacion,
    rotulo_comercial,
    id_categoria_compra,
    codigo,
    precio_total,
    precio_total_mb,
    codigo_categoria,
    nombre_categoria,
    id_proceso_wf_sol,
    id_proceso_wf,
    detalle,
    desc_funcionario1,
    codigo_uo,
    nombre_unidad,
    tipo,
    tipo_concepto,
    nombre_cargo,
    nombre_unidad_cargo)
AS
  SELECT DISTINCT pro.id_proceso_compra,
         pro.codigo_proceso,
         pro.num_cotizacion,
         sol.id_solicitud,
         p.id_proveedor AS id_proveedor_solicitud,
         p.desc_proveedor AS des_proveedor_solicitud,
         sol.id_moneda,
         sol.id_depto,
         sol.numero,
         sol.fecha_soli,
         sol.estado,
         sol.num_tramite,
         sol.id_gestion,
         sol.justificacion,
         p.rotulo_comercial,
         sol.id_categoria_compra,
         mon.codigo,
         sum(sd.precio_total) AS precio_total,
         sum(sd.precio_unitario_mb * sd.cantidad::numeric) AS precio_total_mb,
         COALESCE(cac.codigo, '' ::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, '' ::character varying) AS nombre_categoria,
         sol.id_proceso_wf AS id_proceso_wf_sol,
         pro.id_proceso_wf,
         ('<table>' ::text || pxp.html_rows((((('<td>' ::text ||
          ci.desc_ingas::text) || ' <br>' ::text) || sd.descripcion) || '</td>'
           ::text) ::character varying) ::text) || '</table>' ::text AS detalle,
         fun.desc_funcionario1,
         uo.codigo AS codigo_uo,
         uo.nombre_unidad,
         lower(sol.tipo::text) AS tipo,
         lower(sol.tipo_concepto::text) AS tipo_concepto,
         fun.nombre_cargo,
         fun.nombre_unidad AS nombre_unidad_cargo
  FROM adq.tproceso_compra pro
       JOIN adq.tsolicitud sol ON sol.id_solicitud = pro.id_solicitud
       JOIN adq.tsolicitud_det sd ON sd.id_solicitud = sol.id_solicitud
       JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas =
        sd.id_concepto_ingas
       JOIN param.tmoneda mon ON mon.id_moneda = sol.id_moneda
       JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario =
        sol.id_funcionario AND fun.estado_reg_asi::text = 'activo' ::text
       JOIN orga.tuo uo ON uo.id_uo = sol.id_uo
       JOIN param.vproveedor p ON p.id_proveedor = sol.id_proveedor
       JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
        sol.id_categoria_compra
  WHERE fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion >= sol.fecha_soli OR
        fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion IS NULL
  GROUP BY pro.id_proceso_compra,
           pro.codigo_proceso,
           pro.num_cotizacion,
           sol.id_solicitud,
           p.id_proveedor,
           p.desc_proveedor,
           sol.id_moneda,
           sol.id_depto,
           sol.numero,
           sol.fecha_soli,
           sol.estado,
           sol.num_tramite,
           sol.id_gestion,
           sol.justificacion,
           p.rotulo_comercial,
           sol.id_categoria_compra,
           cac.codigo,
           cac.nombre,
           mon.codigo,
           fun.desc_funcionario1,
           uo.codigo,
           uo.nombre_unidad,
           sol.tipo_concepto,
           sol.tipo,
           fun.nombre_cargo,
           fun.nombre_unidad;

/***********************************F-DEP-RAC-ADQ-1-22/08/2014*****************************************/


/***********************************I-DEP-RAC-ADQ-1-29/08/2014*****************************************/

select pxp.f_insert_testructura_gui ('OBPAGOA.1.1', 'OBPAGOA.1');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPGSOL_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPGSOL_SEL', 'OBPAGOA.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPAR_SEL', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPAR_SEL', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPAR_SEL', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPAR_SEL', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPAR_SEL', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPAR_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PPANTPAR_INS', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PPANTPAR_INS', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_TIPO_SEL', 'OBPAGOA.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPAR_SEL', 'OBPAGOA.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_OFCU_SEL', 'OBPAGOA.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'OBPAGOA.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'OBPAGOA.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_SEL', 'OBPAGOA.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PER_SEL', 'OBPAGOA.1.1', 'no');
select pxp.f_delete_tgui_rol ('VBSOL.2.1', 'ADQ - Visto Bueno Sol');
select pxp.f_delete_tgui_rol ('VBDP', 'ADQ - Solicitud de Compra');
select pxp.f_delete_tgui_rol ('TES', 'ADQ - Solicitud de Compra');
select pxp.f_delete_tgui_rol ('VBDP.4', 'ADQ - Solicitud de Compra');
select pxp.f_delete_tgui_rol ('VBDP.5', 'ADQ - Solicitud de Compra');
select pxp.f_delete_tgui_rol ('VBDP.1', 'ADQ - Solicitud de Compra');
select pxp.f_delete_tgui_rol ('VBDP.2', 'ADQ - Solicitud de Compra');
select pxp.f_delete_tgui_rol ('VBDP.2.1', 'ADQ - Solicitud de Compra');
select pxp.f_delete_tgui_rol ('VBDP.2.2', 'ADQ - Solicitud de Compra');
select pxp.f_delete_tgui_rol ('VBDP.2.2.1', 'ADQ - Solicitud de Compra');
select pxp.f_delete_tgui_rol ('VBDP.2.2.2', 'ADQ - Solicitud de Compra');
select pxp.f_delete_tgui_rol ('VBDP.2.2.2.1', 'ADQ - Solicitud de Compra');
select pxp.f_delete_tgui_rol ('VBDP.2.2.3', 'ADQ - Solicitud de Compra');
select pxp.f_delete_tgui_rol ('VBDP.2.2.3.1', 'ADQ - Solicitud de Compra');
select pxp.f_delete_tgui_rol ('VBDP.2.2.3.1.1', 'ADQ - Solicitud de Compra');
select pxp.f_delete_tgui_rol ('VBDP.3', 'ADQ - Solicitud de Compra');
select pxp.f_delete_tgui_rol ('VBDP.3.1', 'ADQ - Solicitud de Compra');
select pxp.f_delete_tgui_rol ('VBDP.3.2', 'ADQ - Solicitud de Compra');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_DWF_MOD', 'VBSOL.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_DWF_ELI', 'VBSOL.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_DOCWFAR_MOD', 'VBSOL.2.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'WF_DWF_MOD', 'VBCOT.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'WF_DWF_ELI', 'VBCOT.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'WF_DOCWFAR_MOD', 'VBCOT.2.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_DOCSOL_INS', 'VBCOT.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_DOCSOL_MOD', 'VBCOT.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_DOCSOL_ELI', 'VBCOT.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_DWF_MOD', 'ADQ.3.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_DES_INS', 'VBSOL.2.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_DES_MOD', 'VBSOL.2.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_DES_ELI', 'VBSOL.2.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_DWF_MOD', 'VBSOL.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_DOCWFAR_MOD', 'VBSOL.2.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'WF_DWF_MOD', 'VBCOT.2');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'WF_DOCWFAR_MOD', 'VBCOT.2.1');
select pxp.f_delete_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_DWF_MOD', 'ADQ.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_CONIGPAR_SEL', 'ADQ.3.1');

/***********************************F-DEP-RAC-ADQ-1-29/08/2014*****************************************/

/***********************************I-DEP-JRR-ADQ-1-10/09/2014*****************************************/
CREATE OR REPLACE VIEW adq.vsolicitud_compra(
    id_solicitud,
    id_proveedor,
    desc_proveedor,
    id_moneda,
    id_depto,
    numero,
    fecha_soli,
    estado,
    num_tramite,
    id_gestion,
    justificacion,
    rotulo_comercial,
    id_categoria_compra,
    codigo,
    precio_total,
    precio_total_mb,
    codigo_categoria,
    nombre_categoria,
    id_proceso_wf,
    detalle,
    desc_funcionario1,
    codigo_uo,
    nombre_unidad,
    tipo,
    tipo_concepto,
    nombre_cargo,
    nombre_unidad_cargo,
    email_empresa,
    desc_usuario)
AS
  SELECT DISTINCT sol.id_solicitud,
         sol.id_proveedor,
         p.desc_proveedor,
         sol.id_moneda,
         sol.id_depto,
         sol.numero,
         sol.fecha_soli,
         sol.estado,
         sol.num_tramite,
         sol.id_gestion,
         sol.justificacion,
         p.rotulo_comercial,
         sol.id_categoria_compra,
         mon.codigo,
         sum(sd.precio_total) AS precio_total,
         sum(sd.precio_unitario_mb * sd.cantidad::numeric) AS precio_total_mb,
         COALESCE(cac.codigo, '' ::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, '' ::character varying) AS nombre_categoria,
         sol.id_proceso_wf,
         ('<table>' ::text || pxp.html_rows((((('<td>' ::text ||
          ci.desc_ingas::text) || ' <br>' ::text) || sd.descripcion) || '</td>'
           ::text) ::character varying) ::text) || '</table>' ::text AS detalle,
         fun.desc_funcionario1,
         uo.codigo AS codigo_uo,
         uo.nombre_unidad,
         lower(sol.tipo::text) AS tipo,
         lower(sol.tipo_concepto::text) AS tipo_concepto,
         fun.nombre_cargo,
         fun.nombre_unidad AS nombre_unidad_cargo,
         fun.email_empresa,
         usu.desc_persona AS desc_usuario
  FROM adq.tsolicitud sol
       JOIN adq.tsolicitud_det sd ON sd.id_solicitud = sol.id_solicitud
       JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas =
        sd.id_concepto_ingas
       JOIN param.tmoneda mon ON mon.id_moneda = sol.id_moneda
       JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario =
        sol.id_funcionario AND fun.estado_reg_asi::text = 'activo' ::text
       JOIN orga.tuo uo ON uo.id_uo = sol.id_uo
       JOIN segu.vusuario usu ON usu.id_usuario = sol.id_usuario_reg
       LEFT JOIN param.vproveedor p ON p.id_proveedor = sol.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
        sol.id_categoria_compra
  WHERE fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion >= sol.fecha_soli OR
        fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion IS NULL
  GROUP BY sol.id_solicitud,
           sol.id_proveedor,
           p.desc_proveedor,
           sol.id_moneda,
           sol.id_depto,
           sol.numero,
           sol.fecha_soli,
           sol.estado,
           sol.num_tramite,
           sol.id_gestion,
           sol.justificacion,
           p.rotulo_comercial,
           sol.id_categoria_compra,
           cac.codigo,
           cac.nombre,
           mon.codigo,
           fun.desc_funcionario1,
           uo.codigo,
           uo.nombre_unidad,
           sol.tipo_concepto,
           sol.tipo,
           fun.nombre_cargo,
           fun.nombre_unidad,
           fun.email_empresa,
           usu.desc_persona;
           
/***********************************F-DEP-JRR-ADQ-1-10/09/2014*****************************************/



/***********************************I-DEP-RAC-ADQ-1-22/09/2014*****************************************/

CREATE OR REPLACE VIEW adq.vsolicitud_compra(
    id_solicitud,
    id_proveedor,
    desc_proveedor,
    id_moneda,
    id_depto,
    numero,
    fecha_soli,
    estado,
    num_tramite,
    id_gestion,
    justificacion,
    rotulo_comercial,
    id_categoria_compra,
    codigo,
    precio_total,
    precio_total_mb,
    codigo_categoria,
    nombre_categoria,
    id_proceso_wf,
    detalle,
    desc_funcionario1,
    codigo_uo,
    nombre_unidad,
    tipo,
    tipo_concepto,
    nombre_cargo,
    nombre_unidad_cargo,
    email_empresa,
    desc_usuario,
    id_funcionario_supervisor,
    id_funcionario_aprobador)
AS
  SELECT DISTINCT sol.id_solicitud,
         sol.id_proveedor,
         p.desc_proveedor,
         sol.id_moneda,
         sol.id_depto,
         sol.numero,
         sol.fecha_soli,
         sol.estado,
         sol.num_tramite,
         sol.id_gestion,
         sol.justificacion,
         p.rotulo_comercial,
         sol.id_categoria_compra,
         mon.codigo,
         sum(sd.precio_total) AS precio_total,
         sum(sd.precio_unitario_mb * sd.cantidad::numeric) AS precio_total_mb,
         COALESCE(cac.codigo, ''::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, ''::character varying) AS nombre_categoria,
         sol.id_proceso_wf,
         ('<table>'::text || pxp.html_rows((((('<td>'::text || ci.desc_ingas::
           text) || ' <br>'::text) || sd.descripcion) || '</td>'::text)::
           character varying)::text) || '</table>'::text AS detalle,
         fun.desc_funcionario1,
         uo.codigo AS codigo_uo,
         uo.nombre_unidad,
         lower(sol.tipo::text) AS tipo,
         lower(sol.tipo_concepto::text) AS tipo_concepto,
         fun.nombre_cargo,
         fun.nombre_unidad AS nombre_unidad_cargo,
         fun.email_empresa,
         usu.desc_persona AS desc_usuario,
         COALESCE(sol.id_funcionario_supervisor, 0) AS id_funcionario_supervisor
  ,
         COALESCE(sol.id_funcionario_aprobador, 0) AS id_funcionario_aprobador
  FROM adq.tsolicitud sol
       JOIN adq.tsolicitud_det sd ON sd.id_solicitud = sol.id_solicitud
       JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas =
         sd.id_concepto_ingas
       JOIN param.tmoneda mon ON mon.id_moneda = sol.id_moneda
       JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario =
         sol.id_funcionario AND fun.estado_reg_asi::text = 'activo'::text
       JOIN orga.tuo uo ON uo.id_uo = sol.id_uo
       JOIN segu.vusuario usu ON usu.id_usuario = sol.id_usuario_reg
       LEFT JOIN param.vproveedor p ON p.id_proveedor = sol.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
         sol.id_categoria_compra
  WHERE fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion >= sol.fecha_soli OR
        fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion IS NULL
  GROUP BY sol.id_solicitud,
           sol.id_proveedor,
           p.desc_proveedor,
           sol.id_moneda,
           sol.id_depto,
           sol.numero,
           sol.fecha_soli,
           sol.estado,
           sol.num_tramite,
           sol.id_gestion,
           sol.justificacion,
           p.rotulo_comercial,
           sol.id_categoria_compra,
           cac.codigo,
           cac.nombre,
           mon.codigo,
           fun.desc_funcionario1,
           uo.codigo,
           uo.nombre_unidad,
           sol.tipo_concepto,
           sol.tipo,
           fun.nombre_cargo,
           fun.nombre_unidad,
           fun.email_empresa,
           usu.desc_persona;

/***********************************F-DEP-RAC-ADQ-1-22/09/2014*****************************************/


/***********************************I-DEP-RAC-ADQ-1-26/09/2014*****************************************/


CREATE OR REPLACE VIEW adq.vsolicitud_compra(
    id_solicitud,
    id_proveedor,
    desc_proveedor,
    id_moneda,
    id_depto,
    numero,
    fecha_soli,
    estado,
    num_tramite,
    id_gestion,
    justificacion,
    rotulo_comercial,
    id_categoria_compra,
    codigo,
    precio_total,
    precio_total_mb,
    codigo_categoria,
    nombre_categoria,
    id_proceso_wf,
    detalle,
    desc_funcionario1,
    codigo_uo,
    nombre_unidad,
    tipo,
    tipo_concepto,
    nombre_cargo,
    nombre_unidad_cargo,
    email_empresa,
    desc_usuario,
    id_funcionario_supervisor,
    id_funcionario_aprobador)
AS
  SELECT DISTINCT sol.id_solicitud,
         sol.id_proveedor,
         p.desc_proveedor,
         sol.id_moneda,
         sol.id_depto,
         sol.numero,
         sol.fecha_soli,
         sol.estado,
         sol.num_tramite,
         sol.id_gestion,
         sol.justificacion,
         p.rotulo_comercial,
         sol.id_categoria_compra,
         mon.codigo,
         sum(sd.precio_total) AS precio_total,
         sum(sd.precio_unitario_mb * sd.cantidad::numeric) AS precio_total_mb,
         COALESCE(cac.codigo, ''::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, ''::character varying) AS nombre_categoria,
         sol.id_proceso_wf,
         ('<table>'::text || pxp.html_rows((((('<td>'::text || ci.desc_ingas::
           text) || ' <br>'::text) || sd.descripcion) || '</td>'::text)::
           character varying)::text) || '</table>'::text AS detalle,
         fun.desc_funcionario1,
         uo.codigo AS codigo_uo,
         uo.nombre_unidad,
         lower(sol.tipo::text) AS tipo,
         lower(sol.tipo_concepto::text) AS tipo_concepto,
         fun.nombre_cargo,
         fun.nombre_unidad AS nombre_unidad_cargo,
         fun.email_empresa,
         usu.desc_persona AS desc_usuario,
         COALESCE(sol.id_funcionario_supervisor, 0) AS id_funcionario_supervisor
  ,
         COALESCE(sol.id_funcionario_aprobador, 0) AS id_funcionario_aprobador
  FROM adq.tsolicitud sol
       LEFT JOIN adq.tsolicitud_det sd ON sd.id_solicitud = sol.id_solicitud
       LEFT JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas =
         sd.id_concepto_ingas
       JOIN param.tmoneda mon ON mon.id_moneda = sol.id_moneda
       JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario =
         sol.id_funcionario AND fun.estado_reg_asi::text = 'activo'::text
       JOIN orga.tuo uo ON uo.id_uo = sol.id_uo
       JOIN segu.vusuario usu ON usu.id_usuario = sol.id_usuario_reg
       LEFT JOIN param.vproveedor p ON p.id_proveedor = sol.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
         sol.id_categoria_compra
  WHERE fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion >= sol.fecha_soli OR
        fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion IS NULL
  GROUP BY sol.id_solicitud,
           sol.id_proveedor,
           p.desc_proveedor,
           sol.id_moneda,
           sol.id_depto,
           sol.numero,
           sol.fecha_soli,
           sol.estado,
           sol.num_tramite,
           sol.id_gestion,
           sol.justificacion,
           p.rotulo_comercial,
           sol.id_categoria_compra,
           cac.codigo,
           cac.nombre,
           mon.codigo,
           fun.desc_funcionario1,
           uo.codigo,
           uo.nombre_unidad,
           sol.tipo_concepto,
           sol.tipo,
           fun.nombre_cargo,
           fun.nombre_unidad,
           fun.email_empresa,
           usu.desc_persona;
           
/***********************************F-DEP-RAC-ADQ-1-26/09/2014*****************************************/
           

/***********************************I-DEP-RAC-ADQ-1-29/09/2014*****************************************/
 
--------------- SQL ---------------

CREATE OR REPLACE VIEW adq.vsolicitud_compra(
    id_solicitud,
    id_proveedor,
    desc_proveedor,
    id_moneda,
    id_depto,
    numero,
    fecha_soli,
    estado,
    num_tramite,
    id_gestion,
    justificacion,
    rotulo_comercial,
    id_categoria_compra,
    codigo,
    precio_total,
    precio_total_mb,
    codigo_categoria,
    nombre_categoria,
    id_proceso_wf,
    detalle,
    desc_funcionario1,
    codigo_uo,
    nombre_unidad,
    tipo,
    tipo_concepto,
    nombre_cargo,
    nombre_unidad_cargo,
    email_empresa,
    desc_usuario,
    id_funcionario_supervisor,
    id_funcionario_aprobador)
AS
  SELECT DISTINCT sol.id_solicitud,
         sol.id_proveedor,
         p.desc_proveedor,
         sol.id_moneda,
         sol.id_depto,
         sol.numero,
         sol.fecha_soli,
         sol.estado,
         sol.num_tramite,
         sol.id_gestion,
         sol.justificacion,
         p.rotulo_comercial,
         sol.id_categoria_compra,
         mon.codigo,
         COALESCE(sum(sd.precio_total),0) AS precio_total,
         COALESCE(sum(sd.precio_unitario_mb * sd.cantidad::numeric),0) AS precio_total_mb,
         COALESCE(cac.codigo, ''::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, ''::character varying) AS nombre_categoria,
         sol.id_proceso_wf,
         ('<table>'::text || pxp.html_rows((((('<td>'::text || ci.desc_ingas::
           text) || ' <br>'::text) || sd.descripcion) || '</td>'::text)::
           character varying)::text) || '</table>'::text AS detalle,
         fun.desc_funcionario1,
         uo.codigo AS codigo_uo,
         uo.nombre_unidad,
         lower(sol.tipo::text) AS tipo,
         lower(sol.tipo_concepto::text) AS tipo_concepto,
         fun.nombre_cargo,
         fun.nombre_unidad AS nombre_unidad_cargo,
         fun.email_empresa,
         usu.desc_persona AS desc_usuario,
         COALESCE(sol.id_funcionario_supervisor, 0) AS id_funcionario_supervisor
  ,
         COALESCE(sol.id_funcionario_aprobador, 0) AS id_funcionario_aprobador
  FROM adq.tsolicitud sol
       LEFT JOIN adq.tsolicitud_det sd ON sd.id_solicitud = sol.id_solicitud
       LEFT JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas =
         sd.id_concepto_ingas
       JOIN param.tmoneda mon ON mon.id_moneda = sol.id_moneda
       JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario =
         sol.id_funcionario AND fun.estado_reg_asi::text = 'activo'::text
       JOIN orga.tuo uo ON uo.id_uo = sol.id_uo
       JOIN segu.vusuario usu ON usu.id_usuario = sol.id_usuario_reg
       LEFT JOIN param.vproveedor p ON p.id_proveedor = sol.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
         sol.id_categoria_compra
  WHERE fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion >= sol.fecha_soli OR
        fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion IS NULL
  GROUP BY sol.id_solicitud,
           sol.id_proveedor,
           p.desc_proveedor,
           sol.id_moneda,
           sol.id_depto,
           sol.numero,
           sol.fecha_soli,
           sol.estado,
           sol.num_tramite,
           sol.id_gestion,
           sol.justificacion,
           p.rotulo_comercial,
           sol.id_categoria_compra,
           cac.codigo,
           cac.nombre,
           mon.codigo,
           fun.desc_funcionario1,
           uo.codigo,
           uo.nombre_unidad,
           sol.tipo_concepto,
           sol.tipo,
           fun.nombre_cargo,
           fun.nombre_unidad,
           fun.email_empresa,
           usu.desc_persona;

/***********************************F-DEP-RAC-ADQ-1-29/09/2014*****************************************/
/***********************************I-DEP-JRR-ADQ-1-01/10/2014*****************************************/

 -- object recreation
DROP VIEW adq.vcotizacion;

CREATE VIEW adq.vcotizacion(
    id_cotizacion,
    numero_oc,
    codigo_proceso,
    num_cotizacion,
    id_solicitud,
    id_proveedor,
    desc_proveedor,
    id_moneda,
    id_depto,
    numero,
    fecha_soli,
    estado,
    num_tramite,
    id_gestion,
    justificacion,
    rotulo_comercial,
    id_categoria_compra,
    codigo,
    precio_total,
    precio_total_mb,
    monto_total_adjudicado,
    monto_total_adjudicado_mb,
    codigo_categoria,
    nombre_categoria,
    id_proceso_wf_sol,
    id_proceso_wf,
    detalle,
    desc_funcionario1,
    codigo_uo,
    nombre_unidad,
    tipo,
    tipo_concepto,
    nombre_cargo,
    nombre_unidad_cargo,
    requiere_contrato,
    nro_contrato)
AS
  SELECT DISTINCT cot.id_cotizacion,
         cot.numero_oc,
         pro.codigo_proceso,
         pro.num_cotizacion,
         sol.id_solicitud,
         p.id_proveedor,
         p.desc_proveedor,
         sol.id_moneda,
         sol.id_depto,
         sol.numero,
         sol.fecha_soli,
         sol.estado,
         sol.num_tramite,
         sol.id_gestion,
         sol.justificacion,
         p.rotulo_comercial,
         sol.id_categoria_compra,
         mon.codigo,
         COALESCE(sum(sd.precio_total), 0::numeric) AS precio_total,
         COALESCE(sum(sd.precio_unitario_mb * sd.cantidad::numeric), 0::numeric)
          AS precio_total_mb,
         COALESCE(sum(cd.cantidad_adju * cd.precio_unitario), 0::numeric) AS
          monto_total_adjudicado,
         COALESCE(sum(cd.cantidad_adju * cd.precio_unitario_mb), 0::numeric) AS
          monto_total_adjudicado_mb,
         COALESCE(cac.codigo, '' ::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, '' ::character varying) AS nombre_categoria,
         sol.id_proceso_wf AS id_proceso_wf_sol,
         cot.id_proceso_wf,
         ('<table>' ::text || pxp.html_rows((((('<td>' ::text ||
          ci.desc_ingas::text) || ' <br>' ::text) || sd.descripcion) || '</td>'
           ::text) ::character varying) ::text) || '</table>' ::text AS detalle,
         fun.desc_funcionario1,
         uo.codigo AS codigo_uo,
         uo.nombre_unidad,
         lower(sol.tipo::text) AS tipo,
         lower(sol.tipo_concepto::text) AS tipo_concepto,
         fun.nombre_cargo,
         fun.nombre_unidad AS nombre_unidad_cargo,
         cot.requiere_contrato,
         cot.nro_contrato
  FROM adq.tcotizacion cot
       JOIN adq.tproceso_compra pro ON pro.id_proceso_compra =
        cot.id_proceso_compra
       JOIN adq.tsolicitud sol ON sol.id_solicitud = pro.id_solicitud
       LEFT JOIN adq.tcotizacion_det cd ON cd.id_cotizacion = cot.id_cotizacion
       LEFT JOIN adq.tsolicitud_det sd ON sd.id_solicitud_det =
        cd.id_solicitud_det
       LEFT JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas =
        sd.id_concepto_ingas
       JOIN param.tmoneda mon ON mon.id_moneda = sol.id_moneda
       JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario =
        sol.id_funcionario AND fun.estado_reg_asi::text = 'activo' ::text
       JOIN orga.tuo uo ON uo.id_uo = sol.id_uo
       JOIN param.vproveedor p ON p.id_proveedor = cot.id_proveedor
       JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
        sol.id_categoria_compra
  WHERE fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion >= sol.fecha_soli OR
        fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion IS NULL
  GROUP BY cot.id_cotizacion,
           cot.numero_oc,
           pro.codigo_proceso,
           pro.num_cotizacion,
           sol.id_solicitud,
           p.id_proveedor,
           p.desc_proveedor,
           sol.id_moneda,
           sol.id_depto,
           sol.numero,
           sol.fecha_soli,
           sol.estado,
           sol.num_tramite,
           sol.id_gestion,
           sol.justificacion,
           p.rotulo_comercial,
           sol.id_categoria_compra,
           cac.codigo,
           cac.nombre,
           mon.codigo,
           fun.desc_funcionario1,
           uo.codigo,
           uo.nombre_unidad,
           sol.tipo_concepto,
           sol.tipo,
           fun.nombre_cargo,
           fun.nombre_unidad,
           cot.requiere_contrato,
           cot.nro_contrato;

/***********************************F-DEP-JRR-ADQ-1-01/10/2014*****************************************/






/***********************************I-DEP-RAC-ADQ-1-03/10/2014*****************************************/


--------------- SQL ---------------

CREATE OR REPLACE VIEW adq.vsolicitud_compra(
    id_solicitud,
    id_proveedor,
    desc_proveedor,
    id_moneda,
    id_depto,
    numero,
    fecha_soli,
    estado,
    num_tramite,
    id_gestion,
    justificacion,
    rotulo_comercial,
    id_categoria_compra,
    codigo,
    precio_total,
    precio_total_mb,
    codigo_categoria,
    nombre_categoria,
    id_proceso_wf,
    detalle,
    desc_funcionario1,
    codigo_uo,
    nombre_unidad,
    tipo,
    tipo_concepto,
    nombre_cargo,
    nombre_unidad_cargo,
    email_empresa,
    desc_usuario,
    id_funcionario_supervisor,
    id_funcionario_aprobador)
AS
  SELECT DISTINCT sol.id_solicitud,
         sol.id_proveedor,
         p.desc_proveedor,
         sol.id_moneda,
         sol.id_depto,
         sol.numero,
         sol.fecha_soli,
         sol.estado,
         sol.num_tramite,
         sol.id_gestion,
         sol.justificacion,
         p.rotulo_comercial,
         sol.id_categoria_compra,
         mon.codigo,
         COALESCE(sum(sd.precio_total), 0::numeric) AS precio_total,
         COALESCE(sum(sd.precio_unitario_mb * sd.cantidad::numeric), 0::numeric)
           AS precio_total_mb,
         COALESCE(cac.codigo, ''::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, ''::character varying) AS nombre_categoria,
         sol.id_proceso_wf,
         ('<table>'::text || pxp.html_rows((((('<td>'::text || ci.desc_ingas::
           text) || ' <br>'::text) || sd.descripcion) || '</td>'::text)::
           character varying)::text) || '</table>'::text AS detalle,
         fun.desc_funcionario1,
         uo.codigo AS codigo_uo,
         uo.nombre_unidad,
         lower(sol.tipo::text) AS tipo,
         lower(sol.tipo_concepto::text) AS tipo_concepto,
         fun.nombre_cargo,
         fun.nombre_unidad AS nombre_unidad_cargo,
         fun.email_empresa,
         usu.desc_persona AS desc_usuario,
         COALESCE(sol.id_funcionario_supervisor, 0) AS id_funcionario_supervisor
  ,
         COALESCE(sol.id_funcionario_aprobador, 0) AS id_funcionario_aprobador
  FROM adq.tsolicitud sol
       LEFT JOIN adq.tsolicitud_det sd ON sd.id_solicitud = sol.id_solicitud and  sd.estado_reg = 'activo'
       LEFT JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas =
         sd.id_concepto_ingas
       JOIN param.tmoneda mon ON mon.id_moneda = sol.id_moneda
       JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario =
         sol.id_funcionario AND fun.estado_reg_asi::text = 'activo'::text
       JOIN orga.tuo uo ON uo.id_uo = sol.id_uo
       JOIN segu.vusuario usu ON usu.id_usuario = sol.id_usuario_reg
       LEFT JOIN param.vproveedor p ON p.id_proveedor = sol.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
         sol.id_categoria_compra
  WHERE fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion >= sol.fecha_soli OR
        fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion IS NULL
  GROUP BY sol.id_solicitud,
           sol.id_proveedor,
           p.desc_proveedor,
           sol.id_moneda,
           sol.id_depto,
           sol.numero,
           sol.fecha_soli,
           sol.estado,
           sol.num_tramite,
           sol.id_gestion,
           sol.justificacion,
           p.rotulo_comercial,
           sol.id_categoria_compra,
           cac.codigo,
           cac.nombre,
           mon.codigo,
           fun.desc_funcionario1,
           uo.codigo,
           uo.nombre_unidad,
           sol.tipo_concepto,
           sol.tipo,
           fun.nombre_cargo,
           fun.nombre_unidad,
           fun.email_empresa,
           usu.desc_persona;


/***********************************F-DEP-RAC-ADQ-1-03/10/2014*****************************************/
 

/***********************************I-DEP-RAC-ADQ-1-21/10/2014*****************************************/

CREATE OR REPLACE VIEW adq.vsolicitud_compra(
    id_solicitud,
    id_proveedor,
    desc_proveedor,
    id_moneda,
    id_depto,
    numero,
    fecha_soli,
    estado,
    num_tramite,
    id_gestion,
    justificacion,
    rotulo_comercial,
    id_categoria_compra,
    codigo,
    precio_total,
    precio_total_mb,
    codigo_categoria,
    nombre_categoria,
    id_proceso_wf,
    detalle,
    desc_funcionario1,
    codigo_uo,
    nombre_unidad,
    tipo,
    tipo_concepto,
    nombre_cargo,
    nombre_unidad_cargo,
    email_empresa,
    desc_usuario,
    id_funcionario_supervisor,
    id_funcionario_aprobador)
AS
  SELECT DISTINCT sol.id_solicitud,
         sol.id_proveedor,
         p.desc_proveedor,
         sol.id_moneda,
         sol.id_depto,
         sol.numero,
         sol.fecha_soli,
         sol.estado,
         sol.num_tramite,
         sol.id_gestion,
         sol.justificacion,
         p.rotulo_comercial,
         sol.id_categoria_compra,
         mon.codigo,
         COALESCE(sum(sd.precio_total), 0::numeric) AS precio_total,
         COALESCE(sum(sd.precio_unitario_mb * sd.cantidad::numeric), 0::numeric)
           AS precio_total_mb,
         COALESCE(cac.codigo, ''::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, ''::character varying) AS nombre_categoria,
         sol.id_proceso_wf,
         ('<table>'::text || pxp.html_rows((((('<td>'::text || ci.desc_ingas::
           text) || ' <br>'::text) || sd.descripcion) || '</td>'::text)::
           character varying)::text) || '</table>'::text AS detalle,
         fun.desc_funcionario1,
         uo.codigo AS codigo_uo,
         uo.nombre_unidad,
         lower(sol.tipo::text) AS tipo,
         lower(sol.tipo_concepto::text) AS tipo_concepto,
         fun.nombre_cargo,
         fun.nombre_unidad AS nombre_unidad_cargo,
         fun.email_empresa,
         usu.desc_persona AS desc_usuario,
         COALESCE(sol.id_funcionario_supervisor, 0) AS id_funcionario_supervisor
  ,
         COALESCE(sol.id_funcionario_aprobador, 0) AS id_funcionario_aprobador
  FROM adq.tsolicitud sol
       LEFT JOIN adq.tsolicitud_det sd ON sd.id_solicitud = sol.id_solicitud AND
         sd.estado_reg::text = 'activo'::text
       LEFT JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas =
         sd.id_concepto_ingas
       JOIN param.tmoneda mon ON mon.id_moneda = sol.id_moneda
       JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario =
         sol.id_funcionario AND fun.estado_reg_asi::text = 'activo'::text
       JOIN orga.tuo uo ON uo.id_uo = sol.id_uo
       JOIN segu.vusuario usu ON usu.id_usuario = sol.id_usuario_reg
       LEFT JOIN param.vproveedor p ON p.id_proveedor = sol.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
         sol.id_categoria_compra
  WHERE fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion >= sol.fecha_soli OR
        fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion IS NULL
  GROUP BY sol.id_solicitud,
           sol.id_proveedor,
           p.desc_proveedor,
           sol.id_moneda,
           sol.id_depto,
           sol.numero,
           sol.fecha_soli,
           sol.estado,
           sol.num_tramite,
           sol.id_gestion,
           sol.justificacion,
           p.rotulo_comercial,
           sol.id_categoria_compra,
           cac.codigo,
           cac.nombre,
           mon.codigo,
           fun.desc_funcionario1,
           uo.codigo,
           uo.nombre_unidad,
           sol.tipo_concepto,
           sol.tipo,
           fun.nombre_cargo,
           fun.nombre_unidad,
           fun.email_empresa,
           usu.desc_persona;
           
           
           
           
     CREATE OR REPLACE VIEW adq.vcotizacion(
    id_cotizacion,
    numero_oc,
    codigo_proceso,
    num_cotizacion,
    id_solicitud,
    id_proveedor,
    desc_proveedor,
    id_moneda,
    id_depto,
    numero,
    fecha_soli,
    estado,
    num_tramite,
    id_gestion,
    justificacion,
    rotulo_comercial,
    id_categoria_compra,
    codigo,
    precio_total,
    precio_total_mb,
    monto_total_adjudicado,
    monto_total_adjudicado_mb,
    codigo_categoria,
    nombre_categoria,
    id_proceso_wf_sol,
    id_proceso_wf,
    detalle,
    desc_funcionario1,
    codigo_uo,
    nombre_unidad,
    tipo,
    tipo_concepto,
    nombre_cargo,
    nombre_unidad_cargo,
    requiere_contrato,
    nro_contrato)
AS
  SELECT DISTINCT cot.id_cotizacion,
         cot.numero_oc,
         pro.codigo_proceso,
         pro.num_cotizacion,
         sol.id_solicitud,
         p.id_proveedor,
         p.desc_proveedor,
         sol.id_moneda,
         sol.id_depto,
         sol.numero,
         sol.fecha_soli,
         sol.estado,
         sol.num_tramite,
         sol.id_gestion,
         sol.justificacion,
         p.rotulo_comercial,
         sol.id_categoria_compra,
         mon.codigo,
         COALESCE(sum(sd.precio_total), 0::numeric) AS precio_total,
         COALESCE(sum(sd.precio_unitario_mb * sd.cantidad::numeric), 0::numeric)
           AS precio_total_mb,
         COALESCE(sum(cd.cantidad_adju * cd.precio_unitario), 0::numeric) AS
           monto_total_adjudicado,
         COALESCE(sum(cd.cantidad_adju * cd.precio_unitario_mb), 0::numeric) AS
           monto_total_adjudicado_mb,
         COALESCE(cac.codigo, ''::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, ''::character varying) AS nombre_categoria,
         sol.id_proceso_wf AS id_proceso_wf_sol,
         cot.id_proceso_wf,
         ('<table>'::text || pxp.html_rows((((('<td>'::text || ci.desc_ingas::
           text) || ' <br>'::text) || sd.descripcion) || '</td>'::text)::
           character varying)::text) || '</table>'::text AS detalle,
         fun.desc_funcionario1,
         uo.codigo AS codigo_uo,
         uo.nombre_unidad,
         lower(sol.tipo::text) AS tipo,
         lower(sol.tipo_concepto::text) AS tipo_concepto,
         fun.nombre_cargo,
         fun.nombre_unidad AS nombre_unidad_cargo,
         cot.requiere_contrato,
         cot.nro_contrato
  FROM adq.tcotizacion cot
       JOIN adq.tproceso_compra pro ON pro.id_proceso_compra =
         cot.id_proceso_compra
       JOIN adq.tsolicitud sol ON sol.id_solicitud = pro.id_solicitud
       LEFT JOIN adq.tcotizacion_det cd ON cd.id_cotizacion = cot.id_cotizacion
       LEFT JOIN adq.tsolicitud_det sd ON sd.id_solicitud_det =
         cd.id_solicitud_det
       LEFT JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas =
         sd.id_concepto_ingas
       JOIN param.tmoneda mon ON mon.id_moneda = sol.id_moneda
       JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario =
         sol.id_funcionario AND fun.estado_reg_asi::text = 'activo'::text
       JOIN orga.tuo uo ON uo.id_uo = sol.id_uo
       JOIN param.vproveedor p ON p.id_proveedor = cot.id_proveedor
       JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
         sol.id_categoria_compra
  WHERE fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion >= sol.fecha_soli OR
        fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion IS NULL
  GROUP BY cot.id_cotizacion,
           cot.numero_oc,
           pro.codigo_proceso,
           pro.num_cotizacion,
           sol.id_solicitud,
           p.id_proveedor,
           p.desc_proveedor,
           sol.id_moneda,
           sol.id_depto,
           sol.numero,
           sol.fecha_soli,
           sol.estado,
           sol.num_tramite,
           sol.id_gestion,
           sol.justificacion,
           p.rotulo_comercial,
           sol.id_categoria_compra,
           cac.codigo,
           cac.nombre,
           mon.codigo,
           fun.desc_funcionario1,
           uo.codigo,
           uo.nombre_unidad,
           sol.tipo_concepto,
           sol.tipo,
           fun.nombre_cargo,
           fun.nombre_unidad,
           cot.requiere_contrato,
           cot.nro_contrato;
           
           
           
           CREATE OR REPLACE VIEW adq.vproceso_compra(
    id_proceso_compra,
    id_depto,
    num_convocatoria,
    id_solicitud,
    id_estado_wf,
    fecha_ini_proc,
    obs_proceso,
    id_proceso_wf,
    num_tramite,
    codigo_proceso,
    estado_reg,
    estado,
    num_cotizacion,
    id_usuario_reg,
    fecha_reg,
    fecha_mod,
    id_usuario_mod,
    usr_reg,
    usr_mod,
    desc_depto,
    desc_funcionario,
    desc_solicitud,
    desc_moneda,
    instruc_rpc,
    id_categoria_compra,
    usr_aux,
    id_moneda,
    id_funcionario,
    id_usuario_auxiliar,
    desc_cotizacion)
AS
  SELECT proc.id_proceso_compra,
         proc.id_depto,
         proc.num_convocatoria,
         proc.id_solicitud,
         proc.id_estado_wf,
         proc.fecha_ini_proc,
         proc.obs_proceso,
         proc.id_proceso_wf,
         proc.num_tramite,
         proc.codigo_proceso,
         proc.estado_reg,
         proc.estado,
         proc.num_cotizacion,
         proc.id_usuario_reg,
         proc.fecha_reg,
         proc.fecha_mod,
         proc.id_usuario_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         dep.codigo AS desc_depto,
         fun.desc_funcionario1 AS desc_funcionario,
         sol.numero AS desc_solicitud,
         mon.codigo AS desc_moneda,
         sol.instruc_rpc,
         sol.id_categoria_compra,
         usua.cuenta AS usr_aux,
         sol.id_moneda,
         sol.id_funcionario,
         proc.id_usuario_auxiliar,
         adq.f_get_desc_cotizaciones(proc.id_proceso_compra) AS desc_cotizacion
  FROM adq.tproceso_compra proc
       JOIN segu.tusuario usu1 ON usu1.id_usuario = proc.id_usuario_reg
       JOIN param.tdepto dep ON dep.id_depto = proc.id_depto
       JOIN adq.tsolicitud sol ON sol.id_solicitud = proc.id_solicitud
       JOIN orga.vfuncionario fun ON fun.id_funcionario = sol.id_funcionario
       JOIN param.tmoneda mon ON mon.id_moneda = sol.id_moneda
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = proc.id_usuario_mod
       LEFT JOIN segu.tusuario usua ON usua.id_usuario =
         proc.id_usuario_auxiliar;   
         
         
         
         
         CREATE OR REPLACE VIEW adq.vproceso_compra_wf(
    id_proceso_compra,
    codigo_proceso,
    num_cotizacion,
    id_solicitud,
    id_proveedor_solicitud,
    des_proveedor_solicitud,
    id_moneda,
    id_depto,
    numero,
    fecha_soli,
    estado,
    num_tramite,
    id_gestion,
    justificacion,
    rotulo_comercial,
    id_categoria_compra,
    codigo,
    precio_total,
    precio_total_mb,
    codigo_categoria,
    nombre_categoria,
    id_proceso_wf_sol,
    id_proceso_wf,
    detalle,
    desc_funcionario1,
    codigo_uo,
    nombre_unidad,
    tipo,
    tipo_concepto,
    nombre_cargo,
    nombre_unidad_cargo)
AS
  SELECT DISTINCT pro.id_proceso_compra,
         pro.codigo_proceso,
         pro.num_cotizacion,
         sol.id_solicitud,
         p.id_proveedor AS id_proveedor_solicitud,
         p.desc_proveedor AS des_proveedor_solicitud,
         sol.id_moneda,
         sol.id_depto,
         sol.numero,
         sol.fecha_soli,
         sol.estado,
         sol.num_tramite,
         sol.id_gestion,
         sol.justificacion,
         p.rotulo_comercial,
         sol.id_categoria_compra,
         mon.codigo,
         sum(sd.precio_total) AS precio_total,
         sum(sd.precio_unitario_mb * sd.cantidad::numeric) AS precio_total_mb,
         COALESCE(cac.codigo, ''::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, ''::character varying) AS nombre_categoria,
         sol.id_proceso_wf AS id_proceso_wf_sol,
         pro.id_proceso_wf,
         ('<table>'::text || pxp.html_rows((((('<td>'::text || ci.desc_ingas::
           text) || ' <br>'::text) || sd.descripcion) || '</td>'::text)::
           character varying)::text) || '</table>'::text AS detalle,
         fun.desc_funcionario1,
         uo.codigo AS codigo_uo,
         uo.nombre_unidad,
         lower(sol.tipo::text) AS tipo,
         lower(sol.tipo_concepto::text) AS tipo_concepto,
         fun.nombre_cargo,
         fun.nombre_unidad AS nombre_unidad_cargo
  FROM adq.tproceso_compra pro
       JOIN adq.tsolicitud sol ON sol.id_solicitud = pro.id_solicitud
       JOIN adq.tsolicitud_det sd ON sd.id_solicitud = sol.id_solicitud
       JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas =
         sd.id_concepto_ingas
       JOIN param.tmoneda mon ON mon.id_moneda = sol.id_moneda
       JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario =
         sol.id_funcionario AND fun.estado_reg_asi::text = 'activo'::text
       JOIN orga.tuo uo ON uo.id_uo = sol.id_uo
       JOIN param.vproveedor p ON p.id_proveedor = sol.id_proveedor
       JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
         sol.id_categoria_compra
  WHERE fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion >= sol.fecha_soli OR
        fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion IS NULL
  GROUP BY pro.id_proceso_compra,
           pro.codigo_proceso,
           pro.num_cotizacion,
           sol.id_solicitud,
           p.id_proveedor,
           p.desc_proveedor,
           sol.id_moneda,
           sol.id_depto,
           sol.numero,
           sol.fecha_soli,
           sol.estado,
           sol.num_tramite,
           sol.id_gestion,
           sol.justificacion,
           p.rotulo_comercial,
           sol.id_categoria_compra,
           cac.codigo,
           cac.nombre,
           mon.codigo,
           fun.desc_funcionario1,
           uo.codigo,
           uo.nombre_unidad,
           sol.tipo_concepto,
           sol.tipo,
           fun.nombre_cargo,
           fun.nombre_unidad;   

/***********************************F-DEP-RAC-ADQ-1-21/10/2014*****************************************/
 



/***********************************I-DEP-RAC-ADQ-1-29/12/2014*****************************************/
 

--------------- SQL ---------------

CREATE OR REPLACE VIEW adq.vproceso_compra(
    id_proceso_compra,
    id_depto,
    num_convocatoria,
    id_solicitud,
    id_estado_wf,
    fecha_ini_proc,
    obs_proceso,
    id_proceso_wf,
    num_tramite,
    codigo_proceso,
    estado_reg,
    estado,
    num_cotizacion,
    id_usuario_reg,
    fecha_reg,
    fecha_mod,
    id_usuario_mod,
    usr_reg,
    usr_mod,
    desc_depto,
    desc_funcionario,
    desc_solicitud,
    desc_moneda,
    instruc_rpc,
    id_categoria_compra,
    usr_aux,
    id_moneda,
    id_funcionario,
    id_usuario_auxiliar,
    desc_cotizacion,
    objeto)
AS
  SELECT proc.id_proceso_compra,
         proc.id_depto,
         proc.num_convocatoria,  
         proc.id_solicitud,
         proc.id_estado_wf,
         proc.fecha_ini_proc,
         proc.obs_proceso,
         proc.id_proceso_wf,
         proc.num_tramite,
         proc.codigo_proceso,
         proc.estado_reg,
         proc.estado,
         proc.num_cotizacion,
         proc.id_usuario_reg,
         proc.fecha_reg,
         proc.fecha_mod,
         proc.id_usuario_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         dep.codigo AS desc_depto,
         fun.desc_funcionario1 AS desc_funcionario,
         sol.numero AS desc_solicitud,
         mon.codigo AS desc_moneda,
         sol.instruc_rpc,
         sol.id_categoria_compra,
         usua.cuenta AS usr_aux,
         sol.id_moneda,
         sol.id_funcionario,
         proc.id_usuario_auxiliar,
         adq.f_get_desc_cotizaciones(proc.id_proceso_compra) AS desc_cotizacion,
         proc.objeto
  FROM adq.tproceso_compra proc
       JOIN segu.tusuario usu1 ON usu1.id_usuario = proc.id_usuario_reg
       JOIN param.tdepto dep ON dep.id_depto = proc.id_depto
       JOIN adq.tsolicitud sol ON sol.id_solicitud = proc.id_solicitud
       JOIN orga.vfuncionario fun ON fun.id_funcionario = sol.id_funcionario
       JOIN param.tmoneda mon ON mon.id_moneda = sol.id_moneda
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = proc.id_usuario_mod
       LEFT JOIN segu.tusuario usua ON usua.id_usuario =
         proc.id_usuario_auxiliar;


/***********************************F-DEP-RAC-ADQ-1-29/12/2014*****************************************/
 


/***********************************I-DEP-RAC-ADQ-1-04/03/2015*****************************************/
 

--------------- SQL ---------------

 -- object recreation
DROP VIEW adq.vsolicitud_compra;

CREATE VIEW adq.vsolicitud_compra
AS
  SELECT DISTINCT sol.id_solicitud,
         sol.id_proveedor,
         p.desc_proveedor,
         sol.id_moneda,
         sol.id_depto,
         sol.numero,
         sol.fecha_soli,
         sol.estado,
         sol.num_tramite,
         sol.id_gestion,
         sol.justificacion,
         p.rotulo_comercial,
         sol.id_categoria_compra,
         mon.codigo,
         COALESCE(sum(sd.precio_total), 0::numeric) AS precio_total,
         COALESCE(sum(sd.precio_unitario_mb * sd.cantidad::numeric), 0::numeric)
           AS precio_total_mb,
         COALESCE(cac.codigo, ''::character varying) AS codigo_categoria,
         COALESCE(cac.nombre, ''::character varying) AS nombre_categoria,
         sol.id_proceso_wf,
         ('<table>'::text || pxp.html_rows((((('<td>'::text || ci.desc_ingas::
           text) || ' <br>'::text) || sd.descripcion) || '</td>'::text)::
           character varying)::text) || '</table>'::text AS detalle,
         fun.desc_funcionario1,
         uo.codigo AS codigo_uo,
         uo.nombre_unidad,
         lower(sol.tipo::text) AS tipo,
         lower(sol.tipo_concepto::text) AS tipo_concepto,
         fun.nombre_cargo,
         fun.nombre_unidad AS nombre_unidad_cargo,
         fun.email_empresa,
         usu.desc_persona AS desc_usuario,
         COALESCE(sol.id_funcionario_supervisor, 0) AS id_funcionario_supervisor
  ,
         COALESCE(sol.id_funcionario_aprobador, 0) AS id_funcionario_aprobador,
         dep.prioridad,
         dep.nombre as nombre_depto
  FROM adq.tsolicitud sol
       LEFT JOIN adq.tsolicitud_det sd ON sd.id_solicitud = sol.id_solicitud AND
         sd.estado_reg::text = 'activo'::text
       LEFT JOIN param.tconcepto_ingas ci ON ci.id_concepto_ingas =
         sd.id_concepto_ingas
       JOIN param.tmoneda mon ON mon.id_moneda = sol.id_moneda
       JOIN param.tdepto dep on dep.id_depto = sol.id_depto
       JOIN orga.vfuncionario_cargo fun ON fun.id_funcionario =
         sol.id_funcionario AND fun.estado_reg_asi::text = 'activo'::text
       JOIN orga.tuo uo ON uo.id_uo = sol.id_uo
       JOIN segu.vusuario usu ON usu.id_usuario = sol.id_usuario_reg
       LEFT JOIN param.vproveedor p ON p.id_proveedor = sol.id_proveedor
       LEFT JOIN adq.tcategoria_compra cac ON cac.id_categoria_compra =
         sol.id_categoria_compra
  WHERE fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion >= sol.fecha_soli OR
        fun.fecha_asignacion <= sol.fecha_soli AND
        fun.fecha_finalizacion IS NULL
  GROUP BY sol.id_solicitud,
           sol.id_proveedor,
           p.desc_proveedor,
           sol.id_moneda,
           sol.id_depto,
           sol.numero,
           sol.fecha_soli,
           sol.estado,
           sol.num_tramite,
           sol.id_gestion,
           sol.justificacion,
           p.rotulo_comercial,
           sol.id_categoria_compra,
           cac.codigo,
           cac.nombre,
           mon.codigo,
           fun.desc_funcionario1,
           uo.codigo,
           uo.nombre_unidad,
           sol.tipo_concepto,
           sol.tipo,
           fun.nombre_cargo,
           fun.nombre_unidad,
           fun.email_empresa,
           usu.desc_persona,
           dep.prioridad,
           dep.nombre;

ALTER TABLE adq.vsolicitud_compra
  OWNER TO postgres;
/***********************************F-DEP-RAC-ADQ-1-04/03/2015*****************************************/

/***********************************I-DEP-RAC-ADQ-1-11/03/2015*****************************************/
 
CREATE OR REPLACE VIEW adq.vproceso_compra(
    id_proceso_compra,
    id_depto,
    num_convocatoria,
    id_solicitud,
    id_estado_wf,
    fecha_ini_proc,
    obs_proceso,
    id_proceso_wf,
    num_tramite,
    codigo_proceso,
    estado_reg,
    estado,
    num_cotizacion,
    id_usuario_reg,
    fecha_reg,
    fecha_mod,
    id_usuario_mod,
    usr_reg,
    usr_mod,
    desc_depto,
    desc_funcionario,
    desc_solicitud,
    desc_moneda,
    instruc_rpc,
    id_categoria_compra,
    usr_aux,
    id_moneda,
    id_funcionario,
    id_usuario_auxiliar,
    objeto,
    estados_cotizacion,
    numeros_oc,
    array_estados_cot,
    proveedores_cot)
AS
 WITH cotizaciones AS (
SELECT cot_1.id_proceso_compra,
            count(cot_1.id_cotizacion) AS cantidad_cotizacion,
            pxp.list(cot_1.estado::text) AS estados_cotizacion,
            pxp.list(cot_1.numero_oc::text) AS numeros_oc,
            pxp.list(prov.desc_proveedor::text) AS proveedores_cot
FROM adq.tcotizacion cot_1
             JOIN param.vproveedor prov ON prov.id_proveedor = cot_1.id_proveedor
WHERE cot_1.estado_reg::text = 'activo'::text
GROUP BY cot_1.id_proceso_compra
        )
    SELECT proc.id_proceso_compra,
    proc.id_depto,
    proc.num_convocatoria,
    proc.id_solicitud,
    proc.id_estado_wf,
    proc.fecha_ini_proc,
    proc.obs_proceso,
    proc.id_proceso_wf,
    proc.num_tramite,
    proc.codigo_proceso,
    proc.estado_reg,
    proc.estado,
    proc.num_cotizacion,
    proc.id_usuario_reg,
    proc.fecha_reg,
    proc.fecha_mod,
    proc.id_usuario_mod,
    usu1.cuenta AS usr_reg,
    usu2.cuenta AS usr_mod,
    dep.codigo AS desc_depto,
    fun.desc_funcionario1 AS desc_funcionario,
    sol.numero AS desc_solicitud,
    mon.codigo AS desc_moneda,
    sol.instruc_rpc,
    sol.id_categoria_compra,
    usua.cuenta AS usr_aux,
    sol.id_moneda,
    sol.id_funcionario,
    proc.id_usuario_auxiliar,
    proc.objeto,
    cot.estados_cotizacion,
    cot.numeros_oc,
    string_to_array(cot.estados_cotizacion, ','::text) AS array_estados_cot,
    cot.proveedores_cot
    FROM adq.tproceso_compra proc
     JOIN segu.tusuario usu1 ON usu1.id_usuario = proc.id_usuario_reg
     JOIN param.tdepto dep ON dep.id_depto = proc.id_depto
     JOIN adq.tsolicitud sol ON sol.id_solicitud = proc.id_solicitud
     JOIN orga.vfuncionario fun ON fun.id_funcionario = sol.id_funcionario
     JOIN param.tmoneda mon ON mon.id_moneda = sol.id_moneda
     LEFT JOIN cotizaciones cot ON cot.id_proceso_compra = proc.id_proceso_compra
     LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = proc.id_usuario_mod
     LEFT JOIN segu.tusuario usua ON usua.id_usuario = proc.id_usuario_auxiliar;
/***********************************F-DEP-RAC-ADQ-1-11/03/2015*****************************************/

 