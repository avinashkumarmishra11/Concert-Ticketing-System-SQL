
/* DROP statements to clean up objects from previous run */
-- Triggers
DROP TRIGGER TRG_ARTIST;
DROP TRIGGER TRG_CONCERT;
DROP TRIGGER TRG_TICKETS;
DROP TRIGGER TRG_TICKET_CATEGORY;
DROP TRIGGER TRG_ORDER_DETAILS;
DROP TRIGGER TRG_CUSTOMER;

-- Sequences

DROP SEQUENCE SEQ_CONCERT_concert_id;
DROP SEQUENCE SEQ_TICKETS_ticket_id;
DROP SEQUENCE SEQ_ORDER_DETAILS_order_no;
DROP SEQUENCE SEQ_CUSTOMER_customer_id;

-- Views
DROP VIEW ARTISTInfo;
DROP VIEW CONCERTInfo;
DROP VIEW TICKETSInfo;
DROP VIEW CUSTOMERInfo;

-- Indices

DROP INDEX IDX_customer_name ;
DROP INDEX IDX_order_no;
DROP INDEX IDX_Order_Details_customer_id_FK ;

DROP INDEX IDX_Tickets_ticket_id;
DROP INDEX IDX_Tickets_concert_id_FK;
DROP INDEX IDX_Tickets_tkt_category_id_FK;
DROP INDEX IDX_Tickets_serial_no;

DROP INDEX IDX_Ticket_Category_ticket_id_FK;
DROP INDEX IDX_Ticket_Category_price;
DROP INDEX IDX_Ticket_Category_description;

DROP INDEX IDX_Concert_concert_name;
DROP INDEX IDX_Concert_concert_venue;
DROP INDEX IDX_Concert_concert_date;
DROP INDEX IDX_IDX_Concert_artist_id_FK ;

DROP INDEX IDX_Artist_genre_id;
DROP INDEX IDX_Artist_concert_id_FK;
DROP INDEX IDX_Artist_Artist_name;
DROP INDEX IDX_Artist_genre;

--Drop Primary Keys
ALTER TABLE ARTIST DROP Constraint PK_Artist CASCADE;
ALTER TABLE CONCERT DROP Constraint PK_Concert CASCADE;
ALTER TABLE TICKET_CATEGORY DROP Constraint PK_TICKET_CATEGORY CASCADE;
ALTER TABLE TICKETS DROP Constraint PK_TICKETS CASCADE;

-- Tables
DROP TABLE ARTIST;
DROP TABLE CONCERT;
DROP TABLE TICKETS;
DROP TABLE TICKET_CATEGORY;
DROP TABLE ORDER_DETAILS;
DROP TABLE CUSTOMER;


/* Create tables based on entities */
CREATE TABLE ARTIST (
    artist_id             INTEGER      NOT NULL,
    artist_name           VARCHAR2(30) NOT NULL,
    genre                 VARCHAR2(30) NOT NULL,
    genre_id         INTEGER,    
    artist_category       VARCHAR2(30),
    artist_rating         INTEGER,


    CONSTRAINT PK_ARTIST PRIMARY KEY (artist_id)
);

CREATE TABLE CONCERT (
    concert_id            INTEGER       NOT NULL,
    stage_id              INTEGER       NOT NULL,
    stage_name            VARCHAR2(128) NOT NULL,
    concert_name          VARCHAR2(512) NOT NULL,
    concert_venue         VARCHAR2(30)  NOT NULL,
    artist_id             INTEGER,
    concert_date          DATE          NOT NULL,
    concert_time          VARCHAR2(30)  NOT NULL,

    CONSTRAINT PK_CONCERT         PRIMARY KEY (concert_id),
    CONSTRAINT FK_CONCERT_artist_id FOREIGN KEY (artist_id) REFERENCES ARTIST
);



CREATE TABLE CUSTOMER (
    customer_id             INTEGER      NOT NULL,
    customer_name           VARCHAR2(30) NOT NULL,
    customer_email          VARCHAR2(30) NOT NULL,
    customer_contact        VARCHAR2(30),
    customer_code           INTEGER,
    discount                INTEGER,


    CONSTRAINT PK_CUSTOMER PRIMARY KEY (customer_id)
);


