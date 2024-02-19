--@Autor: Alonso Lopez Daniel
--		  Marcelino Cisneros Eduardo
--@Fecha creación: 04/12/2019
--@Descripción: carga inicial para tabla de proyecto
--				se hace uso de secuencias para los id's

prompt Conectando usuario admin y realizando carga inicial
connect am_proy_admin/daniel;
prompt Realizando carga inicial para centro_operaciones

set serveroutput on
-- declaracion de variables
declare
v_seq_centro_operaciones number(10,0);
v_seq_empleado number(10,0);
v_clave 	varchar2(6);
v_direccion varchar2(60);
type lista_direccion is table of varchar2(100);
v_lista_direccion lista_direccion;
v_num_telefono number(15,0);
v_es_farmacia number(1,0);
v_es_almacen number(1,0);
v_es_oficina number(1,0);
type lista_nombre is table of varchar2(200);
v_lista_nombre lista_nombre;
type lista_apellido is table of varchar2(200);
v_lista_apellido lista_apellido;
v_nombre varchar2(100);
v_ap_paterno varchar2(100);
v_ap_materno varchar2(100);
v_rfc varchar2(100);
v_fecha_ingreso varchar2(100);

begin 
	--lista de nombres de calles para direccion
	v_lista_direccion := lista_direccion('Maple','Center','Sherman','Moland','Hill','Park','Acker','Washington','Central','Plaza');
	v_lista_nombre := lista_nombre('Daniel','William','George','Edward','Bruce','Alex','Max','Mickey','Jhonny','Paul');
	v_lista_apellido := lista_apellido('Champness','Beedham','McKyrrelly','Sedwick','Titmus','Derisley','Rean','Selvey','Lennon','McCartney','Harrison','Lukas');

	for i in 1..10 loop

		--itera la secuencia de centro_operaciones
		select seq_centro_operaciones.nextval into v_seq_centro_operaciones from dual;

		--obtiene aleatoriamente valores de clave
		v_clave:=dbms_random.string('U',2)||'-'||trunc(dbms_random.value(100,1001));

		--obtiene aleatoriamente valores de direccion de acuerdo a la lista de calles
		v_direccion:=trunc(dbms_random.value(1,1001))||' '||v_lista_direccion(trunc(dbms_random.value(1,11)))||' '||
			v_lista_direccion(trunc(dbms_random.value(1,11)));

		--obtiene un numero telefonico aleatorio
		v_num_telefono:=dbms_random.value(1000000001,10000000001);

		--obtiene aleatoriamente valores para es_farmacia, es_almacen y es_oficina
		v_es_farmacia:=dbms_random.value(0,1);
		v_es_almacen:=dbms_random.value(0,1);
		v_es_oficina:=dbms_random.value(0,1);

		--valida que no viole el constraint del tipo de centro de operaciones
		if v_es_farmacia=1 and v_es_almacen=1 then
			v_es_oficina:=0;
		elsif v_es_oficina = 1 then
			v_es_almacen:=0;
			v_es_farmacia:=0;
		elsif v_es_farmacia=1 and v_es_almacen=0 then
			v_es_oficina:=0;
		elsif v_es_farmacia=0 and v_es_almacen=1 then
			v_es_oficina:=0;
		elsif v_es_farmacia=1 and v_es_oficina=1 then
			v_es_oficina:=0;
		elsif v_es_almacen=1 and v_es_oficina=1 then
			v_es_oficina:=0;
		elsif v_es_farmacia=0 and v_es_oficina=0 and v_es_almacen=0 then
			v_es_farmacia:=1;
		end if;

		--se inserta un registro aleatorio por cada iteracion
		insert into centro_operaciones (centro_operaciones_id, clave, direccion, num_telefonico, es_farmacia, es_almacen, es_oficina) 
			values(v_seq_centro_operaciones, v_clave, v_direccion,v_num_telefono,v_es_farmacia,v_es_almacen,v_es_oficina);

		commit;

		select seq_empleado.nextval into v_seq_empleado from dual;

		v_nombre := v_lista_nombre(trunc(dbms_random.value(1,11)));
		v_ap_paterno := v_lista_apellido(trunc(dbms_random.value(1,12)));
		v_ap_materno := v_lista_apellido(trunc(dbms_random.value(1,12)));
		v_rfc := dbms_random.string('U',4)||trunc(dbms_random.value(1000001,1999999))||dbms_random.string('U',1)||trunc(dbms_random.value(1,9));
		v_fecha_ingreso := trunc(dbms_random.value(1,27))||'/'||trunc(dbms_random.value(1,10))||'/'||trunc(dbms_random.value(2001,2018));

		--falta modificar y asignar aleatoriamente
		--los centros de operaciones_id
		--debe ser en otro ciclo for para que ya se tengan los registros de centro_operaciones_id
		--sugerencia: hacer en bloques anonimos cada insercion de cada tabla

		insert into empleado(empleado_id,nombre,ap_paterno,ap_materno,rfc,fecha_ingreso,centro_operaciones_id)
			values(v_seq_empleado,v_nombre,v_ap_paterno,v_ap_materno,v_rfc,to_date(v_fecha_ingreso,'dd/mm/yyyy'),1);


	end loop;

	commit;
end;
/

prompt Carga inicial para centro_operaciones finalizada
