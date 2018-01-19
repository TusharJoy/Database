drop table orderTable ;
drop table artwork ;
drop table artist ;
drop table customer ;

create table customer(
	cust_id integer ,
	name varchar(50),
	country varchar(50),
	address varchar(50)
);

alter table customer add primary key(cust_id) ;

create table artist(
	artist_id integer ,
	age integer ,
	birthplace varchar(50),
	style varchar(50),
	name varchar(50)
);

alter table artist ADD UNIQUE KEY (name) ;
alter table artist add primary key(artist_id) ;

create table artwork(
	artwork_id integer ,
	tittle varchar(50),
	year number(10) ,
	price number(10),
	artist_id integer not null 
);

alter table artwork add primary key(artwork_id) ;
alter table artwork add foreign key(artist_id) references artist(artist_id) ;

create table orderTable(
	order_id integer,
	artwork_id integer,
	cust_id integer	
); 

alter table orderTable add primary key(order_id);
alter table orderTable add foreign key(artwork_id) references artwork(artwork_id) ;
alter table orderTable add foreign key(cust_id) references customer(cust_id) ; 

savepoint count1 ;

select * from tab ;
describe  customer;
select * from customer ;

describe  artwork ;
select * from artwork ;

describe  artist ;
select * from artist ;

describe  orderTable ;
select * from orderTable ;

alter table  customer 
	add birthday varchar(20);

describe customer ;
alter table customer 
	modify birthday varchar(30);

describe customer ;

alter table customer
	rename column birthday to jonmodin ;

alter table customer 
	DROP COLUMN  jonmodin ;

describe customer ;

savepoint count2;

insert into customer values(1,'mobul','USA','west virginia/USA');
insert into customer values(2,'soumik','Bangladesh','islampur,OldDhaka');
insert into customer  values(3,'Tamzid','Bangladesh','laxmiBazar,OldDhaka');
insert into customer  values(4,'Tushar','Bangladesh','Dhamrai,Dhaka');
insert into customer  values(5,'shaoki','Bangladesh','sonamori,noakhali');
insert into customer  values(6,'abul','Bangladesh','tatibazar,chittagong');
insert into customer  values(7,'giggs','Portugal','lisbon'); 
insert into customer  values(8,'Ronaldo','Portugal','lisbon');
insert into customer  values(9,'neymar','Brazil','rio-de-zenerio');
insert into customer  values(10,'hulk','Brazil','rio-de-zenerio');
insert into customer  values(11,'A','Brazil','rio-de-zenerio');

describe customer ;
select * from customer ;

update customer set name = 'mokbul' where cust_id=1;

select * from customer ;


insert into artist  values(1,55,'Bangladesh','simple','Ahsan Habib');
insert into artist  values(2,45,'Bangladesh','complex','Shamsur Rahman');
insert into artist  values (3,60,'Bangladesh','grameenart','Humayun Ahmed');

select * from artist ;
 
insert into artwork values(1,'A',2001,100,1) ;
insert into artwork values(2,'B',2001,1000,1) ;
insert into artwork values(3,'C',2003,1000,2) ;
insert into artwork values(4,'D',2004,100,2) ;
insert into artwork values(5,'E',2004,1000,2) ;
insert into artwork values(6,'F',2006,100,3) ;
insert into artwork values(7,'G',2006,10700,3) ;
insert into artwork values(8,'H',2007,10098,3) ;
insert into artwork values(9,'I',2007,600,1) ;
insert into artwork values(10,'J',2001,8000,2) ;

select * from artwork ;

insert into orderTable values (1,1,1);
insert into orderTable values(2,2,2);
insert into orderTable values (3,8,9);
insert into orderTable values(4,2,4);
insert into orderTable values (5,7,5);
insert into orderTable values(6,2,7);	
insert into orderTable values (7,2,1);	

savepoint count3 ;

select * from orderTable ;
select name , country ,address from customer ;
delete from customer where name='A' ; 

select tittle from artwork where year>=2002 and year<=2010 ;
select tittle  from artwork where price >=1010 ;
select tittle from artwork order by year ;
select tittle from artwork order by year,tittle ;

SELECT DISTINCT (year) FROM artwork;
SELECT year FROM artwork;
SELECT MAX(year) FROM artwork;
SELECT COUNT(*), SUM(price), AVG(price) FROM artwork;

SELECT AVG(NVL(price,0)) FROM artwork  ;
SELECT COUNT(ALL price) FROM artwork;

select order_id from orderTable where artwork_id = 1; 


select a.tittle, a.price from artwork a,orderTable o where 
		a.artwork_id = o.artwork_id ; 

savepoint count4 ;

SET SERVEROUTPUT ON
DECLARE
   max_price  artwork.price%type;
