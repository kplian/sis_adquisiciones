<?php
/**
*@package pXP
*@file    SolReporteEje.php
*@author  Rensi Arteaga Copari 
*@date    30-01-2014
*@description permites subir archivos a la tabla de documento_sol
*/
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
Phx.vista.SolReporteEje=Ext.extend(Phx.frmInterfaz,{
    ActSave:'../../sis_adquisiciones/control/Solicitud/SolicitarPresupuesto',

    constructor:function(config)
    {   
        Phx.vista.SolReporteEje.superclass.constructor.call(this,config);
        this.init();    
        this.loadValoresIniciales();
        
        this.Cmp.id_gestion.on('select', function(cmp){
        	this.Cmp.id_centro_costo.reset();
        	this.Cmp.id_centro_costo.store.baseParams.id_gestion  = cmp.getValue();
        	this.Cmp.id_centro_costo.modificado = true;
        	this.Cmp.id_partida.reset();
        	this.Cmp.id_partida.store.baseParams.id_gestion = cmp.getValue();
        	this.Cmp.id_partida.modificado = true;
        	
        },this);
        
    },
    
    
  
    
    loadValoresIniciales:function() 
    {        
        
        Phx.vista.SolReporteEje.superclass.loadValoresIniciales.call(this);
        
        
        
    },
    
    successSave:function(resp)
    {
        Phx.CP.loadingHide();
        Phx.CP.getPagina(this.idContenedorPadre).reload();
        this.panel.close();
    },
                
    
    Atributos:[
         {
            config:{
                    name:'id_gestion',
                    origen:'GESTION',
                    fieldLabel: 'Gestión',
                    emptyText : 'Gestión',
                    allowBlank:false
                },
            type:'ComboRec',
            id_grupo:0,
            form:true
        },
    
   		 {
            config:{
                    name:'id_centro_costo',
                    origen:'CENTROCOSTO',
                    fieldLabel: 'Centro de Costos',
                    emptyText : 'Centro Costo...',
                    allowBlank:false,
                    baseParams:{filtrar:'grupo_ep', _adicionar:'Todos'},
                    tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>{codigo_cc}</b></p><p>Gestion: {gestion}</p><p>Reg: {nombre_regional}</p><p>Fin.: {nombre_financiador}</p><p>Proy.: {nombre_programa}</p><p>Act.: {nombre_actividad}</p><p>UO: {nombre_uo}</p></div></tpl>'  				
		    		
                },
            type:'ComboRec',
            id_grupo:0,
            form:true
        },
	   	{
   			config:{
   				sysorigen:'sis_presupuestos',
       		    name:'id_partida',
   				origen:'PARTIDA',
   				allowBlank:false,
   				fieldLabel:'Partida',
   				width: 350,
   				listWidth: 350,
   				baseParams:{ _adicionar: 'Todos' },
	   			renderer:function (value, p, record){return String.format('{0}',record.data['desc_partida']);}
       	     },
   			type:'ComboRec',
   			id_grupo: 0,
   			form:true
	   	},
           
       {
            config:{
                name:'id_moneda',
                origen:'MONEDA',
                 allowBlank:false,
                fieldLabel:'Moneda'
              },
            type:'ComboRec',
            form:true
       }
        
   ],
    title: 'Reporte de ejeucuión presupeustaria por tramite',
    topBar : true,
	botones : false,
	labelSubmit : 'Generar',
	tooltipSubmit : '<b>Generar Reporte ejeucuión presupeustaria</b>',
	tipo : 'reporte',
	clsSubmit : 'bprint',
    onSubmit: function(){
    	    var me = this;
			if (me.form.getForm().isValid()) {
				var arg =  'id_presupuesto=' + me.Cmp.id_centro_costo.getValue();
				arg = arg + "&id_partida=" + me.Cmp.id_partida.getValue();
				arg = arg + "&id_moneda=" + me.Cmp.id_moneda.getValue();
				arg = arg + "&id_usuario=" + Phx.CP.config_ini.id_usuario;
				
				window.open('http://sms.obairlines.bo/ReporteERP/Presto/DetalleEjecucionPartida?'+arg, '_blank');
				
				
				
			}
		}
   
})    
</script>