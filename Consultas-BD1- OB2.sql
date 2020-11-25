create database Pruebasobl2020_25_11
use Pruebasobl2020_25_11
set dateformat dmy;

CREATE TABLE CIUDAD( 
	codigo_ciudad INT NOT NULL,
	nombre_ciudad VARCHAR(50) NOT NULL,
	CONSTRAINT CIUDAD_PK PRIMARY KEY (Codigo_Ciudad),
	)

CREATE TABLE CENTRO( 
	codigo_centro INT NOT NULL,
	nombre_centro VARCHAR (50) NOT NULL,
	cantidad_camas INT NOT NULL,
	codigo_ciudad INT NOT NULL,
	CONSTRAINT CENTRO_PK PRIMARY KEY (codigo_centro),
	CONSTRAINT CENTRO_CIUDAD_FK FOREIGN KEY(codigo_ciudad) REFERENCES CIUDAD(codigo_ciudad)
)

CREATE TABLE TELEFONO_CENTRO (
	codigo_centro INT NOT NULL,
	telefono INT NOT NULL,
	CONSTRAINT TELEFONO_CENTRO_PK PRIMARY KEY (codigo_centro, telefono),
	CONSTRAINT TELEFONO_CENTRO_FK FOREIGN KEY(codigo_centro) REFERENCES CENTRO(codigo_centro)
)


CREATE TABLE SALA(
	nro_sala INT NOT NULL,
	codigo_centro INT NOT NULL,
	CONSTRAINT SALA_PK PRIMARY KEY (nro_sala ,codigo_centro),
	CONSTRAINT SALA_CENTRO_FK FOREIGN KEY(codigo_centro) REFERENCES CENTRO(codigo_centro)
)

CREATE TABLE CAMA(
	nro_cama INT NOT NULL,
	codigo_centro INT NOT NULL,
	estado VARCHAR(1) NOT NULL CONSTRAINT estado_cama CHECK (estado IN ('L', 'O')),
	tiene_respirador  VARCHAR(2) NOT NULL CONSTRAINT tiene_respirador CHECK (tiene_respirador IN ('Si', 'No')),
	nro_sala INT NOT NULL,
	CONSTRAINT CAMA_PK PRIMARY KEY (nro_cama, nro_sala, codigo_centro),
	CONSTRAINT CAMA_SALA_FK FOREIGN KEY(nro_sala ,codigo_centro) REFERENCES SALA (nro_sala ,codigo_centro)
)


CREATE TABLE LABORATORIO(
	nro_registro INT NOT NULL,
	nombre VARCHAR (50) NOT NULL,
	CONSTRAINT LABORATORIO_PK PRIMARY KEY (nro_registro)
)

CREATE TABLE PERSONA( 
	cedula INT NOT NULL,
	codigo_interno INT UNIQUE, 
	nombre VARCHAR (50) NOT NULL,
	CONSTRAINT PERSONA_PK PRIMARY KEY (cedula)
)
CREATE TABLE MEDICO( 
	cedula_medico INT NOT NULL,
	CONSTRAINT MEDICO_PK PRIMARY KEY (cedula_medico),
	CONSTRAINT MEDICO_PERSONA_FK FOREIGN KEY (cedula_medico)REFERENCES PERSONA (cedula),
)

CREATE TABLE ENFERMERO( 
	cedula_enfermero INT NOT NULL,
	fech_ing date,
	lugar  VARCHAR(10) NOT NULL CONSTRAINT lugar_trabajo CHECK (lugar IN ('cti', 'planta')),
	CONSTRAINT ENFERMERO_PK PRIMARY KEY (cedula_enfermero),
	CONSTRAINT ENFERMERO_PERSONA_FK FOREIGN KEY (cedula_enfermero)REFERENCES PERSONA (cedula),
)

