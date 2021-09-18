USE banco;

#------------------------------CARGA DE DATOS-------------------------------------#

#--------------Ciudad (cod_postal, nombre)-------------#

INSERT INTO Ciudad VALUES (1000,"Londres");
INSERT INTO Ciudad VALUES (2000,"Amsterdam");
INSERT INTO Ciudad VALUES (3000,"Berlin");
INSERT INTO Ciudad VALUES (7600,"Roma");
INSERT INTO Ciudad VALUES (1289,"Tokio");


#-------------Sucursal (nro_suc, nombre, direccion, telefono, horario, cod_postal)-----------#

INSERT INTO Sucursal VALUES (001, "Sucursal 1", "Sarmiento 1100", "24458669317", "9 a 16", 7600);
INSERT INTO Sucursal VALUES (002, "Sucursal 2", "Alvear 1509", "23145659878", "9 a 20", 1000);
INSERT INTO Sucursal VALUES (003, "Sucursal 3", "Entre Rios 201", "11256887745", "14 a 21", 1289)
INSERT INTO Sucursal VALUES (004, "Sucursal 4", "Alsina 110", "29255887744", "12 a 18", 3000);
INSERT INTO Sucursal VALUES (005, "Sucursal 5", "Dorrego 200", "29145545478", "8 a 12", 2000);


#----------------Empleado (legajo, apellido, nombre, tipo_doc, nro_doc, direccion, telefono, cargo, password, nro_suc) *FK_Empleado_Sucursal*-------------------#

INSERT INTO Empleado VALUES (1219, "Arena", "Camila", "DNI", 42117020, "Ayacucho 1200", "2914139035", "Gerente", md5('999'), 001);
INSERT INTO Empleado VALUES (2345, "Carreño", "Guadalupe", "DNI", 42556780, "Brasil 900", "2916670987", "Directora de Area de Ventas", md5('559'), 002);
INSERT INTO Empleado VALUES (6722, "Rodriguez", "Leonardo", "L.E", 20987657, "Alsina 1200", "291558877", "Cajero", md5('443'), 001);
INSERT INTO Empleado VALUES (1177, "Geertsen", "Joan", "DNI", 42345676, "Dorrego 220", "291659832", "Cajero", md5('677'), 003);
INSERT INTO Empleado VALUES (9007, "Alonso", "Julieta", "L.E", 41446688, "Zapiola 500", "291784512", "Cajero", md5('355'), 004);


#----------------Cliente (nro_cliente, apellido, nombre, tipo_doc, nro_doc, direccion, telefono, fecha_nac)-------------------#

INSERT INTO Cliente VALUES (12345, "Juarez", "Juan", "DNI", 45237856, "Mitre 38", "11345678", "2000/03/05");
INSERT INTO Cliente VALUES (00005, "Properzi", "Matias", "L.E", 40868775, "Alem 3500", "48886558", "1999/08/03");
INSERT INTO Cliente VALUES (27009, "Gonzales", "Graciela", "DNI", 34511622, "12 de Octube 998", "4514477", "1998/05/11");
INSERT INTO Cliente VALUES (00003, "Diaz", "Valentina", "L.E", 45237856, "Carriego 334", "291457899", "1996/10/07");
INSERT INTO Cliente VALUES (11009, "Larsen", "Martin", "DNI", 45237856, "Sarmiento 226", "299587412", "1990/12/25");


#----------------Plazo Fijo (nro_plazo, capital, fecha_inicio, fecha_fin, tasa_interes, interes, nro_suc) *FK_PlazoFijo_Sucursal*-------------------#

INSERT INTO Plazo_Fijo VALUES (00000039, 0033157.00, "2007/07/16", "2007/08/08", 10.00, 001);
INSERT INTO Plazo_Fijo VALUES (00004456, 1000000.44, "2021/10/15", "2022/01/01", 10.00, 005);
INSERT INTO Plazo_Fijo VALUES (00112245, 0045678.03, "2021/02/04", "2021/08/04", 10.00, 003);
INSERT INTO Plazo_Fijo VALUES (00000001, 0555679.50, "2020/01/01", "2021/01/08", 10.00, 003);
INSERT INTO Plazo_Fijo VALUES (00000006, 5119045.10, "1995/11/12", "1997/11/12", 10.00, 002);


#---------------Tasa Plazo Fijo(periodo, monto_inf, monto_sup, tasa)------------#

