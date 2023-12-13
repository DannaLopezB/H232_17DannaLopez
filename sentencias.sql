-- Poner en uso BD Master 
USE master;

-- Crear la base de datos db_bodegapanchita
IF DB_ID (N'db_bodegapanchita') IS NOT NULL
	DROP DATABASE db_bodegapanchita
GO
CREATE DATABASE db_bodegapanchita
GO

-- Poner es uso la base de datos db_bodegapanchita
USE db_bodegapanchita;

-- Cambiamos el idioma a español y ver si se cambio 
SET LANGUAGE Español;
SELECT @@language AS 'Idioma';
                      
					  
											----------------------------------------------------------
									     --------------------  T  A  B  L  A  S  -------------------------
											----------------------------------------------------------

------------<> MAESTROS

-- 01 Tabla client (Cliente)
CREATE TABLE client (
    id int IDENTITY (1,1),    --clave principal
    type_document char(3),    -- tipo de documento
    number_document char(15), -- numero de documento
    names varchar(60),        --nombres
    last_name varchar(90),    --apellidos
    email varchar(80),        --correo electronico   
    cell_phone char(9),       --numero de celular
    birthdate date ,          --fecha de nacimiento
    active char(1),           --estado
	CONSTRAINT client_pk PRIMARY KEY (id)
);

-- 02 Tabla seller (Vendedor)
CREATE TABLE seller (
    id int IDENTITY(1,1),      --clave principal
    type_document char(30),    --tipo de documento
    number_document char(15),  -- numero de documento
    names varchar(60),         --nombres
    last_name varchar(90),     --apellidos
	email varchar(80) ,        --correo electronico 
    cell_phone char(9),        --numero de celular
	salary decimal(8,2),       --salario
	users varchar(40),         -- usuaio
	passwords varchar(60),     --contraseña
    active char(1),            --estado
    CONSTRAINT seller_pk PRIMARY KEY  (id)
);

-- 03 Tabla ubigeo
CREATE TABLE ubigeo (
	id int IDENTITY(1,1),   --clave principal
	department varchar(60), --departamento
    province varchar(70),   --provincia
    district varchar(80),   --distrito
    CONSTRAINT ubigeo_pk PRIMARY KEY  (id) 
);

-- 04 Tabla supplier (Proveedor)
CREATE TABLE supplier (
    id int IDENTITY(1,1),     --clave principal
    ruc char(11),             --RUC    
    name_company varchar(90), --nombre de la empresa
    ubigeo_id int,             
    names varchar(60),        --nombres
    last_name varchar(80),    --apellidos
    email varchar(90),        --correo electronico
    cell_phone char(9),       --numero de celular
    active char(1),           -- estado
    CONSTRAINT supplier_pk PRIMARY KEY  (id)
);

-- 05 Tabla category_product (Categoria producto)
CREATE TABLE category_product (
    id int IDENTITY(1,1),     --clave principal
    name varchar(60),         --nombre
    description varchar(90),  -- descripcion de la categoria
	active char(1),           --estado
    CONSTRAINT category_product_pk PRIMARY KEY  (id)
);

-- 06 Tabla product (producto)
CREATE TABLE product (
    id int IDENTITY(1,1),         --clave principal
    name varchar(60) ,            --nombre
    category_product_id int,  
    price_purchase decimal(8,2),  --precio de compra
    price_sale decimal(8,2) ,     --precio de venta
    date_expiry date,             --fecha de caducidad del producto
    stock int,                    --stock del producto
	active char(1),               --estado
    CONSTRAINT product_pk PRIMARY KEY  (id)
);


------------<> TRANSACCIONALES

-- 07 Tabla purchase (compra)
CREATE TABLE purchase (
    id int IDENTITY(1,1),     --clave principal
    supplier_id int,         
    date_time datetime,       --fecha de la compra
    active char(1),           --estado
    CONSTRAINT purchase_pk PRIMARY KEY  (id)
);

-- 08 Tabla purchase_detail (compra_detalle)
CREATE TABLE purchase_detail (
    id int IDENTITY(1,1),  --clave principal
    product_id int,
    purchase_id int ,
    amount int ,           --cantidad
    CONSTRAINT purchase_detail_pk PRIMARY KEY  (id)
);

