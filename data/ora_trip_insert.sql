-- trip

SELECT * FROM Trip;

insert into trip(trip_name, COUNTRY_ID, trip_date, max_no_places)
values ('Wycieczka do Paryza', 1, to_date('2022-09-12','YYYY-MM-DD'), 3);

insert into trip(trip_name, COUNTRY_ID, trip_date,  max_no_places)
values ('Piękny Kraków', 2, to_date('2023-07-03','YYYY-MM-DD'), 2);

insert into trip(trip_name, COUNTRY_ID, trip_date,  max_no_places)
values ('Znów do Francji', 1, to_date('2023-05-01','YYYY-MM-DD'), 2);

insert into trip(trip_name, COUNTRY_ID, trip_date,  max_no_places)
values ('Hel', 2, to_date('2023-05-01','YYYY-MM-DD'), 2);

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

-- reservation
-- trip 1
insert into reservation(trip_id, person_id, status)
values (1, 1, 'P');

insert into reservation(trip_id, person_id, status)
values (1, 2, 'N');

-- trip 2
insert into reservation(trip_id, person_id, status)
values (2, 1, 'P');

insert into reservation(trip_id, person_id, status)
values (2, 4, 'C');

-- trip 3
insert into reservation(trip_id, person_id, status)
values (2, 4, 'P');

SELECT * FROM PERSON