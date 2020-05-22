<?php
/**
*@package pXP
*@file ACTCotizacion.php
*@author  Gonzalo Sarmiento Sejas
*@date 21-03-2013 14:48:35
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 ISSUE       AUTHOR          FECHA           DESCRIPCION
 #18           EGS            22/05/2020      Filtros Para Cotizaciones
*/
require_once(dirname(__FILE__).'/../../pxp/pxpReport/ReportWriter.php');
require_once(dirname(__FILE__).'/../reportes/RCotizacion.php');
require_once(dirname(__FILE__).'/../reportes/ROrdenCompra.php');
require_once(dirname(__FILE__).'/../reportes/RCartaAdjudicacion.php');
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
include_once(dirname(__FILE__).'/../../lib/PHPMailer/class.phpmailer.php');
include_once(dirname(__FILE__).'/../../lib/PHPMailer/class.smtp.php');
include_once(dirname(__FILE__).'/../../lib/lib_general/cls_correo_externo.php');

class ACTCotizacion extends ACTbase{    
			
	function listarCotizacion(){
		$this->objParam->defecto('ordenacion','id_cotizacion');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
		
		if($this->objParam->getParametro('filtro_campo')!=''){
            $this->objParam->addFiltro($this->objParam->getParametro('filtro_campo')." = ".$this->objParam->getParametro('filtro_valor'));  
        }

		///////#18

        if($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')!=''){
            $this->objParam->addFiltro("( cot.fecha_coti::date  BETWEEN ''%".$this->objParam->getParametro('desde')."%''::date  and ''%".$this->objParam->getParametro('hasta')."%''::date)");
        }

        if($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')==''){
            $this->objParam->addFiltro("( cot.fecha_coti::date  >= ''%".$this->objParam->getParametro('desde')."%''::date)");
        }

        if($this->objParam->getParametro('desde')=='' && $this->objParam->getParametro('hasta')!=''){
            $this->objParam->addFiltro("( cot.fecha_coti::date  <= ''%".$this->objParam->getParametro('hasta')."%''::date)");
        }
        if($this->objParam->getParametro('num_tramite')!=''){
            $this->objParam->addFiltro("cot.num_tramite like ''%".$this->objParam->getParametro('num_tramite')."%'' ");
        }
        if($this->objParam->getParametro('id_proveedor')!=''){
            $this->objParam->addFiltro("cot.id_proveedor = ''".$this->objParam->getParametro('id_proveedor')."'' ");
        }
        if($this->objParam->getParametro('id_categoria_compra')!=''){
            $this->objParam->addFiltro("cot.id_categoria_compra = ''".$this->objParam->getParametro('id_categoria_compra')."'' ");
        }
        if($this->objParam->getParametro('codigo_proceso')!=''){
            $this->objParam->addFiltro("cot.codigo_proceso like ''%".$this->objParam->getParametro('codigo_proceso')."%'' ");
        }
        if($this->objParam->getParametro('codigo_tcc')!=''){
            $this->objParam->addFiltro(" cot.cecos::varchar like ''%".strtoupper($this->objParam->getParametro('codigo_tcc'))."%''");
        }
        ///////////
		
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
        
        if($this->objParam->getParametro('filtro_campo')!=''){
            $this->objParam->addFiltro($this->objParam->getParametro('filtro_campo')." = ".$this->objParam->getParametro('filtro_valor'));  
        }
        
        
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
	
	function generarNumOC(){
		$this->objFunc=$this->create('MODCotizacion' );
        $this->res=$this->objFunc->generarNumOC($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
	
	function reporteCartaAdjudicacion( $create_file = false){
		
		        $dataSource = new DataSource();
				$idSolicitud = $this->objParam->getParametro('id_solicitud');
				$id_proceso_wf= $this->objParam->getParametro('id_proceso_wf');				
                $this->objParam->addParametroConsulta('ordenacion','id_cotizacion');
                $this->objParam->addParametroConsulta('dir_ordenacion','ASC');
                $this->objParam->addParametroConsulta('cantidad',1000);
                $this->objParam->addParametroConsulta('puntero',0);
                $this->objFunc = $this->create('MODCotizacion');
                $resultOrdenCompra = $this->objFunc->reporteOrdenCompra();
			
				if($resultOrdenCompra->getTipo()=='EXITO'){
				 	
					    $datosOrdenCompra = $resultOrdenCompra->getDatos();
						
		                //armamos el array parametros y metemos ahi los data sets de las otras tablas
		                $dataSource->putParameter('id_proceso_compra', $datosOrdenCompra[0]['id_proceso_compra']);
		                $dataSource->putParameter('desc_proveedor', $datosOrdenCompra[0]['desc_proveedor']);
						$dataSource->putParameter('contacto', $datosOrdenCompra[0]['nombre_completo1']);
						$dataSource->putParameter('celular_contacto', $datosOrdenCompra[0]['celular1']);
						$dataSource->putParameter('email_contacto', $datosOrdenCompra[0]['email_empresa']);
						$dataSource->putParameter('codigo_proceso', $datosOrdenCompra[0]['codigo_proceso']);
						$dataSource->putParameter('forma_pago', $datosOrdenCompra[0]['forma_pago']);
						$dataSource->putParameter('objeto', $datosOrdenCompra[0]['objeto']);
		                
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
		                $dataSource->putParameter('tiempo_entrega', $datosOrdenCompra[0]['tiempo_entrega']);
		                $dataSource->putParameter('dias_entrega', $datosOrdenCompra[0]['dias_entrega']);
		                $dataSource->putParameter('lugar_entrega', $datosOrdenCompra[0]['lugar_entrega']);
		                $dataSource->putParameter('numero_oc', $datosOrdenCompra[0]['numero_oc']);
		                $dataSource->putParameter('tipo_entrega', $datosOrdenCompra[0]['tipo_entrega']);
		                $dataSource->putParameter('tipo', $datosOrdenCompra[0]['tipo']);
		                $dataSource->putParameter('fecha_oc', $datosOrdenCompra[0]['fecha_oc']);
		                $dataSource->putParameter('moneda', $datosOrdenCompra[0]['moneda']);
		                $dataSource->putParameter('codigo_moneda', $datosOrdenCompra[0]['codigo_moneda']);
						$dataSource->putParameter('num_tramite', $datosOrdenCompra[0]['num_tramite']);
		
		                //get detalle
		                //Reset all extra params:
		                $this->objParam->defecto('ordenacion', 'id_solicitud_det');
		                $this->objParam->defecto('cantidad', 1000);
		                $this->objParam->defecto('puntero', 0);
						
						$this->objParam->addParametro('id_cotizacion', $datosOrdenCompra[0]['id_cotizacion'] );
		
		                $modCotizacionDet = $this->create('MODCotizacionDet');
		                $resultCotizacionDet = $modCotizacionDet->listarCotizacionDetReporte();
						
						if($resultCotizacionDet->getTipo() == 'EXITO'){
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
					
					                //build the report
						            $reporte = new RCartaAdjudicacion();
						            $reporte->setDataSource($dataSource);
						            $nombreArchivo = 'carta.docx';
						            $reporte->write(dirname(__FILE__).'/../../reportes_generados/'.$nombreArchivo);
						    
						            
					                $mensajeExito = new Mensaje();
					                $mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
					                'Se generó con éxito el reporte: '.$nombreArchivo,'control');
					                $mensajeExito->setArchivoGenerado($nombreArchivo);
					                $this->res = $mensajeExito;
					                $this->res->imprimirRespuesta($this->res->generarJson());
						            
						}
				       else{
				            $resultCotizacionDet->imprimirRespuesta($resultCotizacionDet->generarJson());
				       }
			   }
		       else{
		                
		             $resultOrdenCompra->imprimirRespuesta($resultOrdenCompra->generarJson());
		       }
            
    
           
            

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
             $this->objParam->defecto('ordenacion', 'id_solicitud_det');
            $this->objParam->defecto('cantidad', 1000);
            $this->objParam->defecto('puntero', 0);
            $this->objParam->addParametro('id_cotizacion', $idCotizacion );
    
            $modCotizacionDet = $this->create('MODCotizacionDet');
            $resultCotizacionDet = $modCotizacionDet->listarCotizacionDetReporte();
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
		$idSolicitud = $this->objParam->getParametro('id_solicitud');
		$id_proceso_wf= $this->objParam->getParametro('id_proceso_wf');				
		$this->objParam->addParametroConsulta('ordenacion','id_cotizacion');
		$this->objParam->addParametroConsulta('dir_ordenacion','ASC');
		$this->objParam->addParametroConsulta('cantidad',1000);
		$this->objParam->addParametroConsulta('puntero',0);
		$this->objFunc = $this->create('MODCotizacion');
		$resultOrdenCompra = $this->objFunc->reporteOrdenCompra();
		
				if($resultOrdenCompra->getTipo()=='EXITO'){
				 	
					    $datosOrdenCompra = $resultOrdenCompra->getDatos();
				
		                //armamos el array parametros y metemos ahi los data sets de las otras tablas
		                $dataSource->putParameter('id_proceso_compra', $datosOrdenCompra[0]['id_proceso_compra']);
		                $dataSource->putParameter('desc_proveedor', $datosOrdenCompra[0]['desc_proveedor']);
						$dataSource->putParameter('contacto', $datosOrdenCompra[0]['nombre_completo1']);
						$dataSource->putParameter('celular_contacto', $datosOrdenCompra[0]['celular1']);
						$dataSource->putParameter('email_contacto', $datosOrdenCompra[0]['email_empresa']);
						$dataSource->putParameter('codigo_proceso', $datosOrdenCompra[0]['codigo_proceso']);
						$dataSource->putParameter('forma_pago', $datosOrdenCompra[0]['forma_pago']);
		                
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
		                $dataSource->putParameter('tiempo_entrega', $datosOrdenCompra[0]['tiempo_entrega']);
		                $dataSource->putParameter('dias_entrega', $datosOrdenCompra[0]['dias_entrega']);
		                $dataSource->putParameter('lugar_entrega', $datosOrdenCompra[0]['lugar_entrega']);
		                $dataSource->putParameter('numero_oc', $datosOrdenCompra[0]['numero_oc']);
		                $dataSource->putParameter('tipo_entrega', $datosOrdenCompra[0]['tipo_entrega']);
		                $dataSource->putParameter('tipo', $datosOrdenCompra[0]['tipo']);
		                $dataSource->putParameter('fecha_oc', $datosOrdenCompra[0]['fecha_oc']);
		                $dataSource->putParameter('moneda', $datosOrdenCompra[0]['moneda']);
		                $dataSource->putParameter('codigo_moneda', $datosOrdenCompra[0]['codigo_moneda']);
						$dataSource->putParameter('num_tramite', $datosOrdenCompra[0]['num_tramite']);
						$dataSource->putParameter('id_categoria_compra', $datosOrdenCompra[0]['id_categoria_compra']);
						$dataSource->putParameter('codigo_uo', $datosOrdenCompra[0]['codigo_uo']);
						$dataSource->putParameter('observacion', $datosOrdenCompra[0]['observacion']);
						$dataSource->putParameter('obs', $datosOrdenCompra[0]['obs']);
		
		                //get detalle
		                //Reset all extra params:
		                $this->objParam->defecto('ordenacion', 'id_solicitud_det');
		                $this->objParam->defecto('cantidad', 1000);
		                $this->objParam->defecto('puntero', 0);
						
						$this->objParam->addParametro('id_cotizacion', $datosOrdenCompra[0]['id_cotizacion'] );
		
		                $modCotizacionDet = $this->create('MODCotizacionDet');
		                $resultCotizacionDet = $modCotizacionDet->listarCotizacionDetReporte();
						
						if($resultCotizacionDet->getTipo() == 'EXITO'){
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
				       else{
				            $resultCotizacionDet->imprimirRespuesta($resultCotizacionDet->generarJson());
				       }
			   }
		       else{
		                
		             $resultOrdenCompra->imprimirRespuesta($resultOrdenCompra->generarJson());
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
        
        $email_cc = $this->objParam->getParametro('email_cc');
        $correo->addCC($email_cc);
        
        
        
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
	
	function habilitarContrato(){
        $this->objFunc=$this->create('MODCotizacion');  
        $this->res=$this->objFunc->habilitarContrato($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
	
    function cambioFomrulario500(){
        $this->objFunc=$this->create('MODCotizacion');  
        $this->res=$this->objFunc->cambioFomrulario500($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function ListarNumTraCot(){
        if($this->objParam->getParametro('num_tramite')!=''){
            $this->objParam->addFiltro("cot.num_tramite = ".$this->objParam->getParametro('num_tramite'));
        }
        $this->objParam->defecto('ordenacion','num_tramite');
        $this->objParam->defecto('dir_ordenacion','asc');
        $this->objFunc=$this->create('MODCotizacion');
        $this->res=$this->objFunc->ListarNumTraCot($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function ListarCodigoProcesoCot(){
        if($this->objParam->getParametro('codigo_proceso')!=''){
            $this->objParam->addFiltro("cot.codigo_proceso = ".$this->objParam->getParametro('codigo_proceso'));
        }
        $this->objParam->defecto('ordenacion','codigo_proceso');
        $this->objParam->defecto('dir_ordenacion','asc');
        $this->objFunc=$this->create('MODCotizacion');
        $this->res=$this->objFunc->ListarCodigoProcesoCot($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    

}

?>