<?php
require_once dirname(__FILE__).'/../../pxp/pxpReport/Report.php';
 class CustomReport extends TCPDF {
    
    private $dataSource;
    
    public function setDataSource(DataSource $dataSource) {
        $this->dataSource = $dataSource;
    }
    
    public function getDataSource() {
        return $this->dataSource;
    }
    
    public function Header() {
        $height = 20;
        $this->Cell(40, $height, '', 0, 0, 'C', false, '', 0, false, 'T', 'C');
        
        $this->SetFontSize(16);
        $this->SetFont('','B');        
        $this->Cell(105, $height, 'SOLICITUD DE COMPRA', 0, 0, 'C', false, '', 0, false, 'T', 'C');        
        
								$x=$this->getX();
								$y=$this->getY();
        $this->Image(dirname(__FILE__).'/../../pxp/lib'.$_SESSION['_DIR_LOGO'], $x, $y, 36);
        
    }
    
    public function Footer() {
        $this->SetFontSize(5.5);
								$this->setY(-10);
								$ormargins = $this->getOriginalMargins();
								$this->SetTextColor(0, 0, 0);
								//set style for cell border
								$line_width = 0.85 / $this->getScaleFactor();
								$this->SetLineStyle(array('width' => $line_width, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
								$ancho = round(($this->getPageWidth() - $ormargins['left'] - $ormargins['right']) / 3);
								$this->Ln(2);
								$cur_y = $this->GetY();
								//$this->Cell($ancho, 0, 'Generado por XPHS', 'T', 0, 'L');
								$this->Cell($ancho, 0, 'Usuario: '.$_SESSION['_LOGIN'], '', 1, 'L');
								$pagenumtxt = 'Página'.' '.$this->getAliasNumPage().' de '.$this->getAliasNbPages();
								//$this->Cell($ancho, 0, '', '', 0, 'C');
								$fecha_rep = date("d-m-Y H:i:s");
								$this->Cell($ancho, 0, "Fecha impresión: ".$fecha_rep, '', 0, 'L');
								$this->Ln($line_width);
			 }
}
Class RSolicitudCompra extends Report {
    function write($fileName) {
        $pdf = new CustomReport('P', PDF_UNIT, "LETTER", true, 'UTF-8', false);
        $pdf->setDataSource($this->getDataSource());
        // set document information
        $pdf->SetCreator(PDF_CREATOR);
        
        // set default monospaced font
        $pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);
        
        //set margins
        $pdf->SetMargins(PDF_MARGIN_LEFT, 40, PDF_MARGIN_RIGHT);
        $pdf->SetHeaderMargin(10);
        $pdf->SetFooterMargin(PDF_MARGIN_FOOTER);
        
        //set auto page breaks
        $pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);
        
        //set image scale factor
        $pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
        
        //set some language-dependent strings
        
        // add a page
        $pdf->AddPage();
        
        $height = 5;
        $width1 = 15;
        $width2 = 20;
        $width3 = 35;
        $width4 = 75;
        
        $pdf->SetFontSize(8.5);
        $pdf->SetFont('', 'B');
        $pdf->setTextColor(0,0,0);
        $pdf->Cell($width3, $height, 'Número de Solicitud', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width3, $height, 'Fecha de Solicitud', 0, 0, 'C', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width3, $height, 'Fecha de Aprobacion', 0, 0, 'C', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width2+5, $height, 'Tipo', 0, 0, 'C', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width2+5, $height, 'Moneda', 0, 0, 'C', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width2+5, $height, 'Gestion', 0, 0, 'C', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
        
        $pdf->SetFont('', '');        
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('numero'), 0, 0, 'C', false, '', 0, false, 'T', 'C');        
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('fecha_soli'), 0, 0, 'C', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width3, $height, $this->getDataSource()->getParameter('fecha_apro'), 0, 0, 'C', false, '', 0, false, 'T', 'C');        
        $pdf->Cell($width2+5, $height, $this->getDataSource()->getParameter('tipo'), 0, 0, 'C', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width2+5, $height, $this->getDataSource()->getParameter('desc_moneda'), 0, 0, 'C', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width2+5, $height, $this->getDataSource()->getParameter('desc_gestion'), 0, 0, 'C', false, '', 0, false, 'T', 'C');
        $pdf->Ln();
        $pdf->Ln();
    
        $white = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(255, 255, 255)));
        $black = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
        //$pdf->setLineStyle($white);
        $pdf->SetFontSize(7);
        $pdf->SetFont('', 'B');
        $pdf->Cell($width3, $height, 'Proceso:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width3+$width2, $height, $this->getDataSource()->getParameter('desc_proceso_macro'), $white, 0, 'L', true, '', 0, false, 'T', 'C');
        $pdf->SetFont('', 'B');
        
        $pdf->Cell(5, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width3, $height, 'Categoria de Compra:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width3+$width2, $height, $this->getDataSource()->getParameter('desc_categoria_compra'), $white, 0, 'L', true, '', 0, false, 'T', 'C');
        
        $pdf->Ln();
        
        $pdf->SetFont('', 'B');                             
        $pdf->Cell($width3, $height, 'Gerente:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->SetFillColor(192,192,192, true);
        //$pdf->MultiCell($width3+$width2, $height, $this->getDataSource()->getParameter('desc_funcionario_apro'), 0,'L', true ,0);
        $pdf->Cell($width3+$width2, $height, $this->getDataSource()->getParameter('desc_funcionario_apro'), $white, 0, 'L', true, '', 0, false, 'T', 'C');        
        
        $pdf->Cell(5, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', 'B');
        $pdf->Cell($width3, $height, 'RPC:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->SetFillColor(192,192,192, true);
        //$pdf->MultiCell($width3+$width2, $height, $this->getDataSource()->getParameter('desc_funcionario_rpc'), 1,'L', true ,1);
        $pdf->Cell($width3+$width2, $height, $this->getDataSource()->getParameter('desc_funcionario_rpc'), $white, 0, 'L', true, '', 0, false, 'T', 'C');        
        $pdf->Ln();
        
        
        $pdf->SetFont('', 'B');                             
        $pdf->Cell($width3, $height, 'Unidad Solicitante:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->SetFillColor(192,192,192, true);
        $pdf->MultiCell($width3+$width2, $height, $this->getDataSource()->getParameter('desc_uo'), 0,'L', true ,0);
        
        //$pdf->Cell($width3+$width2, $height, $this->getDataSource()->getParameter('desc_uo'), $white, 0, 'L', true, '', 1, false, 'T', 'C');        
        $pdf->Cell(5, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', 'B');
        $pdf->Cell($width3, $height, 'Funcionario:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->SetFillColor(192,192,192, true);
        $pdf->MultiCell($width3+$width2, $height, $this->getDataSource()->getParameter('desc_funcionario'), 1,'L', true ,1);
        //$pdf->Cell($width3+$width2, $height, $this->getDataSource()->getParameter('desc_funcionario'), $white, 0, 'L', true, '', 0, false, 'T', 'C');        
       
        
        $pdf->Ln();
        
        
        //imprime el detalle de la solicitud
        
        $this->writeDetalles($this->getDataSource()->getParameter('detalleDataSource'), $pdf);
        
        //imprime el pie del reporte
        
        $pdf->SetFontSize(8);
        $pdf->SetFont('', 'B');
        $pdf->Cell($width3, $height, 'Justificación', 0, 0, 'L', false, '', 1, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->MultiCell($width4*2, $height, $this->getDataSource()->getParameter('justificacion'), 0,'L', false ,0);
        $pdf->Ln();
        $pdf->SetFont('', 'B');
        $pdf->Cell($width3, $height, 'Comité Calificación:', 0, 0, 'L', false, '', 1, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->MultiCell($width4*2, $height, $this->getDataSource()->getParameter('comite_calificacion'), 0,'L', false ,0);
        $pdf->Ln();
        $pdf->SetFont('', 'B');
        $pdf->Cell($width3, $height, 'Posibles Proveedores:', 0, 0, 'L', false, '', 1, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->MultiCell($width4*2, $height, $this->getDataSource()->getParameter('posibles_proveedores'), 0,'L', false ,0);$pdf->setTextColor(0,0,0);
        $pdf->Ln();
        $pdf->SetFont('', 'B');
        $pdf->Cell($width3, $height, 'Lugar de Entrega:', 0, 0, 'L', false, '', 1, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->Cell($width3+$width2, $height, $this->getDataSource()->getParameter('lugar_entrega'), 0, 1, 'L', false, '', 0, false, 'T', 'C');
        
        $pdf->Ln();
        $pdf->Ln();
        if($this->getDataSource()->getParameter('estado')!='borrador' && $this->getDataSource()->getParameter('estado')!='pendiente'){
                    $pdf->Cell($width4-8, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
                    $pdf->Cell($width3+$width1, $height, $this->getDataSource()->getParameter('desc_funcionario_rpc'), $black, 0, 'C', false, '', 0, false, 'T', 'C');
                    $pdf->Cell($width4-8, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
                    $pdf->Ln();
                    $pdf->Cell($width4-8, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
                    $pdf->Cell($width3+$width1, $height, 'Firma Autorizada', 0, 0, 'C', false, '', 0, false, 'T', 'C');
                    $pdf->Cell($width4-8, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        }                           
        $pdf->Ln();
        $pdf->Output($fileName, 'F');
    }
   
    function writeDetalles (DataSource $dataSource, TCPDF $pdf) {
            
        $blackAll = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));  
        $blackSide = array('LR' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
        $blackBottom = array('B' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
        $blackTop = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
        $widthMarginLeft = 1;
        $width1 = 15;
        $width2 = 25;
        $width3 = 20;
        $pdf->SetFontSize(7.5);
        $pdf->SetFont('', 'B');
        $height = 5;
        $pdf->Ln();

        //recorres lso grupos del detalle 
        foreach($dataSource->getDataset() as $row) {
                    
                
                    
             /*CABECERA DESCRIPCION PARTIDA Y CC*/   
            $pdf->setFont('','B');
            $pdf->Cell($width2, $height, 'Código Partida', 0, 0, 'L', false, '', 0, false, 'T', 'C');
            $pdf->Cell($width2*2, $height, 'Nombre Partida', 0, 0, 'L', false, '', 0, false, 'T', 'C');
            $pdf->Cell($width2*2+10, $height, 'Centro de Costo', 0, 0, 'L', false, '', 0, false, 'T', 'C');
            $pdf->Cell($width2, $height, '', 0, 0, 'R', false, '', 0, false, 'T', 'C');
            $pdf->Cell($width2, $height, 'Disponibilidad', 0, 0, 'R', false, '', 0, false, 'T', 'C');
            
            $pdf->Ln();
            $pdf->setFont('','');
            
            /* DATOS ESPECIFICOS DEL GRUPO PARTIDA Y CC*/
           
            $pdf->Cell($width2, $height, $row['groupeddata'][0]['codigo_partida'], 0, 0, 'L', false, '', 0, false, 'T', 'C');
            $yAntes=$pdf->getY();
            $xAntesCell = $pdf->getX();                                             
            
            $pdf->MultiCell($width2*2, $height, $row['groupeddata'][0]['nombre_partida'], 0,'L', false ,1);
           
            $altura = $pdf->getY()- $yAntes;
            $pdf->setY($yAntes);
            
            $pdf->setX($xAntesCell+$width2*2);
            //$pdf->Cell($width2, $height, $row['groupeddata'][0]['nombre_partida'], 0, 0, 'L', false, '', 1, false, 'T', 'C');
            
            $pdf->Cell($width2*2+10, $height, $row['groupeddata'][0]['desc_centro_costo'], 0, 0, 'L', false, '', 1, false, 'T', 'C');
            $xRef=$pdf->getX();
            $yRef=$pdf->getY();
            
            $pdf->Cell($width2, $height, $row['totalRef'], 0, 0, 'R', false, '', 0, false, 'T', 'C');
            
            /*DETERMINA SI EL PRESUPUESTO ESTA DISPONIBLE O NO*/
            
            if($this->getDataSource()->getParameter('estado')=='borrador' || $this->getDataSource()->getParameter('estado')=='pendiente'){
                //verifica la disponibilidad de presupeusto para el  agrupador     
                if($row['presu_verificado']=="true"){
                    $pdf->setTextColor(0,0,0);
                    $pdf->Cell($width2, $height, 'DISPONIBLE', 0, 0, 'R', false, '', 0, false, 'T', 'C');
                }
                else{
                    $pdf->setTextColor(255,0,0);
                    $pdf->Cell($width2, $height, 'NO DISPONIBLE', 0, 0, 'R', false, '', 0, false, 'T', 'C');
                
                }
            }
            else{
                    $pdf->setTextColor(0,0,0);
                    $pdf->Cell($width2, $height, 'DISPONIBLE Y APROBADO', 0, 0, 'R', false, '', 0, false, 'T', 'C');
            } 
            
            $pdf->setTextColor(0,0,0);
           
            $pdf->Ln($altura);
            
            /*CABECERA DE LOS ITEMS ESPECIFICOS*/
           
            $pdf->setFont('','B');
            $pdf->Cell($width2+$width1, $height, 'Concepto Gasto', $blackAll, 0, 'L', false, '', 1, false, 'T', 'C');
            $pdf->Cell($width2+25+$width3*2, $height, 'Descripcion', $blackAll, 0, 'L', false, '', 1, false, 'T', 'C');
            $pdf->Cell($width1, $height, 'Cantidad', $blackAll, 0, 'L', false, '', 1, false, 'T', 'C');
            $pdf->Cell($width3, $height, 'Precio Unitario', $blackAll, 0, 'R', false, '', 1, false, 'T', 'C');
            $pdf->Cell($width3, $height, 'Precio Total', $blackAll, 0, 'R', false, '', 1, false, 'T', 'C');
            
            
                //$pdf->Cell($width3, $height, 'Precio Ges. Act.', $blackAll, 0, 'R', false, '', 1, false, 'T', 'C');
                //$pdf->Cell($width3, $height, 'Precio Ges. Sig.', $blackAll, 0, 'R', false, '', 1, false, 'T', 'C');
            $pdf->Ln();
            $totalRef=0;
            $totalGa=0;
            $totalSg=0;
            $xEnd=0;
            $yEnd=0;
            
            foreach ($row['groupeddata'] as $solicitudDetalle) {
                            
                        $pdf->setFont('','');
                        $xAntesMultiCell = $pdf->getX();
                        $yAntesMultiCell = $pdf->getY();
                        $pdf->setX($xAntesMultiCell+$width2+$width1);
                        $pdf->MultiCell($width2+25+$width3*2, $height, $solicitudDetalle['descripcion'], 1,'L', false ,1);
                        $height = $pdf->getY() - $yAntesMultiCell;
                        $pdf->setX($xAntesMultiCell);
                        $pdf->setY($yAntesMultiCell);
                        $pdf->Cell($width2+$width1, $height, $solicitudDetalle['desc_concepto_ingas'], $blackAll, 0, 'L', false, '', 1, false, 'T', 'C');
                        $pdf->setX($xAntesMultiCell+$width2*2+25+$width3*2+$width1);
                        //$pdf->Cell($width2+25+$width3*2, $height, $solicitudDetalle['descripcion'], $blackSide, 0, 'L', false, '', 1, false, 'T', 'C');
                        $pdf->Cell($width1, $height, $solicitudDetalle['cantidad'], $blackAll, 0, 'R', false, '', 1, false, 'T', 'C');
                        $pdf->Cell($width3, $height, number_format($solicitudDetalle['precio_unitario'],2), $blackAll, 0, 'R', false, '', 1, false, 'T', 'C');
                        $pdf->Cell($width3, $height, number_format($solicitudDetalle['precio_total'],2), $blackAll, 0, 'R', false, '', 1, false, 'T', 'C');
                        //$pdf->Cell($width3, $height, number_format($solicitudDetalle['precio_ga'],2), $blackSide, 0, 'R', false, '', 1, false, 'T', 'C');
                        //$pdf->Cell($width3, $height, number_format($solicitudDetalle['precio_sg'],2), $blackSide, 0, 'R', false, '', 1, false, 'T', 'C');
                        $totalRef=$totalRef+$solicitudDetalle['precio_total'];
                        $totalGa=$totalGa+$solicitudDetalle['precio_ga'];
                        $totalSg=$totalSg+$solicitudDetalle['precio_sg'];
                        $pdf->Ln();
                        $xEnd=$pdf->getX();
                        $yEnd=$pdf->getY();                                                                                                                 
            
            }
            $height=5;
            //$pdf->setXY($xRef,$yRef);
            //$pdf->Cell($width2, $height, $totalRef, 0, 0, 'R', false, '', 0, false, 'T', 'C');
            $pdf->setXY($xEnd,$yEnd);
            $pdf->Cell(185, $height, '', $blackTop, 1, 'L', false, '', 0, false, 'T', 'C');
            $pdf->setXY($xEnd,$yEnd);
            $pdf->Cell($width1*2+$width2*2+$width3*3+25,$height,'','0', 0, 'R', false, '', 1, false, 'T', 'C');
            $pdf->Cell($width3,$height,number_format($totalRef,2),$blackAll, 0, 'R', false, '', 1, false, 'T', 'C');
            //$pdf->Cell($width3,$height,number_format($totalGa,2),$blackAll, 0, 'R', false, '', 1, false, 'T', 'C');
            //$pdf->Cell($width3,$height,number_format($totalSg,2),$blackAll, 0, 'R', false, '', 1, false, 'T', 'C');
            $pdf->Ln($height*2);
        }                                               
    }      
}
?>