CREATE TABLE LIMPIEZA( 
	cedula_limpieza INT NOT NULL,
	exp_desechos  VARCHAR(2) NOT NULL CONSTRAINT experiencia CHECK (exp_desechos IN ('si', 'no')),
	CONSTRAINT LIMPIEZA_PK PRIMARY KEY (cedula_limpieza),
	CONSTRAINT LIMPIEZA_PERSONA_FK FOREIGN KEY (cedula_limpieza)REFERENCES PERSONA (cedula),
)

CREATE TABLE PACIENTE( 
	cedula INT NOT NULL,
	apellido VARCHAR (50) NOT NULL,
	fecha_nacimeinto DATE NOT NULL,
	sexo VARCHAR(1)NOT NULL CONSTRAINT sexo_paciente CHECK ( sexo IN ('F', 'M')),
	codigo_centro INT NOT NULL,
	CONSTRAINT PACIENTE_PK PRIMARY KEY (cedula),
	CONSTRAINT PACIENTE_PERSONA_FK FOREIGN KEY (cedula) REFERENCES PERSONA (cedula),
	CONSTRAINT PACIENTE_CENTRO_FK FOREIGN KEY (codigo_centro) REFERENCES CENTRO (codigo_centro),
)

CREATE TABLE TEST(
	cedula  INT NOT NULL,
	nro_registro INT NOT NULL,
	fecha_resultado DATE NOT NULL,
	resultado VARCHAR(10) CONSTRAINT resultado_posible CHECK (resultado IN ('positivo', 'negativo')),
	CONSTRAINT TEST_PK PRIMARY KEY (cedula, nro_registro,fecha_resultado,resultado),
	CONSTRAINT TEST_PERSONA_FK FOREIGN KEY (cedula) REFERENCES PERSONA (cedula),
	CONSTRAINT TEST_LABORATORIO_FK FOREIGN KEY (nro_registro) REFERENCES LABORATORIO (nro_registro),
)

CREATE TABLE ESTUVO(
	codigo_centro INT NOT NULL,
	cedula  INT NOT NULL,
	fecha DATE NOT NULL,
	CONSTRAINT ESTUVO_PK PRIMARY KEY (codigo_centro, cedula, fecha),
	CONSTRAINT ESTUVO_CENTRO_FK FOREIGN KEY (codigo_centro) REFERENCES CENTRO(codigo_centro),
	CONSTRAINT ESTUVO_PERSONA_FK FOREIGN KEY (cedula) REFERENCES PERSONA (cedula),
)
CREATE TABLE ESPECIALIDAD(
	codigo_esp INT NOT NULL,
	nombre_esp VARCHAR (50) NOT NULL,
	CONSTRAINT ESPECIALIDAD_PK PRIMARY KEY (codigo_esp)
)
CREATE TABLE EJERCE(
	cedula_medico INT NOT NULL, 
	codigo_esp INT NOT NULL,
	fecha_habilitacion DATE NOT NULL,
	CONSTRAINT EJERCE_PK PRIMARY KEY (cedula_medico, codigo_esp),
	CONSTRAINT EJERCE_MEDICO_FK FOREIGN KEY (cedula_medico) REFERENCES MEDICO (cedula_medico),
	CONSTRAINT EJERCE_ESPECIALIDAD_FK FOREIGN KEY (codigo_esp) REFERENCES ESPECIALIDAD (codigo_esp),
)
CREATE TABLE SE_ATIENDE(
	cedula INT NOT NULL,
	codigo_esp INT NOT NULL,
	cedula_medico INT NOT NULL,
	fecha_atencion DATE NOT NULL,
	codigo_centro INT NOT NULL,
	CONSTRAINT SE_ATIENDE_PK PRIMARY KEY (cedula,codigo_esp, cedula_medico,fecha_atencion),
	CONSTRAINT SE_ATIENDE_EJERCE_FK FOREIGN KEY (cedula_medico,codigo_esp) REFERENCES EJERCE (cedula_medico,codigo_esp),
	CONSTRAINT SE_ATIENDE_CENTRO_FK FOREIGN KEY (codigo_centro) REFERENCES CENTRO (codigo_centro),
	CONSTRAINT SE_ATIENDE_PACIENTE_FK FOREIGN KEY (cedula) REFERENCES PACIENTE(cedula)
)

