 drop table log;
 drop table reservation;
 drop table person;
 drop table trip;
 drop table countries;

--zad1
create table person
(
  person_id int generated always as identity not null,
  firstname varchar(50),
  lastname varchar(50),
  constraint person_pk primary key ( person_id ) enable
);

create table trip
(
  trip_id int generated always as identity not null,
  trip_name varchar(100),
  country_id int,
  trip_date date,
  max_no_places int,
  constraint trip_pk primary key ( trip_id ) enable
);

create table reservation
(
  reservation_id int generated always as identity not null,
  trip_id int,
  person_id int,
  status char(1),
  constraint reservation_pk primary key ( reservation_id ) enable
);

create table country
(
  country_id int generated always as identity not null,
  country_name varchar(255),
  constraint country_pk primary key ( country_id ) enable
);
create table log
(
	log_id int  generated always as identity not null,
	reservation_id int not null,
	log_date date  not null,
	status char(1),
	constraint log_pk primary key ( log_id ) enable
);



alter table reservation
add constraint reservation_fk1 foreign key
( person_id ) references person ( person_id ) enable;

alter table reservation
add constraint reservation_fk2 foreign key
( trip_id ) references trip ( trip_id ) enable;

alter table reservation
add constraint reservation_chk1 check
(status in ('N','P','C')) enable;

alter table trip
add constraint reservation_fk3 foreign key
( country_id ) references country ( country_id ) enable;

alter table log
add constraint log_chk1 check
(status in ('N','P','C')) enable;

alter table log
add constraint log_fk1 foreign key
( reservation_id ) references reservation ( reservation_id ) enable;
-- zad2
-- country
insert into country(country_name)
values ('Paryz');

insert into country(country_name)
values ('Paryz');

--trip
insert into trip(trip_name, COUNTRY_ID, trip_date, max_no_places)
values ('Wycieczka do Paryza', 1, to_date('2022-09-12','YYYY-MM-DD'), 10);

insert into trip(trip_name, COUNTRY_ID, trip_date,  max_no_places)
values ('Piękny Kraków', 2, to_date('2023-07-03','YYYY-MM-DD'), 15);

insert into trip(trip_name, COUNTRY_ID, trip_date,  max_no_places)
values ('Znów do Francji', 1, to_date('2023-05-01','YYYY-MM-DD'), 20);

insert into trip(trip_name, COUNTRY_ID, trip_date,  max_no_places)
values ('Hel', 2, to_date('2023-05-01','YYYY-MM-DD'), 5);

-- person

insert into person(firstname, lastname)
values ('Jan', 'Nowak');

insert into person(firstname, lastname)
values ('Jan', 'Kowalski');

insert into person(firstname, lastname)
values ('Jan', 'Nowakowski');

insert into person(firstname, lastname)
values ('Adam', 'Kowalski');

insert into person(firstname, lastname)
values  ('Novak', 'Nowak');

insert into person(firstname, lastname)
values ('Piotr', 'Piotrowski');

insert into person(firstname, lastname)
values ('Stanislaw', 'Krupa');

insert into person(firstname, lastname)
values ('Bernard', 'Skorupa');

insert into person(firstname, lastname)
values ('Anna', 'Motyl');

insert into person(firstname, lastname)
values ('Jakub', 'Maslo');

insert into person(firstname, lastname)
values  ('Katarzyna', 'Ptak');

-- reservation
-- trip 1
insert into reservation(trip_id, person_id, status)
values (1, 1, 'P');

insert into reservation(trip_id, person_id, status)
values (1, 2, 'N');

insert into reservation(trip_id, person_id, status)
values (1, 3, 'P');

insert into reservation(trip_id, person_id, status)
values (1, 4, 'C');


-- trip 2
insert into reservation(trip_id, person_id, status)
values (2, 2, 'P');

insert into reservation(trip_id, person_id, status)
values (2, 4, 'C');

insert into reservation(trip_id, person_id, status)
values (2, 5, 'N');

insert into reservation(trip_id, person_id, status)
values (2, 1, 'C');


-- trip 3
insert into reservation(trip_id, person_id, status)
values (3, 6, 'P');

insert into reservation(trip_id, person_id, status)
values (3, 4, 'C');

-- zad3
CREATE OR REPLACE VIEW ReservationsIDs AS
SELECT COUNTRY_NAME,TRIP_DATE,TRIP_NAME,FIRSTNAME,LASTNAME,r.RESERVATION_ID,STATUS,r.TRIP_ID,p.PERSON_ID
FROM RESERVATION r
LEFT JOIN PERSON p ON p.PERSON_ID = r.PERSON_ID
LEFT JOIN TRIP t ON t.TRIP_ID = r.TRIP_ID
LEFT JOIN COUNTRY c ON t.COUNTRY_ID = c.COUNTRY_ID;

CREATE OR REPLACE VIEW Reservations AS
SELECT COUNTRY_NAME,TRIP_DATE,TRIP_NAME,FIRSTNAME,LASTNAME,RESERVATION_ID,STATUS
FROM RESERVATIONSIDS;

