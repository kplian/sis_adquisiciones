<?php
require_once(dirname(__FILE__) . '/../../lib/tcpdf/tcpdf_barcodes_2d.php');

class RGenerarQRCR extends  ReportePDF
{

    function generarImagen()
    {
        $cadena_qr = 'Nombre: Franklin espinoza'. "\n" . 'Nacionalidad: Boliviano' ;
        $barcodeobj = new TCPDF2DBarcode($cadena_qr, 'QRCODE,M');
        $png = $barcodeobj->getBarcodePngData($w = 8, $h = 8, $color = array(0, 0, 0));
        $im = imagecreatefromstring($png);
        if ($im !== false) {
            header('Content-Type: image/png');
            imagepng($im, dirname(__FILE__) . "/../../reportes_generados/" . $this->objParam->getParametro('nombre_archivo') . ".png");
            imagedestroy($im);

        } else {
            echo 'An error occurred.';
        }
        $url_archivo = dirname(__FILE__) . "/../../reportes_generados/" . $this->objParam->getParametro('nombre_archivo') . ".png";

        return $url_archivo;
    }
}
?>