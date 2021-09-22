# Creo de la Base de Datos

DROP DATABASE banco;


drop user admin@localhost;

drop user empleado;

drop user atm;
/*
drop user ''@localhost;*/

CREATE DATABASE banco;

# selecciono la base de datos
USE banco;


#-------------------------------------------------------------------------
# Creacion Tablas para las entidades

CREATE TABLE Ciudad (
   cod_postal INT UNSIGNED NOT NULL CHECK (cod_postal > 0 AND cod_postal <= 9999),
   nombre VARCHAR(45) NOT NULL, 
    
   CONSTRAINT pk_Ciudad 
    PRIMARY KEY (cod_postal)	

) ENGINE=InnoDB;


CREATE TABLE Sucursal(
	nro_suc SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	nombre VARCHAR(45) NOT NULL,
   direccion VARCHAR(45) NOT NULL, 
   telefono VARCHAR(45) NOT NULL, 
   horario VARCHAR(45) NOT NULL,     
   cod_postal INT UNSIGNED NOT NULL,

	CONSTRAINT pk_Sucursal 
	PRIMARY KEY (nro_suc),

   CONSTRAINT FK_Sucursal_Ciudad
   FOREIGN KEY (cod_postal) REFERENCES Ciudad (cod_postal)
      ON DELETE RESTRICT ON UPDATE CASCADE

) ENGINE=InnoDB;



CREATE TABLE Empleado(
   legajo INT UNSIGNED NOT NULL AUTO_INCREMENT,
   apellido VARCHAR(45) NOT NULL,
   nombre VARCHAR(45) NOT NULL,
   tipo_doc VARCHAR(20) NOT NULL,
   nro_doc BIGINT UNSIGNED NOT NULL CHECK (nro_doc > 0 AND nro_doc <= 99999999),
   direccion VARCHAR(45) NOT NULL,
   telefono VARCHAR(45) NOT NULL,
   cargo VARCHAR(45) NOT NULL,
   password VARCHAR(32) NOT NULL,
   nro_suc SMALLINT UNSIGNED NOT NULL,

   CONSTRAINT pk_Empleado 
	PRIMARY KEY (legajo),

   CONSTRAINT FK_Empleado_Sucursal
   FOREIGN KEY (nro_suc) REFERENCES Sucursal (nro_suc)
      ON DELETE RESTRICT ON UPDATE CASCADE

) ENGINE=InnoDB;


CREATE TABLE Cliente(
   nro_cliente INT UNSIGNED NOT NULL AUTO_INCREMENT,
   apellido VARCHAR(45) NOT NULL,
   nombre VARCHAR(45) NOT NULL,
   tipo_doc VARCHAR(20) NOT NULL,
   nro_doc BIGINT UNSIGNED NOT NULL CHECK (nro_doc > 0 AND nro_doc <= 99999999),
   direccion VARCHAR(45) NOT NULL,
   telefono VARCHAR(45) NOT NULL,
   fecha_nac DATE NOT NULL,
   
   CONSTRAINT pk_Cliente 
	PRIMARY KEY (nro_cliente)

) ENGINE=InnoDB;

CREATE TABLE Plazo_Fijo (
	nro_plazo BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	capital DECIMAL (16,2) UNSIGNED NOT NULL,
	fecha_inicio DATE NOT NULL,
	fecha_fin DATE NOT NULL,
	tasa_interes DECIMAL (4,2) UNSIGNED NOT NULL,
	interes DECIMAL (16,2) UNSIGNED NOT NULL,
   nro_suc SMALLINT UNSIGNED NOT NULL,
	
	CONSTRAINT pk_nro_plazo
	PRIMARY KEY (nro_plazo),
	
	CONSTRAINT fk_Plazo_Fijo_NroSuc
	FOREIGN KEY (nro_suc) REFERENCES Sucursal(nro_suc)
		ON DELETE RESTRICT ON UPDATE CASCADE 
	
		 
) ENGINE=InnoDB;


CREATE TABLE Tasa_Plazo_Fijo(
   periodo SMALLINT UNSIGNED NOT NULL CHECK (periodo > 0 AND periodo <= 999),
   monto_inf  DECIMAL(16,2) UNSIGNED NOT NULL,
   monto_sup  DECIMAL(16,2) UNSIGNED NOT NULL,
   tasa DECIMAL(4,2) UNSIGNED NOT NULL,
    

   CONSTRAINT pk_Tasa_Plazo_Fijo
	   PRIMARY KEY (periodo, monto_inf, monto_sup)

) ENGINE=INNODB;