CREATE TABLE ORDER_DETAILS (
    order_no       INTEGER      NOT NULL,
    address        VARCHAR(30)  NOT NULL,
    purchase_date  DATE         NOT NULL,
    purchase_time  VARCHAR(30)  NOT NULL,
    price          INTEGER      NOT NULL,
    discount       INTEGER      NOT NULL,
    customer_id    INTEGER ,

    CONSTRAINT PK_ORDER_DETAILS          PRIMARY KEY (order_no),
    CONSTRAINT FK_ORDER_DETAILS_customer_id  FOREIGN KEY (customer_id)  REFERENCES CUSTOMER
);

CREATE TABLE TICKETS (
    ticket_id        INTEGER     NOT NULL,
    serial_no        INTEGER,
    concert_id       INTEGER     NOT NULL,
    purchase_date    DATE        NOT NULL,
    purchase_time    varchar(30),
    seat_no          VARCHAR(30) NOT NULL,
    order_no         INTEGER,

    CONSTRAINT PK_TICKETS          PRIMARY KEY (ticket_id),
    CONSTRAINT FK_TICKETS_order_no  FOREIGN KEY (order_no)  REFERENCES ORDER_DETAILS,
    CONSTRAINT FK_TICKETS_concert_id  FOREIGN KEY (concert_id)  REFERENCES CONCERT
);



CREATE TABLE TICKET_CATEGORY (
    tkt_category_id       INTEGER         NOT NULL,
    ticket_id             INTEGER ,
    description           VARCHAR2(1024)  NOT NULL,
    price                 INTEGER         NOT NULL,
    start_date            DATE,
    end_date              DATE,

    CONSTRAINT PK_TICKET_CATEGORY          PRIMARY KEY (tkt_category_id),
    CONSTRAINT FK_TICKET_CATEGORY_ticket_id  FOREIGN KEY (ticket_id)  REFERENCES TICKETS
);





/* Create indices for natural keys, foreign keys, and frequently-queried columns */
-- Customer
-- Natural Keys
CREATE INDEX IDX_customer_name ON Customer (customer_name);

-- Order_Details

--  Foreign Keys
CREATE INDEX IDX_Order_Details_customer_id_FK ON Order_Details (customer_id);


-- Tickets

--  Frequently-queried columns
CREATE INDEX IDX_Tickets_serial_no ON Tickets (serial_no);

-- Ticket_Category
--  Foreign Keys
CREATE INDEX IDX_Ticket_Category_ticket_id_FK   ON Ticket_Category (ticket_id);
--  Frequently-queried columns
CREATE INDEX IDX_Ticket_Category_price ON Ticket_Category (price);
CREATE INDEX IDX_Ticket_Category_description  ON Ticket_Category (description);

-- Concert
--  Foreign Keys
CREATE INDEX IDX_Concert_artist_id_FK  ON Concert (artist_id);
--  Frequently-queried columns
CREATE INDEX IDX_Concert_concert_name ON Concert (concert_name);
CREATE INDEX IDX_Concert_concert_venue ON Concert (concert_venue);
CREATE INDEX IDX_Concert_concert_date ON Concert (concert_date);

-- Artist
--  Natural Keys
CREATE INDEX IDX_Artist_genre_id ON Artist (genre_id);
--  Frequently-queried columns
CREATE INDEX IDX_Artist_Artist_name    ON Artist (Artist_name);
CREATE INDEX IDX_Artist_genre       ON Artist (genre);



/* Alter Tables by adding Audit Columns */
ALTER TABLE CUSTOMER ADD (
    created_by    VARCHAR2(30),
    date_created  DATE,
    modified_by   VARCHAR2(30),
    date_modified DATE
);

ALTER TABLE ORDER_DETAILS ADD (
    created_by    VARCHAR2(30),
    date_created  DATE,
    modified_by   VARCHAR2(30),
    date_modified DATE
);

ALTER TABLE TICKETS ADD (
    created_by    VARCHAR2(30),
    date_created  DATE,
    modified_by   VARCHAR2(30),
    date_modified DATE
);

ALTER TABLE TICKET_CATEGORY ADD (
    created_by    VARCHAR2(30),
    date_created  DATE,
    modified_by   VARCHAR2(30),
    date_modified DATE
);

