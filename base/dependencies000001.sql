

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
