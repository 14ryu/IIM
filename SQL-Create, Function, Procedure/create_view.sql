CREATE TABLE STUDENT (
	StudentID	  			 INT               Not NULL,
    StudentName				TEXT				Not Null,
    StudentPassword   	 VARCHAR(45)         Not NULL,
    Grade            		INT               Not NULL,
    IncomeQuintile   		INT               Not NULL,
    StudentLoan     		INT                   Not NULL,
    English       	 	 VARCHAR(10),
    Chinese         	 VARCHAR(10),
    ComputerSkills   	 VARCHAR(10),
    Mon         	    VARCHAR(2),
    Tue           		  VARCHAR(2),
    Wed           		  VARCHAR(2),
    Thu            		 VARCHAR(2),
    Fri            	 	VARCHAR(2),
    CONSTRAINT StudentPK            PRIMARY KEY(StudentID));
    /* CONSTRAINT Grade CHECK (70<=Grade)) */
    /* CONSTRAINT IncomeQuntile CHECK ((8<=IncomeQuintile) and (1>=IncomeQuintile)) ); */
    

CREATE TABLE WORKPLACE (
	WorkplaceID		VARCHAR(10)			Not NULL,
    WorkplaceName	VARCHAR(45)			Not NULL,
    SupervisorID	VARCHAR(45)			Not NULL,
    StudentsInNeed	INT 				,
    CONSTRAINT WorkplacePK				PRIMARY KEY(WorkplaceID),
    CONSTRAINT StudentsInNeedRange CHECK ((1<=StudentsInNeed) AND (StudentsInNeed <=3))
    );

CREATE TABLE SUPERVISOR (
	SupervisorID 			VARCHAR(45)			NOT NULL,
	SupervisorPassword		VARCHAR(45)			NOT NULL,
	WorkplaceID				VARCHAR(10)			NOT NULL,
    CONSTRAINT 	SupervisorPK			  PRIMARY KEY(SupervisorID),
	CONSTRAINT 	SupervisorFK			  FOREIGN KEY(WorkplaceID)
						       REFERENCES WORKPLACE(WorkplaceID)
	);

CREATE TABLE RECRUITMENT (
	RecruitmentID			VARCHAR(45)			Not NULL,
	SupervisorID			VARCHAR(45)			Not Null,
    WorkplaceID				VARCHAR(10)			NOT NULL,
    Deadline				DATETIME			NOT NULL,
	English 				VARCHAR(10),
    Chinese					VARCHAR(10),
    ComputerSkills			VARCHAR(10),
    Mon						VARCHAR(2),
    Tue						VARCHAR(2),
    Wed						VARCHAR(2),
    Thu						VARCHAR(2),
    Fri						VARCHAR(2),
    CONSTRAINT RecruitmentPK			primary key(RecruitmentID),
    constraint RecruitmentFK1			Foreign key(SupervisorID) references SUPERVISOR(supervisorID),
    constraint RecruitmentFK2			foreign key(WorkplaceID) references WORKPLACE(WorkplaceID)    
);

CREATE TABLE APPLICATION (
	StudentID            	INT               Not NULL,
	RecruitmentID        VARCHAR(45) 		  Not Null,
    CONSTRAINT APPLICATIONPK1         primary key(StudentID,RecruitmentID),
    constraint APPLICATIONFK0         Foreign key(StudentID) references STUDENT(StudentID),
    constraint APPLICATIONFK1         Foreign key(RecruitmentID) references RECRUITMENT(RecruitmentID)
);
   
CREATE TABLE FINAL_ASSIGNMENT (
StudentID        INT        		  NOT NULL,
RecruitmentID    VARCHAR(45)          NOT NULL,
SupervisorID     VARCHAR(45)          NOT NULL,
CONSTRAINT    FINAL_ASSIGNMENTPK1            PRIMARY KEY(StudentID,RecruitmentID,SupervisorID),
CONSTRAINT    FINAL_ASSIGNMENTFK1            FOREIGN KEY(StudentID)
											REFERENCES STUDENT(StudentID),
CONSTRAINT    FINAL_ASSIGNMENTFK2               FOREIGN KEY(SupervisorID)
											REFERENCES Supervisor(SupervisorID),
CONSTRAINT    FINAL_ASSIGNMENTFK3               FOREIGN KEY(RecruitmentID)
											REFERENCES RECRUITMENT(RecruitmentID)
);

