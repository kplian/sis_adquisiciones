<?php
/**
*@package pXP
*@file gen-ACTPlanPago.php
*@author  (admin)
*@date 10-04-2013 15:43:23
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*
*@date 30/08/2018
*@description añadida la columna retenciones de garantía para mostrar el reporte de solicitud de pago
		ISSUE	FORK 	   FECHA			AUTHOR			DESCRIPCION
 		  #5	EndeETR		27/12/2018		EGS				Se añadio el dato de codigo de proveedor
 *        #35   ETR         07/10/2019      RAC            Adicionar descuento de anticipos en reporte de plan de pagos 
 *        #41   ENDETR      16/12/2019      JUAN           Reporte de información de pago
 * */
require_once(dirname(__FILE__).'/../reportes/ReporteConsulta.php');

class ACTPlanPagoRep extends ACTbase{
			
	function listarPlanPagoRep(){

		$this->objParam->defecto('ordenacion','id_plan_pago');
        $this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('pes_estado')=='internacional'){
             $this->objParam->addFiltro("plapa.prioridad = 3");
        }
		if($this->objParam->getParametro('pes_estado')=='nacional'){
             $this->objParam->addFiltro("plapa.prioridad  != 3");
        }


		if($this->objParam->getParametro('id_gestion')!=''){
            $this->objParam->addFiltro("plapa.id_gestion = ".$this->objParam->getParametro('id_gestion'));
        }
		
		if($this->objParam->getParametro('id_obligacion_pago')!=''){
            $this->objParam->addFiltro("plapa.id_obligacion_pago = ".$this->objParam->getParametro('id_obligacion_pago'));  
        }
        
        if($this->objParam->getParametro('filtro_campo')!=''){
            $this->objParam->addFiltro($this->objParam->getParametro('filtro_campo')." = ".$this->objParam->getParametro('filtro_valor'));  
        }


        if($this->objParam->getParametro('id_depto')!=''){
            $this->objParam->addFiltro(" plapa.id_depto = ".$this->objParam->getParametro('id_depto'));
        }


        if($this->objParam->getParametro('id_periodo')!=''){
            $this->objParam->addFiltro("plapa.id_periodo =".$this->objParam->getParametro('id_periodo'));
        }

        if($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')!=''){
            $this->objParam->addFiltro("( plapa.fecha_tentativa::date  BETWEEN ''%".$this->objParam->getParametro('desde')."%''::date  and ''%".$this->objParam->getParametro('hasta')."%''::date)");
        }

        if($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')==''){
            $this->objParam->addFiltro("( plapa.fecha_tentativa::date  >= ''%".$this->objParam->getParametro('desde')."%''::date)");
        }

        if($this->objParam->getParametro('desde')=='' && $this->objParam->getParametro('hasta')!=''){
            $this->objParam->addFiltro("( plapa.fecha_tentativa::date  <= ''%".$this->objParam->getParametro('hasta')."%''::date)");
        }

        if($this->objParam->getParametro('num_tramite')!=''){
            $this->objParam->addFiltro("plapa.num_tramite = ''".$this->objParam->getParametro('num_tramite')."'' ");
        }

