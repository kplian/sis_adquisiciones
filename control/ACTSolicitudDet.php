<?php
/**
*@package pXP
*@file gen-ACTSolicitudDet.php
*@author  (admin)
*@date 05-03-2013 01:28:10
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTSolicitudDet extends ACTbase{    
			
	function listarSolicitudDet(){
		$this->objParam->defecto('ordenacion','id_solicitud_det');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_solicitud')!=''){
            $this->objParam->addFiltro("sold.id_solicitud = ".$this->objParam->getParametro('id_solicitud'));    
        }
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODSolicitudDet','listarSolicitudDet');
		} else{
			$this->objFunc=$this->create('MODSolicitudDet');
			
			$this->res=$this->objFunc->listarSolicitudDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarSolicitudDet(){
		$this->objFunc=$this->create('MODSolicitudDet');	
		if($this->objParam->insertar('id_solicitud_det')){
			$this->res=$this->objFunc->insertarSolicitudDet($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarSolicitudDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarSolicitudDet(){
			$this->objFunc=$this->create('MODSolicitudDet');	
		$this->res=$this->objFunc->eliminarSolicitudDet($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarSolicitudDetCotizacion(){
			$this->objParam->defecto('ordenacion','id_solicitud_det');
		 $this->objParam->defecto('dir_ordenacion','asc');
			$this->objFunc=$this->create('MODSolicitudDet');
			$this->res=$this->objFunc->listarSolicitudDetCotizacion($this->objParam);
			$this->res->imprimirRespuesta($this->res->generarJson());	
	}
}

?>