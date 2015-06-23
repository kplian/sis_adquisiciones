<?php
/**
*@package pXP
*@file gen-ACTRpc.php
*@author  (admin)
*@date 29-05-2014 15:57:51
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTRpc extends ACTbase{    
			
	function listarRpc(){
		$this->objParam->defecto('ordenacion','id_rpc');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODRpc','listarRpc');
		} else{
			$this->objFunc=$this->create('MODRpc');
			
			$this->res=$this->objFunc->listarRpc($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarRpc(){
		$this->objFunc=$this->create('MODRpc');	
		if($this->objParam->insertar('id_rpc')){
			$this->res=$this->objFunc->insertarRpc($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarRpc($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarRpc(){
		$this->objFunc=$this->create('MODRpc');	
		$this->res=$this->objFunc->eliminarRpc($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function clonarRpc(){
        $this->objFunc=$this->create('MODRpc'); 
        $this->res=$this->objFunc->clonarRpc($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
    function changeRpc(){
        $this->objFunc=$this->create('MODRpc'); 
        $this->res=$this->objFunc->changeRpc($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
	
	
			
}

?>