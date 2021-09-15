# Creo de la Base de Datos
DROP DATABASE banco; /*revisar*/
CREATE DATABASE banco;

# selecciono la base de datos sobre la cual voy a hacer modificaciones
USE banco;

#-------------------------------------------------------------------------
# Creacion Tablas para las entidades

CREATE TABLE Ciudad (
    nombre VARCHAR(45) NOT NULL, 
    cod_postal INT(4) NOT NULL,
    
    CONSTRAINT pk_Ciudad 
    PRIMARY KEY (cod_postal)

) ENGINE=InnoDB;


CREATE TABLE Sucursal(
    direccion VARCHAR(45) NOT NULL, 
    telefono VARCHAR(45) NOT NULL, 
    horario VARCHAR(45) NOT NULL, 
    nombre VARCHAR(45) NOT NULL,
    nro_suc INT NOT NULL CHECK (nro_suc > 0 AND nro_suc <= 999) NOT NULL,
    cod_postal INT(4) NOT NULL,

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
    nro_doc INT NOT NULL CHECK (nro_doc > 0 AND nro_doc <= 99999999),
    direccion VARCHAR(45) NOT NULL,
    telefono VARCHAR(45) NOT NULL,
    cargo VARCHAR(45) NOT NULL,
    password VARCHAR(32) NOT NULL,
    nro_suc INT NOT NULL CHECK (nro_suc > 0 AND nro_suc <= 999) NOT NULL,

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
    nro_doc INT NOT NULL CHECK (nro_doc > 0 AND nro_doc <= 99999999),
    direccion VARCHAR(45) NOT NULL,
    telefono VARCHAR(45) NOT NULL,
    fecha_nac DATE NOT NULL,
    nro_cliente INT(8) NOT NULL,

    CONSTRAINT pk_Cliente 
	PRIMARY KEY (nro_cliente),

) ENGINE=InnoDB;


CREATE TABLE PlazoFijo(
    nro_plazo INT NOT NULL CHECK (nro_plazo > 0 AND nro_plazo <= 99999999),
    capital FLOAT NOT NULL CHECK (capital > 0),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    tasa_interes DECIMAL (X,2) NOT NULL,
    interes DECIMAL(X,2) NOT NULL,
    nro_suc INT NOT NULL CHECK (nro_suc > 0 AND nro_suc <= 999) NOT NULL, 

   CONSTRAINT pk_PlazoFijo 
	PRIMARY KEY (nro_plazo),

   CONSTRAINT FK_PlazoFijo_Sucursal
   FOREIGN KEY (nro_suc) REFERENCES Sucursal (nro_suc)
        ON DELETE RESTRICT ON UPDATE CASCADE

) ENGINE=InnoDB;


CREATE TABLE Tasa_Plazo_Fijo(
    periodo INT NOT NULL CHECK (periodo > 0 AND periodo <= 999) NOT NULL,
    monto_inf DECIMAL(X,2) NOT NULL CHECK (monto_inf > 0), 
    monto_sup DECIMAL(X,2) NOT NULL CHECK (monto_sup>0),
    tasa DECIMAL(X,2) NOT NULL CHECK (tasa > 0),

    CONSTRAINT pk_Tasa_Plazo_Fijo
	    PRIMARY KEY (periodo, monto_inf, monto_sup)

) ENGINE=INNODB;


CREATE TABLE Plazo_Cliente(

	nro_plazo INT NOT NULL CHECK (nro_plazo > 0 AND nro_plazo <= 99999999),
	nro_cliente INT NOT NULL CHECK (nro_cliente > 0 AND nro_cliente <= 99999),
	
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
    nro_prestamo INT NOT NULL CHECK (nro_prestamo > 0 AND nro_prestamo <= 99999999),   
    fecha DATE NOT NULL,
    cant_meses INT NOT NULL CHECK (cant_meses > 0 AND cant_meses <= 99),
    monto DECIMAL(X,2) NOT NULL CHECK (monto > 0), 
    tasa_interes DECIMAL(X,2) NOT NULL CHECK (tasa_interes > 0), 
    interes DECIMAL(X,2) NOT NULL CHECK (interes > 0), 
    valor_cuota DECIMAL(X,2) NOT NULL CHECK (valor_cuota > 0), 
    legajo INT NOT NULL CHECK (legajo > 0 AND legajo <= 9999),
    nro_cliente INT NOT NULL CHECK (nro_cliente > 0 AND nro_cliente <= 99999),

   CONSTRAINT pk_Prestamo
	PRIMARY KEY (nro_prestamo),
	
	CONSTRAINT FK_Prestamo_Empleado
	FOREIGN KEY (legajo) REFERENCES Empleado (legajo)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	
	CONSTRAINT FK_Prestamo_Cliente
	FOREIGN KEY (nro_cliente) REFERENCES Cliente (nro_cliente)
		ON DELETE RESTRICT ON UPDATE CASCADE

) ENGINE=INNODB;


CREATE TABLE Pago(
    nro_prestamo INT NOT NULL CHECK (nro_prestamo > 0 AND nro_prestamo <= 99999999),
    nro_pago INT NOT NULL CHECK (nro_pago > 0 AND nro_pago <= 99),
    fecha_venc DATE NOT NULL,
    fecha_pago DATE NOT NULL,

   CONSTRAINT pk_Pago
	    PRIMARY KEY (nro_pago, nro_prestamo),

   CONSTRAINT FK_Pago_Prestamo
	FOREIGN KEY (nro_prestamo) REFERENCES Prestamo (nro_prestamo)
		ON DELETE RESTRICT ON UPDATE CASCADE

) ENGINE=InnoDB;


