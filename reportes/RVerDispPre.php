<?php
// Extend the TCPDF class to create custom MultiRow
class RVerDispPre extends ReportePDF {
	var $datos_titulo;
	var $datos_detalle;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $total;
	var $datos_entidad;
	var $datos_periodo;
	var $fec;
	function datosHeader ($detalle,$resultado,$tpoestado,$auxiliar) {
		$this->SetHeaderMargin(12);
		$this->SetAutoPageBreak(TRUE, 10);
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		$this->datos_titulo = $resultado;
		$this->SetMargins(17, 15, 5,10);
	}
	//
	function getDataSource(){
		return  $this->datos_detalle;		
	}
	//
	function Header() {		
	}
	//	
	function generarCabecera(){
	}
	//
	function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		$this->generarCuerpo($this->datos_detalle);
	}
	//		
	function generarCuerpo($detalle){		
		//function		
		$this->cab();		
		$this->imprimirLinea($val,$count,$fill);
	}
	//
	function imprimirLinea($val,$count,$fill){
		
		$height = 2;
		$width_f1 = 5;
		$esp_width = 10;
		$width_c1= 180;
		$width_c2= 70;
		$width1= 10;
		
		$this->Ln(5);
		
		$this->SetFont('', 'B',10);
		$this->SetFillColor(192,192,192, true);	
		$this->Cell($width_f1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->Cell($width_c1, $height, '1) DATOS GENERALES(Responsable del llenado: Area solicitante)', 1, 1, 'L', true, '', 0, false, 'T', 'C');			
		$this->Ln(0.5);
		$this->SetFont('', 'B',7);
		$this->SetFillColor(192,192,192, true);	

		$this->Cell($width_c1-150, $height, 'SOLICITUD DE PEDIDO(LIBERADO)', 1, 1, 'L', true, '', 0, false, 'T', 'C');
		$this->Cell($esp_width, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->Cell($width_c1-120, $height, 'DATO_1', 1, 1, 'L', true, '', 0, false, 'T', 'C');			
		$this->Ln();
		
		
		$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->Cell($width_c1, $height, 'Nombre o Razón Social:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->SetFont('', '');
		$this->SetFillColor(192,192,192, true);
		$this->Cell($width_c2, $height, '33333333333333333', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		////////////////////////////////////////
		$this->Cell($esp_width, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->Cell($width_c1, $height,'NIT:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->SetFont('', '');
		$this->SetFillColor(192,192,192, true);
		$this->Cell($width_c1, $height, '$this->datos_entidad[]', 0, 0, 'L', false, '', 0, false, 'T', 'C');		
		
	} 
	//
	function revisarfinPagina($a){
		$dimensions = $this->getPageDimensions();
		$hasBorder = false;
		$startY = $this->GetY();
		$this->getNumLines($row['cell1data'], 90);		
		if ($startY > 237) {				
			if($this->total!= 0){
				$this->AddPage();
				$this->generarCabecera();
			}				
		}
	}
	//
	function Footer() {		
		$this->setY(-15);
		$ormargins = $this->getOriginalMargins();
		$this->SetTextColor(0, 0, 0);
		$line_width = 0.85 / $this->getScaleFactor();
		$this->SetLineStyle(array('width' => $line_width, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
		$ancho = round(($this->getPageWidth() - $ormargins['left'] - $ormargins['right']) / 3);
		$this->Ln(2);
		$cur_y = $this->GetY();
		$this->Cell($ancho, 0, '', '', 0, 'L');
		$pagenumtxt = 'Página'.' '.$this->getAliasNumPage().' de '.$this->getAliasNbPages();
		$this->Cell($ancho, 0, $pagenumtxt, '', 0, 'C');
		$this->Cell($ancho, 0, '', '', 0, 'R');
		$this->Ln();
		$fecha_rep = date("d-m-Y H:i:s");
		$this->Cell($ancho, 0, '', '', 0, 'L');
		$this->Ln($line_width);
	}
	//
	function cab() {
		$white = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(255, 255, 255)));
		$black = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
		$this->Ln(15);
		$this->Image(dirname(__FILE__).'/../../lib/imagenes/logos/logo.jpg', 10,15,40,20);
		$this->ln(5);
		$this->SetFont('','B',15);		
		$this->Cell(0,5,"VERIFICACION DE DISPONIBILIDAD PRESUPUESTARIA",0,1,'C');					
		$this->Ln(3);
		
		$this->generarCabecera();
	}		
}
?>