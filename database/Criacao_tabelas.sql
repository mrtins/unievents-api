create schema evt;

create table evt.tb_profile (
	id_profile		smallserial			not null,
	nm_profile		varchar(40)			not null
);

alter table evt.tb_profile add constraint pk_profile primary key (id_profile);

create table evt.tb_term (
	id_term		smallserial			not null,
	cd_term		varchar(2)			not null,
	nm_term		varchar(20)			not null
);

alter table evt.tb_term add constraint pk_term primary key (id_term);

create table evt.tb_user (
	id_user			bigserial		not null,
	id_profile		smallint		not null,
	nm_first_name	varchar(20)		not null,
	nm_last_name	varchar(80)		null,
	cd_enrollment	varchar(60)		not null,
	tx_email		varchar(320)	not null,
	tx_password		varchar(30)		not null
);

alter table evt.tb_user add constraint pk_user primary key (id_user);
alter table evt.tb_user add constraint fk_user_profile foreign key (id_profile) references evt.tb_profile(id_profile);

create table evt.tb_professor (
	id_professor			serial			not null,
	id_user					bigint			not null
);

alter table evt.tb_professor add constraint pk_professor primary key (id_professor);
alter table evt.tb_professor add constraint fk_professor_user foreign key (id_user) references evt.tb_user(id_user);


create table evt.tb_course (
	id_course 						serial			not null,
	id_coordinator					int				not null,
	nm_course						varchar(80) 	not null,
	id_insertion_user				bigint			not null,
	dh_insertion					timestamp		not null
);

alter table tb_course add constraint pk_course primary key (id_course);
alter table evt.tb_course add constraint fk_course_coordinator foreign key (id_coordinator) references evt.tb_professor(id_professor);
alter table evt.tb_course add constraint fk_course_insertion_user foreign key (id_insertion_user) references evt.tb_user(id_user);

create table evt.tb_student (
	id_student 					serial 			not null,
	id_user						bigint			not null,
	id_course 					int				not null,
	id_term						smallint		null,
	qt_complementary_hours		int				null
);

alter table tb_student add constraint pk_student primary key (id_student);
alter table evt.tb_student add constraint fk_student_user foreign key (id_user) references evt.tb_user(id_user);
alter table evt.tb_student add constraint fk_student_course foreign key (id_course) references evt.tb_course(id_course);
alter table evt.tb_student add constraint fk_student_term foreign key (id_term) references evt.tb_term(id_term);

create table evt.tb_local (
	id_local						serial			not null,
	nm_local						varchar(120)	not null,
	cd_room							varchar(10)		null,
	cd_floor						char(1)			null,
	cd_zip_code						varchar(20)		null,
	cd_location_number				varchar(6)		null,
	tx_complement					varchar(220)	null,
	id_insertion_user				bigint			not null,
	dh_insertion					timestamp		not null
);

alter table tb_local add constraint pk_local primary key (id_local);
alter table evt.tb_local add constraint fk_local_insertion_user foreign key (id_insertion_user) references evt.tb_user(id_user);


create table evt.tb_professor_course (
	id_professor_course		serial			not null,
	id_professor			int				not null,
	id_course				int				not null,
	id_insertion_user		bigint			not null,
	dh_insertion			timestamp		not null
);

alter table tb_professor_course add constraint pk_professor_course primary key (id_professor_course);
alter table evt.tb_professor_course add constraint fk_professor_course_professor foreign key (id_professor) references evt.tb_professor(id_professor);
alter table evt.tb_professor_course add constraint fk_professor_course_course foreign key (id_course) references evt.tb_course(id_course);
alter table evt.tb_professor_course add constraint fk_professor_course_insertion_user foreign key (id_insertion_user) references evt.tb_user(id_user);

create table evt.tb_event (
	id_event					bigserial 		not null,
	id_local					int				not null,
	id_professor				int				null,
	nm_event					varchar(120)	not null,
	tx_description				text			null,
	tx_target_audience			varchar(160)	null,
	qt_vacancy					int				null,
	qt_hours					int				not null,
	vl_enrollment				decimal(12, 2)	null,
	ph_cover					bytea			null,
	dt_event					date			not null,
	dt_enrollment_ending		timestamp		null,
	hr_opening					time			not null,
	hr_ending					time			not null,
	id_insertion_user			bigint			not null,
	dh_insertion				timestamp		not null
);

