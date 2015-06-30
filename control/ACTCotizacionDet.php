<?php
/**
*@package pXP
*@file ACTCotizacionDet.php
*@author  Gonzalo Sarmiento Sejas
*@date 21-03-2013 21:44:43
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCotizacionDet extends ACTbase{    
			
	function listarCotizacionDet(){
		$this->objParam->defecto('ordenacion','id_cotizacion_det');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCotizacionDet','listarCotizacionDet');
		} else{
			$this->objFunc=$this->create('MODCotizacionDet');
			
			$this->res=$this->objFunc->listarCotizacionDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarCotizacionDet(){
		$this->objFunc=$this->create('MODCotizacionDet');	
		if($this->objParam->insertar('id_cotizacion_det')){
			$this->res=$this->objFunc->insertarCotizacionDet($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCotizacionDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCotizacionDet(){
	    $this->objFunc=$this->create('MODCotizacionDet');	
		$this->res=$this->objFunc->eliminarCotizacionDet($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function totalAdjudicado(){
         $this->objFunc=$this->create('MODCotizacionDet');   
        $this->res=$this->objFunc->totalAdjudicado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

   function AdjudicarDetalle(){
        $this->objFunc=$this->create('MODCotizacionDet');   
        $this->res=$this->objFunc->AdjudicarDetalle($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }	
			
}

?>