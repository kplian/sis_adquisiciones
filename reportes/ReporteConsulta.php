<?php
class ReporteConsulta
{
    function __construct(CTParametro $objParam){
        $this->objParam = $objParam;
        $this->url_archivo = "../../../reportes_generados/".$this->objParam->getParametro('nombre_archivo');
        set_time_limit(400);
        $cacheMethod = PHPExcel_CachedObjectStorageFactory:: cache_to_phpTemp;
        $cacheSettings = array('memoryCacheSize'  => '10MB');
        PHPExcel_Settings::setCacheStorageMethod($cacheMethod, $cacheSettings);
        $this->docexcel = new PHPExcel();
        $this->docexcel->getProperties()->setCreator("PXP")
                                ->setLastModifiedBy("PXP")
                                ->setTitle($this->objParam->getParametro('titulo_archivo'))
                                ->setSubject($this->objParam->getParametro('titulo_archivo'))
                                ->setDescription('Reporte "'.$this->objParam->getParametro('titulo_archivo').'", generado por el framework PXP')
                                ->setKeywords("office 2007 openxml php")
                                ->setCategory("Report File");
        $sheetId = 1;
        $this->docexcel->createSheet(NULL, $sheetId);	
        $this->docexcel->setActiveSheetIndex($sheetId);	
        $this->docexcel->setActiveSheetIndex(0);
        
        $this->equivalencias=array(0=>'A',1=>'B',2=>'C',3=>'D',4=>'E',5=>'F',6=>'G',7=>'H',8=>'I',
                                9=>'J',10=>'K',11=>'L',12=>'M',13=>'N',14=>'O',15=>'P',16=>'Q',17=>'R',
                                18=>'S',19=>'T',20=>'U',21=>'V',22=>'W',23=>'X',24=>'Y',25=>'Z',
                                26=>'AA',27=>'AB',28=>'AC',29=>'AD',30=>'AE',31=>'AF',32=>'AG',33=>'AH',
                                34=>'AI',35=>'AJ',36=>'AK',37=>'AL',38=>'AM',39=>'AN',40=>'AO',41=>'AP',
                                42=>'AQ',43=>'AR',44=>'AS',45=>'AT',46=>'AU',47=>'AV',48=>'AW',49=>'AX',
                                50=>'AY',51=>'AZ',
                                52=>'BA',53=>'BB',54=>'BC',55=>'BD',56=>'BE',57=>'BF',58=>'BG',59=>'BH',
                                60=>'BI',61=>'BJ',62=>'BK',63=>'BL',64=>'BM',65=>'BN',66=>'BO',67=>'BP',
                                68=>'BQ',69=>'BR',70=>'BS',71=>'BT',72=>'BU',73=>'BV',74=>'BW',75=>'BX',
                                76=>'BY',77=>'BZ');
    }

    function imprimeDetalle(){

        

        $this->docexcel->getActiveSheet()->setTitle('Detalle');
        $datos = $this->objParam->getParametro('datos');	
        $columnas = 0;
        $this->docexcel->setActiveSheetIndex(0);
        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(7);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(40);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(40);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(40);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(20);
        //
        function dias_laborales($inicio, $fin)
        {
            $dias_labo = 0;
            $iniFec = strtotime($inicio);
            $finFec = strtotime($fin);
            for ($i = $iniFec; $i <= $finFec; $i = $i + (60 * 60 * 24)) {
                if (date("N", $i) <= 5) $dias_labo = $dias_labo + 1;
            }
            return $dias_labo;
        }
        $styleTitulos = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 10,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '339FFF'
                )
            ),
        );
        $styleDetalle = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 8,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => 'c5d9f1'
                )
            ),
            'borders' => array(
            'allborders' => array(
                'style' => PHPExcel_Style_Border::BORDER_THIN
            )
        ));
        $this->docexcel->getActiveSheet()->setCellValue('C1','DETALLE DE PROCESOS CONCLUIDOS Y EVALUADOS');
        $this->docexcel->getActiveSheet()->getStyle('C1:G1')->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->mergeCells('C1:G1');

        $this->docexcel->getActiveSheet()->getStyle('A5:O5')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A5:O5')->applyFromArray($styleDetalle);
        //*************************************Cabecera*****************************************
        $this->docexcel->getActiveSheet()->setCellValue('A5','No');
        $this->docexcel->getActiveSheet()->setCellValue('B5','Nro. Orden');
        $this->docexcel->getActiveSheet()->setCellValue('C5','Suministro/Servicio');
        $this->docexcel->getActiveSheet()->setCellValue('D5','Proveedor');
        $this->docexcel->getActiveSheet()->setCellValue('E5','Responsable');
        $this->docexcel->getActiveSheet()->setCellValue('F5','Estado');
        $this->docexcel->getActiveSheet()->setCellValue('G5','Fecha ingreso documentos');
        $this->docexcel->getActiveSheet()->setCellValue('H5','Fecha generacion orden de compra');
        $this->docexcel->getActiveSheet()->setCellValue('I5','DÍAS HABILES');
        $this->docexcel->getActiveSheet()->setCellValue('J5','Monto adjudicación');
        $this->docexcel->getActiveSheet()->setCellValue('K5','Monto adjudicación');
        $this->docexcel->getActiveSheet()->setCellValue('L5','Fecha Prevista');
        $this->docexcel->getActiveSheet()->setCellValue('M5','Fecha Recepción');
        $this->docexcel->getActiveSheet()->setCellValue('N5','Fecha Evaluación Seguimiento');
        $this->docexcel->getActiveSheet()->setCellValue('O5','Eval. Total');
        //*************************************Detalle*****************************************
        $fila = 6;
        $dias_labo=0;
        $i=1;
        foreach($datos as $value) {
            $dias_labo = dias_laborales($value['fecha_apro'],$value['fecha_adju']);
         
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $i);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['num_tramite']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['justificacion']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['desc_proveedor']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['desc_funcionario']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, '');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, date("d/m/Y", strtotime($value['fecha_apro'])));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, date("d/m/Y", strtotime($value['fecha_adju'])));
            if($dias_labo==0){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, 'Error en diferencia');
            }else{
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $dias_labo);
            }
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, number_format($value['monto_total_adjudicado_mb'],2));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['moneda']);
            $fila++;
            $i++;
        }
    }

    function generarReporte() {
        $this->docexcel->setActiveSheetIndex(0);
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);	
    }

}
?>