CREATE TABLE Plazo_Cliente(

	nro_plazo BIGINT UNSIGNED NOT NULL,
	nro_cliente INT UNSIGNED NOT NULL,
	
	CONSTRAINT pk_Plazo_Cliente
	PRIMARY KEY (nro_plazo, nro_cliente),
	
	CONSTRAINT FK_Plazo_Cliente_Plazo_Fijo
	FOREIGN KEY (nro_plazo) REFERENCES Plazo_Fijo (nro_plazo)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	
	CONSTRAINT FK_Plazo_Cliente_Cliente
	FOREIGN KEY (nro_cliente) REFERENCES Cliente (nro_cliente)
		ON DELETE RESTRICT ON UPDATE CASCADE

) ENGINE=InnoDB;



CREATE TABLE Prestamo(
   nro_prestamo BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
   fecha DATE NOT NULL,
   cant_meses SMALLINT UNSIGNED NOT NULL CHECK (cant_meses > 0 AND cant_meses <= 99),
   monto DECIMAL(10,2) UNSIGNED NOT NULL, 
   tasa_interes  DECIMAL(4,2) UNSIGNED NOT NULL, 
   interes DECIMAL(9,2) UNSIGNED NOT NULL, 
   valor_cuota  DECIMAL(9,2) UNSIGNED NOT NULL, 
   legajo INT UNSIGNED NOT NULL,
   nro_cliente INT UNSIGNED NOT NULL,

   CONSTRAINT pk_Prestamo
	PRIMARY KEY (nro_prestamo),
	
	CONSTRAINT FK_Prestamo_Empleado
	FOREIGN KEY (legajo) REFERENCES Empleado (legajo)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	
	CONSTRAINT FK_Prestamo_Cliente
	FOREIGN KEY (nro_cliente) REFERENCES Cliente (nro_cliente)
		ON DELETE RESTRICT ON UPDATE CASCADE

) ENGINE=InnoDB;


CREATE TABLE Pago(
   nro_prestamo BIGINT UNSIGNED NOT NULL,
   nro_pago SMALLINT UNSIGNED NOT NULL CHECK (nro_pago > 0 AND nro_pago <= 99),
   fecha_venc DATE NOT NULL,
   fecha_pago DATE,

   CONSTRAINT pk_Pago
	    PRIMARY KEY (nro_pago, nro_prestamo),

   CONSTRAINT FK_Pago_Prestamo
	FOREIGN KEY (nro_prestamo) REFERENCES Prestamo (nro_prestamo)
		ON DELETE RESTRICT ON UPDATE CASCADE

) ENGINE=InnoDB;


CREATE TABLE Tasa_Prestamo(
	periodo SMALLINT UNSIGNED NOT NULL CHECK (periodo > 0 AND periodo <= 999),
	monto_inf  DECIMAL(10,2) UNSIGNED NOT NULL,
	monto_sup  DECIMAL(10,2) UNSIGNED NOT NULL,
	tasa  DECIMAL(4,2) UNSIGNED NOT NULL,
	
	CONSTRAINT pk_Tasa_Prestamo
	PRIMARY KEY (periodo, monto_inf, monto_sup)

) ENGINE=InnoDB;


CREATE TABLE Caja_Ahorro(
	nro_ca INT UNSIGNED NOT NULL AUTO_INCREMENT,
	CBU BIGINT UNSIGNED NOT NULL CHECK (CBU > 0 AND CBU <= 999999999999999999),
	saldo DECIMAL(16,2) UNSIGNED NOT NULL,
	
	CONSTRAINT pk_Caja_Ahorro
	PRIMARY KEY (nro_ca)

) ENGINE=InnoDB;

CREATE TABLE Cliente_CA (
	nro_cliente INT UNSIGNED NOT NULL,
	nro_ca INT UNSIGNED NOT NULL,

	CONSTRAINT pk_Cliente_CA
	PRIMARY KEY (nro_cliente, nro_ca),

	CONSTRAINT FK_Cliente_CA_Cliente
	FOREIGN KEY (nro_cliente) REFERENCES Cliente (nro_cliente)
		ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT FK_Cliente_CA_Caja_Ahorro
	FOREIGN KEY (nro_ca) REFERENCES Caja_Ahorro (nro_ca)
		ON DELETE RESTRICT ON UPDATE CASCADE

) ENGINE=InnoDB;

