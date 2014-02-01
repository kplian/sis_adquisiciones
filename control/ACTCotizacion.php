<?php
/**
*@package pXP
*@file ACTCotizacion.php
*@author  Gonzalo Sarmiento Sejas
*@date 21-03-2013 14:48:35
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
require_once(dirname(__FILE__).'/../../pxp/pxpReport/ReportWriter.php');
require_once(dirname(__FILE__).'/../reportes/RCotizacion.php');
require_once(dirname(__FILE__).'/../reportes/ROrdenCompra.php');
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');

include_once(dirname(__FILE__).'/../../lib/PHPMailer/class.phpmailer.php');
include_once(dirname(__FILE__).'/../../lib/PHPMailer/class.smtp.php');
include_once(dirname(__FILE__).'/../../lib/lib_general/cls_correo_externo.php');

class ACTCotizacion extends ACTbase{    
			
	function listarCotizacion(){
		$this->objParam->defecto('ordenacion','id_cotizacion');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCotizacion','listarCotizacion');
		} else{
			$this->objFunc=$this->create('MODCotizacion');
			
			$this->res=$this->objFunc->listarCotizacion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarCotizacionRPC(){
        $this->objParam->defecto('ordenacion','id_cotizacion');

        $this->objParam->defecto('dir_ordenacion','asc');
        
        $this->objParam->addParametro('id_funcionario_rpc',$_SESSION["ss_id_funcionario"]); 
        
        $this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
        
        
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODCotizacion','listarCotizacionRPC');
        } else{
            $this->objFunc=$this->create('MODCotizacion');
            
            $this->res=$this->objFunc->listarCotizacionRPC($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
			
	function insertarCotizacion(){
		$this->objFunc=$this->create('MODCotizacion');	
		if($this->objParam->insertar('id_cotizacion')){
			$this->res=$this->objFunc->insertarCotizacion($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCotizacion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCotizacion(){
			$this->objFunc=$this->create('MODCotizacion' );
        $this->res=$this->objFunc->eliminarCotizacion($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
        }

   function reporteCotizacion($create_file=false){
            $dataSource = new DataSource();
            $idCotizacion = $this->objParam->getParametro('id_cotizacion');
            $tipo = $this->objParam->getParametro('tipo');
            $this->objParam->addParametroConsulta('ordenacion','id_cotizacion');
            $this->objParam->addParametroConsulta('dir_ordenacion','ASC');
            $this->objParam->addParametroConsulta('cantidad',1000);
            $this->objParam->addParametroConsulta('puntero',0);
            
            $this->objFunc = $this->create('MODCotizacion');
            $this->res = $this->objFunc->reporteCotizacion();
            
            $datosCotizacion = $this->res->getDatos();
            //armamos el array parametros y metemos ahi los data sets de las otras tablas
            $dataSource->putParameter('tipo',$tipo);
            $dataSource->putParameter('estado', $datosCotizacion[0]['estado']);
            $dataSource->putParameter('fecha_adju', $datosCotizacion[0]['fecha_adju']);
            $dataSource->putParameter('fecha_venc', $datosCotizacion[0]['fecha_venc']);
            $dataSource->putParameter('fecha_coti', $datosCotizacion[0]['fecha_coti']);
            $dataSource->putParameter('fecha_entrega', $datosCotizacion[0]['fecha_entrega']);
            $dataSource->putParameter('id_moneda', $datosCotizacion[0]['id_moneda']);
            $dataSource->putParameter('moneda', $datosCotizacion[0]['moneda']);
            $dataSource->putParameter('id_proceso_compra', $datosCotizacion[0]['id_proceso_compra']);
            $dataSource->putParameter('codigo_proceso', $datosCotizacion[0]['codigo_proceso']);
            $dataSource->putParameter('num_cotizacion', $datosCotizacion[0]['num_cotizacion']);
            $dataSource->putParameter('num_tramite', $datosCotizacion[0]['num_tramite']);
            $dataSource->putParameter('id_proveedor', $datosCotizacion[0]['id_proveedor']);
            $dataSource->putParameter('desc_proveedor', $datosCotizacion[0]['desc_proveedor']);
            
            if($datosCotizacion[0]['id_institucion']===NULL){
                $dataSource->putParameter('direccion', $datosCotizacion[0]['dir_per']);
                $dataSource->putParameter('telefono1', $datosCotizacion[0]['tel_per1']);
                $dataSource->putParameter('telefono2', $datosCotizacion[0]['tel_per2']);
                $dataSource->putParameter('celular', $datosCotizacion[0]['cel_per']);
                $dataSource->putParameter('email', $datosCotizacion[0]['correo']);
            }
            else{
                $dataSource->putParameter('direccion', $datosCotizacion[0]['dir_ins']);
                $dataSource->putParameter('telefono1', $datosCotizacion[0]['tel_ins1']);
                $dataSource->putParameter('telefono2', $datosCotizacion[0]['tel_ins2']);
                $dataSource->putParameter('celular', $datosCotizacion[0]['cel_ins']);
                $dataSource->putParameter('email', $datosCotizacion[0]['email_ins']);
            }
            $dataSource->putParameter('fax', $datosCotizacion[0]['fax']);
            $dataSource->putParameter('lugar_entrega', $datosCotizacion[0]['lugar_entrega']);
            $dataSource->putParameter('nro_contrato', $datosCotizacion[0]['nro_contrato']);
            $dataSource->putParameter('numero_oc', $datosCotizacion[0]['numero_oc']);
            $dataSource->putParameter('obs', $datosCotizacion[0]['obs']);
            $dataSource->putParameter('tipo_entrega', $datosCotizacion[0]['tipo_entrega']);
            //get detalle
            //Reset all extra params:
            $this->objParam->defecto('ordenacion', 'id_cotizacion_det');
            $this->objParam->defecto('cantidad', 1000);
            $this->objParam->defecto('puntero', 0);
            $this->objParam->addParametro('id_cotizacion', $idCotizacion );
    
            $modCotizacionDet = $this->create('MODCotizacionDet');
            $resultCotizacionDet = $modCotizacionDet->listarCotizacionDet();
            $cotizacionDetDataSource = new DataSource();
            $cotizacionDetDataSource->setDataSet($resultCotizacionDet->getDatos());
            $dataSource->putParameter('detalleDataSource', $cotizacionDetDataSource);
    
            //build the report
            $reporte = new RCotizacion();
            $reporte->setDataSource($dataSource);
            $nombreArchivo = 'Cotizacion.pdf';
            $reportWriter = new ReportWriter($reporte, dirname(__FILE__).'/../../reportes_generados/'.$nombreArchivo);
            $reportWriter->writeReport(ReportWriter::PDF);
    
            if(!$create_file){
                $mensajeExito = new Mensaje();
                $mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
                'Se generó con éxito el reporte: '.$nombreArchivo,'control' );
                    $mensajeExito->setArchivoGenerado($nombreArchivo);
                    $this->res = $mensajeExito;
                    $this->res->imprimirRespuesta($this->res->generarJson());
            }
            else{
                        
                 return dirname(__FILE__).'/../../reportes_generados/'.$nombreArchivo;  
                
            }

        }

      function reporteOC($create_file=false){
                $dataSource = new DataSource();
                $this->objParam->addParametroConsulta('ordenacion','id_cotizacion');
                $this->objParam->addParametroConsulta('dir_ordenacion','ASC');
                $this->objParam->addParametroConsulta('cantidad',1000);
                $this->objParam->addParametroConsulta('puntero',0);
                $this->objFunc = $this->create('MODCotizacion');
                $resultOrdenCompra = $this->objFunc->reporteOrdenCompra();
                $datosOrdenCompra = $resultOrdenCompra->getDatos();
                //armamos el array parametros y metemos ahi los data sets de las otras tablas
                $dataSource->putParameter('id_proceso_compra', $datosOrdenCompra[0]['id_proceso_compra']);
                $dataSource->putParameter('desc_proveedor', $datosOrdenCompra[0]['desc_proveedor']);
                
                if($datosOrdenCompra[0]['id_persona']!=''){
                    $dataSource->putParameter('direccion', $datosOrdenCompra[0]['dir_persona']);
                    $dataSource->putParameter('telefono1', $datosOrdenCompra[0]['telf1_persona']);
                    $dataSource->putParameter('telefono2', $datosOrdenCompra[0]['telf2_persona']);
                    $dataSource->putParameter('celular', $datosOrdenCompra[0]['cel_persona']);
                    $dataSource->putParameter('email', $datosOrdenCompra[0]['correo_persona']);
                     $dataSource->putParameter('fax', '');
                }
                
                if($datosOrdenCompra[0]['id_institucion']!=''){
                    $dataSource->putParameter('direccion', $datosOrdenCompra[0]['dir_institucion']);
                    $dataSource->putParameter('telefono1', $datosOrdenCompra[0]['telf1_institucion']);
                    $dataSource->putParameter('telefono2', $datosOrdenCompra[0]['telf2_institucion']);
                    $dataSource->putParameter('celular', $datosOrdenCompra[0]['cel_institucion']);
                    $dataSource->putParameter('email', $datosOrdenCompra[0]['email_institucion']);
                    $dataSource->putParameter('fax', $datosOrdenCompra[0]['fax_institucion']);
                  }
                $dataSource->putParameter('fecha_entrega', $datosOrdenCompra[0]['fecha_entrega']);
                $dataSource->putParameter('dias_entrega', $datosOrdenCompra[0]['dias_entrega']);
                $dataSource->putParameter('lugar_entrega', $datosOrdenCompra[0]['lugar_entrega']);
                $dataSource->putParameter('numero_oc', $datosOrdenCompra[0]['numero_oc']);
                $dataSource->putParameter('tipo_entrega', $datosOrdenCompra[0]['tipo_entrega']);
                $dataSource->putParameter('tipo', $datosOrdenCompra[0]['tipo']);
                $dataSource->putParameter('fecha_oc', $datosOrdenCompra[0]['fecha_oc']);
                $dataSource->putParameter('moneda', $datosOrdenCompra[0]['moneda']);
                $dataSource->putParameter('codigo_moneda', $datosOrdenCompra[0]['codigo_moneda']);

                //get detalle
                //Reset all extra params:
                $this->objParam->defecto('ordenacion', 'id_solicitud_det');
                $this->objParam->defecto('cantidad', 1000);
                $this->objParam->defecto('puntero', 0);
                $this->objParam->addParametro('id_solicitud', $idSolicitud );

                $modCotizacionDet = $this->create('MODCotizacionDet');
                $resultCotizacionDet = $modCotizacionDet->listarCotizacionDet();
                //$solicitudDetAgrupado = $this->groupArray($resultSolicitudDet->getDatos(), 'codigo_partida','desc_centro_costo');
                $cotizacionDetDataSource = new DataSource();
                $cotizacionDetDataSource->setDataSet($resultCotizacionDet->getDatos());
                $dataSource->putParameter('detalleDataSource', $cotizacionDetDataSource);

                //build the report
                $reporte = new ROrdenCompra();
                $reporte->setDataSource($dataSource);
                if($datosOrdenCompra[0]['tipo']=='Bien')
                    $nombreArchivo = 'OrdenCompra.pdf';
                else
                if($datosOrdenCompra[0]['tipo']=='Servicio')
                    $nombreArchivo = 'OrdenServicio.pdf';
                else
                $nombreArchivo = 'OrdenCompraServicio.pdf';

                $reportWriter = new ReportWriter($reporte, dirname(__FILE__).'/../../reportes_generados/'.$nombreArchivo);
                $reportWriter->writeReport(ReportWriter::PDF);

                
            if(!$create_file){
                $mensajeExito = new Mensaje();
                $mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
                'Se generó con éxito el reporte: '.$nombreArchivo,'control');
                $mensajeExito->setArchivoGenerado($nombreArchivo);
                $this->res = $mensajeExito;
                $this->res->imprimirRespuesta($this->res->generarJson());
            }
            else{
                        
                 return dirname(__FILE__).'/../../reportes_generados/'.$nombreArchivo;  
                
            }

     }
     
   function sendMailCotizacion(){
         //genera archivo adjunto
        $file = $this->reporteCotizacion(true);
      
        $correo=new CorreoExterno();
        $email = $this->objParam->getParametro('email');
        $correo->addDestinatario($email);
        $correo->setAsunto('Solcitud de Cotizacion');
        $correo->setMensaje('Mediante la presente solicitamos  a su distinguida empresa, enviarnos una cotización segun formulario adjunto');
        $correo->setTitulo('Solicitud de Cotización');
        $correo->addAdjunto($file);
        $correo->setDefaultPlantilla();
        $resp=$correo->enviarCorreo();           
        
        if($resp=='OK'){
                $mensajeExito = new Mensaje();
                $mensajeExito->setMensaje('EXITO','Cotizacion.php','Correo enviado',
                'Se mando el correo con exito: OK','control' );
                   
                    $this->res = $mensajeExito;
                    $this->res->imprimirRespuesta($this->res->generarJson());
            
        }  
        else{
              //echo $resp;      
              echo "{\"ROOT\":{\"error\":true,\"detalle\":{\"mensaje\":\" Error al enviar correo\"}}}";  
              
        }  
        
        unlink($file);
        exit;
           
       
   }
   
   function SolicitarContrato(){
         
        //hacer el contrato exigible  
        
        $this->objFunc=$this->create('MODCotizacion' );
        $this->res=$this->objFunc->SolicitarContrato($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson()); 
        
        if($this->res->getTipo()=='ERROR'){
           $this->res->imprimirRespuesta($this->res->generarMensajeJson());
           exit;
        }
                      
        //genera archivo adjunto
        $file = $this->reporteOC(true);
        $correo=new CorreoExterno();
        //destinatario
        $email = $this->objParam->getParametro('email');
        $correo->addDestinatario($email);
        //asunto
        $asunto = $this->objParam->getParametro('asunto');
        $correo->setAsunto($asunto);
        //cuerpo mensaje
        $body = $this->objParam->getParametro('body');
        $correo->setMensaje($body);
        $correo->setTitulo('Solicitud de contrato');
        $correo->addAdjunto($file);
        
        $correo->setDefaultPlantilla();
        $resp=$correo->enviarCorreo();           
        
        if($resp=='OK'){
                $mensajeExito = new Mensaje();
                $mensajeExito->setMensaje('EXITO','Cotizacion.php','Correo enviado',
                'Se mando el correo con exito: OK','control' );
                $this->res = $mensajeExito;
                $this->res->imprimirRespuesta($this->res->generarJson());
            
        }  
        else{
              //echo $resp;      
              echo "{\"ROOT\":{\"error\":true,\"detalle\":{\"mensaje\":\" Error al enviar correo\"}}}";  
              
        }  
        
        unlink($file);
        exit;
           
       
   }

   function finalizarRegistro(){
        $this->objFunc=$this->create('MODCotizacion');  
        $this->res=$this->objFunc->finalizarRegistro($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
    function adjudicarTodo(){
        $this->objFunc=$this->create('MODCotizacion');  
        $this->res=$this->objFunc->adjudicarTodo($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
     function generarOC(){
        $this->objFunc=$this->create('MODCotizacion');  
        $this->res=$this->objFunc->generarOC($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
    function solicitarAprobacion(){
        $this->objFunc=$this->create('MODCotizacion');  
        $this->res=$this->objFunc->solicitarAprobacion($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
       
    }
    
    function siguienteEstadoCotizacion(){
        $this->objFunc=$this->create('MODCotizacion');  
        $this->res=$this->objFunc->siguienteEstadoCotizacion($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
       
    }
    
     function anteriorEstadoCotizacion(){
        $this->objFunc=$this->create('MODCotizacion');  
        $this->res=$this->objFunc->anteriorEstadoCotizacion($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    

       function habilitarPago(){
        $this->objFunc=$this->create('MODCotizacion');  
        $this->res=$this->objFunc->habilitarPago($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
  
    function listarDeptoFiltradoCotizacion(){
            
        $this->objFunc=$this->create('MODCotizacion'); 
        $this->res=$this->objFunc->obtnerUosEpsDetalleAdjudicado($this->objParam);
        
        //si sucede un error
        if($this->res->getTipo()=='ERROR'){
            
            $this->res->imprimirRespuesta($this->res->generarJson());
            exit;
        }

        $this->datos=array();
        $this->datos=$this->res->getDatos();
        
        $uos=$this->res->datos['uos'];
        $eps=$this->res->datos['eps'];
   
        
        $this->objParam->addParametro('eps',$eps);
        $this->objParam->addParametro('uos',$uos);
        
        
        // parametros de ordenacion por defecto
        $this->objParam->defecto('ordenacion','depto');
        $this->objParam->defecto('dir_ordenacion','asc');
       
        $this->objFunc=$this->create('sis_parametros/MODDepto'); 
        //ejecuta el metodo de lista personas a travez de la intefaz objetoFunSeguridad 
        $this->res=$this->objFunc->listarDeptoFiltradoXUOsEPs($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
        
        
    }

	function generarPreingreso(){
        $this->objFunc=$this->create('MODCotizacion');  
        $this->res=$this->objFunc->generarPreingreso($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    

}

?>