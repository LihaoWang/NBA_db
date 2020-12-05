drop table if exists years cascade;
drop table if exists owners cascade;
drop table if exists conferences cascade;
drop table if exists coaches cascade;
drop table if exists positions cascade;
drop table if exists teams cascade;
drop table if exists owned_by_owner cascade;
drop table if exists coached_by_coach cascade;
drop table if exists players cascade;
drop table if exists plays_in_team cascade;
drop table if exists statistics cascade;

Create table years(
	year integer primary key
);

Create table owners(
	oid integer primary key,
	name varchar(128),
	dob date
);

Create table conferences(
	name varchar(128) primary key
);

Create table coaches(
	coid integer primary key,
	name varchar(128),
	dob date,
	used_play bool
);

Create table positions(
	name varchar(128) primary key
);

Create table teams(
	tid integer primary key,
	name varchar(128),
	city varchar(128),
	court varchar(128),
	conference_name varchar(128) not null,
	foreign key (conference_name) references conferences(name)
);

Create table owned_by_owner(
	year integer,
	tid integer,
	oid integer,
	primary key (year, tid, oid),
	foreign key (year) references years(year),
	foreign key (oid) references owners(oid),
	foreign key (tid) references teams(tid)
);

Create table coached_by_coach(
	year integer,
	tid integer,
	coid integer,
	primary key (year, tid, coid),
	foreign key (year) references years(year),
	foreign key (coid) references coaches(coid),
	foreign key (tid) references teams(tid)
);

Create table players(
	pid integer primary key,
	name varchar(128),
	pos varchar(128) not null,
	foreign key (pos) references positions(name)
);

Create table plays_in_team(
	year integer,
	pid integer,
	tid integer,
	primary key (year, pid, tid),
	foreign key (year) references years(year),
	foreign key (pid) references players(pid),
	foreign key (tid) references teams(tid)
);


Create table statistics(
	pid integer,
	season integer,
	gp integer,
	gs integer,
	min numeric,
	pts numeric,
	oreb numeric, 
	dr numeric,
	reb numeric,
	ast numeric,
	stl numeric,
	blk numeric,
	tuov numeric,
	pf numeric,
	ast_tuov numeric,
	per numeric,
	primary key (pid, season),
	foreign key (pid) references players(pid) on delete cascade
);