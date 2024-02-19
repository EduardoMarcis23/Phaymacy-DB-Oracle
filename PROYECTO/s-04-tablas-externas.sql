--@Autor: Alonso Lopez Daniel
--		  Marcelino Cisneros Eduardo
--@Fecha creación: 08/12/2019
--@Descripción: Creación de tablas externas del caso de studio: Pharmacy Online

--Se requiere hacer uso del usuario SYS para crear un objeto tipo
--directory y otorgar privilegios.
prompt Conectando como sys
connect sys/Dan02061997 as sysdba

--tmp_dir es un objeto que apunta al directorio /tmp/bases del servidor
prompt creando directorio tmp_dir
create or replace directory tmp_dir as '/tmp/bases';

--se otorgan permisos para que el usuario am_proy_admin pueda leer el contenido del directorio
grant read, write on directory tmp_dir to am_proy_admin;

prompt Contectando con usuario am_proy_admin para crear la tabla externa
connect am_proy_admin/daniel
show user
prompt creando tabla externa

--Suponer que un distribuidor entrega a cada farmacia la lista de los medicamentos disponibles
create table medicamento_ext (
	num_medicamento number(10,0),
	nombre_medicamento varchar2(50),
	sustancia_activa varchar2(50),
	descripcion varchar2(40),		
	precio_unitario number(10,2)
) 
organization external (
	--En oracle existen 2 tipos de drivers para parsear el archivo:
	-- oracle_loader y oracle_datapump
	type oracle_loader
	default directory tmp_dir
	access parameters (
		records delimited by newline
		badfile tmp_dir:'medicamento_ext_bad.log'
		logfile tmp_dir:'medicamento_ext.log'
		fields terminated by ','
		lrtrim
		missing field values are null
		(
			num_medicamento, nombre_medicamento, sustancia_activa,
			descripcion, precio_unitario
		)
	)
	location ('medicamento_ext.txt')
)
reject limit unlimited;

prompt creando el directorio /tmp/bases en caso de no existir
!mkdir -p /tmp/bases
prompt cambiando permisos
!chmod 777 /tmp/bases
-- Asegurarse que el archivo se encuentra en el mismo
-- directorio donde se está ejecutando este script.
-- De lo contrario, el comando cp fallará.
prompt copiando el archivo txt a /tmp/bases
!cp medicamento_ext.txt /tmp/bases

col num_medicamento format a10
col nombre_medicamento format a15
col sustancia_activa format a15
col descripcion format a15
col precio_unitario format a15

select * from medicamento_ext;