<?php 



include_once(dirname(__FILE__)."/../../lib/lib_control/CTSesion.php");
session_start();
$_SESSION["_SESION"]= new CTSesion(); 



include(dirname(__FILE__).'/../../lib/DatosGenerales.php');
include_once(dirname(__FILE__).'/../../lib/lib_general/Errores.php');
require dirname(__FILE__).'/../../lib/PHPMailer/PHPMailerAutoload.php';
include_once(dirname(__FILE__).'/../../lib/lib_general/cls_correo_externo.php');
include_once(dirname(__FILE__).'/../../lib/rest/PxpRestClient.php');
include_once(dirname(__FILE__).'/../../lib/FirePHPCore-0.3.2/lib/FirePHPCore/FirePHP.class.php');

ob_start();
$fb=FirePHP::getInstance(true);
//estable aprametros ce la cookie de sesion
$_SESSION["_CANTIDAD_ERRORES"]=0;//inicia control 
//echo dirname(__FILE__).'LLEGA';
include_once(dirname(__FILE__).'/../../lib/lib_control/CTincludes.php');
include_once(dirname(__FILE__).'/../../sis_adquisiciones/modelo/MODCotizacion.php');


     
        $objPostData = new CTPostData();
        $arr_unlink = array();
        $aPostData = $objPostData->getData();
       
        //$aPostFiles=$objPostData->getFiles(); //eliminar esto
        //echo ("entro al cron");
		//exit;
        $_SESSION["_PETICION"]=serialize($aPostData);
        $objParam = new CTParametro($aPostData['p'],null,$aPostFiles);

        ////////////////http://172.18.79.202/etr/sis_adquisiciones/control/ActionDiasOrdenCompra.php
        
        $objParam->defecto('ordenacion','id_funcionario_departamento');
        $objParam->defecto('dir_ordenacion','asc');
        
		
		$objParam->addParametro('id_usuario', 1);
		
		$objParam->addParametro('tipo', 'TODOS');
		
        $objFunc=new MODCotizacion($objParam);  
        $res2=$objFunc->InsertarDiasFaltantesOrdenCompra();
		
		if($res2->getTipo()=='ERROR'){
			echo 'Se ha producido un error-> Mensaje Técnico:'.$res2->getMensajeTec();
			exit;        
		} 


        //echo 'ERROR JUAN '.$this->consulta. ' fin juan';
        $res2->imprimirRespuesta($res2->generarJson());
		
?>