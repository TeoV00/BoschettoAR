-- *********************************************
-- * SQL SQLite generation                     
-- *--------------------------------------------
-- * DB-MAIN version: 11.0.1              
-- * Generator date: Dec  4 2018              
-- * Generation date: Fri Jul 15 15:35:46 2022 
-- * LUN file:  
-- * Schema: App Persistence/1 
-- ********************************************* 


-- Database Section
-- ________________ 


-- Tables Section
-- _____________ 

create table Project (
     name varchar(100) not null,
     id integer primary key autoincrement,
     descr varchar(500) not null);

create table User (
     userId integer primary key autoincrement,
     name varchar(30) not null,
     surname varchar(30) not null,
     dateBirth date not null,
     course varchar(50) not null,
     registrationDate date not null,
     userImageName varchar(20));

create table Badge (
     id integer primary key autoincrement,
     descr varchar(200) not null);

create table Tree (
     id integer primary key autoincrement,
     name varchar(100) not null,
     descr varchar(500) not null,
     height numeric(3) not null,
     diameter numeric(3) not null,
     co2 numeric(3) not null);


-- Index Section
-- _____________ 

