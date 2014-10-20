<?php
/**
*@package pXP
*@file gen-ACTProcesoCompra.php
*@author  (admin)
*@date 19-03-2013 12:55:30
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

require_once(dirname(__FILE__).'/../../pxp/pxpReport/ReportWriter.php');
require_once(dirname(__FILE__).'/../reportes/RCuadroComparativo.php');
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');

class ACTProcesoCompra extends ACTbase{    
			
	function listarProcesoCompra(){
		$this->objParam->defecto('ordenacion','id_proceso_compra');

		$this->objParam->defecto('fecha_reg','desc');
		
		if($this->objParam->getParametro('filtro_campo')!=''){
            $this->objParam->addFiltro($this->objParam->getParametro('filtro_campo')." = ".$this->objParam->getParametro('filtro_valor'));  
        }
		
		if($this->objParam->getParametro('pendientes')=='1'){
             $this->objParam->addFiltro("(estado in (''pendiente'',''proceso'')) and (desc_cotizacion not like''%pago_habilitado%''  or desc_cotizacion is NULL)");
        }
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODProcesoCompra','listarProcesoCompra');
		} else{
			$this->objFunc=$this->create('MODProcesoCompra');
			
			$this->res=$this->objFunc->listarProcesoCompra($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarProcesoCompra(){
		$this->objFunc=$this->create('MODProcesoCompra');	
		if($this->objParam->insertar('id_proceso_compra')){
			$this->res=$this->objFunc->insertarProcesoCompra($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarProcesoCompra($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function asignarUsuarioProceso(){
        $this->objFunc=$this->create('MODProcesoCompra');   
        $this->res=$this->objFunc->asignarUsuarioProceso($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
	
	function eliminarProcesoCompra(){
	    $this->objFunc=$this->create('MODProcesoCompra');	
		$this->res=$this->objFunc->eliminarProcesoCompra($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function revertirPresupuesto(){
        $this->objFunc=$this->create('MODProcesoCompra');   
        $this->res=$this->objFunc->revertirPresupuesto($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
    function finalizarProceso(){
        $this->objFunc=$this->create('MODProcesoCompra');   
        $this->res=$this->objFunc->finalizarProceso($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
    
	function cuadroComparativo(){
			
            $dataSource = new DataSource();
			
			
			$this->objParam->addParametroConsulta('ordenacion','id_proceso_compra');
            $this->objParam->addParametroConsulta('dir_ordenacion','ASC');
            $this->objParam->addParametroConsulta('cantidad',1);
            $this->objParam->addParametroConsulta('puntero',0);
            
            
            //recupera datos del proceso de compra
            $this->objFunc = $this->create('MODProcesoCompra');
            $resultProcesoCompra = $this->objFunc->listarProcesoCompraPedido();
            $datosProcesoCompra = $resultProcesoCompra->getDatos();
           
            
            if($resultProcesoCompra->getTipo()=='ERROR'){
                              
                      $resultProcesoCompra->imprimirRespuesta($resultProcesoCompra-> generarMensajeJson());
                      exit;
            }
        	
        	
        	$idSolicitud=$datosProcesoCompra[0]['id_solicitud'];
        	
        	
        	//armamos el array parametros y metemos ahi los data sets de las otras tablas
            $dataSource->putParameter('id_proceso_compra', $datosProcesoCompra[0]['id_proceso_compra']);
			$dataSource->putParameter('codigo_proceso', $datosProcesoCompra[0]['codigo_proceso']);
			$dataSource->putParameter('desc_solicitud', $datosProcesoCompra[0]['desc_solicitud']);
			
			
			
			//recupera el detalle de la solicituf
			$this->objParam->addParametroConsulta('ordenacion', 'id_solicitud_det');
            $this->objParam->addParametroConsulta('cantidad', 1000);
            $this->objParam->addParametroConsulta('puntero', 0);
            $this->objParam->addParametro('id_solicitud', $idSolicitud);
            
            $modSolicitudDet = $this->create('MODSolicitudDet');
            $resultSolicitudDet = $modSolicitudDet->listarSolicitudDet();        
            $datosResultSolicitudDet = $resultSolicitudDet->getDatos();
            if($resultSolicitudDet->getTipo()=='ERROR'){
                              
                      $resultSolicitudDet->imprimirRespuesta($resultSolicitudDet-> generarMensajeJson());
                      exit;
            }
            
            //var_dump($datosResultSolicitudDet);
			$solicitudDetDataSource = new DataSource();
			$solicitudDetDataSource->setDataSet($datosResultSolicitudDet);
			//registra el dataSoruce para los detalles de la solicitud de compra
			$dataSource->putParameter('detalleSolicitudDataSource', $solicitudDetDataSource);
								
                 
                 
             //recuepra las cotizaciones del proceso
             //get detalle
             //Reset all extra params:
		    $this->objParam->addParametroConsulta('ordenacion', 'id_cotizacion');
            $this->objParam->addParametroConsulta('cantidad', 1000);
            $this->objParam->addParametroConsulta('puntero', 0);
            
                    
            $modCotizacion = $this->create('MODCotizacion');
            $resultCotizacion = $modCotizacion->listarCotizacion();        
            $datosResultCotizacion = $resultCotizacion->getDatos();
            
            if($resultCotizacion->getTipo()=='ERROR'){
                              
                      $resultCotizacion->imprimirRespuesta($resultCotizacion-> generarMensajeJson());
                      exit;
            }
            
             //recorre las cotizaciones y recupera los datos ofertados
            for ($i=0; $i <count($datosResultCotizacion) ; $i++) {             
                
                    $idCotizacion = $datosResultCotizacion[$i]['id_cotizacion'];
                    
                    $this->objParam->addParametroConsulta('ordenacion', 'id_solicitud_det');
                    $this->objParam->addParametroConsulta('cantidad', 1000);
                    $this->objParam->addParametroConsulta('puntero', 0);
                    $this->objParam->addParametro('id_cotizacion', $idCotizacion);
                            
                    $modCotizacionDet = $this->create('MODCotizacionDet');
                    $resultCotizacionDet = $modCotizacionDet->listarCotizacionDet(); 
                    
                    $datosResultCotizacionDet=$resultCotizacionDet->getDatos();
                    $resultCotizacionDet->setDatos($datosResultCotizacionDet);
                    
                    //crea un data source para almacenar las cotizaciones
                    $cotizacionDetDataSource = new DataSource();
                    $cotizacionDetDataSource->setDataSet($resultCotizacionDet->getDatos());
                    //recursivamente agregar el detalle de la cotizacion como un dataset
                    $datosResultCotizacion[$i]['dataset']=$cotizacionDetDataSource;
                                   
             }
             
             $resultCotizacion->setDatos($datosResultCotizacion);
             
		     $cotizacionDataSource = new DataSource();        
    	     $cotizacionDataSource->setDataSet($resultCotizacion->getDatos());
    	     
    	     //alamcena en data source principal los datos de la cotizacion
    	     $dataSource->putParameter('cotizacionDataSource', $cotizacionDataSource);
    				        
             //build the report
             $reporte = new RCuadroComparativo();
             //configura el data set principal para armar el reporte
             $reporte->setDataSource($dataSource);
        	 $nombreArchivo = 'CuadroComparativo.xls';
              
             //almacena el archivo temporalmente 				
             $reportWriter = new ReportWriter($reporte, dirname(__FILE__).'/../../reportes_generados/'.$nombreArchivo);
             $reportWriter->writeReport('xls');
            
              //retorna el nombre del archivo temporal al cliente
             $mensajeExito = new Mensaje();
             $mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
                                            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
             
             $mensajeExito->setArchivoGenerado($nombreArchivo);
             $this->res = $mensajeExito;
             $this->res->imprimirRespuesta($this->res->generarJson());

  }
}

?>