-- *********************************************
-- * SQL SQLite generation                     
-- *--------------------------------------------
-- * DB-MAIN version: 11.0.1              
-- * Generator date: Dec  4 2018              
-- * Generation date: Sat Jul 16 10:39:41 2022 
-- * LUN file: Z:\FlutterProjects\TirocinioTreeAR\TreeAR.lun 
-- * Schema: Logico/1 
-- ********************************************* 


-- Database Section
-- ________________ 


-- Tables Section
-- _____________ 

create table Project (
     name varchar(100) not null,
     id integer primary key autoincrement,
     descr varchar(500) not null,
     link varchar(400) not null --,
--     check(exists(select * from Tree
--                  where Tree.associatedProject = id)) 
);

create table UserProfile (
     userId integer primary key autoincrement,
     name varchar(30) not null,
     surname varchar(30) not null,
     dateBirth date not null,
     course varchar(50) not null,
     registrationDate date not null,
     userImageName varchar(20) not null --,
--     check(exists(select * from UserBadge
--                  where UserBadge.userId = userId)) 
);

create table Badge (
     id integer primary key autoincrement,
     descr varchar(200) not null,
     imageName varchar(200) not null);

create table UserTrees (
     userId numeric(5) not null,
     treeId numeric(4) not null,
     constraint IDhasScanned primary key (treeId, userId),
     foreign key (treeId) references Tree,
     foreign key (userId) references UserProfile);

create table Tree (
     id integer primary key autoincrement,
     associatedProject numeric(4) not null,
     name varchar(100) not null,
     descr varchar(500) not null,
     height numeric(3) not null,
     diameter numeric(3) not null,
     co2 numeric(3) not null,
     constraint FKR_1 unique (associatedProject),
     foreign key (associatedProject) references Project);

create table UserBadge (
     idBadge numeric(2) not null,
     userId numeric(5) not null,
     constraint IDunlocked primary key (idBadge, userId),
     foreign key (userId) references UserProfile,
     foreign key (idBadge) references Badge);


-- Index Section
-- _____________ 

