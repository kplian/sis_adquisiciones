<?php
/****************************************************************************************
*@package pXP
*@file ACTBoleta.php
*@author  (egutierrez)
*@date 25-03-2021 13:42:09
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo

 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR                DESCRIPCION
  #0                25-03-2021 13:42:09    egutierrez             Creacion    
  #
*****************************************************************************************/

class ACTBoleta extends ACTbase{    
            
    function listarBoleta(){
		$this->objParam->defecto('ordenacion','idboleta');
        $this->objParam->defecto('dir_ordenacion','asc');

        if($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')!=''){
            $this->objParam->addFiltro("(b.fechafin::date  BETWEEN ''%".$this->objParam->getParametro('desde')."%''::date  and ''%".$this->objParam->getParametro('hasta')."%''::date)");
        }

        if($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')==''){
            $this->objParam->addFiltro("(b.fechafin::date  >= ''%".$this->objParam->getParametro('desde')."%''::date)");
        }

        if($this->objParam->getParametro('desde')=='' && $this->objParam->getParametro('hasta')!=''){
            $this->objParam->addFiltro("(b.fechafin::date  <= ''%".$this->objParam->getParametro('hasta')."%''::date)");
        }

        if($this->objParam->getParametro('id_gestor') != ''){
            $this->objParam->addFiltro("(i.Cd_empleado_gestor ::integer  = ".$this->objParam->getParametro('id_gestor')."::integer )");
        }

        if($this->objParam->getParametro('estado') != ''){
            $this->objParam->addFiltro("( b.estado ::integer  = ".$this->objParam->getParametro('estado')."::integer )");
        }

        if($this->objParam->getParametro('otorgante') != ''){
            $this->objParam->addFiltro("( b.otorgante  = ''".$this->objParam->getParametro('otorgante')."''::varchar )");
        }

        if($this->objParam->getParametro('cod_responsable') != ''){
            $this->objParam->addFiltro("( b.codresponsable  = ''".$this->objParam->getParametro('cod_responsable')."''::varchar )");
        }

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODBoleta','listarBoleta');
        } else{
        	$this->objFunc=$this->create('MODBoleta');
            
        	$this->res=$this->objFunc->listarBoleta($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function listarGestor(){
        /*if($this->objParam->getParametro('completo')!=''){
            $this->objParam->addFiltro("pt.completo::varchar like UPPER(''%".$this->objParam->getParametro('completo')."%'')");
        }*/

        $this->objParam->defecto('ordenacion','cd_empleado');
        $this->objParam->defecto('dir_ordenacion','asc');
        $this->objFunc=$this->create('MODBoleta');
        $this->res=$this->objFunc->listarGestor($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function listarPersona(){

        //el objeto objParam contiene todas la variables recibidad desde la interfaz

        // parametros de ordenacion por defecto
        $this->objParam->defecto('ordenacion','ap_paterno');
        $this->objParam->defecto('dir_ordenacion','asc');

        if($this->objParam->getParametro('nombre')!=''){
            $this->objParam->addFiltro("vf.desc_funcionario1 ilike ''%".$this->objParam->getParametro('nombre')."%'' ");
        }

        //crea el objetoFunSeguridad que contiene todos los metodos del sistema de seguridad
        if ($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte=new Reporte($this->objParam, $this);
            $this->res=$this->objReporte->generarReporteListado('MODBoleta','listarPersona');
        }
        else {
            $this->objFunSeguridad = $this->create('MODBoleta');
            //ejecuta el metodo de lista personas a travez de la intefaz objetoFunSeguridad
            $this->res=$this->objFunSeguridad->listarPersona();

        }
        //imprime respuesta en formato JSON para enviar lo a la interface (vista)
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function listarOtorgante(){

        $this->objParam->defecto('ordenacion','otorgante');
        $this->objParam->defecto('dir_ordenacion','asc');

        if($this->objParam->getParametro('otorgante')!=''){
            $this->objParam->addFiltro("bb.otorgante::varchar ilike ''%".$this->objParam->getParametro('otorgante')."%'' ");
        }

        //crea el objetoFunSeguridad que contiene todos los metodos del sistema de seguridad
        if ($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte=new Reporte($this->objParam, $this);
            $this->res=$this->objReporte->generarReporteListado('MODBoleta','listarOtorgante');
        }
        else {
            $this->objFunSeguridad = $this->create('MODBoleta');
            //ejecuta el metodo de lista personas a travez de la intefaz objetoFunSeguridad
            $this->res=$this->objFunSeguridad->listarOtorgante();

        }
        //imprime respuesta en formato JSON para enviar lo a la interface (vista)
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                
    function insertarBoleta(){
        $this->objFunc=$this->create('MODBoleta');    
        if($this->objParam->insertar('idboleta')){
            $this->res=$this->objFunc->insertarBoleta($this->objParam);            
        } else{            
            $this->res=$this->objFunc->modificarBoleta($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                        
    function eliminarBoleta(){
        	$this->objFunc=$this->create('MODBoleta');    
        $this->res=$this->objFunc->eliminarBoleta($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
            
}

?>