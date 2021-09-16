# Creo de la Base de Datos
DROP DATABASE banco; /*revisar*/
CREATE DATABASE banco;

# selecciono la base de datos sobre la cual voy a hacer modificaciones
USE banco;

#-------------------------------------------------------------------------
# Creacion Tablas para las entidades

CREATE TABLE Ciudad (
    nombre VARCHAR(45) NOT NULL, 
    cod_postal INT NOT NULL CHECK (cod_postal > 0 AND cod_postal <= 9999),
    
    CONSTRAINT pk_Ciudad 
    PRIMARY KEY (cod_postal)

) ENGINE=InnoDB;


CREATE TABLE Sucursal(
    direccion VARCHAR(45) NOT NULL, 
    telefono VARCHAR(45) NOT NULL, 
    horario VARCHAR(45) NOT NULL, 
    nombre VARCHAR(45) NOT NULL,
    nro_suc INT NOT NULL CHECK (nro_suc > 0 AND nro_suc <= 999),
    cod_postal INT NOT NULL,

	CONSTRAINT pk_Sucursal 
	PRIMARY KEY (nro_suc),

   CONSTRAINT FK_Sucursal_Ciudad
   FOREIGN KEY (cod_postal) REFERENCES Ciudad (cod_postal)
      ON DELETE RESTRICT ON UPDATE CASCADE

) ENGINE=InnoDB;



CREATE TABLE Empleado(
    legajo INT NOT NULL CHECK (legajo > 0 AND legajo <= 9999),
    apellido VARCHAR(45) NOT NULL,
    nombre VARCHAR(45) NOT NULL,
    tipo_doc VARCHAR(45) NOT NULL,
    nro_doc BIGINT NOT NULL CHECK (nro_doc > 0 AND nro_doc <= 99999999),
    direccion VARCHAR(45) NOT NULL,
    telefono VARCHAR(45) NOT NULL,
    cargo VARCHAR(45) NOT NULL,
    password VARCHAR(32) NOT NULL,
    nro_suc INT NOT NULL,

   CONSTRAINT pk_Empleado 
	PRIMARY KEY (legajo),

   CONSTRAINT FK_Empleado_Sucursal
   FOREIGN KEY (nro_suc) REFERENCES Sucursal (nro_suc)
      ON DELETE RESTRICT ON UPDATE CASCADE

) ENGINE=InnoDB;


CREATE TABLE Cliente(
    nro_cliente INT NOT NULL CHECK (nro_cliente > 0 AND nro_cliente <= 99999),
    apellido VARCHAR(45) NOT NULL,
    nombre VARCHAR(45) NOT NULL,
    tipo_doc VARCHAR(45) NOT NULL,
    nro_doc BIGINT NOT NULL CHECK (nro_doc > 0 AND nro_doc <= 99999999),
    direccion VARCHAR(45) NOT NULL,
    telefono VARCHAR(45) NOT NULL,
    fecha_nac DATE NOT NULL,
   
   CONSTRAINT pk_Cliente 
	PRIMARY KEY (nro_cliente)

) ENGINE=InnoDB;


CREATE TABLE PlazoFijo(
    nro_plazo BIGINT NOT NULL CHECK (nro_plazo > 0 AND nro_plazo <= 99999999),
    capital FLOAT NOT NULL CHECK (capital > 0),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    tasa_interes DECIMAL (4,2) NOT NULL,
    interes DECIMAL(6,2) NOT NULL,
    nro_suc INT NOT NULL, 

   CONSTRAINT pk_PlazoFijo 
	PRIMARY KEY (nro_plazo),

   CONSTRAINT FK_PlazoFijo_Sucursal
   FOREIGN KEY (nro_suc) REFERENCES Sucursal (nro_suc)
        ON DELETE RESTRICT ON UPDATE CASCADE

) ENGINE=InnoDB;


CREATE TABLE Tasa_Plazo_Fijo(
    periodo SMALLINT NOT NULL CHECK (periodo > 0 AND periodo <= 999),
    monto_inf UNSIGNED DECIMAL(9,2) NOT NULL,
    monto_sup UNSIGNED DECIMAL(9,2) NOT NULL,
    tasa DUNSIGNED DECIMAL(4,2) NOT NULL,

    CONSTRAINT pk_Tasa_Plazo_Fijo
	    PRIMARY KEY (periodo, monto_inf, monto_sup)

) ENGINE=InnoDB;