INSERT INTO Plazo_Fijo VALUES (000, 0003455.55, 0005000.00, 05.00);
INSERT INTO Plazo_Fijo VALUES (001, 0005000.50, 0007500.00, 15.00);
INSERT INTO Plazo_Fijo VALUES (011, 0700050.10, 0800000.00, 20.00);
INSERT INTO Plazo_Fijo VALUES (005, 9500000.00, 1000000.00, 10.00);
INSERT INTO Plazo_Fijo VALUES (009, 1000000.00, 2000000.00, 10.00);


#---------------Plazo Cliente (nro_plazo, nro_cliente) *FK_Plazo_Cliente_Plazo_Fijo* *FK_Plazo_Cliente_Cliente*------------#

INSERT INTO Plazo_Fijo VALUES (00000039, 12345);
INSERT INTO Plazo_Fijo VALUES (00004456, 00005);
INSERT INTO Plazo_Fijo VALUES (00112245, 27009);
INSERT INTO Plazo_Fijo VALUES (00000001, 00003);
INSERT INTO Plazo_Fijo VALUES (00000006, 11009);


#---------------Prestamo (nro_prestamo, fecha, cant_meses, monto, tasa_interes, interes, valor_cuota, legajo, nro_cliente) *FK_Prestamo_Empleado* *FK_Prestamo_Cliente*------------#

INSERT INTO Prestamo VALUES (00000001, "1984/09/21", 12, 0000556.90, 07.00, 0010.00, 05000.00, 1219, 12345);
INSERT INTO Prestamo VALUES (00000002, "2008/03/15", 01, 0200550.00, 10.00, 0015.00, 01000.00, 2345, 00005);
INSERT INTO Prestamo VALUES (00000100, ,"1985/03/20", 05, 1000000.00, 45.00, 0020.00, 01500.00, 6722, 27009);
INSERT INTO Prestamo VALUES (56783455, "1984/09/21", 10, 0004000.50, 15.00, 0010.00, 02000.00, 1177, 00003);
INSERT INTO Prestamo VALUES (00044009, "2021/05/16", 11, 0300700.50, 20.00, 0020.00, 02500.00, 9007, 11009);


#---------------Pago (nro_prestamo, nro_pago, fecha_venc, fecha_pago) *FK_Pago_Prestamo*--------------#

INSERT INTO Pago VALUES (00000001, 01, "2021/08/04", "2020/07/05");
INSERT INTO Pago VALUES (00000002, 02, "2021/09/01", "2021/11/10");
INSERT INTO Pago VALUES (00000100, 03, "2018/10/12", "2020/12/23");
INSERT INTO Pago VALUES (56783455, 04, "1990/08/15", "1999/09/12");
INSERT INTO Pago VALUES (00044009, 05, "2000/07/07", "2001/08/01");


#---------------Tasa Prestamo (periodo, monto_inf, monto_sup, tasa)--------------#

INSERT INTO Tasa_Prestamo VALUES (001, 0010000.00, 1000000.00, 10.00);
INSERT INTO Tasa_Prestamo VALUES (001, 0005000.00, 0010000.00, 15.00);
INSERT INTO Tasa_Prestamo VALUES (001, 0008000.00, 1000000.00, 70.00);
INSERT INTO Tasa_Prestamo VALUES (001, 0000500.00, 0010000.00, 50.00);
INSERT INTO Tasa_Prestamo VALUES (001, 0800000.00, 9000000.00, 25.00);


#---------------Caja Ahorro (nro_ca, CBU, saldo)---------------#

INSERT INTO Caja_Ahorro VALUES (19577834, 222888333777666555, 00034500,00);
INSERT INTO Caja_Ahorro VALUES (00001165, 100055214788855566, 00555000,00);
INSERT INTO Caja_Ahorro VALUES (02007735, 000000111547126598, 00034500,50);
INSERT INTO Caja_Ahorro VALUES (00115005, 002548881122963258, 12500500,70);
INSERT INTO Caja_Ahorro VALUES (00112355, 789550002502001000, 00700500,10);


#---------------Cliente CA (nro_cliente, nro_ca) *FK_Cliente_CA_Cliente* *FK_Cliente_CA_Caja_Ahorro*---------------#

INSERT INTO Cliente_CA VALUES (12345, 19577834); 
INSERT INTO Cliente_CA VALUES (00005, 00001165); 
INSERT INTO Cliente_CA VALUES (27009, 02007735); 
INSERT INTO Cliente_CA VALUES (00003, 00115005); 
INSERT INTO Cliente_CA VALUES (11009, 00112355); 