CREATE TABLE Tarjeta(
	nro_tarjeta BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, 
	PIN CHAR(32) NOT NULL, 
	CVT CHAR(32) NOT NULL, 
	fecha_venc DATE NOT NULL,	
	nro_cliente INT UNSIGNED NOT NULL, 
	nro_ca INT UNSIGNED NOT NULL,
	
	CONSTRAINT pk_Tarjeta
	PRIMARY KEY (nro_tarjeta),
	
	CONSTRAINT FK_Tarjeta_Cliente
	FOREIGN KEY (nro_cliente, nro_ca) REFERENCES Cliente_Ca (nro_cliente, nro_ca)
		ON DELETE RESTRICT ON UPDATE CASCADE
		
)ENGINE=InnoDB;


CREATE TABLE Caja (
	cod_caja INT UNSIGNED NOT NULL AUTO_INCREMENT, 
	
	CONSTRAINT pk_Caja
	PRIMARY KEY (cod_caja)
	
)ENGINE=InnoDB;


CREATE TABLE Ventanilla(
	cod_caja INT UNSIGNED NOT NULL, 
	nro_suc SMALLINT UNSIGNED NOT NULL,

	CONSTRAINT pk_Ventanilla
	PRIMARY KEY (cod_caja),
	
	CONSTRAINT FK_Ventanilla_Caja
	FOREIGN KEY (cod_caja) REFERENCES Caja (cod_caja)
		ON DELETE RESTRICT ON UPDATE CASCADE,		
	
	CONSTRAINT FK_Ventanilla_Sucursal
	FOREIGN KEY (nro_suc) REFERENCES Sucursal (nro_suc)
		ON DELETE RESTRICT ON UPDATE CASCADE

)ENGINE=InnoDB;


CREATE TABLE ATM(
	cod_caja INT UNSIGNED NOT NULL, 
	cod_postal INT UNSIGNED NOT NULL,
	direccion VARCHAR(45) NOT NULL,
	
	CONSTRAINT pk_ATM
	PRIMARY KEY (cod_caja),
	
	CONSTRAINT FK_ATM_Caja
	FOREIGN KEY (cod_caja) REFERENCES Caja (cod_caja)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	
	CONSTRAINT FK_ATM_Ciudad
	FOREIGN KEY (cod_postal) REFERENCES Ciudad (cod_postal)
		ON DELETE RESTRICT ON UPDATE CASCADE

)ENGINE=InnoDB;


CREATE TABLE Transaccion(
	nro_trans BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, 
	fecha DATE NOT NULL, 
	hora TIME NOT NULL, 
	monto DECIMAL(16,2) UNSIGNED NOT NULL,
	
	CONSTRAINT pk_Transaccion
	PRIMARY KEY (nro_trans)

)ENGINE=InnoDB;


CREATE TABLE Debito(
	nro_trans BIGINT UNSIGNED NOT NULL, 	
	descripcion TINYTEXT, 
	nro_cliente INT UNSIGNED NOT NULL,
	nro_ca INT UNSIGNED NOT NULL,
	
	CONSTRAINT pk_Debito
	PRIMARY KEY (nro_trans),
	
	CONSTRAINT FK_Debito_Transaccion
	FOREIGN KEY (nro_trans) REFERENCES Transaccion (nro_trans)
		ON DELETE RESTRICT ON UPDATE CASCADE,
		
	CONSTRAINT FK_Debito_ClienteCA_ClienteYCA
	FOREIGN KEY (nro_cliente, nro_ca) REFERENCES Cliente_CA (nro_cliente, nro_ca)
		ON DELETE RESTRICT ON UPDATE CASCADE


)ENGINE=InnoDB;


