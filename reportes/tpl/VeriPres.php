<table border="1">
<tbody>
	
	<tr >		
		<td height="40px" colspan="8" style="text-align: left; vertical-align: middle;">
			<img align="left" style="width: 75px;" src="./../../../lib/<?php echo $_SESSION['_DIR_LOGO'];?>" alt="Logo">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<strong>
				<font size="12">VERIFICACION DE DISPONIBILIDAD PRESUPUESTARIA</font>
			</strong>
			<br />
		</td>
	</tr>
	
	<tr>
		<td colspan="8" valign="center"  style="background-color: #87B4F4; vertical-align: middle;">
			<font size="10"><strong>1) DETALLES GENERALES (Responsable de llenado : Area solicitante)</strong></font>
		</td>		
	</tr>
		
	<tr style="text-align: center; vertical-align: middle;">
		
		<td colspan="1" ><font size="8"><strong><br />  SOLICITUD DE PEDIDO <BR/>(LIBERADO)</strong></font></td>
		<td colspan="1" ><font size="8"><br /> <?php echo $this->cabecera[0]['num_tramite'];?>   </font></td>
		<td colspan="1" ><font size="8"><strong><br />DESCRIPCION INVITACION <BR/>SOL. PEDIDO</strong></font></td>
		<td colspan="3"><font size="8"><br />&nbsp;<?php  echo $this->cabecera[0]['justificacion']; ?></font></td>
		<td colspan="1" ><strong><font size="8"> COSTO ESTIMADO (BS).<BR/> SOL. PEDIDO <br /> (LIBERADA)</strong></font></td>
		<td colspan="1" ><font size="8"><br /><?php echo number_format(($this->datos['v_precio_sg_mb']+$this->datos['v_precio_ga_mb']),2);?></font></td>
	</tr>
		
	<tr style="text-align: center; vertical-align: top;">
		<td colspan="1"><strong><font size="7">IMPUTACION <BR/>(CECO/ORDEN/PEP)</font></strong></td>
		<td colspan="1"><font size="8"><br /><?php  echo $this->cabecera[0]['codigo']; ?> </font></td>
		<td colspan="2"><strong> <font size="8">DENOMINACION DE LA IMPUTACION</font></strong></td>
		<td colspan="4"><font size="8"><br /><?php  echo $this->cabecera[0]['descripcion']; ?></font></td>
		
	</tr>
	
	<tr>
		<td colspan="8" style="background-color: #87B4F4; vertical-align: middle;"><h5>1.1 PROGRAMACION DE PAGOS DE INVERSION ESTIMADA (B)</h5></td>		
	</tr>
	
	<tr style="text-align: center; vertical-align: middle;">
		<td colspan="2"><strong><font size="8">DESCRIPCION</font></strong></td>
		<td colspan="2"><strong><font size="8">GESTION <?php  echo $this->cabecera[0]['gestion']; ?></font></strong></td>
		<td colspan="2"><strong><font size="8">GESTION <?php  echo $this->cabecera[0]['gestion']+1; ?></font></strong></td>
		<td colspan="2"><strong><font size="8">GESTION <?php  echo $this->cabecera[0]['gestion']+2; ?></font></strong></td>		
	</tr>
	
	<tr style="text-align: center; vertical-align: middle;">
		<td colspan="2"><strong><font size="8">MONTO REQUERIDO</font></strong></td>
		<td colspan="2"><strong><font size="8"><?php echo number_format($this->datos['v_precio_ga_mb'],2);?> </font></strong></td>
		<td colspan="2"><strong><font size="8"><?php echo number_format($this->datos['v_precio_sg_mb'],2);?> </font></strong></td>		
		<td colspan="2"><strong><font size="8"></font></strong></td>		
	</tr>
	
	<tr style="text-align: center; vertical-align: middle;">
		<td colspan="2"><strong><font size="8">CONCEPTO</font></strong></td>
		<td colspan="2"><strong><font size="8"></font></strong></td>
		<td colspan="2"><strong><font size="8"></font></strong></td>
		<td colspan="2"><strong><font size="8"></font></strong></td>		
	</tr>
	<tr>
		<td colspan="8">
			<font size="6">   NOTA:<br />*Es responsabilidad del Area Solicitante, presupuestar en cada gestion, los montos programados para las gestiones posteriores al año en curso. 
			</font> 
		</td>			
	</tr>
	
	<tr>
		<td colspan="8" valign="center" style="background-color: #87B4F4; vertical-align: middle;"><font size="10"><strong>2) DETALLE FINANCIERO (Responsable de llenado: Finanzas)</strong></font></td>		
	</tr>	
	<tr style="text-align: center; vertical-align: middle;">
		<td colspan="1"><strong><font size="8"><br/> PRESUPUESTO VIGENTE GESTION <?php  echo $this->cabecera[0]['gestion']; ?><br /> <br/></font></strong></td>	
		<td colspan="1"><strong><font size="8"><br/><br/><br/> <?php echo number_format($this->datos['v_saldo_vigente_mb'],2);?> </font></strong></td>	
		<td colspan="1"><strong><font size="8"><br/>PRESUPUESTO COMPROMETIDO GESTION <?php  echo $this->cabecera[0]['gestion']; ?><br /> <br/></font></strong></td>	
		<td colspan="1"><strong><font size="8"><br/><br/><br/> <?php echo number_format($this->datos['v_saldo_comp_mb'],2);?></font></strong></td>	
		<td colspan="1"><strong><font size="8"><br/>SOLICITADO CON CARGO AL PRESUPUESTO GESTION <?php  echo $this->cabecera[0]['gestion']; ?><br /> <br/></font></strong></td>	
		<td colspan="1"><strong><font size="8"><br/><br/><br/> <?php echo number_format($this->datos['v_precio_ga_mb'],2);?></font></strong></td>	
		<td colspan="1"><strong><font size="8"><br/>PRESUPUESTO DISPONIBLE IMPUTACION GESTION  <?php  echo $this->cabecera[0]['gestion']; ?><br /> <br/></font></strong></td>	
		<td colspan="1"><strong><font size="8"><br/><br/><br/> <?php echo number_format($this->datos['v_total_disponble'],2);?></font></strong></td>	
	</tr>
	
	<tr>
		<td colspan="8" style="background-color: #87B4F4; vertical-align: middle;"><font size="10"><strong> 2.1 VERIFICACION PRESUPUESTARIA GESTION <?php  echo $this->cabecera[0]['gestion']; ?></strong></font></td>		
	</tr>
	
	<tr style="text-align: center; vertical-align: middle;">
		<td colspan="2"><strong><font size="8"><br/>DISPONIBILIDAD<br/>PRESUPUESTARIA<br/>EN ORDEN/ELEMENTO PEP<br/></font></strong></td>
		<td rowspan="2" colspan="1">
			<strong><font size="8"><br/>SI</font>
				<font size="7">
					<br/><?php if(number_format($this->datos['v_total_disponble'],2)>0){  echo 'FECHA IMPRESION'; }?>		
					<br/> <?php if(number_format($this->datos['v_total_disponble'],2)>0){  echo date("d-m-Y H:m", strtotime($this->datos['v_fecha_comp'])); }?>					
				</font>
			</strong>
		</td>
		<td colspan="1"><strong><font size="18"><br/><?php if(number_format($this->datos['v_total_disponble'],2)>0){  echo 'X'; }?></font><br/></strong></td>
		
		
		<td rowspan="2" colspan="1">
			<strong><font size="8"><br/>NO</font>
				<font size="7">
					<br/><?php if(number_format($this->datos['v_total_disponble'],2)<0){  echo 'FECHA IMPRESION'; }?>	
					<br/> <?php if(number_format($this->datos['v_total_disponble'],2)<0){  echo date("d-m-Y H:m", strtotime($this->datos['v_fecha_comp'])); }?>				
				</font>
			</strong>
		</td>
		<td colspan="1"><strong><font size="18"><br/><?php if(number_format($this->datos['v_total_disponble'],2)<0){  echo 'X'; }?></font><br/></strong></td>
	</tr>

</tbody>
</table>