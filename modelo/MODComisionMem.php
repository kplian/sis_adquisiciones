<?php
/**
 *@package pXP
 *@file gen-MODMotivoAnulado.php
 *@author  (admin)
 *@date 12-10-2016 19:36:54
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */

class MODComisionMem extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarComision(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='adq.ft_comision_sel';
        $this->transaccion='ADQ_COM_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_integrante','int4');
        $this->captura('id_funcionario','int4');
        $this->captura('orden','numeric');
        $this->captura('estado_reg','varchar');
        $this->captura('fecha_reg','timestamp');
        $this->captura('usuario_ai','varchar');
        $this->captura('id_usuario_reg','int4');
        $this->captura('id_usuario_ai','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('id_usuario_mod','int4');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
        $this->captura('desc_funcionario1','varchar');


        //Ejecuta la instruccion
        $this->armarConsulta();
        //var_dump($this->consulta);exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function insertarComision(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.ft_comision_ime';
        $this->transaccion='ADQ_COM_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('orden','orden','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarComision(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.ft_comision_ime';
        $this->transaccion='ADQ_COM_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_integrante','id_integrante','int4');
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('orden','orden','numeric');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarComision(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.ft_comision_ime';
        $this->transaccion='ADQ_COM_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_integrante','id_integrante','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

}
?>