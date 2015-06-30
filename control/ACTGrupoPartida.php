<?php
/**
*@package pXP
*@file gen-ACTGrupoPartida.php
*@author  (admin)
*@date 09-05-2013 22:46:52
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTGrupoPartida extends ACTbase{    
			
	function listarGrupoPartida(){
		$this->objParam->defecto('ordenacion','id_grupo_partida');

		$this->objParam->defecto('dir_ordenacion','asc');
		
        if($this->objParam->getParametro('id_grupo')!=''){
            $this->objParam->addFiltro("id_grupo = ".$this->objParam->getParametro('id_grupo'));    
        }
        
        if($this->objParam->getParametro('id_gestion')!=''){
            $this->objParam->addFiltro("grpa.id_gestion = ".$this->objParam->getParametro('id_gestion'));    
        }
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODGrupoPartida','listarGrupoPartida');
		} else{
			$this->objFunc=$this->create('MODGrupoPartida');
			
			$this->res=$this->objFunc->listarGrupoPartida($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarGrupoPartida(){
		$this->objFunc=$this->create('MODGrupoPartida');	
		if($this->objParam->insertar('id_grupo_partida')){
			$this->res=$this->objFunc->insertarGrupoPartida($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarGrupoPartida($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarGrupoPartida(){
			$this->objFunc=$this->create('MODGrupoPartida');	
		$this->res=$this->objFunc->eliminarGrupoPartida($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>