-- 09 Tabla sale (venta)
CREATE TABLE sale (
    id int IDENTITY(1,1),   --clave principal
    date_time datetime,     --fecha de la venta
    active char(1),         --estado    
    seller_id int,
    client_id int,
    CONSTRAINT sale_pk PRIMARY KEY  (id)
);

-- 10 Tabla sale_detail (venta_detalle)
CREATE TABLE sale_detail (
    id int IDENTITY(1,1),    --clave principal
    sale_id int,
    product_id int ,
    amount int ,             --cantidad
    CONSTRAINT sale_detail_pk PRIMARY KEY  (id)
);


                                             ----------------------------------------------------------
								 --------------------  R  E  S  T  R  I  C  C  I  O  N  E  S  -------------------------
											 ----------------------------------------------------------

----------<> Restricciones para la Tabla Client (Cliente)
-- Restricción para tipos de documento válidos (DNI o CNE)
ALTER TABLE client
    ADD CONSTRAINT chk_type_document_client CHECK(type_document ='DNI' OR type_document ='CNE');

-- Restricción para asegurar que el número de documento sea único
ALTER TABLE client
    ADD CONSTRAINT uq_number_document_client UNIQUE (number_document);

-- Restricción para asegurar que el nombre solo contenga letras y espacios
ALTER TABLE client
    ADD CONSTRAINT chk_names_client CHECK(names NOT LIKE '%[^a-zA-Z ]%');

-- Restricción para asegurar que el apellido solo contenga letras y espacios
ALTER TABLE client
    ADD CONSTRAINT chk_last_name_client CHECK(last_name NOT LIKE '%[^a-zA-Z ]%');

-- Restricción para asegurar un formato de correo electrónico básico
ALTER TABLE client
    ADD CONSTRAINT chk_email_client CHECK(email LIKE '%@%._%');