ALTER TABLE CONCERT ADD (
    created_by    VARCHAR2(30),
    date_created  DATE,
    modified_by   VARCHAR2(30),
    date_modified DATE
);

ALTER TABLE ARTIST ADD (
    created_by    VARCHAR2(30),
    date_created  DATE,
    modified_by   VARCHAR2(30),
    date_modified DATE
);

/* Create Views */
-- Business purpose: The CustomerInfo view will be used primarily for rapidly fetching information about customer for entry to the concert.
CREATE OR REPLACE VIEW CustomerInfo AS
SELECT customer_id,customer_name,customer_code,customer_email
FROM CUSTOMER;

-- Business purpose: The ArtistInfo view will be used to fetch information about an artist to be displayed as part of detail information of the artist performing.
CREATE OR REPLACE VIEW ArtistInfo AS
SELECT artist_id,artist_name,genre,artist_rating,artist_category
FROM ARTIST;

-- Business purpose: The ConcertInfo view will be used to populate information about the concert where the concert will take place.
CREATE OR REPLACE VIEW ConcertInfo AS
SELECT concert_id,concert_name,concert_venue,concert_date,concert_time
FROM CONCERT;

-- Business purpose: The TicketCat view will be used to populate a list of all the tickets sold for all the concerts.
CREATE OR REPLACE VIEW TicketCat AS
SELECT tkt_category_id,description,price,start_date,end_date
FROM TICKET_CATEGORY;

/* Create Sequences */


CREATE SEQUENCE SEQ_CONCERT_concert_id
    INCREMENT BY 1
    START WITH 0
    NOMAXVALUE
    MINVALUE 0
    NOCACHE;

CREATE SEQUENCE SEQ_TICKETS_ticket_id
    INCREMENT BY 1
    START WITH 0
    NOMAXVALUE
    MINVALUE 0
    NOCACHE;

CREATE SEQUENCE SEQ_ORDER_DETAILS_order_no
    INCREMENT BY 1
    START WITH 0
    NOMAXVALUE
    MINVALUE 0
    NOCACHE;

CREATE SEQUENCE SEQ_CUSTOMER_customer_id
    INCREMENT BY 1
    START WITH 0
    NOMAXVALUE
    MINVALUE 0
    NOCACHE;


/* Create Triggers */
-- Business purpose: The TRG_CUSTOMER trigger automatically assigns a sequential customer ID to a newly-inserted row in the CUSTOMER table, as well as assigning appropriate values to the created_by and date_created fields.  If the record is being inserted or updated, appropriate values are assigned to the modified_by and modified_date fields.
CREATE OR REPLACE TRIGGER TRG_CUSTOMER
    BEFORE INSERT OR UPDATE ON CUSTOMER
    FOR EACH ROW
    BEGIN
        IF INSERTING THEN
            IF :NEW.customer_id IS NULL THEN
                :NEW.customer_id := SEQ_CUSTOMER_customer_id.NEXTVAL;
            END IF;
            IF :NEW.created_by IS NULL THEN
                :NEW.created_by := USER;
            END IF;
            IF :NEW.date_created IS NULL THEN
                :NEW.date_created := SYSDATE;
            END IF;
        END IF;
        IF INSERTING OR UPDATING THEN
            :NEW.modified_by := USER;
            :NEW.date_modified := SYSDATE;
        END IF;
END;
/

-- Business purpose: The TRG_ORDER_DETAILS trigger automatically assigns a sequential order_no to a newly-inserted row in the ORDER_DETAILS table, as well as setting the join date to the current system date and assigning appropriate values to the created_by and date_created fields.  If the record is being inserted or updated, appropriate values are assigned to the modified_by and modified_date fields.
CREATE OR REPLACE TRIGGER TRG_ORDER_DETAILS
    BEFORE INSERT OR UPDATE ON ORDER_DETAILS
    FOR EACH ROW
    BEGIN
        IF INSERTING THEN
            IF :NEW.order_no IS NULL THEN
                :NEW.order_no := SEQ_ORDER_DETAILS_order_no.NEXTVAL;
            END IF;
            IF :NEW.created_by IS NULL THEN
                :NEW.created_by := USER;
            END IF;
            IF :NEW.date_created IS NULL THEN
                :NEW.date_created := SYSDATE;
            END IF;
        END IF;
        IF INSERTING OR UPDATING THEN
            :NEW.modified_by := USER;
            :NEW.date_modified := SYSDATE;
        END IF;
