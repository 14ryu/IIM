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
    
CREATE TABLE ACCOUNT (
   SupervisorID           VARCHAR(45)         NOT NULL,
   SupervisorPassword     VARCHAR(45)         NOT NULL,
   StudentID              INT                 NOT NULL,
   StudentPassword        VARCHAR(10)         NOT NULL,
   CONSTRAINT    ACCOUNTPK1               PRIMARY KEY(StudentID),
   CONSTRAINT    ACCOUNTFK1               FOREIGN KEY(StudentID)
											REFERENCES STUDENT(StudentID),
   CONSTRAINT    ACCOUNTPK2               PRIMARY KEY(SupervisorID),
   CONSTRAINT    ACCOUNTFK2               FOREIGN KEY(SupervisorID)
											REFERENCES Supervisor(SupervisorID)
   );
   
CREATE TABLE FINAL_ASSIGNMENT (
StudentID        INT        		  NOT NULL,
RecruitmentID    VARCHAR(45)          NOT NULL,
SupervisorID     VARCHAR(45)          NOT NULL,
CONSTRAINT    FINAL_ASSIGNMENTPK1            PRIMARY KEY(StudentID),
CONSTRAINT    FINAL_ASSIGNMENTFK1            FOREIGN KEY(StudentID)
											REFERENCES STUDENT(StudentID),
CONSTRAINT    FINAL_ASSIGNMENTPK2               PRIMARY KEY(SupervisorID),
CONSTRAINT    FINAL_ASSIGNMENTFK2               FOREIGN KEY(SupervisorID)
											REFERENCES Supervisor(SupervisorID),
CONSTRAINT    FINAL_ASSIGNMENTPK3               PRIMARY KEY(RecruitmentID),
CONSTRAINT    FINAL_ASSIGNMENTFK3               FOREIGN KEY(RecruitmentID)
											REFERENCES RECURUITMENT(RecruitmentID)
);

CREATE TABLE RECRUITMENT (
	RecruitmentID			INT					Not NULL AUTO_INCREMENT,
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

CREATE TABLE STUDENT (
	StudentID	  			 INT               Not NULL,
    StudentPassword   	 VARCHAR(45)         Not NULL,
    Grade            		INT               Not NULL,
    StudentID       		INT               Not NULL,
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
    CONSTRAINT StudentPK            PRIMARY KEY(StudentID),
    CONSTRAINT Grade CHECK (70<=Grade),
    CONSTRAINT IncomeQuntile CHECK ((8<=IncomeQuntile) and (1>=IncomeQuntile))
    );

CREATE TABLE APPLICATION (
	StudentID             INT                 Not NULL,
	RecruitmentID         VARCHAR(45)         Not Null,
	Grade            		INT               Not NULL,
    StudentID       		INT               Not NULL,
    IncomeQuintile   		INT               Not NULL,
    StudentLoan     		INT               Not NULL,
    English       	 	 VARCHAR(10),
    Chinese         	 VARCHAR(10),
    ComputerSkills   	 VARCHAR(10),
    Mon         	    VARCHAR(2),
    Tue           		  VARCHAR(2),
    Wed           		  VARCHAR(2),
    Thu            		 VARCHAR(2),
    Fri            	 	VARCHAR(2),   
    CONSTRAINT APPLICATIONPK1         primary key(StudentID),
    CONSTRAINT APPLICATIONPK2         primary key(RecruitmentID),
    constraint APPLICATIONFK1         Foreign key(StudentID) references STUDENT(StudentID),
    constraint APPLICATIONFK2         Foreign key(RecruitmentID) references RECRUITMENT(RecruitmentID),
    constraint APPLICATIONFK2         Foreign key(Grade) references Student(Grade),
    constraint APPLICATIONFK3         Foreign key(IncomeQuintile) references STUDENT(IncomQuintile),
    constraint APPLICATIONFK4         Foreign key(StudentLoan) references STUDENT(StudentLoan),
    constraint APPLICATIONFK5         Foreign key(English) references STUDENT(English),
    constraint APPLICATIONFK6         Foreign key(Chinese) references STUDENT(Chinese),
    constraint APPLICATIONFK7         Foreign key(ComputerSkills) references STUDENT(ComputerSkills),
    constraint APPLICATIONFK8         Foreign key(Mon) references STUDENT(Mon),
    constraint APPLICATIONFK9         Foreign key(Tue) references STUDENT(Tue),
    constraint APPLICATIONFK10        Foreign key(Wed) references STUDENT(Wed),
    constraint APPLICATIONFK11        Foreign key(Thu) references STUDENT(Thu),
    constraint APPLICATIONFK12        Foreign key(Fri) references STUDENT(Fri)
);

CREATE VIEW RecruimentView AS
	  SELECT  	R.RecruitmentID AS 공고번호,
				W.WorkplaceID AS 근무지,
                R.Deadline AS 마감기한,
                R.English AS 영어능력,
                R.Chinese AS 중국어능력,
                R.ComputerSkills AS 컴퓨터활용능력,
                R.Mon AS 월,
                R.Tue AS 화,
                R.Wed AS 수,
                R.Thu AS 목,
                R.Fri AS 금
	  FROM	    RECRUITMENT AS R JOIN SUPERVISOR AS S ON R.SuperviorID = S.SupervisorID, WORKPLACE AS W;

CREATE VIEW RecruimentStudentView AS
	  SELECT  	R.RecruitmentID AS 공고번호,
				R.Deadline AS 마감기한,
                W.WorkplaceName AS 근무지명,
				S.StudentID AS 학생번호,
				S.StudentName AS 학생이름,
                S.English AS 영어능력,
                S.Chinese AS 중국어능력,
                S.ComputerSkills AS 컴퓨터활용능력,
                S.Grade AS 성적,
                S.IncomeQuitntile AS 소득분위,
                S.StudentLoan AS 학자금대출횟수,
				R.Mon AS 월,
                R.Tue AS 화,
                R.Wed AS 수,
                R.Thu AS 목,
                R.Fri AS 금
	  FROM	    STUDENT AS S JOIN Recruitment AS R
			ON	S.studentID = R.studentID, WORKPLACE AS W;
            
CREATE VIEW MyApplicationList AS
	SELECT A.RecruitmentID
    FROM APPLICATION AS A JOIN RECRUITMENT AS R ON R.RecruitmentID = A.RecruitmentID;
    
INSERT INTO APPLICATION(STUDENT_StudentID, RECRUITMENT_RecruitmentID)
VALUES (2013146722, BIZ_01_200106);

CREATE VIEW RecruimentOutNowView AS
	  SELECT  	R.RecruitmentID AS 공고번호,
				W.WorkplaceID AS 근무지,
                R.Deadline AS 마감기한,
                R.English AS 영어능력,
                R.Chinese AS 중국어능력,
                R.ComputerSkills AS 컴퓨터활용능력,
                R.Mon AS 월,
                R.Tue AS 화,
                R.Wed AS 수,
                R.Thu AS 목,
                R.Fri AS 금
	  FROM	    RECRUITMENT AS R JOIN SUPERVISOR AS S ON R.SuperviorID = S.SupervisorID, WORKPLACE AS W
      WHERE SYSDATE() < R.Deadline;
    

