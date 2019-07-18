CREATE TABLE users (
 id SERIAL NOT NULL PRIMARY KEY ,
 name VARCHAR( 25 ) NOT NULL ,
 email VARCHAR( 35 ) NOT NULL ,
 password VARCHAR( 60 ) NOT NULL ,
 UNIQUE (email)
);

CREATE TABLE posts (
 id SERIAL NOT NULL PRIMARY KEY ,
 user_id int NOT NULL references users(id) ,
 content VARCHAR( 100 ) NOT NULL ,
 created_at date NOT NULL,
 uploaded_at date  NOT NULL
);