END;
/

-- Business purpose: The TRG_TICKET_CATEGORY trigger sets the modified_by and date_modified fields to appropriate values in a newly inserted or updated record; if the record is being inserted, then the created_by and date_created fields are set to appropriate values too.
CREATE OR REPLACE TRIGGER TRG_TICKET_CATEGORY
    BEFORE INSERT OR UPDATE ON TICKET_CATEGORY
    FOR EACH ROW
    BEGIN
        IF INSERTING THEN
            IF :NEW.created_by IS NULL THEN
                :NEW.created_by := USER;
            END IF;
            IF :NEW.date_created IS NULL THEN
                :NEW.date_created := SYSDATE;
            END IF;
        END IF;
        IF INSERTING OR UPDATING THEN
            :NEW.modified_by := USER;
            :NEW.date_modified := SYSDATE;
        END IF;
END;
/

-- Business purpose: The TRG_TICKET trigger automatically assigns a sequential ticket_id to a newly-inserted row in the TICKET table, as well as setting the join date to the current system date and assigning appropriate values to the created_by and date_created fields.  If the record is being inserted or updated, appropriate values are assigned to the modified_by and modified_date fields.
CREATE OR REPLACE TRIGGER TRG_TICKETS
    BEFORE INSERT OR UPDATE ON TICKETS
    FOR EACH ROW
    BEGIN
        IF INSERTING THEN
            IF :NEW.ticket_id IS NULL THEN
                :NEW.ticket_id := SEQ_TICKETS_ticket_id.NEXTVAL;
            END IF;
            IF :NEW.created_by IS NULL THEN
                :NEW.created_by := USER;
            END IF;
            IF :NEW.date_created IS NULL THEN
                :NEW.date_created := SYSDATE;
            END IF;
        END IF;
        IF INSERTING OR UPDATING THEN
            :NEW.modified_by := USER;
            :NEW.date_modified := SYSDATE;
        END IF;
END;
/

-- Business purpose: The TRG_CONCERT trigger automatically assigns a sequential concert_id to a newly-inserted row in the CONCERT table, as well as setting the join date to the current system date and assigning appropriate values to the created_by and date_created fields.  If the record is being inserted or updated, appropriate values are assigned to the modified_by and modified_date fields.
CREATE OR REPLACE TRIGGER TRG_CONCERT
    BEFORE INSERT OR UPDATE ON CONCERT
    FOR EACH ROW
    BEGIN
        IF INSERTING THEN
            IF :NEW.concert_id IS NULL THEN
                :NEW.concert_id := SEQ_CONCERT_concert_id.NEXTVAL;
            END IF;
            IF :NEW.created_by IS NULL THEN
                :NEW.created_by := USER;
            END IF;
            IF :NEW.date_created IS NULL THEN
                :NEW.date_created := SYSDATE;
            END IF;
        END IF;
        IF INSERTING OR UPDATING THEN
            :NEW.modified_by := USER;
            :NEW.date_modified := SYSDATE;
 END IF;
END;
/

-- Business purpose: The TRG_ARTIST trigger sets the modified_by and date_modified fields to appropriate values in a newly inserted or updated record; if the record is being inserted, then the created_by and date_created fields are set to appropriate values too.
CREATE OR REPLACE TRIGGER TRG_ARTIST
    BEFORE INSERT OR UPDATE ON ARTIST
    FOR EACH ROW
    BEGIN
        IF INSERTING THEN
            IF :NEW.created_by IS NULL THEN
                :NEW.created_by := USER;
            END IF;
            IF :NEW.date_created IS NULL THEN
                :NEW.date_created := SYSDATE;
            END IF;
        END IF;
        IF INSERTING OR UPDATING THEN
            :NEW.modified_by := USER;
            :NEW.date_modified := SYSDATE;
        END IF;
END;
/


-- Check the DBMS data dictionary to make sure that all objects have been created successfully
SELECT TABLE_NAME FROM USER_TABLES;

SELECT OBJECT_NAME, STATUS, CREATED, LAST_DDL_TIME FROM USER_OBJECTS;


--Artist