CREATE TABLE INTERNADO (
	nro_cama INT NOT NULL,
	nro_sala INT NOT NULL,
	codigo_centro INT NOT NULL,
	cedula  INT NOT NULL,
	fecha_desde DATE NOT NULL,
	fecha_hasta DATE,
	CONSTRAINT INTERNADO_PK PRIMARY KEY (nro_cama,nro_sala,codigo_centro,cedula,fecha_desde),
	CONSTRAINT INTERNADO_CAMA_FK FOREIGN KEY (nro_cama, nro_sala, codigo_centro) REFERENCES CAMA (nro_cama, nro_sala, codigo_centro),
	CONSTRAINT INTERNADO_PACIENTE_FK FOREIGN KEY (cedula) REFERENCES PACIENTE(cedula)
)


-- CARGAR EL JUEGO DE PRUEBA QUE SE UTILIZARA PARA LA EJECUCION DE LAS CONSULTAS 


insert into CIUDAD(codigo_ciudad,nombre_ciudad)
values (1,'Montevideo'),(2,'Salto'),(3,'Colonia'),(4,'Rivera'),(5,'Canelones'),(6,'Rocha');


insert into CENTRO(codigo_centro,nombre_centro,cantidad_camas,codigo_ciudad)
values (1,'CASMU',12,2), (2,'Universal',11,1), (3,'Espanola',5,3),(4,'Espanola2',5,4);


insert into TELEFONO_CENTRO(codigo_centro,telefono)
values (1,099031110), (2,099035115), (3,099120145);



insert into SALA(nro_sala,codigo_centro)
values	(1,1) , (2,1) , (3,1),
		(1,2) , (2,2) , (3,2),
		(1,3) , (2,3) , (3,3),
		(1,4) , (2,4) , (3,4);

insert into CAMA(nro_cama,codigo_centro,estado,tiene_respirador,nro_sala)
values  --en centro 1 y sala 1 (camas de la 1 a 12)
		(1,1,'L','Si',1), (2,1,'L','Si',1), (3,1,'L','Si',1),
		(4,1,'L','Si',1), (5,1,'L','Si',1), (6,1,'L','Si',1),
		(7,1,'L','Si',1), (8,1,'L','Si',1), (9,1,'L','Si',1),
		(10,1,'L','Si',1), (11,1,'L','Si',1), (12,1,'L','No',1),
		--en centro 1 y sala2 (camas de la 1 a 12)
		 --en centro 1 y sala 1 (camas de la 1 a 15)
		(1,1,'L','Si',2), (2,1,'L','Si',2), (3,1,'L','Si',2),
		(4,1,'L','Si',2), (5,1,'L','Si',2), (6,1,'L','Si',2),
		(7,1,'L','Si',2), (8,1,'L','Si',2), (9,1,'L','Si',2),
		(10,1,'L','Si',2), (11,1,'L','Si',2), (12,1,'L','No',2),
		(13,1,'L','Si',2), (14,1,'L','Si',2), (15,1,'L','Si',2),

		--en centro 2 y sala 1 (camas de la 1 a 3)
		(1,2,'L','Si',1), (2,2,'L','Si',1), (3,2,'L','No',1),
		--en centro 3 y sala 1 (camas de la 1 a 3)
		(1,3,'L','Si',1), (2,3,'L','Si',1), (3,3,'L','No',1),
		--en centro 4 y sala 1 (camas de la 1 a 15)
		(1,4,'L','Si',1), (2,4,'L','Si',1), (3,4,'L','No',1),
		
		--agregado
		
		(4,4,'L','Si',1), (5,4,'L','Si',1), (6,4,'L','Si',1),
		(7,4,'L','Si',1), (8,4,'L','Si',1), (9,4,'L','Si',1),
		(10,4,'L','Si',1), (11,4,'L','No',1), (12,4,'L','No',1),
		(13,4,'L','Si',1), (14,4,'L','Si',1), (15,4,'L','Si',1),
		
		
		(1,1,'L','Si',3),

		(1,2,'L','Si',2),
		(1,2,'L','Si',3),

		(1,3,'L','Si',2),
		(1,3,'L','Si',3),

		(1,4,'L','Si',2),
		(1,4,'L','Si',3);


		

