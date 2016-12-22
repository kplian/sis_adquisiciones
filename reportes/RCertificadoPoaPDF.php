<?php
class RCertificadoPoaPDF extends ReportePDF
{
    var $datos ;
    var $ancho_hoja;
    var $gerencia;
    var $numeracion;
    var $ancho_sin_totales;
    var $cantidad_columnas_estaticas;
    function Header() {

        $height = 30;

        //cabecera del reporte
        $this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 70, 8, 70, 20);
        $this->Cell(40, $height, '', 0, 0, 'C', false, '', 0, false, 'T', 'C');
        $this->ln(50);
        $this->SetFontSize(15);
        $this->SetFont('','BU');
        $this->Cell(180, $height, 'CERTIFICACIÓN POA', 0, 0, 'C', false, '', 0, false, 'T', 'C');
        $this->ln();
        $this->certificado();

    }
    function  certificado()
    {
        $nro_tramite = $this->datos[0]['num_tramite'];
        $fecha_sol = $this->datos[0]['fecha_soli'];
        $descripcion = $this->datos[0]['justificacion'];
        $gestion = $this->datos[0]['gestion'];
        $codigo= $this->datos[0]['codigo_descripcion'];

        $height = 5;
        $width4 = 93;
        $tex ='Mediante la presente, en referencia a solicitud '.$nro_tramite.' de fecha '.$fecha_sol.' acerca de: '.$descripcion.', certificar que el mismo se encuentra contemplado en el Plan Operativo gestion '.$gestion.', en la operacion '.$codigo.'.';
        $this->ln(0.8);
        $this->SetFont('', '', 12);
        $this->MultiCell($width4*2, $height, $tex."\n",'J', 0, '' ,'');

    }
    function setDatos($datos) {
        $this->datos = $datos;

    }
    function generarReporte() {

        $this->setFontSubsetting(false);

    }


}
?>