CREATE TABLE Tasa_Prestamo(
	periodo INT NOT NULL CHECK (periodo > 0 AND periodo <= 999) NOT NULL,
	monto_inf DECIMAL(X,2) NOT NULL,
	monto_sup DECIMAL(X,2) NOT NULL,
	tasa DECIMAL(X,2) NOT NULL,
	
	CONSTRAINT pk_Tasa_Prestamo
	PRIMARY KEY (periodo, monto_inf, monto_sup)

) ENGINE=InnoDB;


CREATE TABLE Caja_Ahorro(
	nro_ca INT NOT NULL CHECK (nro_ca > 0 AND nro_ca <= 99999999),
	CBU INT NOT NULL CHECK (CBU > 99999999999999999 AND CBU <= 999999999999999999),
	saldo DECIMAL(X,2) NOT NULL,
	
	CONSTRAINT pk_Caja_Ahorro
	PRIMARY KEY (nro_ca)

) ENGINE=InnoDB;


CREATE TABLE Tarjeta(
	nro_tarjeta INT (16) NOT NULL CHECK(nro_tarjeta > 0 AND nro_tarjeta <= 9999999999999999), 
	MD5(PIN INT NOT NULL (32)), 
	MD5(CVT INT NOT NULL (32)), 
	nro_cliente INT NOT NULL CHECK (nro_cliente > 0 AND nro_cliente <= 99999), 
	nro_ca INT NOT NULL CHECK (nro_ca > 0 AND nro_ca <= 99999999),
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
	cod_caja INT (5) NOT NULL CHECK(cod_caja > 0 AND cod_caja <= 99999), 
	
	CONSTRAINT pk_Caja
	PRIMARY KEY (cod_caja)
	
)ENGINE=InnoDB;



CREATE TABLE ATM(
	cod_caja INT (5) NOT NULL CHECK(cod_caja > 0 AND cod_caja <= 99999), 
	cod_postal INT(4) NOT NULL,
	direccion VARCHAR(45) NOT NULL,
	
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
	cod_caja INT (5) NOT NULL CHECK(cod_caja > 0 AND cod_caja <= 99999), 
	nro_suc INT NOT NULL CHECK (nro_suc > 0 AND nro_suc <= 999) NOT NULL,

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
	nro_trans INT(10) NOT NULL CHECK(nro_trans > 0 AND nro_trans <= 9999999999), 
	fecha DATE NOT NULL, 
	hora TIME NOT NULL, 
	monto DECIMAL(X,2) NOT NULL,
	
	CONSTRAINT pk_Transaccion
	PRIMARY KEY (nro_trans)

)ENGINE=InnoDB;


CREATE TABLE Transaccion_por_caja(
	nro_trans INT(10) NOT NULL CHECK(nro_trans > 0 AND nro_trans <= 9999999999), 
	cod_caja INT (5) NOT NULL CHECK(cod_caja > 0 AND cod_caja <= 99999), 

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
	nro_trans INT(10) NOT NULL CHECK(nro_trans > 0 AND nro_trans <= 9999999999), 	
	descripcion VARCHAR(45) NOT NULL, 
	nro_cliente INT NOT NULL CHECK (nro_cliente > 0 AND nro_cliente <= 99999),
	nro_ca INT NOT NULL CHECK (nro_ca > 0 AND nro_ca <= 99999999),
	
	CONSTRAINT pk_Debito
	PRIMARY KEY (nro_trans),
	
	CONSTRAINT FK_Debito_Transaccion
	FOREIGN KEY (nro_trans) REFERENCES Transaccion (nro_trans)
		ON DELETE RESTRICT ON UPDATE CASCADE
		
	CONSTRAINT FK_Debito_ClienteCA_Cliente
	FOREIGN KEY (nro_cliente) REFERENCES Cliente_CA (nro_cliente)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	
	CONSTRAINT FK_Debito_ClienteCA_CA
	FOREIGN KEY (nro_ca) REFERENCES Cliente_CA (nro_ca)
		ON DELETE RESTRICT ON UPDATE CASCADE

)ENGINE=InnoDB;



CREATE TABLE Deposito(
	nro_trans INT(10) NOT NULL CHECK(nro_trans > 0 AND nro_trans <= 9999999999), 
	nro_ca INT NOT NULL CHECK (nro_ca > 0 AND nro_ca <= 99999999),
	
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
	nro_trans INT(10) NOT NULL CHECK(nro_trans > 0 AND nro_trans <= 9999999999), 
	nro_cliente INT NOT NULL CHECK (nro_cliente > 0 AND nro_cliente <= 99999),
	nro_ca INT NOT NULL CHECK (nro_ca > 0 AND nro_ca <= 99999999),
		
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
	nro_trans INT(10) NOT NULL CHECK(nro_trans > 0 AND nro_trans <= 9999999999), 	
	nro_cliente INT NOT NULL CHECK (nro_cliente > 0 AND nro_cliente <= 99999), 
	origen_nroca INT NOT NULL CHECK (nro_ca > 0 AND nro_ca <= 99999999),
	destino_nroca INT NOT NULL CHECK (nro_ca > 0 AND nro_ca <= 99999999),
	
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


