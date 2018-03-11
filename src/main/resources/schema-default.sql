-- This is where the ddl will go


DROP SEQUENCE hibernate_sequence IF EXISTS;

CREATE SEQUENCE hibernate_sequence START WITH 1 INCREMENT BY 1; 
CREATE TABLE TITLES (
    TITLE_ID       BIGINT GENERATED BY DEFAULT AS IDENTITY,
    TITLE          VARCHAR(32)   NOT NULL,
    PRIMARY KEY (TITLE_ID)
);


CREATE TABLE PERSONS (
    PERSON_ID       BIGINT GENERATED BY DEFAULT AS IDENTITY,
    TITLE_ID        BIGINT,
    FIRST_NAME      VARCHAR(512)  NOT NULL,
    MIDDLE_INITIAL  VARCHAR(512),
    LAST_NAME       VARCHAR(512)  NOT NULL,
    GENDER          VARCHAR(8)    NOT NULL,
    SSN             VARCHAR(32)   NOT NULL,
    HOME_PHONE      VARCHAR(64),
    MOBILE_PHONE    VARCHAR(64),
    EMAIL           VARCHAR(512),
    
    ADDRESS         VARCHAR(512),
    CITY            VARCHAR(512),
    COUNTY          VARCHAR(512),
    STATE           VARCHAR(512),
    POSTAL_CODE     VARCHAR(32),
    
    DATE_OF_BIRTH   TIMESTAMP,
    
    PRIMARY KEY (PERSON_ID)
);

ALTER TABLE PERSONS 
    ADD CONSTRAINT UK_PERSON_SSN UNIQUE (SSN);
ALTER TABLE PERSONS
    ADD CONSTRAINT FK_PERSONS_TITLE_ID 
    FOREIGN KEY (TITLE_ID)
    REFERENCES TITLES (TITLE_ID);

CREATE TABLE PERSONNEL_TYPE (
    PERSONNEL_TYPE_ID       BIGINT GENERATED BY DEFAULT AS IDENTITY,
    TYPE_NAME               VARCHAR(64)   NOT NULL,
    PRIMARY KEY (PERSONNEL_TYPE_ID)
);

CREATE TABLE PERSONNEL (
	PERSONNEL_ID        BIGINT NOT NULL,
	PERSON_ID           BIGINT NOT NULL,
	PERSONNEL_TYPE_ID   BIGINT NOT NULL,
	ANNUAL_SALARY       INTEGER,
	EMPLOYMENT_NUMBER   VARCHAR(128) NOT NULL,
	PRIMARY KEY (PERSONNEL_ID)
);

ALTER TABLE PERSONNEL
ADD CONSTRAINT UK_PERSONNEL_EMP_NO UNIQUE (EMPLOYMENT_NUMBER);

ALTER TABLE PERSONNEL
    ADD CONSTRAINT FK_PERSONNEL_PERSON_ID 
    FOREIGN KEY (PERSON_ID)
    REFERENCES PERSONS (PERSON_ID);


CREATE TABLE NURSES (
	PERSONNEL_ID        BIGINT NOT NULL,
	SURGERY_TYPE_ID     BIGINT,
	GRADE               VARCHAR(64),
	YEARS_OF_EXPERIENCE INTEGER,
	PRIMARY KEY (PERSONNEL_ID)
);

CREATE TABLE SURGERY_TYPES (
	SURGERY_TYPE_ID           BIGINT NOT NULL,
	TYPE_NAME                 VARCHAR(64)   NOT NULL,
	SURGERY_CODE              VARCHAR(64)   NOT NULL,
	LOCATION_ID               BIGINT,
	SPECIAL_NEEDS             VARCHAR(1024),
	CATEGORY                  VARCHAR(64),
	PRIMARY KEY (SURGERY_TYPE_ID)
);

ALTER TABLE SURGERY_TYPES
ADD CONSTRAINT UK_SURGERY_TYPES_SURGERY_CODE UNIQUE (SURGERY_CODE);


CREATE TABLE SURGERY_SKILLS (
	SURGERY_SKILL_ID         BIGINT NOT NULL,
	SKILL_NAME               VARCHAR(64)   NOT NULL,
	SKILL_CODE               VARCHAR(64)   NOT NULL,
	PRIMARY KEY (SURGERY_SKILL_ID)
);

ALTER TABLE SURGERY_SKILLS
ADD CONSTRAINT UK_SURGERY_SKILLS_SKILL_CODE UNIQUE (SKILL_CODE);

ALTER TABLE NURSES
    ADD CONSTRAINT FK_PERSONNEL_ID 
    FOREIGN KEY (PERSONNEL_ID)
    REFERENCES PERSONNEL (PERSONNEL_ID);

