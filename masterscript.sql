-- DROP DATABASE MCS;
CREATE DATABASE MCS;
USE MCS;

create table login(
loginid varchar(50),
pass varchar(50),
username varchar(64),
title varchar(32),
PRIMARY KEY (loginid)
);

insert into login
VALUES ('tMcPhee', 'password', 'Tyler McPhee', 'DBA');
insert into login
VALUES ('mGiorno', 'password', 'Matthew Giorno', 'DBA');
insert into login
VALUES ('kGenereux', 'password', 'Kevin Genereux', 'DBA');
insert into login
VALUES ('nSissons', 'password', 'Noah Sissons', 'DBA');
insert into login
VALUES ('pDavis', 'password', 'Peter Davis', 'Doctor');
insert into login
VALUES ('mGuinn', 'password', 'Michael Guinn', 'Doctor');
insert into login
VALUES ('sChomitz', 'password', 'Sarah Chomitz', 'Doctor');
insert into login
VALUES ('nHoltz', 'password', 'Nancy Holtz', 'Doctor');
insert into login
VALUES ('mGibbs', 'password2', 'Mark Gibbs', 'Doctor');
insert into login
VALUES ('pForeman', 'password', 'Peter Foreman', 'Doctor');
insert into login
VALUES ('sBrodsky', 'password', 'Steven Brodsky', 'Doctor');
insert into login
VALUES ('rClark', 'password', 'Robert Clark', 'Doctor');
insert into login
VALUES ('tJames', 'password', 'James Terry', 'Doctor');
insert into login
VALUES ('rJohnson', 'password', 'Robert Johnson', 'Doctor');
insert into login
VALUES ('jMiller', 'password', 'Janet Miller', 'Doctor');
insert into login
VALUES ('jBryant', 'password', 'Joseph Bryant', 'Doctor');
insert into login
VALUES ('lAllen', 'password', 'Lori Allen', 'Doctor');
insert into login
VALUES ('dPowell', 'password', 'Daniel Powell', 'Doctor');
insert into login
VALUES ('jPrice', 'password', 'John Price', 'Doctor');
insert into login
VALUES ('tCampbell', 'password', 'Theresa Campbell', 'Doctor');
insert into login
VALUES ('zRenfro', 'password', 'Zapp Renfro', 'Nurse');

-- entity set ‘Patient’
CREATE TABLE Patient(
patientMCS CHAR(9),
patientFirstName VARCHAR(64),
patientLastName VARCHAR(64),
patientSIN CHAR(11),
patientHeight INTEGER,
patientWeight FLOAT,
patientDateOfBirth DATE,
patientGender CHAR,
patientHealthCard LONG,
patientPostalCode CHAR(7),
patientAddress VARCHAR(64),
patientCity VARCHAR(32),
patientPhoneNumber CHAR(17),
patientAdvancedDirective VARCHAR(32),
patientAdvDirOnFile VARCHAR(32),
patientAllergies VARCHAR(64),
patientAdvDirDate DATE,
PRIMARY KEY (patientMCS));

-- entity set ‘Condition’
CREATE TABLE Conditions (
conditionCode CHAR(8),
conditionName VARCHAR(64),
PRIMARY KEY (conditionCode));

-- relationship between ‘Patient’ and ‘Condition’
CREATE TABLE DiagnosedWith(
conditionCode CHAR(8), 
patientMCS CHAR(9),
PRIMARY KEY (conditionCode, patientMCS),
FOREIGN KEY (conditionCode) REFERENCES Conditions (conditionCode),
FOREIGN KEY (patientMCS) REFERENCES Patient (patientMCS));

-- relationship combining ‘Is Written About’ and ‘Notes’
CREATE TABLE Notes(
patientMCS CHAR(9) NOT NULL,
focus VARCHAR(128),
contents BLOB,
dateOfReport DATE,
timeOfReport TIME,
userName VARCHAR(64),
userTitle VARCHAR(32),
noteID INTEGER,
PRIMARY KEY (noteID),
FOREIGN KEY (patientMCS) REFERENCES Patient (patientMCS));

-- entity set Medications
CREATE TABLE Medications (
genericName VARCHAR(64),
tradeName VARCHAR(64),
PRIMARY KEY(genericName));

-- relationship between ‘Patient’ and ‘Medications’ 
CREATE TABLE Takes(
patientMCS CHAR(9),
genericName VARCHAR(64),
medStatus VARCHAR(12),
dosage VARCHAR(10),
route VARCHAR(16),
stopDate DATETIME,
startDate DATETIME,
sigSch VARCHAR(16),
lastAdmin DATETIME,
doseAdmin VARCHAR(16),
PRIMARY KEY(genericName, patientMCS),
FOREIGN KEY (genericName) REFERENCES Medications (genericName),
FOREIGN KEY (patientMCS) REFERENCES Patient (patientMCS));

-- relationship combining  ‘Contacts’ and ‘Has’
CREATE TABLE Contacts (
patientMCS CHAR(9) NOT NULL,
contactPostalCode CHAR(7),
contactCity VARCHAR(32),
contactAddress VARCHAR(64),
contactName VARCHAR(64),
contactPhoneNumber CHAR(17),
contactRelationship VARCHAR(32),
PRIMARY KEY(contactName, patientMCS),
FOREIGN KEY (patientMCS) REFERENCES Patient (patientMCS));

-- entity set ‘Doctor’
CREATE TABLE Doctor(
doctorLastName VARCHAR(64),
doctorFirstName VARCHAR(64),
doctorPhoneNumber CHAR(17),
doctorTitle VARCHAR(64),
doctorSIN CHAR(11),
PRIMARY KEY(doctorSIN));

-- relationship combining  ‘is involved in’, ‘Order’, and ‘Orders’
CREATE TABLE Orders(
orderID INTEGER,
doctorSIN CHAR(11) NOT NULL,
patientMCS CHAR(9) NOT NULL,
orderDate DATE,
serviceTime TIME,
orderTime TIME,
procedureName VARCHAR(64),
orderStatus VARCHAR(32),
serviceDate DATE,
PRIMARY KEY (orderID, patientMCS, doctorSIN),
FOREIGN KEY (doctorSIN) REFERENCES Doctor (doctorSIN),
FOREIGN KEY (patientMCS) REFERENCES Patient (patientMCS));

-- relationship between Patient and Doctor
CREATE TABLE IsProvidedForBy(
patientMCS CHAR(9),
role varchar(32),
doctorSIN CHAR(11),
PRIMARY KEY (patientMCS, doctorSIN),
FOREIGN KEY (patientMCS) REFERENCES Patient (patientMCS),
FOREIGN KEY (doctorSIN) REFERENCES Doctor (doctorSIN));

-- entity set ‘Unit’
CREATE TABLE Unit(
unitCode CHAR(2),
unitName VARCHAR(32),
PRIMARY KEY (unitCode));

-- relationship between ‘Doctor’ and Unit
CREATE TABLE IsPartOf(
doctorSIN CHAR(11),
unitCode CHAR(2),
PRIMARY KEY (doctorSIN, unitCode),
FOREIGN KEY (doctorSIN) REFERENCES Doctor (doctorSIN),
FOREIGN KEY (unitCode) REFERENCES Unit (unitCode));

-- relationship combining ‘is within’ and ‘Room’
CREATE TABLE Room(
unitCode CHAR(2),
roomNumber INTEGER,
PRIMARY KEY (roomNumber),
FOREIGN KEY (unitCode) REFERENCES Unit (unitCode));

-- relationship combining ‘Resides In’
CREATE TABLE ResidesIn(
patientMCS VARCHAR(9) unique,
roomNumber INTEGER,
bedNumber INTEGER,
PRIMARY KEY(patientMCS, roomNumber),
UNIQUE (roomNumber, bedNumber),
FOREIGN KEY (roomNumber) REFERENCES Room (roomNumber),
FOREIGN KEY (patientMCS) REFERENCES Patient (patientMCS),
CHECK ( bedNumber = 1
OR bedNumber = 2));

-- relationship combining ‘Report’, ‘is subject of’, and ‘written by’
CREATE TABLE Report(
patientMCS CHAR(9),
doctorSIN CHAR(11),
reportid INTEGER,
examDate DATE,
procedureName VARCHAR(64),
reportSubmissionDate DATETIME,
contents BLOB,
radiologist VARCHAR(32),
reportType VARCHAR(16),
PRIMARY KEY (reportid),
FOREIGN KEY (patientMCS) REFERENCES Patient (patientMCS),
FOREIGN KEY (doctorSIN) REFERENCES Doctor (doctorSIN));

-- relationship between ‘Report’ and ‘Doctor’
CREATE TABLE ReferredBy(
reportid INTEGER,
doctorSIN CHAR(11),
PRIMARY KEY(reportid,doctorSIN),
FOREIGN KEY(reportid) REFERENCES Report (reportid),
FOREIGN KEY(doctorSIN) REFERENCES Doctor (doctorSIN));

-- relationship combining ‘Has’ and ‘Laboratory Results’
CREATE TABLE LaboratoryResults(
patientMCS CHAR(9) NOT NULL,
labDateTime DATETIME,
PRIMARY KEY(patientMCS, labDateTime),
FOREIGN KEY(patientMCS) REFERENCES Patient (patientMCS));

-- entity set ‘HematologyResults’
CREATE TABLE HematologyResults (
patientMCS CHAR(9) NOT NULL,
labDateTime DATETIME,
WBC REAL,
RBC REAL,
HGB REAL,
HCT REAL,
pitCount INTEGER,
neutrophils INTEGER,
lymphocytes INTEGER,
monocytes INTEGER,
eosinophils INTEGER,
basophils INTEGER,
PRIMARY KEY(patientMCS, labDateTime),
FOREIGN KEY(patientMCS) REFERENCES Patient (patientMCS));

-- entity set ‘ChemistryResults’
CREATE TABLE ChemistryResults(
patientMCS CHAR(9) NOT NULL,
labDateTime DATETIME,
sodium INTEGER,
potassium REAL,
chloride INTEGER,
BUN INTEGER,
creatinine REAL,
estimatedGFR REAL,
calcium REAL,
totalBilirubin REAL,
AST INTEGER,
ALT INTEGER,
PRIMARY KEY(patientMCS, labDateTime),
FOREIGN KEY(patientMCS) REFERENCES Patient (patientMCS));

-- entity set ‘UrinalysisResults’
CREATE TABLE UrinalysisResults(
patientMCS CHAR(9) NOT NULL,
labDateTime DATETIME,
colour VARCHAR(32),
appearance VARCHAR(64),
specificGravity REAL,
pH INTEGER,
protein CHAR(8),
glucose CHAR(8),
elythrocytes CHAR(8),
leukocyteEsterase CHAR(8),
nitrite CHAR(8),
kestones CHAR(8),
PRIMARY KEY(patientMCS, labDateTime),
FOREIGN KEY(patientMCS) REFERENCES Patient (patientMCS));

-- entity set CoagulationResults
CREATE TABLE CoagulationResults(
patientMCS CHAR(9) NOT NULL,
labDateTime DATETIME,
INR REAL,
PRIMARY KEY(patientMCS, labDateTime),
FOREIGN KEY(patientMCS) REFERENCES Patient (patientMCS));

CREATE TABLE ToxicologyResults(
patientMCS CHAR(9) NOT NULL,
labDateTime DATETIME,
Marijuana CHAR(8),
THC CHAR(8),
cocaine CHAR(8),
opiates CHAR(8),
oxycodone VARCHAR(8),
amphetamines VARCHAR(8),
PRIMARY KEY(patientMCS, labDateTime),
FOREIGN KEY(patientMCS) REFERENCES Patient (patientMCS));

CREATE TABLE SerologyResults(
patientMCS CHAR(9) NOT NULL,
labDateTime DATETIME,
HIV CHAR(8),
HepatitisA CHAR(8),
HepatitisB CHAR(8),
HepatitisC CHAR(8),
PRIMARY KEY(patientMCS, labDateTime),
FOREIGN KEY(patientMCS) REFERENCES Patient (patientMCS));

INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS358852','Abigail','Abraham','903 287 099','71','156','1966-03-26','F','7006-878-872-ER','I3Z 4N3','7039 Bay Meadows Avenue','Thunder Bay','+1 (142) 026-7935','FULL CODE','INCOMPLETE','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS605959','Alexandra','Allan','504 948 502','63','172','1941-06-25','F','0716-555-116-EB','T7W 3M0','65 Peachtree St.','Thunder Bay','+1 (700) 808-5911','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS398056','Alison','Alsop','370 546 000','57','149','1991-01-22','M','2030-298-974-WW','Z0Q 4H3','79 Newbridge Ave.','Thunder Bay','+1 (463) 397-9512','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS322892','Amanda','Anderson','160 052 294','71','150','1975-10-06','F','7750-499-770-AO','Q7K 1J3','9882 Valley Drive','Thunder Bay','+1 (362) 972-5699','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS281321','Amelia','Arnold','253 556 941','56','172','1986-01-09','M','0738-238-844-VH','T7M 5P3','797 Alton St.','Thunder Bay','+1 (928) 384-9117','FULL CODE','YES','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS249465','Amy','Avery','742 010 900','60','212','1947-02-26','M','0033-948-240-CI','N0H 6N5','8551 Golf Court','Kenora','+1 (945) 040-9183','FULL CODE','YES','Milk','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS624616','Andrea','Bailey','023 390 817','70','208','1980-02-07','M','3758-240-051-JX','H9K 1L0','9 West River Rd.','Thunder Bay','+1 (184) 279-5467','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS300361','Angela','Baker','781 609 507','72','193','1966-03-24','M','2648-513-496-NE','V3R 1R1','570 Depot Road','Thunder Bay','+1 (432) 580-2893','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS294872','Anna','Ball','862 947 220','69','188','1935-05-09','M','1615-507-515-EQ','Y7O 1J2','5 W. Cooper St.','Thunder Bay','+1 (306) 666-8520','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS948637','Anne','Bell','606 994 062','59','165','1958-09-27','F','5886-260-645-DM','E5A 6Q6','8747 Maple Rd.','Winnipeg','+1 (363) 589-4610','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS795080','Audrey','Berry','532 896 734','56','214','1973-10-25','F','1394-307-326-TK','R8I 4Z7','604 Catherine Drive','Thunder Bay','+1 (250) 118-6046','FULL CODE','YES','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS024164','Ava','Black','713 972 100','56','131','1944-12-23','F','2710-142-504-QU','C5E 5Q0','219 North Trenton St.','Thunder Bay','+1 (811) 783-8890','FULL CODE','YES','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS531853','Bella','Blake','219 344 253','56','179','1974-07-22','F','2491-100-347-DB','Z9G 0B8','8540 Tunnel Street ','Thunder Bay','+1 (128) 440-5870','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS129533','Bernadette','Bond','582 303 925','60','130','1970-07-04','F','6146-692-329-PM','Q3H 6K6','3 Lyme Dr. ','Thunder Bay','+1 (121) 120-7129','FULL CODE','YES','Soy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS312841','Carol','Bower','154 523 325','74','168','1936-01-16','F','3260-329-284-FA','L0M 8F2','174 Wellington Lane','Beijing','+1 (313) 544-1380','FULL CODE','YES','Gluten','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS218262','Caroline','Brown','578 898 807','64','167','1923-01-13','F','5856-605-200-LR','B3I 2S6','609 Rock Maple Road','Thunder Bay','+1 (342) 724-1826','FULL CODE','YES','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS761046','Carolyn','Buckland','274 126 212','68','212','2004-05-27','F','3945-750-187-PR','O1A 9A0','72 Blue Spring St. ','Thunder Bay','+1 (057) 678-1413','FULL CODE','YES','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS626521','Chloe','Burgess','171 063 362','63','175','1990-02-12','F','6101-559-991-DG','Y1K 9U9','7192 Ridgeview Ave.','Thunder Bay','+1 (298) 884-0797','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS689837','Claire','Butler','936 228 734','63','147','2002-06-09','F','4280-885-754-WQ','W1K 7C9','434 Cedar Drive ','Thunder Bay','+1 (706) 053-1499','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS123408','Deirdre','Cameron','923 922 978','65','122','1987-06-19','F','9707-499-327-UW','A9X 2I4','14 Philmont Lane','Thunder Bay','+1 (504) 950-3235','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS041047','Diana','Campbell','788 653 802','61','206','1956-04-28','F','5995-815-282-YV','L7T 6K1','340 N. Orchard Street','Thunder Bay','+1 (236) 268-9289','FULL CODE','YES','Soy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS978897','Diane','Carr','618 413 885','61','202','1935-10-10','M','0342-417-525-WY','F0E 0W9','7175 Grant St.','Thunder Bay','+1 (080) 691-2578','FULL CODE','YES','Gluten','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS988669','Donna','Chapman','396 693 094','57','182','1956-09-13','M','1183-246-805-QI','D4O 1B1','237 Fawn St. ','North Bay','+1 (772) 924-1452','FULL CODE','YES','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS682829','Dorothy','Churchill','626 994 869','73','205','1964-03-22','F','5674-879-044-GA','P2X 1A1','781 Wagon Street','Thunder Bay','+1 (127) 542-6121','FULL CODE','INCOMPLETE','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS570149','Elizabeth','Clark','291 424 779','57','196','2008-05-04','M','7974-806-170-ZT','Y1R 6P7','303 Clinton St.','Thunder Bay','+1 (336) 881-4261','FULL CODE','YES','Fish','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS837748','Ella','Clarkson','080 008 744','63','132','1957-11-10','F','5197-114-588-KT','U3Y 6F1','521 Lakewood Rd. ','Thunder Bay','+1 (391) 934-7760','FULL CODE','YES','Bees','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS942200','Emily','Coleman','972 509 612','65','142','2006-10-23','M','9515-513-619-GA','X8Z 0K2','7519 Catherine Drive ','Toronto','+1 (287) 938-3691','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS692953','Emma','Cornish','100 184 333','74','211','1961-10-28','M','9386-550-340-NQ','J7V 0D5','\"8363 N. Bayport Dr. ','Toronto','+1 (520) 659-2092','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS032917','Faith','Davidson','287 294 338','75','175','2000-07-15','F','5633-188-775-DT','S2D 5M9','10 Devon Lane','Thunder Bay','+1 (709) 322-1773','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS815232','Felicity','Davies','555 537 613','60','135','1962-04-20','M','0091-061-074-OB','Z0N 9O3','9251 Fairfield Drive ','Thunder Bay','+1 (565) 776-8481','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS197967','Fiona','Dickens','379 890 735','58','186','1993-10-17','M','6002-183-092-YI','P8Z 0A9','7029 Sutor St.','Thunder Bay','+1 (818) 962-7304','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS459850','Gabrielle','Dowd','463 728 448','64','216','1969-07-04','F','4553-503-221-PM','A4U 3S8','10 East Green Dr. ','Thunder Bay','+1 (209) 343-7940','FULL CODE','YES','Bees','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS195878','Grace','Duncan','620 803 954','76','209','2004-03-05','F','3768-872-446-BS','J6B 8C6','200 Pawnee Drive','Thunder Bay','+1 (956) 254-5838','FULL CODE','YES','Peanuts','2017-08-24');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS192006','Hannah','Dyer','457 916 417','61','203','1998-02-14','M','4857-870-307-VE','N5F 7P0','444 Tanglewood Street','Kenora','+1 (579) 425-1773','DNR','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS120573','Heather','Edmunds','322 757 469','69','209','1926-06-22','M','7754-169-084-AW','F7K 2W9','655 Ryan St.','Thunder Bay','+1 (319) 981-1970','FULL CODE','YES','Gluten','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS269652','Irene','Ellison','240 503 466','76','149','1987-08-21','F','3767-432-674-JT','G7G 4I9','398 Green Lake St.','Thunder Bay','+1 (326) 349-3194','FULL CODE','YES','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS907274','Jan','Ferguson','671 197 407','69','180','1998-08-16','F','0294-620-442-HM','T4B 4G6','221 Franklin Street ','Thunder Bay','+1 (515) 011-9227','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS649869','Jane','Fisher','643 364 026','71','171','1994-03-21','M','1891-271-599-DL','Q5V 9A9','387 Pennsylvania Ave.','New York City','+1 (755) 764-5403','FULL CODE','YES','Eggs','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS300243','Jasmine','Forsyth','135 423 171','75','169','1945-11-05','M','1777-894-430-RL','J7T 8N2','303 Kent Ave. ','Thunder Bay','+1 (599) 716-3811','FULL CODE','YES','Milk','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS066405','Jennifer','Fraser','904 104 410','61','165','1952-08-08','F','0670-432-857-IP','K4G 7T2','9625 E. Longfellow St. ','Thunder Bay','+1 (727) 302-0054','FULL CODE','YES','Milk','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS089533','Jessica','Gibson','445 884 671','65','204','1977-04-15','M','8840-779-008-NI','F2H 9Y0','41 Mayflower Court ','Vancouver','+1 (551) 707-1526','FULL CODE','YES','Eggs','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS014311','Joan','Gill','703 792 090','62','185','1941-12-03','M','0763-631-765-NI','Y5Y 2G9','7888 Queen Street ','Thunder Bay','+1 (800) 225-1839','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS980780','Joanne','Glover','685 943 739','66','125','1939-05-04','F','2897-086-658-UU','N2W 5A7','104 South Water Lane','Thunder Bay','+1 (661) 227-6637','DNR','YES','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS111127','Julia','Graham','708 533 463','75','124','1999-05-25','M','8606-828-920-YQ','N5J 9I0','225 Anderson St.','Thunder Bay','+1 (686) 318-6406','FULL CODE','YES','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS548024','Karen','Grant','417 743 426','72','169','1960-03-22','F','6906-397-757-CR','A6V 5A6','17 North Belmont Drive','Thunder Bay','+1 (670) 271-9946','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS640461','Katherine','Gray','669 684 016','59','136','1955-08-03','F','6936-816-262-AY','O2M 3Z8','945 High St.','Chicago','+1 (486) 930-7015','FULL CODE','INCOMPLETE','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS378263','Kimberly','Greene','326 175 432','58','125','2004-11-26','M','1494-101-513-YI','L7X 1O6','526 Bear Hill St.','Thunder Bay','+1 (807) 423-9955','FULL CODE','INCOMPLETE','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS842394','Kylie','Hamilton','843 448 855','58','206','1938-11-19','M','2923-847-493-QA','O0X 4H0','7669 Trout Lane','Thunder Bay','+1 (653) 398-5453','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS600600','Lauren','Hardacre','630 113 736','72','208','1981-07-08','M','6141-710-679-XY','Q0H 5V1','508 Spruce St.','Thunder Bay','+1 (314) 089-6896','DNR','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS374286','Leah','Harris','283 631 416','56','189','1995-10-02','M','5012-710-328-XU','Y5D 5O0','2 Saxon Road','Thunder Bay','+1 (306) 396-4316','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS445020','Lillian','Hart','285 344 379','65','216','1946-06-02','F','9539-598-838-SC','H2I 9K3','9504 Heather St.','Thunder Bay','+1 (409) 960-4429','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS578256','Lily','Hemmings','279 938 272','56','198','1929-08-15','M','3230-659-060-ZH','F5Q 8B1','979 Morris Rd.','Kingston','+1 (998) 371-0149','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS945213','Lisa','Henderson','813 857 521','57','195','1993-08-07','F','7826-461-519-CW','P3E 2E2','18 Lake View Drive','Thunder Bay','+1 (182) 624-3600','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS888624','Madeleine','Hill','137 056 173','66','152','1919-04-04','F','2569-105-405-AZ','A0A 9Z3','26 Glenwood Ave. ','Thunder Bay','+1 (332) 569-2150','FULL CODE','YES','Gluten','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS107400','Maria','Hodges','060 161 827','57','158','1990-11-25','F','9214-592-524-LR','Z0G 5W7','8715 Bald Hill Road','Thunder Bay','+1 (146) 067-2559','FULL CODE','YES','Soy','2017-09-07');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS961053','Mary','Howard','208 910 273','61','171','1970-01-27','M','3303-506-255-DF','H4H 6O6','9304 Santa Clara Dr. ','Thunder Bay','+1 (926) 114-6409','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS967223','Megan','Hudson','874 236 255','65','168','1986-01-23','F','4701-837-625-AE','T3I 8F6','8799 Clark Drive','Thunder Bay','+1 (266) 502-6807','FULL CODE','YES','Milk','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS970388','Melanie','Hughes','213 063 468','70','201','1954-01-17','F','1067-111-808-KT','G9F 2C7','9782 North Brookside Rd.','Thunder Bay','+1 (178) 729-7171','FULL CODE','YES','Milk','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS574642','Michelle','Hunter','968 807 596','60','200','1962-02-22','F','7049-701-446-KZ','M4X 7U2','7039 Bay Meadows Avenue','Thunder Bay','+1 (871) 929-0936','FULL CODE','YES','Eggs','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS337562','Molly','Ince','230 319 615','74','170','2002-06-02','M','2155-471-088-EV','H9T 3F8','65 Peachtree St.','Thunder Bay','+1 (263) 588-8919','FULL CODE','YES','Milk','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS647526','Natalie','Jackson','889 773 422','58','158','1990-07-27','F','1478-493-616-WZ','L5U 7H9','79 Newbridge Ave.','Toronto','+1 (796) 172-2228','FULL CODE','YES','Milk','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS404543','Nicola','James','544 207 814','58','179','1961-05-10','F','7828-995-514-TH','K0L 0F7','9882 Valley Drive','Thunder Bay','+1 (153) 586-2166','FULL CODE','YES','Eggs','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS512772','Olivia','Johnston','259 087 982','59','204','1969-01-08','F','1622-630-331-XL','N3W 7O1','797 Alton St.','Thunder Bay','+1 (150) 543-9052','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS845078','Penelope','Jones','893 547 158','63','161','1958-05-26','M','2854-770-940-JS','H1B 5W9','8551 Golf Court','Thunder Bay','+1 (718) 744-7163','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS932294','Pippa','Kelly','411 512 614','65','158','1981-01-11','F','4723-844-972-OH','U4P 5E5','9 West River Rd.','Thunder Bay','+1 (099) 719-4833','FULL CODE','YES','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS166511','Rachel','Kerr','795 688 851','63','143','2009-04-19','M','8215-979-872-SR','M4J 6H3','570 Depot Road','Thunder Bay','+1 (601) 966-1133','DNR','INCOMPLETE','Fish','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS566502','Rebecca','King','184 677 700','59','149','1931-11-24','M','2432-499-667-FL','L0V 0T9','5 W. Cooper St.','Washington','+1 (437) 702-7954','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS874875','Rose','Knox','463 452 755','73','144','1992-03-04','M','7579-332-347-RZ','W5W 6D1','8747 Maple Rd.','Thunder Bay','+1 (661) 054-4713','FULL CODE','YES','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS884448','Ruth','Lambert','143 579 839','66','189','1976-07-25','M','1784-088-693-TH','H3H 2B7','604 Catherine Drive','Thunder Bay','+1 (046) 911-0054','FULL CODE','YES','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS564657','Sally','Langdon','258 124 925','58','204','1970-09-06','M','5870-319-266-OF','K8T 3J8','219 North Trenton St.','Thunder Bay','+1 (642) 642-7072','FULL CODE','YES','Gluten','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS980843','Samantha','Lawrence','023 313 429','60','147','1949-01-13','M','4984-451-178-TT','B2J 3C3','8540 Tunnel Street ','Thunder Bay','+1 (908) 402-1030','FULL CODE','YES','Gluten','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS589036','Sarah','Lee','871 544 304','59','194','1998-09-23','F','8373-358-992-JS','I9C 6P8','3 Lyme Dr. ','Thunder Bay','+1 (450) 587-8305','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS078366','Sonia','Lewis','929 324 559','76','121','1917-03-17','M','9193-356-724-PG','D6X 4S8','174 Wellington Lane','Thunder Bay','+1 (124) 067-0720','FULL CODE','INCOMPLETE','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS495003','Sophie','Lyman','802 459 631','71','169','1973-11-07','M','4716-584-346-HA','X4E 9W8','609 Rock Maple Road','Thunder Bay','+1 (270) 225-7476','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS769091','Stephanie','MacDonald','215 037 930','71','139','2003-01-04','F','5369-961-599-TL','N3C 6U3','72 Blue Spring St. ','Thunder Bay','+1 (837) 108-1314','FULL CODE','YES','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS744974','Sue','Mackay','311 186 592','69','175','1968-05-01','F','3656-018-949-VA','V6B 1O6','7192 Ridgeview Ave.','Thunder Bay','+1 (230) 811-2344','FULL CODE','YES','Gluten','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS552236','Theresa','Mackenzie','533 331 337','64','169','1948-05-11','M','2065-833-712-AU','G7E 0R4','434 Cedar Drive ','Thunder Bay','+1 (896) 526-8374','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS149284','Tracey','MacLeod','824 974 947','69','123','1923-07-02','F','0478-888-079-TL','B1T 6K2','14 Philmont Lane','Thunder Bay','+1 (928) 119-5485','DNR','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS961928','Una','Manning','132 979 391','68','165','1982-01-24','F','1037-071-474-EB','E2Q 6H8','340 N. Orchard Street','Thunder Bay','+1 (514) 319-1995','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS714341','Vanessa','Marshall','001 134 356','58','191','1924-12-19','F','3802-975-977-YD','H0A 5U8','7175 Grant St.','Thunder Bay','+1 (634) 994-0245','FULL CODE','YES','Eggs','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS839655','Victoria','Martin','988 055 967','62','204','1920-11-09','F','5481-467-572-SB','F0X 5A4','237 Fawn St. ','Thunder Bay','+1 (470) 682-2597','FULL CODE','YES','Bees','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS107620','Virginia','Mathis','126 012 947','76','149','2009-11-15','M','6599-366-410-JJ','U5W 0S6','781 Wagon Street','Thunder Bay','+1 (395) 247-4328','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS046332','Wanda','May','140 722 441','67','193','1969-08-13','F','8194-773-288-UZ','T3I 7O7','303 Clinton St.','Thunder Bay','+1 (560) 933-9768','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS217742','Wendy','McDonald','318 090 135','60','201','1996-07-08','M','1029-902-511-DI','V1I 9G4','521 Lakewood Rd. ','Thunder Bay','+1 (873) 409-7156','FULL CODE','YES','Gluten','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS254465','Yvonne','McLean','787 169 557','73','217','1952-09-16','F','9288-288-226-AR','P6Y 0V5','7519 Catherine Drive ','Thunder Bay','+1 (743) 256-7795','FULL CODE','YES','Gluten','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS484575','Zoe','McGrath','670 371 431','71','189','1995-08-20','M','1134-822-976-QO','D6W 4F5','8363 N. Bayport Dr. ','Thunder Bay','+1 (991) 062-4914','FULL CODE','YES','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS956738','Adam','Metcalfe','578 800 452','60','183','1983-12-11','F','9364-183-682-BQ','U4K 7U2','10 Devon Lane','Thunder Bay','+1 (931) 479-3382','FULL CODE','YES','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS971259','Adrian','Miller','118 231 897','60','145','2010-03-22','M','4510-664-565-HA','X8E 5K7','9251 Fairfield Drive ','Thunder Bay','+1 (610) 644-8712','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS524970','Alan','Mills','394 967 565','67','216','1980-01-16','M','4049-971-416-YN','O4K 3U3','7029 Sutor St.','Thunder Bay','+1 (132) 579-4860','FULL CODE','INCOMPLETE','Bees','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS346048','Alexander','Mitchell','910 099 211','64','218','1926-03-05','M','0083-116-711-VC','G2U 5J4','10 East Green Dr. ','Thunder Bay','+1 (554) 114-7818','FULL CODE','YES','Fish','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS134787','Andrew','Morgan','369 229 824','74','131','1980-12-02','F','0213-493-263-ZJ','U1Q 2G2','200 Pawnee Drive','Thunder Bay','+1 (138) 673-4040','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS705002','Anthony','Morrison','191 590 974','61','215','1917-09-02','F','5445-552-375-IN','X8N 1K9','444 Tanglewood Street','Thunder Bay','+1 (570) 293-4206','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS464193','Austin','Murray','937 852 293','57','133','1917-06-02','F','1704-062-335-WG','E5P 8A5','655 Ryan St.','Thunder Bay','+1 (717) 132-5368','FULL CODE','YES','Fish','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS674794','Benjamin','Nash','474 763 610','73','211','1982-05-23','M','3265-349-129-YE','M9E 1J6','398 Green Lake St.','Thunder Bay','+1 (457) 673-5856','FULL CODE','YES','Fish','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS342183','Blake','Newman','990 927 374','75','173','1945-12-11','M','1483-971-716-HK','T1F 7P1','221 Franklin Street ','Thunder Bay','+1 (862) 597-6036','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS049746','Boris','Nolan','603 161 091','56','165','1939-02-13','M','0255-238-606-VD','S2O 9P0','387 Pennsylvania Ave.','Thunder Bay','+1 (242) 434-1120','FULL CODE','INCOMPLETE','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS604745','Brandon','North','179 001 235','65','166','1995-08-04','M','3798-286-179-OC','N3B 9N6','303 Kent Ave. ','Thunder Bay','+1 (306) 582-8890','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS742290','Brian','Ogden','037 230 255','74','161','1927-07-17','F','0255-835-360-ZQ','X5J 4V6','9625 E. Longfellow St. ','Thunder Bay','+1 (928) 503-5239','FULL CODE','YES','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS545873','Cameron','Oliver','409 924 776','68','161','1946-10-18','M','1408-001-987-PO','L6F 3S4','41 Mayflower Court ','Thunder Bay','+1 (783) 396-1681','FULL CODE','YES','Gluten','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS906516','Carl','Paige','804 639 134','69','218','1989-04-04','F','4937-414-543-TD','K0K 5H7','7888 Queen Street ','Thunder Bay','+1 (039) 391-7733','DNR','YES','Fish','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS356272','Charles','Parr','340 737 055','71','134','1954-03-16','F','4653-988-362-EG','F6G 5H2','104 South Water Lane','Thunder Bay','+1 (680) 530-9892','FULL CODE','YES','Bees','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS894128','Christian','Parsons','305 751 781','73','127','2009-03-08','M','8731-732-314-VS','H6P 7F0','225 Anderson St.','Thunder Bay','+1 (091) 611-1488','DNR','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS510439','Christopher','Paterson','185 453 726','56','153','1939-10-10','M','4184-203-821-SX','U4Y 9K9','17 North Belmont Drive','Thunder Bay','+1 (709) 720-3463','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS129288','Colin','Payne','156 759 522','71','168','2001-10-06','F','2120-223-308-YZ','L2Z 1E7','945 High St.','Thunder Bay','+1 (939) 009-6203','DNR','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS950385','Connor','Peake','571 959 426','69','139','1958-02-21','M','0653-686-518-ZO','S1X 2W0','526 Bear Hill St.','Thunder Bay','+1 (807) 576-1648','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS485110','Dan','Peters','694 273 525','64','144','1926-10-08','M','1083-103-238-GZ','N5J 9M8','7669 Trout Lane','Thunder Bay','+1 (912) 344-7127','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS274796','David','Piper','899 453 568','67','194','2003-10-21','M','2784-853-994-XT','V3Z 6E3','508 Spruce St.','Thunder Bay','+1 (490) 938-0877','FULL CODE','YES','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS649271','Dominic','Poole','386 469 460','63','151','1927-05-15','F','8804-206-301-FH','Z8U 7X7','2 Saxon Road','Thunder Bay','+1 (011) 092-8429','FULL CODE','INCOMPLETE','Gluten','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS060289','Dylan','Powell','499 188 666','67','199','1917-06-04','F','1945-012-009-GT','X8W 8Q1','9504 Heather St.','Thunder Bay','+1 (032) 340-6850','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS535296','Edward','Pullman','067 674 346','71','194','1970-10-04','F','3186-484-465-YR','Z8Z 9P4','979 Morris Rd.','Thunder Bay','+1 (930) 483-0961','FULL CODE','INCOMPLETE','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS194109','Eric','Quinn','295 695 342','74','165','1951-11-02','F','2889-835-376-TC','T0A 9Z2','18 Lake View Drive','Thunder Bay','+1 (941) 794-2844','FULL CODE','INCOMPLETE','No known allergy','2017-10-11');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS182805','Evan','Rampling','355 804 059','60','192','1932-03-19','F','8602-700-917-HF','G4B 1P8','26 Glenwood Ave. ','Thunder Bay','+1 (209) 162-0294','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS332936','Frank','Randall','957 126 195','74','191','1942-04-13','M','6642-225-452-LB','Z3R 9J8','8715 Bald Hill Road','Thunder Bay','+1 (748) 538-9518','FULL CODE','YES','Fish','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS549031','Gavin','Rees','608 236 211','61','166','1944-07-14','M','6262-140-195-TO','P7I 7P6','9304 Santa Clara Dr. ','Thunder Bay','+1 (782) 243-4387','FULL CODE','YES','Bees','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS978302','Gordon','Reid','367 238 897','74','194','1997-02-23','F','9354-136-526-TL','E7O 4R4','8799 Clark Drive','Thunder Bay','+1 (129) 187-3234','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS284615','Harry','Roberts','600 956 596','66','209','1969-11-24','M','0815-407-948-DN','N2H 2U6','9782 North Brookside Rd.','Thunder Bay','+1 (662) 884-2072','FULL CODE','YES','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS516472','Ian','Robertson','198 663 608','73','164','1971-02-12','M','1545-554-428-RE','X6N 2L0','7039 Bay Meadows Avenue','Thunder Bay','+1 (954) 153-5351','FULL CODE','INCOMPLETE','Gluten','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS249916','Isaac','Ross','154 082 068','59','133','1923-11-18','F','1384-275-727-QQ','E3A 1Q8','65 Peachtree St.','Thunder Bay','+1 (948) 269-1819','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS766475','Jack','Russell','422 555 718','71','186','1989-03-10','F','5480-523-173-OU','Z9B 0N6','79 Newbridge Ave.','Thunder Bay','+1 (221) 696-0817','FULL CODE','YES','Bees','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS083576','Jacob','Rutherford','176 507 228','76','169','1979-01-09','F','7491-449-295-SE','K2I 8Q7','9882 Valley Drive','Thunder Bay','+1 (501) 731-8725','FULL CODE','YES','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS481302','Jake','Sanderson','987 822 254','63','155','2002-08-05','M','1134-767-659-VS','R8U 2M1','797 Alton St.','Thunder Bay','+1 (983) 748-6900','FULL CODE','INCOMPLETE','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS645281','James','Scott','898 623 274','74','209','1927-09-05','F','2360-174-761-UF','S8T 8M6','8551 Golf Court','Thunder Bay','+1 (840) 725-5187','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS602725','Jason','Sharp','333 858 550','67','184','1991-06-06','M','1443-221-077-RO','J3Z 3D6','9 West River Rd.','Thunder Bay','+1 (996) 765-6701','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS312552','Joe','Short','545 207 390','59','157','2009-12-12','M','1920-853-625-CP','V7X 7T2','570 Depot Road','Thunder Bay','+1 (925) 022-8230','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS735632','John','Simpson','175 550 213','70','217','1933-07-14','M','0079-006-988-CU','U6E 0D1','5 W. Cooper St.','Thunder Bay','+1 (524) 244-5100','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS662669','Jonathan','Skinner','466 438 133','71','195','1981-12-16','M','8870-958-412-ID','M2T 8S6','8747 Maple Rd.','Thunder Bay','+1 (295) 086-5195','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS344005','Joseph','Slater','953 968 970','58','165','1985-07-02','M','0473-615-618-WB','I4C 4D5','604 Catherine Drive','Thunder Bay','+1 (684) 966-8457','DNR','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS949621','Joshua','Smith','415 533 873','59','196','1970-05-09','F','6775-380-593-NM','B0N 3I1','219 North Trenton St.','Thunder Bay','+1 (069) 331-8824','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS942499','Julian','Springer','393 115 677','57','122','1948-09-09','M','1965-717-509-UT','L1Y 8S4','8540 Tunnel Street ','Thunder Bay','+1 (739) 565-8716','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS147884','Justin','Stewart','707 129 212','75','215','1946-09-15','F','5081-712-940-TF','L1J 5Z1','3 Lyme Dr. ','Thunder Bay','+1 (251) 112-1655','FULL CODE','YES','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS411905','Keith','Sutherland','141 063 321','69','185','2002-12-18','F','3099-811-831-FR','P7K 7P6','174 Wellington Lane','Thunder Bay','+1 (385) 523-7135','FULL CODE','INCOMPLETE','Milk','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS901512','Kevin','Taylor','852 224 297','69','145','1941-02-23','M','9964-018-644-LI','D2G 2X8','609 Rock Maple Road','Thunder Bay','+1 (571) 364-5044','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS933416','Leonard','Terry','773 703 927','60','191','1929-08-14','F','9010-491-536-NG','X8F 3S3','72 Blue Spring St. ','Thunder Bay','+1 (232) 120-4755','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS995362','Liam','Thomson','028 500 588','59','132','1971-03-03','F','5491-481-045-IE','G9T 6Q7','7192 Ridgeview Ave.','Thunder Bay','+1 (990) 243-0439','FULL CODE','YES','Bees','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS795212','Lucas','Tucker','027 801 711','61','201','1924-09-26','F','9036-063-013-AA','P7Q 5I8','434 Cedar Drive ','Thunder Bay','+1 (295) 175-1639','FULL CODE','YES','Fish','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS731439','Luke','Turner','744 709 249','68','143','1944-07-03','F','3028-480-837-ST','M1E 2L3','14 Philmont Lane','Cairo','+1 (083) 293-1422','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS416733','Matt','Underwood','326 153 845','65','215','1974-12-23','M','2701-644-970-LQ','U5M 6Y1','340 N. Orchard Street','Thunder Bay','+1 (707) 501-5270','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS776785','Max','Vance','198 164 943','58','167','1920-04-14','F','2295-893-720-AV','K8D 6U7','7175 Grant St.','Thunder Bay','+1 (318) 586-9593','FULL CODE','YES','Bees','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS881260','Michael','Vaughan','171 176 155','60','179','2000-08-03','M','8816-505-410-BB','V4J 8J0','237 Fawn St. ','Thunder Bay','+1 (924) 291-7756','FULL CODE','YES','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS693627','Nathan','Walker','047 549 496','67','178','1975-08-27','F','1201-014-112-PG','Y5A 5L4','781 Wagon Street','Thunder Bay','+1 (704) 890-6103','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS199683','Neil','Wallace','958 476 956','67','216','1983-06-05','M','0103-557-764-QO','H2K 6J1','303 Clinton St.','Thunder Bay','+1 (459) 188-9455','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS207714','Nicholas','Walsh','251 307 729','70','170','1918-11-22','M','6357-498-924-SX','Y5Y 2E8','521 Lakewood Rd. ','Thunder Bay','+1 (438) 442-1305','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS115791','Oliver','Watson','995 783 628','68','163','1926-05-23','M','8594-018-751-LR','G6P 4D0','7519 Catherine Drive ','Thunder Bay','+1 (026) 185-7407','DNR','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS056697','Owen','Welch','627 587 107','70','207','2009-04-05','F','5567-059-803-ZD','N8I 8U2','8363 N. Bayport Dr. ','Nairobi','+1 (325) 178-3871','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS394386','Paul','White','247 935 832','68','154','1954-10-08','F','3038-014-827-AV','X9W 4Z1','10 Devon Lane','Thunder Bay','+1 (324) 039-4845','DNR','INCOMPLETE','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS057624','Peter','Wilkins','095 018 544','68','217','1977-04-19','F','6810-969-071-DR','R2W 3J2','9251 Fairfield Drive ','Thunder Bay','+1 (224) 343-6375','FULL CODE','YES','Gluten','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS486620','Phil','Wilson','088 022 452','73','183','1996-07-15','M','1828-236-704-PK','O7F 0D3','7029 Sutor St.','Thunder Bay','+1 (285) 158-3802','FULL CODE','YES','Gluten','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS312216','Piers','Wright','740 020 721','62','120','1977-01-24','F','7582-077-863-GW','I4A 8D8','10 East Green Dr. ','Thunder Bay','+1 (837) 735-6614','DNR','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS330394','Richard','Young','099 367 514','59','199','1926-12-06','F','0877-143-877-IB','Z1X 8F2','200 Pawnee Drive','Thunder Bay','+1 (749) 927-7913','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS200113','Robert','Turner','225 596 800','60','215','1927-08-26','F','5230-291-969-WA','U2E 3V7','444 Tanglewood Street','Thunder Bay','+1 (932) 624-0275','FULL CODE','YES','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS388840','Ryan','Wallace','666 500 267','59','193','1936-03-12','F','7493-540-010-VR','L2V 1F7','655 Ryan St.','Thunder Bay','+1 (998) 425-5926','FULL CODE','YES','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS353994','Sam','Taylor','375 555 411','74','213','1971-07-15','F','2433-676-389-KU','E9T 7J1','398 Green Lake St.','Torino','+1 (389) 335-7370','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS262372','Sean','Powell','952 140 818','75','182','1940-11-20','F','7035-012-994-CQ','E1K 3R6','221 Franklin Street ','Thunder Bay','+1 (026) 818-3659','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS492447','Sebastian','Pullman','482 250 528','67','128','2008-02-26','F','0962-256-651-UP','Z8E 4A9','387 Pennsylvania Ave.','Thunder Bay','+1 (383) 332-0564','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS901599','Simon','Quinn','620 765 466','70','124','1939-09-15','M','2879-839-817-AY','C4D 8S3','303 Kent Ave. ','Thunder Bay','+1 (061) 754-2024','DNR','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS600861','Stephen','Rampling','069 685 889','73','130','1967-10-16','M','2614-556-487-KD','D3R 4B7','9625 E. Longfellow St. ','Thunder Bay','+1 (162) 737-5159','FULL CODE','YES','Gluten','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS068176','Steven','Randall','512 695 939','69','177','1944-10-02','M','5491-066-159-BN','B4M 5V2','41 Mayflower Court ','Thunder Bay','+1 (338) 401-3561','FULL CODE','YES','Peanuts','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS378461','Stewart','Rees','700 661 451','69','135','1966-02-24','M','5368-384-680-VE','B8R 6O3','7888 Queen Street ','Thunder Bay','+1 (521) 662-8581','FULL CODE','YES','No known allergy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS148847','Thomas','Reid','761 746 102','69','156','1996-10-24','M','9559-397-333-OC','P7N 6N7','104 South Water Lane','Thunder Bay','+1 (242) 142-2138','FULL CODE','YES','Soy','2017-05-23');
INSERT INTO Patient (patientMCS,patientFirstName,patientLastName,patientSIN,patientHeight,patientWeight,patientDateOfBirth,patientGender,patientHealthCard,patientPostalCode,patientAddress,patientCity,patientPhoneNumber,patientAdvancedDirective,patientAdvDirOnFile,patientAllergies,patientAdvDirDate) VALUES ('MCS933038','Tim','Roberts','305 951 223','75','126','1918-02-10','M','9964-594-105-NT','T8M 5E3','225 Anderson St.','Paris','+1 (617) 472-2091','FULL CODE','YES','Gluten','2017-05-23');


