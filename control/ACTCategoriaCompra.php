<?php
/**
*@package pXP
*@file gen-ACTCategoriaCompra.php
*@author  (admin)
*@date 06-02-2013 15:59:42
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCategoriaCompra extends ACTbase{    
			
	function listarCategoriaCompra(){
		$this->objParam->defecto('ordenacion','id_categoria_compra');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCategoriaCompra','listarCategoriaCompra');
		} else{
			$this->objFunc=$this->create('MODCategoriaCompra');
			
			$this->res=$this->objFunc->listarCategoriaCompra($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarCategoriaCompra(){
		$this->objFunc=$this->create('MODCategoriaCompra');	
		if($this->objParam->insertar('id_categoria_compra')){
			$this->res=$this->objFunc->insertarCategoriaCompra($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCategoriaCompra($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCategoriaCompra(){
			$this->objFunc=$this->create('MODCategoriaCompra');	
		$this->res=$this->objFunc->eliminarCategoriaCompra($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>