CREATE TABLE Plazo_Cliente(

	nro_plazo INT NOT NULL,
	nro_cliente INT NOT NULL,
	
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
    nro_prestamo BIGINT NOT NULL CHECK (nro_prestamo > 0 AND nro_prestamo <= 99999999),   
    fecha DATE NOT NULL,
    cant_meses SMALLINT NOT NULL CHECK (cant_meses > 0 AND cant_meses <= 99),
    monto UNSIGNED DECIMAL(9,2) NOT NULL, 
    tasa_interes UNSIGNED DECIMAL(4,2) NOT NULL, 
    interes UNSIGNED DECIMAL(6,2) NOT NULL, 
    valor_cuota UNSIGNED DECIMAL(7,2) NOT NULL, 
    legajo INT NOT NULL,
    nro_cliente INT NOT NULL,

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
    nro_prestamo INT NOT NULL,
    nro_pago SMALLINT NOT NULL CHECK (nro_pago > 0 AND nro_pago <= 99),
    fecha_venc DATE NOT NULL,
    fecha_pago DATE NOT NULL,

   CONSTRAINT pk_Pago
	    PRIMARY KEY (nro_pago, nro_prestamo),

   CONSTRAINT FK_Pago_Prestamo
	FOREIGN KEY (nro_prestamo) REFERENCES Prestamo (nro_prestamo)
		ON DELETE RESTRICT ON UPDATE CASCADE

) ENGINE=InnoDB;


CREATE TABLE Tasa_Prestamo(
	periodo SMALLINT NOT NULL CHECK (periodo > 0 AND periodo <= 999),
	monto_inf UNSIGNED DECIMAL(9,2) NOT NULL,
	monto_sup UNSIGNED DECIMAL(9,2) NOT NULL,
	tasa UNSIGNED DECIMAL(4,2) NOT NULL,
	
	CONSTRAINT pk_Tasa_Prestamo
	PRIMARY KEY (periodo, monto_inf, monto_sup)

) ENGINE=InnoDB;


CREATE TABLE Caja_Ahorro(
	nro_ca INT NOT NULL CHECK (nro_ca > 0 AND nro_ca <= 99999999),
	CBU BIGINT NOT NULL CHECK (CBU > 99999999999999999 AND CBU <= 999999999999999999),
	saldo UNSIGNED DECIMAL(10,2) NOT NULL,
	
	CONSTRAINT pk_Caja_Ahorro
	PRIMARY KEY (nro_ca)

) ENGINE=InnoDB;

CREATE TABLE Cliente_CA (
	nro_cliente INT NOT NULL,
	nro_ca INT NOT NULL,

	CONSTRAINT pk_Cliente_CA
	PRIMARY KEY (nro_cliente, nro_ca),

	CONSTRAINT fk_Cliente_CA_Cliente
	FOREIGN KEY (nro_cliente) REFERENCES Cliente (nro_cliente)
		ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT fk_Cliente_CA_Caja_Ahorro
	FOREIGN KEY (nro_ca) REFERENCES Caja_Ahorro (nro_ca)
		ON DELETE RESTRICT ON UPDATE CASCADE

) ENGINE=InnoDB;

CREATE TABLE Tarjeta(
	nro_tarjeta BIGINT NOT NULL CHECK(nro_tarjeta > 0 AND nro_tarjeta <= 9999999999999999), 
	MD5(PIN INT NOT NULL), 
	MD5(CVT INT NOT NULL), 
	nro_cliente INT NOT NULL, 
	nro_ca INT NOT NULL,
	fecha_venc DATE NOT NULL,	
	
	CONSTRAINT pk_Tarjeta
	PRIMARY KEY (nro_tarjeta),
	
	CONSTRAINT FK_Tarjeta_Cliente
	FOREIGN KEY (nro_cliente) REFERENCES Cliente (nro_cliente)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	
	CONSTRAINT FK_Tarjeta_Caja_Ahorro
	FOREIGN KEY (nro_ca) REFERENCES Caja_Ahorro (nro_ca)
		ON DELETE RESTRICT ON UPDATE CASCADE

)ENGINE=InnoDB;


CREATE TABLE Caja (
	cod_caja INT NOT NULL CHECK(cod_caja > 0 AND cod_caja <= 99999), 
	
	CONSTRAINT pk_Caja
	PRIMARY KEY (cod_caja)
	
)ENGINE=INNODB;


CREATE TABLE ATM(
	cod_caja INT NOT NULL, 
	cod_postal INT NOT NULL,
	direccion VARCHAR NOT NULL,
	
	CONSTRAINT pk_ATM
	PRIMARY KEY (cod_caja),
	
	CONSTRAINT FK_ATM_Caja
	FOREIGN KEY (cod_caja) REFERENCES Caja (cod_caja)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	
	CONSTRAINT FK_ATM_Cicudad
	FOREIGN KEY (cod_postal) REFERENCES Ciudad (cod_postal)
		ON DELETE RESTRICT ON UPDATE CASCADE

)ENGINE=InnoDB;