#---------------Tarjeta (nro_tarjeta, PIN, CVT, fecha_venc, nro_cliente, nro_ca) *FK_Tarjeta_Cliente* *FK_Tarjeta_Caja_Ahorro*---------------#

INSERT INTO Tarjeta VALUES (3456902145006312, md5('11111111111111111111111111111111'), md5('22222222222222222222222222222222'), "2025/12/31", 00012345, 19577834); 
INSERT INTO Tarjeta VALUES (2345678932012368, md5('33333333333333333333333333333333'), md5('44444444444444444444444444444444'), "2033/01/15", 00005, 00001165); 
INSERT INTO Tarjeta VALUES (4508763214567890, md5('55555555555555555555555555555555'), md5('66666666666666666666666666666666'), "2030/04/28", 27009, 02007735); 
INSERT INTO Tarjeta VALUES (1234567890987654, md5('77777777777777777777777777777777'), md5('88888888888888888888888888888888'), "2021/12/27", 00003, 00115005); 
INSERT INTO Tarjeta VALUES (8765432109876543, md5('99999999999999999999999999999999'), md5('01111111111111111111111111111111'), "2042/05/02", 11009, 00112355); 


#---------------Caja(cod_caja)---------------#

INSERT INTO Caja VALUES(12345);
INSERT INTO Caja VALUES(10000);
INSERT INTO Caja VALUES(02000);
INSERT INTO Caja VALUES(00030);
INSERT INTO Caja VALUES(00004);


#---------------Ventanilla(cod_caja, nro_suc)*FK_Ventanilla_Caja* *FK_Ventanilla_Sucursal*---------------#

INSERT INTO Ventanilla VALUES(12345, 001);
INSERT INTO Ventanilla VALUES(10000, 002);
INSERT INTO Ventanilla VALUES(02000, 003);
INSERT INTO Ventanilla VALUES(00030, 004);
INSERT INTO Ventanilla VALUES(00004, 005);


#---------------ATM(cod_caja, cod_postal, direccion)*FK_ATM_Caja* *FK_ATM_Cicudad*---------------#

INSERT INTO ATM VALUES(00112355, 1000, "Brasil 189");
INSERT INTO ATM VALUES(19577834, 1289, "Avenida Alem 700");
INSERT INTO ATM VALUES(00001165, 3000, "Holdich 1950");
INSERT INTO ATM VALUES(02007735, 7600, "Sarmiento 500");
INSERT INTO ATM VALUES(00115005, 2000, "Zapiola 36");


#---------------Transaccion(nro_trans, fecha, hora, monto)---------------#

#INFO PARA TRANSACCION (suponiendo que las transacciones puedan existir sin ser debito, caja, deposito, extraccion o transferencia)
INSERT INTO Transaccion VALUES(1010106789, "2021/09/15", "12:35:56", 12389.25);
INSERT INTO Transaccion VALUES(8765432106, "2020/04/04", "08:03:02", 3221456.00);
INSERT INTO Transaccion VALUES(1234567890, "2019/10/07", "20:50:13", 100250.00);
INSERT INTO Transaccion VALUES(9987654321, "2021/01/28", "23:00:19", 17500.50);
INSERT INTO Transaccion VALUES(7786543217, "2022/12/19", "15:20:25", 2500.25);

#INFO PARA DEBITO
INSERT INTO Transaccion VALUES(0000000001, "2021/08/10", "10:40:00", 24560.00);
INSERT INTO Transaccion VALUES(0000000002, "2020/10/11", "12:23:34", 2000100.00);
INSERT INTO Transaccion VALUES(0000000003, "2019/03/25", "14:12:50", 107050.00);
INSERT INTO Transaccion VALUES(0000000004, "2021/12/20", "16:25:47", 1500.25);
INSERT INTO Transaccion VALUES(0000000005, "2022/07/09", "06:57:21", 568000.00);

#INFO PARA TRANSACCION POR CAJA
INSERT INTO Transaccion VALUES(0000000009, "2025/10/06", "09:00:12", 2756.50);
INSERT INTO Transaccion VALUES(0000000006, "2024/08/13", "08:03:02", 850250.00);
INSERT INTO Transaccion VALUES(0000000008, "2021/06/09", "20:50:13", 17890.00);
INSERT INTO Transaccion VALUES(0000000019, "2020/03/20", "23:00:19", 34270.75);
INSERT INTO Transaccion VALUES(0000000007, "2022/11/30", "15:20:25", 7865900.00);


