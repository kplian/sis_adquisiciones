<?php
/**
 *@package pXP
 *@file gen-ACTMotivoAnulado.php
 *@author  (admin)
 *@date 12-10-2016 19:36:54
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */

class ACTComisionMem extends ACTbase{

    function listarComision(){
        $this->objParam->defecto('ordenacion','id_integrante');

        $this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODComisionMem','listarComision');
        } else{
            $this->objFunc=$this->create('MODComisionMem');

            $this->res=$this->objFunc->listarComision($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarComision(){
        $this->objFunc=$this->create('MODComisionMem');
        if($this->objParam->insertar('id_integrante')){
            $this->res=$this->objFunc->insertarComision($this->objParam);
        } else{
            $this->res=$this->objFunc->modificarComision($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarComision(){
        $this->objFunc=$this->create('MODComisionMem');
        $this->res=$this->objFunc->eliminarComision($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>