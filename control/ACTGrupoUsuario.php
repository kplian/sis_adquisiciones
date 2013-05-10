<?php
/**
*@package pXP
*@file gen-ACTGrupoUsuario.php
*@author  (admin)
*@date 09-05-2013 22:46:48
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTGrupoUsuario extends ACTbase{    
			
	function listarGrupoUsuario(){
		$this->objParam->defecto('ordenacion','id_grupo_usuario');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_grupo')!=''){
            $this->objParam->addFiltro("id_grupo = ".$this->objParam->getParametro('id_grupo'));    
        }
        
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODGrupoUsuario','listarGrupoUsuario');
		} else{
			$this->objFunc=$this->create('MODGrupoUsuario');
			
			$this->res=$this->objFunc->listarGrupoUsuario($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarGrupoUsuario(){
		$this->objFunc=$this->create('MODGrupoUsuario');	
		if($this->objParam->insertar('id_grupo_usuario')){
			$this->res=$this->objFunc->insertarGrupoUsuario($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarGrupoUsuario($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarGrupoUsuario(){
			$this->objFunc=$this->create('MODGrupoUsuario');	
		$this->res=$this->objFunc->eliminarGrupoUsuario($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>