CREATE TABLE Project (
     name TEXT,
     projectId INTEGER PRIMARY KEY,
     treeId INTEGER,
     descr TEXT,
     link TEXT );

CREATE TABLE UserProfile (
     userId INTEGER PRIMARY KEY,
     name TEXT,
     surname TEXT,
     dateBirth TEXT ,
     course TEXT,
     registrationDate TEXT,
     userImageName TEXT );

CREATE TABLE Badge (
     id INTEGER PRIMARY KEY,
     descr TEXT,
     imageName TEXT);

CREATE TABLE UserTrees (
     userId INTEGER PRIMARY KEY,
     treeId INTEGER PRIMARY KEY,
     PRIMARY KEY (userId, treeId));

CREATE TABLE Tree (
     treeId INTEGER PRIMARY KEY,
     name TEXT,
     descr TEXT,
     height INTEGER,
     diameter INTEGER,
     co2 INTEGER );

CREATE TABLE UserBadge (
     idBadge INTEGER,
     userId INTEGER,
     PRIMARY KEY (idBadge, userId));