CREATE TABLE Ventallia(
	cod_caja INT NOT NULL, 
	nro_suc INT NOT NULL,

	CONSTRAINT pk_Ventanilla
	PRIMARY KEY (cod_caja),
	
	CONSTRAINT FK_Ventanilla_Caja
	FOREIGN KEY (cod_caja) REFERENCES Caja (cod_caja)
		ON DELETE RESTRICT ON UPDATE CASCADE,		
	
	CONSTRAINT FK_Ventanilla_Sucursal
	FOREIGN KEY (nro_suc) REFERENCES Sucursal (nro_suc)
		ON DELETE RESTRICT ON UPDATE CASCADE

)ENGINE=InnoDB;



CREATE TABLE Transaccion(
	nro_trans INT NOT NULL CHECK(nro_trans > 0 AND nro_trans <= 9999999999), 
	fecha DATE NOT NULL, 
	hora TIME NOT NULL, 
	monto UNSIGNED DECIMAL(9,2) NOT NULL,
	
	CONSTRAINT pk_Transaccion
	PRIMARY KEY (nro_trans)

)ENGINE=InnoDB;


CREATE TABLE Transaccion_por_caja(
	nro_trans INT NOT NULL, 
	cod_caja INT NOT NULL, 

	CONSTRAINT pk_Transaccion_por_caja
	PRIMARY KEY (nro_trans),
	
	CONSTRAINT FK_TransPorCaja_Transaccion
	FOREIGN KEY (nro_trans) REFERENCES Transaccion (nro_trans)
		ON DELETE RESTRICT ON UPDATE CASCADE,	
		
	CONSTRAINT FK_TransPorCaja_Caja
	FOREIGN KEY (cod_caja) REFERENCES Caja (cod_caja)
		ON DELETE RESTRICT ON UPDATE CASCADE

)ENGINE=InnoDB;



CREATE TABLE Debito(
	nro_trans INT NOT NULL, 	
	descripcion VARCHAR NOT NULL, 
	nro_cliente INT NOT NULL,
	nro_ca INT NOT NULL,
	
	CONSTRAINT pk_Debito
	PRIMARY KEY (nro_trans),
	
	CONSTRAINT FK_Debito_Transaccion
	FOREIGN KEY (nro_trans) REFERENCES Transaccion (nro_trans)
		ON DELETE RESTRICT ON UPDATE CASCADE,
		
	CONSTRAINT FK_Debito_ClienteCA_Cliente
	FOREIGN KEY (nro_cliente) REFERENCES Cliente_CA (nro_cliente)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	
	CONSTRAINT FK_Debito_ClienteCA_CA
	FOREIGN KEY (nro_ca) REFERENCES Cliente_CA (nro_ca)
		ON DELETE RESTRICT ON UPDATE CASCADE

)ENGINE=InnoDB;



CREATE TABLE Deposito(
	nro_trans INT NOT NULL, 
	nro_ca INT NOT NULL,
	
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
	nro_trans BIGINT NOT NULL, 
	nro_cliente INT NOT NULL,
	nro_ca INT NOT NULL,
		
	CONSTRAINT pk_Extraccion
	PRIMARY KEY (nro_trans),
	
	CONSTRAINT FK_Extraccion_TransPorCaja
	FOREIGN KEY (nro_trans) REFERENCES Transaccion_por_caja (nro_trans)
		ON DELETE RESTRICT ON UPDATE CASCADE, 
		
	CONSTRAINT FK_Extraccion_ClienteCA_Cliente
	FOREIGN KEY (nro_cliente) REFERENCES Cliente_CA (nro_cliente)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	
	CONSTRAINT FK_Extraccion_ClienteCA_CA
	FOREIGN KEY (nro_ca) REFERENCES Cliente_CA (nro_ca)
		ON DELETE RESTRICT ON UPDATE CASCADE

)ENGINE=InnoDB;



