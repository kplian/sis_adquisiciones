<?php
/****************************************************************************************
*@package pXP
*@file MODBoleta.php
*@author  (egutierrez)
*@date 25-03-2021 13:42:09
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas

 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR                DESCRIPCION
  #0                25-03-2021 13:42:09    egutierrez             Creacion    
  #
*****************************************************************************************/

class MODBoleta extends MODbase{
    
    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }
            
    function listarBoleta(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='adq.ft_boleta_sel';
        $this->transaccion='ADQ_BOLG_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
                
        //Definicion de la lista del resultado del query
		$this->captura('idboleta','int4');
        $this->captura('nrodoc','varchar');
        $this->captura('tipodocumento','varchar');
        $this->captura('otorgante','varchar');
        $this->captura('diasrestantes','int4');
        $this->captura('fechainicio','date');
        $this->captura('fechafin','date');
        $this->captura('estado','int4');
        $this->captura('desc_estado','varchar');
        //$this->captura('correo','varchar');
        $this->captura('fechaaccion','date');
        $this->captura('paragarantizar','varchar');
        $this->captura('Cd_empleado_gestor','varchar');
        $this->captura('gestor','varchar');
        $this->captura('codresponsable','varchar');
        $this->captura('responsable','varchar');
        
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        
        //Devuelve la respuesta
        return $this->respuesta;
    }

    function listarPersona(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.ft_boleta_sel';
        $this->transaccion='ADQ_PERSON_SEL';
        $this->tipo_procedimiento='SEL';

        $this->captura('id_persona','integer');
		$this->captura('nom','varchar');
        $this->captura('nombre','varchar');

        //Ejecuta la funcion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        return $this->respuesta;

    }
	
	function listarResponsable(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.ft_boleta_sel';
        $this->transaccion='ADQ_PERRES_SEL';
        $this->tipo_procedimiento='SEL';
		//$this->setCount(false);

        $this->captura('id_persona','integer');
        $this->captura('nombre','varchar');

        //Ejecuta la funcion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        return $this->respuesta;

    }

    function listarOtorgante(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.ft_boleta_sel';// nombre procedimiento almacenado
        $this->transaccion='ADQ_BOTOR_SEL';//nombre de la transaccion
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        //$this->setCount(false);

        //Define los parametros para la funcion
        $this->setParametro('tipo_relacion','tipo_relacion','varchar');
        $this->setParametro('id_persona','id_persona','varchar');

        $this->captura('otorgante','varchar');

        //Ejecuta la funcion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        return $this->respuesta;

    }
            
    function insertarBoleta(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.ft_boleta_ime';
        $this->transaccion='ADQ_BOLG_INS';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('idtipo','idtipo','int4');
		$this->setParametro('idtipodoc','idtipodoc','int4');
		$this->setParametro('nrodoc','nrodoc','varchar');
		$this->setParametro('otorgante','otorgante','varchar');
		$this->setParametro('monto','monto','numeric');
		$this->setParametro('montomoneda','montomoneda','int4');
		$this->setParametro('acuentade','acuentade','varchar');
		$this->setParametro('idgerencia','idgerencia','int4');
		$this->setParametro('codresponsable','codresponsable','varchar');
		$this->setParametro('responsable','responsable','varchar');
		$this->setParametro('paragarantizar','paragarantizar','varchar');
		$this->setParametro('fechaaccion','fechaaccion','date');
		$this->setParametro('fechainicio','fechainicio','timestamp');
		$this->setParametro('fechafin','fechafin','timestamp');
		$this->setParametro('observaciones','observaciones','varchar');
		$this->setParametro('estado','estado','int4');
		$this->setParametro('beneficiario','beneficiario','varchar');
		$this->setParametro('idgarantizar','idgarantizar','int4');
		$this->setParametro('idinvitacion','idinvitacion','int4');
		$this->setParametro('idproyecto','idproyecto','int4');
		$this->setParametro('diasrestantes','diasrestantes','int4');
		$this->setParametro('correo','correo','varchar');
		$this->setParametro('tipodocumento','tipodocumento','varchar');
		$this->setParametro('gestor','gestor','varchar');
		$this->setParametro('cd_empleado_gestor','cd_empleado_gestor','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function modificarBoleta(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.ft_boleta_ime';
        $this->transaccion='ADQ_BOLG_MOD';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('idboleta','idboleta','int4');
		$this->setParametro('idtipo','idtipo','int4');
		$this->setParametro('idtipodoc','idtipodoc','int4');
		$this->setParametro('nrodoc','nrodoc','varchar');
		$this->setParametro('otorgante','otorgante','varchar');
		$this->setParametro('monto','monto','numeric');
		$this->setParametro('montomoneda','montomoneda','int4');
		$this->setParametro('acuentade','acuentade','varchar');
		$this->setParametro('idgerencia','idgerencia','int4');
		$this->setParametro('codresponsable','codresponsable','varchar');
		$this->setParametro('responsable','responsable','varchar');
		$this->setParametro('paragarantizar','paragarantizar','varchar');
		$this->setParametro('fechaaccion','fechaaccion','date');
		$this->setParametro('fechainicio','fechainicio','timestamp');
		$this->setParametro('fechafin','fechafin','timestamp');
		$this->setParametro('observaciones','observaciones','varchar');
		$this->setParametro('estado','estado','int4');
		$this->setParametro('beneficiario','beneficiario','varchar');
		$this->setParametro('idgarantizar','idgarantizar','int4');
		$this->setParametro('idinvitacion','idinvitacion','int4');
		$this->setParametro('idproyecto','idproyecto','int4');
		$this->setParametro('diasrestantes','diasrestantes','int4');
		$this->setParametro('correo','correo','varchar');
		$this->setParametro('tipodocumento','tipodocumento','varchar');
		$this->setParametro('gestor','gestor','varchar');
		$this->setParametro('cd_empleado_gestor','cd_empleado_gestor','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function eliminarBoleta(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.ft_boleta_ime';
        $this->transaccion='ADQ_BOLG_ELI';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('idboleta','idboleta','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
}
?>