
use uczelnia
drop database dziennik
create database dziennik
use dziennik

create table uczniowie 
(
	Id_ucznia int not null primary key,
	Imi� nvarchar(50) not null,
	Nazwisko nvarchar(50) not null,
	Data_urodzenia date not null 
)

create table nauczyciele
(
	Id_nauczyciela int not null primary key,
	Imi� nvarchar(50) not null,
	Nazwisko nvarchar(50)not null
)

create table przedmioty
(
	Id_przedmiotu int not null primary key,
	Przedmiot nvarchar(50) not null,
	Id_nauczyciela int not null foreign key references nauczyciele(Id_nauczyciela)
)

create table dni
(
	Id_dnia int not null primary key,
	Dzie� nvarchar(50) not null,
	Miesi�c nvarchar(50) not null,
	Rok nvarchar(50) not null
)

create table oceny
(
	Id_oceny int not null primary key,
	Id_nauczyciela int not null foreign key references nauczyciele(Id_nauczyciela),
	Id_przedmiotu int not null foreign key references przedmioty(Id_przedmiotu),
	Id_ucznia int not null foreign key references uczniowie(Id_ucznia),
	Ocena int not null
	constraint chk_ocena check (ocena > 0 and ocena < 7)
)

create table obecno�ci
(
	Id_obecno�ci int not null primary key,
	Id_ucznia int not null foreign key references uczniowie(Id_ucznia),
	Id_dnia int not null foreign key references dni(Id_dnia),
	Warto�� int not null
	constraint chk_warto�� check (warto�� = 1 or warto�� = 0)
)

insert into uczniowie (Id_ucznia, Imi�, Nazwisko, Data_urodzenia)
values (1, 'Leon', 'Miklaszewski', '2000-12-11'),
(2, 'Henryk', 'Wojciechowski', '2000-03-03'),
(3, 'Klara', 'Kowalska', '2000-05-18'),
(4, '�ucja', 'Kapustka', '2000-06-17'),
(5, 'Karol', 'Motylanoga', '2000-05-17'),
(6, 'Grzegorz', 'Skrzyd�owski', '2001-01-30'),
(7, 'Marek', 'Kietrza�ski', '2000-01-01'),
(8, 'J�zef', 'Dynia', '2000-09-11'),
(9, 'Benedykt', 'Gut', '2000-08-26')

insert into nauczyciele(Id_nauczyciela, Imi�, Nazwisko)
values (1, 'Martyna', 'Mieczyk'),
(2, 'Helena', 'Straszyk'),
(3, 'Irena', 'Pl�dkowska'),
(4, 'Marin', 'Mietek'),
(5, 'Jowita', 'Planetarna')

insert into przedmioty (Id_przedmiotu, Przedmiot, Id_nauczyciela)
values (1, 'Biologia', 1),
(2, 'Chemia', 1),
(3, 'Matematyka', 2),
(4, 'J�zyk_polski', 3),
(5, '�acina', 4),
(6, 'Fizyka', 5),
(7, 'Historia', 4)

insert into dni (Id_dnia, Dzie�, Miesi�c, Rok)
values (1, 1, 10, 2015),
(2, 2, 10, 2015),
(3, 5, 10, 2015),
(4, 6, 10, 2015),
(5, 7, 10, 2015),
(6, 8, 10, 2015),
(7, 9, 10, 2015),
(8, 12, 10, 2015),
(9, 13, 10, 2015),
(10, 14, 10, 2015)

insert into oceny (Id_oceny, Id_nauczyciela, Id_przedmiotu, Id_ucznia, ocena)
values (1, 5, 6, 4, 3),
(2, 3, 4, 1, 5),
(3, 2, 3, 1, 6),
(4, 4, 7, 2, 3),
(5, 1, 2, 4, 4),
(6, 1, 1, 7, 5),
(7, 1, 2, 8, 1),
(8, 5, 6, 5,3)

insert into obecno�ci (Id_obecno�ci, Id_ucznia, Id_dnia, Warto��)
values (1, 1, 1, 1),
(2, 2, 1, 1),
(3, 3, 1, 0),
(4, 4, 1, 1),
(5, 5, 1, 1),
(6, 6, 1, 1),
(7, 7, 1, 1),
(8, 8, 1, 0),
(9, 1, 2, 1),
(10, 2, 2, 1),
(11, 3, 2, 0),
(12, 4, 2, 1),
(13, 5, 2, 1),
(14, 6, 2, 1),
(15, 7, 2, 1),
(16, 8, 2, 1),
(17, 1, 3, 1),
(18, 2, 3, 1),
(19, 3, 3, 0),
(20, 4, 3, 1),
(21, 5, 3, 1),
(22, 6, 3, 1),
(23, 7, 3, 1),
(24, 8, 3, 1)

-- ZAPYTANIA

--1. �REDNIA OCEN
go
create view �rednia_ocen
as
select nazwisko, avg(cast (ocena as float)) as �rednia
from uczniowie u full join oceny o
on u.Id_ucznia=o.Id_ucznia
group by Nazwisko
--2. Frekwencja
go
create view frekwencja
as
select nazwisko, sum(cast(warto�� as float))/count(warto��) * 100 as frekwencja_procent 
from uczniowie u full join obecno�ci o
on u.Id_ucznia=o.Id_ucznia
group by Nazwisko
--3. Obecno�ci
go
create view obecno�ci_ucznia
as
Select nazwisko, warto��
from uczniowie u full join obecno�ci o
on u.id_ucznia= o.Id_ucznia
go
create view nauczyciele_przedmioty
as 
select przedmiot,nazwisko
from przedmioty p inner join nauczyciele n
on p.id_nauczyciela = n.id_nauczyciela

go

create procedure dodaj_przedmiot
	@nazwa_przedmiotu nvarchar(50),
	@nazwisko_nauczyciela nvarchar(50)
As
begin
	declare @id_dodawanego_nauczyciela as int

	set @id_dodawanego_nauczyciela = 
		(select id_nauczyciela from nauczyciele
		where nazwisko = @nazwisko_nauczyciela 
		)

	declare @id_dodawanego_przedmiotu as int

	set @id_dodawanego_przedmiotu =
		(select max(id_przedmiotu) + 1 from przedmioty
		)
	
	insert into przedmioty (Id_przedmiotu, przedmiot, Id_nauczyciela)
	values (@id_dodawanego_przedmiotu, @nazwa_przedmiotu, @id_dodawanego_nauczyciela)
end

CREATE procedure obni�_ocen�
@id_oceny int
as
begin
	if (select ocena from oceny where @id_oceny = id_oceny) > 1
	begin
	 update oceny
	 set ocena = ocena - 1
	 where @id_oceny = id_oceny
	end
end

execute obni�_ocen� 6
use dziennik
create procedure obni�_wszystkim
as
begin
	declare @ilo�� as int
		set @ilo�� =
		(select count(id_oceny)+1 from oceny)
	declare @przej�cie as int = 1
		while @przej�cie < @ilo��
		begin
			execute obni�_ocen� @przej�cie 		
			set @przej�cie = @przej�cie + 1
		end
end

execute obni�_wszystkim
select *
from uczniowie u full join oceny o
on u.Id_ucznia = o.Id_ucznia
