<?php
/*include_once(dirname(__FILE__).'/../../lib/PHPWord/src/PhpWord/Autoloader.php');
\PhpOffice\PhpWord\Autoloader::register();*/
include_once (dirname(__FILE__).'/../../pxp/lib/phpdocx/Classes/Phpdocx/Create/CreateDocx.inc');
Class RMemoDesigCR {

    private $dataSource;

    var $lista;
    public function datosHeader( $dataSource) {
        $this->dataSource = $dataSource;
        //var_dump($this->dataSource);exit;
    }



    function write($fileName/*, $url_archivo*/) {


        /*$phpWord = new \PhpOffice\PhpWord\PhpWord();
        $document = $phpWord->loadTemplate(dirname(__FILE__).'/plantilla_memo_designacion.docx');
        setlocale(LC_ALL,"es_ES@euro","es_ES","esp");
        //echo $this->dataSource[0]['desc_funcionario1'];exit;
        $document->setValue('NOMBRE_RESPONSABLE', $this->dataSource[0]['funcionario']); // On section/content
        //$document->setValue('LISTA_COMISION', $this->dataSource[0]['lista_comicion']); // On section/content
        $document->setValue('FECHA',  date('d').'/'.date('m').'/'.date('Y') ); // On section/content
        $document->setValue('PROVEEDOR', $this->dataSource[0]['proveedor']); // On section/content
        $document->setValue('NRO_DOC', $this->dataSource[0]['tramite']); // On section/content
        $document->saveAs($fileName);*/

        $comision = explode(',',$this->dataSource[0]['nombres']);

        //establecemos tabla para la comision
        if(count($comision)>=1){
            $this->lista = '<table border="0" width=400>';
            foreach ($comision as $value){
                $this->lista .= '<tr><td width="85"> </td><td width="300"><font face="calibri" size="12">'.$value.'</font></td></tr>';
            }
            $this->lista .= '</table>';
        }

        $docx = new Phpdocx\Create\CreateDocxFromTemplate(dirname(__FILE__).'/plantilla_memo_designacionRPC.docx');
        $docx->setLanguage('es-ES');

        $docx->replaceVariableByText(array('NRO_DOC'=> $this->dataSource[0]['tramite']));
        $docx->replaceVariableByText(array('FECHA' =>  $this->dataSource[0]['fecha_po'] ));
        $docx->replaceVariableByText(array('NOMBRE_RESPONSABLE' => $this->dataSource[0]['funcionario']));
        $docx->replaceVariableByHTML('LISTA_COMISION', 'block', $this->lista);
        $docx->replaceVariableByText(array('PROVEEDOR' => $this->dataSource[0]['proveedor']));
        //var_dump( $url_archivo);exit;
        /*$docx->replacePlaceholderImage ('IMAGEN', $url_archivo, array(
            'height' => 'auto',
            'width' => 'auto',
            'target' => 'document'
        ));*/
        $docx->replaceVariableByText(array('IMAGEN' => $this->dataSource[0]['funcionario']));
        $file = str_replace(".docx","",$fileName);


        $docx->createDocx($file);



    }


}
?>