ALTER TABLE NURSES
    ADD CONSTRAINT FK_SURGERY_TYPE_ID 
    FOREIGN KEY (SURGERY_TYPE_ID)
    REFERENCES SURGERY_TYPES (SURGERY_TYPE_ID);

CREATE TABLE NURSES_TO_SKILLS (
	PERSONNEL_ID             BIGINT NOT NULL,
	SURGERY_SKILL_ID         BIGINT NOT NULL,
	PRIMARY KEY (PERSONNEL_ID, SURGERY_SKILL_ID)
);

ALTER TABLE NURSES_TO_SKILLS
    ADD CONSTRAINT FK_NURSES_TO_SKILLS_PERSONNEL_ID 
    FOREIGN KEY (PERSONNEL_ID)
    REFERENCES NURSES (PERSONNEL_ID);

ALTER TABLE NURSES_TO_SKILLS
    ADD CONSTRAINT FK_NURSES_TO_SKILLS_SKILL_ID 
    FOREIGN KEY (SURGERY_SKILL_ID)
    REFERENCES SURGERY_SKILLS (SURGERY_SKILL_ID);

CREATE TABLE SURGERY_TYPES_TO_SKILLS (
	SURGERY_TYPE_ID            BIGINT NOT NULL,
	SURGERY_SKILL_ID           BIGINT NOT NULL,
	PRIMARY KEY (SURGERY_TYPE_ID, SURGERY_SKILL_ID)
);

ALTER TABLE SURGERY_TYPES_TO_SKILLS
    ADD CONSTRAINT FK_SURGERY_TYPES_TO_SKILLS_SURGERY_TYPE_ID
    FOREIGN KEY (SURGERY_TYPE_ID)
    REFERENCES SURGERY_TYPES (SURGERY_TYPE_ID);

ALTER TABLE SURGERY_TYPES_TO_SKILLS
    ADD CONSTRAINT FK_SURGERY_TYPES_TO_SKILLS_SKILL_ID 
    FOREIGN KEY (SURGERY_SKILL_ID)
    REFERENCES SURGERY_SKILLS (SURGERY_SKILL_ID);

CREATE TABLE PHYSICIANS (
	PERSONNEL_ID          BIGINT NOT NULL,
	SPECIALTY_ID          BIGINT,
	OWNERSHIP_PERCENTAGE  NUMERIC(5,2),
	PRIMARY KEY (PERSONNEL_ID)
);

ALTER TABLE PHYSICIANS
    ADD CONSTRAINT FK_PHYSICIANS_PERSONNEL_ID 
    FOREIGN KEY (PERSONNEL_ID)
    REFERENCES PERSONNEL (PERSONNEL_ID);
    
CREATE TABLE PATIENTS (
    PATIENT_ID            BIGINT   NOT NULL,
	PERSON_ID             BIGINT   NOT NULL,
	PRIMARY_PHYSICIAN_ID  BIGINT,
	PATIENT_NUMBER        VARCHAR(64)  NOT NULL,
	PRIMARY KEY (PATIENT_ID)
);

ALTER TABLE PATIENTS 
    ADD CONSTRAINT UK_PATIENTS_NUMBER UNIQUE (PATIENT_NUMBER);

ALTER TABLE PATIENTS
    ADD CONSTRAINT FK_PATIENTS_PERSON_ID
    FOREIGN KEY (PERSON_ID)
    REFERENCES PERSONS (PERSON_ID);

    
ALTER TABLE PATIENTS
    ADD CONSTRAINT FK_PRIMARY_PHYSICIAN_ID
    FOREIGN KEY (PRIMARY_PHYSICIAN_ID)
    REFERENCES PHYSICIANS (PERSONNEL_ID);


CREATE TABLE ILLNESSES (
	ILLNESS_ID           BIGINT        NOT NULL,
	ILLNESS_NAME         VARCHAR(256)  NOT NULL,
	PRIMARY KEY (ILLNESS_ID)
);

CREATE TABLE PATIENTS_TO_ILLNESSES (
	PATIENT_ID           BIGINT NOT NULL,
	ILLNESS_ID           BIGINT NOT NULL,
	PRIMARY KEY (PATIENT_ID, ILLNESS_ID)
);

ALTER TABLE PATIENTS_TO_ILLNESSES
    ADD CONSTRAINT FK_PATIENTS_TO_ILLNESSES_PATIENT_ID
    FOREIGN KEY (PATIENT_ID)
    REFERENCES PATIENTS (PATIENT_ID);

ALTER TABLE PATIENTS_TO_ILLNESSES
    ADD CONSTRAINT FK_PATIENTS_TO_ILLNESSES_ILLNESS_ID 
    FOREIGN KEY (ILLNESS_ID)
    REFERENCES ILLNESSES (ILLNESS_ID);
 
