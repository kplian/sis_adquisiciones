<?php
// Extend the TCPDF class to create custom MultiRow
class RVerDispPre extends ReportePDF {
	var $cabecera;
		
	function datosHeader ($detalle) {
		$this->cabecera =$detalle->getParameter('cabecera');	
		$this->ancho_hoja = $this->getPageWidth() - PDF_MARGIN_LEFT - PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		//$this->numero = $numero;
		//$this->importe = $importe;
		
		$this->SetMargins(10, 17, 10,10);
	}
	
	function Header() {			
	}

	function generarReporte() {	
		$this->AddPage();		
		$dataSource = $this->datos_detalle; 
		
		$num_tramite = $this->cabecera[0]['tipo'];		
		$justifiacion = $this->cabecera[0]['num_tramite'];
		$numero = $this->cabecera[0]['justificacion'];		
		$descripcion = $this->cabecera[0]['descripcion'];		
		$codigo = $this->cabecera[0]['codigo'];
		$precio_total = $this->cabecera[0]['precio_total'];
		
		//$justificacion = $this->cabecera[0]['justificacion'];
		ob_start();
		include(dirname(__FILE__).'/../reportes/tpl/VeriPres.php');
		$content = ob_get_clean();
		$this->writeHTML($content, false, false, false, false, '');		
	}

}
?>