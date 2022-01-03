-- Quaran Academy - DB Script.
-- create database 
create database QuaranAcademy;

-- used databse that we created 
use QuaranAcademy;

-- create table System
create table if not exists System
(
 id int not null auto_increment,
 name nvarchar(50) not null,
 description nvarchar(250) null,
 primary key(id)
);
-- create table student  
create table if not exists Student(
 id        int not null auto_increment,
 firstName nvarchar(50) not null,
 lastName  nvarchar(50) not null,
 telegram  varchar(25) not null unique,
 email     varchar(250) not null unique,
 redFlag   int(1) not null default 0,
 pasword   varchar(250) not null,
 created_at timestamp default current_timestamp,
 primary key(id)
);

-- create table level  
create table if not exists Level(
 id          int not null auto_increment,
 name        nvarchar(50) not null,
 discription nvarchar(250) null,
 capacity    int(4) not null,
 systemid    int not null,
 primary key(id),
 foreign key (systemid) references System(id) on delete cascade on update cascade
);

-- create table studentlevel   
create table if not exists StudentLevel(
 levelid   int not null ,
 studentid int not null,
 score     int not null,
 primary key(levelid, studentid)
);

-- create table sheikh  
create table if not exists Sheikh(
 id        int not null auto_increment,
 firstName nvarchar(50) not null,
 lastName  nvarchar(50) not null,
 telegram  varchar(25) not null unique,
 email     varchar(250) not null unique,
 policy    int not null default 1,
 rate      decimal(3,1) not null,
 created_at timestamp default current_timestamp,
 primary key(id)
);


-- create table tempsheikh 
create table if not exists TempSheikh(
 id        int not null,
 firstName nvarchar(50) not null,
 lastName  nvarchar(50) not null,
 primary key(id)
);

-- create table lesson  
create table if not exists Lesson(
 id       int not null,
 name     nvarchar(50),
 content  nvarchar(250),
 levelid  int not null,
 sheikhid int not null,
 primary key(id),
 foreign key (levelid) references Level(id) on delete cascade,
 foreign key (sheikhid) references Sheikh(id) on delete cascade
);

-- create table room  
create table if not exists Room(
 id          int not null auto_increment,
 name        nvarchar(50) not null,
 discription nvarchar(250),
 capacity    int(4) not null,
 roomtype    int(1) not null,
 sheikhid    int not null,
 primary key(id),
 foreign key (sheikhid) references Sheikh(id) on delete cascade
);

-- create table studentroom  
create table if not exists StudentRoom
(
 studentid int not null, 
 roomid    int not null,
 foreign key (studentid) references Student(id) on delete cascade,
 foreign key (roomid) references Room(id) on delete cascade
);

-- create table news  
create table if not exists News(
 id          int not null auto_increment,
 title       nvarchar(50) not null,
 contentpath varchar(150) not null,
 publishdate datetime not null,
 edited      tinyint not null default 0,
 sheikhid    int not null,
 primary key(id),
 foreign key(sheikhid) references Sheikh(id) on delete cascade
);

-- Functions..
-- Function to return number of student in speical level
delimiter //
create function count_student(levid int)
returns int(11) deterministic
begin
declare count int;
select count(studentid) from StudentLevel where levelid = levid into count;
return count;
end//
delimiter ;
-- Make call for function
select count_student(2);

-- Function to return max score for student in speical level
delimiter //
create function student_highestScore(levid int)
returns int deterministic
begin
declare highscore int;
select max(score) from StudentLevel where levelid = levid into highscore;
return highscore;
end//
delimiter ;

-- Make call for function
select student_highestScore(1);

delimiter //
create function DateFromDeclartion(sheikhid int)
returns varchar(50) deterministic
begin
declare createdate timestamp;
declare numberofyears int;
declare numberofmonth int;
declare answer varchar(50);
select create_at from Sheikh where id = sheikhid into createdate;
set numberofyears =  year(current_timestamp())-year(createdate);
set numberofmonth =  month(current_timestamp())-month(createdate);
set answer= concat(numberofyears," year ",numberofmonth ," month ");
return answer;
end//
delimiter ;

-- Make call for function
select DateFromDeclartion(2);

-- triggers..
-- trigger to validate the rate of Sheikh before updating it 
delimiter //
create trigger checkSheikhRate 
before update on Sheikh 
for each row
begin
     if new.rate < 0 then set new.rate = 0; end if;
     if new.rate > 5 then set new.rate = 5; end if;
end//
delimiter ;

-- trigger to validate the rate of Sheikh before inserting it 
delimiter //
create trigger Before_Insert_Sheikh 
before insert on Sheikh 
for each row
begin
     if new.rate < 0 then set new.rate = 0; end if;
     if new.rate > 5 then set new.rate = 5; end if;
end//
delimiter ;

-- trigger to insert the deleted Sheikh into TempSheikh
delimiter //
create trigger After_Delete_Sheikh 
After delete on Sheikh 
for each row
begin
     insert into TempSheikh values(old.id,old.firstName,old.lastName);
end//
delimiter ;

-- stored procedure that take table name as a parameter and select all the rows in this table
delimiter //
create procedure Select_from_Table(name varchar(40),id int)
begin
     set @table_name=name;
     set @item_id = id;
     SET @sql_text = concat('select * from ',@table_name,' WHERE id = ',@item_id);
     PREPARE stmt FROM @sql_text;
     EXECUTE stmt;
     DEALLOCATE PREPARE stmt;
end//
delimiter ;

-- create super admin user.
CREATE USER 'superAdmin'@'localhost' identified by 'sji508k91';
GRANT ALL PRIVILEGES ON QuaranAcademy.* TO 'superAdmin'@'localhost';