        if($this->objParam->getParametro('id_proveedor')!=''){
            $this->objParam->addFiltro("plapa.id_proveedor = ''".$this->objParam->getParametro('id_proveedor')."'' ");
        }
        if($this->objParam->getParametro('codigo_tcc')!=''){
            $this->objParam->addFiltro(" plapa.cecos::varchar like ''%".strtoupper($this->objParam->getParametro('codigo_tcc'))."%'' ");
        }
        
		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
        
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPlanPagoRep','listarPlanPagoRep');
		} else{
			$this->objFunc=$this->create('MODPlanPagoRep');
			
			$this->res=$this->objFunc->listarPlanPagoRep($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
    function ListarNumTraObp(){
        if($this->objParam->getParametro('num_tramite')!=''){
            $this->objParam->addFiltro("obp.num_tramite = ".$this->objParam->getParametro('num_tramite'));
        }
        $this->objParam->defecto('ordenacion','num_tramite');
        $this->objParam->defecto('dir_ordenacion','asc');
        $this->objFunc=$this->create('MODPlanPagoRep');
        $this->res=$this->objFunc->ListarNumTraObp($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    //
    function listarReporteConsulta(){
        $this->objParam->defecto('ordenacion','num_tramite');
        $this->objParam->defecto('dir_ordenacion','asc');
        //
        if($this->objParam->getParametro('id_gestion')!=''){
            $this->objParam->addFiltro("sol.id_gestion = ".$this->objParam->getParametro('id_gestion'));
        }
        if($this->objParam->getParametro('filtro_campo')!=''){
            $this->objParam->addFiltro($this->objParam->getParametro('filtro_campo')." = ".$this->objParam->getParametro('filtro_valor'));  
        }

        if($this->objParam->getParametro('id_depto')!=''){
            $this->objParam->addFiltro(" sol.id_depto = ".$this->objParam->getParametro('id_depto'));
        }

        /*if($this->objParam->getParametro('id_periodo')!=''){
            $this->objParam->addFiltro("plapa.id_periodo =".$this->objParam->getParametro('id_periodo'));
        }*/

        if($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')!=''){
            $this->objParam->addFiltro("(fecha_adju::date  BETWEEN ''%".$this->objParam->getParametro('desde')."%''::date  and ''%".$this->objParam->getParametro('hasta')."%''::date)");
        }

        if($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')==''){
            $this->objParam->addFiltro("(fecha_adju::date  >= ''%".$this->objParam->getParametro('desde')."%''::date)");
        }

        if($this->objParam->getParametro('desde')=='' && $this->objParam->getParametro('hasta')!=''){
            $this->objParam->addFiltro("(fecha_adju::date  <= ''%".$this->objParam->getParametro('hasta')."%''::date)");
        }

        if($this->objParam->getParametro('num_tramite')!=''){
            $this->objParam->addFiltro("sol.num_tramite = ''".$this->objParam->getParametro('num_tramite')."'' ");
        }

        if($this->objParam->getParametro('id_proveedor')!=''){
            $this->objParam->addFiltro("prov.id_proveedor = ''".$this->objParam->getParametro('id_proveedor')."'' ");
        }

        if($this->objParam->getParametro('codigo_tcc')!=''){
            $this->objParam->addFiltro(" oc.cecos::varchar like ''%".strtoupper($this->objParam->getParametro('codigo_tcc'))."%'' ");
        }
        if($this->objParam->getParametro('id_categoria_compra')!=''){
            $this->objParam->addFiltro("sol.id_categoria_compra = ''".$this->objParam->getParametro('id_categoria_compra')."'' ");
        }
        //$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]);

        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODPlanPagoRep','listarReporteConsulta');
        } else{
            $this->objFunc=$this->create('MODPlanPagoRep');
            $this->res=$this->objFunc->listarReporteConsulta($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    //
    function ListadoReporte(){

        if($this->objParam->getParametro('id_gestion')!=''){
            $this->objParam->addFiltro("sol.id_gestion = ".$this->objParam->getParametro('id_gestion'));
        }
        if($this->objParam->getParametro('filtro_campo')!=''){
            $this->objParam->addFiltro($this->objParam->getParametro('filtro_campo')." = ".$this->objParam->getParametro('filtro_valor'));  
        }

        if($this->objParam->getParametro('id_depto')!=''){
            $this->objParam->addFiltro(" sol.id_depto = ".$this->objParam->getParametro('id_depto'));
        }

        if($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')!=''){
            $this->objParam->addFiltro("(fecha_adju::date  BETWEEN ''%".$this->objParam->getParametro('desde')."%''::date  and ''%".$this->objParam->getParametro('hasta')."%''::date)");
        }

        if($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')==''){
            $this->objParam->addFiltro("(fecha_adju::date  >= ''%".$this->objParam->getParametro('desde')."%''::date)");
        }

        if($this->objParam->getParametro('desde')=='' && $this->objParam->getParametro('hasta')!=''){
            $this->objParam->addFiltro("(fecha_adju::date  <= ''%".$this->objParam->getParametro('hasta')."%''::date)");
        }

        if($this->objParam->getParametro('num_tramite')!=''){
            $this->objParam->addFiltro("sol.num_tramite = ''".$this->objParam->getParametro('num_tramite')."'' ");
        }

        if($this->objParam->getParametro('id_proveedor')!=''){
            $this->objParam->addFiltro("prov.id_proveedor = ''".$this->objParam->getParametro('id_proveedor')."'' ");
        }

        if($this->objParam->getParametro('codigo_tcc')!=''){
            $this->objParam->addFiltro(" oc.cecos::varchar like ''%".strtoupper($this->objParam->getParametro('codigo_tcc'))."%'' ");
        }
        if($this->objParam->getParametro('id_categoria_compra')!=''){
            $this->objParam->addFiltro("sol.id_categoria_compra = ''".$this->objParam->getParametro('id_categoria_compra')."'' ");
        }
        $this->objFunc = $this->create('MODPlanPagoRep');
        $this->res = $this->objFunc->recuperarConsulta($this->objParam);
        $this->objParam->addParametro('datos',$this->res->datos);
        $this->objParam->addParametro('tipo','detalle');
        $titulo = 'EstadoProcesos';
        $nombreArchivo=uniqid(md5(session_id()).$titulo);
        $nombreArchivo.='.xls';
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
        
        $this->objReporteFormato=new ReporteConsulta($this->objParam);
        $this->objReporteFormato->imprimeDetalle();
        $this->objReporteFormato->generarReporte();
        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }
}

?>