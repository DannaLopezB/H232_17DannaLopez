create database bd_Jas_Digital;

-- Poner es uso la base de datos bd_JasDigital
USE bd_Jas_Digital;

-- Cambiamos el idioma a español y ver si se cambio 
SET LANGUAGE Español;
SELECT @@language AS 'Idioma';
                      
---CREACION DE TABLAS---

	-----------<>MAESTRO1<>-----------
	-- TABLA: BIEN
 	CREATE TABLE ESTATE (
		Amount int  NOT NULL,
		Code varchar(6)  NOT NULL,
		Details varchar(1000)  NOT NULL,
		Value decimal(8,2)  NOT NULL,
		Admission_date date  NOT NULL,
		Depreciation_Date date  NOT NULL,
		Annual_Depreciation decimal(8,2)  NOT NULL,
		Monthly_Depreciation decimal(8,2)  NOT NULL,
		Accumulated_Depreciation decimal(8,2)  NOT NULL,
		Status int  NOT NULL,
		AREA_ID int  NOT NULL,
		CONSTRAINT ESTATE_pk PRIMARY KEY  (Amount)
	);
	
	select*from ESTATE;

	-----------<>TRANSACIONAL<>-----------
	-- Tabl: AREA
		CREATE TABLE AREA (
			ID int  NOT NULL,
			Name_Area varchar(50)  NOT NULL,
			Last_name varchar(50)  NOT NULL,
			Name varchar(50)  NOT NULL,
			Staff_ID int  NOT NULL,
			CONSTRAINT AREA_pk PRIMARY KEY  (ID)
		);
	select*from AREA;

	-- Table: Personal
	CREATE TABLE Staff (
		ID int  NOT NULL,
		Names varchar(100)  NOT NULL,
		last_names varchar(100)  NOT NULL,
		type_document char(30),
		number_document char(15),
		Phone char(9)  NOT NULL,
		Birth_date date  NOT NULL,
		Status varchar(10)  NOT NULL,
		CONSTRAINT Staff_pk PRIMARY KEY  (ID)
	);
	select*from Staff;

---RELACIONES DE TABLAS---

	-- Reference: AREA_Staff (table: AREA)
	ALTER TABLE AREA ADD CONSTRAINT AREA_Staff
		FOREIGN KEY (Staff_ID)
		REFERENCES Staff (ID);

	-- Reference: ESTATE_AREA (table: ESTATE)
	ALTER TABLE ESTATE ADD CONSTRAINT ESTATE_AREA
		FOREIGN KEY (AREA_ID)
		REFERENCES AREA (ID);