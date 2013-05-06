<?php
/**
*@package pXP
*@file gen-ACTDocumentoSol.php
*@author  (admin)
*@date 08-02-2013 19:01:00
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTDocumentoSol extends ACTbase{    
            
    function listarDocumentoSol(){
        $this->objParam->defecto('ordenacion','id_documento_sol');
        $this->objParam->defecto('dir_ordenacion','asc');
        
        if($this->objParam->getParametro('id_categoria_compra')!=''){
            $this->objParam->addFiltro("docsol.id_solicitud is null and docsol.id_categoria_compra = ".$this->objParam->getParametro('id_categoria_compra'));    
        }
		
       
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODDocumentoSol','listarDocumentoSol');
        } else{
            $this->objFunc=$this->create('MODDocumentoSol');
            
            $this->res=$this->objFunc->listarDocumentoSol($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
    function listarDocumentoSolArchivo(){
        $this->objParam->defecto('ordenacion','id_documento_sol');
        $this->objParam->defecto('dir_ordenacion','asc');
        
        if($this->objParam->getParametro('id_solicitud')!=''){
            $this->objParam->addFiltro("docsol.id_solicitud = ".$this->objParam->getParametro('id_solicitud'));    
        }
       
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODDocumentoSol','listarDocumentoSolArchivo');
        } else{
            $this->objFunc=$this->create('MODDocumentoSol');
            
            $this->res=$this->objFunc->listarDocumentoSolArchivo($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                
    function insertarDocumentoSol(){
        $this->objFunc=$this->create('MODDocumentoSol');    
        if($this->objParam->insertar('id_documento_sol')){
            $this->res=$this->objFunc->insertarDocumentoSol($this->objParam);           
        } else{         
            $this->res=$this->objFunc->modificarDocumentoSol($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                        
    function eliminarDocumentoSol(){
            $this->objFunc=$this->create('MODDocumentoSol');    
        $this->res=$this->objFunc->eliminarDocumentoSol($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function subirArchivo(){
        $this->objFunc=$this->create('MODDocumentoSol');
        $this->res=$this->objFunc->subirDocumentoSolArchivo();
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
            
}

?>