alter table evt.tb_event add constraint pk_event primary key (id_event);
alter table evt.tb_event add constraint fk_event_local foreign key (id_local) references evt.tb_local(id_local);
alter table evt.tb_event add constraint fk_event_professor foreign key (id_professor) references evt.tb_professor(id_professor);
alter table evt.tb_event add constraint fk_event_insertion_user foreign key (id_insertion_user) references evt.tb_user(id_user);

create table evt.tb_event_course (
	id_event_course					bigserial		not null,
	id_event						bigint			not null,
	id_course						int				null,
	id_insertion_user				bigint			not null,
	dh_insertion					timestamp		not null
);

alter table evt.tb_event_course add constraint pk_event_course primary key (id_event_course);
alter table evt.tb_event_course add constraint fk_event_course_event foreign key (id_event) references evt.tb_event (id_event);
alter table evt.tb_event_course add constraint fk_event_course_course foreign key (id_course) references evt.tb_course (id_course);
alter table evt.tb_event_course add constraint fk_event_course_insertion_user foreign key (id_insertion_user) references evt.tb_user(id_user);


create table evt.tb_student_event_enrollment (
	id_student_event_enrollment		bigserial		not null,
	id_student						int				not null,
	id_event						bigint			not null,
	dh_enrollment					timestamp		not null,
	dh_participation				timestamp		null,
	id_insertion_user				bigint			not null,
	dh_insertion					timestamp		not null
);

alter table evt.tb_student_event_enrollment add constraint pk_student_event_enrollment primary key (id_student_event_enrollment);
alter table evt.tb_student_event_enrollment add constraint fk_student_event_enrollment_student foreign key (id_student) references evt.tb_student (id_student);
alter table evt.tb_student_event_enrollment add constraint fk_student_event_enrollment_event foreign key (id_event) references evt.tb_event (id_event);
alter table evt.tb_student_event_enrollment add constraint fk_event_course_insertion_user foreign key (id_insertion_user) references evt.tb_user(id_user);

-- Adding audition
alter table evt.tb_professor add column id_insertion_user bigint not null default(1);
alter table evt.tb_professor alter column id_insertion_user drop default;
alter table evt.tb_professor add column dh_insertion timestamp not null default '2019-12-16 00:00:00';
alter table evt.tb_professor alter column dh_insertion drop default;
alter table evt.tb_professor add constraint fk_professor_insertion_user foreign key (id_insertion_user) references evt.tb_user (id_user);

alter table evt.tb_profile add column id_insertion_user bigint not null default(1);
alter table evt.tb_profile alter column id_insertion_user drop default;
alter table evt.tb_profile add column dh_insertion timestamp not null default '2019-11-21 00:00:00';
alter table evt.tb_profile alter column dh_insertion drop default;
alter table evt.tb_profile add constraint fk_profile_insertion_user foreign key (id_insertion_user) references evt.tb_user (id_user);

alter table evt.tb_student add column id_insertion_user bigint not null default(1);
alter table evt.tb_student alter column id_insertion_user drop default;
alter table evt.tb_student add column dh_insertion timestamp not null default '2019-11-21 00:00:00';
alter table evt.tb_student alter column dh_insertion drop default;
alter table evt.tb_student add constraint fk_student_insertion_user foreign key (id_insertion_user) references evt.tb_user (id_user);

alter table evt.tb_term add column id_insertion_user bigint not null default(1);
alter table evt.tb_term alter column id_insertion_user drop default;
alter table evt.tb_term add column dh_insertion timestamp not null default '2019-11-21 00:00:00';
alter table evt.tb_term alter column dh_insertion drop default;
alter table evt.tb_term add constraint fk_term_insertion_user foreign key (id_insertion_user) references evt.tb_user (id_user);