CREATE TABLE PRESCRIPTIONS (
	PRESCRIPTION_ID    BIGINT    NOT NULL,
	PATIENT_ID         BIGINT,
	MEDICATION_ID      BIGINT,
	PHYSICIAN_ID       BIGINT,
	DOSAGE             VARCHAR(256),
	FREQUENCY          VARCHAR(256),
	PRIMARY KEY (PRESCRIPTION_ID)
);

CREATE TABLE MEDICATIONS (
	MEDICATION_ID        BIGINT    NOT NULL,
	MEDICATION_NAME      VARCHAR(256),
	MEDICATION_CODE      VARCHAR(64)   NOT NULL,
	PRIMARY KEY (MEDICATION_ID)
);

ALTER TABLE PRESCRIPTIONS
    ADD CONSTRAINT FK_PRESCRIPTIONS_PATIENT_ID 
    FOREIGN KEY (PATIENT_ID)
    REFERENCES PATIENTS (PATIENT_ID);

ALTER TABLE PRESCRIPTIONS
    ADD CONSTRAINT FK_PRESCRIPTIONS_MEDICATION_ID 
    FOREIGN KEY (MEDICATION_ID)
    REFERENCES MEDICATIONS (MEDICATION_ID);
    
ALTER TABLE PRESCRIPTIONS
    ADD CONSTRAINT FK_PRESCRIPTIONS_PHYSICIAN_ID 
    FOREIGN KEY (PHYSICIAN_ID)
    REFERENCES PHYSICIANS (PERSONNEL_ID);
    
CREATE TABLE INTERACTIONS (
	INTERACTION_ID      BIGINT        NOT NULL,
	SEVERITY            VARCHAR(1)    NOT NULL,
	PRIMARY KEY (INTERACTION_ID)
);

CREATE TABLE INTERACTIONS_TO_MEDICATIONS (
	INTERACTION_ID      BIGINT        NOT NULL,
	MEDICATION_ID       BIGINT        NOT NULL,
	PRIMARY KEY (INTERACTION_ID, MEDICATION_ID)
);

ALTER TABLE INTERACTIONS_TO_MEDICATIONS
    ADD CONSTRAINT FK_INTERACTIONS_TO_MEDICATIONS_INTERACTION_ID 
    FOREIGN KEY (INTERACTION_ID)
    REFERENCES INTERACTIONS (INTERACTION_ID);

ALTER TABLE INTERACTIONS_TO_MEDICATIONS
    ADD CONSTRAINT FK_INTERACTIONS_TO_MEDICATIONS_MEDICATION_ID 
    FOREIGN KEY (MEDICATION_ID)
    REFERENCES MEDICATIONS (MEDICATION_ID);

CREATE TABLE SPECIALITIES (
	SPECIALTY_ID      BIGINT    NOT NULL,
	SPECIALTY_NAME    VARCHAR(256),
	PRIMARY KEY (SPECIALTY_ID)
);

CREATE TABLE SURGEONS (
	PERSONNEL_ID        BIGINT NOT NULL,
	SPECIALTY_ID        BIGINT,
	CONTRACT_TYPE       VARCHAR(64),
	CONTRACT_LENGTH     INTEGER,
	PRIMARY KEY (PERSONNEL_ID)
);

ALTER TABLE SURGEONS
    ADD CONSTRAINT FK_SURGEONS_PERSONNEL_ID 
    FOREIGN KEY (PERSONNEL_ID)
    REFERENCES PERSONNEL (PERSONNEL_ID);

ALTER TABLE SURGEONS
    ADD CONSTRAINT FK_SURGEONS_SPECIALTY_ID 
    FOREIGN KEY (SPECIALTY_ID)
    REFERENCES SPECIALITIES (SPECIALTY_ID);

ALTER TABLE PHYSICIANS
    ADD CONSTRAINT FK_PHYSICIANS_SPECIALTY_ID 
    FOREIGN KEY (SPECIALTY_ID)
    REFERENCES SPECIALITIES (SPECIALTY_ID);
  
CREATE TABLE ANATOMICAL_LOCATIONS (
	LOCATION_ID      BIGINT    NOT NULL,
	LOCATION_NAME    VARCHAR(256),
	PRIMARY KEY (LOCATION_ID)
);

ALTER TABLE SURGERY_TYPES
    ADD CONSTRAINT FK_SURGERY_TYPE_LOCATION_ID 
    FOREIGN KEY (LOCATION_ID)
    REFERENCES ANATOMICAL_LOCATIONS (LOCATION_ID);

CREATE TABLE MEDICAL_PROFILES (
	PATIENT_ID            BIGINT    NOT NULL,
	BLOOD_TYPE            VARCHAR(16),
	LDL_BAD_CHOLESTEROL   INTEGER,
	HDL_GOOD_CHOLESTEROL  INTEGER,
	TRIGLYCERIDES         INTEGER,
	BLOOD_SUGAR           INTEGER,
	PRIMARY KEY (PATIENT_ID)
);

