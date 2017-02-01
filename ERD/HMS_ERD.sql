/* create tables */

create table beds
(
	id int not null unique auto_increment comment 'id',
	room_id int not null comment 'room_id',
	created_at datetime not null comment 'created_at',
	updated_at datetime not null comment 'updated_at',
	name char(30) comment 'name',
	primary key (id)
) comment = 'beds';


create table bed_usage
(
	id int not null unique auto_increment comment 'id',
	bed_id int not null comment 'bed_id',
	patient_id int not null comment 'patient_id',
	created_at datetime not null comment 'created_at',
	updated_at datetime not null comment 'updated_at',
	start_date date not null comment 'start_date',
	end_date date comment 'end_date',
	-- 0: empty
	-- 1: occupied
	status tinyint default 0 not null comment 'status : 0: empty, 1: occupied',
	primary key (id)
) comment = 'bed_usage';


create table doctors
(
	id int not null unique auto_increment comment 'id',
	staff_id int not null comment 'staff_id',
	created_at datetime not null comment 'created_at',
	updated_at datetime not null comment 'updated_at',
	primary key (id)
) comment = 'doctors';


create table patients
(
	id int not null unique auto_increment comment 'id',
	user_id int not null comment 'user_id',
	doctor_id int not null comment 'doctor_id',
	created_at datetime not null comment 'created_at',
	updated_at datetime not null comment 'updated_at',
	-- 0: inpatient
	-- 1: outpatient
	type tinyint not null comment 'type : 0: inpatient, 1: outpatient',
	insurance char(100) comment 'insurance',
	primary key (id)
) comment = 'patients';


create table patient_records
(
	id int not null unique auto_increment comment 'id',
	patient_id int not null comment 'patient_id',
	bed_id int comment 'bed_id',
	created_at datetime not null comment 'created_at',
	updated_at datetime not null comment 'updated_at',
	visit_date date not null comment 'visit_date',
	disease_name varchar(500) not null comment 'disease_name',
	treatment varchar(1000) not null comment 'treatment',
	medicine_given boolean not null comment 'medicine_given',
	medicine_name varchar(500) comment 'medicine_name',
	medical_notes varchar(1000) comment 'medical_notes',
	ambulance_service_used boolean comment 'ambulance_service_used',
	billing_amount char(30) not null comment 'billing_amount',
	primary key (id)
) comment = 'patient_records';


create table rooms
(
	id int not null unique auto_increment comment 'id',
	created_at datetime not null comment 'created_at',
	updated_at datetime not null comment 'updated_at',
	name char(30) comment 'name',
	floor tinyint comment 'floor',
	primary key (id)
) comment = 'rooms';


create table shifts
(
	id int not null unique auto_increment comment 'id',
	staff_id int not null comment 'staff_id',
	created_at datetime not null comment 'created_at',
	updated_at datetime not null comment 'updated_at',
	clock_in_time time not null comment 'clock_in_time',
	clock_out_time time not null comment 'clock_out_time',
	-- 0: normal
	-- 1: emergency
	status tinyint default 0 not null comment 'status : 0: normal, 1: emergency',
	primary key (id)
) comment = 'shifts';


create table staff
(
	id int not null unique auto_increment comment 'id',
	user_id int not null comment 'user_id',
	created_at datetime not null comment 'created_at',
	updated_at datetime not null comment 'updated_at',
	qualification char(50) not null comment 'qualification',
	certification_expirations date comment 'certification_expirations',
	cell_phone_number char(20) comment 'cell_phone_number',
	email_address char(50) comment 'email_address',
	payroll char(30) not null comment 'payroll',
	personal_details varchar(500) comment 'personal_details',
	is_doctor boolean not null comment 'is_doctor',
	primary key (id)
) comment = 'staff';


create table users
(
	id int not null unique auto_increment comment 'id',
	created_at datetime not null comment 'created_at',
	updated_at datetime not null comment 'updated_at',
	login_name char(30) not null unique comment 'login_name',
	password char(50) not null comment 'password',
	-- 0: administrator
	-- 1: medical staff
	-- 2: patient
	role tinyint not null comment 'role : 0: administrator, 1: medical staff, 2: patient',
	first_name char(30) not null comment 'first_name',
	middle_name char(30) comment 'middle_name',
	last_name char(30) not null comment 'last_name',
	social_security_number char(15) not null unique comment 'social_security_number',
	address char(100) comment 'address',
	primary key (id)
) comment = 'users';


/* create foreign keys */

alter table bed_usage
	add constraint fk_bed_usage_beds foreign key (bed_id)
	references beds (id)
	on update restrict
	on delete restrict
;


alter table patient_records
	add constraint fk_patient_records_beds foreign key (bed_id)
	references beds (id)
	on update restrict
	on delete restrict
;


alter table patients
	add constraint fk_patients_doctors foreign key (doctor_id)
	references doctors (id)
	on update restrict
	on delete restrict
;


alter table bed_usage
	add constraint fk_bed_usage_patients foreign key (patient_id)
	references patients (id)
	on update restrict
	on delete restrict
;


alter table patient_records
	add constraint fk_patient_records_patients foreign key (patient_id)
	references patients (id)
	on update restrict
	on delete restrict
;


alter table beds
	add constraint fk_beds_rooms foreign key (room_id)
	references rooms (id)
	on update restrict
	on delete restrict
;


alter table doctors
	add constraint fk_doctors_staff foreign key (staff_id)
	references staff (id)
	on update restrict
	on delete restrict
;


alter table shifts
	add constraint fk_shifts_staff foreign key (staff_id)
	references staff (id)
	on update restrict
	on delete restrict
;


alter table patients
	add constraint fk_patients_users foreign key (user_id)
	references users (id)
	on update restrict
	on delete restrict
;


alter table staff
	add constraint fk_staff_users foreign key (user_id)
	references users (id)
	on update restrict
	on delete restrict
;