/*관리자 : 내 지원 공고 보기*/
CREATE VIEW RecruimentView2 AS
	  SELECT  	RECRUITMENT.RecruitmentID AS 공고번호,
				WORKPLACE.WorkplaceID AS 근무지,
                RECRUITMENT.Deadline AS 마감기한,
                RECRUITMENT.English AS 영어능력,
                RECRUITMENT.Chinese AS 중국어능력,
                RECRUITMENT.ComputerSkills AS 컴퓨터활용능력,
                RECRUITMENT.Mon AS 월,
                RECRUITMENT.Tue AS 화,
                RECRUITMENT.Wed AS 수,
                RECRUITMENT.Thu AS 목,
                RECRUITMENT.Fri AS 금
	  FROM	    RECRUITMENT JOIN SUPERVISOR ON RECRUITMENT.SupervisorID = SUPERVISOR.SupervisorID, WORKPLACE
      WHERE		SUPERVISOR.SupervisorID = 'A1_061';

/*관리자 : 내가 낸 공고의 지원 학생 보기*/
CREATE VIEW RecruimentStudentView AS
	  SELECT  	APPLICATION.RecruitmentID AS 공고번호,
				STUDENT.StudentID AS 학생번호,
                STUDENT.English AS 영어능력,
                STUDENT.Chinese AS 중국어능력,
                STUDENT.ComputerSkills AS 컴퓨터활용능력,
                STUDENT.Grade AS 성적,
                STUDENT.IncomeQuintile AS 소득분위,
                STUDENT.StudentLoan AS 학자금대출횟수
	  FROM	    STUDENT JOIN APPLICATION ON STUDENT.StudentID = APPLICATION.StudentID
      JOIN RECRUITMENT ON APPLICATION.recruitmentID = RECRUITMENT.recruitmentID ;

/*학생 : 내가 지원한 공고 보기*/      
CREATE VIEW MyApplicationList AS
	SELECT A.RecruitmentID
    FROM APPLICATION AS A JOIN RECRUITMENT AS R ON R.RecruitmentID = A.RecruitmentID;

/* INSERT INTO APPLICATION(StudentID,RecruitmentID)
VALUES (2013146722, 'BIZ_01_200106'); */

/*학생 : 지금 지원 가능한 공고 보기*/
CREATE VIEW RecruimentOutNowView AS
	  SELECT  	RECRUITMENT.RecruitmentID AS 공고번호,
				WORKPLACE.WorkplaceID AS 근무지,
                RECRUITMENT.Deadline AS 마감기한,
                RECRUITMENT.English AS 영어능력,
                RECRUITMENT.Chinese AS 중국어능력,
                RECRUITMENT.ComputerSkills AS 컴퓨터활용능력,
                RECRUITMENT.Mon AS 월,
                RECRUITMENT.Tue AS 화,
                RECRUITMENT.Wed AS 수,
                RECRUITMENT.Thu AS 목,
                RECRUITMENT.Fri AS 금
	  FROM	    RECRUITMENT JOIN SUPERVISOR ON RECRUITMENT.SupervisorID = SUPERVISOR.SupervisorID, WORKPLACE
      WHERE SYSDATE() < RECRUITMENT.Deadline;
      
 /*     
SHOW FULL TABLES IN madang
WHERE TABLE_TYPE LIKE 'VIEW';      
      
    
DROP TABLE student;
DROP TABLE supervisor;
DROP TABLE workplace;
DROP TABLE application;
DROP TABLE recruitment;
DROP TABLE final_assignment;
*/