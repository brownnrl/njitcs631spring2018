-- This is where the ddl will go

DROP TABLE TITLES IF EXISTS;
DROP TABLE PERSONS IF EXISTS;


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
    GENDER          VARCHAR(2)    NOT NULL,
    
    SSN             VARCHAR(32)   NOT NULL,
    HOME_PHONE      VARCHAR(64),
    MOBILE_PHONE    VARCHAR(64),
    EMAIL           VARCHAR(512),
    
    
    ADDRESS         VARCHAR(512),
    CITY            VARCHAR(512),
    COUNTY          VARCHAR(512),
    STATE           VARCHAR(512),
    POSTAL_CODE     VARCHAR(32),
    
    PRIMARY KEY (PERSON_ID)
);

ALTER TABLE PERSONS 
    ADD CONSTRAINT UK_PERSON_SSN UNIQUE (SSN);
ALTER TABLE PERSONS
    ADD CONSTRAINT FK_PERSONS_TITLE_ID 
    FOREIGN KEY (TITLE_ID)
    REFERENCES TITLES (TITLE_ID);