CREATE TABLE Transferencia(
	nro_trans INT NOT NULL, 	
	nro_cliente INT NOT NULL, 
	origen_nroca INT NOT NULL,
	destino_nroca INT NOT NULL,
	
	CONSTRAINT pk_Transferencia
	PRIMARY KEY (nro_trans),
	
	CONSTRAINT FK_Transferencia_TransPorCaja
	FOREIGN KEY (nro_trans) REFERENCES Transaccion_por_caja (nro_trans)
		ON DELETE RESTRICT ON UPDATE CASCADE, 
	
	CONSTRAINT FK_Transferencia_ClienteCA_Cliente
	FOREIGN KEY (nro_cliente) REFERENCES Cliente_CA (nro_cliente)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	
	
	/*no se si referencia a la llave de la relacion Cliente_CA o si directamente va a Caja_de_ahorro*/
	CONSTRAINT FK_Deposito_CA
	FOREIGN KEY (origen_nroca) REFERENCES Cliente_CA (nro_ca)
		ON DELETE RESTRICT ON UPDATE CASCADE, 
	
	CONSTRAINT FK_Deposito_CA
	FOREIGN KEY (destino_nroca) REFERENCES Cliente_CA (nro_ca)
		ON DELETE RESTRICT ON UPDATE CASCADE	
		

)ENGINE=InnoDB;


#----------------------------------------------------------------------------------
# Creacion de usuarios y asignacion de privilegios

#------------- Usuario: admin -------------------

/* 	Este usuario se utilizara para administrar la base de datos “banco” por lo tanto debera tener 
acceso total sobre todas las tablas, con la opcion de crear usuarios y otorgar privilegios sobre las mismas. 
Para no comprometer la seguridad se restringira que el acceso de este usuario se realice solo desde la maquina 
local donde se encuentra el servidor MySQL. El password de este usuario debera ser admin. */

CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';

GRANT ALL PRIVILEGES ON banco.* TO 'admin'@'localhost' WITH GRANT OPTION;

#------------- Usuario: empleado -------------------

/* Este usuario estara destinado a permitir el acceso de la aplicacion de administracion
que utilizan los empleados del banco para administrar los clientes, prestamos, cajas de ahorro y
plazos fijos. Para esto necesitara privilegios para:
 
 *Solo realizar consultas sobre: Empleado, Sucursal, Tasa Plazo Fijo y Tasa Prestamo.
 
 *Realizar consultas e ingresar datos sobre: Prestamo, Plazo Fijo, Plazo Cliente, Caja Ahorro y Tarjeta.
 
 *Realizar consultas, ingresar y modificar datos sobre: Cliente CA, Cliente y Pago.
 
Dado que el banco cuenta con varias sucursales distribuidas en diferentes ciudades, este usuario deber´a poder conectarse desde cualquier dominio. El password de este usuario deber´a ser
empleado. Importante: Recuerde eliminar el usuario vacıo (drop user ’’@localhost) para
poder conectarse con el usuario empleado desde localhost. */
# 

CREATE USER 'empleado'@'%' IDENTIFIED BY 'empleado';

drop user ’’@localhost /*ESTA BIEN ASI? xd*/

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


#------------- Usuario: atm -------------------

#
atm: Este usuario esta destinado a permitir el acceso de los ATM, para que los clientes puedan
consultar el estado de sus cajas de ahorro y realizar transacciones. Con el objetivo de ocultar
la estructura de la base de datos, el usuario atm tendra una vision restringida de la misma que
solamente le permita ver informacion relacionada a las transacciones realizadas sobre las cajas
de ahorro. A tal efecto, se debera crear una vista con el nombre trans cajas ahorro que contenga
la siguiente informacion:

	*Numero (nro ca) y saldo de cada caja de ahorro.

	*Numero (nro trans), fecha, hora, tipo (debito, extraccion, transferencia, deposito) y monto
de cada transaccion realizada sobre cada caja de ahorro. En caso que la transaccion sea
una transferencia la vista debera contener el numero de la caja de ahorro destino. Ademas,
debera contener el codigo de la caja (cod caja) donde fue realizada la transaccion (salvo
que sea un debito).

	*Numero de cliente, tipo y numero de documento, nombre y apellido del cliente que realizo
cada transaccion (solo para debito, extraccion y transferencia).

El usuario atm tendra privilegio de lectura sobre la vista trans cajas ahorro. 

Ademas este usuario debera tener permiso de lectura y actualizacion sobre la tabla tarjeta (ver apendice A) para
poder controlar el ingreso de los clientes a los ATM y permitir que cambien el PIN de su tarjeta.

Dado que los cajeros automaticos se encuentran distribuidos en diferentes ciudades, este usuario
debera poder conectarse desde cualquier dominio. El password de este usuario debera ser atm.
#

CREATE USER 'atm'@'%' IDENTIFIED BY 'atm';

GRANT SELECT ON banco.Transaccion_por_caja TO 'atm'@'%';
GRANT SELECT, UPDATE ON banco.Tarjeta TO 'atm'@'%';