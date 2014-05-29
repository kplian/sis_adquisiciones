<?php
/**
*@package pXP
*@file gen-ACTRpcUo.php
*@author  (admin)
*@date 29-05-2014 15:58:17
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTRpcUo extends ACTbase{    
			
	function listarRpcUo(){
		$this->objParam->defecto('ordenacion','id_rpc_uo');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_rpc')!=''){
            $this->objParam->addFiltro("ruo.id_rpc = ".$this->objParam->getParametro('id_rpc'));    
        }
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODRpcUo','listarRpcUo');
		} else{
			$this->objFunc=$this->create('MODRpcUo');
			
			$this->res=$this->objFunc->listarRpcUo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarRpcUo(){
		$this->objFunc=$this->create('MODRpcUo');	
		if($this->objParam->insertar('id_rpc_uo')){
			$this->res=$this->objFunc->insertarRpcUo($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarRpcUo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarRpcUo(){
			$this->objFunc=$this->create('MODRpcUo');	
		$this->res=$this->objFunc->eliminarRpcUo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>