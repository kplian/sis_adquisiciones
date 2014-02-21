<?php

require_once (dirname(__FILE__)).'/../../pxp/lib/PHPExcel/Classes/PHPExcel.php';
require_once (dirname(__FILE__)).'/../../pxp/lib/PHPExcel/Classes/PHPExcel/IOFactory.php';


class RCuadroComparativo extends Report{

		function write($fileName){
			        
			 
				$dataSourceProcesoCompra=$this->getDataSource();
			    $objectPHPExcel = new PHPExcel();
				$objectActiveSheet= $objectPHPExcel->getActiveSheet();
				
				$objectActiveSheet->getHeaderFooter()->setOddHeader('&L&H&6&BORIGINAL');
                $objectActiveSheet->getHeaderFooter()->setOddFooter('&L&8'."&8Usuario: \n&8Sistema: ".'&C&8Page &8&P of &8&N'."&R&8Fecha: &8&D\n&8Hora: &8&T");
    
                $objDrawing = new PHPExcel_Worksheet_Drawing();
				
				$objDrawing->setName('Logo');
				$objDrawing->setDescription('Logo');
				$objDrawing->setPath(dirname(__FILE__).'/../../pxp/lib'.$_SESSION['_DIR_LOGO']);
				$objDrawing->setHeight(60);
				$objDrawing->setCoordinates('H1');
				$objDrawing->setWorksheet($objectPHPExcel->getActiveSheet());

				$styleArrayTitle = array('font' => array('bold' => true,'size'=>15));
				$styleArraySubTitle = array('font' => array('bold' => false,'size'=>8));
				$objectActiveSheet->getStyle('C2')->applyFromArray($styleArrayTitle);				    
				$objectActiveSheet->setCellValue('C2','CUADRO COMPARATIVO DE OFERTAS');
				
				$objectActiveSheet->setCellValue('E3','Expresado en Bolivianos')->getStyle('E3')->applyFromArray($styleArraySubTitle);;
				$objectActiveSheet->setCellValue('E4','Formato: Compacto')->getStyle('E4')->applyFromArray($styleArraySubTitle);
				
				$objectActiveSheet->setCellValue('A5','Nº Proceso: '.$dataSourceProcesoCompra->getParameter('id_proceso_compra'))->getStyle('A5')->applyFromArray($styleArraySubTitle);
				$objectActiveSheet->setCellValue('C5','Codigo Proceso: '.$dataSourceProcesoCompra->getParameter('codigo_proceso'))->getStyle('C5')->applyFromArray($styleArraySubTitle);
				$objectActiveSheet->setCellValue('H5','Solicitud: '.$dataSourceProcesoCompra->getParameter('desc_solicitud'))->getStyle('H5')->applyFromArray($styleArraySubTitle);
				
			    $styleArrayCell = array(
                  'font' => array(
                    'name' => 'Arial',
                    'size' => '8',
                  ),
                  'borders' => array(
                    'left' => array(
                      'style' => PHPExcel_Style_Border::BORDER_THIN,
                    ),
                    'right' => array(
                      'style' => PHPExcel_Style_Border::BORDER_THIN,
                    ),
                    'bottom' => array(
                      'style' => PHPExcel_Style_Border::BORDER_THIN,
                    ),
                    'top' => array(
                      'style' => PHPExcel_Style_Border::BORDER_THIN,
                    ),
                  ),
                );
                //ESTILO PARA EL PRECIO TOTAL
                $styleArrayPriceTotal = array(
                'font'  => array(
                    'bold'  => true,
                    'color' => array('rgb' => 'FF0000'),
                    'size'  => 10,
                    'name'  => 'Verdana'
                ),
                'borders' => array(
                    'left' => array(
                      'style' => PHPExcel_Style_Border::BORDER_THIN,
                    ),
                    'right' => array(
                      'style' => PHPExcel_Style_Border::BORDER_THIN,
                    ),
                    'bottom' => array(
                      'style' => PHPExcel_Style_Border::BORDER_THIN,
                    ),
                    'top' => array(
                      'style' => PHPExcel_Style_Border::BORDER_THIN,
                    )
                   )
                
                );
                //ESTILO PARA CANTIDAD ADJUDICADA MAYOR A CERO
                $styleArrayCantAdjudicada = array(
                'font'  => array(
                    'bold'  => true,
                    'color' => array('rgb' => '32CD32'),
                    'size'  => 10,
                    'name'  => 'Verdana'
                ),
                'borders' => array(
                    'left' => array(
                      'style' => PHPExcel_Style_Border::BORDER_THIN,
                    ),
                    'right' => array(
                      'style' => PHPExcel_Style_Border::BORDER_THIN,
                    ),
                    'bottom' => array(
                      'style' => PHPExcel_Style_Border::BORDER_THIN,
                    ),
                    'top' => array(
                      'style' => PHPExcel_Style_Border::BORDER_THIN,
                    )
                   )
                
                );
                
                
                
				$objectActiveSheet->getColumnDimension('B')->setWidth(20);
				$objectActiveSheet->mergeCells('A7:A8')->getStyle('A7:A8')->getAlignment()->setVertical(PHPExcel_Style_Alignment::VERTICAL_CENTER);
				$objectActiveSheet->mergeCells('B7:B8')->getStyle('B7:B8')->getAlignment()->setVertical(PHPExcel_Style_Alignment::VERTICAL_CENTER);
				$objectActiveSheet->mergeCells('C7:C8')->getStyle('C7:C8')->getAlignment()->setVertical(PHPExcel_Style_Alignment::VERTICAL_CENTER);
				
				//cabecera grilla
				$objectActiveSheet->setCellValue('A7','Nro')->getStyle('A7:A8')->applyFromArray($styleArrayCell);
				$objectActiveSheet->setCellValue('B7','Descripcion del item')->getStyle('B7:B8')->applyFromArray($styleArrayCell);
				$objectActiveSheet->setCellValue('C7','Cant. Sol.')->getStyle('C7:C8')->applyFromArray($styleArrayCell);
				
				$itemsSolicitud= $dataSourceProcesoCompra->getParameter('detalleSolicitudDataSource')->getDataset();;
				
				
				
				//comienza en la linea 9
				//DEFINE LOS TIMES DE LA SOLICITUD
				for($i=0;$i<count($itemsSolicitud);$i++){
					$celda=$i+9;
					$objectActiveSheet->setCellValue('A'.$celda, $i+1)->getStyle('A'.$celda)->applyFromArray($styleArrayCell);
					
					$xx = $objectActiveSheet->setCellValue('B'.$celda, $itemsSolicitud[$i]['desc_concepto_ingas']." \n".$itemsSolicitud[$i]['descripcion'])->getStyle('B'.$celda);
					$xx->applyFromArray($styleArrayCell);
					$xx->getAlignment()->setWrapText(true);
					
					$objectActiveSheet->setCellValue('C'.$celda, $itemsSolicitud[$i]['cantidad'])->getStyle('C'.$celda)->applyFromArray($styleArrayCell);
				
                }
				
				$datasetCotizaciones = $dataSourceProcesoCompra->getParameter('cotizacionDataSource')->getDataset();
				
				$column = 3;
				$file = 7;
				$lastFile=0;
				
				//recorre las cotizaciones
				
				foreach ($datasetCotizaciones as $provider) {
					                   
					         //dibuja los header de la tabla      
					           
					              
					        $precio_total_adj = 0;  
					        $objectActiveSheet->mergeCellsByColumnAndRow($column,$file,$column+4,$file);
							$objectActiveSheet->setCellValueByColumnAndRow($column, $file, $provider['desc_proveedor']);
					        
					        
					        $objectActiveSheet->getStyleByColumnAndRow($column,$file)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow($column+1,$file)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow($column+2,$file)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow($column+3,$file)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow($column+4,$file)->applyFromArray($styleArrayCell);
							
							//cantidad cotizada
							$objectActiveSheet->setCellValueByColumnAndRow($column, $file+1, 'Cant. Cot.');
							$objectActiveSheet->getStyleByColumnAndRow($column,$file+1)->applyFromArray($styleArrayCell);
							
							//precio unitario
							$objectActiveSheet->setCellValueByColumnAndRow($column+1, $file+1, 'Precio U.');
							$objectActiveSheet->getStyleByColumnAndRow($column+1,$file+1)->applyFromArray($styleArrayCell);
							
							//precio total
							$objectActiveSheet->setCellValueByColumnAndRow($column+2, $file+1, 'Precio T.');
							$objectActiveSheet->getStyleByColumnAndRow($column+2,$file+1)->applyFromArray($styleArrayCell);
							
							//Cantidad Adjudicada
                            $objectActiveSheet->setCellValueByColumnAndRow($column+3, $file+1, 'Cant Adj.');
                            $objectActiveSheet->getStyleByColumnAndRow($column+3,$file+1)->applyFromArray($styleArrayCell);
                            
                            //Precio Adjudicado
                            $objectActiveSheet->setCellValueByColumnAndRow($column+4, $file+1, 'Precio Adj.');
                            $objectActiveSheet->getStyleByColumnAndRow($column+4,$file+1)->applyFromArray($styleArrayCell);
							
							
							
							$itemsCotizadosPorProveedor = $provider['dataset']->getDataset();
							
							//INTRODUCE LOS VALORES DE LACOTIZACION PARA CADA DETALLE DE LA SOLCITUD
							//prepara los valores de la cotizacion en la siguiete fila para cada item cotizado
							
							$fileItemCotizado=$file+2;
							$sw = true;
							for($i=0;$i<count($itemsSolicitud);$i++){
							            
    							        //valores por defecto
    							        $cantidad_coti = 0;
                                        $precio_unitario = 0;
                                        $precio_total = 0;
                                        $cantidad_adjudicada = 0;
                                        $precio_adjudicado = 0;
    							        
    							        
    							        //identificamos los item cotizados
    							        for($j=0;$j<count($itemsSolicitud);$j++){
    							                   
    							                if($itemsSolicitud[$i]['id_solicitud_det']==$itemsCotizadosPorProveedor[$j]['id_solicitud_det']){
                                                    $cantidad_coti = $itemsCotizadosPorProveedor[$i]['cantidad_coti'];
                                                    $precio_unitario = $itemsCotizadosPorProveedor[$i]['precio_unitario']*$provider['tipo_cambio_conv'];
                                                    $precio_total = $cantidad_coti * $precio_unitario;
                                                    
                                                    $cantidad_adjudicada = $itemsCotizadosPorProveedor[$i]['cantidad_adju'];
                                                    $precio_adjudicado = $cantidad_adjudicada * $precio_unitario;
                                                    break;
                                                 }
    							        }
							    
											//TODO CAMBIAR COLOR SI CANTIDAD ADJUDICADA ES MAYOR A CERO
											
											if($cantidad_adjudicada > 0){
											    $tmpArray =   $styleArrayCantAdjudicada;
											}else{
											    $tmpArray = $styleArrayCell;
											}
											
								 			$objectActiveSheet->setCellValueByColumnAndRow($column, $fileItemCotizado, $cantidad_coti);
											$objectActiveSheet->getStyleByColumnAndRow($column,$fileItemCotizado)->applyFromArray($tmpArray);	
																								
											$objectActiveSheet->setCellValueByColumnAndRow($column+1, $fileItemCotizado, $precio_unitario);
											$objectActiveSheet->getStyleByColumnAndRow($column+1,$fileItemCotizado)->applyFromArray($tmpArray);
											
											$objectActiveSheet->setCellValueByColumnAndRow($column+2, $fileItemCotizado,$precio_total );
											$objectActiveSheet->getStyleByColumnAndRow($column+2,$fileItemCotizado)->applyFromArray($tmpArray);
									
                                            $objectActiveSheet->setCellValueByColumnAndRow($column+3, $fileItemCotizado,$cantidad_adjudicada );
                                            $objectActiveSheet->getStyleByColumnAndRow($column+3,$fileItemCotizado)->applyFromArray($tmpArray);
                                    
                                            $objectActiveSheet->setCellValueByColumnAndRow($column+4, $fileItemCotizado,$precio_adjudicado );
                                            $objectActiveSheet->getStyleByColumnAndRow($column+4,$fileItemCotizado)->applyFromArray($tmpArray);
                                    
                                           
											$fileItemCotizado=$fileItemCotizado+1;
											
											$precio_total_adj = $precio_total_adj +	$precio_adjudicado;								
									}
							
							
							//PLAZO DE ENTERGA
							
							
							if($sw){
							        
							    $objectActiveSheet->setCellValueByColumnAndRow(0, $fileItemCotizado, 'Precio Total Adjudicado');
                                $objectActiveSheet->getStyleByColumnAndRow(0,$fileItemCotizado)->applyFromArray($styleArrayCell);
                                $objectActiveSheet->getStyleByColumnAndRow(1,$fileItemCotizado)->applyFromArray($styleArrayCell);
                                $objectActiveSheet->getStyleByColumnAndRow(2,$fileItemCotizado)->applyFromArray($styleArrayCell);
                                $objectActiveSheet->mergeCellsByColumnAndRow(0,$fileItemCotizado,2,$fileItemCotizado);
                                                
							    $objectActiveSheet->setCellValueByColumnAndRow(0, $fileItemCotizado+1, 'Plazo de Entrega');
                                $objectActiveSheet->getStyleByColumnAndRow(0,$fileItemCotizado+1)->applyFromArray($styleArrayCell);
                                $objectActiveSheet->getStyleByColumnAndRow(1,$fileItemCotizado+1)->applyFromArray($styleArrayCell);
                                $objectActiveSheet->getStyleByColumnAndRow(2,$fileItemCotizado+1)->applyFromArray($styleArrayCell);
                                $objectActiveSheet->mergeCellsByColumnAndRow(0,$fileItemCotizado+1,2,$fileItemCotizado+1);
                                
                                $objectActiveSheet->setCellValueByColumnAndRow(0, $fileItemCotizado+2, 'Lugar de Entrega');
                                $objectActiveSheet->getStyleByColumnAndRow(0,$fileItemCotizado+2)->applyFromArray($styleArrayCell);
                                $objectActiveSheet->getStyleByColumnAndRow(1,$fileItemCotizado+2)->applyFromArray($styleArrayCell);
                                $objectActiveSheet->getStyleByColumnAndRow(2,$fileItemCotizado+2)->applyFromArray($styleArrayCell);
                                $objectActiveSheet->mergeCellsByColumnAndRow(0,$fileItemCotizado+2,2,$fileItemCotizado+2);           
							    
							    $objectActiveSheet->setCellValueByColumnAndRow(0, $fileItemCotizado+3, 'Validez de la oferta');
                                $objectActiveSheet->getStyleByColumnAndRow(0,$fileItemCotizado+3)->applyFromArray($styleArrayCell);
                                $objectActiveSheet->getStyleByColumnAndRow(1,$fileItemCotizado+3)->applyFromArray($styleArrayCell);
                                $objectActiveSheet->getStyleByColumnAndRow(2,$fileItemCotizado+3)->applyFromArray($styleArrayCell);
                                $objectActiveSheet->mergeCellsByColumnAndRow(0,$fileItemCotizado+3,2,$fileItemCotizado+3);
                               
							        
							  $sw = false;  
							}
							
							
							                           
							
							
							$objectActiveSheet->setCellValueByColumnAndRow($column, $fileItemCotizado, $precio_total_adj);
							$objectActiveSheet->getStyleByColumnAndRow($column,$fileItemCotizado)->applyFromArray($styleArrayPriceTotal);
							$objectActiveSheet->getStyleByColumnAndRow($column+1,$fileItemCotizado)->applyFromArray($styleArrayPriceTotal);
							$objectActiveSheet->getStyleByColumnAndRow($column+2,$fileItemCotizado)->applyFromArray($styleArrayPriceTotal);
							$objectActiveSheet->getStyleByColumnAndRow($column+3,$fileItemCotizado)->applyFromArray($styleArrayPriceTotal);
                            $objectActiveSheet->getStyleByColumnAndRow($column+4,$fileItemCotizado)->applyFromArray($styleArrayPriceTotal);
                            $objectActiveSheet->mergeCellsByColumnAndRow($column,$fileItemCotizado,$column+4,$fileItemCotizado);
							
							
							
							$objectActiveSheet->setCellValueByColumnAndRow($column, $fileItemCotizado+1, $provider['fecha_entrega']);
							$objectActiveSheet->getStyleByColumnAndRow($column,$fileItemCotizado+1)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow($column+1,$fileItemCotizado+1)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow($column+2,$fileItemCotizado+1)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow($column+3,$fileItemCotizado+1)->applyFromArray($styleArrayCell);
                            $objectActiveSheet->getStyleByColumnAndRow($column+4,$fileItemCotizado+1)->applyFromArray($styleArrayCell);
                            $objectActiveSheet->mergeCellsByColumnAndRow($column,$fileItemCotizado+1,$column+4,$fileItemCotizado+1);
							
							
							$objectActiveSheet->setCellValueByColumnAndRow($column, $fileItemCotizado+2, $provider['lugar_entrega']);
							$objectActiveSheet->getStyleByColumnAndRow($column,$fileItemCotizado+2)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow($column+1,$fileItemCotizado+2)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow($column+2,$fileItemCotizado+2)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow($column+3,$fileItemCotizado+2)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow($column+4,$fileItemCotizado+2)->applyFromArray($styleArrayCell);
							$objectActiveSheet->mergeCellsByColumnAndRow($column,$fileItemCotizado+2,$column+4,$fileItemCotizado+2);
							
							
							$objectActiveSheet->setCellValueByColumnAndRow($column, $fileItemCotizado+3, $provider['fecha_venc']);
                            $objectActiveSheet->getStyleByColumnAndRow($column,$fileItemCotizado+3)->applyFromArray($styleArrayCell);
                            $objectActiveSheet->getStyleByColumnAndRow($column+1,$fileItemCotizado+3)->applyFromArray($styleArrayCell);
                            $objectActiveSheet->getStyleByColumnAndRow($column+2,$fileItemCotizado+3)->applyFromArray($styleArrayCell);
                            $objectActiveSheet->getStyleByColumnAndRow($column+3,$fileItemCotizado+3)->applyFromArray($styleArrayCell);
                            $objectActiveSheet->getStyleByColumnAndRow($column+4,$fileItemCotizado+3)->applyFromArray($styleArrayCell);
                            $objectActiveSheet->mergeCellsByColumnAndRow($column,$fileItemCotizado+3,$column+4,$fileItemCotizado+3);
                            
                            
                                    							
							
							
							$column=$column+5;
							$lastFile=$fileItemCotizado+5;
				}
												
				$objWriter = PHPExcel_IOFactory::createWriter($objectPHPExcel, 'Excel5');
			 $objWriter->save($fileName);
		}
	
}
?>