INSERT INTO Unit (unitCode,unitName) VALUES ('2A','Surgical Unit');
INSERT INTO Unit (unitCode,unitName) VALUES ('2B','Intensive Care Unit');
INSERT INTO Unit (unitCode,unitName) VALUES ('3A','Stroke and Rehab');
INSERT INTO Unit (unitCode,unitName) VALUES ('3B','Acquired Brain Injury');
INSERT INTO Unit (unitCode,unitName) VALUES ('4A','Mental Health');
INSERT INTO Unit (unitCode,unitName) VALUES ('4B','Chronic Pain');
INSERT INTO Unit (unitCode,unitName) VALUES ('5A','Geriatrics');
INSERT INTO Unit (unitCode,unitName) VALUES ('5B','Palliative Care');

INSERT INTO Room (unitCode,roomNumber) VALUES ('2A','202');
INSERT INTO Room (unitCode,roomNumber) VALUES ('2A','204');
INSERT INTO Room (unitCode,roomNumber) VALUES ('2A','206');
INSERT INTO Room (unitCode,roomNumber) VALUES ('2A','208');
INSERT INTO Room (unitCode,roomNumber) VALUES ('2A','210');
INSERT INTO Room (unitCode,roomNumber) VALUES ('2A','212');
INSERT INTO Room (unitCode,roomNumber) VALUES ('2A','214');
INSERT INTO Room (unitCode,roomNumber) VALUES ('2A','216');
INSERT INTO Room (unitCode,roomNumber) VALUES ('2A','218');
INSERT INTO Room (unitCode,roomNumber) VALUES ('2A','220');
INSERT INTO Room (unitCode,roomNumber) VALUES ('2B','222');
INSERT INTO Room (unitCode,roomNumber) VALUES ('2B','224');
INSERT INTO Room (unitCode,roomNumber) VALUES ('2B','226');
INSERT INTO Room (unitCode,roomNumber) VALUES ('2B','228');
INSERT INTO Room (unitCode,roomNumber) VALUES ('2B','230');
INSERT INTO Room (unitCode,roomNumber) VALUES ('2B','232');
INSERT INTO Room (unitCode,roomNumber) VALUES ('2B','234');
INSERT INTO Room (unitCode,roomNumber) VALUES ('2B','236');
INSERT INTO Room (unitCode,roomNumber) VALUES ('2B','238');
INSERT INTO Room (unitCode,roomNumber) VALUES ('2B','240');
INSERT INTO Room (unitCode,roomNumber) VALUES ('3A','302');
INSERT INTO Room (unitCode,roomNumber) VALUES ('3A','304');
INSERT INTO Room (unitCode,roomNumber) VALUES ('3A','306');
INSERT INTO Room (unitCode,roomNumber) VALUES ('3A','308');
INSERT INTO Room (unitCode,roomNumber) VALUES ('3A','310');
INSERT INTO Room (unitCode,roomNumber) VALUES ('3A','312');
INSERT INTO Room (unitCode,roomNumber) VALUES ('3A','314');
INSERT INTO Room (unitCode,roomNumber) VALUES ('3A','316');
INSERT INTO Room (unitCode,roomNumber) VALUES ('3A','318');
INSERT INTO Room (unitCode,roomNumber) VALUES ('3A','320');
INSERT INTO Room (unitCode,roomNumber) VALUES ('3B','322');
INSERT INTO Room (unitCode,roomNumber) VALUES ('3B','324');
INSERT INTO Room (unitCode,roomNumber) VALUES ('3B','326');
INSERT INTO Room (unitCode,roomNumber) VALUES ('3B','328');
INSERT INTO Room (unitCode,roomNumber) VALUES ('3B','330');
INSERT INTO Room (unitCode,roomNumber) VALUES ('3B','332');
INSERT INTO Room (unitCode,roomNumber) VALUES ('3B','334');
INSERT INTO Room (unitCode,roomNumber) VALUES ('3B','336');
INSERT INTO Room (unitCode,roomNumber) VALUES ('3B','338');
INSERT INTO Room (unitCode,roomNumber) VALUES ('3B','340');
INSERT INTO Room (unitCode,roomNumber) VALUES ('4A','402');
INSERT INTO Room (unitCode,roomNumber) VALUES ('4A','404');
INSERT INTO Room (unitCode,roomNumber) VALUES ('4A','406');
INSERT INTO Room (unitCode,roomNumber) VALUES ('4A','408');
INSERT INTO Room (unitCode,roomNumber) VALUES ('4A','410');
INSERT INTO Room (unitCode,roomNumber) VALUES ('4A','412');
INSERT INTO Room (unitCode,roomNumber) VALUES ('4A','414');
INSERT INTO Room (unitCode,roomNumber) VALUES ('4A','416');
INSERT INTO Room (unitCode,roomNumber) VALUES ('4A','418');
INSERT INTO Room (unitCode,roomNumber) VALUES ('4A','420');
INSERT INTO Room (unitCode,roomNumber) VALUES ('4B','422');
INSERT INTO Room (unitCode,roomNumber) VALUES ('4B','424');
INSERT INTO Room (unitCode,roomNumber) VALUES ('4B','426');
INSERT INTO Room (unitCode,roomNumber) VALUES ('4B','428');
INSERT INTO Room (unitCode,roomNumber) VALUES ('4B','430');
INSERT INTO Room (unitCode,roomNumber) VALUES ('4B','432');
INSERT INTO Room (unitCode,roomNumber) VALUES ('4B','434');
INSERT INTO Room (unitCode,roomNumber) VALUES ('4B','436');
INSERT INTO Room (unitCode,roomNumber) VALUES ('4B','438');
INSERT INTO Room (unitCode,roomNumber) VALUES ('4B','440');
INSERT INTO Room (unitCode,roomNumber) VALUES ('5A','502');
INSERT INTO Room (unitCode,roomNumber) VALUES ('5A','504');
INSERT INTO Room (unitCode,roomNumber) VALUES ('5A','506');
INSERT INTO Room (unitCode,roomNumber) VALUES ('5A','508');
INSERT INTO Room (unitCode,roomNumber) VALUES ('5A','510');
INSERT INTO Room (unitCode,roomNumber) VALUES ('5A','512');
INSERT INTO Room (unitCode,roomNumber) VALUES ('5A','514');
INSERT INTO Room (unitCode,roomNumber) VALUES ('5A','516');
INSERT INTO Room (unitCode,roomNumber) VALUES ('5A','518');
INSERT INTO Room (unitCode,roomNumber) VALUES ('5A','520');
INSERT INTO Room (unitCode,roomNumber) VALUES ('5B','522');
INSERT INTO Room (unitCode,roomNumber) VALUES ('5B','524');
INSERT INTO Room (unitCode,roomNumber) VALUES ('5B','526');
INSERT INTO Room (unitCode,roomNumber) VALUES ('5B','528');
INSERT INTO Room (unitCode,roomNumber) VALUES ('5B','530');
INSERT INTO Room (unitCode,roomNumber) VALUES ('5B','532');
INSERT INTO Room (unitCode,roomNumber) VALUES ('5B','534');
INSERT INTO Room (unitCode,roomNumber) VALUES ('5B','536');
INSERT INTO Room (unitCode,roomNumber) VALUES ('5B','538');
INSERT INTO Room (unitCode,roomNumber) VALUES ('5B','540');

INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS358852','202','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS605959','202','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS398056','204','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS322892','204','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS281321','206','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS249465','206','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS624616','208','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS300361','208','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS294872','210','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS948637','210','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS795080','212','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS024164','212','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS531853','214','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS129533','214','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS312841','216','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS218262','216','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS761046','218','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS626521','218','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS689837','220','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS123408','220','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS041047','222','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS978897','222','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS988669','224','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS682829','224','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS570149','226','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS837748','226','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS942200','228','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS692953','228','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS032917','230','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS815232','230','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS197967','232','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS459850','232','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS195878','234','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS192006','234','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS120573','236','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS269652','236','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS907274','238','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS649869','238','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS300243','240','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS066405','240','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS089533','302','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS014311','302','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS980780','304','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS111127','304','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS548024','306','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS640461','306','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS378263','308','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS842394','308','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS600600','310','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS374286','310','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS445020','312','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS578256','312','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS945213','314','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS888624','314','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS107400','316','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS961053','316','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS967223','318','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS970388','318','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS574642','320','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS337562','320','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS647526','322','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS404543','322','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS512772','324','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS845078','324','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS932294','326','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS166511','326','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS566502','328','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS874875','328','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS884448','330','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS564657','330','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS980843','332','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS589036','332','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS078366','334','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS495003','334','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS769091','336','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS744974','336','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS552236','338','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS149284','338','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS961928','340','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS714341','340','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS839655','402','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS107620','402','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS046332','404','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS217742','404','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS254465','406','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS484575','406','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS956738','408','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS971259','408','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS524970','410','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS346048','410','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS134787','412','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS705002','412','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS464193','414','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS674794','414','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS342183','416','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS049746','416','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS604745','418','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS742290','418','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS545873','420','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS906516','420','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS356272','422','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS894128','422','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS510439','424','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS129288','424','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS950385','426','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS485110','426','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS274796','428','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS649271','428','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS060289','430','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS535296','430','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS194109','432','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS182805','432','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS332936','434','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS549031','434','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS978302','436','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS284615','436','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS516472','438','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS249916','438','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS766475','440','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS083576','440','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS481302','502','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS645281','502','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS602725','504','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS312552','504','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS735632','506','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS662669','506','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS344005','508','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS949621','508','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS942499','510','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS147884','510','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS411905','512','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS901512','512','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS933416','514','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS995362','514','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS795212','516','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS731439','516','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS416733','518','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS776785','518','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS881260','520','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS693627','520','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS199683','522','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS207714','522','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS115791','524','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS056697','524','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS394386','526','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS057624','526','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS486620','528','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS312216','528','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS330394','530','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS200113','530','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS388840','532','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS353994','532','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS262372','534','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS492447','534','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS901599','536','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS600861','536','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS068176','538','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS378461','538','2');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS148847','540','1');
INSERT INTO ResidesIn (patientMCS,roomNumber,bedNumber) VALUES ('MCS933038','540','2');

INSERT INTO Conditions (conditionCode,conditionName) VALUES ('9Z8P8U','Carotid Endarterectomy Sx');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('9I9F2O','Cataract Sx');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('2G7N8O','Cholecystectomy Sx');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('0N0D3R','Appendectomy Sx');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('8P1H1O','Hiatal Hernia Sx');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('9W3B6S','Hemerroidectomy Sx');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('5Z6R3Y','Umbilical Hernia Sx');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('9G1H6R','Thyroidectemy Sx');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('7L5H0K','Strabismus Sx');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('0J8I2N','Colectomy Sx');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('5Z1U4J','Lumbar Fusion Sx');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('5O4J9X','Bunion Surgery Sx');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('4L6J6E','Colon Resection Sx');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('4Q6W1T','Colostomy Sx');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('0B2E7J','Mastectomy Sx');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('3D0A0V','Breast Biopsy Sx');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('0U5Q4Q','Gastric Bypass Surgery Sx');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('8P2W2C','Ileostomy Sx');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('9S6X8X','Hip Sx');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('4Z6B6Q','Tonsillectomy');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('3M3R0D','Sepsis');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('4H1I5F','Heart Failure');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('5V3E6H','Trauma');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('6R3J4N','Cocaine Toxicity');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('5P5S6A','Iron Toxicity');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('6T5K2L','Kidney Disease');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('7W1Z9T','Pulmonary Embolism');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('9U3O7G','Pneumonia');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('6J7L7B','Abdominal Bleeding');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('7Q2X9R','Ruptured Brain Aneurysm');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('0S3U9D','Phenytoin Toxicity');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('3K9F1L','Opioid Toxicity');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('7M8H2B','Alcohol Toxicity');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('0P8B1Z','Hypothermia');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('4W5Q4J','Renal Failure');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('2G8G2S','Blood Clotting');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('1N7L4W','Cerebral Anoxia');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('6G9N6Y','Hypovolemic Shock');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('9B0O4Y','Cardiogenic Shock');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('3F5D8M','Aspiration');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('1D3O2I','Ischemic stroke');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('0M2L5H','Seizure');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('8A5P3E','Post Stroke Rehabilitation');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('6S2K7G','Hip Fracture');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('4C0D8O','Cervical Fusion');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('9D0P2A','Spinal Cord Injury');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('9O0L6Z','Parkinson’s Disease');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('8M8O4A','Guillain Barre Syndrome');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('1P7E2H','Parapalegic');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('2A3N5K','Quadrapalegic');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('6H3G3S','Multiple Sclerosis');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('2S3L8N','Osteoarthritis');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('0K2S0G','Amputation');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('4W9X8Y','Spina Bifida');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('1C9Q1Z','Motor Vehicle Accident');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('1S1U0W','Haemorrhagic stroke');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('4M1K2D','Hypertension');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('5C2M6R','Carotid Endarterectomy');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('1M7Q1V','Transient Ischemic Attack');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('8Z0N8F','Epilepsy');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('9Q9H9X','Subarachnoid Hemmorhage');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('4X3R6Z','Cerebral Aneurysm');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('2Z5N1P','Abdominal Aortic Aneurysm');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('7H8L1Y','Concussion');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('5J5O5D','Amnesia');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('5M0S2F','Traumatic Brain Injury');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('6X2D9C','Coma');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('6M7T9V','Chronic Traumatic Encephelopathy');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('9Q0I3D','Hydrocephalus');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('9K1T6R','Meningitis');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('2W3F8X','Diffuse Axonal Injury');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('9V0B8F','Cerebral Hematoma');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('6K8U9F','Cerebral Edema');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('7I8H9U','Skull Fracture');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('0Y8S8D','Intracranial Pressure');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('8R0U4P','Epidural Hematoma');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('1X1E9E','Subdural Hematoma');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('9O7R5S','Closed Head Injury');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('8Q8V0G','Coup-Contrecoup');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('2Z8R0J','Encephalitis');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('8Y4N4Q','Schizophrenia');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('7I3S6G','Depression');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('5M2M9R','Anxiety');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('3S2S1H','Bipolar Disorder');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('3B7J6X','Obsessive Compulsive Disorder');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('1L4N8N','Dissociative Disorder');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('0R0Q6E','Post-traumatic Disorder');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('1V0P2E','Borderline Personality Disorder');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('4H3Q5X','Paraphilic Disorder');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('4E4F6I','Substance Addiction');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('8B0M5M','Sleep Disorder');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('4U9X2I','Anorexia');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('7D3H9E','Autism');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('6D9L5L','Amyotrophic Lateral Sclerosis');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('2F6P1B','Attention Deficit/Hyperactivity Disorder');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('0A2V1V','Bullimia Nervosa');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('4E1L1Z','Seasonal Affective Disorder');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('1T4P3K','Cyclothymic Disorder');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('2G0P7Q','Psychosis');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('8V7V9X','Panic Attack');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('8E3L1S','Schizoaffective Disorder');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('3P1T1H','Headache');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('5L6K0I','Pelvic Pin');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('0S9M9X','Arthritis');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('8S2I0R','Fibromyalgia');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('9V4D5M','Back Pain');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('6Q4V2C','Sciatica');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('4H9I5E','TMJ Disorder');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('9B4B4A','Neck Pain');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('8Q9P2C','Myofascial Pain');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('1G9W8F','Neuropathic Pain');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('3I1Y9A','Nociceptive Pain');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('9I2T2G','Lupus');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('3T5N7U','Rheumatoid Arthritis');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('7F9Q0D','Somatic Pain');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('9H7W7M','Visceral Pain');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('8S8V5F','Shoulder Pain');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('1A0J3T','Foot Pain');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('2K7P5M','Delirium');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('9B1P4E','Dementia');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('1T2P7C','Electrolyte Imbalance');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('4O6K7I','Urinary Incontinence');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('6S6Z5S','Constipation');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('9T6T6D','Cardiac Disorder');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('5R4A7B','Mobility Disorder');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('3U3S3J','Coronary Disease');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('5B8N9O','Anemia');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('7R3G3U','Diabetes');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('0Q6G2C','Ulcer');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('2E9S8C','Bladder Infection');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('2K6X2L','Cerebrovascular Disease');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('8K4D3Q','Pancreatic Cancer');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('6E2T8H','Kidney Disease');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('6Z9A7U','Liver Disease');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('4Q9F4X','Congestive Heart Failure');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('7P2A9P','Chronic Obstructuve Pulmonary Disease');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('2L2L6D','Colon Cancer');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('8U0H2Y','Head and Neck Cancer');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('5F0T1M','Leukemia');
INSERT INTO Conditions (conditionCode,conditionName) VALUES ('3T0P1B','Lung Cancer');

INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('9Z8P8U','MCS358852');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('9I9F2O','MCS605959');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('2G7N8O','MCS398056');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('0N0D3R','MCS322892');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('8P1H1O','MCS281321');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('9W3B6S','MCS249465');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('5Z6R3Y','MCS624616');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('9G1H6R','MCS300361');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('7L5H0K','MCS294872');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('0J8I2N','MCS948637');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('5Z1U4J','MCS795080');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('5O4J9X','MCS024164');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('4L6J6E','MCS531853');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('4Q6W1T','MCS129533');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('0B2E7J','MCS312841');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('3D0A0V','MCS218262');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('0U5Q4Q','MCS761046');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('8P2W2C','MCS626521');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('9S6X8X','MCS689837');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('4Z6B6Q','MCS123408');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('3M3R0D','MCS041047');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('4H1I5F','MCS978897');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('5V3E6H','MCS988669');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('6R3J4N','MCS682829');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('5P5S6A','MCS570149');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('6T5K2L','MCS837748');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('7W1Z9T','MCS942200');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('9U3O7G','MCS692953');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('6J7L7B','MCS032917');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('7Q2X9R','MCS815232');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('0S3U9D','MCS197967');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('3K9F1L','MCS459850');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('7M8H2B','MCS195878');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('0P8B1Z','MCS192006');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('4W5Q4J','MCS120573');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('2G8G2S','MCS269652');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('1N7L4W','MCS907274');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('6G9N6Y','MCS649869');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('9B0O4Y','MCS300243');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('3F5D8M','MCS066405');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('1D3O2I','MCS089533');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('0M2L5H','MCS014311');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('8A5P3E','MCS980780');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('6S2K7G','MCS111127');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('4C0D8O','MCS548024');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('9D0P2A','MCS640461');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('9O0L6Z','MCS378263');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('8M8O4A','MCS842394');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('1P7E2H','MCS600600');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('2A3N5K','MCS374286');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('6H3G3S','MCS445020');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('2S3L8N','MCS578256');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('0K2S0G','MCS945213');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('4W9X8Y','MCS888624');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('1C9Q1Z','MCS107400');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('1S1U0W','MCS961053');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('4M1K2D','MCS967223');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('5C2M6R','MCS970388');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('1M7Q1V','MCS574642');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('8Z0N8F','MCS337562');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('9Q9H9X','MCS647526');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('4X3R6Z','MCS404543');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('2Z5N1P','MCS512772');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('7H8L1Y','MCS845078');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('5J5O5D','MCS932294');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('5M0S2F','MCS166511');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('6X2D9C','MCS566502');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('6M7T9V','MCS874875');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('9Q0I3D','MCS884448');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('9K1T6R','MCS564657');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('2W3F8X','MCS980843');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('9V0B8F','MCS589036');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('6K8U9F','MCS078366');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('7I8H9U','MCS495003');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('0Y8S8D','MCS769091');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('8R0U4P','MCS744974');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('1X1E9E','MCS552236');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('9O7R5S','MCS149284');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('8Q8V0G','MCS961928');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('2Z8R0J','MCS714341');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('8Y4N4Q','MCS839655');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('7I3S6G','MCS107620');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('5M2M9R','MCS046332');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('3S2S1H','MCS217742');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('3B7J6X','MCS254465');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('1L4N8N','MCS484575');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('0R0Q6E','MCS956738');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('1V0P2E','MCS971259');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('4H3Q5X','MCS524970');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('4E4F6I','MCS346048');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('8B0M5M','MCS134787');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('4U9X2I','MCS705002');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('7D3H9E','MCS464193');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('2F6P1B','MCS674794');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('0A2V1V','MCS342183');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('4E1L1Z','MCS049746');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('1T4P3K','MCS604745');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('2G0P7Q','MCS742290');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('8V7V9X','MCS545873');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('8E3L1S','MCS906516');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('3P1T1H','MCS356272');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('5L6K0I','MCS894128');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('0S9M9X','MCS510439');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('8S2I0R','MCS129288');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('9V4D5M','MCS950385');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('6Q4V2C','MCS485110');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('4H9I5E','MCS274796');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('9B4B4A','MCS649271');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('8Q9P2C','MCS060289');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('1G9W8F','MCS535296');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('3I1Y9A','MCS194109');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('9I2T2G','MCS182805');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('3T5N7U','MCS332936');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('6H3G3S','MCS549031');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('7F9Q0D','MCS978302');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('9H7W7M','MCS284615');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('8S8V5F','MCS516472');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('1A0J3T','MCS249916');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('3T5N7U','MCS766475');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('9B4B4A','MCS083576');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('2K7P5M','MCS481302');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('9B1P4E','MCS645281');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('9O0L6Z','MCS602725');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('8B0M5M','MCS312552');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('7I3S6G','MCS735632');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('1T2P7C','MCS662669');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('4O6K7I','MCS344005');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('6S6Z5S','MCS949621');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('4M1K2D','MCS942499');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('9T6T6D','MCS147884');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('2S3L8N','MCS411905');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('5R4A7B','MCS901512');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('6S2K7G','MCS933416');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('3U3S3J','MCS995362');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('5B8N9O','MCS795212');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('7R3G3U','MCS731439');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('0Q6G2C','MCS416733');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('2E9S8C','MCS776785');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('2K6X2L','MCS881260');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('6T5K2L','MCS693627');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('6D9L5L','MCS199683');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('2L2L6D','MCS207714');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('8U0H2Y','MCS115791');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('5F0T1M','MCS056697');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('3T0P1B','MCS394386');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('8K4D3Q','MCS057624');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('6E2T8H','MCS486620');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('6Z9A7U','MCS312216');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('4Q9F4X','MCS330394');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('7P2A9P','MCS200113');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('6D9L5L','MCS388840');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('2L2L6D','MCS353994');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('8U0H2Y','MCS262372');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('5F0T1M','MCS492447');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('3T0P1B','MCS901599');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('8K4D3Q','MCS600861');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('6E2T8H','MCS068176');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('6Z9A7U','MCS378461');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('4Q9F4X','MCS148847');
INSERT INTO DiagnosedWith (conditionCode,patientMCS) VALUES ('7P2A9P','MCS933038');