INSERT INTO Artist (artist_id, artist_name,genre, genre_id,artist_category, artist_rating)
VALUES (001,'John Joy','Rock',001,'Young Adult',6);
INSERT INTO Artist (artist_id, artist_name,genre, genre_id,artist_category, artist_rating)
VALUES (007,'Hozier','Pop',002,'Adult',7);
INSERT INTO Artist (artist_id, artist_name,genre, genre_id,artist_category, artist_rating)
VALUES (099,'Lady Yaya','Rap',003,'Explicit',8);
INSERT INTO Artist (artist_id, artist_name,genre, genre_id,artist_category, artist_rating)
VALUES (101,'Harry Patter','Indie',004,'Young Adult',7);
INSERT INTO Artist (artist_id, artist_name,genre, genre_id,artist_category, artist_rating)
VALUES (021,'Kanye South','Jazz',005,'Adult',8);
INSERT INTO Artist (artist_id, artist_name,genre, genre_id,artist_category, artist_rating)
VALUES (030,'Taylor Drift','Rock',001,'Explicit',9);
INSERT INTO Artist (artist_id, artist_name,genre, genre_id,artist_category, artist_rating)
VALUES (028,'Pre Malone','Rap',003,'Adult',5);
INSERT INTO Artist (artist_id, artist_name,genre, genre_id,artist_category, artist_rating)
VALUES (066,'Twenty Two Pilots','EDM',006,'Explicit',9);
INSERT INTO Artist (artist_id, artist_name,genre, genre_id,artist_category, artist_rating)
VALUES (120,'Pitstop','Pop',002,'Adult',7);
INSERT INTO Artist (artist_id, artist_name,genre, genre_id,artist_category, artist_rating)
VALUES (089,'The Weekdy','Indie',004,'Young Adult',8);

--Concert
INSERT INTO Concert (concert_id, stage_id, stage_name, concert_name, concert_venue,artist_id,concert_date, concert_time)
VALUES (001,03,'Green Stage','RockFeast','Iron City','001','25-DEC-2021','19:00:00');
INSERT INTO Concert (concert_id, stage_id, stage_name, concert_name, concert_venue,artist_id,concert_date, concert_time)
VALUES (001,03,'Green Stage','RockFeast','Iron City','001','25-DEC-2021','19:00:00');
INSERT INTO Concert (concert_id, stage_id, stage_name, concert_name, concert_venue,artist_id,concert_date, concert_time)
VALUES (020,11,'Red Stage','PopFeast','Wild Mikes','007','12-NOV-2022','20:00:00');
INSERT INTO Concert (concert_id, stage_id, stage_name, concert_name, concert_venue,artist_id,concert_date, concert_time)
VALUES (021,26,'Blue Stage','RapFeast','Royce Hall','099','12-JAN-2022','19:30:00');
INSERT INTO Concert (concert_id, stage_id, stage_name, concert_name, concert_venue,artist_id,concert_date, concert_time)
VALUES (030,19,'Red Stage','IndieFeast','Wild Mikes','101','15-DEC-2021','20:00:00');
INSERT INTO Concert (concert_id, stage_id, stage_name, concert_name, concert_venue,artist_id,concert_date, concert_time)
VALUES (102,07,'Green Stage','JazzFeast','House of Blues','021','12-NOV-2022','19:30:00');
INSERT INTO Concert (concert_id, stage_id, stage_name, concert_name, concert_venue,artist_id,concert_date, concert_time)
VALUES (111,04,'Green Stage','RockFeast','Petco Park','030','12-FEB-2022','20:00:00');
INSERT INTO Concert (concert_id, stage_id, stage_name, concert_name, concert_venue,artist_id,concert_date, concert_time)
VALUES (018,99,'Red Stage','RapFeast','Oracle Park','028','12-MAY-2022','21:00:00');
INSERT INTO Concert (concert_id, stage_id, stage_name, concert_name, concert_venue,artist_id,concert_date, concert_time)
VALUES (091,28,'Yellow Stage','EDMFeast','Iron City','066','12-JAN-2022','18:30:00');
INSERT INTO Concert (concert_id, stage_id, stage_name, concert_name, concert_venue,artist_id,concert_date, concert_time)
VALUES (071,32,'Blue Stage','PopFeast','House of Blues','120','12-MAY-2022','18:00:00');
INSERT INTO Concert (concert_id, stage_id, stage_name, concert_name, concert_venue,artist_id,concert_date, concert_time)
VALUES (011,68,'Yellow Stage','IndieFeast','Oracle Park','089','12-JUN-2022','20:00:00');

