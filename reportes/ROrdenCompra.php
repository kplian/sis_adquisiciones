<?php
include_once dirname(__FILE__)."/../../lib/lib_reporte/lang.es_AR.php";
require_once dirname(__FILE__).'/../../pxp/lib/lib_reporte/mypdf.php';
require_once dirname(__FILE__).'/../../pxp/pxpReport/Report.php';

 class CustomReportOC extends MYPDF {
    
    private $dataSource;
    
    public function setDataSource(DataSource $dataSource) {
        $this->dataSource = $dataSource;
    }
    
    public function getDataSource() {
        return $this->dataSource;
    }
    
    public function Header() {
    	$x= $this->getX();
		$y= $this->getY();
        $height = 20;
		$this->Image(dirname(__FILE__).'/../../pxp/lib'.$_SESSION['_DIR_LOGO'], $x+15, $y+10, 36);
		$this->Cell(20, $height, '', 0, 0, 'C', false, '', 1, false, 'T', 'C');
								
        $this->SetFontSize(16);
        $this->SetFont('','B');
								$tipo=$this->getDataSource()->getParameter('tipo');
								if($tipo=='Bien')
								  $tipo='Compra';
                                elseif($tipo=='Bien - Servicio')
								  $tipo='Compra - Servicio'; 
                                else
                                  $tipo='Servicio';       
                                
                                $this->Cell(145, $height, 'Orden de '.$tipo, 0, 0, 'C', false, '', 1, false, 'T', 'C');        
        
								$x=$this->getX();
								$y=$this->getY();
								$this->setXY($x,$y-10);
								$this->SetFontSize(8);
								$this->SetFont('', 'B');
								$this->Cell(20, $height, $this->getDataSource()->getParameter('numero_oc'), 0, 0, 'L', false, '', 1, false, 'T', 'C');
								
								$this->setXY($x,$y-7);
								$this->SetFontSize(8);
								$this->SetFont('', 'B');
								$this->Cell(20, $height, $this->getDataSource()->getParameter('num_tramite'), 0, 0, 'L', false, '', 1, false, 'T', 'C');
								
								$this->setXY($x,$y-4);
								$this->SetFontSize(6);
								$this->SetFont('', 'B');
								$this->Cell(20, $height, '', 0, 0, 'L', false, '', 1, false, 'T', 'C');
								$this->setXY($x,$y-1);
								$this->SetFontSize(7);
								$this->setFont('','');
								$this->Cell(20, $height, '', 0, 0, 'L', false, '', 1, false, 'T', 'C');
								$this->setXY($x,$y+11);
								$this->setFont('','');
								$this->Cell(6, $height/5, 'Dia', 1, 0, 'L', false, '', 1, false, 'T', 'C');
								$this->Cell(6, $height/5, 'Mes', 1, 0, 'L', false, '', 1, false, 'T', 'C');
								$this->Cell(7, $height/5, 'Año', 1, 0, 'L', false, '', 1, false, 'T', 'C');
								$this->setXY($x,$y+15);
								
																
								$fecha_oc = explode('-', $this->getDataSource()->getParameter('fecha_oc'));
								$this->Cell(6, $height/4, $fecha_oc[2], 1, 0, 'C', false, '', 1, false, 'T', 'C');
								$this->Cell(6, $height/4, $fecha_oc[1], 1, 0, 'C', false, '', 1, false, 'T', 'C');
								$this->Cell(7, $height/4, $fecha_oc[0], 1, 0, 'C', false, '', 1, false, 'T', 'C');
								$this->Ln();		
								if($tipo=='adjudicado'){
								  $this->SetFontSize(9);
                                $this->SetFont('','B');						
										$this->Cell(30, $height, 'Numero de O.C. :', 0, 0, 'L', false, '', 1, false, 'T', 'C');
										$this->SetFont('','');	
										$this->Cell(30, $height, $this->getDataSource()->getParameter('numero_oc'), 0, 0, 'L', false, '', 1, false, 'T', 'C');
								}
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

Class ROrdenCompra extends Report {

    function write($fileName) {
        $pdf = new CustomReportOC('P', PDF_UNIT, "LETTER", true, 'UTF-8', false);
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
        
		$white = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(255, 255, 255)));
		$black = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
		
		$pdf->SetFontSize(7);
		$pdf->SetFont('', 'B');
        $pdf->Cell($width1, $height, 'Señores:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width4+$width3+$width2, $height, $this->getDataSource()->getParameter('desc_proveedor'), $white, 1, 'L', true, '', 0, false, 'T', 'C');
        //$pdf->SetFont('', 'B');
		//$pdf->Cell(5, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        
		//$pdf->Ln();
		        
		if($this->getDataSource()->getParameter('direccion')!=''){
			$pdf->SetFont('', 'B');
			$pdf->Cell($width1, $height, 'Dirección:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$pdf->SetFont('', '');
			$pdf->SetFillColor(192,192,192, true);
			$pdf->Cell($width4+$width3+$width2, $height, $this->getDataSource()->getParameter('direccion'), $white, 1, 'L', true, '', 0, false, 'T', 'C');        
			//$pdf->Cell(5, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		}
		//$pdf->Ln();
		
		if($this->getDataSource()->getParameter('telefono1')!=''){		
			$pdf->SetFont('', 'B');
			$pdf->Cell($width1, $height, 'Telefono:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$pdf->SetFont('', '');
			$pdf->SetFillColor(192,192,192, true);
			$pdf->Cell($width4+$width3+$width2, $height, $this->getDataSource()->getParameter('telefono1'), $white, 1, 'L', true, '', 0, false, 'T', 'C');
        }
		//$pdf->Ln();
		
		if($this->getDataSource()->getParameter('telefono2')!=''){
			$pdf->SetFont('', 'B');
			$pdf->Cell($width1, $height, 'Telf. 2:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$pdf->SetFont('', '');
			$pdf->SetFillColor(192,192,192, true);
			$pdf->Cell($width4+$width3+$width2, $height, $this->getDataSource()->getParameter('telefono2'), $white, 1, 'L', true, '', 0, false, 'T', 'C');        
        }
		//$pdf->Ln();
        /*
		if($this->getDataSource()->getParameter('lugar_entrega')==''){
			$pdf->SetFont('', 'B');
			$pdf->Cell($width1, $height, 'Ciudad:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$pdf->SetFont('', '');
			$pdf->SetFillColor(192,192,192, true);
			$pdf->Cell($width4+$width3+$width2, $height, $this->getDataSource()->getParameter('lugar_entrega'), $white, 0, 'L', true, '', 0, false, 'T', 'C');
			$pdf->SetFont('', 'B');
			$pdf->Cell(5, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		}
		$pdf->Ln();*/
		if($this->getDataSource()->getParameter('celular')!=''){
			$pdf->SetFont('', 'B');
			$pdf->Cell($width1, $height, 'Celular:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$pdf->SetFont('', '');
			$pdf->SetFillColor(192,192,192, true);
			$pdf->Cell($width4+$width3+$width2, $height, $this->getDataSource()->getParameter('celular'), $white, 1, 'L', true, '', 0, false, 'T', 'C');
        }
		//$pdf->Ln();
        
		if($this->getDataSource()->getParameter('email')!=''){
			$pdf->SetFont('', 'B');
			$pdf->Cell($width1, $height, 'Email:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$pdf->SetFont('', '');
			$pdf->SetFillColor(192,192,192, true);
			$pdf->Cell($width4+$width3+$width2, $height, $this->getDataSource()->getParameter('email'), $white, 1, 'L', true, '', 0, false, 'T', 'C');        
			//$pdf->Cell(5, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		}
		//$pdf->Ln();
		if($this->getDataSource()->getParameter('fax')!=''){
			$pdf->SetFont('', 'B');
			$pdf->Cell($width1, $height, 'Fax:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$pdf->SetFont('', '');
			$pdf->SetFillColor(192,192,192, true);
			$pdf->Cell($width4+$width3+$width2, $height, $this->getDataSource()->getParameter('fax'), $white, 1, 'L', true, '', 0, false, 'T', 'C');        
		}
		$pdf->Ln();        
		//$pdf->Ln();
		
		$pdf->SetFontSize(10);
		$tipo=$this->getDataSource()->getParameter('tipo');
		
		if($tipo=='Bien - Servicio')
		  $tipo='Compra - Servicio'; 
		
		if($tipo=='Bien')						
		    $pdf->MultiCell(0, $height, 'De acuerdo a su cotización en la que detalla especificaciones, por medio de la presente confirmamos orden para la provisión de:', 0,'L', false ,1);
		
		//escritura de los datalles de la cotizacion
		$this->writeDetalles($this->getDataSource()->getParameter('detalleDataSource'), $pdf,$tipo, $this->getDataSource()->getParameter('codigo_moneda') );

		$pdf->SetFontSize(9);
		$pdf->Ln();
		
		if($this->getDataSource()->getParameter('fecha_entrega')!=''){  
    		
            $pdf->SetFont('', 'B');
            $pdf->Cell($width3, $height, 'Fecha de Entrega:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
            $pdf->SetFont('', '');
            $pdf->SetFillColor(192,192,192, true);
            $pdf->Cell($width4+$width3+$width2+$width1, $height, $this->getDataSource()->getParameter('fecha_entrega'), $white, 0, 'L', true, '', 0, false, 'T', 'C');        
            $pdf->Cell(5, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
            $pdf->Ln();
            $pdf->SetFont('', 'B');
        }
        else{
            $pdf->SetFont('', 'B');
            $pdf->Cell($width3, $height, 'Tiempo de Entrega:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
            $pdf->SetFont('', '');
            $pdf->SetFillColor(192,192,192, true);
            //$pdf->Cell($width4+$width3+$width2+$width1, $height, $this->getDataSource()->getParameter('tiempo_entrega'), $white, 0, 'L', true, '', 0, false, 'T', 'C');        
			$pdf->MultiCell(0, $height, $this->getDataSource()->getParameter('tiempo_entrega'), 0,'L', true ,1);        
            $pdf->Cell(5, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
            $pdf->Ln();
       }
         
		/*
        $pdf->Cell($width3, $height, 'Tipo de Entrega:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->SetFillColor(192,192,192, true);
        $pdf->Cell($width4+$width3+$width2, $height, $this->getDataSource()->getParameter('tipo_entrega'), $white, 0, 'L', true, '', 0, false, 'T', 'C');        
        $pdf->Ln();
        $pdf->SetFont('', 'B');
        */
		
		$pdf->SetFont('', 'B');
        $pdf->Cell($width3, $height, 'Lugar de Entrega:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $pdf->SetFont('', '');
        $pdf->SetFillColor(192,192,192, true);
		$pdf->MultiCell(0, $height, $this->getDataSource()->getParameter('lugar_entrega'), 0,'L', true ,1);        
        $pdf->Ln();
		
		if($this->getDataSource()->getParameter('forma_pago')!=''){
			$pdf->SetFont('', 'B');
			$pdf->Cell($width3, $height, 'Forma de Pago:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$pdf->SetFont('', '');
			$pdf->SetFillColor(192,192,192, true);			
			$pdf->MultiCell(0, $height, $this->getDataSource()->getParameter('forma_pago'), 0,'L', true ,1);
			$pdf->Ln();
        }
		
		if($this->getDataSource()->getParameter('tipo')=='adjudicado'){	        
	        $pdf->SetFont('', 'B');
	        $pdf->Cell($width3, $height, 'Fecha Adjudicacion:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $pdf->SetFont('', '');
	        $pdf->SetFillColor(192,192,192, true);
	        $pdf->MultiCell(0, $height, $this->getDataSource()->getParameter('fecha_adju'), 0,'L', true ,1);
			//$pdf->Cell($width3+$width2, $height, $this->getDataSource()->getParameter('fecha_adju'), $white, 0, 'L', true, '', 0, false, 'T', 'C');        
		}	
		
		$pdf->Ln();
		//$pdf->SetFont('','B');
		//$pdf->Cell($width1, $height, 'NOTA:', 0, 0, 'L', false, '', 0, false, 'T', 'C');							 
        $pdf->SetFont('','');
		$pdf->setFontSize(7);								
        
		if($this->getDataSource()->getParameter('codigo_proceso')!='PROCINPD'){
			$pdf->MultiCell(0, $height, 'La suma de dinero será cancelada de la forma establecida, debiendo ustedes emitir la factura respectiva a nombre de BOLIVIANA DE AVIACIÓN – BOA, NIT 154422029,  de no emitirse la misma, BOA se reserva del derecho de efectuar las retenciones impositivas respectivas.', 0,'L', false ,1);
		}else{
			$pdf->MultiCell(0, $height, 'La suma de dinero será cancelada de acuerdo a su oferta, el pedido deberá cumplir con todas las especificaciones solicitadas por Boliviana de Aviación, asimismo, solicitamos nos remita la nota fiscal correspondiente o similar de su país de origen.', 0,'L', false ,1);
		}
		
		$pdf->Ln($height);
		//$pdf->MultiCell(0, $height, 'Firma Proveedor o Sello ', 1,'R', false ,1);							
		
		if($tipo=='Bien')			
			$mensaje = 'El ítem deberá ser entregado conforme a lo solicitado, estipuladas en la cotización y la presente Orden.';			
		else
			$mensaje = 'El servicio deberá ser entregado conforme a lo solicitado, estipuladas en la cotización y la presente Orden.';			
				
		$pdf->MultiCell(0, $height, $mensaje, 0,'L', false ,1);
		$pdf->Ln($height);
		
		if($this->getDataSource()->getParameter('contacto')!=''){
			$pdf->SetFontSize(7);
			$pdf->SetFont('', 'B');
			$pdf->Cell($width1, $height, 'Contacto:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$pdf->SetFont('', '');
			$pdf->SetFillColor(192,192,192, true);
			$pdf->Cell($width4+$width3+$width2, $height, $this->getDataSource()->getParameter('contacto'), $white, 1, 'L', true, '', 0, false, 'T', 'C');
		}
		
		if($this->getDataSource()->getParameter('celular_contacto')!=''){
			$pdf->SetFontSize(7);
			$pdf->SetFont('', 'B');
			$pdf->Cell($width1, $height, 'Telefono:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$pdf->SetFont('', '');
			$pdf->SetFillColor(192,192,192, true);
			$pdf->Cell($width4+$width3+$width2, $height, $this->getDataSource()->getParameter('celular_contacto'), $white, 1, 'L', true, '', 0, false, 'T', 'C');
		}
		
		if($this->getDataSource()->getParameter('email_contacto')!=''){
			$pdf->SetFontSize(7);
			$pdf->SetFont('', 'B');
			$pdf->Cell($width1, $height, 'Correo:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$pdf->SetFont('', '');
			$pdf->SetFillColor(192,192,192, true);
			$pdf->Cell($width4+$width3+$width2, $height, $this->getDataSource()->getParameter('email_contacto'), $white, 1, 'L', true, '', 0, false, 'T', 'C');
		}
		//$mensaje = $mensaje.', ante cualquier demora BOLIVIANA DE AVIACIÓN – BOA se reserva el derecho de retener el UNO PORCIENTO (1%) del monto total por día de retraso hasta un 20%.';
		$pdf->Ln($height);
		if($this->getDataSource()->getParameter('codigo_proceso')!='PROCINPD'){
			$pdf->MultiCell(0, $height, 'Ante cualquier demora BOLIVIANA DE AVIACIÓN – BOA se reserva el derecho de retener el UNO PORCIENTO (1%) del monto total por día de retraso hasta un 20%.', 0,'L', false ,1);
			$pdf->Ln($height);
		}		
		
		$pdf->MultiCell(0, $height, 'Sin otro particular y agradeciendo su gentil atención, saludo a usted', 0,'L', false ,1);
        $pdf->Ln($height);
		$pdf->MultiCell(0, $height, 'Atentamente.', 0,'L', false ,1);
        
		//$pdf->MultiCell(0, $height, 'El proveedor se compromete a entregar el suministro en el plazo de '.$this->getDataSource()->getParameter('dias_entrega').' dias calendarios que seran computables a partir de la fecha de elaboracion de la presente orden de '.$tipo.'. El incumplimiento se sancionara con una multa del 0,1% del monto de contrato por cada dia calendario de retraso, multa que no debe exceder del 2%.', 1,'L', false ,1);
        $pdf->Output($fileName, 'F');
    }
    
    function writeDetalles (DataSource $dataSource, TCPDF $pdf,$tipo, $tipo_moneda) {
    	
    	$blackAll = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
        $widthMarginLeft = 1;
        $width1 = 20;
        $width2 = 130;
        
        $pdf->Ln();
        $pdf->SetFontSize(7.5);
        $pdf->SetFont('', 'B');
        $height = 5;
        $pdf->SetFillColor(255,255,255, true);
        $pdf->setTextColor(0,0,0); 
		
		$pdf->SetFontSize(6.5);
		$totalOrdenCompra=0.00;
		
		$conf_par_tablewidths=array($width1-5,$width2,$width1,$width1);
        $conf_par_tablealigns=array('L','L','L','R');
        $conf_par_tablenumbers=array(0,0,0,0);
        $conf_tableborders=array($blackAll,$blackAll,$blackAll,$blackAll);
        $conf_tabletextcolor=array();
				
		$pdf->tablewidths=$conf_par_tablewidths;
		$pdf->tablealigns=$conf_par_tablealigns;
		$pdf->tablenumbers=$conf_par_tablenumbers;
		$pdf->tableborders=$conf_tableborders;
		
		$RowArray = array(
					'cantidad'  => 'Cantidad',
					'item'  => 'Item',
					'precio_unitario' => 'Precio Unitario',
					'total' => 'Total'
				);     
					 
		 $pdf-> MultiRow($RowArray,false,1); 
		 
        foreach($dataSource->getDataset() as $row) {
			            
			 if($row['cantidad_adju']>0){
				 $RowArray = array(
							'cantidad'  => $row['cantidad_adju'],
							'item'  => $row['desc_solicitud_det']."\r\n".'  - '.$row['descripcion_sol'],
							'precio_unitario'    => number_format($row['precio_unitario'],2),                       
							'total' =>  ($row['cantidad_adju']*$row['precio_unitario'])
						);     
				$totalOrdenCompra=$totalOrdenCompra + ($row['cantidad_adju']*$row['precio_unitario']);			 
				$pdf-> MultiRow($RowArray,false,1) ; 
			}
						  
        }
    	$height=5;		 								
    	$obj = new Numbers_Words_es_AR;
    	$numero=explode('.', number_format($totalOrdenCompra,2));
    	$pdf->Cell($width2+$width1+$width1/2+$width1/4, $height, 'SON: '. strtoupper(trim($obj->toWords(str_replace(',', '', $numero[0])))).' '.$numero[1].'/'.'100 '.strtoupper($this->getDataSource()->getParameter('moneda')), 1, 0, 'L', false, '', 1, false, 'T', 'C');
    	$pdf->Cell($width1, $height, number_format($totalOrdenCompra,2), 1, 0, 'R', false, '', 1, false, 'T', 'C');
    	$pdf->Ln();       									
    }     
}
?>