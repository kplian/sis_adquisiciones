<?php
/**
*@package pXP
*@file DiagramadorGantt.php
*@author  Gonzalo Sarmiento
*@date 03-05-2013
*@description Clase que que genera el diagrama Gantt con ayuda de la libreria jpgraph
*/
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
require_once (dirname(__FILE__).'/../../pxp/lib/jpgraph/src/jpgraph.php');
require_once (dirname(__FILE__).'/../../pxp/lib/jpgraph/src/jpgraph_gantt.php');

class DiagramadorGantt{
	
    private $dataSource;
				private $fechaInicio;
				private $numBarras=0;
    
    public function setDataSource(DataSource $dataSource) {
        $this->dataSource = $dataSource;
    }
    
    public function getDataSource() {
        return $this->dataSource;
    }
				
				public function getNumBarras()
				{
					 return $this->numBarras;
				}
				
				public function setNumBarras($valor){
					 $this->numBarras = $valor;
				}				
	
				public function graficar($filename){
					
					
					$graph = new GanttGraph();
					$graph->SetShadow();
					//$graph->SetBox();
					
					// Only show part of the Gantt
					
					$graph = new GanttGraph(0,0);
					$graph->title->Set('Proceso '.$this->dataSource->getParameter('desc_proceso_macro')."\n".
																								'Seguimiento de Solicitud '.$this->dataSource->getParameter('numero')."\n".
																								'Unidad '.$this->dataSource->getParameter('desc_uo'));
					$graph->title->SetFont(FF_ARIAL,FS_BOLD,6);
					
					// Setup some "very" nonstandard colors
					$graph->SetMarginColor('lightgreen@0.8');
					$graph->SetBox(true,'yellow:0.6',2);
					$graph->SetFrame(true,'darkgreen',4);
					$graph->scale->divider->SetColor('yellow:0.6');
					$graph->scale->dividerh->SetColor('yellow:0.6');
					
					// Explicitely set the date range 
					// (Autoscaling will of course also work)
					
					// Display month and year scale with the gridlines
					$graph->ShowHeaders(GANTT_HMONTH | GANTT_HYEAR | GANTT_HDAY);
					$graph->scale->month->grid->SetColor('gray');
					$graph->scale->month->grid->Show(true);
					$graph->scale->year->grid->SetColor('gray');
					$graph->scale->year->grid->Show(true);					
					
					// Setup activity info
					
					// For the titles we also add a minimum width of 100 pixels for the Task name column
					$graph->scale->actinfo->SetColTitles(
					    array('Tipo','Estado','Responsable','Duracion','Inicio','Fin'),array(40,100));
					$graph->scale->actinfo->SetBackgroundColor('green:0.5@0.5');
					$graph->scale->actinfo->SetFont(FF_ARIAL,FS_NORMAL,10);
					
					
					$dataset=$this->dataSource->getDataset();
					$datasetSolicitud = $dataset->getDataset();
					$this->fechaInicio=	$datasetSolicitud[0]['fecha_reg'];
					
					$datasetSolictudAgrupado = array();
					$res = array();
					for ($i=0; $i<count($datasetSolicitud); $i++) {
						  array_push($res,$datasetSolicitud[$i]);
								if($datasetSolicitud[$i]['nombre_estado']=='En_Proceso'){
									array_push($datasetSolictudAgrupado,$res);
									$res = array();
								}
					}					
					$a=0;
					$this->graficarBarras($datasetSolictudAgrupado[$a], $graph);
					if(count($dataset->getParameters())!=0){
							for($i=0;$i<count($dataset->getParameters());$i++){
								
									 $dataSourceProceso=$dataset->getParameter('dataSourceProceso.'.$i);
							   $datasetProceso = $dataSourceProceso->getDataset();
										$a++;
										$this->graficarBarras($datasetProceso, $graph);								
										$this->graficarBarras($datasetSolictudAgrupado[$a], $graph);
										
										if(count($dataSourceProceso->getParameters())!=0){
												for($j=0;$j<count($dataSourceProceso->getParameters());$j++){								
															$dataSourceCotizacion = $dataSourceProceso->getParameter('dataSourceCotizacion.'.$j);
													  $datasetCotizacion = $dataSourceCotizacion->getDataset();
															$this->graficarBarras($datasetCotizacion, $graph); 
															
															for($k=0;$k<count($dataSourceCotizacion->getParameters());$k++){
																		$dataSourcePago = $dataSourceCotizacion->getParameter('dataSourcePago');
																		$datasetPago = $dataSourcePago->getDataset();
																		$this->graficarBarras($datasetPago, $graph);
															}
												}
										}
							}
					}
					
					//var_dump($graph);
					$graph->SetDateRange($this->fechaInicio,$this->fechaFin);					 
				 $archivo = dirname(__FILE__).'/../../reportes_generados/'.$filename;
					$graph->Stroke($archivo);
				}

				public function graficarBarras($dataset, $graph){
								
					  $tamanioDataset = count($dataset);
							//$fechaInicio=0;
							//$fechaFin=0;
							for ($i=0;$i<$tamanioDataset;$i++) {
								//var_dump($dataset[$i]);
									if($dataset[$i]['nombre_estado']=='En_Proceso'||$dataset[$i]['nombre_estado']=='Habilitado para pagar'||$dataset[$i]['nombre_estado']=='En Pago'){
											$milestone = new MileStone($this->numBarras,$dataset[$i]['nombre_estado'],$dataset[$i]['fecha_reg'],$dataset[$i]['fecha_reg']);
											$milestone->title->SetColor("black");
											$milestone->title->SetFont(FF_FONT1,FS_BOLD);
											$graph->Add($milestone);	
											$this->numBarras+=1;
											continue;
									}else{
															 
								 $actividad = array();
								 array_push($actividad,$i);		
									if($i==($tamanioDataset-1))
												$this->fechaFin = $dataset[$i]['fecha_reg'];
									else
												$this->fechaFin = $dataset[$i+1]['fecha_reg'];													
									$startLiteral = new DateTime($dataset[$i]['fecha_reg']);
									$endLiteral = new DateTime($this->fechaFin);									
									$start = strtotime($dataset[$i]['fecha_reg']);
									$end = strtotime($this->fechaFin);
									$days_between = ceil(($end - $start) / 86400);
									$cabecera = array($dataset[$i]['nombre'],$dataset[$i]['nombre_estado'],($dataset[$i]['funcionario']!=null)?$dataset[$i]['funcionario']:'',"$days_between".' dias', $startLiteral->format('d M Y') ,$endLiteral->format('d M Y'));
									array_push($actividad,$cabecera);
									array_push($actividad, $dataset[$i]['fecha_reg']);
									array_push($actividad, $this->fechaFin);
									array_push($actividad, FF_ARIAL);
									array_push($actividad, FS_NORMAL);
									array_push($actividad, 8);
									//array_push($data,$actividad);									
									
									$bar = new GanttBar($this->numBarras,$actividad[1],$actividad[2],$actividad[3],"[100%]",10);
								//if( count($data[$i])>4 )
									$bar->title->SetFont($actividad[4],$actividad[5],$actividad[6]);
								$bar->SetPattern(BAND_RDIAG,"yellow");
								$bar->SetFillColor("gray");
								$bar->progress->Set(1);
								$bar->progress->SetPattern(GANTT_SOLID,"darkgreen");
								$graph->Add($bar);
								$this->numBarras+=1;				
									}				 
							}	
				}
}

?>