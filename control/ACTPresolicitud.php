<?php
/**
*@package pXP
*@file gen-ACTPresolicitud.php
*@author  (admin)
*@date 10-05-2013 05:03:41
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPresolicitud extends ACTbase{    
			
	function listarPresolicitud(){
		$this->objParam->defecto('ordenacion','id_presolicitud');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
        
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPresolicitud','listarPresolicitud');
		} else{
			$this->objFunc=$this->create('MODPresolicitud');
			
			$this->res=$this->objFunc->listarPresolicitud($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPresolicitud(){
		$this->objFunc=$this->create('MODPresolicitud');	
		if($this->objParam->insertar('id_presolicitud')){
			$this->res=$this->objFunc->insertarPresolicitud($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPresolicitud($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPresolicitud(){
			$this->objFunc=$this->create('MODPresolicitud');	
		$this->res=$this->objFunc->eliminarPresolicitud($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function finalizarPresolicitud(){
        $this->objFunc=$this->create('MODPresolicitud');    
        $this->res=$this->objFunc->finalizarPresolicitud($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
    function retrocederPresolicitud(){
        $this->objFunc=$this->create('MODPresolicitud');    
        $this->res=$this->objFunc->retrocederPresolicitud($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
    function aprobarPresolicitud(){
        $this->objFunc=$this->create('MODPresolicitud');    
        $this->res=$this->objFunc->aprobarPresolicitud($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
     function consolidarSolicitud(){
        $this->objFunc=$this->create('MODPresolicitud');    
        $this->res=$this->objFunc->consolidarSolicitud($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
  
			
}

?>