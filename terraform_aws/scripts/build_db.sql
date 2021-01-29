/* Create user_db, tables and create
   a user with specific privledges to the
   user_db
 */

-- You should...probably replace the password

CREATE DATABASE user_db;
CREATE USER rtrenneman IDENTIFIED BY 'haveyouturneditoffandonagain';
FLUSH PRIVILEGES;

USE user_db;

CREATE TABLE users (
	id MEDIUMINT NOT NULL AUTO_INCREMENT,
	name VARCHAR (100) NOT NULL,
	email varchar (30) NOT NULL,
	PRIMARY KEY (id)
	);
					
GRANT SELECT, INSERT, UPDATE, DELETE on users to 'rtrenneman';