ALTER TABLE MEDICAL_PROFILES
    ADD CONSTRAINT FK_MEDICAL_PROFILES_PATIENT_ID 
    FOREIGN KEY (PATIENT_ID)
    REFERENCES PATIENTS (PATIENT_ID);

CREATE TABLE ALLERGIES (
	ALLERGY_ID           BIGINT    NOT NULL,
	ALLERGY_NAME         VARCHAR(128)   NOT NULL,
	ALLERGY_CODE         VARCHAR(64)   NOT NULL,
	PRIMARY KEY (ALLERGY_ID)
);

ALTER TABLE ALLERGIES 
    ADD CONSTRAINT UK_ALLERGIES_ALLERGY_CODE UNIQUE (ALLERGY_CODE);
    
CREATE TABLE MEDICAL_PROFILES_TO_ALLERGIES (
	PATIENT_ID               BIGINT NOT NULL,
	ALLERGY_ID               BIGINT NOT NULL,
	PRIMARY KEY (PATIENT_ID, ALLERGY_ID)
);

ALTER TABLE MEDICAL_PROFILES_TO_ALLERGIES
    ADD CONSTRAINT FK_MEDICAL_PROFILES_TO_ALLERGIES_PATIENT_ID 
    FOREIGN KEY (PATIENT_ID)
    REFERENCES MEDICAL_PROFILES (PATIENT_ID);

ALTER TABLE MEDICAL_PROFILES_TO_ALLERGIES
    ADD CONSTRAINT FK_MEDICAL_PROFILES_TO_ALLERGIES_ALLERGY_ID 
    FOREIGN KEY (ALLERGY_ID)
    REFERENCES ALLERGIES (ALLERGY_ID);

CREATE TABLE MEDICATION_INVENTORIES (
	MEDICATION_ID             BIGINT    NOT NULL,
	QUANTITY_ON_HAND          INTEGER,
	QUANTIFY_ON_ORDER         INTEGER,
	UNIT_COST                 NUMERIC(10,2),
	USAGE_YEAR_TO_DATE        BIGINT,
	PRIMARY KEY (MEDICATION_ID)
);

ALTER TABLE MEDICATION_INVENTORIES
    ADD CONSTRAINT FK_MEDICATION_INVENTORIES_MEDICATION_ID 
    FOREIGN KEY (MEDICATION_ID)
    REFERENCES MEDICATIONS (MEDICATION_ID);

CREATE TABLE SURGERIES (
	SURGERY_ID           BIGINT    NOT NULL,
	SURGEON_ID           BIGINT,
	PATIENT_ID           BIGINT,
	NURSE_ID             BIGINT,
	SURGERY_TYPE_ID      BIGINT,
	SCHEDULE             TIMESTAMP,
	PRIMARY KEY (SURGERY_ID)
);

ALTER TABLE SURGERIES
    ADD CONSTRAINT FK_SURGERIES_SURGEON_ID 
    FOREIGN KEY (SURGEON_ID)
    REFERENCES SURGEONS (PERSONNEL_ID);

ALTER TABLE SURGERIES
    ADD CONSTRAINT FK_SURGERIES_PATIENT_ID 
    FOREIGN KEY (PATIENT_ID)
    REFERENCES PATIENTS (PATIENT_ID);

ALTER TABLE SURGERIES
    ADD CONSTRAINT FK_SURGERIES_NURSE_ID 
    FOREIGN KEY (NURSE_ID)
    REFERENCES NURSES (PERSONNEL_ID);

ALTER TABLE SURGERIES
    ADD CONSTRAINT FK_SURGERIES_SURGERY_TYPE_ID 
    FOREIGN KEY (SURGERY_TYPE_ID)
    REFERENCES SURGERY_TYPES (SURGERY_TYPE_ID);
    

CREATE TABLE INPATIENTS (
	PATIENT_ID            BIGINT    NOT NULL,
	NURSE_ID              BIGINT,
	ADMISSION_DATE        TIMESTAMP,
	NURSING_UNIT          INTEGER,
	ROOM_NUMBER           VARCHAR(64),
	WING                  VARCHAR(64),
	BED_NUMBER            VARCHAR(8),
	PRIMARY KEY (PATIENT_ID)
);

ALTER TABLE INPATIENTS
    ADD CONSTRAINT FK_INPATIENTS_PATIENT_ID 
    FOREIGN KEY (PATIENT_ID)
    REFERENCES PATIENTS (PATIENT_ID);

ALTER TABLE INPATIENTS
    ADD CONSTRAINT FK_INPATIENTS_NURSE_ID 
    FOREIGN KEY (NURSE_ID)
    REFERENCES NURSES (PERSONNEL_ID);