INSERT INTO Doctor (doctorLastName,doctorFirstName,doctorPhoneNumber,doctorTitle,doctorSIN) VALUES ('Davis','Peter','+1 (432) 580-2893','Surgeon','492 628 712');
INSERT INTO Doctor (doctorLastName,doctorFirstName,doctorPhoneNumber,doctorTitle,doctorSIN) VALUES ('Guinn','Michael','+1 (306) 666-8520','Intensivist','825 629 018');
INSERT INTO Doctor (doctorLastName,doctorFirstName,doctorPhoneNumber,doctorTitle,doctorSIN) VALUES ('Chomitz','Sarah','+1 (363) 589-4610','Physiatrist','210 381 025');
INSERT INTO Doctor (doctorLastName,doctorFirstName,doctorPhoneNumber,doctorTitle,doctorSIN) VALUES ('Holtz','Nancy','+1 (250) 118-6046','Physiatrist','147 925 232');
INSERT INTO Doctor (doctorLastName,doctorFirstName,doctorPhoneNumber,doctorTitle,doctorSIN) VALUES ('Gibbs','Mark','+1 (811) 783-8890','Psychologist','612 031 682');
INSERT INTO Doctor (doctorLastName,doctorFirstName,doctorPhoneNumber,doctorTitle,doctorSIN) VALUES ('Foreman','Peter','+1 (128) 440-5870','Pain Specialist','193 749 290');
INSERT INTO Doctor (doctorLastName,doctorFirstName,doctorPhoneNumber,doctorTitle,doctorSIN) VALUES ('Brodsky','Steven','+1 (121) 120-7129','Geriatrician','397 018 639');
INSERT INTO Doctor (doctorLastName,doctorFirstName,doctorPhoneNumber,doctorTitle,doctorSIN) VALUES ('Clark','Robert','+1 (257) 863-1972','Palliative Care Specialist','742 394 024');
INSERT INTO Doctor (doctorLastName,doctorFirstName,doctorPhoneNumber,doctorTitle,doctorSIN) VALUES ('James','Terry','+1 (464) 259-1298','Surgeon','762 916 654');
INSERT INTO Doctor (doctorLastName,doctorFirstName,doctorPhoneNumber,doctorTitle,doctorSIN) VALUES ('Johnson','Roger','+1 (782) 619-0182','Intensivist','283 872 371');
INSERT INTO Doctor (doctorLastName,doctorFirstName,doctorPhoneNumber,doctorTitle,doctorSIN) VALUES ('Miller','Janet','+1 (371) 691-9261','Physiatrist','487 293 374');
INSERT INTO Doctor (doctorLastName,doctorFirstName,doctorPhoneNumber,doctorTitle,doctorSIN) VALUES ('Bryant','Joseph','+1 (767) 529-0821','Physiatrist','921 712 238');
INSERT INTO Doctor (doctorLastName,doctorFirstName,doctorPhoneNumber,doctorTitle,doctorSIN) VALUES ('Allen','Lori','+1 (436) 787-7981','Psychologist','712 872 917');
INSERT INTO Doctor (doctorLastName,doctorFirstName,doctorPhoneNumber,doctorTitle,doctorSIN) VALUES ('Powell','Daniel','+1 (234) 981-3871','Pain Specialist','093 365 492');
INSERT INTO Doctor (doctorLastName,doctorFirstName,doctorPhoneNumber,doctorTitle,doctorSIN) VALUES ('Price','John','+1 (567) 871-6120','Geriatrician','471 872 809');
INSERT INTO Doctor (doctorLastName,doctorFirstName,doctorPhoneNumber,doctorTitle,doctorSIN) VALUES ('Campbell','Theresa','+1 (767) 341-0932','Palliative Care Specialist','567 617 281');

INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS358852','762 916 654','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS605959','762 916 654','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS398056','492 628 712','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS322892','492 628 712','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS281321','762 916 654','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS249465','492 628 712','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS624616','762 916 654','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS300361','492 628 712','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS294872','762 916 654','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS948637','492 628 712','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS795080','762 916 654','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS024164','492 628 712','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS531853','762 916 654','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS129533','492 628 712','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS312841','492 628 712','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS218262','762 916 654','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS761046','762 916 654','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS626521','492 628 712','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS689837','762 916 654','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS123408','492 628 712','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS041047','825 629 018','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS978897','283 872 371','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS988669','825 629 018','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS682829','283 872 371','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS570149','283 872 371','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS837748','825 629 018','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS942200','825 629 018','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS692953','283 872 371','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS032917','825 629 018','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS815232','825 629 018','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS197967','283 872 371','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS459850','825 629 018','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS195878','825 629 018','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS192006','283 872 371','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS120573','825 629 018','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS269652','283 872 371','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS907274','825 629 018','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS649869','825 629 018','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS300243','283 872 371','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS066405','825 629 018','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS089533','210 381 025','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS014311','487 293 374','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS980780','210 381 025','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS111127','487 293 374','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS548024','487 293 374','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS640461','210 381 025','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS378263','210 381 025','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS842394','487 293 374','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS600600','210 381 025','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS374286','487 293 374','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS445020','210 381 025','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS578256','487 293 374','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS945213','210 381 025','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS888624','210 381 025','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS107400','210 381 025','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS961053','487 293 374','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS967223','210 381 025','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS970388','210 381 025','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS574642','487 293 374','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS337562','487 293 374','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS647526','921 712 238','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS404543','147 925 232','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS512772','147 925 232','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS845078','921 712 238','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS932294','921 712 238','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS166511','147 925 232','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS566502','921 712 238','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS874875','147 925 232','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS884448','147 925 232','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS564657','921 712 238','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS980843','147 925 232','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS589036','921 712 238','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS078366','147 925 232','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS495003','921 712 238','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS769091','147 925 232','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS744974','147 925 232','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS552236','147 925 232','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS149284','921 712 238','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS961928','147 925 232','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS714341','921 712 238','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS839655','712 872 917','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS107620','612 031 682','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS046332','612 031 682','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS217742','612 031 682','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS254465','712 872 917','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS484575','612 031 682','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS956738','612 031 682','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS971259','612 031 682','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS524970','712 872 917','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS346048','612 031 682','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS134787','612 031 682','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS705002','612 031 682','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS464193','612 031 682','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS674794','712 872 917','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS342183','612 031 682','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS049746','612 031 682','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS604745','712 872 917','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS742290','712 872 917','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS545873','612 031 682','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS906516','612 031 682','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS356272','193 749 290','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS894128','193 749 290','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS510439','093 365 492','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS129288','193 749 290','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS950385','193 749 290','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS485110','093 365 492','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS274796','093 365 492','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS649271','193 749 290','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS060289','193 749 290','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS535296','093 365 492','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS194109','193 749 290','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS182805','193 749 290','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS332936','093 365 492','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS549031','193 749 290','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS978302','093 365 492','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS284615','193 749 290','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS516472','193 749 290','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS249916','193 749 290','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS766475','093 365 492','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS083576','093 365 492','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS481302','397 018 639','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS645281','471 872 809','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS602725','397 018 639','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS312552','397 018 639','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS735632','397 018 639','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS662669','471 872 809','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS344005','397 018 639','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS949621','397 018 639','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS942499','397 018 639','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS147884','471 872 809','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS411905','397 018 639','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS901512','397 018 639','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS933416','471 872 809','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS995362','397 018 639','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS795212','471 872 809','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS731439','397 018 639','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS416733','397 018 639','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS776785','471 872 809','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS881260','397 018 639','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS693627','471 872 809','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS199683','742 394 024','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS207714','567 617 281','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS115791','742 394 024','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS056697','742 394 024','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS394386','742 394 024','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS057624','567 617 281','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS486620','742 394 024','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS312216','742 394 024','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS330394','742 394 024','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS200113','567 617 281','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS388840','742 394 024','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS353994','742 394 024','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS262372','567 617 281','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS492447','742 394 024','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS901599','567 617 281','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS600861','742 394 024','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS068176','742 394 024','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS378461','742 394 024','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS148847','567 617 281','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS933038','742 394 024','Attending Physician');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS218262','567 617 281','Family Doctor');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS195878','742 394 024','Family Doctor');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS107400','487 293 374','Family Doctor');
INSERT INTO IsProvidedForBy (patientMCS,doctorSIN,role) VALUES ('MCS194109','762 916 654','Family Doctor');

INSERT INTO HematologyResults (patientMCS,labDateTime,WBC,RBC,HGB,HCT,pitCount,neutrophils,lymphocytes,monocytes,eosinophils,basophils) VALUES ('MCS218262','2017-03-12 10:45:00','4.5','5.3','9.1','24.5','214','25','18','97','77','80');
INSERT INTO HematologyResults (patientMCS,labDateTime,WBC,RBC,HGB,HCT,pitCount,neutrophils,lymphocytes,monocytes,eosinophils,basophils) VALUES ('MCS218262','2017-03-19 15:30:00','3.4','5.9','10.2','23.9','203','8','53','43','28','25');
INSERT INTO HematologyResults (patientMCS,labDateTime,WBC,RBC,HGB,HCT,pitCount,neutrophils,lymphocytes,monocytes,eosinophils,basophils) VALUES ('MCS218262','2017-04-21 13:00:00','3.4','5.7','9','23.9','156','7','34','36','32','80');
INSERT INTO HematologyResults (patientMCS,labDateTime,WBC,RBC,HGB,HCT,pitCount,neutrophils,lymphocytes,monocytes,eosinophils,basophils) VALUES ('MCS218262','2017-05-23 14:15:00','3.2','5','11.1','22.4','169','17','60','10','21','74');
INSERT INTO HematologyResults (patientMCS,labDateTime,WBC,RBC,HGB,HCT,pitCount,neutrophils,lymphocytes,monocytes,eosinophils,basophils) VALUES ('MCS195878','2017-08-12 10:30:00','3.5','4.7','9.4','21.4','243','75','85','25','95','85');
INSERT INTO HematologyResults (patientMCS,labDateTime,WBC,RBC,HGB,HCT,pitCount,neutrophils,lymphocytes,monocytes,eosinophils,basophils) VALUES ('MCS195878','2017-08-20 20:00:00','3.7','4.7','8.2','21.4','211','22','52','74','58','88');
INSERT INTO HematologyResults (patientMCS,labDateTime,WBC,RBC,HGB,HCT,pitCount,neutrophils,lymphocytes,monocytes,eosinophils,basophils) VALUES ('MCS195878','2017-08-28 17:00:00','4.4','5.7','11.6','29.5','181','94','84','20','27','70');
INSERT INTO HematologyResults (patientMCS,labDateTime,WBC,RBC,HGB,HCT,pitCount,neutrophils,lymphocytes,monocytes,eosinophils,basophils) VALUES ('MCS195878','2017-09-03 14:45:00','3.3','6.1','9.2','26.5','156','40','21','43','84','17');
INSERT INTO HematologyResults (patientMCS,labDateTime,WBC,RBC,HGB,HCT,pitCount,neutrophils,lymphocytes,monocytes,eosinophils,basophils) VALUES ('MCS195878','2017-09-07 17:30:00','4.3','5.6','8.8','22.7','204','10','37','78','5','11');
INSERT INTO HematologyResults (patientMCS,labDateTime,WBC,RBC,HGB,HCT,pitCount,neutrophils,lymphocytes,monocytes,eosinophils,basophils) VALUES ('MCS107400','2015-08-12 16:00:00','4.2','6','10','29','162','39','36','89','12','40');
INSERT INTO HematologyResults (patientMCS,labDateTime,WBC,RBC,HGB,HCT,pitCount,neutrophils,lymphocytes,monocytes,eosinophils,basophils) VALUES ('MCS107400','2016-01-30 19:30:00','4','5.2','9.4','27.3','162','5','55','67','35','26');
INSERT INTO HematologyResults (patientMCS,labDateTime,WBC,RBC,HGB,HCT,pitCount,neutrophils,lymphocytes,monocytes,eosinophils,basophils) VALUES ('MCS107400','2016-02-15 17:45:00','3.2','6.1','10.1','21.4','153','57','98','25','29','95');

INSERT INTO ChemistryResults (patientMCS,labDateTime,sodium,potassium,chloride,BUN,creatinine,estimatedGFR,calcium,totalBilirubin,AST,ALT) VALUES ('MCS218262','2017-05-13 20:15:00','120','4.2','100','3','1.05','48.69','9.3','1.1','40','76');
INSERT INTO ChemistryResults (patientMCS,labDateTime,sodium,potassium,chloride,BUN,creatinine,estimatedGFR,calcium,totalBilirubin,AST,ALT) VALUES ('MCS218262','2017-05-27 18:00:00','115','4.4','105','15','1.07','43.25','9.5','1.2','45','81');
INSERT INTO ChemistryResults (patientMCS,labDateTime,sodium,potassium,chloride,BUN,creatinine,estimatedGFR,calcium,totalBilirubin,AST,ALT) VALUES ('MCS107400','2017-06-06 17:00:00','130','4.5','112','23','1.11','50.36','9.1','1.5','50','87');
INSERT INTO ChemistryResults (patientMCS,labDateTime,sodium,potassium,chloride,BUN,creatinine,estimatedGFR,calcium,totalBilirubin,AST,ALT) VALUES ('MCS107400','2017-06-12 18:30:00','125','4','103','27','1.12','45.26','10.6','1.4','48','92');
INSERT INTO ChemistryResults (patientMCS,labDateTime,sodium,potassium,chloride,BUN,creatinine,estimatedGFR,calcium,totalBilirubin,AST,ALT) VALUES ('MCS107400','2017-06-19 13:30:00','140','4.2','109','18','1.04','54.89','10.2','1.9','47','98');
INSERT INTO ChemistryResults (patientMCS,labDateTime,sodium,potassium,chloride,BUN,creatinine,estimatedGFR,calcium,totalBilirubin,AST,ALT) VALUES ('MCS107400','2017-08-20 11:45:00','100','4.3','106','21','1.09','42.87','10.4','1.5','38','45');
INSERT INTO ChemistryResults (patientMCS,labDateTime,sodium,potassium,chloride,BUN,creatinine,estimatedGFR,calcium,totalBilirubin,AST,ALT) VALUES ('MCS194109','2016-11-30 08:30:00','120','4.8','104','25','1.23','52.27','10.5','1.0','44','65');
INSERT INTO ChemistryResults (patientMCS,labDateTime,sodium,potassium,chloride,BUN,creatinine,estimatedGFR,calcium,totalBilirubin,AST,ALT) VALUES ('MCS194109','2017-01-15 10:30:00','125','4.6','114','19','1.01','43.78','9.9','1.7','41','72');
INSERT INTO ChemistryResults (patientMCS,labDateTime,sodium,potassium,chloride,BUN,creatinine,estimatedGFR,calcium,totalBilirubin,AST,ALT) VALUES ('MCS194109','2017-01-29 11:45:00','135','4.7','112','14','1.02','52.12','9.8','1.4','52','64');

INSERT INTO UrinalysisResults (patientMCS,labDateTime,colour,appearance,specificGravity,pH,protein,glucose,elythrocytes,leukocyteEsterase,nitrite,kestones) VALUES ('MCS218262','2016-08-15 07:30:00','YELLOW','CLEAR','1.015','7','NEGATIVE','POSITIVE','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE');
INSERT INTO UrinalysisResults (patientMCS,labDateTime,colour,appearance,specificGravity,pH,protein,glucose,elythrocytes,leukocyteEsterase,nitrite,kestones) VALUES ('MCS218262','2016-09-22 13:45:00','YELLOW','CLOUDY','1.017','8','NEGATIVE','NEGATIVE','NEGATIVE','POSITIVE','NEGATIVE','NEGATIVE');
INSERT INTO UrinalysisResults (patientMCS,labDateTime,colour,appearance,specificGravity,pH,protein,glucose,elythrocytes,leukocyteEsterase,nitrite,kestones) VALUES ('MCS195878','2016-03-14 15:00:00','YELLOW','CLEAR','1.023','7','POSITIVE','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE');
INSERT INTO UrinalysisResults (patientMCS,labDateTime,colour,appearance,specificGravity,pH,protein,glucose,elythrocytes,leukocyteEsterase,nitrite,kestones) VALUES ('MCS195878','2016-04-08 16:15:00','YELLOW','CLEAR','1.032','7','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE','POSITIVE');
INSERT INTO UrinalysisResults (patientMCS,labDateTime,colour,appearance,specificGravity,pH,protein,glucose,elythrocytes,leukocyteEsterase,nitrite,kestones) VALUES ('MCS195878','2016-04-25 20:00:00','YELLOW','CLOUDY','1.003','7','NEGATIVE','POSITIVE','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE');
INSERT INTO UrinalysisResults (patientMCS,labDateTime,colour,appearance,specificGravity,pH,protein,glucose,elythrocytes,leukocyteEsterase,nitrite,kestones) VALUES ('MCS194109','2015-12-23 19:00:00','YELLOW','CLEAR','1.008','6','NEGATIVE','NEGATIVE','NEGATIVE','POSITIVE','NEGATIVE','NEGATIVE');

INSERT INTO CoagulationResults (patientMCS,labDateTime,INR) VALUES ('MCS218262','2017-03-12 10:45:00','1.2');
INSERT INTO CoagulationResults (patientMCS,labDateTime,INR) VALUES ('MCS218262','2017-03-19 15:30:00','1.1');
INSERT INTO CoagulationResults (patientMCS,labDateTime,INR) VALUES ('MCS218262','2017-04-21 13:00:00','1.5');
INSERT INTO CoagulationResults (patientMCS,labDateTime,INR) VALUES ('MCS218262','2017-05-23 14:15:00','1.6');
INSERT INTO CoagulationResults (patientMCS,labDateTime,INR) VALUES ('MCS195878','2017-08-12 10:30:00','0.8');
INSERT INTO CoagulationResults (patientMCS,labDateTime,INR) VALUES ('MCS195878','2017-08-20 20:00:00','0.9');
INSERT INTO CoagulationResults (patientMCS,labDateTime,INR) VALUES ('MCS195878','2017-08-28 17:00:00','1.2');
INSERT INTO CoagulationResults (patientMCS,labDateTime,INR) VALUES ('MCS195878','2017-09-03 14:45:00','1.1');
INSERT INTO CoagulationResults (patientMCS,labDateTime,INR) VALUES ('MCS195878','2017-09-07 17:30:00','1.0');
INSERT INTO CoagulationResults (patientMCS,labDateTime,INR) VALUES ('MCS107400','2015-08-12 16:00:00','1.4');
INSERT INTO CoagulationResults (patientMCS,labDateTime,INR) VALUES ('MCS107400','2016-01-30 19:30:00','1.3');
INSERT INTO CoagulationResults (patientMCS,labDateTime,INR) VALUES ('MCS107400','2016-02-15 17:45:00','1.1');

