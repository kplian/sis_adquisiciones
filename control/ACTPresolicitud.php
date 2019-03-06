<?php
/**
*@package pXP
*@file gen-ACTPresolicitud.php
*@author  (admin)
*@date 10-05-2013 05:03:41
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
	ISSUE		FECHA			ATHOR			DESCRIPCION
 * 	#4 endeETR	19/02/2019		EGS				Se aumento filtro para tipo de estado en la presolicitud
*/

require_once(dirname(__FILE__).'/../../pxp/pxpReport/ReportWriter.php');
require_once(dirname(__FILE__).'/../reportes/RPresolicitudCompra.php');
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');

class ACTPresolicitud extends ACTbase{    
			
	function listarPresolicitud(){
		$this->objParam->defecto('ordenacion','id_presolicitud');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]);
        
        if($this->objParam->getParametro('estado')!=''){//#4
        	if ($this->objParam->getParametro('estado')=='aprobado') {
				$this->objParam->addFiltro("pres.estado in (''".$this->objParam->getParametro('estado')."'',''asignado'')");					
			} else {
				$this->objParam->addFiltro("pres.estado = ''".$this->objParam->getParametro('estado')."''");				
			}			
        }
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
  
			function reportePresolicitud(){
    $dataSource = new DataSource();
    $idPresolicitud = $this->objParam->getParametro('id_presolicitud');
    $estado = $this->objParam->getParametro('estado');
    $this->objParam->addParametroConsulta('ordenacion','id_presolicitud');
    $this->objParam->addParametroConsulta('dir_ordenacion','ASC');
    $this->objParam->addParametroConsulta('cantidad',1000);
    $this->objParam->addParametroConsulta('puntero',0);
    $this->objFunc = $this->create('MODPresolicitud');
    $resultPresolicitud = $this->objFunc->reportePresolicitud();
    $datosPresolicitud = $resultPresolicitud->getDatos();
 			
 			//armamos el array parametros y metemos ahi los data sets de las otras tablas
    $dataSource->putParameter('estado',$estado);
    $dataSource->putParameter('id_presolicitud', $datosPresolicitud[0]['id_presolicitud']);
				$dataSource->putParameter('id_grupo', $datosPresolicitud[0]['id_grupo']);
    $dataSource->putParameter('id_funcionario_supervisor', $datosPresolicitud[0]['id_funcionario_supervisor']);
    $dataSource->putParameter('id_funcionario', $datosPresolicitud[0]['id_funcionario']);
    $dataSource->putParameter('obs', $datosPresolicitud[0]['obs']);
				$dataSource->putParameter('id_uo', $datosPresolicitud[0]['id_uo']);
    $dataSource->putParameter('fecha_soli', $datosPresolicitud[0]['fecha_soli']);
				$dataSource->putParameter('desc_grupo', $datosPresolicitud[0]['desc_grupo']);
    $dataSource->putParameter('desc_funcionario', $datosPresolicitud[0]['desc_funcionario']);
    $dataSource->putParameter('desc_funcionario_supervisor', $datosPresolicitud[0]['desc_funcionario_supervisor']);
    $dataSource->putParameter('desc_uo', $datosPresolicitud[0]['desc_uo']);
				
    //get detalle
    //Reset all extra params:
    $this->objParam->defecto('ordenacion', 'id_presolicitud_det');
    $this->objParam->defecto('cantidad', 1000);
    $this->objParam->defecto('puntero', 0);
    $this->objParam->addFiltro("id_presolicitud = ".$idPresolicitud);
    
    $modPresolicitudDet = $this->create('MODPresolicitudDet');
    $resultPresolicitudDet = $modPresolicitudDet->listarPresolicitudDet();
				$presolicitudDetAgrupado = $this->groupArray($resultPresolicitudDet->getDatos(), 'codigo_cc');
    $presolicitudDetDataSource = new DataSource();
				$presolicitudDetDataSource->setDataSet($presolicitudDetAgrupado);
    $dataSource->putParameter('detalleDataSource', $presolicitudDetDataSource);
            
    //build the report
    $reporte = new RPresolicitudCompra();
    $reporte->setDataSource($dataSource);
    $nombreArchivo = 'PresolicitudCompra.pdf';
    $reportWriter = new ReportWriter($reporte, dirname(__FILE__).'/../../reportes_generados/'.$nombreArchivo);
    $reportWriter->writeReport(ReportWriter::PDF);
    
    $mensajeExito = new Mensaje();
    $mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
                                    'Se generó con éxito el reporte: '.$nombreArchivo,'control');
    $mensajeExito->setArchivoGenerado($nombreArchivo);
    $this->res = $mensajeExito;
    $this->res->imprimirRespuesta($this->res->generarJson());

    }

				function groupArray($array,$groupkey)
				{
				 if (count($array)>0)
				 {
				 	$keys = array_keys($array[0]);
				 	$removekey = array_search($groupkey, $keys);		if ($removekey===false)
				 		return array("Clave \"$groupkey\" no existe");
				 	else
				 		unset($keys[$removekey]);
				 	$groupcriteria = array();
				 	$return=array();
				 	foreach($array as $value)
				 	{
				 		$item=null;
				 		foreach ($keys as $key)
				 		{
				 			$item[$key] = $value[$key];
				 		}
				 	 	$busca = array_search($value[$groupkey], $groupcriteria);
				 		if ($busca === false)
				 		{
				 			$groupcriteria[]=$value[$groupkey];
				 			$return[]=array($groupkey=>$value[$groupkey],'groupeddata'=>array());
				 			$busca=count($return)-1;
				 		}
				 		$return[$busca]['groupeddata'][]=$item;
				 	}
				 	return $return;
				 }
				 else
				 	return array();
				}
	function desconsolidarSolicitud(){
        $this->objFunc=$this->create('MODPresolicitud');    
        $this->res=$this->objFunc->desconsolidarSolicitud($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
	function siguienteEstado(){
        $this->objFunc=$this->create('MODPresolicitud');  
        $this->res=$this->objFunc->siguienteEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function anteriorEstado(){
        $this->objFunc=$this->create('MODPresolicitud');  
        $this->res=$this->objFunc->anteriorEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
}

?>