CREATE OR REPLACE  VIEW Trips AS
SELECT DISTINCT COUNTRY_NAME,TRIP_DATE,TRIP_NAME,MAX_NO_PLACES,MAX_NO_PLACES - (SELECT COUNT(*) FROM RESERVATION r WHERE r.trip_id = t.trip_id ) AS no_available_places
FROM TRIP t
LEFT JOIN COUNTRY c ON c.country_id = t.country_id;

CREATE OR REPLACE VIEW AvailableTrips AS
SELECT COUNTRY_NAME,TRIP_DATE,TRIP_NAME,MAX_NO_PLACES,MAX_NO_PLACES - (SELECT COUNT(*) FROM RESERVATION r WHERE r.trip_id = t.trip_id ) AS no_available_places
FROM TRIP t
LEFT JOIN COUNTRY c ON c.country_id = t.country_id
LEFT JOIN reservation r2 on t.trip_id = r2.trip_id
WHERE MAX_NO_PLACES - (SELECT COUNT(*) FROM RESERVATION r WHERE r.trip_id = t.trip_id ) > 0 AND r2.status != 'C';


SELECT * FROM AvailableTrips;

--zad4
CREATE OR REPLACE TYPE tr AS OBJECT(
    COUNTRY_NAME VARCHAR2(255),
    TRIP_DATE DATE,
    TRIP_NAME VARCHAR2(255),
    FIRSTNAME VARCHAR2(255),
    LASTNAME VARCHAR2(255),
    RESERVATION_ID INT,
    STATUS char(1)
                        );
CREATE OR REPLACE TYPE tr_array AS TABLE OF tr;
-- DROP FUNCTION PERSONRESERVATIONS

CREATE OR REPLACE FUNCTION FTripParticipants(tripid INT)
RETURN tr_array
AS
    result tr_array;
    valid INT;
BEGIN
    SELECT count(*) INTO valid
    FROM TRIP
    WHERE TRIP.trip_id=tripid;
    IF valid = 0 THEN
        raise_application_error(-20001, 'Trip not found');
    END IF;
    SELECT tr(r.COUNTRY_NAME,r.TRIP_DATE,r.TRIP_NAME,r.FIRSTNAME,r.LASTNAME,r.RESERVATION_ID,r.STATUS) BULK COLLECT
    INTO result
    FROM reservationsIDS r
    WHERE r.TRIP_ID = tripid;
    RETURN result;
END;

CREATE OR REPLACE TYPE tr AS OBJECT(
    COUNTRY_NAME VARCHAR2(255),
    TRIP_DATE DATE,
    TRIP_NAME VARCHAR2(255),
    FIRSTNAME VARCHAR2(255),
    LASTNAME VARCHAR2(255),
    RESERVATION_ID INT,
    STATUS char(1),
    TRIP_ID INT,
    PERSON_ID INT
                        );
CREATE OR REPLACE TYPE tr_array AS TABLE OF tr;

SELECT * from FTripParticipants(1);

CREATE OR REPLACE FUNCTION FPersonReservations(personid INT)
RETURN tr_array
AS
    result tr_array;
    valid INT;
BEGIN
    SELECT count(*) INTO valid
    FROM PERSON
    WHERE PERSON.person_id=personid;
    IF valid = 0 THEN
        raise_application_error(-20001, 'Trip not found');
    END IF;
    SELECT tr(r.COUNTRY_NAME,r.TRIP_DATE,r.TRIP_NAME,r.FIRSTNAME,r.LASTNAME,r.RESERVATION_ID,r.STATUS) bulk collect
    INTO result
    FROM reservationsIDS r
    WHERE r.PERSON_ID = personid;
    RETURN result;
END;

SELECT * from FPersonReservations(1);

CREATE OR REPLACE TYPE av AS OBJECT(
    COUNTRY_NAME VARCHAR(255),
    TRIP_DATE DATE,
    TRIP_NAME VARCHAR(255),
    MAX_NO_PLACES INT,
    NO_AVAILABLE_PLACES INT
                        );
CREATE OR REPLACE TYPE av_array AS TABLE OF av;

CREATE OR REPLACE FUNCTION FAvailableTrips(country VARCHAR,date_from DATE, date_to DATE)
RETURN av_array
AS
    result av_array;
    valid INT;
BEGIN
    SELECT COUNT(*) INTO valid
    FROM COUNTRY c
    WHERE c.COUNTRY_NAME = country;
    IF valid = 0 THEN
        raise_application_error(-20001, 'Country not found');
    END IF;
    IF date_from > date_to THEN
        raise_application_error(-20001, 'Date_from is later than date_to');
    END IF;
    SELECT av(t.COUNTRY_NAME,t.TRIP_DATE,t.TRIP_NAME,t.MAX_NO_PLACES,t.no_available_places) bulk collect
    INTO result
    FROM trips t
    WHERE t.COUNTRY_NAME = country AND date_from <= t.TRIP_DATE AND date_to >= t.TRIP_DATE AND t.NO_AVAILABLE_PLACES > 0;
    RETURN result;
END;

SELECT * FROM FAvailableTrips('Polska','09-03-2003','09-03-2030');

--zad5