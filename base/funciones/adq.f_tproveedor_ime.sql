CREATE OR REPLACE FUNCTION adq.f_tproveedor_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.f_tproveedor_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'adq.tdocumento_sol'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        01-03-2013 19:01:00
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_proveedor			integer;
    cadena_con				varchar;
    v_res_cone				varchar;
    v_consulta				varchar;
    
    resp text;
    v_id_persona 			int4;
    v_id_institucion		int4;
    v_registro				record;			    
BEGIN

    v_nombre_funcion = 'adq.f_proveedor_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_PROVEE_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		01-03-2013 19:01:00
	***********************************/

	if(p_transaccion='ADQ_PROVEE_INS')then
					
        begin
        	cadena_con = migra.f_obtener_cadena_con_dblink();
             v_res_cone=( select dblink_connect(cadena_con));
			raise notice 'cadena con %',cadena_con;
            if v_parametros.register='no_registered' then
            	begin
					if v_parametros.tipo='persona natural' then
                    v_consulta:='
                    insert into sss.tsg_persona(
                    nombre,
                    apellido_paterno,
                    apellido_materno,
                    doc_id,
                    email1,
                    celular1,
                    celular2,
                    telefono1,
                    telefono2,
                    genero,
                    id_tipo_doc_identificacion,
                    fecha_nacimiento,
                    direccion
                    ) values('''
                    ||COALESCE(v_parametros.nombre::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.apellido_paterno::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.apellido_materno::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.ci::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.correo::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.celular1::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.celular2::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.telefono1::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.telefono2::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.genero::varchar,'NULL')||''','''
                    ||COALESCE('1'::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.fecha_nacimiento::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.direccion::varchar,'NULL')||'''
                    )';
                    PERFORM * from dblink_exec(cadena_con,v_consulta);                                        
                    v_consulta:='select per.id_persona from sss.tsg_persona per where per.nombre='''||
                    v_parametros.nombre::varchar||''' and per.apellido_paterno='''||v_parametros.apellido_paterno::varchar||
                    ''' and per.apellido_materno='''||v_parametros.apellido_materno::varchar||'''';
            
                    select * into v_id_persona from dblink(cadena_con,v_consulta) as ( v_id_persona varchar); 
            
                    v_consulta:='
                    insert into compro.tad_proveedor(
                    id_institucion,
                    id_persona,
                    codigo,
                    id_lugar
                    ) values('
                    ||COALESCE(v_parametros.id_institucion::varchar,'NULL')||','
                    ||COALESCE(v_id_persona::varchar,'NULL')||','''
                    ||COALESCE(v_parametros.codigo::varchar,'NULL')||''','
                    ||COALESCE(v_parametros.id_lugar::varchar,'NULL')||'
                    )';                    
                    resp =  dblink_exec(cadena_con,v_consulta);
                                
                    elsif v_parametros.tipo='persona juridica' then
                    v_consulta:='
                    insert into param.tpm_institucion(
                    doc_id,
                    nombre,
                    casilla,
                    telefono1,
                    telefono2,
                    direccion,
                    celular1,
                    celular2,
                    fax,
                    email1,
                    email2,
                    pag_web,
                    observaciones,
                    codigo_banco,
                    id_tipo_doc_institucion,
                    codigo
                    ) values('''
                    ||COALESCE(v_parametros.doc_id::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.nombre_institucion::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.casilla::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.telefono1_institucion::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.telefono2_institucion::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.direccion_institucion::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.celular1_institucion::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.celular2_institucion::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.fax::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.email1_institucion::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.email2_institucion::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.pag_web::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.observaciones::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.codigo_banco::varchar,'NULL')||''','''
                    ||COALESCE('1'::varchar,'NULL')||''','''
                    ||COALESCE(v_parametros.codigo::varchar,'NULL')||'''
                    )';
                    PERFORM * from dblink_exec(cadena_con,v_consulta);                                        
                    v_consulta:='select inst.id_institucion from param.tpm_institucion inst where inst.nombre='''||
                    v_parametros.nombre_institucion::varchar||''' and inst.doc_id='''||v_parametros.doc_id::varchar||
                    ''' and inst.codigo='''||v_parametros.codigo::varchar||'''';
            
                    select * into v_id_institucion from dblink(cadena_con,v_consulta) as ( v_id_institucion varchar); 
                    --resp =  dblink_exec(cadena_con,v_consulta);                    
            
                    v_consulta:='
                    insert into compro.tad_proveedor(
                    id_institucion,
                    id_persona,
                    codigo,
                    id_lugar
                    ) values('
                    ||COALESCE(v_id_institucion::varchar,'NULL')||','
                    ||COALESCE(v_parametros.id_persona::varchar,'NULL')||','''
                    ||COALESCE(v_parametros.codigo::varchar,'NULL')||''','
                    ||COALESCE(v_parametros.id_lugar::varchar,'NULL')||'
                    )';                    
                    resp =  dblink_exec(cadena_con,v_consulta);
                    
                    end if;
                end;
            elsif v_parametros.register='before_registered' then
			raise notice '%', 'entra a before';            	
        	--Sentencia de la insercion
            v_consulta:='
        	insert into compro.tad_proveedor(
			id_institucion,
			id_persona,
			codigo,
			id_lugar
          	) values('
            ||COALESCE(v_parametros.id_institucion::varchar,'NULL')||','
            ||COALESCE(v_parametros.id_persona::varchar,'NULL')||','''
            ||COALESCE(v_parametros.codigo::varchar,'NULL')||''','
            ||COALESCE(v_parametros.id_lugar::varchar,'NULL')||'
			)';
            
            resp =  dblink_exec(cadena_con,v_consulta);
            
			raise notice 'resp %', resp;
            end if;
            
            v_consulta:='select migracion.f_sincronizacion()';
            raise notice 'antes sincronizacion %',v_consulta;            
            select * into v_registro from dblink(cadena_con,v_consulta) as t1(proname boolean);
            raise notice 'despues sincronizacion %',v_consulta;            
--			resp = dblink(cadena_con,v_consulta);
            
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Proveedor almacenado(a) con exito');
            --if v_parametros.id_persona is null then v_parametros.id_persona else v_parametros.id_institucion end if||')'); 
            --v_resp = pxp.f_agrega_clave(v_resp,'id_proveedor',v_id_proveedor::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_PROVEE_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		01-03-2013 19:01:00
	***********************************/

	elsif(p_transaccion='ADQ_PROVEE_MOD')then
		cadena_con = migra.f_obtener_cadena_con_dblink();
        v_res_cone=( select dblink_connect(cadena_con));
        raise notice '%',v_res_cone;
		begin
			--Sentencia de la modificacion
            v_consulta:='update compro.tad_proveedor set
			id_persona ='||COALESCE(v_parametros.id_persona::varchar,'NULL')||',
            id_institucion ='||COALESCE(v_parametros.id_institucion::varchar,'NULL')||',
            codigo ='''||COALESCE(v_parametros.codigo::varchar,'NULL')||''',
            id_lugar ='''||COALESCE(v_parametros.id_lugar::varchar,'NULL')||'''
            where id_proveedor='||v_parametros.id_proveedor||'';
            raise notice 'prov %',v_consulta;            
            resp =  dblink_exec(cadena_con,v_consulta);
            if v_parametros.tipo='persona natural' then
            	v_consulta:='update sss.tsg_persona set 
                doc_id ='''||v_parametros.nit||'''               
                where id_persona='''||v_parametros.id_persona||'';

                resp =  dblink_exec(cadena_con,v_consulta);
			end if;
			if v_parametros.tipo='persona juridica' then
            	v_consulta:='update param.tpm_institucion set                
                doc_id ='''||v_parametros.nit||'''
                where id_persona='||v_parametros.id_institucion||'';           

                resp =  dblink_exec(cadena_con,v_consulta);
            end if;
            
            update param.tproveedor set
            numero_sigma = v_parametros.numero_sigma,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()
			where id_proveedor=v_parametros.id_proveedor;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Proveedor modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proveedor',v_parametros.id_proveedor::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_PROVEE_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		08-02-2013 19:01:00
	***********************************/

	elsif(p_transaccion='ADQ_PROVEE_ELI')then

		begin
			--Sentencia de la eliminacion
            
			delete from param.tproveedor
            where id_proveedor=v_parametros.id_proveedor;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Proveedor eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proveedor',v_parametros.id_proveedor::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
         
	else
     
    	raise exception 'Transaccion inexistente: %',p_transaccion;

	end if;

EXCEPTION
				
	WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
		raise exception '%',v_resp;
				        
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;