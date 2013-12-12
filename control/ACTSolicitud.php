<?php
/**
*@package pXP
*@file gen-ACTSolicitud.php
*@author  (admin)
*@date 19-02-2013 12:12:51
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

require_once(dirname(__FILE__).'/../../pxp/pxpReport/ReportWriter.php');
require_once(dirname(__FILE__).'/../reportes/RSolicitudCompra.php');
require_once(dirname(__FILE__).'/../reportes/DiagramadorGantt.php');
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');

class ACTSolicitud extends ACTbase{    
			
	function listarSolicitud(){
		$this->objParam->defecto('ordenacion','id_solicitud');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_depto')!=''){
            $this->objParam->addFiltro("sol.id_depto = ".$this->objParam->getParametro('id_depto'));    
        }
        
        if($this->objParam->getParametro('estado')!=''){
                
            
            $this->objParam->addFiltro("sol.estado = ''".$this->objParam->getParametro('estado')."''");
            
        }
        
         if($this->objParam->getParametro('filtro_aprobadas')==1){
                 
             $this->objParam->addFiltro("(sol.estado = ''aprobado'' or  sol.estado = ''proceso'')");
            
         }
		
		//var_dump($_SESSION["ss_id_funcionario"]);
		
		 $this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODSolicitud','listarSolicitud');
		} else{
			$this->objFunc=$this->create('MODSolicitud');
			
			$this->res=$this->objFunc->listarSolicitud($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
		
	function insertarSolicitud(){
		$this->objFunc=$this->create('MODSolicitud');	
		if($this->objParam->insertar('id_solicitud')){
			$this->res=$this->objFunc->insertarSolicitud($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarSolicitud($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarSolicitud(){
			$this->objFunc=$this->create('MODSolicitud');	
		$this->res=$this->objFunc->eliminarSolicitud($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function finalizarSolicitud(){
            $this->objFunc=$this->create('MODSolicitud');   
        $this->res=$this->objFunc->finalizarSolicitud($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

 

    function diagramaGantt(){
				$dataSource = new DataSource();
				$dataSourceSolicitud = new DataSource();
				
			    $idSolicitud = $this->objParam->getParametro('id_solicitud');
			    $this->objParam->addParametroConsulta('ordenacion','id_solicitud');
			    $this->objParam->addParametroConsulta('dir_ordenacion','ASC');
			    $this->objParam->addParametroConsulta('cantidad',1000);
			    $this->objParam->addParametroConsulta('puntero',0);
			    $this->objFunc = $this->create('MODSolicitud');
			    
			    $resultSolicitud = $this->objFunc->estadosSolicitud();
			    $datosSolicitud = $resultSolicitud->getDatos();
							
				$dataSourceSolicitud->setDataset($datosSolicitud);
							
				$this->objFunc = $this->create('MODProcesoCompra');
			    $resultProcesoSolicitud = $this->objFunc->listarProcesoCompraSolicitud();
			    $datosProcesoSolicitud = $resultProcesoSolicitud->getDatos();
							
							if(count($datosProcesoSolicitud)!=0){
									for ($i=0 ; $i<count($datosProcesoSolicitud); $i++) {
													$dataSourceProceso = new DataSource();
												 $this->objParam->addParametro('id_proceso_compra', $datosProcesoSolicitud[$i]['id_proceso_compra']);		
													$this->objFunc = $this->create('MODSolicitud');
								     $resultProceso = $this->objFunc->estadosProceso();
								     $datosProceso = $resultProceso->getDatos();
													$dataSourceProceso->setDataSet($datosProceso);
													
													//$this->objParam->addParametro('id_proceso_compra', $datosProcesoSolicitud[$i]['id_proceso_compra']);
													$this->objFunc = $this->create('MODCotizacion');											
					    				$resultCotizacionProceso = $this->objFunc->listarCotizacionProcesoCompra();
					    				$datosCotizacionProceso = $resultCotizacionProceso->getDatos();
													
													if(count($datosCotizacionProceso)!=0){
															for ($j=0 ; $j<count($datosCotizacionProceso); $j++) {
																		$dataSourceCotizacion = new DataSource();
																		$this->objParam->addParametro('id_cotizacion', $datosCotizacionProceso[$j]['id_cotizacion']);
																		$this->objFunc = $this->create('MODCotizacion');														
													     $resultCotizacion = $this->objFunc->estadosCotizacion();
													     $datosCotizacion = $resultCotizacion->getDatos();
																		$dataSourceCotizacion->setDataSet($datosCotizacion);											
																		
																		$this->objFunc = $this->create('MODCotizacion');											
										    				$resultObligacionPagoCotizacion = $this->objFunc->listarObligacionPagoCotizacion();
										    				$datosObligacionPagoCotizacion = $resultObligacionPagoCotizacion->getDatos();
																		
																		if(count($datosObligacionPagoCotizacion)!=0){
																					for ($k=0 ; $k<count($datosObligacionPagoCotizacion); $k++) {																		
																							 $dataSourcePago = new DataSource();
																						  $this->objParam->addParametro('id_obligacion_pago', $datosObligacionPagoCotizacion[$k]['id_obligacion_pago']);
																							 $this->objFunc = $this->create('sis_tesoreria/MODObligacionPago');
																			     $resultPago = $this->objFunc->estadosPago();
																			     $datosPago = $resultPago->getDatos();
																							 $dataSourcePago->setDataSet($datosPago);
																							 $dataSourceCotizacion->putParameter('dataSourcePago',$dataSourcePago);
																					}											 
																		}
																		$dataSourceProceso->putParameter("dataSourceCotizacion.$j",$dataSourceCotizacion);
															}
													}
													$dataSourceSolicitud->putParameter("dataSourceProceso.$i",$dataSourceProceso);															
									}
							}
							$dataSource->setDataset($dataSourceSolicitud);
							$this->objFunc = $this->create('MODSolicitud');
							$resultSolicitud = $this->objFunc->reporteSolicitud();
							$datosSolicitud = $resultSolicitud->getDatos();
							$dataSource->putParameter('numero',$datosSolicitud[0]['numero']);
							$dataSource->putParameter('num_tramite',$datosSolicitud[0]['num_tramite']);
							$dataSource->putParameter('desc_uo',$datosSolicitud[0]['desc_uo']);
							$dataSource->putParameter('desc_proceso_macro',$datosSolicitud[0]['desc_proceso_macro']);
			  		
			  		//build the diagram
			    $nombreArchivo='diagramaGantt.png';
			    $diagramador = new DiagramadorGantt();
							$diagramador->setDataSource($dataSource);
							$diagramador->graficar($nombreArchivo);
							
			    $mensajeExito = new Mensaje();
			    $mensajeExito->setMensaje('EXITO','DiagramaGantt.php','Diagrama Gantt generado',
			                                    'Se generó con éxito el diagrama Gantt: '.$nombreArchivo,'control');
			    $mensajeExito->setArchivoGenerado($nombreArchivo);
			    $this->res = $mensajeExito;
			    $this->res->imprimirRespuesta($this->res->generarJson());
				}
				
    function siguienteEstadoSolicitud(){
        $this->objFunc=$this->create('MODSolicitud');  
        $this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
        $this->res=$this->objFunc->siguienteEstadoSolicitud($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
    function anteriorEstadoSolicitud(){
        $this->objFunc=$this->create('MODSolicitud');  
        $this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
        $this->res=$this->objFunc->anteriorEstadoSolicitud($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
    
   function reporteSolicitud(){
    $dataSource = new DataSource();
    
    $idSolicitud = $this->objParam->getParametro('id_solicitud');
    $estado = $this->objParam->getParametro('estado');
    
    $this->objParam->addParametroConsulta('ordenacion','id_solicitud');
    $this->objParam->addParametroConsulta('dir_ordenacion','ASC');
    $this->objParam->addParametroConsulta('cantidad',1000);
    $this->objParam->addParametroConsulta('puntero',0);
    
    $this->objFunc = $this->create('MODSolicitud');
    
    $resultSolicitud = $this->objFunc->reporteSolicitud();
    
    $datosSolicitud = $resultSolicitud->getDatos();
            
    //armamos el array parametros y metemos ahi los data sets de las otras tablas
    $dataSource->putParameter('estado',$estado);
    $dataSource->putParameter('id_solicitud', $datosSolicitud[0]['id_solicitud']);
    $dataSource->putParameter('numero', $datosSolicitud[0]['numero']);
    $dataSource->putParameter('fecha_apro', $datosSolicitud[0]['fecha_apro']);
    $dataSource->putParameter('desc_moneda', $datosSolicitud[0]['desc_moneda']);
    $dataSource->putParameter('tipo', $datosSolicitud[0]['tipo']);
    $dataSource->putParameter('desc_gestion', $datosSolicitud[0]['desc_gestion']);
    $dataSource->putParameter('fecha_soli', $datosSolicitud[0]['fecha_soli']);
    $dataSource->putParameter('desc_categoria_compra', $datosSolicitud[0]['desc_categoria_compra']);
    $dataSource->putParameter('desc_proceso_macro', $datosSolicitud[0]['desc_proceso_macro']);
    $dataSource->putParameter('desc_funcionario', $datosSolicitud[0]['desc_funcionario']);
    $dataSource->putParameter('desc_uo', $datosSolicitud[0]['desc_uo']);
    $dataSource->putParameter('desc_depto', $datosSolicitud[0]['desc_depto']);
                
    $dataSource->putParameter('justificacion', $datosSolicitud[0]['justificacion']);
    $dataSource->putParameter('lugar_entrega', $datosSolicitud[0]['lugar_entrega']);
    $dataSource->putParameter('comite_calificacion', $datosSolicitud[0]['comite_calificacion']);
    $dataSource->putParameter('posibles_proveedores', $datosSolicitud[0]['posibles_proveedores']);
    $dataSource->putParameter('desc_funcionario_rpc', $datosSolicitud[0]['desc_funcionario_rpc']);
    $dataSource->putParameter('desc_funcionario_apro', $datosSolicitud[0]['desc_funcionario_apro']);
                
    //get detalle
    //Reset all extra params:
    $this->objParam->defecto('ordenacion', 'id_solicitud_det');
    $this->objParam->defecto('cantidad', 1000);
    $this->objParam->defecto('puntero', 0);
    $this->objParam->addParametro('id_solicitud', $idSolicitud );
    $modSolicitudDet = $this->create('MODSolicitudDet');
    //lista el detalle de la solicitud
    $resultSolicitudDet = $modSolicitudDet->listarSolicitudDet();
    
    //agrupa el detalle de la solcitud por centros de costos y partidas
    
    $solicitudDetAgrupado = $this->groupArray($resultSolicitudDet->getDatos(), 'codigo_partida','desc_centro_costo', $datosSolicitud[0]['id_moneda'],$datosSolicitud[0]['estado']);
    
    $solicitudDetDataSource = new DataSource();
    
    $solicitudDetDataSource->setDataSet($solicitudDetAgrupado);
    
    //inserta el detalle de la colistud como origen de datos
    
    $dataSource->putParameter('detalleDataSource', $solicitudDetDataSource);
            
    //build the report
    $reporte = new RSolicitudCompra();
    
    $reporte->setDataSource($dataSource);
    $nombreArchivo = 'SolicitudCompra.pdf';
    $reportWriter = new ReportWriter($reporte, dirname(__FILE__).'/../../reportes_generados/'.$nombreArchivo);
    $reportWriter->writeReport(ReportWriter::PDF);
    
    $mensajeExito = new Mensaje();
    $mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
                                    'Se generó con éxito el reporte: '.$nombreArchivo,'control');
    $mensajeExito->setArchivoGenerado($nombreArchivo);
    $this->res = $mensajeExito;
    $this->res->imprimirRespuesta($this->res->generarJson());

    } 
    
    /*
    
    Autor: GSS
    DESCRIPTION:  Agrupa los detalles de la solcitud
    $solicitudDetAgrupado = $this->groupArray(
        $resultSolicitudDet->getDatos(), 
        'codigo_partida',
        'desc_centro_costo');
    
    */
    
   function groupArray($array,$groupkey,$groupkeyTwo,$id_moneda,$estado_sol)
	{
	 if (count($array)>0)
	 {
	 	//recupera las llaves del array    
	 	$keys = array_keys($array[0]);
	 	
	 	$removekey = array_search($groupkey, $keys);
	 	$removekeyTwo = array_search($groupkeyTwo, $keys);
	 	
		if ($removekey===false)
 		     return array("Clave \"$groupkey\" no existe");
		if($removekeyTwo===false)
 		     return array("Clave \"$groupkeyTwo\" no existe");
 		     
	 	
	 	//crea los array para agrupar y para busquedas
	 	$groupcriteria = array();
	 	$arrayResp=array();
	 	
	 	//recorre el resultado de la consulta de oslicitud detalle
	 	foreach($array as $value)
	 	{
	 		//por cada registro almacena el valor correspondiente en $item     
	 		$item=null;
	 		foreach ($keys as $key)
	 		{
	 			$item[$key] = $value[$key];
	 		}
	 		
	 		//buscar si el grupo ya se incerto
	 	 	$busca = array_search($value[$groupkey].$value[$groupkeyTwo], $groupcriteria);
	 		
	 		if ($busca === false)
	 		{
	 		     //si el grupo no existe lo crea
	 		    //en la siguiente posicicion de crupcriteria agrega el identificador del grupo
	 			$groupcriteria[]=$value[$groupkey].$value[$groupkeyTwo];
	 			
	 			//en la siguiente posivion cre ArrayResp cre un btupo con el identificaor nuevo  
	 			//y un bubgrupo para acumular los detalle de semejaste caracteristicas
	 			
	 			$arrayResp[]=array($groupkey.$groupkeyTwo=>$value[$groupkey].$value[$groupkeyTwo],'groupeddata'=>array(),'presu_verificado'=>"false");
	 			$arrayPresuVer[]=
	 			//coloca el indice en la ultima posicion insertada
	 			$busca=count($arrayResp)-1;
	 			
	 			
	 			
	 		}
	 		
	 		//inserta el registro en el subgrupo correspondiente
	 		$arrayResp[$busca]['groupeddata'][]=$item;
	 		
	 	}
	 	
	 	//solo verificar si el estado es borrador o pendiente
	 	//suma y verifica el presupuesto
	 	
	 	if ($estado_sol == 'borrador' || $estado_sol == 'pendiente'){
    	 	    $cont_grup = 0;
    	 	foreach($arrayResp as $value2)
            {
                  
                  $total_pre = 0;
                  
                 $busca = array_search($value2[$groupkey].$value2[$groupkeyTwo], $groupcriteria);
                 
                 foreach($value2[groupeddata] as $value_det){
                       //sumamos el monto a comprometer   
                      $total_pre = $total_pre + $value_det["precio_ga"];
                 }
                 
                 $value_det = $value2[groupeddata][0];
                 
                 $this->objParam = new CTParametro(null,null,null);
                 $this->objParam->addParametro('id_presupuesto',$value_det["id_presupuesto"]);
                 $this->objParam->addParametro('id_partida',$value_det["id_partida"]);
                 $this->objParam->addParametro('id_moneda',$id_moneda);
                 $this->objParam->addParametro('monto_total',$total_pre);
                 
                 
                 $this->objFunc = $this->create('sis_presupuestos/MODPresupuesto');
                 $resultSolicitud = $this->objFunc->verificarPresupuesto();
                 
                $arrayResp[$cont_grup]["presu_verificado"] = $resultSolicitud->datos["presu_verificado"];
                 $cont_grup++;
                 
                 
                 if($resultSolicitud->getTipo()=='ERROR'){
                              
                      $resultSolicitud->imprimirRespuesta($resultSolicitud-> generarMensajeJson());
                      exit;
                 }
                 
                 
                  
            }
            
        }
	 	
	 	return $arrayResp;
	 }
	 else
	 	return array();
	}			
}

?>