insert into LABORATORIO (nro_registro, nombre)
values (1,'Lab 1'), (2,'Lab 2'), (3,'Lab 3');
	
	
insert into PERSONA(cedula,codigo_interno,nombre)
values (41256087,1,'Rodrigo'),(41256887,2,'Pedro'),(41226087,3,'Romina'),(31256087,4,'Eduardo'),
		(41256086,5,'Daniela'),(46256087,6,'Federico'),(41256066,7,'Agustina'),(41256666,8,'Agustin');

		
insert into MEDICO(cedula_medico)
values (41256087), (41256887);


insert into PACIENTE(cedula,apellido,fecha_nacimeinto,sexo,codigo_centro)
values (41226087,'perez','21-10-1990','F',2),(31256087,'Rodriguez','21-10-1991','M',2),
		(41256086,'Zanfabro','21-10-1985','F',2),(46256087,'Dominguez','21-10-1988','M',2),
		(41256066,'Gutierrez','21-10-1975','F',2),(41256666,'Diaz','21-10-88','F',2);

	
insert into TEST(cedula,nro_registro,fecha_resultado,resultado)
values (41226087,1,'19-11-2020','positivo'),(41226087,1,'18-11-2020','positivo'),(41226087,1,'17-11-2020','positivo'), (41256086,1,'17-11-2020','negativo')


insert into ESTUVO(codigo_centro,cedula,fecha)
values (2,41256087,'18-09-2020'),(4,41256666,'18-09-2020'),(4,41256887,'18-09-2020'),
(4,41226087,'19-09-2020');

insert into ESPECIALIDAD(codigo_esp,nombre_esp)
values (1,'Pediatria'),(2,'Dermatologia'),(3,'Oftalmologia');


insert into EJERCE(cedula_medico,codigo_esp,fecha_habilitacion)
values (41256087,1,'28-5-1991'),(41256087,2,'29-5-1991'), (41256887,3,'30-5-1991');


insert into SE_ATIENDE(cedula,codigo_esp,cedula_medico,fecha_atencion,codigo_centro)
values (41226087,1,41256087,'25-09-2020',4), (41256666,3,41256887,'25-09-2020',3)


insert into INTERNADO (nro_cama,nro_sala,codigo_centro,cedula,fecha_desde,fecha_hasta)
values (1,1,4,41226087,'21-11-2020','21-11-2020'),
(1,1,4,31256087,'21-11-2020','21-11-2020'),
(1,1,4,41256086,'21-11-2020','21-11-2020'),

(1,1,4,46256087,'21-11-2020','21-11-2020'),

(1,1,4,41256066,'21-11-2020','21-11-2020'),
(1,1,4,41256666,'21-11-2020','21-11-2020'),
(1,1,1,41256666,'21-11-2020','11-11-2020'),
(1,1,2,41256666,'10-09-2020','11-09-2020'),

(1,1,1,41226087,'21-09-2020','11-09-2020');
--1) Obtener los Centros en los cuales en la última semana se han internado más de 5 personas.--------------select * from CENTRO where CENTRO.codigo_centro in (select CENTRO.codigo_centro from CENTRO, INTERNADO where centro.codigo_centro = INTERNADO.codigo_centro and  INTERNADO.fecha_desde >= (getdate()-7)   group by centro.codigo_centrohaving count(INTERNADO.cedula) > 5)--------------------------------------2)Obtener todos los Centros que tienen más de 10 camas juntas (en una misma sala) con
--  Respirador disponible.