INSERT INTO ToxicologyResults (patientMCS,labDateTime,Marijuana,THC,cocaine,opiates,oxycodone,amphetamines) VALUES ('MCS218262','2017-05-13 20:15:00','POSITIVE','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE');
INSERT INTO ToxicologyResults (patientMCS,labDateTime,Marijuana,THC,cocaine,opiates,oxycodone,amphetamines) VALUES ('MCS218262','2017-05-27 18:00:00','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE');
INSERT INTO ToxicologyResults (patientMCS,labDateTime,Marijuana,THC,cocaine,opiates,oxycodone,amphetamines) VALUES ('MCS107400','2017-06-06 17:00:00','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE');
INSERT INTO ToxicologyResults (patientMCS,labDateTime,Marijuana,THC,cocaine,opiates,oxycodone,amphetamines) VALUES ('MCS107400','2017-06-12 18:30:00','NEGATIVE','NEGATIVE','NEGATIVE','POSITIVE','NEGATIVE','NEGATIVE');
INSERT INTO ToxicologyResults (patientMCS,labDateTime,Marijuana,THC,cocaine,opiates,oxycodone,amphetamines) VALUES ('MCS107400','2017-06-19 13:30:00','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE');
INSERT INTO ToxicologyResults (patientMCS,labDateTime,Marijuana,THC,cocaine,opiates,oxycodone,amphetamines) VALUES ('MCS107400','2017-08-20 11:45:00','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE');
INSERT INTO ToxicologyResults (patientMCS,labDateTime,Marijuana,THC,cocaine,opiates,oxycodone,amphetamines) VALUES ('MCS194109','2016-11-30 08:30:00','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE','POSITIVE');
INSERT INTO ToxicologyResults (patientMCS,labDateTime,Marijuana,THC,cocaine,opiates,oxycodone,amphetamines) VALUES ('MCS194109','2017-01-15 10:30:00','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE');
INSERT INTO ToxicologyResults (patientMCS,labDateTime,Marijuana,THC,cocaine,opiates,oxycodone,amphetamines) VALUES ('MCS194109','2017-01-29 11:45:00','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE');

INSERT INTO SerologyResults (patientMCS,labDateTime,HIV,HepatitisA,HepatitisB,HepatitisC) VALUES ('MCS218262','2017-05-13 20:15:00','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE');
INSERT INTO SerologyResults (patientMCS,labDateTime,HIV,HepatitisA,HepatitisB,HepatitisC) VALUES ('MCS218262','2017-05-27 18:00:00','NEGATIVE','NEGATIVE','POSITIVE','NEGATIVE');
INSERT INTO SerologyResults (patientMCS,labDateTime,HIV,HepatitisA,HepatitisB,HepatitisC) VALUES ('MCS107400','2017-06-06 17:00:00','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE');
INSERT INTO SerologyResults (patientMCS,labDateTime,HIV,HepatitisA,HepatitisB,HepatitisC) VALUES ('MCS107400','2017-06-12 18:30:00','NEGATIVE','NEGATIVE','NEGATIVE','POSITIVE');
INSERT INTO SerologyResults (patientMCS,labDateTime,HIV,HepatitisA,HepatitisB,HepatitisC) VALUES ('MCS107400','2017-06-19 13:30:00','NEGATIVE','POSITIVE','NEGATIVE','NEGATIVE');
INSERT INTO SerologyResults (patientMCS,labDateTime,HIV,HepatitisA,HepatitisB,HepatitisC) VALUES ('MCS194109','2016-11-30 08:30:00','NEGATIVE','NEGATIVE','NEGATIVE','NEGATIVE');
INSERT INTO SerologyResults (patientMCS,labDateTime,HIV,HepatitisA,HepatitisB,HepatitisC) VALUES ('MCS194109','2017-01-29 11:45:00','POSITIVE','NEGATIVE','NEGATIVE','NEGATIVE');

INSERT INTO Contacts (patientMCS,contactPostalCode,contactCity,contactAddress,contactName,contactPhoneNumber,contactRelationship) VALUES ('MCS218262','B31 2S6','Thunder Bay','609 Rock Maple Road','James Brown','+1 (342) 724-1826','Husband');
INSERT INTO Contacts (patientMCS,contactPostalCode,contactCity,contactAddress,contactName,contactPhoneNumber,contactRelationship) VALUES ('MCS218262','C6B 9M2','Fredericton','272 Cedar Drive','Carly Brown','+1 (561) 876-9801','Mother');
INSERT INTO Contacts (patientMCS,contactPostalCode,contactCity,contactAddress,contactName,contactPhoneNumber,contactRelationship) VALUES ('MCS195878','DB5 Y6C','Thunder Bay','204 Pawnee Drive','Martin Duncan','+1 (782) 564-2381','Brother');
INSERT INTO Contacts (patientMCS,contactPostalCode,contactCity,contactAddress,contactName,contactPhoneNumber,contactRelationship) VALUES ('MCS107400','G8B C4L','Thunder Bay','873 Pine Avenue','Anthony Hodges','+1 (563) 678-1592','Father');
INSERT INTO Contacts (patientMCS,contactPostalCode,contactCity,contactAddress,contactName,contactPhoneNumber,contactRelationship) VALUES ('MCS107400','H5B D8X','Quebec City','264 Glenwood Ave.','Olivia Hodges','+1 (872) 582-8143','Sister');
INSERT INTO Contacts (patientMCS,contactPostalCode,contactCity,contactAddress,contactName,contactPhoneNumber,contactRelationship) VALUES ('MCS194109','D4N 8B4','Thunder Bay','18 Lake View Drive','Erica Quinn','+1 (467) 369-8642','Wife');
INSERT INTO Contacts (patientMCS,contactPostalCode,contactCity,contactAddress,contactName,contactPhoneNumber,contactRelationship) VALUES ('MCS194109','R6Y 9B3','Thunder Bay','541 Saxon Road','David Quinn','+1 (478) 291-9251','Father');

INSERT INTO Medications (genericName,tradeName) VALUES ('Lexofloxacin ','Lexaquin');
INSERT INTO Medications (genericName,tradeName) VALUES ('Furosemide','Lasix');
INSERT INTO Medications (genericName,tradeName) VALUES ('Influenza Virus Vaccine','Fluvirin Vac');
INSERT INTO Medications (genericName,tradeName) VALUES ('Acetaminophen','Tylenol');
INSERT INTO Medications (genericName,tradeName) VALUES ('Sodium Chloride','Sodium Chloride');
INSERT INTO Medications (genericName,tradeName) VALUES ('Ramipril','Altace');
INSERT INTO Medications (genericName,tradeName) VALUES ('Pantoloc','Pantoprazole');
INSERT INTO Medications (genericName,tradeName) VALUES ('Docusate Sodium','Colace');
INSERT INTO Medications (genericName,tradeName) VALUES ('Avapro','Irbesartan');
INSERT INTO Medications (genericName,tradeName) VALUES ('Lasix','Furosemide');
INSERT INTO Medications (genericName,tradeName) VALUES ('Aldactone','Spironolactone');
INSERT INTO Medications (genericName,tradeName) VALUES ('Metformin','Glucophage');
INSERT INTO Medications (genericName,tradeName) VALUES ('Amoxicillin','Amoxil');
INSERT INTO Medications (genericName,tradeName) VALUES ('Zopiclone','Imovane');
INSERT INTO Medications (genericName,tradeName) VALUES ('Ibuprofen','Advil');
INSERT INTO Medications (genericName,tradeName) VALUES ('Doxycycline','Vibramycin');
INSERT INTO Medications (genericName,tradeName) VALUES ('Lorazepam','Ativan');
INSERT INTO Medications (genericName,tradeName) VALUES ('Hydrochlorothiazide','Microzide');
INSERT INTO Medications (genericName,tradeName) VALUES ('Gabapentin','Neurontin');
INSERT INTO Medications (genericName,tradeName) VALUES ('Alprazolam','Xanax');
INSERT INTO Medications (genericName,tradeName) VALUES ('Amitriptyline','Elavil');
INSERT INTO Medications (genericName,tradeName) VALUES ('Trazodone','Desyrel');
INSERT INTO Medications (genericName,tradeName) VALUES ('Azithromycin','Zithromax');

INSERT INTO Takes (patientMCS,genericName,medStatus,dosage,route,stopDate,startDate,sigSch,lastAdmin,doseAdmin) VALUES ('MCS218262','Lexofloxacin ','Active','750 mg','PO','2017-10-12 15:00:00','2017-09-03 14:45:00','DAILY','2017-10-12 15:00:00','750 MG PO');
INSERT INTO Takes (patientMCS,genericName,medStatus,dosage,route,stopDate,startDate,sigSch,lastAdmin,doseAdmin) VALUES ('MCS218262','Furosemide','Active','80 mg','PO','2017-11-29 11:30:00','2017-08-28 17:00:00','DAILY','2017-11-29 11:30:00','80 MG PO');
INSERT INTO Takes (patientMCS,genericName,medStatus,dosage,route,stopDate,startDate,sigSch,lastAdmin,doseAdmin) VALUES ('MCS218262','Influenza Virus Vaccine','Active','0.5 mL','IM','2017-10-23 08:30:00','2017-08-20 20:00:00','ONCE','2017-10-23 08:30:00','0.5 ML IV');
INSERT INTO Takes (patientMCS,genericName,medStatus,dosage,route,stopDate,startDate,sigSch,lastAdmin,doseAdmin) VALUES ('MCS218262','Acetaminophen','Active','1000 mg','PO','2017-09-29 19:00:00','2017-08-12 10:30:00','Q4H PRN','2017-09-29 19:00:00','1000 MG PO');
INSERT INTO Takes (patientMCS,genericName,medStatus,dosage,route,stopDate,startDate,sigSch,lastAdmin,doseAdmin) VALUES ('MCS218262','Sodium Chloride','Discontinued','650 mg','PO','2017-05-23 18:30:00','2017-05-23 14:15:00','Q4H PRN','2017-05-23 18:30:00','650 MG PO');
INSERT INTO Takes (patientMCS,genericName,medStatus,dosage,route,stopDate,startDate,sigSch,lastAdmin,doseAdmin) VALUES ('MCS218262','Ramipril','Active','5 mg','PO','2017-011-21 17:00:00','2017-04-21 13:00:00','DAILY','2017-011-21 17:00:00','5 MG PO');
INSERT INTO Takes (patientMCS,genericName,medStatus,dosage,route,stopDate,startDate,sigSch,lastAdmin,doseAdmin) VALUES ('MCS218262','Pantoloc','Discontinued','650 mg','PO','2017-05-27 15:30:00','2017-03-19 15:30:00','DAILY','2017-05-27 15:30:00','650 MG PO');
INSERT INTO Takes (patientMCS,genericName,medStatus,dosage,route,stopDate,startDate,sigSch,lastAdmin,doseAdmin) VALUES ('MCS218262','Docusate Sodium','Discontinued','100 mg','PO','2017-04-15 12:45:00','2017-03-12 10:45:00','BID','2017-04-15 12:45:00','100 MG PO');
INSERT INTO Takes (patientMCS,genericName,medStatus,dosage,route,stopDate,startDate,sigSch,lastAdmin,doseAdmin) VALUES ('MCS218262','Avapro','Active','150 mg','PO','2017-03-01 16:30:00','2017-02-27 13:30:00','DAILY','2017-03-01 16:30:00','150 MG PO');
INSERT INTO Takes (patientMCS,genericName,medStatus,dosage,route,stopDate,startDate,sigSch,lastAdmin,doseAdmin) VALUES ('MCS195878','Lasix','Discontinued','20 mg','PO','2017-10-03 16:30:00','2017-09-25 15:45:00','DAILY','2017-10-03 16:30:00','20 MG PO');
INSERT INTO Takes (patientMCS,genericName,medStatus,dosage,route,stopDate,startDate,sigSch,lastAdmin,doseAdmin) VALUES ('MCS195878','Aldactone','Active','200 mg','PO','2017-09-05 08:30:00','2017-08-20 16:30:00','DAILY','2017-09-05 08:30:00','200 MG PO');
INSERT INTO Takes (patientMCS,genericName,medStatus,dosage,route,stopDate,startDate,sigSch,lastAdmin,doseAdmin) VALUES ('MCS195878','Metformin','Active','500 mg','PO','2017-06-25 16:30:00','2017-06-18 14:15:00','DAILY','2017-06-25 16:30:00','500 MG PO');
INSERT INTO Takes (patientMCS,genericName,medStatus,dosage,route,stopDate,startDate,sigSch,lastAdmin,doseAdmin) VALUES ('MCS195878','Amoxicillin','Discontinued','250 mg','PO','2017-04-21 12:30:00','2017-04-07 11:30:00','Q6H','2017-04-21 12:30:00','250 MG PO');
INSERT INTO Takes (patientMCS,genericName,medStatus,dosage,route,stopDate,startDate,sigSch,lastAdmin,doseAdmin) VALUES ('MCS195878','Zopiclone','Discontinued','5 mg','PO','2017-02-24 14:00:00','2017-02-12 14:00:00','HS PRN','2017-02-24 14:00:00','5 MG PO');
INSERT INTO Takes (patientMCS,genericName,medStatus,dosage,route,stopDate,startDate,sigSch,lastAdmin,doseAdmin) VALUES ('MCS195878','Ibuprofen','Active','400 mg','PO','2016-12-19 23:00:00','2016-08-13 09:30:00','Q6H PRN','2016-12-19 23:00:00','400 MG PO');
INSERT INTO Takes (patientMCS,genericName,medStatus,dosage,route,stopDate,startDate,sigSch,lastAdmin,doseAdmin) VALUES ('MCS107400','Doxycycline','Active','500 mg','PO','2017-05-22 10:45:00','2017-05-19 08:30:00','DAILY','2017-05-22 10:45:00','500 MG PO');
INSERT INTO Takes (patientMCS,genericName,medStatus,dosage,route,stopDate,startDate,sigSch,lastAdmin,doseAdmin) VALUES ('MCS107400','Lorazepam','Active','1 mg','PO','2017-04-21 20:30:00','2017-04-17 10:00:00','PRN','2017-04-21 20:30:00','1  MG PO');
INSERT INTO Takes (patientMCS,genericName,medStatus,dosage,route,stopDate,startDate,sigSch,lastAdmin,doseAdmin) VALUES ('MCS107400','Hydrochlorothiazide','Active','25 mg','PO','2017-01-29 15:15:00','2017-01-23 11:30:00','DAILY','2017-01-29 15:15:00','25 MG PO');
INSERT INTO Takes (patientMCS,genericName,medStatus,dosage,route,stopDate,startDate,sigSch,lastAdmin,doseAdmin) VALUES ('MCS107400','Gabapentin','Active','400mg','PO','2016-10-04 17:00:00','2016-09-27 15:00:00','BID','2016-10-04 17:00:00','400 MG PO');
INSERT INTO Takes (patientMCS,genericName,medStatus,dosage,route,stopDate,startDate,sigSch,lastAdmin,doseAdmin) VALUES ('MCS107400','Alprazolam','Active','300 mg','PO','2016-06-12 10:30:00','2016-06-02 14:45:00','DAILY','2016-06-12 10:30:00','300 MG PO');
INSERT INTO Takes (patientMCS,genericName,medStatus,dosage,route,stopDate,startDate,sigSch,lastAdmin,doseAdmin) VALUES ('MCS107400','Amitriptyline','Discontinued','10 mg','PO','2016-01-18 11:30:00','2016-01-13 08:00:00','DAILY','2016-01-18 11:30:00','10 MG PO');
INSERT INTO Takes (patientMCS,genericName,medStatus,dosage,route,stopDate,startDate,sigSch,lastAdmin,doseAdmin) VALUES ('MCS194109','Trazodone','Discontinued','50 mg','PO','2017-07-29 18:00:00','2017-07-17 09:30:00','HS','2017-07-29 18:00:00','50 MG PO');
INSERT INTO Takes (patientMCS,genericName,medStatus,dosage,route,stopDate,startDate,sigSch,lastAdmin,doseAdmin) VALUES ('MCS194109','Azithromycin','Active','100 mg','PO','2017-06-15 14:00:00','2017-05-30 16:00:00','DAILY','2017-06-15 14:00:00','100 MG PO');

