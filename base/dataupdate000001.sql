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