#---------------Débito(nro_trans, descripción, nro_cliente, nro_ca)*FK_Debito_Transaccion* *FK_Debito_ClienteCA_Cliente* *FK_Debito_ClienteCA_CA*---------------#

INSERT INTO Debito VALUES(0000000001, "Alquiler de Julio 2021.", 11009, 02007735);
INSERT INTO Debito VALUES(0000000002, "Compra terreno.", 27009, 19577834);
INSERT INTO Debito VALUES(0000000003, "Pago cuota auto.", 00005, 00115005);
INSERT INTO Debito VALUES(0000000004, "Pago de la luz.", 00003, 00001165);
INSERT INTO Debito VALUES(0000000005, "Compra pasajes.", 12345, 00112355);


#---------------Transaccion_por_caja(nro_trans, cod_caja)*FK_TransPorCaja_Transaccion* *FK_TransPorCaja_Caja*---------------#

INSERT INTO Transaccion_por_caja VALUES(0000000009, 00112355);
INSERT INTO Transaccion_por_caja VALUES(0000000006, 19577834);
INSERT INTO Transaccion_por_caja VALUES(0000000008, 00001165);
INSERT INTO Transaccion_por_caja VALUES(0000000019, 00115005);
INSERT INTO Transaccion_por_caja VALUES(0000000007, 02007735);

#INFO PARA DEPOSITO
INSERT INTO Transaccion_por_caja VALUES(0000000089, 00004);
INSERT INTO Transaccion_por_caja VALUES(0000000106, 00030);
INSERT INTO Transaccion_por_caja VALUES(0000000890, 10000);
INSERT INTO Transaccion_por_caja VALUES(0000000021, 12345);
INSERT INTO Transaccion_por_caja VALUES(0000000217, 02000);

#INFO PARA EXTRACCION
INSERT INTO Transaccion_por_caja VALUES(1000000000, 02000);
INSERT INTO Transaccion_por_caja VALUES(2000000000, 12345);
INSERT INTO Transaccion_por_caja VALUES(3000000000, 10000);
INSERT INTO Transaccion_por_caja VALUES(4000000000, 00030);
INSERT INTO Transaccion_por_caja VALUES(5000000000, 00004);

#INFO PARA TRANSFERENCIA
INSERT INTO Transaccion_por_caja VALUES(4500000000, 10000);
INSERT INTO Transaccion_por_caja VALUES(8700000000, 12345);
INSERT INTO Transaccion_por_caja VALUES(1200000000, 02000);
INSERT INTO Transaccion_por_caja VALUES(9900000000, 00030);
INSERT INTO Transaccion_por_caja VALUES(7780000000, 00004);

#---------------Deposito(nro_trans, nro_ca)*FK_Deposito_TransPorCaja* *FK_Deposito_Caja*---------------#

INSERT INTO Deposito VALUES(0000000089, 00112355);
INSERT INTO Deposito VALUES(0000000106, 19577834);
INSERT INTO Deposito VALUES(0000000890, 00001165);
INSERT INTO Deposito VALUES(0000000021, 00115005);
INSERT INTO Deposito VALUES(0000000217, 02007735);


#---------------Extraccion(nro_trans, nro_cliente, nro_ca)*FK_Extraccion_TransPorCaja* *FK_Extraccion_ClienteCA_Cliente* *FK_Extraccion_ClienteCA_CA*---------------#

INSERT INTO Extraccion VALUES(1000000000, 12345, 19577834);
INSERT INTO Extraccion VALUES(2000000000, 00005, 00001165);
INSERT INTO Extraccion VALUES(3000000000, 27009, 02007735);
INSERT INTO Extraccion VALUES(4000000000, 00003, 00115005);
INSERT INTO Extraccion VALUES(5000000000, 11009, 00112355);

#---------------Transferencia(nro_trans, nro_cliente, origen, destino)*FK_Transferencia_TransPorCaja* *FK_Transferencia_ClienteCA_Cliente* *FK_Transferencia_ClienteCA_Origen* *FK_Transferencia_CA_Destino*---------------#

INSERT INTO Transferencia VALUES(4500000000, 11009, 00112355, 19577834);
INSERT INTO Transferencia VALUES(8700000000, 00003, 00115005, 02007735);
INSERT INTO Transferencia VALUES(1200000000, 27009, 02007735, 00001165);
INSERT INTO Transferencia VALUES(9900000000, 00005, 00001165, 00112355);
INSERT INTO Transferencia VALUES(7780000000, 12345, 19577834, 00115005);