INSERT INTO Notes (patientMCS,focus,contents,dateOfReport,timeOfReport,userName,userTitle,noteID) VALUES ('MCS218262','Social Work Assessment','D- Writer met with client for the purpose of initial assessment. Writer introduced self, explained role of SW, limits of confidentiality, and reason for assessment. Client receptive to today’s meeting. Client chart reviewed prior to meeting.
\nA-Client shared that he was living in a core floor home with his supportive spouse and two children (ages 12 and 14) prior to admission. There are three stairs to enter the home – client did not identify this as a barrier upon discharge. Client provided verbal consent for this writer/team to communicate with spouse and two children if necessary. Client identified several support systems in his life, including family members and close friends. Client is retired (previously employed at paper mill). He reports no concerns with finances and is receiving private pension, OAS and CPP. Client was previously independent with ADLs and IADLs. Client was also independent in terms of transportation. Client did not express any concerns about returning home post-discharge. Client reports no concerns with his mood as of recent. Client is a non-smoker; however, he reports some drug and alcohol use. Client’s drug of choice is reportedly marijuana and he shared that he will typically smoke it 3x/week. Client further states that he drinks approximately 3-4 beer per day. Client stated that he has not participated in treatment for drug/alcohol use in the past; however, client noted that his drug/alcohol use is problematic and is interested in exploring this further. Writer provided client with information regarding treatment program. Client agreeable to review this information and meet with writer tomorrow to complete application.
\nR-Client pleasant and receptive to SW. Writer wrote SW contact information on client\'s white board should she have any questions or concerns. No questions/concerns verbalized at this time.
\nP-Meet with client tomorrow to further discuss/complete application for treatment program; liaise with circle of care to facilitate discharge planning.','2017-09-15','15:30:00','Russell Nelson','Social Worker','1');
INSERT INTO Notes (patientMCS,focus,contents,dateOfReport,timeOfReport,userName,userTitle,noteID) VALUES ('MCS218262','Social Work Follow Up','D-Social work met with client for follow up to complete application for treatment program as per yesterday’s discussion. Writer answered the client’s questions pertaining to the treatment program. Client remains agreeable to applying for the treatment program.
\nA-Application for treatment program completed and faxed. Original application on client’s paper chart.
\nR-Client receptive and appreciative of assistance.
\nP-Writer will continue to monitor.',
'2017-07-29','14:00:00','Russell Nelson','Social Worker','2');
INSERT INTO Notes (patientMCS,focus,contents,dateOfReport,timeOfReport,userName,userTitle,noteID) VALUES ('MCS218262','Sleep Disturbance','D-Client reports not sleeping well during the night. States is awake at 0300hrs and unable to fall back asleep.  Reports has used sleeping pill occasionally in the past.
\nA-MD notified and sedative ordered. Trazadone 50mg  given po
\nR-Client slept all night—Sedation effective.
\nP-Continue with sedation as needed
','2017-05-14','12:00:00','Ernest Flores','Nurse','3');
INSERT INTO Notes (patientMCS,focus,contents,dateOfReport,timeOfReport,userName,userTitle,noteID) VALUES ('MCS218262','Pain','D-Client c/o pain to right shoulder
\nA-Pain medication administered
\nR-Client reports medication effective
\nP-Continue to administer pain meds as needed
','2017-03-26','21:30:00','Barbara Smith','Nurse','4');
INSERT INTO Notes (patientMCS,focus,contents,dateOfReport,timeOfReport,userName,userTitle,noteID) VALUES ('MCS218262','Medication Education','A-Writer demonstrated to client how to administer Lovenox  S.Q. Instructed client about side effects and safety precautions.  Provided client with additional printed education.
\nR-Client demonstrated how to administer Lovenox in Left lower quadrant. Client verbalized correctly side effects and safety precautions.
','2017-02-19','10:45:00','Steven Baker','Nurse','5');
INSERT INTO Notes (patientMCS,focus,contents,dateOfReport,timeOfReport,userName,userTitle,noteID) VALUES ('MCS195878','Admission','D-Admitted from TBRHSC-1A- via Ambutrans. Arrived to unit via wheelchair and porter escort.  Alert and oriented X3
\nA- V.S.S. MD notified and admission orders received.
\nP-Continue with admission process
','2017-09-23','06:45:00','Joe Collins','Nurse','6');
INSERT INTO Notes (patientMCS,focus,contents,dateOfReport,timeOfReport,userName,userTitle,noteID) VALUES ('MCS195878','Fall','D-Writer entered client’s room and found client lying on right side on floor by bedside.  Client wearing socks only, no footwear. Client reported that they were overreaching for an item on counter. V.S.S. Denies hitting head.  Writer assessed client on floor. Hip assessment resulted normal; no leg length shortening or external hip rotation. Client denies any pain/tenderness to bilateral hip region. Assisted back to bed with two staff assist.  No injuries sustained. MD, Clinical Resource Co-ordinator and family notified of fall. Family agreeable to activation of bed alarm when client in bed. Fall Risk and Post fall intervention updated.
\nP-Activate bed alarm and monitor client closely.
','2017-09-16','17:00:00','Fred Phillips','Nurse','7');
INSERT INTO Notes (patientMCS,focus,contents,dateOfReport,timeOfReport,userName,userTitle,noteID) VALUES ('MCS195878','Social Work Assessment','D- Writer met with client for the purpose of initial assessment. Writer introduced self, explained role of SW, limits of confidentiality, and reason for assessment. Client receptive to today’s meeting. Client chart reviewed prior to meeting.
\nA-Client shared that he was living in a core floor home with his supportive spouse and two children (ages 12 and 14) prior to admission. There are three stairs to enter the home – client did not identify this as a barrier upon discharge. Client provided verbal consent for this writer/team to communicate with spouse and two children if necessary. Client identified several support systems in his life, including family members and close friends. Client is retired (previously employed at paper mill). He reports no concerns with finances and is receiving private pension, OAS and CPP. Client was previously independent with ADLs and IADLs. Client was also independent in terms of transportation. Client did not express any concerns about returning home post-discharge. Client reports no concerns with his mood as of recent. Client is a non-smoker; however, he reports some drug and alcohol use. Client’s drug of choice is reportedly marijuana and he shared that he will typically smoke it 3x/week. Client further states that he drinks approximately 3-4 beer per day. Client stated that he has not participated in treatment for drug/alcohol use in the past; however, client noted that his drug/alcohol use is problematic and is interested in exploring this further. Writer provided client with information regarding treatment program. Client agreeable to review this information and meet with writer tomorrow to complete application.
\nR-Client pleasant and receptive to SW. Writer wrote SW contact information on client\'s white board should she have any questions or concerns. No questions/concerns verbalized at this time.
\nP-Meet with client tomorrow to further discuss/complete application for treatment program; liaise with circle of care to facilitate discharge planning.','2017-09-09','15:00:00','Russell Nelson','Social Worker','8');
INSERT INTO Notes (patientMCS,focus,contents,dateOfReport,timeOfReport,userName,userTitle,noteID) VALUES ('MCS195878','Social Work Follow Up','D-Social work met with client for follow up to complete application for treatment program as per yesterday’s discussion. Writer answered the client’s questions pertaining to the treatment program. Client remains agreeable to applying for the treatment program.
\nA-Application for treatment program completed and faxed. Original application on client’s paper chart.
\nR-Client receptive and appreciative of assistance.
\nP-Writer will continue to monitor.','2017-08-30','13:15:00','Russell Nelson','Social Worker','9');
INSERT INTO Notes (patientMCS,focus,contents,dateOfReport,timeOfReport,userName,userTitle,noteID) VALUES ('MCS195878','Sleep Disturbance','D-Client reports not sleeping well during the night. States is awake at 0300hrs and unable to fall back asleep.  Reports has used sleeping pill occasionally in the past.
\nA-MD notified and sedative ordered. Trazadone 50mg  given po
\nR-Client slept all night—Sedation effective.
\nP-Continue with sedation as needed
','2017-08-12','18:00:00','Ernest Flores','Nurse','10');
INSERT INTO Notes (patientMCS,focus,contents,dateOfReport,timeOfReport,userName,userTitle,noteID) VALUES ('MCS195878','Pain','D-Client c/o pain to right shoulder
\nA-Pain medication administered
\nR-Client reports medication effective
\nP-Continue to administer pain meds as needed
','2017-07-26','19:30:00','Barbara Smith','Nurse','11');
INSERT INTO Notes (patientMCS,focus,contents,dateOfReport,timeOfReport,userName,userTitle,noteID) VALUES ('MCS195878','Medication Education','A-Writer demonstrated to client how to administer Lovenox  S.Q. Instructed client about side effects and safety precautions.  Provided client with additional printed education.
\nR-Client demonstrated how to administer Lovenox in Left lower quadrant. Client verbalized correctly side effects and safety precautions.
','2017-07-14','15:45:00','Steven Baker','Nurse','12');
INSERT INTO Notes (patientMCS,focus,contents,dateOfReport,timeOfReport,userName,userTitle,noteID) VALUES ('MCS107400','Admission','D-Admitted from TBRHSC-1A- via Ambutrans. Arrived to unit via wheelchair and porter escort.  Alert and oriented X3
\nA- V.S.S. MD notified and admission orders received.
\nP-Continue with admission process
','2017-08-22','12:30:00','Joe Collins','Nurse','13');
INSERT INTO Notes (patientMCS,focus,contents,dateOfReport,timeOfReport,userName,userTitle,noteID) VALUES ('MCS194109','Fall','D-Writer entered client’s room and found client lying on right side on floor by bedside.  Client wearing socks only, no footwear. Client reported that they were overreaching for an item on counter. V.S.S. Denies hitting head.  Writer assessed client on floor. Hip assessment resulted normal; no leg length shortening or external hip rotation. Client denies any pain/tenderness to bilateral hip region. Assisted back to bed with two staff assist.  No injuries sustained. MD, Clinical Resource Co-ordinator and family notified of fall. Family agreeable to activation of bed alarm when client in bed. Fall Risk and Post fall intervention updated.
\nP-Activate bed alarm and monitor client closely.
','2017-09-10','16:15:00','Fred Phillips','Nurse','14');
INSERT INTO Notes (patientMCS,focus,contents,dateOfReport,timeOfReport,userName,userTitle,noteID) VALUES ('MCS194109','Social Work Assessment','D- Writer met with client for the purpose of initial assessment. Writer introduced self, explained role of SW, limits of confidentiality, and reason for assessment. Client receptive to today’s meeting. Client chart reviewed prior to meeting.
\nA-Client shared that he was living in a core floor home with his supportive spouse and two children (ages 12 and 14) prior to admission. There are three stairs to enter the home – client did not identify this as a barrier upon discharge. Client provided verbal consent for this writer/team to communicate with spouse and two children if necessary. Client identified several support systems in his life, including family members and close friends. Client is retired (previously employed at paper mill). He reports no concerns with finances and is receiving private pension, OAS and CPP. Client was previously independent with ADLs and IADLs. Client was also independent in terms of transportation. Client did not express any concerns about returning home post-discharge. Client reports no concerns with his mood as of recent. Client is a non-smoker; however, he reports some drug and alcohol use. Client’s drug of choice is reportedly marijuana and he shared that he will typically smoke it 3x/week. Client further states that he drinks approximately 3-4 beer per day. Client stated that he has not participated in treatment for drug/alcohol use in the past; however, client noted that his drug/alcohol use is problematic and is interested in exploring this further. Writer provided client with information regarding treatment program. Client agreeable to review this information and meet with writer tomorrow to complete application.
\nR-Client pleasant and receptive to SW. Writer wrote SW contact information on client\'s white board should she have any questions or concerns. No questions/concerns verbalized at this time.
\nP-Meet with client tomorrow to further discuss/complete application for treatment program; liaise with circle of care to facilitate discharge planning.','2017-05-21','12:30:00','Russell Nelson','Social Worker','15');
INSERT INTO Notes (patientMCS,focus,contents,dateOfReport,timeOfReport,userName,userTitle,noteID) VALUES ('MCS194109','Social Work Follow Up','D-Social work met with client for follow up to complete application for treatment program as per yesterday’s discussion. Writer answered the client’s questions pertaining to the treatment program. Client remains agreeable to applying for the treatment program.
\nA-Application for treatment program completed and faxed. Original application on client’s paper chart.
\nR-Client receptive and appreciative of assistance.
\nP-Writer will continue to monitor.','2017-03-12','17:45:00','Russell Nelson','Social Worker','16');

INSERT INTO Orders (orderID,doctorSIN,patientMCS,orderDate,serviceTime,orderTime,procedureName,orderStatus,serviceDate) VALUES ('1','492 628 712','MCS218262','2017-09-12','12:45:00','14:00:00','Consult MD','Active','2017-09-12');
INSERT INTO Orders (orderID,doctorSIN,patientMCS,orderDate,serviceTime,orderTime,procedureName,orderStatus,serviceDate) VALUES ('2','825 629 018','MCS218262','2017-06-16','13:00:00','11:30:00','Regular Diet','Active','2017-06-16');
INSERT INTO Orders (orderID,doctorSIN,patientMCS,orderDate,serviceTime,orderTime,procedureName,orderStatus,serviceDate) VALUES ('3','210 381 025','MCS218262','2017-05-13','16:15:00','19:00:00','CBC','Active','2017-05-13');
INSERT INTO Orders (orderID,doctorSIN,patientMCS,orderDate,serviceTime,orderTime,procedureName,orderStatus,serviceDate) VALUES ('4','147 925 232','MCS218262','2017-05-11','19:00:00','15:00:00','Electrolytes','In Progress','2017-05-11');
INSERT INTO Orders (orderID,doctorSIN,patientMCS,orderDate,serviceTime,orderTime,procedureName,orderStatus,serviceDate) VALUES ('5','612 031 682','MCS218262','2017-05-02','15:00:00','14:45:00','Blood Transfusion','In Progress','2017-05-02');
INSERT INTO Orders (orderID,doctorSIN,patientMCS,orderDate,serviceTime,orderTime,procedureName,orderStatus,serviceDate) VALUES ('6','193 749 290','MCS218262','2017-02-18','14:45:00','12:15:00','EKG','Active','2017-02-18');
INSERT INTO Orders (orderID,doctorSIN,patientMCS,orderDate,serviceTime,orderTime,procedureName,orderStatus,serviceDate) VALUES ('7','397 018 639','MCS218262','2016-04-19','12:15:00','20:00:00','Urine C&S','Incomplete','2016-04-19');
INSERT INTO Orders (orderID,doctorSIN,patientMCS,orderDate,serviceTime,orderTime,procedureName,orderStatus,serviceDate) VALUES ('8','742 394 024','MCS195878','2017-08-14','20:00:00','19:30:00','Urinalysis','Incomplete','2017-08-14');
INSERT INTO Orders (orderID,doctorSIN,patientMCS,orderDate,serviceTime,orderTime,procedureName,orderStatus,serviceDate) VALUES ('9','762 916 654','MCS195878','2017-06-19','19:30:00','12:45:00','CXR','Active','2017-06-19');
INSERT INTO Orders (orderID,doctorSIN,patientMCS,orderDate,serviceTime,orderTime,procedureName,orderStatus,serviceDate) VALUES ('10','283 872 371','MCS195878','2017-04-17','13:00:00','13:00:00','Cardiac Consult','Incomplete','2017-04-17');
INSERT INTO Orders (orderID,doctorSIN,patientMCS,orderDate,serviceTime,orderTime,procedureName,orderStatus,serviceDate) VALUES ('11','487 293 374','MCS195878','2017-02-12','15:45:00','16:15:00','Ultrasound','In Progress','2017-02-12');
INSERT INTO Orders (orderID,doctorSIN,patientMCS,orderDate,serviceTime,orderTime,procedureName,orderStatus,serviceDate) VALUES ('12','921 712 238','MCS195878','2017-01-02','14:00:00','19:00:00','BUN','Active','2017-01-02');
INSERT INTO Orders (orderID,doctorSIN,patientMCS,orderDate,serviceTime,orderTime,procedureName,orderStatus,serviceDate) VALUES ('13','712 872 917','MCS107400','2017-08-16','11:30:00','15:00:00','CT Scan','Active','2017-08-16');
INSERT INTO Orders (orderID,doctorSIN,patientMCS,orderDate,serviceTime,orderTime,procedureName,orderStatus,serviceDate) VALUES ('14','093 365 492','MCS107400','2017-03-26','19:00:00','12:15:00','Cholesterol Level','In Progress','2017-03-26');
INSERT INTO Orders (orderID,doctorSIN,patientMCS,orderDate,serviceTime,orderTime,procedureName,orderStatus,serviceDate) VALUES ('15','471 872 809','MCS107400','2016-10-11','15:00:00','20:00:00','Neurology Consult','Active','2016-10-11');
INSERT INTO Orders (orderID,doctorSIN,patientMCS,orderDate,serviceTime,orderTime,procedureName,orderStatus,serviceDate) VALUES ('16','567 617 281','MCS194109','2017-10-18','14:45:00','19:30:00','MRI','Incomplete','2017-10-18');
INSERT INTO Orders (orderID,doctorSIN,patientMCS,orderDate,serviceTime,orderTime,procedureName,orderStatus,serviceDate) VALUES ('17','193 749 290','MCS194109','2017-06-28','12:15:00','19:00:00','Troponin Level','Active','2017-06-28');
INSERT INTO Orders (orderID,doctorSIN,patientMCS,orderDate,serviceTime,orderTime,procedureName,orderStatus,serviceDate) VALUES ('18','397 018 639','MCS194109','2017-04-23','20:00:00','15:00:00','Serum Vitamin D Level','Incomplete','2017-04-23');
INSERT INTO Orders (orderID,doctorSIN,patientMCS,orderDate,serviceTime,orderTime,procedureName,orderStatus,serviceDate) VALUES ('19','742 394 024','MCS194109','2017-01-01','19:30:00','17:30:00','Dermatology Consult','Incomplete','2017-01-01');

INSERT INTO Report (patientMCS,doctorSIN,reportid,examDate,procedureName,reportSubmissionDate,contents,radiologist, reportType) VALUES ('MCS218262','492 628 712','5','2017-04-18 12:30:00',NULL,NULL,'CHIEF COMPLAINT: Chest pain.
HISTORY OF PRESENT ILLNESS: This is a 55-year-old white female referred today for chest pain. She was recently evaluated for a typical chest pain and had exercise stress testing. She exercised for 9 minutes and 26 seconds and the test was clinically negative. She continues to have atypical chest pain complaints. She has no orthopnea, no lower extremity edema, no palpations, or dyspnea on exertion.
PAST MEDICAL HISTORY: Hypothyroidism.
PAST SURGICAL HISTORY: Partial hysterectomy, lumbar laminectomy, and benign bony tumor removed from sinus cavity.
SOCIAL HISTORY: She is married and has a 28-year-old son. She is self-employed. She makes custom draperies.
FAMILY HISTORY: Father is deceased from congestive heart failure and mother is still living at age 86 with history of hypertension and CVA. She has three sisters who are healthy. She smokes cigarettes one-half pack per day for 25 years. She quit 10-15 years ago. She drinks on a social basis, one to two mixed drinks per week. Caffeine intake, two to three diet Rite Cola’s per day. Three to five eight-ounce glasses of water per day. She exercises regularly and walks one to one-and-one-half miles per day, five day a week. She follows a regular diet with no restrictions.
REVIEW OF SYSTEMS: She has lost 16 pounds since January. She is positive for easy bruising. She does experience occasional seasonal allergies symptoms, occasional nocturia, urinary urgency, and hyperkeratosis.
CURRENT MEDICATIONS: Premarin everyday, Synthroid everyday, and oxybutnin p.r.n.
ALLERGIES: SULFA DRUGS CAUSE RASH.
PHYSICAL EXAMINATION: Weight 169 pounds, height 5’8” tall.
VITAL SIGNS: In the right arm blood pressure 140/80 and in the left arm 130/80. She has an applicable respiratory rate at 16.
GENERAL: A 56-year-old white female in no acute distress.
SKIN: Warm and dry.
PHYSICAL EXAM: Unremarkable.
EKG: Normal sinus rhythm.
IMPRESSION:
1. A typical chest pain with negative exercise stress testing on 09/11/02.
2. Reform smoker.
3. Unknown lipid status.
4. Hypertension.
DISCUSSION: At this time, chest pain appears to be caustic chondritis, will treat with Motrin. Check fasting lipids. I will see the patient back in the office in four weeks and reevaluate blood pressure readings at that time, as to whether or not medical therapy will be necessary.',NULL, 'report');
INSERT INTO Report (patientMCS,doctorSIN,reportid,examDate,procedureName,reportSubmissionDate,contents,radiologist, reportType) VALUES ('MCS195878','762 916 654','6','2017-06-09 09:00:00',NULL, NULL,
'CHIEF COMPLAINT: Low back pain, bilateral lower extremity pain of 4-5 weeks duration.

HISTORY OF PRESENT ILLNESS: This is a 70-year-old male with chief complaint of low back pain and bilateral lower extremity pain. The patient denies any recent trauma to the low back. He states that he has been a body builder for the past 30 years and has worked out at the gym on a regular basis. He has entered in one multiple body building contests. He states that approximately 3 years ago, he was a using a machine at the gym doing crunches and felt a pop in his low back. He states that his back has not been the same since then. However, he was able to continue working out until about 4-5 weeks ago when he states he was unable to get out of bed due to bilateral lower extremity burning in his legs. He went to see a chiropractor and had some manipulation, which helped somewhat. He has taken multiple pain medications, NSAID’s and narcotics. At present, he is taking Percocet. He states that this has not helped much at all. He has not been able to return to the gym. The patient also gives a history of taking a growth hormone that was a black market product from China for an entire year, approximately 4-5 years ago. He denies any change in bladder or bowel movements.

ALLERGIES: NO KNOWN DRUG ALLERGIES.

PAST MEDICAL HISTORY: Significant for depression and anxiety.

PAST SURGICAL HISTORY: The patient had a right knee arthroscopy in January of 2002.

SOCIAL HISTORY: The patient denies any alcohol use, denies any smoking history. He is presently retired. Prior to retiring, he worked as a massage therapist. He does this occasionally for friends at the present time. He is married. He lives with his wife. There is no litigation involved in this pain management case.

FAMILY HISTORY: Parents are deceased. Mother died of cancer in 2001. Father died of cardiac disease.

PHYSICAL EXAM: The patient is a 70-year-old well developed, well nourished male in moderate distress secondary to low back pain, as well as bilateral lower extremity pain. His blood pressure is slightly elevated today at 130/90. The patient’s pulse is 70. He is 5’6” tall and weighs 223 lbs HEENT: Normocephalic. Atraumatic. Extraocular muscles are intact. Pupils are equal and reactive to light and accommodation. Neck: Supple without masses or adenopathy. Lungs: Clear to auscultation and percussion bilaterally. No rales, rhonchi or wheezing is appreciated. Heart: Negative S4, positive S1, positive S2, negative S3. No murmurs or ectopy is appreciated. Abdomen: Soft and non-tender to palpation. Bowel sounds are present in all four quadrants. GU: Deferred. Skin: Clear. Pulses: Bilaterally symmetric in the upper and lower extremities. No clubbing, cyanosis or edema is noted in the lower extremities. Sensory Evaluation: No sensory deficits are noted in the upper or lower extremities. Motor strength function: The patient ambulates with a normal gait. Transfers on and off the exam table are fluid. There is no motor weakness noted in the lower extremities. Motor strength testing is bilaterally symmetric and 5/5. The patient has well defined musculature. Reflexes are bilaterally symmetric in the upper and lower extremities.

Focus examination of the lumbar spine reveals the patient ambulating with a normal gait. Transfers on and off the exam table are fluid. There is no abnormal list or posturing. Lumbar lordosis is maintained. The patient has full range of motion of the lumbar spine in all planes. He is able to toe-heel walk without difficulty. Straight leg raise is negative. Motor strength testing of the lower extremities is 5/5 and symmetric. The lower extremities are without muscle atrophy. Skin is warm and dry to touch. Pulses are intact. Deep tendon reflexes are bilaterally symmetric.

DIAGNOSTIC TESTING: The patient had an MRI done on 07/14/08. MRI findings reveal HNP L4-L5 on the right minimally compressing the thecal sac. There is an HNP at L3-L4, again, mildly flattening the thecal sac. There is degenerative disc disease at multiple levels.

CURRENT MEDICATIONS:Celexa 10 mg one daily, Ativan 2 mg one daily, Ambien 12.5 mg one daily, and Percocet 5 mg t.i.d./q.i.d.

DIAGNOSTIC IMPRESSION:
Degenerative disc disease.
Chronic low back pain.
Lumbar radiculopathy.
HNP L3-L4 and L4-L5.
PLAN: The patient is in an acute state of pain secondary to a lumbar radiculopathy. After careful review of his medications and disease status, the patient would most likely benefit from a lumbar epidural steroid injection. He was advised no aspirin products or NSAID’s products 3-5 days prior to his injections. At present, he is taking Percocet for pain. He also understands that the injections may or may not relieve any or all of his pain and the risks include, but are not limited to injection site tenderness, redness, infection, nerve damage or injury, exacerbation of his pain, as well as death. He has been advised to remain NPO 8-10 hours prior to the injections and to have a driver available to transport him to and from the facility. He understands the risks and benefits of the procedure and is willing to undergo a lumbar epidural steroid injection tomorrow. He has been advised of conscious sedation and what that entails. His questions regarding the procedures were answered to his satisfaction.',NULL,'report');
INSERT INTO Report (patientMCS,doctorSIN,reportid,examDate,procedureName,reportSubmissionDate,contents,radiologist, reportType) VALUES ('MCS107400','492 628 712','7','2017-11-12 10:00:00',NULL, NULL,
'HISTORY OF PRESENT ILLNESS: This is a 43-year-old black man with no apparent past medical history who presented to the emergency room with the chief complaint of weakness, malaise and dyspnea on exertion for approximately one month. The patient also reports a 15-pound weight loss. He denies fever, chills, and sweats. He denies cough and diarrhea. He has mild anorexia. Past Medical History: Essentially unremarkable except for chest wall cysts which apparently have been biopsied by a dermatologist in the past, and he was given a benign diagnosis. He had a recent PPD which was negative in August 1994.

MEDICATIONS: Advil and Ibuprofen.

ALLERGIES: NO KNOWN DRUG ALLERGIES.

SOCIAL HISTORY: He occasionally drinks. He is a nonsmoker. The patient participated in homosexual activity in Haiti during 1982, which he described as “very active.” He denies intravenous drug use. The patient is currently employed.

FAMILY HISTORY: Unremarkable.

PHYSICAL EXAMINATION:
General: This is a thin, black cachectic man speaking in full sentences with oxygen.
Vital Signs: Blood pressure 96/56, heart rate 120. No change with orthostatics. Temperature 101.6 degrees Fahrenheit. Respirations 30.
HEENT: Funduscopic examination normal. He has oral thrush.
Lymph: He has marked adenopathy including right bilateral epitrochlear and posterior cervical nodes.
Neck: No goiter, no jugular venous distention.
Chest: Bilateral basilar crackles, and egophony at the right and left middle lung fields.
Heart: Regular rate and rhythm, no murmur, rub or gallop.
Abdomen: Soft and nontender.
Genitourinary: Normal.
Rectal: Unremarkable.
Skin: The patient has multiple, subcutaneous mobile nodules on the chest wall that are nontender. He has very pale palms.

LABORATORY: Sodium 133, potassium 5.3, BUN 29, creatinine 1.8, hemoglobin 14, white count 7100, platelet count 515, total protein 10, albumin 3.1, AST 131, ALT 31, urinalysis shows 1+ protein, trace blood, total bilirubin 2.4, and direct bilirubin 0.1.

X-RAYS: Electrocardiogram shows normal sinus rhythm. Chest x-ray shows bilateral alveolar and interstitial infiltrates.

IMPRESSION:
1. Bilateral pneumonia; suspect atypical pneumonia, rule out Pneumocystis carinii pneumonia and tuberculosis.
2. Thrush.
3. Elevated unconjugated bilirubin.
4. Hepatitis.
5. Elevated globulin fraction.
6. Renal insufficiency.
7. Subcutaneous nodules.
8. Risky sexual behavior in 1982 in Haiti.

PLAN:
1. Induced sputum, rule out Pneumocystis carinii pneumonia and tuberculosis.
2. Begin intravenous Bactrim and erythromycin.
3. Begin prednisone.
4. Oxygen.
5. Nystatin swish and swallow.
6. Dermatologic biopsy of lesions.
7. Check HIV and RPR.
8. Administer Pneumovax, tetanus shot, and Heptavax if indicated.',NULL, 'report');
INSERT INTO Report (patientMCS,doctorSIN,reportid,examDate,procedureName,reportSubmissionDate,contents,radiologist, reportType) VALUES ('MCS194109','762 916 654','8','2017-10-19 15:00:00',NULL, NULL,
'HISTORY OF PRESENT ILLNESS: This is a 43-year-old black man with no apparent past medical history who presented to the emergency room with the chief complaint of weakness, malaise and dyspnea on exertion for approximately one month. The patient also reports a 15-pound weight loss. He denies fever, chills, and sweats. He denies cough and diarrhea. He has mild anorexia. Past Medical History: Essentially unremarkable except for chest wall cysts which apparently have been biopsied by a dermatologist in the past, and he was given a benign diagnosis. He had a recent PPD which was negative in August 1994.

MEDICATIONS: Advil and Ibuprofen.

ALLERGIES: NO KNOWN DRUG ALLERGIES.

SOCIAL HISTORY: He occasionally drinks. He is a nonsmoker. The patient participated in homosexual activity in Haiti during 1982, which he described as “very active.” He denies intravenous drug use. The patient is currently employed.

FAMILY HISTORY: Unremarkable.

PHYSICAL EXAMINATION:
General: This is a thin, black cachectic man speaking in full sentences with oxygen.
Vital Signs: Blood pressure 96/56, heart rate 120. No change with orthostatics. Temperature 101.6 degrees Fahrenheit. Respirations 30.
HEENT: Funduscopic examination normal. He has oral thrush.
Lymph: He has marked adenopathy including right bilateral epitrochlear and posterior cervical nodes.
Neck: No goiter, no jugular venous distention.
Chest: Bilateral basilar crackles, and egophony at the right and left middle lung fields.
Heart: Regular rate and rhythm, no murmur, rub or gallop.
Abdomen: Soft and nontender.
Genitourinary: Normal.
Rectal: Unremarkable.
Skin: The patient has multiple, subcutaneous mobile nodules on the chest wall that are nontender. He has very pale palms.

LABORATORY: Sodium 133, potassium 5.3, BUN 29, creatinine 1.8, hemoglobin 14, white count 7100, platelet count 515, total protein 10, albumin 3.1, AST 131, ALT 31, urinalysis shows 1+ protein, trace blood, total bilirubin 2.4, and direct bilirubin 0.1.

X-RAYS: Electrocardiogram shows normal sinus rhythm. Chest x-ray shows bilateral alveolar and interstitial infiltrates.

IMPRESSION:
1. Bilateral pneumonia; suspect atypical pneumonia, rule out Pneumocystis carinii pneumonia and tuberculosis.
2. Thrush.
3. Elevated unconjugated bilirubin.
4. Hepatitis.
5. Elevated globulin fraction.
6. Renal insufficiency.
7. Subcutaneous nodules.
8. Risky sexual behavior in 1982 in Haiti.

PLAN:
1. Induced sputum, rule out Pneumocystis carinii pneumonia and tuberculosis.
2. Begin intravenous Bactrim and erythromycin.
3. Begin prednisone.
4. Oxygen.
5. Nystatin swish and swallow.
6. Dermatologic biopsy of lesions.
7. Check HIV and RPR.
8. Administer Pneumovax, tetanus shot, and Heptavax if indicated.',NULL, 'report');
INSERT INTO Report (patientMCS,doctorSIN,reportid,examDate,procedureName,reportSubmissionDate,contents,radiologist, reportType) VALUES ('MCS218262','492 628 712','1','2017-07-12','\nCR OF THE LUMBOSACRAL 2 OR 3 VIEWS','2017-07-19 11:30:00',
'CLINICAL HISTORY: Back pain.

COMMENTS:Standard views show no fracture.

Grade 1 anterolisthesis of L4 on L5 is noted. Alignment is otherwise preserved.

Mild levoscoliosis is present, apex at L3.

Moderate to severe multilevel degenerative changes are seen, demostrated by marked
osteophytosis, loss of disk space heights and end-plate sclerosis. L4-L5 level and L5-S1 levels are
most effected.

No evidence of lytic or blastic lesion. The pedicles are intact.

Soft tissue structures are intact.

IMPRESSION:
1. Mild levoscoliosis is present, apex at L3.
2. Moderate to severe multilevel degenerative changes.
3. Grade 1 anterolisthesis of L4 on L5
4. Consider follow up with MRI if clinically warranted.','Dr. Chelsea Betenbaugh', 'imaging');
INSERT INTO Report (patientMCS,doctorSIN,reportid,examDate,procedureName,reportSubmissionDate,contents,radiologist, reportType) VALUES ('MCS195878','762 916 654','2','2017-11-06','CR OF THE LEFT KNEE COMPLETE 4 OR MORE VIEWS','207-11-13 12:30:00',
'CLINICAL HISTORY: Knee pain.

COMMENTS:

Moderate to severe tricompartmental degenerative changes are noted, demonstrated by marked
osteophytosis, endplate sclerosis and significant joint space narrowing, involving the medial
compartment to the greater degree.

Large suprapatellar joint effusion is noted.

There is no fracture or dislocation. There is no chondrocalcinosis. The patella is normal in position
and appearance.

IMPRESSION:
1. No fracture or dislocation.
2. Moderate to severe tricompartmental degenerative changes.
3. Large suprapatellar joint effusion.
4. Consider follow up with MRI.','Dr. Karla Maring', 'imaging');
INSERT INTO Report (patientMCS,doctorSIN,reportid,examDate,procedureName,reportSubmissionDate,contents,radiologist, reportType) VALUES ('MCS107400','492 628 712','3','2017-09-23','CR OF THE CERVICAL SPINE 2 OR 3 VIEWS','2017-09-30 10:00:00',
'CLINICAL HISTORY: Neck pain.

COMMENTS:

AP, lateral and open mouth views show no spondylolisthesis. There is visualization to T1 vertebral
body.

Soft tissue structures are intact.

Mild compression deformities are noted involving vertebral bodies.

There is straightening of normal cervical lordosis is seen, compatible with muscular spasm

Moderate multilevel degenerative changes are noted. This is demonstrated by osteophytosis,
endplate sclerosis and moderate loss of disk space height.

IMPRESSION:
1. Straightening of normal cervical lordosis, compatible with muscular spasm.
2. Mild compression deformities are noted involving several vertebral bodies as above.
3. Moderate to severe multilevel degenerative changes, most prominent at C5-C6.','Dr. Pablo Smeastad', 'imaging');
INSERT INTO Report (patientMCS,doctorSIN,reportid,examDate,procedureName,reportSubmissionDate,contents,radiologist, reportType) VALUES ('MCS194109','762 916 654','4','2017-01-03','CR OF THE CHEST TWO VIEWS','2017-01-10 17:45:00',
'CLINICAL HISTORY: Cough, congestion.

COMMENTS:

PA and lateral views of chest reveals no evidence of active pleural or pulmonary parenchymal
abnormality.

There are diffusely increased interstitial lung markings consistent with chronic bronchitis. Underlying
pulmonary fibrosis is not excluded.

The cardiac silhouette is enlarged. The mediastinum and pulmonary vessels appear normal. Aorta is
tortuous.

Degenerative changes are noted in the thoracic spine.

IMPRESSION:
1. No evidence of acute pulmonary pathology.
2. Enlarged cardiac silhouette.
3. Tortuous aorta.
4. Diffusely increased interstitial lung markings consistent with chronic bronchitis. Underlying
pulmonary fibrosis is not excluded.
5. Consider follow up with Chest CT if clinically warranted.','Dr. Hudson Kilgore', 'imaging');