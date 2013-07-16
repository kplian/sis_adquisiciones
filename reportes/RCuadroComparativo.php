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

				$styleArrayTitle = array(
    'font' => array('bold' => true,'size'=>15)
				);
				$styleArraySubTitle = array(
    'font' => array('bold' => false,'size'=>8)
				);
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
				$objectActiveSheet->getColumnDimension('B')->setWidth(20);
				$objectActiveSheet->mergeCells('A7:A8')->getStyle('A7:A8')->getAlignment()->setVertical(PHPExcel_Style_Alignment::VERTICAL_CENTER);
				$objectActiveSheet->mergeCells('B7:B8')->getStyle('B7:B8')->getAlignment()->setVertical(PHPExcel_Style_Alignment::VERTICAL_CENTER);
				$objectActiveSheet->mergeCells('C7:C8')->getStyle('C7:C8')->getAlignment()->setVertical(PHPExcel_Style_Alignment::VERTICAL_CENTER);
				$objectActiveSheet->setCellValue('A7','Nro')->getStyle('A7:A8')->applyFromArray($styleArrayCell);
				$objectActiveSheet->setCellValue('B7','Descripcion del item')->getStyle('B7:B8')->applyFromArray($styleArrayCell);
				$objectActiveSheet->setCellValue('C7','Cantidad')->getStyle('C7:C8')->applyFromArray($styleArrayCell);
				
				$datasetItems= $dataSourceProcesoCompra->getParameter('detalleSolicitudDataSource')->getDataset();;
				for($i=0;$i<count($datasetItems);$i++){
					$celda=$i+9;
					$objectActiveSheet->setCellValue('A'.$celda,$i+1)->getStyle('A'.$celda)->applyFromArray($styleArrayCell);
					$objectActiveSheet->setCellValue('B'.$celda,$datasetItems[$i]['desc_concepto_ingas'])->getStyle('B'.$celda)->applyFromArray($styleArrayCell);
					$objectActiveSheet->setCellValue('C'.$celda,$datasetItems[$i]['cantidad'])->getStyle('C'.$celda)->applyFromArray($styleArrayCell);
				}
				
				$datasetCotizaciones = $dataSourceProcesoCompra->getParameter('cotizacionDataSource')->getDataset();
				
				$column = 3;
				$file = 7;
				$lastFile=0;
				foreach ($datasetCotizaciones as $provider) {
					  $objectActiveSheet->mergeCellsByColumnAndRow($column,$file,$column+2,$file);
							$objectActiveSheet->setCellValueByColumnAndRow($column, $file, $provider['desc_proveedor']);
					  $objectActiveSheet->getStyleByColumnAndRow($column,$file)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow($column+1,$file)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow($column+2,$file)->applyFromArray($styleArrayCell);
							$objectActiveSheet->setCellValueByColumnAndRow($column, $file+1, 'Cant. Cot.');
							$objectActiveSheet->getStyleByColumnAndRow($column,$file+1)->applyFromArray($styleArrayCell);
							$objectActiveSheet->setCellValueByColumnAndRow($column+1, $file+1, 'Precio U.');
							$objectActiveSheet->getStyleByColumnAndRow($column+1,$file+1)->applyFromArray($styleArrayCell);
							$objectActiveSheet->setCellValueByColumnAndRow($column+2, $file+1, 'Precio T.');
							$objectActiveSheet->getStyleByColumnAndRow($column+2,$file+1)->applyFromArray($styleArrayCell);
							
							$itemsCotizadosPorProveedor = $provider['dataset']->getDataset();
							$fileItemCotizado=$file+2;
							for($i=0;$i<count($itemsCotizadosPorProveedor);$i++){
											if($datasetItems[$i]['desc_concepto_ingas']==$itemsCotizadosPorProveedor[$i]['desc_solicitud_det']){
										 			$objectActiveSheet->setCellValueByColumnAndRow($column, $fileItemCotizado, $itemsCotizadosPorProveedor[$i]['cantidad_coti']);
													 $objectActiveSheet->getStyleByColumnAndRow($column,$fileItemCotizado)->applyFromArray($styleArrayCell);														
													 $objectActiveSheet->setCellValueByColumnAndRow($column+1, $fileItemCotizado, $itemsCotizadosPorProveedor[$i]['precio_unitario']*$provider['tipo_cambio_conv']);
														$objectActiveSheet->getStyleByColumnAndRow($column+1,$fileItemCotizado)->applyFromArray($styleArrayCell);
														$objectActiveSheet->setCellValueByColumnAndRow($column+2, $fileItemCotizado, $itemsCotizadosPorProveedor[$i]['cantidad_coti']*$itemCotizado['precio_unitario']);
														$objectActiveSheet->getStyleByColumnAndRow($column+2,$fileItemCotizado)->applyFromArray($styleArrayCell);
											}
											$fileItemCotizado=$fileItemCotizado+1;									
									}
							$objectActiveSheet->setCellValueByColumnAndRow(0, $fileItemCotizado, 'Plazo de Entrega');
							$objectActiveSheet->getStyleByColumnAndRow(0,$fileItemCotizado)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow(1,$fileItemCotizado)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow(2,$fileItemCotizado)->applyFromArray($styleArrayCell);
							$objectActiveSheet->mergeCellsByColumnAndRow(0,$fileItemCotizado,2,$fileItemCotizado);
							$objectActiveSheet->setCellValueByColumnAndRow($column, $fileItemCotizado, $provider['fecha_entrega']);
							$objectActiveSheet->getStyleByColumnAndRow($column,$fileItemCotizado)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow($column+1,$fileItemCotizado)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow($column+2,$fileItemCotizado)->applyFromArray($styleArrayCell);
							$objectActiveSheet->mergeCellsByColumnAndRow($column,$fileItemCotizado,$column+2,$fileItemCotizado);
							
							$objectActiveSheet->setCellValueByColumnAndRow(0, $fileItemCotizado+1, 'Lugar de Entrega');
							$objectActiveSheet->getStyleByColumnAndRow(0,$fileItemCotizado+1)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow(1,$fileItemCotizado+1)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow(2,$fileItemCotizado+1)->applyFromArray($styleArrayCell);
							$objectActiveSheet->mergeCellsByColumnAndRow(0,$fileItemCotizado+1,2,$fileItemCotizado+1);
							$objectActiveSheet->setCellValueByColumnAndRow($column, $fileItemCotizado+1, $provider['lugar_entrega']);
							$objectActiveSheet->getStyleByColumnAndRow($column,$fileItemCotizado+1)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow($column+1,$fileItemCotizado+1)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow($column+2,$fileItemCotizado+1)->applyFromArray($styleArrayCell);
							$objectActiveSheet->mergeCellsByColumnAndRow($column,$fileItemCotizado+1,$column+2,$fileItemCotizado+1);
							
							$objectActiveSheet->setCellValueByColumnAndRow(0, $fileItemCotizado+2, 'Validez de la oferta');
							$objectActiveSheet->getStyleByColumnAndRow(0,$fileItemCotizado+2)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow(1,$fileItemCotizado+2)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow(2,$fileItemCotizado+2)->applyFromArray($styleArrayCell);
							$objectActiveSheet->setCellValueByColumnAndRow($column, $fileItemCotizado+2, $provider['fecha_venc']);
							$objectActiveSheet->getStyleByColumnAndRow($column,$fileItemCotizado+2)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow($column+1,$fileItemCotizado+2)->applyFromArray($styleArrayCell);
							$objectActiveSheet->getStyleByColumnAndRow($column+2,$fileItemCotizado+2)->applyFromArray($styleArrayCell);
							$objectActiveSheet->mergeCellsByColumnAndRow($column,$fileItemCotizado+2,$column+2,$fileItemCotizado+2);							
							$objectActiveSheet->mergeCellsByColumnAndRow(0,$fileItemCotizado+2,2,$fileItemCotizado+2);
							
							
							$column=$column+3;
							$lastFile=$fileItemCotizado+5;
				}
												
				$objWriter = PHPExcel_IOFactory::createWriter($objectPHPExcel, 'Excel5');
			 $objWriter->save($fileName);
		}
	
}
?>