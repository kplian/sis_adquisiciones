<?php
/**
*@package pXP
*@file ProveedorAdq.php
*@author  (admin)
*@date 07-03-2019 13:53:18
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ProveedorAdq={
	require:'../../../sis_parametros/vista/proveedor/Proveedor.php',
	requireclase:'Phx.vista.proveedor',
	title:'Proveedor Adq',
	nombreVista: 'ProveedorAdq',
	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.ProveedorAdq.superclass.constructor.call(this,config);
        this.getBoton('estadoProveedor').hide();
        this.init();
		this.load({params:{start:0, limit:this.tam_pag , nombreVista:this.nombreVista }});
	},
	preparaMenu:function(n){
      var data = this.getSelectedData();
      var tb =this.tbar;
        Phx.vista.ProveedorAdq.superclass.preparaMenu.call(this,n);
         return tb 
     }, 
     liberaMenu:function(){
        var tb = Phx.vista.ProveedorAdq.superclass.liberaMenu.call(this);
        if(tb){

        }
       return tb
    },
    tabeast:undefined,
    bedit:false,
    bnew:false,
    bdel:false,

	}
</script>
		
		