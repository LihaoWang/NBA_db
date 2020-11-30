drop table if exists years cascade;
drop table if exists owners cascade;
drop table if exists conferences cascade;
drop table if exists coaches cascade;
drop table if exists positions cascade;
drop table if exists teams cascade;
drop table if exists owned_by_onwer cascade;
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
	former_player bool
);

Create table positions(
	posid integer primary key,
	name varchar(128)
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
	posid integer not null,
	foreign key (posid) references positions(posid)
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
	pts numeric,
	reb numeric,
	ast numeric,
	blk numeric,
	stl numeric,
	pf numeric,
	TurnOver numeric,
	FG numeric,
	ThreePoint numeric,
	FT numeric,
	gp integer,
	min numeric,
	primary key (pid, season),
	foreign key (pid) references players(pid) on delete cascade
);

insert into positions values (1, 'C');
insert into positions values (2, 'PF');
insert into positions values (3, 'SF');
insert into positions values (4, 'SG');
insert into positions values (5, 'PG');
insert into owners values (1, 'Tony Ressler');
insert into owners values (2, 'Wyc Grousbeck');
insert into owners values (3, 'Joseph Tsai');
insert into owners values (4, 'Michael Jordan');
insert into owners values (5, 'Jerry Reinsdorf');
insert into owners values (6, 'Dan Gilbert');
insert into owners values (7, 'Mark Cuban');
insert into owners values (8, 'Ann Walton Kroenke');
insert into owners values (9, 'Tom Gores');
insert into owners values (10, 'Joe Lacob');
insert into owners values (11, 'Tilman Fertitta');
insert into owners values (12, 'Herbert Simon');
insert into owners values (13, 'Steve Ballmer');
insert into owners values (14, 'Jeanie Buss');
insert into owners values (15, 'Robert J. Pera');
insert into owners values (16, 'Micky Arison');
insert into owners values (17, 'Marc Lasry');
insert into owners values (18, 'Glen Taylor');
insert into owners values (19, 'Gayle Benson');
insert into owners values (20, 'James Dolan');
insert into owners values (21, 'Clay Bennett');
insert into owners values (22, 'Dan DeVos');
insert into owners values (23, 'Joshua Harris');
insert into owners values (24, 'Robert Sarver');
insert into owners values (25, 'Jody Allen');
insert into owners values (26, 'Vivek Ranadivé');
insert into owners values (27, 'Peter Holt');
insert into owners values (28, 'Larry Tanenbaum');
insert into owners values (29, 'Gail Miller');
insert into owners values (30, 'Ted Leonsis');
insert into conferences values ('East');
insert into conferences values ('West');
insert into teams values (1,  'Atlanta Hawks', 'Atlanta', 'State Farm Arena', 'East');
insert into teams values (2,  'Boston Celtics', 'Boston', 'TD Garden', 'East');
insert into teams values (3,  'Brooklyn Nets', 'Brooklyn', 'Barclays Center', 'East');
insert into teams values (4,  'Charlotte Hornets', 'Charlotte', 'Spectrum Center', 'East');
insert into teams values (5,  'Chicago Bulls', 'Chicago', 'United Center', 'East');
insert into teams values (6,  'Cleveland Cavaliers', 'Cleveland', 'Rocket Mortgage FieldHouse', 'East');
insert into teams values (7,  'Dallas Mavericks', 'Dallas', 'American Airlines Center', 'West');
insert into teams values (8,  'Denver Nuggets', 'Denver', 'Pepsi Center', 'West');
insert into teams values (9,  'Detroit Pistons', 'Detroit', 'Little Caesars Arena', 'East');
insert into teams values (10,  'Golden State Warriors', 'Oakland', 'Oracle Arena', 'West');
insert into teams values (11,  'Houston Rockets', 'Houston', 'Toyota Center', 'West');
insert into teams values (12,  'Indiana Pacers', 'Indiana', 'Bankers Life Fieldhouse', 'East');
insert into teams values (13,  'Los Angeles Clippers', 'Los Angeles', 'Staples Center', 'West');
insert into teams values (14,  'Los Angeles Lakers', 'Los Angeles', 'Staples Center', 'West');
insert into teams values (15,  'Memphis Grizzlies', 'Memphis', 'FedExForum', 'West');
insert into teams values (16,  'Miami Heat', 'Miami', 'American Airlines Arena', 'East');
insert into teams values (17,  'Milwaukee Bucks', 'Milwaukee', 'Fiserv Forum', 'East');
insert into teams values (18,  'Minnesota Timberwolves', 'Minnesota', 'Target Center', 'West');
insert into teams values (19,  'New Orleans Pelicans', 'New Orleans', 'Smoothie King Center', 'West');
insert into teams values (20,  'New York Knicks', 'New York', 'Madison Square Garden', 'East');
insert into teams values (21,  'Oklahoma City Thunder', 'Oklahoma City', 'Chesapeake Energy Arena', 'West');
insert into teams values (22,  'Orlando Magic', 'Orlando', 'Amway Center', 'East');
insert into teams values (23,  'Philadelphia 76ers', 'Philadelphia', 'Wells Fargo Center', 'East');
insert into teams values (24,  'Phoenix Suns', 'Phoenix', 'Talking Stick Resort Arena', 'West');
insert into teams values (25,  'Portland Trail Blazers', 'Portland', 'Moda Center', 'West');
insert into teams values (26,  'Sacramento Kings', 'Sacramento', 'Golden 1 Center', 'West');
insert into teams values (27,  'San Antonio Spurs', 'San Antonio', 'AT&T Center', 'West');
insert into teams values (28,  'Toronto Raptors', 'Toronto', 'Scotiabank Arena', 'East');
insert into teams values (29,  'Utah Jazz', 'Utah', 'Vivint Smart Home Arena', 'West');
insert into teams values (30,  'Washington Wizards', 'Washington DC', 'Capital One Arena', 'East');
insert into teams values (31,  'Atlanta Hawks', 'Atlanta', 'State Farm Arena', 'East');
insert into teams values (32,  'Boston Celtics', 'Boston', 'TD Garden', 'East');
insert into teams values (33,  'Brooklyn Nets', 'Brooklyn', 'Barclays Center', 'East');
insert into teams values (34,  'Charlotte Hornets', 'Charlotte', 'Spectrum Center', 'East');
insert into teams values (35,  'Chicago Bulls', 'Chicago', 'United Center', 'East');
insert into teams values (36,  'Cleveland Cavaliers', 'Cleveland', 'Rocket Mortgage FieldHouse', 'East');
insert into teams values (37,  'Dallas Mavericks', 'Dallas', 'American Airlines Center', 'West');
insert into teams values (38,  'Denver Nuggets', 'Denver', 'Pepsi Center', 'West');
insert into teams values (39,  'Detroit Pistons', 'Detroit', 'Little Caesars Arena', 'East');
insert into teams values (40,  'Golden State Warriors', 'Oakland', 'Oracle Arena', 'West');
insert into teams values (41,  'Houston Rockets', 'Houston', 'Toyota Center', 'West');
insert into teams values (42,  'Indiana Pacers', 'Indiana', 'Bankers Life Fieldhouse', 'East');
insert into teams values (43,  'Los Angeles Clippers', 'Los Angeles', 'Staples Center', 'West');
insert into teams values (44,  'Los Angeles Lakers', 'Los Angeles', 'Staples Center', 'West');
insert into teams values (45,  'Memphis Grizzlies', 'Memphis', 'FedExForum', 'West');
insert into teams values (46,  'Miami Heat', 'Miami', 'American Airlines Arena', 'East');
insert into teams values (47,  'Milwaukee Bucks', 'Milwaukee', 'Fiserv Forum', 'East');
insert into teams values (48,  'Minnesota Timberwolves', 'Minnesota', 'Target Center', 'West');
insert into teams values (49,  'New Orleans Pelicans', 'New Orleans', 'Smoothie King Center', 'West');
insert into teams values (50,  'New York Knicks', 'New York', 'Madison Square Garden', 'East');
insert into teams values (51,  'Oklahoma City Thunder', 'Oklahoma City', 'Chesapeake Energy Arena', 'West');
insert into teams values (52,  'Orlando Magic', 'Orlando', 'Amway Center', 'East');
insert into teams values (53,  'Philadelphia 76ers', 'Philadelphia', 'Wells Fargo Center', 'East');
insert into teams values (54,  'Phoenix Suns', 'Phoenix', 'Talking Stick Resort Arena', 'West');
insert into teams values (55,  'Portland Trail Blazers', 'Portland', 'Moda Center', 'West');
insert into teams values (56,  'Sacramento Kings', 'Sacramento', 'Golden 1 Center', 'West');
insert into teams values (57,  'San Antonio Spurs', 'San Antonio', 'AT&T Center', 'West');
insert into teams values (58,  'Toronto Raptors', 'Toronto', 'Scotiabank Arena', 'East');
insert into teams values (59,  'Utah Jazz', 'Utah', 'Vivint Smart Home Arena', 'West');
insert into teams values (60,  'Washington Wizards', 'Washington DC', 'Capital One Arena', 'East');
insert into teams values (61,  'Atlanta Hawks', 'Atlanta', 'State Farm Arena', 'East');
insert into teams values (62,  'Boston Celtics', 'Boston', 'TD Garden', 'East');
insert into teams values (63,  'Brooklyn Nets', 'Brooklyn', 'Barclays Center', 'East');
insert into teams values (64,  'Charlotte Hornets', 'Charlotte', 'Spectrum Center', 'East');
insert into teams values (65,  'Chicago Bulls', 'Chicago', 'United Center', 'East');
insert into teams values (66,  'Cleveland Cavaliers', 'Cleveland', 'Rocket Mortgage FieldHouse', 'East');
insert into teams values (67,  'Dallas Mavericks', 'Dallas', 'American Airlines Center', 'West');
insert into teams values (68,  'Denver Nuggets', 'Denver', 'Pepsi Center', 'West');
insert into teams values (69,  'Detroit Pistons', 'Detroit', 'Little Caesars Arena', 'East');
insert into teams values (70,  'Golden State Warriors', 'Oakland', 'Chase Center', 'West');
insert into teams values (71,  'Houston Rockets', 'Houston', 'Toyota Center', 'West');
insert into teams values (72,  'Indiana Pacers', 'Indiana', 'Bankers Life Fieldhouse', 'East');
insert into teams values (73,  'Los Angeles Clippers', 'Los Angeles', 'Staples Center', 'West');
insert into teams values (74,  'Los Angeles Lakers', 'Los Angeles', 'Staples Center', 'West');
insert into teams values (75,  'Memphis Grizzlies', 'Memphis', 'FedExForum', 'West');
insert into teams values (76,  'Miami Heat', 'Miami', 'American Airlines Arena', 'East');
insert into teams values (77,  'Milwaukee Bucks', 'Milwaukee', 'Fiserv Forum', 'East');
insert into teams values (78,  'Minnesota Timberwolves', 'Minnesota', 'Target Center', 'West');
insert into teams values (79,  'New Orleans Pelicans', 'New Orleans', 'Smoothie King Center', 'West');
insert into teams values (80,  'New York Knicks', 'New York', 'Madison Square Garden', 'East');
insert into teams values (81,  'Oklahoma City Thunder', 'Oklahoma City', 'Chesapeake Energy Arena', 'West');
insert into teams values (82,  'Orlando Magic', 'Orlando', 'Amway Center', 'East');
insert into teams values (83,  'Philadelphia 76ers', 'Philadelphia', 'Wells Fargo Center', 'East');
insert into teams values (84,  'Phoenix Suns', 'Phoenix', 'Talking Stick Resort Arena', 'West');
insert into teams values (85,  'Portland Trail Blazers', 'Portland', 'Moda Center', 'West');
insert into teams values (86,  'Sacramento Kings', 'Sacramento', 'Golden 1 Center', 'West');
insert into teams values (87,  'San Antonio Spurs', 'San Antonio', 'AT&T Center', 'West');
insert into teams values (88,  'Toronto Raptors', 'Toronto', 'Scotiabank Arena', 'East');
insert into teams values (89,  'Utah Jazz', 'Utah', 'Vivint Smart Home Arena', 'West');
insert into teams values (90,  'Washington Wizards', 'Washington DC', 'Capital One Arena', 'East');