CREATE TABLE Transaccion_por_caja(
	nro_trans BIGINT UNSIGNED NOT NULL, 
	cod_caja INT UNSIGNED NOT NULL, 

	CONSTRAINT pk_Transaccion_por_caja
	PRIMARY KEY (nro_trans),
	
	CONSTRAINT FK_TransPorCaja_Transaccion
	FOREIGN KEY (nro_trans) REFERENCES Transaccion (nro_trans)
		ON DELETE RESTRICT ON UPDATE CASCADE,	
		
	CONSTRAINT FK_TransPorCaja_Caja
	FOREIGN KEY (cod_caja) REFERENCES Caja (cod_caja)
		ON DELETE RESTRICT ON UPDATE CASCADE

)ENGINE=InnoDB;



CREATE TABLE Deposito(
	nro_trans BIGINT UNSIGNED NOT NULL, 
	nro_ca INT UNSIGNED NOT NULL,
	
	CONSTRAINT pk_Deposito
	PRIMARY KEY (nro_trans),
	
	CONSTRAINT FK_Deposito_TransPorCaja
	FOREIGN KEY (nro_trans) REFERENCES Transaccion_por_caja (nro_trans)
		ON DELETE RESTRICT ON UPDATE CASCADE, 
		
	CONSTRAINT FK_Deposito_CA
	FOREIGN KEY (nro_ca) REFERENCES Caja_Ahorro (nro_ca)
		ON DELETE RESTRICT ON UPDATE CASCADE

)ENGINE=InnoDB;


CREATE TABLE Extraccion(
	nro_trans BIGINT UNSIGNED  NOT NULL, 
	nro_cliente INT UNSIGNED NOT NULL,
	nro_ca INT UNSIGNED UNSIGNED NOT NULL,
		
	CONSTRAINT pk_Extraccion
	PRIMARY KEY (nro_trans),
	
	CONSTRAINT FK_Extraccion_TransPorCaja
	FOREIGN KEY (nro_trans) REFERENCES Transaccion_por_caja (nro_trans)
		ON DELETE RESTRICT ON UPDATE CASCADE, 
		
	CONSTRAINT FK_Extraccion_ClienteCA_Cliente
	FOREIGN KEY (nro_cliente, nro_ca) REFERENCES Cliente_CA (nro_cliente, nro_ca)
		ON DELETE RESTRICT ON UPDATE CASCADE

)ENGINE=InnoDB;



CREATE TABLE Transferencia(
	nro_trans BIGINT UNSIGNED NOT NULL,  	
	nro_cliente INT UNSIGNED NOT NULL, 
	origen INT UNSIGNED NOT NULL,
	destino INT UNSIGNED NOT NULL,
	
	CONSTRAINT pk_Transferencia
	PRIMARY KEY (nro_trans),
	
	CONSTRAINT FK_Transferencia_TransPorCaja
	FOREIGN KEY (nro_trans) REFERENCES Transaccion_por_caja (nro_trans)
		ON DELETE RESTRICT ON UPDATE CASCADE, 
	
	CONSTRAINT FK_Transferencia_ClienteCA_Cliente
	FOREIGN KEY (nro_cliente, origen) REFERENCES Cliente_CA (nro_cliente, nro_ca)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	
	CONSTRAINT FK_Transferencia_CA_Destino
	FOREIGN KEY (destino) REFERENCES Caja_Ahorro (nro_ca)
		ON DELETE RESTRICT ON UPDATE CASCADE	
		

)ENGINE=InnoDB;