--Customer
INSERT INTO Customer(customer_id, customer_name, customer_email, customer_contact, customer_code, discount)
VALUES (231,'Adam','Adam.A@gmail.com','4691231234',03,10);
INSERT INTO Customer(customer_id, customer_name, customer_email, customer_contact, customer_code, discount)
VALUES (232,'Adam','A324@gmail.com','4691231235',03,10);
INSERT INTO Customer(customer_id, customer_name, customer_email, customer_contact, customer_code, discount)
VALUES (233,'steve','st342@gmail.com','4691231236',03,10);
INSERT INTO Customer(customer_id, customer_name, customer_email, customer_contact, customer_code, discount)
VALUES (234,'Polo','Aer34@gmail.com','4691231237',03,10);
INSERT INTO Customer(customer_id, customer_name, customer_email, customer_contact, customer_code, discount)
VALUES (235,'Alan','Adas34@gmail.com','4691231238',03,10);
INSERT INTO Customer(customer_id, customer_name, customer_email, customer_contact, customer_code, discount)
VALUES (236,'Jeff','jg324A@gmail.com','4691231239',03,10);
INSERT INTO Customer(customer_id, customer_name, customer_email, customer_contact, customer_code, discount)
VALUES (237,'steve','stve45@gmail.com','4691231210',03,10);
INSERT INTO Customer(customer_id, customer_name, customer_email, customer_contact, customer_code, discount)
VALUES (238,'ry','rder34@gmail.com','4691231211',06,10);
INSERT INTO Customer(customer_id, customer_name, customer_email, customer_contact, customer_code, discount)
VALUES (239,'wanda','wasdf3@gmail.com','4691231212',03,10);
INSERT INTO Customer(customer_id, customer_name, customer_email, customer_contact, customer_code, discount)
VALUES (240,'Lovo','43234lop@gmail.com','4691231213',03,10);
Select * from customer;


--Order Details
INSERT INTO Order_Details(order_no, address, purchase_date, purchase_time, price, discount, customer_id)
VALUES (23,'125 Main Rd','08-Dec-2008','19:00:00',200,10,231);
INSERT INTO Order_Details(order_no, address, purchase_date, purchase_time, price, discount, customer_id)
VALUES (24,'126 Main Rd','05-NOv-2010','19:00:00',200,10,232);
INSERT INTO Order_Details(order_no, address, purchase_date, purchase_time, price, discount, customer_id)
VALUES (25,'127 Main Rd','01-NOv-2008','19:00:00',200,10,233);
INSERT INTO Order_Details(order_no, address, purchase_date, purchase_time, price, discount, customer_id)
VALUES (26,'128 Main Rd','02-Jan-2009','19:00:00',200,10,234);
INSERT INTO Order_Details(order_no, address, purchase_date, purchase_time, price, discount, customer_id)
VALUES (27,'129 Main Rd','07-Jan-2011','19:00:00',200,10,235);
INSERT INTO Order_Details(order_no, address, purchase_date, purchase_time, price, discount, customer_id)
VALUES (28,'132 Main Rd','11-Apr-2010','19:00:00',200,10,236);
INSERT INTO Order_Details(order_no, address, purchase_date, purchase_time, price, discount, customer_id)
VALUES (29,'133 Main Rd','11-Mar-2009','19:00:00',200,10,237);
INSERT INTO Order_Details(order_no, address, purchase_date, purchase_time, price, discount, customer_id)
VALUES (30,'134 Main Rd','10-Oct-2008','19:00:00',200,10,238);
INSERT INTO Order_Details(order_no, address, purchase_date, purchase_time, price, discount, customer_id)
VALUES (21,'123 Main Rd','11-Nov-2008','19:00:00',200,10,239);
INSERT INTO Order_Details(order_no, address, purchase_date, purchase_time, price, discount, customer_id)
VALUES (22,'124 Main Rd','06-Jan-2009','19:00:00',200,10,240);


