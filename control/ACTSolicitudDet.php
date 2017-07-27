<?php
/**
*@package pXP
*@file gen-ACTSolicitudDet.php
*@author  (admin)
*@date 05-03-2013 01:28:10
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

include_once(dirname(__FILE__).'/../../lib/lib_general/ExcelInput.php');

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
		
		//adicionar una fila al resultado con el summario
		$temp = Array();
		$temp['precio_total'] = $this->res->extraData['precio_total'];
		$temp['tipo_reg'] = 'summary';
		$temp['id_solicitud_det'] = 0;
		
		$this->res->total++;
		
		$this->res->addLastRecDatos($temp);
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

	function subirDetalleGastoSolicitud(){
		//validar extnsion del archivo
		$id_solicitud = $this->objParam->getParametro('id_solicitud');
		$codigoArchivo = $this->objParam->getParametro('codigo');

		$arregloFiles = $this->objParam->getArregloFiles();
		$ext = pathinfo($arregloFiles['archivo']['name']);
		$nombreArchivo = $ext['filename'];
		$extension = $ext['extension'];

		$error = 'no';
		$mensaje_completo = '';
		//validar errores unicos del archivo: existencia, copia y extension
		if(isset($arregloFiles['archivo']) && is_uploaded_file($arregloFiles['archivo']['tmp_name'])){

			//procesa Archivo
			$archivoExcel = new ExcelInput($arregloFiles['archivo']['tmp_name'], $codigoArchivo);
			$archivoExcel->recuperarColumnasExcel();

			$arrayArchivo = $archivoExcel->leerColumnasArchivoExcel();

			$this->objParam->addParametro('id_solicitud', $id_solicitud);
			$this->objFunc = $this->create('sis_adquisiciones/MODSolicitudDet');
			$this->res = $this->objFunc->eliminarDetalleGastoSolicitud($this->objParam);

			if($this->res->getTipo()=='ERROR'){
				$error = 'error';
				$mensaje_completo = "Error al eliminar detalle de gasto ". $this->res->getMensajeTec();
			}
			foreach ($arrayArchivo as $fila) {
				$this->objParam->addParametro('id_solicitud', $id_solicitud);
				$this->objParam->addParametro('concepto_gasto', $fila['concepto_gasto']);
				$this->objParam->addParametro('id_centro_costo', $fila['id_centro_costo']);
				$this->objParam->addParametro('centro_costo', $fila['centro_costo']);
				$this->objParam->addParametro('orden_trabajo', $fila['orden_trabajo']);
				$this->objParam->addParametro('descripcion', $fila['descripcion']);
				$this->objParam->addParametro('cantidad_sol', $fila['cantidad']);
				$this->objParam->addParametro('precio_unitario', $fila['precio_unitario']);
				$this->objParam->addParametro('precio_total', $fila['precio_unitario']*$fila['cantidad']);
				$this->objParam->addParametro('precio_sg', 0.00);
				$this->objParam->addParametro('precio_ga', $fila['precio_unitario']*$fila['cantidad']);
				$this->objFunc = $this->create('sis_adquisiciones/MODSolicitudDet');
				$this->res = $this->objFunc->insertarDetalleGastoSolicitud($this->objParam);
				if($this->res->getTipo()=='ERROR'){
					$error = 'error';
					$mensaje_completo = "Error al guardar el fila en tabla ". $this->res->getMensajeTec();
				}
			}
			$file_path = $arregloFiles['archivo']['name'];

		} else {
			$mensaje_completo = "No se subio el archivo a la carpeta temporal";
			$error = 'error_fatal';
		}
		//armar respuesta en error fatal
		if ($error == 'error_fatal') {

			$this->mensajeRes=new Mensaje();
			$this->mensajeRes->setMensaje('ERROR','ACTSolicitudDet.php',$mensaje_completo,
					$mensaje_completo,'control');
			//si no es error fatal proceso el archivo
		}

		//armar respuesta en caso de exito o error en algunas tuplas
		if ($error == 'error') {
			$this->mensajeRes=new Mensaje();
			$this->mensajeRes->setMensaje('ERROR','ACTSolicitudDet.php','Ocurrieron los siguientes errores : ' . $mensaje_completo,
					$mensaje_completo,'control');
		} else if ($error == 'no') {
			$this->mensajeRes=new Mensaje();
			$this->mensajeRes->setMensaje('EXITO','ACTSolicitudDet.php','El archivo fue ejecutado con éxito',
					'El archivo fue ejecutado con éxito','control');
		}

		//devolver respuesta
		$this->mensajeRes->imprimirRespuesta($this->mensajeRes->generarJson());
		//return $this->respuesta;
	}
}

?>