CREATE VIEW trans_cajas_ahorro AS
	(SELECT DISTINCT deb.nro_ca, saldo, deb.nro_trans, fecha, hora, 'debito' AS tipo, monto, NULL AS cod_caja, deb.nro_cliente, tipo_doc, nro_doc, nombre, apellido, 
						NULL AS destino
	FROM ((((Debito deb JOIN Transaccion trans ON deb.nro_trans = trans.nro_trans) 
				JOIN Cliente_ca clienteca ON clienteca.nro_ca = deb.nro_ca)
				JOIN Cliente cl ON cl.nro_cliente = deb.nro_cliente)
				JOIN Caja_ahorro ca ON ca.nro_ca = clienteca.nro_ca))
	
					
	UNION
	
	(SELECT DISTINCT dep.nro_ca, saldo, dep.nro_trans, fecha, hora, 'deposito' AS tipo, monto, ca.cod_caja, NULL as nro_cliente, NULL as tipo_doc, NULL as nro_doc, 
							NULL as nombre, NULL as apellido, NULL AS destino
	FROM ((((Deposito dep JOIN Transaccion_por_caja transcaja ON dep.nro_trans = transcaja.nro_trans) 
				JOIN Transaccion trans ON transcaja.nro_trans = trans.nro_trans)
				JOIN Caja_ahorro caahorro ON caahorro.nro_ca = dep.nro_ca)
				JOIN Caja ca ON ca.cod_caja = transcaja.cod_caja))
	
	UNION
	(SELECT DISTINCT extra.nro_ca, caahorro.saldo, extra.nro_trans, fecha, hora, 'extraccion' AS tipo, monto, ca.cod_caja, extra.nro_cliente, tipo_doc, nro_doc, nombre, apellido, 
							NULL AS destino
	FROM ((((((Extraccion extra JOIN Transaccion_por_caja transcaja ON extra.nro_trans = transcaja.nro_trans) 
				JOIN Transaccion trans ON transcaja.nro_trans = trans.nro_trans)
				JOIN Cliente_ca clienteca ON clienteca.nro_ca = extra.nro_ca AND clienteca.nro_cliente = extra.nro_cliente)
				JOIN Caja ca ON ca.cod_caja = transcaja.cod_caja)
				JOIN Cliente cl ON cl.nro_cliente = extra.nro_cliente)
				JOIN caja_ahorro caahorro ON clienteca.nro_ca = caahorro.nro_ca))
	
	UNION 
				
	(SELECT DISTINCT clienteca.nro_ca, caahorro.saldo, transfer.nro_trans, fecha, hora, 'transferencia' AS tipo, monto, ca.cod_caja, transfer.nro_cliente, tipo_doc, nro_doc, nombre, apellido, 
						destino
	FROM ((((((Transferencia transfer JOIN Transaccion_por_caja transcaja ON transfer.nro_trans = transcaja.nro_trans) 
				JOIN Transaccion trans ON transcaja.nro_trans = trans.nro_trans)
				JOIN Cliente_ca clienteca ON clienteca.nro_ca = transfer.origen AND clienteca.nro_cliente = transfer.nro_cliente)
				JOIN Caja ca ON ca.cod_caja = transcaja.cod_caja)
				JOIN Cliente cl ON cl.nro_cliente = transfer.nro_cliente)
				JOIN caja_ahorro caahorro ON clienteca.nro_ca = caahorro.nro_ca));	
				
				
#----------------------------------------------------------------------------------
# Creacion de usuarios y asignacion de privilegios

/*----------------------USER ADMIN-------------------------*/


CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';

GRANT ALL PRIVILEGES ON banco.* TO 'admin'@'localhost' WITH GRANT OPTION;


/*----------------------USER EMPLEADO-------------------------*/

/*DROP USER empleado;*/
CREATE USER 'empleado'@'%' IDENTIFIED BY 'empleado';

/* Consultas que puede hacer el empleado: */
GRANT SELECT ON banco.Empleado TO 'empleado'@'%';
GRANT SELECT ON banco.Sucursal TO 'empleado'@'%';
GRANT SELECT ON banco.Tasa_Plazo_Fijo TO 'empleado'@'%';
GRANT SELECT ON banco.Tasa_Prestamo TO 'empleado'@'%'; 

/*Consultas e ingreso de datos que puede hacer el empelado:*/
GRANT SELECT, INSERT ON banco.Prestamo TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.Plazo_Fijo TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.Plazo_Cliente TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.Caja_Ahorro TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.Tarjeta TO 'empleado'@'%';

/*Consultas, ingreso y modificcacion de datos que puede hacer el empelado:*/
GRANT SELECT, INSERT, UPDATE ON banco.Cliente_CA TO 'empleado'@'%';
GRANT SELECT, INSERT, UPDATE ON banco.Cliente TO 'empleado'@'%';
GRANT SELECT, INSERT, UPDATE ON banco.Pago TO 'empleado'@'%';


/*----------------------USER ATM-------------------------*/

CREATE USER 'atm'@'%' IDENTIFIED BY 'atm';


GRANT SELECT ON banco.Transaccion_por_caja TO 'atm'@'%';
GRANT SELECT, UPDATE ON banco.Tarjeta TO 'atm'@'%';
/*GRANT SELECT ON banco.trans_cajas_ahorro TO 'atm'@'%';*/