BEGIN
   SELECT MAX(price)  INTO max_price  
   FROM artwork;
   DBMS_OUTPUT.PUT_LINE('The maximum price of picture  is : ' || max_price);
 END;
/
show errors ;


CREATE OR REPLACE PROCEDURE add_customer (
  id customer.cust_id%TYPE,
  name customer.name%type,
  cou customer.country%type,
  add customer.address%type ) IS
BEGIN
  INSERT INTO customer VALUES (id,name,cou,add);
END add_customer;
/
show errors ;


set SERVEROUTPUT ON

BEGIN 
	add_customer(12,'Akash','Bangladesh','khilgaon') ;
END ;
/	


CREATE OR REPLACE PROCEDURE add_artist (
  id artist.artist_id%type,
  age artist.age%type,
  birth artist.birthplace%type,
  style artist.style%type,
  name artist.name%type ) IS
BEGIN
  INSERT INTO artist VALUES (id,age,birth,style,name);
END add_artist;
/


	
savepoint count5 ;

CREATE OR REPLACE FUNCTION total_discount
   (
   	price1  artwork.price%type
    ) RETURN NUMBER  IS 
	d_price  artwork.price%type ;
BEGIN
    IF price1 < 1000  THEN
                d_price := 0;
    ELSIF price1 >= 1000 and price1 <2000   THEN
               d_price :=  price1 - (price1*0.25);
   ELSE
	d_price :=  price1 - (price1*0.5); 
    END IF;
    return d_price ;
END;
/
show errors ;


set SERVEROUTPUT on 
DECLARE
discount artwork.price%type ;
BEGIN
	discount:=total_discount(1000) ;
	DBMS_OUTPUT.PUT_LINE('Discount is '||discount ) ;
end;
/


create or REPLACE FUNCTION show_total_costOfcustomer(
	c_id customer.cust_id%type ) return NUMBER IS 
	total_cost artwork.price%type ; 
BEGIN
	select SUM (a.price) into total_cost from artwork a where a.artwork_id in (select o.artwork_id from orderTable o where o.cust_id=c_id ) ;  
    return total_cost ;
 end;
 /
 show errors ; 


create table maxorder(
	artwork_id integer,
	count1 number(2)	
); 

insert into maxorder(artwork_id,count1) select artwork_id ,count(order_id) from orderTable  group by artwork_id;


create or REPLACE procedure  mostSoldproduct
	IS
 	art  artwork.tittle%type ;
 	id artwork.artwork_id%type; 
 	maxcunt number(2) ;
BEGIN 
	select MAX(count1) into maxcunt from maxorder ;
	select artwork_id into id from  maxorder where count1=maxcunt ;
	select tittle into art  from artwork  where artwork_id=id ;
	DBMS_OUTPUT.PUT_LINE('THe Most sold item name is '|| art) ;
end;
/


set SERVEROUTPUT on 
BEGIN 
	mostSoldproduct ;
end;
/	 


create or REPLACE procedure  mostPopularArtist
	IS
 	artistname  artist.name%type ;
 	id artwork.artwork_id%type;
 	artisid artist.artist_id%type ; 
 	maxcunt number(2) ;
BEGIN 
	select MAX(count1) into maxcunt from maxorder ;
	select artwork_id into id from  maxorder where count1=maxcunt ;
	select artist_id into artisid  from artwork  where artwork_id=id ;
	select name into artistname from artist where artist_id = artisid ; 
	DBMS_OUTPUT.PUT_LINE('THe Most Popular Artist is '|| artistname) ;
end;
/


set SERVEROUTPUT on 
BEGIN 
	mostPopularArtist ;
end;
/




set SERVEROUTPUT on 
DECLARE
cost artwork.price%type ;
BEGIN
	cost:=show_total_costOfcustomer(1) ;
	DBMS_OUTPUT.PUT_LINE('Total cost of the customer  is '||cost ) ;
end;
/

savepoint count6;  



CREATE OR REPLACE TRIGGER check_price BEFORE INSERT OR UPDATE ON artwork
FOR EACH ROW
DECLARE
   c_min constant number(8,2) := 1000.0;
   c_max constant number(8,2) := 500000.0;
BEGIN
  IF :new.price > c_max OR :new.price < c_min THEN
  RAISE_APPLICATION_ERROR(-20000,'New price is too small or large');
END IF;
END;
/



set SERVEROUTPUT on 
DECLARE
   c_id customer.cust_id%type;
   c_name customer.name%type;
   CURSOR c_customer is
      SELECT cust_id, name  FROM customer;
BEGIN
   OPEN c_customer;
   LOOP
      FETCH c_customer into c_id, c_name ;
      EXIT WHEN c_customer%notfound;
      dbms_output.put_line(c_id || ' ' || c_name || ' ');
   END LOOP;
   CLOSE c_customer;
END;
/
show errors ;