select * from CENTRO where CENTRO.codigo_centro in

(select  CENTRO.codigo_centro from CENTRO,CAMA,SALA where centro.codigo_centro = SALA.codigo_centro and sala.codigo_centro = CAMA.codigo_centro
and SALA.nro_sala = CAMA.nro_sala and cama.tiene_respirador = 'Si' 
	group by CENTRO.codigo_centro
having count(CAMA.nro_sala) > 10)

		
--3)Obtener los datos de los pacientes que tuvieron dos o más test positivos en los últimos sesenta
--  días, partiendo desde el día de la fecha.

select * from PACIENTE where PACIENTE.cedula in

(select paciente.cedula from PACIENTE,TEST where PACIENTE.cedula = test.cedula and TEST.resultado='positivo' and ((getdate()-60) <= test.fecha_resultado)
	group by paciente.cedula 
		having count(test.nro_registro) >= 2)


--4)Obtener los datos de los médicos que tienen más de una especialidad y atendieron a pacientes
--  que se encuentran internados en centros de la ciudad de Salto.

select * from PERSONA where PERSONA.cedula in

(select  MEDICO.cedula_medico from MEDICO,SE_ATIENDE,PACIENTE where 
		medico.cedula_medico in
		(select MEDICO.cedula_medico from MEDICO,EJERCE
		where MEDICO.cedula_medico = EJERCE.cedula_medico
		group by MEDICO.cedula_medico
		having count(EJERCE.cedula_medico) > 1)
			and 
		paciente.cedula in	
		(select paciente.cedula from PACIENTE,INTERNADO where PACIENTE.cedula = INTERNADO.cedula 
		and INTERNADO.codigo_centro in 
		(select centro.codigo_centro from centro,ciudad where centro.codigo_ciudad = ciudad.codigo_ciudad and CIUDAD.nombre_ciudad='Salto'))
		and SE_ATIENDE.cedula = PACIENTE.cedula and SE_ATIENDE.cedula_medico = MEDICO.cedula_medico)

--5)Obtener el nombre, cédula de las personas que estuvieron en centros de la ciudad de
--  Montevideo o Rivera el jueves 18 septiembre, se debe ordenar el resultado alfabéticamente y
--  mostrar para cada persona el centro, es decir si una persona estuvo este día en más de un
--  centro debe aparecer en el listado más de una vez


select distinct PERSONA.nombre,PERSONA.cedula, CENTRO.codigo_centro, CENTRO.nombre_centro from PERSONA,ESTUVO,CENTRO,CIUDAD where ESTUVO.cedula=PERSONA.cedula and 
ESTUVO.codigo_centro in (select centro.codigo_centro from centro,ciudad
where centro.codigo_ciudad = CIUDAD.codigo_ciudad and (CIUDAD.nombre_ciudad='Montevideo' or CIUDAD.nombre_ciudad='Rivera'))
and ESTUVO.codigo_centro = CENTRO.codigo_centro and
ESTUVO.fecha = '18-09-2020' order by PERSONA.nombre 


--6)Proponga al menos una consulta que al equipo le resulte de interés, considerando que la misma
--  debe cumplir como requisitos mínimos, la presencia de un join y un promedio.
--  La respuesta debe constar de tres partes:
--  a. La letra de la consulta propuesta.
--  b. La consulta en SQL
--  c. Una captura del resultado obtenido.--6.1) Mostrar nombre de centro y promedio de camas por sala para cada centro(considerando solamente las salas que tengan camas)

select nombreCentro, avg(cantCamas) from 

(select  CENTRO.nombre_centro as nombreCentro,sala.nro_sala as numeroSala,count(CAMA.nro_cama) as cantCamas 
from CENTRO join SALA on CENTRO.codigo_centro = SALA.codigo_centro
right join CAMA on Sala.codigo_centro = CAMA.codigo_centro where sala.nro_sala = cama.nro_sala
group by CENTRO.nombre_centro,SALA.nro_sala) as tabla group by nombreCentro