--Tickets
INSERT INTO Tickets (ticket_id, serial_no, concert_id, purchase_date, purchase_time, seat_no, order_no )
VALUES (111,1101,001,'11-Nov-2008','19:00:00','A23',21);
INSERT INTO Tickets (ticket_id, serial_no, concert_id, purchase_date, purchase_time, seat_no, order_no )
VALUES (112,1102,020,'06-Jan-2009','19:00:00','A24',22);
INSERT INTO Tickets (ticket_id, serial_no, concert_id, purchase_date, purchase_time, seat_no, order_no )
VALUES (113,1103,021,'08-Dec-2008','19:00:00','A25',23);
INSERT INTO Tickets (ticket_id, serial_no, concert_id, purchase_date, purchase_time, seat_no, order_no )
VALUES (114,1104,030,'05-NOv-2010','19:00:00','A26',24);
INSERT INTO Tickets (ticket_id, serial_no, concert_id, purchase_date, purchase_time, seat_no, order_no )
VALUES (115,1105,102,'01-NOv-2008','19:00:00','A27',25);
INSERT INTO Tickets (ticket_id, serial_no, concert_id, purchase_date, purchase_time, seat_no, order_no )
VALUES (116,1106,111,'02-Jan-2009','19:00:00','A28',26);
INSERT INTO Tickets (ticket_id, serial_no, concert_id, purchase_date, purchase_time, seat_no, order_no )
VALUES (117,1107,018,'07-Jan-2011','19:00:00','A29',27);
INSERT INTO Tickets (ticket_id, serial_no, concert_id, purchase_date, purchase_time, seat_no, order_no )
VALUES (118,1108,091,'11-Apr-2010','19:00:00','A30',28);
INSERT INTO Tickets (ticket_id, serial_no, concert_id, purchase_date, purchase_time, seat_no, order_no )
VALUES (119,1109,071,'11-Mar-2009','19:00:00','A31',29);
INSERT INTO Tickets (ticket_id, serial_no, concert_id, purchase_date, purchase_time, seat_no, order_no )
VALUES (120,1110,011,'10-Oct-2008','19:00:00','A32',30);

--Ticket Category
INSERT INTO Ticket_Category(tkt_category_id, ticket_id, description, price, start_date, end_date)
VALUES (011,111,'Front Left Section',200,'01-Nov-2012','02-Nov-2012');
INSERT INTO Ticket_Category(tkt_category_id, ticket_id, description, price, start_date, end_date)
VALUES (022,112,'Front Right Section',200,'03-Nov-2012','04-Nov-2012');
INSERT INTO Ticket_Category(tkt_category_id, ticket_id, description, price, start_date, end_date)
VALUES (033,113,'Back Left Section',200,'05-Nov-2012','06-Nov-2012');
INSERT INTO Ticket_Category(tkt_category_id, ticket_id, description, price, start_date, end_date)
VALUES (044,114,'Back Right Section',200,'07-Nov-2012','08-Nov-2012');
INSERT INTO Ticket_Category(tkt_category_id, ticket_id, description, price, start_date, end_date)
VALUES (055,115,'Balcony Front Left Section',200,'09-Nov-2012','10-Nov-2012');
INSERT INTO Ticket_Category(tkt_category_id, ticket_id, description, price, start_date, end_date)
VALUES (066,116,'Balcony Front Right Section',200,'11-Nov-2012','12-Nov-2012');
INSERT INTO Ticket_Category(tkt_category_id, ticket_id, description, price, start_date, end_date)
VALUES (077,117,'Balcony Back Left Section',200,'13-Nov-2012','14-Nov-2012');
INSERT INTO Ticket_Category(tkt_category_id, ticket_id, description, price, start_date, end_date)
VALUES (088,118,'Balcony Back Right Section',200,'15-Nov-2012','16-Nov-2012');
INSERT INTO Ticket_Category(tkt_category_id, ticket_id, description, price, start_date, end_date)
VALUES (099,119,'SideBar Right',200,'17-Nov-2012','18-Nov-2012');
INSERT INTO Ticket_Category(tkt_category_id, ticket_id, description, price, start_date, end_date)
VALUES (1000,120,'SideBar Left',200,'19-Nov-2012','20-Nov-2012');
select * from Ticket_Category;



--Q1) Select all columns and all rows from one table

SELECT * FROM artist;
 


--Q2) Select five columns and all rows from one table

