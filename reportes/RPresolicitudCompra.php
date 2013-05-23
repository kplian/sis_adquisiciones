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
        $this->Cell(105, $height, 'PRESOLICITUD DE COMPRA', 0, 0, 'C', false, '', 0, false, 'T', 'C');        
        
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

Class RPresolicitudCompra extends Report {

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
        $pdf->Cell($width3, $height, 'Fecha de Presolicitud', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $date = new DateTime($this->getDataSource()->getParameter('fecha_soli'));
        $pdf->Cell($width3, $height, $date->format('d-F-Y'), 0, 0, 'C', false, '', 0, false, 'T', 'C');
								$pdf->Ln();								
								$pdf->Ln();
        
								$white = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(255, 255, 255)));
								$black = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
								//$pdf->setLineStyle($white);
								$pdf->SetFontSize(7);
								$pdf->SetFont('', 'B');
        $pdf->Cell($width3, $height, 'Grupo de Compras:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width3+$width2, $height, $this->getDataSource()->getParameter('desc_grupo'), $white, 0, 'L', true, '', 0, false, 'T', 'C');
        $pdf->SetFont('', 'B');
								$pdf->Cell(5, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->Cell($width3, $height, 'Unidad Organizacional:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
								$pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width3+$width2, $height, $this->getDataSource()->getParameter('desc_uo'), $white, 0, 'L', true, '', 0, false, 'T', 'C');
        $pdf->Ln();
        $pdf->SetFont('', 'B');
        $pdf->Cell($width3, $height, 'Funcionario:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width3+$width2, $height, $this->getDataSource()->getParameter('desc_funcionario'), $white, 0, 'L', true, '', 0, false, 'T', 'C');        
        $pdf->Cell(5, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', 'B');
        $pdf->Cell($width3, $height, 'Supervisor:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width3+$width2, $height, $this->getDataSource()->getParameter('desc_funcionario_supervisor'), $white, 0, 'L', true, '', 0, false, 'T', 'C');        
        $pdf->Ln();
        $pdf->SetFont('', 'B');
        $pdf->Cell($width3, $height, 'Obs:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->SetFillColor(192,192,192, true);
        $pdf->MultiCell(0, $height, $this->getDataSource()->getParameter('obs'), 1,'L', true ,1);        
        $pdf->Ln();
        
								$this->writeDetalles($this->getDataSource()->getParameter('detalleDataSource'), $pdf);
        $pdf->Ln();
								$pdf->Ln();
								if($this->getDataSource()->getParameter('estado')=='aprobado'){
											$pdf->Cell($width4-8, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
											$pdf->Cell($width3+$width1, $height, $this->getDataSource()->getParameter('desc_funcionario_supervisor'), $black, 0, 'C', false, '', 0, false, 'T', 'C');
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
        foreach($dataSource->getDataset() as $row) {
        	   $pdf->setFont('','B');
            $pdf->Cell($width2*3+10, $height, 'Centro de Costo', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        				$pdf->Ln();
												$pdf->setFont('','');
												$pdf->Cell($width2*3+10, $height, $row['codigo_cc'], 0, 0, 'L', false, '', 1, false, 'T', 'C');
        				$pdf->setTextColor(0,0,0);
        				$pdf->Ln();
												$pdf->setFont('','B');
        				$pdf->Cell($width2*2, $height, 'Concepto', $blackAll, 0, 'L', false, '', 1, false, 'T', 'C');
												$pdf->Cell($width2*4+$width1, $height, 'Descripcion', $blackAll, 0, 'L', false, '', 1, false, 'T', 'C');
												$pdf->Cell($width3, $height, 'Cantidad', $blackAll, 0, 'L', false, '', 1, false, 'T', 'C');
												$pdf->Ln();
												$totalCantidad=0;
												$xEnd=0;
												$yEnd=0;
												foreach ($row['groupeddata'] as $solicitudDetalle) {
													  $pdf->setFont('','');
															$pdf->Cell($width2*2, $height, $solicitudDetalle['desc_ingas'], $blackSide, 0, 'L', false, '', 1, false, 'T', 'C');
															$pdf->Cell($width2*4+$width1, $height, $solicitudDetalle['descripcion'], $blackSide, 0, 'L', false, '', 1, false, 'T', 'C');
															$pdf->Cell($width3, $height, $solicitudDetalle['cantidad'], $blackSide, 0, 'R', false, '', 1, false, 'T', 'C');
															$totalCantidad=$totalCantidad+$solicitudDetalle['cantidad'];
															$pdf->Ln();															
															$xEnd=$pdf->getX();
															$yEnd=$pdf->getY();					  	
												}
												$pdf->Cell(185, $height, '', $blackTop, 1, 'L', false, '', 0, false, 'T', 'C');
												$pdf->setXY($xEnd,$yEnd);
												$pdf->Cell($width2*6+$width1,$height,'','0', 0, 'R', false, '', 1, false, 'T', 'C');
												$pdf->Cell($width3,$height,number_format($totalCantidad,2),$blackAll, 0, 'R', false, '', 1, false, 'T', 'C');
												$pdf->Ln($height*2);
        }												
    }      
}
?>