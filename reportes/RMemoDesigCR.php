<?php
include_once(dirname(__FILE__).'/../../lib/PHPWord/src/PhpWord/Autoloader.php');
\PhpOffice\PhpWord\Autoloader::register();
Class RMemoDesigCR {

    private $dataSource;

    public function datosHeader( $dataSource) {
        $this->dataSource = $dataSource;
        //var_dump($this->dataSource);exit;
    }



    function write($fileName) {

        $phpWord = new \PhpOffice\PhpWord\PhpWord();
        $document = $phpWord->loadTemplate(dirname(__FILE__).'/plantilla_memo_designacion.docx');
        setlocale(LC_ALL,"es_ES@euro","es_ES","esp");

        //echo $this->dataSource[0]['desc_funcionario1'];exit;
        $document->setValue('NOMBRE_RESPONSABLE', $this->dataSource[0]['funcionario']); // On section/content
        //$document->setValue('LISTA_COMISION', $this->dataSource[0]['lista_comicion']); // On section/content

        $document->setValue('FECHA',  date('d').'/'.date('m').'/'.date('Y') ); // On section/content

        $document->setValue('PROVEEDOR', $this->dataSource[0]['proveedor']); // On section/content

        $document->setValue('NRO_DOC', $this->dataSource[0]['tramite']); // On section/content




        $document->saveAs($fileName);



    }


}
?>