SELECT artist_id, artist_name, genre, genre_id, artist_category
FROM artist;



 
--Q3) Select all columns from all rows from one view

SELECT * FROM CustomerInfo;


 
--Q4)Using a join on 2 tables, select all columns and all rows
 
SELECT * FROM concert LEFT OUTER JOIN Tickets ON concert.concert_id = tickets.concert_id;




 
--Q5) Select and order data retrieved from one table

SELECT * FROM Artist
ORDER BY artist_id;



 
--Q6) Using a join on 3 tables, select 5 columns from the 3 tables.  Use syntax that would limit the output to 10 rows

SELECT artist.artist_id, concert.concert_name, concert.stage_id, concert.concert_venue, tickets.ticket_id
FROM artist INNER JOIN concert ON artist.artist_id = concert.artist_id
            INNER JOIN tickets ON concert.concert_id = tickets.concert_id
FETCH FIRST 10 ROWS ONLY;
 



--Q7) Select distinct rows using joins on 3 tables

SELECT DISTINCT *
FROM concert INNER JOIN tickets ON concert.concert_id = tickets.concert_id
            INNER JOIN artist ON concert.artist_id = artist.artist_id;
 


--Q8)Use GROUP BY and HAVING in a select statement using one or more tables

SELECT concert.concert_name, AVG(artist.artist_rating)
FROM concert INNER JOIN artist ON concert.artist_id = artist.artist_id
GROUP BY concert.concert_name, concert.concert_id
HAVING concert.concert_id = 021;
 


--Q9) Use IN clause to select data from one or more tables

SELECT * FROM concert
WHERE concert_id IN (020, 021, 030);
 


-- Q10. Select length of one column from one table (use LENGTH function)
SELECT LENGTH(customer_id) FROM CUSTOMER;
 

 
-- Q11. Delete one record from one table. Use select statements to demonstrate the table contents before and after the DELETE statement. Make sure you use ROLLBACK afterward so that the data will not be physically removed
SELECT * FROM CUSTOMER;
DELETE FROM CUSTOMER
WHERE customer_id = 231;
SELECT * FROM CUSTOMER;
ROLLBACK;
 

 
-- Q12. Update one record from one table. Use select statements to demonstrate the table contents before and after the UPDATE statement. Make sure you use ROLLBACK afterward so that the data will not be physically removed
SELECT * FROM ARTIST;
UPDATE ARTIST
SET artist_name= 'The Weeknd'
WHERE artist_id = 101;
SELECT * FROM ARTIST;
ROLLBACK;
 

 
-- Q13. List all artist names, their categories, and their ratings, ordered alphabetically by their name where the genre is pop.
 
SELECT a.artist_name, a.artist_category, a.artist_rating
FROM ARTIST a
WHERE a.genre = 'pop'
ORDER BY a.artist_name;
 

 
-- Q14. List all unique ticket categories; display the average price along where the description is 'fun'.
SELECT AVG(price)AS avg_price 
FROM TICKET_CATEGORY
WHERE description = 'fun';
 
 

-- Q15. Display the artist_id and artist_name of all artists who will perform more than once.
SELECT a.artist_id, a.artist_name
FROM ARTIST a GROUP BY a.artist_id, a.artist_name
HAVING COUNT(a.artist_id) > 1;
 
 

 

-- Q16.  Top 3 artists basis on the no of concerts performed. 

select a.artist_name,count(c.concert_id) as total_no_concerts from artist a 
join concert c on a.artist_id = c.artist_id
group by a.artist_name
order by total_no_concerts
fetch first 3 rows only 




-- Q17.Top 3 prices of tickets sold  

SELECT Price from order_details 
Where price > 23;





-- Q18. Top 3 customers which has the highest no of tickets purchased and how much did they spend in total 

select count(order_no),customer_id,sum(price) from order_details 
group by customer_id
order by count(order_no)
fetch first 3 rows only  





-- Q19. Top 35 customers which has the highest no of tickets purchased and how much did they spend in total 


select count(order_no),customer_id,sum(price) from order_details 
group by customer_id
order by count(order_no)
fetch first 35 rows only ;





-- Q20. Top 15 customers which has the highest no of tickets purchased and how much did they spend in total 


select count(order_no),customer_id,sum(price) from order_details 
group by customer_id
order by count(order_no)
fetch first 15 rows only;



