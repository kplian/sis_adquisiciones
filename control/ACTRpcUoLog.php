<?php
/**
*@package pXP
*@file gen-ACTRpcUoLog.php
*@author  (admin)
*@date 03-06-2014 13:14:39
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTRpcUoLog extends ACTbase{    
			
	function listarRpcUoLog(){
		$this->objParam->defecto('ordenacion','id_rpc_uo_log');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_rpc')!=''){
            $this->objParam->addFiltro("rpcl.id_rpc = ".$this->objParam->getParametro('id_rpc'));    
        }
        
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODRpcUoLog','listarRpcUoLog');
		} else{
			$this->objFunc=$this->create('MODRpcUoLog');
			
			$this->res=$this->objFunc->listarRpcUoLog($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarRpcUoLog(){
		$this->objFunc=$this->create('MODRpcUoLog');	
		if($this->objParam->insertar('id_rpc_uo_log')){
			$this->res=$this->objFunc->insertarRpcUoLog($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarRpcUoLog($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarRpcUoLog(){
			$this->objFunc=$this->create('MODRpcUoLog');	
		$this->res=$this->objFunc->eliminarRpcUoLog($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>