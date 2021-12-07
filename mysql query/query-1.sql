create database documentManager;
use documentManager;

create table user
(
	user_id varchar(5),
    password varchar(10),
    email varchar(30),
    name varchar(40),
    uFlag int not null unique,
    dpt_id varchar(5),
    primary key(user_id,uFlag)
);

ALTER TABLE user
ADD FOREIGN KEY (dpt_id)
REFERENCES department(d_id);

drop table user;

create table userType
(
	uFlag int primary key,
    adminType int,
    empType int,
	constraint fk_userType foreign key (uFlag) references user(uFlag)
);


create table branch
(
	b_id varchar(5) primary key,
    b_name varchar(30) not null unique
);


drop table branch;

create table branchInfo
(
	b_name varchar(30) primary key,
    address_no varchar(10),
	street varchar(30),
    town varchar(30),
	constraint fk_branch_info foreign key (b_name) references branch(b_name)
);

create table job_info
(
	job_id varchar(5) primary key,
    amount real,
    constraint check (amount > 0)
);

ALTER TABLE job_info
ADD FOREIGN KEY (job_id)
REFERENCES job(job_id);

drop table job_info;

create table bill_info
(
	bill_id varchar(5) primary key,
    is_paid boolean
 );

create table payment
(
	bill_id varchar(5),
    date date,
    job_id varchar(5),
    customer_id varchar(5),
    primary key(bill_id,job_id,date),
    constraint fk_payment1 foreign key (bill_id) references bill_info(bill_id),
    constraint fk_payment2 foreign key (job_id) references job(job_id),
    constraint fk_payment3 foreign key (customer_id) references user(user_id)
);

drop table payment;


create table department
(
	d_id varchar(5) primary key,
    d_name varchar(30),
    branch_id varchar(5),
	constraint fk_dept foreign key (branch_id) references branch(b_id)
);


create table document
(
	doc_id varchar(5) primary key,
    doc_name varchar(30),
    type varchar(30),
    date date,
    department_id varchar(5),
    constraint fk_doc foreign key (department_id) references department(d_id)
);


create table job
(
	job_id varchar(5) primary key,
    date date,
    admin_id varchar(5),
    emp_id varchar(5),
    doc_id varchar(5),
	constraint fk_job1 foreign key (admin_id) references user(user_id),
    constraint fk_job2 foreign key (emp_id) references user(user_id),
    constraint fk_job3 foreign key (doc_id) references document(doc_id)
);


create table request
(
	doc_id varchar(5),
    admin_id varchar(5),
	customer_id varchar(5),
    primary key(doc_id,admin_id,customer_id),
	constraint fk_req1 foreign key (admin_id) references user(user_id),
    constraint fk_req2 foreign key (customer_id) references user(user_id),
    constraint fk_req3 foreign key (doc_id) references document(doc_id)    
);


create table userTeleNo
(
	user_id varchar(5) primary key,
    tele varchar(10),
    constraint fk_tele foreign key (user_id) references user(user_id)
);




#use database
use documentmanager;

#view for see profile details by one user
DELIMITER $$
create view as myProfile 
	select u.user_id as userID,u.name as name,u.email as email, b.b_name as branchName, d.d_name as dpt_name
    from user u,department d,branch b
    where u.dpt_id=d.d_id and d.branch_id=b.b_id
DELIMITER ;    
select * from myprofile;
select * from myJobs;


#employee can view their list of jobs
USE `documentmanager`;
CREATE  OR REPLACE VIEW `myJobs` AS
	select j.job_id as jobId, j.date as date, d.doc_id as docId, d.doc_name as docName
    from job j,user u,document d
    where u.user_id = j.emp_id and j.doc_id=d.doc_id;

#admin can view selected employee or customer details
DELIMITER $$
USE `documentmanager`$$
CREATE PROCEDURE `seeEmployee` (emp_id varchar(5))
BEGIN
		select u.user_id as employee_id, u.name as name, u.email as email, u.password as password
        from user u
        where u.user_id = emp_id;
END$$
DELIMITER ;


#admin can register customer and employees
DELIMITER $$
USE `documentmanager`$$
CREATE FUNCTION `registerEmployee` (uId varchar(5),uName varchar(40),uEmail varchar(30),uPassword varchar(10),uDpt_id varchar(5),uUFlag int)
RETURNS INTEGER
BEGIN
	insert into user(user_id,name,email,password,dpt_id,uFlag) values(uId,uName,uEmail,uPassword,uDpt_id,uUFlag);
RETURN 1;
END$$

DELIMITER ;
















