/********************************************I-DAUP-AUTOR-SCHEMA-0-31/02/2019********************************************/
--SHEMA : Esquema (CONTA) contabilidad         AUTHOR:Siglas del autor de los scripts' dataupdate000001.txt
/********************************************F-DAUP-AUTOR-SCHEMA-0-31/02/2019********************************************/
/********************************************I-DAUP-EGS-ADQ-0-16/10/2020********************************************/
--Dato original
-- update adq.tsolicitud set
--     id_depto=16
-- WHERE id_solicitud = 6273;
--Cambio
update adq.tsolicitud set
    id_depto=5
WHERE id_solicitud = 6273;
/********************************************F-DAUP-EGS-ADQ-0-16/10/2020********************************************/

/********************************************I-DAUP-EGS-ADQ-1-16/10/2020********************************************/
--Dato original
-- update adq.tsolicitud set
--     id_depto=16
-- WHERE id_solicitud = 6272;
--Cambio
update adq.tsolicitud set
    id_depto=5
WHERE id_solicitud = 6272;
/********************************************F-DAUP-EGS-ADQ-1-16/10/2020********************************************/
/********************************************I-DAUP-EGS-ADQ-2-11/11/2020********************************************/
--Dato original
-- update adq.tsolicitud set
--     id_depto=16
-- WHERE id_solicitud = 6274;
--Cambio
update adq.tsolicitud set
    id_depto=5
WHERE id_solicitud = 6274;

--Dato original
-- update adq.tsolicitud set
--     id_depto=16
-- WHERE id_solicitud = 6275;
--Cambio
update adq.tsolicitud set
    id_depto=5
WHERE id_solicitud = 6275;
/********************************************F-DAUP-EGS-ADQ-2-11/11/2020********************************************/
/********************************************I-DAUP-EGS-ADQ-3-12/11/2020********************************************/
--Dato original
-- update adq.tsolicitud set
--     id_depto=16
-- WHERE id_solicitud = 6674;
--Cambio
update adq.tsolicitud set
    id_depto=5
WHERE id_solicitud = 6674;
/********************************************F-DAUP-EGS-ADQ-3-12/11/2020********************************************/
/********************************************I-DAUP-EGS-ADQ-4-17/11/2020********************************************/
--Dato original
-- update adq.tsolicitud set
--     id_depto=16
-- WHERE id_solicitud = 6512;
--Cambio
update adq.tsolicitud set
    id_depto=5
WHERE id_solicitud = 6512;
/********************************************F-DAUP-EGS-ADQ-4-17/11/2020********************************************/
/********************************************I-DAUP-EGS-ADQ-5-20/11/2020********************************************/
--Dato original
-- update adq.tcotizacion set
--     tiempo_entrega= '45 días a partir del dia siguiente de confirmado el deposito de pago.'
-- WHERE id_cotizacion = 5186;
--Cambio
update adq.tcotizacion set
    tiempo_entrega= '45 días a partir del día siguiente de recibido los documentos de embarque.'
WHERE id_cotizacion = 5186;
/********************************************F-DAUP-EGS-ADQ-5-20/11/2020********************************************/
/********************************************I-DAUP-EGS-ADQ-ETR-2008-08/12/2020********************************************/
--Dato original
-- update adq.tsolicitud set
--     id_depto=16
-- WHERE id_solicitud = 6664;
--Cambio
update adq.tsolicitud set
    id_depto=5
WHERE id_solicitud = 6664;
--Dato original
-- update adq.tsolicitud set
--     id_depto=16
-- WHERE id_solicitud = 6663;
--Cambio
update adq.tsolicitud set
    id_depto=5
WHERE id_solicitud = 6663;
/********************************************F-DAUP-EGS-ADQ-ETR-2008-08/12/2020********************************************/
/********************************************I-DAUP-EGS-ADQ-ETR-2542-14/01/2021********************************************/
--Dato original
-- update adq.tsolicitud set
--     id_depto=20
-- WHERE id_solicitud = 6732;
--Cambio
update adq.tsolicitud set
    id_depto=5
WHERE id_solicitud = 6732;
/********************************************F-DAUP-EGS-ADQ-ETR-2542-14/01/2021********************************************/

/********************************************I-DAUP-EGS-ADQ-ETR-2758-14/01/2021********************************************/
--Dato original
-- update adq.tsolicitud set
--     id_depto=17
-- WHERE id_solicitud = 6992;
-- update wf.testado_wf set
--     id_depto = 17
-- where id_estado_wf = 1200951;
--Cambio
update adq.tsolicitud set
    id_depto=5
WHERE id_solicitud = 6992;

update wf.testado_wf set
    id_depto = 5
where id_estado_wf = 1200951;
/********************************************F-DAUP-EGS-ADQ-ETR-2758-14/01/2021********************************************/

/********************************************I-DAUP-EGS-ADQ-ETR-2940-12/02/2021********************************************/
--Dato original
-- update adq.tsolicitud set
--     id_depto=17
-- WHERE id_solicitud = 7059;
-- update wf.testado_wf set
--     id_depto = 17
-- where id_estado_wf = 1252192;
--Cambio
update adq.tsolicitud set
    id_depto=5
WHERE id_solicitud = 7059;

update wf.testado_wf set
    id_depto = 5
where id_estado_wf = 1252192;
/********************************************F-DAUP-EGS-ADQ-ETR-2940-12/02/2021********************************************/

/********************************************I-DAUP-EGS-ADQ-ETR-3079-25/02/2021********************************************/
--Dato original
-- update adq.tsolicitud set
--     estado='anulado',
--     id_estado_wf = 1262817
-- WHERE id_solicitud = 7168;

-- update wf.testado_wf set
--     estado_reg = 'inactivo'
-- where id_estado_wf = 1251779;
--Cambio
update adq.tsolicitud set
    estado='borrador',
    id_estado_wf = 1251779
WHERE id_solicitud = 7168;

update wf.testado_wf set
    estado_reg = 'activo'
where id_estado_wf = 1251779;

delete from wf.testado_wf
where id_estado_wf = 1262817;
/********************************************F-DAUP-EGS-ADQ-ETR-3079-25/02/2021********************************************/

/********************************************I-DAUP-EGS-ADQ-ETR-3108-02/03/2021********************************************/
--Dato original
-- update adq.tsolicitud set
--     id_depto=17
-- WHERE id_solicitud = 7058;
-- update wf.testado_wf set
--     id_depto = 17
-- where id_estado_wf = 1260455;
--Cambio
update adq.tsolicitud set
    id_depto=5
WHERE id_solicitud = 7058;

update wf.testado_wf set
    id_depto = 5
where id_estado_wf = 1260455;
/********************************************F-DAUP-EGS-ADQ-ETR-3108-02/03/2021********************************************/