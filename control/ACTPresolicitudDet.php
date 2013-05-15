<?php
/**
*@package pXP
*@file gen-ACTPresolicitudDet.php
*@author  (admin)
*@date 10-05-2013 05:04:17
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPresolicitudDet extends ACTbase{    
			
	function listarPresolicitudDet(){
		$this->objParam->defecto('ordenacion','id_presolicitud_det');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		 if($this->objParam->getParametro('id_presolicitud')!=''){
            $this->objParam->addFiltro("id_presolicitud = ".$this->objParam->getParametro('id_presolicitud'));    
        }
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPresolicitudDet','listarPresolicitudDet');
		} else{
			$this->objFunc=$this->create('MODPresolicitudDet');
			
			$this->res=$this->objFunc->listarPresolicitudDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPresolicitudDet(){
		$this->objFunc=$this->create('MODPresolicitudDet');	
		if($this->objParam->insertar('id_presolicitud_det')){
			$this->res=$this->objFunc->insertarPresolicitudDet($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPresolicitudDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPresolicitudDet(){
			$this->objFunc=$this->create('MODPresolicitudDet');	
		$this->res=$this->objFunc->eliminarPresolicitudDet($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>