-- Restricción para asegurar un formato de número de teléfono básico
ALTER TABLE client
    ADD CONSTRAINT chk_cellphone_client CHECK (cell_phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

-- Restricción para asegurar que la fecha de nacimiento indique una edad mayor o igual a 18 años
ALTER TABLE client
    ADD CONSTRAINT chk_birthdate_client CHECK((YEAR(GETDATE()) - YEAR(birthdate)) >= 18);

-- Restricción para asignar un valor por defecto 'A' a la columna active
ALTER TABLE client
    ADD CONSTRAINT df_active_client DEFAULT('A') FOR active;


----------<> Restricciones para la Tabla seller (vendedor)
-- Restricción para tipos de documento válidos (DNI o CNE)
ALTER TABLE seller
    ADD CONSTRAINT chk_type_document_seller CHECK(type_document ='DNI' OR type_document ='CNE');

-- Restricción para asegurar que el número de documento sea único
ALTER TABLE seller
    ADD CONSTRAINT uq_number_document_seller UNIQUE (number_document);

-- Restricción para asegurar que el nombre solo contenga letras y espacios
ALTER TABLE seller
    ADD CONSTRAINT chk_names_seller CHECK(names NOT LIKE '%[^a-zA-Z ]%');

-- Restricción para asegurar que el apellido solo contenga letras y espacios
ALTER TABLE seller
    ADD CONSTRAINT chk_last_name_seller CHECK(last_name NOT LIKE '%[^a-zA-Z ]%');

-- Restricción para asegurar un formato de correo electrónico básico
ALTER TABLE seller
    ADD CONSTRAINT chk_email_seller CHECK(email LIKE '%@%._%');

-- Restricción para asegurar un formato de número de teléfono básico
ALTER TABLE seller
    ADD CONSTRAINT chk_cellphone_seller CHECK (cell_phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

-- Restricción para asignar un valor por defecto 'A' a la columna active
ALTER TABLE seller
    ADD CONSTRAINT df_active_seller DEFAULT('A') FOR active;

----------<> Restricciones para la Tabla supplier (proveedor)
-- Restricción para asegurar que el RUC tenga 11 caracteres
ALTER TABLE supplier
    ADD CONSTRAINT chk_ruc_supplier CHECK (LEN(ruc) = 11);

-- Restricción para asegurar que el RUC sea único
ALTER TABLE supplier
    ADD CONSTRAINT uq_ruc_supplier UNIQUE (ruc);

-- Restricción para asegurar que el nombre solo contenga letras
ALTER TABLE supplier
    ADD CONSTRAINT chk_names_supplier CHECK(names NOT LIKE '%[^a-zA-Z]%');

-- Restricción para asegurar que el apellido solo contenga letras
ALTER TABLE supplier
    ADD CONSTRAINT chk_last_name_supplier CHECK(last_name NOT LIKE '%[^a-zA-Z]%');

-- Restricción para asegurar un formato de correo electrónico básico
ALTER TABLE supplier
    ADD CONSTRAINT chk_email_supplier CHECK(email LIKE '%@%._%');

-- Restricción para asegurar un formato de número de teléfono básico
ALTER TABLE supplier
    ADD CONSTRAINT chk_cellphone_supplier CHECK (cell_phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

-- Restricción para asignar un valor por defecto 'A' a la columna active
ALTER TABLE supplier
    ADD CONSTRAINT df_active_supplier DEFAULT ('A') FOR active;

----------<> Restricciones para la Tabla category_product (categoria_producto)
-- Restricción para asignar un valor por defecto 'A' a la columna active
ALTER TABLE category_product
    ADD CONSTRAINT df_active_category_product DEFAULT ('A') FOR active;

----------<> Restricciones para la Tabla product (producto)
-- Restricción para asignar un valor por defecto 'A' a la columna active
ALTER TABLE product
    ADD CONSTRAINT df_active_product DEFAULT ('A') FOR active;

----------<> Restricciones para la Tabla purchase (compra)
-- Restricción para asignar un valor por defecto la fecha y hora actual a la columna date_time
ALTER TABLE purchase
    ADD CONSTRAINT df_date_time_purchase DEFAULT GETDATE() FOR date_time;

-- Restricción para asignar un valor por defecto 'A' a la columna active
ALTER TABLE purchase
    ADD CONSTRAINT df_active_purchase DEFAULT ('A') FOR active;

----------<> Restricciones para la Tabla purchase_detail (purchase_detail)
-- Restriccion para asegurar que el campo amount sera un valor positivo
ALTER TABLE purchase_detail
    ADD CONSTRAINT chk_amount_purchase_detail CHECK(amount > 0);

----------<> Restricciones para la Tabla sale (venta)
-- Restricción para asignar un valor por defecto la fecha y hora actual a la columna date_time
ALTER TABLE sale
    ADD CONSTRAINT df_date_time_sale DEFAULT GETDATE() FOR date_time;

-- Restricción para asignar un valor por defecto 'A' a la columna active
ALTER TABLE sale
    ADD CONSTRAINT df_active_sale DEFAULT ('A') FOR active;

----------<> Restricciones para la Tabla sale_detail (venta_detalle)
-- Restriccion para asegurar que el campo amount sera un valor positivo
ALTER TABLE sale_detail
    ADD CONSTRAINT chk_amount_sale_detail CHECK(amount > 0);


                                             ----------------------------------------------------------------------
									   ----------------------  R  E  L  A  C  I  O  N  E  S  ---------------------------
											 ----------------------------------------------------------------------

-- foreign keys

-- 1. Una categoria de producto puede estar en uno o varios productos
ALTER TABLE product 
	ADD CONSTRAINT product_category_product FOREIGN KEY (category_product_id)
    REFERENCES category_product (id);

-- 2. Un cliente puede realizar una o muchas ventas
ALTER TABLE sale 
	ADD CONSTRAINT sale_client FOREIGN KEY (client_id)
    REFERENCES client (id);

-- 3. Un vendedor puede realizar una o muchas ventas
ALTER TABLE sale 
	ADD CONSTRAINT sale_seller FOREIGN KEY (seller_id)
    REFERENCES seller (id);

-- 4. Un ubigeo puede estar en una o muhcos proveedores
ALTER TABLE supplier 
	ADD CONSTRAINT supplier_ubigeo FOREIGN KEY (ubigeo_id)
    REFERENCES ubigeo (id);

-- 5. Un proveedor puede realizar una o varias veces una compra
ALTER TABLE purchase 
	ADD CONSTRAINT purchase_supplier FOREIGN KEY (supplier_id)
    REFERENCES supplier (id);

-- 6. Una compra puede estar en una o muchas compras detalles
ALTER TABLE purchase_detail 
	ADD CONSTRAINT purchase_detail_purchase FOREIGN KEY (purchase_id)
    REFERENCES purchase (id);

-- 7. Un producto puede estar en una o muchas compras detalles
ALTER TABLE purchase_detail 
	ADD CONSTRAINT purchase_detail_product FOREIGN KEY (product_id)
    REFERENCES product (id);

-- 8. Un producto puede estar en uno o muchas ventas detalles
ALTER TABLE sale_detail 
	ADD CONSTRAINT sale_detail_product FOREIGN KEY (product_id)
    REFERENCES product (id);

-- 9. Una venta puede tener una o muchas ventas detalles
ALTER TABLE sale_detail 
	ADD CONSTRAINT sale_detail_sale FOREIGN KEY (sale_id)
    REFERENCES sale (id);


-- Poner es uso la base de datos db_bodegapanchita
USE db_bodegapanchita;

-- Cambiamos el idioma a español y ver si se cambio 
SET LANGUAGE Español;
SELECT @@language AS 'Idioma';

/* Ver formato de fecha y hora del servidor */
SELECT sysdatetime() as 'Fecha y  hora'
GO

/* Configurar el formato de fecha */
SET DATEFORMAT dmy
GO

-----------------------------------<>Script SQL de CRUD de datos de la tabla CLIENT

--Crear (Create):
-- Crear un nuevo cliente
INSERT INTO client(type_document, number_document, names, last_name, email, cell_phone, birthdate)
VALUES
('DNI', '78451233', 'Angel Gabriel', 'Castilla Sandoval', 'angel.castilla@gmail.com', '936609401', '2005/12/08'),
('DNI', '14782536', 'Fernando', 'Sandoval Medina', 'fernandosandovall@gmail.com', '952467996', '2004/12/30'),
('DNI', '78451236', 'Luis Alberto', 'Barrios Paredes', 'luisbarrios@outlook.com', '985414752', '1995/11/25'),
('CNE', '352514789', 'Claudia María', 'Martínez Rodríguez', 'claudiamartinez@yahoo.com', '995522147', '1992/10/23'),
('CNE', '142536792', 'Mario Tadeo', 'Farfán Castillo', 'mariotadeo@outlook.com', '973125478', '1997/12/30'),
('DNI', '58251433', 'Ana Lucrecia', 'Chumpitaz Prada', 'anachumpitaz@gmail.com', '982514361', '1995/12/25');

--Actualizar (Update):
-- Actualizar los datos de un cliente
UPDATE client
SET type_document = 'CNE', 
	number_document =  '263738461',
	names = 'Manuel Angel',
	last_name = 'Sandoval Medina',
	email = 'angel.gabriel@gmail.com',
	cell_phone = '913546486',
	birthdate= '05/08/2005'
WHERE id = 5;

--Eliminar (Delete):
-- ELIMINADO LOGICO CLIENTE 
UPDATE client
SET 
	active = 'I'
WHERE number_document = '58251433';

-- Leer (Read):
-- Leer todos los clientes
SELECT * FROM client;
-- Leer un cliente por su ID
SELECT * FROM client WHERE id = 1;
-- Leer los cliente inactivos
SELECT * FROM client WHERE active = 'I';

-----------------------------------<> Script SQL de CRUD de datos de la tabla seller(vendedor)

--Crear (Create):
-- Crear un nuevo seller((vendedor)
INSERT INTO seller(type_document, number_document, names, last_name, email, cell_phone, salary, users, passwords)
VALUES
('DNI', '11224578', 'Oscar', 'Paredes Flores', 'oparedes@miempresa.com', '985566251', '900.00', 'oscar', 'cazador'),
('CNE', '889922365', 'Azucena', 'Valle Alcazar', 'avalle@miempresa.com', '966338874', '800.00', 'angel', '1234'),
('DNI', '44771123', 'Rosario', 'Huarca Tarazona', 'rhuaraca@miempresa.com', '933665521', '1000.00', 'rosario', 'por100pre'),
('DNI', '76684851', 'Juan', 'Sandoval Kaira', 'juansandoval@miempresa.com', '998877665', '1025.00', 'juan', 'hastalavista'),
('DNI', '77224455', 'Azul', 'Valle Grande', 'azul@miempresa.com', '978527842', '800.00', 'azul', 'turuleka'),
('DNI', '73812354', 'Nicole', 'Hernandez Coyantes', 'nhernandez@miempresa.com', '982634718', '900.00', 'nicole', 'noimporta');

--Actualizar (Update):
-- Actualizar los datos de un cliente
UPDATE seller
SET type_document = 'CNE', 
	number_document =  '263738461',
	names = 'Manuel Angel',
	last_name = 'Sandoval Medina',
	email = 'angel.gabriel@gmail.com',
	cell_phone = '913546486',
	salary = '1000.00'
WHERE id = 5;

--Eliminar (Delete):

-- ELIMINADO LOGICO SELLER(VENDEDOR)
UPDATE seller
SET 
	active = 'I'
WHERE number_document = '73812354';

-- Leer (Read):
-- Leer todos los selller()
SELECT * FROM seller;
-- Leer un vededor por su ID
SELECT * FROM seller WHERE id = 1;
-- Leer los vendedores inactivos
SELECT * FROM seller WHERE active = 'I';


-----------------------------------<> Script SQL de CRUD de datos de la tabla category_product(categoria de productos)
--Crear (Create):
--insertar registros
INSERT INTO dbo.category_product 
(name, description)
VALUES
('Bebidas', 'Refrescos, jugos y bebidas embotelladas'),
('Productos enlatados', 'Alimentos enlatados como sopas y vegetales'),
('lacteos', 'Leche, queso y productos lácteos'),
('carnes', 'Productos cárnicos frescos y procesados'),
('productos de limpieza', 'productos que eliminan suciedad, polvo, manchas y germnes del hogar o entorno');

--Actualizar (Update):
-- Actualizar los datos de un cliente
UPDATE category_product
SET name = 'lacteós'
WHERE id = 3;

--Eliminar (Delete):
--eliminado logico
UPDATE category_product
SET 
	active = 'I'
WHERE name = 'Bebidas';

-- Leer (Read):
--Listar
select*from category_product;


-----------------------------------<>  Script SQL de CRUD de datos de la tabla product(productos)
--Crear (Create):
--insertar registros
INSERT INTO dbo.product 
(name, category_product_id, price_purchase, price_sale, date_expiry, stock)
VALUES
    ('Coca-Cola', 1, 0.50, 1.00, '2023-12-31', 100),
    ('Atun florida', 2, 3.50, 5.00, '2023-09-30', 50),
    ('leche gloria', 3, 1.20, 2.00, '2024-06-30', 80),
    ('Jamonada', 4, 1.80, 2.50, '2023-11-15', 60),
    ('Jabon', 5, 0.75, 1.25, '2023-09-25', 120);


--eliminado logico
UPDATE product
SET 
	active = 'I'
WHERE name = 'Coca-Cola';

--listar productos
select id, name, category_product_id, price_purchase, price_sale, date_expiry, stock, active from product;

--listar con joins
SELECT 
    p.id, 
    p.name AS product_name,
    cp.name AS category_name, 
    p.price_purchase, 
    p.price_sale, 
    p.date_expiry, 
    p.stock, 
    p.active
FROM 
    product p
JOIN 
    category_product cp ON p.category_product_id = cp.id;


----------------------------------------------------------------------------------------------------------------------
----------------------------------<<<<<<<<<<<<< T R A N S A C C I O N A L E S >>>>>>>>>>>>

-----------------------------------<> Script SQL de CRUD de datos de la tabla sale (venta)
-- Insertar datos en la tabla sale (venta)
INSERT INTO sale (seller_id, client_id)
VALUES
(1, 1),  -- Venta 1
(2, 2),  -- Venta 2
(3, 3);  -- Venta 3

--------<> Script SQL de CRUD de datos de la tabla sale_detail (venta_detalle)

-- Insertar datos en la tabla sale_detail (venta_detalle)
INSERT INTO sale_detail 
	(sale_id, product_id, amount)
VALUES
-- Detalles para la Venta 1
(1, 1, 5),  -- 5 unidades de Coca-Cola
(1, 2, 2),  -- 2 unidades de Atun Florida

-- Detalles para la Venta 2
(2, 3, 3),  -- 3 unidades de Leche Gloria
(2, 4, 1),  -- 1 unidad de Jamonada

-- Detalles para la Venta 3
(3, 5, 10); -- 10 unidades de Jabón


-- Verificar los datos insertados
SELECT * FROM sale;
SELECT * FROM sale_detail;


---------------------------------<<<<<<<<<	Indices >>>>>>>>>>>>>
-- Indice no agrupado en la tabla client para el campo names
CREATE NONCLUSTERED INDEX idx_names ON client(names);
select*from client order by names;
SELECT id, type_document, number_document, names, last_name, email, cell_phone, birthdate FROM client WHERE active='A' ORDER BY names;


---------------------------------<<<<<<<<<	Consultas con joins >>>>>>>>>>>>>
--------<> Consulta con JOINs en la tabla sale (venta)
-- Selecciona información específica de la tabla sale y agrega detalles de vendedor y cliente
SELECT
    s.id AS sale_id,                  --Identificador único de la venta
    s.date_time AS Fecha,             --Fecha de la venta
    s.active AS Estado,               --Estado
    se.names AS Vendedor,             --Nombre del Vendedor
    cl.names AS Cliente               --Nombre del Cliente
FROM
    sale s                            -- Alias 's' para la tabla 'sale'
JOIN
    seller se ON s.seller_id = se.id  -- Realiza un JOIN con la tabla 'seller' para obtener información del vendedor
JOIN
    client cl ON s.client_id = cl.id  -- Realiza un JOIN con la tabla 'client' para obtener información del cliente;


--------<> Consulta con JOINs en la tabla sale_detail (venta_detalle)
-- Selecciona información específica de la tabla sale_detail y agrega detalles de la sale(venta) y del producto.
SELECT
    sd.id AS ID,
    s.id AS sale_id,
    p.name AS Producto,
    sd.amount AS Cantidad
FROM 
    sale_detail sd                     -- Alias 'sd' para la tabla 'sale_detail'
JOIN 
    sale s ON sd.sale_id = s.id        -- Realiza un JOIN con la tabla 'sale' para obtener informacion de la venta
JOIN 
    product p ON sd.product_id = p.id; -- Realiza un JOIN con la tabla 'product' para obtener información del producto


--------<> Consulta con JOINs en la tabla sale_detail (venta_detalle)
-- Selecciona información específica de la tabla sale_detail y agrega detalles de la sale(venta), cliente, vendedor y del producto.
SELECT
    sd.id AS ID,
    s.id AS sale_id,
    c.names AS Cliente,
    se.names AS Vendedor,
    p.name AS Producto,
    sd.amount AS Cantidad,
    p.price_sale AS Precio,
    (sd.amount * p.price_sale) AS 'Precio Total' 
FROM 
    sale_detail sd                     -- Alias 'sd' para la tabla 'sale_detail'
JOIN 
    sale s ON sd.sale_id = s.id        -- Realiza un JOIN con la tabla 'sale' para obtener informacion de la venta
JOIN 
    client c ON s.client_id = c.id     -- Realiza un JOIN con la tabla client utilizando el campo client_id de sale y el id de client
JOIN 
    seller se ON s.seller_id = se.id   -- Realiza un JOIN con la tabla seller utilizando el campo seller_id de sale y el id de seller
JOIN 
    product p ON sd.product_id = p.id; -- Realiza un JOIN con la tabla 'product' para obtener información del producto


--------<> Consulta con JOINs en la tabla sale (venta)
-- Consulta para obtener el precio total a pagar por cada venta, agrupado por venta, cliente y vendedor
SELECT
    s.id AS sale_id,               
    se.names AS Vendedor,    
    c.names AS Cliente,        
    SUM(sd.amount * p.price_sale) AS 'Precio total a pagar'  -- Calcula el precio total a pagar por cada grupo de venta
FROM
    sale s                                -- Alias 's' para la tabla 'sale'
JOIN
    seller se ON s.seller_id = se.id      -- Realiza un JOIN con la tabla 'seller' para obtener información del vendedor
JOIN
    client c ON s.client_id = c.id        -- Realiza un JOIN con la tabla 'client' para obtener información del cliente;
JOIN
    sale_detail sd ON s.id = sd.sale_id   -- Realiza un JOIN con la tabla sale_detail utilizando el campo id de sale y el sale_id de sale_detail
JOIN
    product p ON sd.product_id = p.id  -- Realiza un JOIN con la tabla product utilizando el campo product_id de sale_detail y el id de product
GROUP BY
    s.id, c.names, se.names;          -- Agrupa los resultados por el identificador de venta, el nombre del cliente y el nombre del vendedor



--insercion de 5 registros
-- Insertar registros en la tabla miTabla
INSERT INTO miTabla (columna1, columna2, columna3) VALUES
('valor1_1', 'valor1_2', 'valor1_3'),
('valor2_1', 'valor2_2', 'valor2_3'),
('valor3_1', 'valor3_2', 'valor3_3'),
('valor4_1', 'valor4_2', 'valor4_3'),
('valor5_1', 'valor5_2', 'valor5_3');

--insercion de 10 registros
-- Insertar 10 registros en la tabla miTabla
INSERT INTO miTabla (columna1, columna2, columna3) VALUES
('valor1_1', 'valor1_2', 'valor1_3'),
('valor2_1', 'valor2_2', 'valor2_3'),
('valor3_1', 'valor3_2', 'valor3_3'),
('valor4_1', 'valor4_2', 'valor4_3'),
('valor5_1', 'valor5_2', 'valor5_3'),
('valor6_1', 'valor6_2', 'valor6_3'),
('valor7_1', 'valor7_2', 'valor7_3'),
('valor8_1', 'valor8_2', 'valor8_3'),
('valor9_1', 'valor9_2', 'valor9_3'),
('valor10_1', 'valor10_2', 'valor10_3');

--actualizacion
UPDATE miTabla
SET columna2 = 'nuevo_valor'
WHERE ID = 1;

--eliminado logico
UPDATE miTabla
SET eliminado = 1
WHERE ID = 2;

--listado
SELECT * FROM miTabla;

--Supongamos que tienes una tabla miTabla con una columna edad, y deseas obtener registros cuya edad esté entre 18 y 30 años:
SELECT *
FROM miTabla
WHERE edad BETWEEN 18 AND 30;

--Supongamos que deseas encontrar registros en una tabla empleados cuyo nombre empiece con "A":
SELECT *
FROM empleados
WHERE nombre LIKE 'A%';
--Supongamos que tienes una tabla productos y deseas obtener registros de productos con ciertos IDs específicos:
SELECT *
FROM productos
WHERE id_producto IN (1, 3, 5) AND categoria = 'Electrónicos';

--Este procedimiento verifica si un estudiante tiene permiso para matricularse en un curso específico. 
--Se utiliza un bloque IF para evaluar la condición.
CREATE PROCEDURE VerificarMatricula
    @idEstudiante INT,
    @idCurso INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Matriculas WHERE idEstudiante = @idEstudiante AND idCurso = @idCurso)
    BEGIN
        PRINT 'El estudiante tiene permiso para matricularse en el curso.';
    END
    ELSE
    BEGIN
        PRINT 'El estudiante no tiene permiso para matricularse en el curso.';
    END
END;

--Este procedimiento aplica un descuento a una venta según el tipo de cliente. Se utiliza una estructura CASE para determinar el descuento.
CREATE PROCEDURE ProcesarVenta
    @idCliente INT,
    @montoVenta DECIMAL(10, 2)
AS
BEGIN
    DECLARE @descuento DECIMAL(10, 2);

    SELECT @descuento = 
        CASE 
            WHEN TipoCliente = 'VIP' THEN 0.15
            WHEN TipoCliente = 'Regular' THEN 0.1
            ELSE 0
        END
    FROM Clientes
    WHERE idCliente = @idCliente;

    SET @montoVenta = @montoVenta - (@montoVenta * @descuento);

    PRINT 'Monto de venta después del descuento: ' + CONVERT(VARCHAR, @montoVenta);--La función CONVERT en SQL Server se utiliza para convertir un valor de un tipo de datos a otro.
END;

--Procedimiento para realizar múltiples ventas hasta alcanzar un límite de cantidad:
--Este procedimiento realiza ventas repetidas hasta alcanzar un límite de cantidad. Se utiliza un bucle WHILE para realizar ventas sucesivas.

CREATE PROCEDURE RealizarVentasHastaLimite
    @limiteVentas INT
AS
BEGIN
    DECLARE @contador INT = 1;
    DECLARE @montoVenta DECIMAL(10, 2);

    WHILE @contador <= @limiteVentas
    BEGIN
        SET @montoVenta = RAND() * 1000; -- Monto de venta aleatorio entre el 0 y 1
        PRINT 'Venta #' + CONVERT(VARCHAR, @contador) + ': ' + CONVERT(VARCHAR, @montoVenta);
        SET @contador = @contador + 1;
    END
END;



/*

-- Índice no agrupado para la tabla client en la columna number_document
CREATE NONCLUSTERED INDEX idx_number_document_client
ON client (number_document);

-- Índice no agrupado para la tabla product en la columna name
CREATE NONCLUSTERED INDEX idx_name_product
ON product (name);

*/