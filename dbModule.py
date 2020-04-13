import pymysql

class Database():
    def __init__(self):
        self.db= pymysql.connect(host='localhost', port= 3306,
                            user='root',
                            password='1234',
                            db='test2', # db를 프로젝트용으로 바꿔야함
                            charset='utf8')
        self.cursor= self.db.cursor(pymysql.cursors.DictCursor)

    def logcheck(self,id,password):
        sql = "SELECT StudentName FROM STUDENT WHERE StudentID=%s AND StudentPassword = %s"
        result = self.cursor.execute(sql,(id,password))
        name = self.cursor.fetchone()
        if result ==0:
            return False 
        else :
            return True,name

    def getdata (self):
        sql= """SELECT Deadline, WORKPLACE.WorkplaceName, English, Chinese, ComputerSkills, Mon, Tue, Wed, Thu, Fri, RecruitmentID
                FROM RECRUITMENT, WORKPLACE
                WHERE Workplace.WorkplaceID = RECRUITMENT.WorkplaceID
                AND Deadline > NOW()""" # 이미 신청한 공고입니다. 나오게 할 것
        num=self.cursor.execute(sql)
        data = self.cursor.fetchall()
        return num, data

    def getmylist(self, StudentID):
        sql ="""SELECT Deadline, WORKPLACE.WorkplaceName, Mon, Tue, Wed, Thu, Fri, Hired
                FROM RECRUITMENT, APPLICATION, WORKPLACE
                WHERE Workplace.WorkplaceID = RECRUITMENT.WorkplaceID AND RECRUITMENT.RecruitmentID = APPLICATION.RecruitmentID
                AND APPLICATION.StudentID = %s"""
        num=self.cursor.execute(sql, (StudentID))
        data = self.cursor.fetchall()
        return num, data

    def add_application(self,StudentID,RecruitmentID):
        sql= """INSERT INTO APPLICATION(StudentID, RecruitmentID)
                VALUES(%s,%s)"""
        result = self.cursor.execute(sql,(StudentID,RecruitmentID))
        self.db.commit()

    #--------------------for Supervisors-------------------------------#

    def logcheck_s(self,id,password):
        sql = """SELECT WorkplaceName FROM WORKPLACE WHERE SupervisorID IN(SELECT SupervisorID FROM SUPERVISOR WHERE SupervisorID=%s AND SupervisorPassword = %s)"""
        result = self.cursor.execute(sql,(id,password))
        name = self.cursor.fetchone()
        if result ==0:
            return False 
        else :
            return True,name

    def getmyrec (self, SupervisorID):
        sql= """SELECT Deadline, WORKPLACE.WorkplaceName, English, Chinese, ComputerSkills, Mon, Tue, Wed, Thu, Fri, RecruitmentID
                FROM RECRUITMENT, WORKPLACE
                WHERE Workplace.WorkplaceID = RECRUITMENT.WorkplaceID
                AND Workplace.SupervisorID = %s""" # 이미 신청한 공고입니다. 나오게 할 것
        num=self.cursor.execute(sql,(SupervisorID))
        data = self.cursor.fetchall()
        return num, data


    def getmystudent(self, RecruitmentID):
        sql = """SELECT Student.StudentID, StudentName, Netscore(English, Chinese, Computerskills) AS Score
                FROM STUDENT, APPLICATION
                WHERE STUDENT.StudentID = APPLICATION.StudentID
                AND APPLICATION.RecruitmentID = %s
                ORDER BY Score Desc"""
        num=self.cursor.execute(sql,(RecruitmentID))
        data = self.cursor.fetchall()
        return num, data

    def final_selection(self,StudentID,RecruitmentID,SupervisorID):
        sql= """INSERT INTO FINAL_ASSIGNMENT(StudentID, RecruitmentID, SupervisorID)
                VALUES(%s,%s,%s)"""
        result = self.cursor.execute(sql,(StudentID,RecruitmentID,SupervisorID))
        self.db.commit()

    def result_update(self):
        sql = """UPDATE application SET hired='선발' where exists(
                SELECT * FROM Final_ASSIGNMENT WHERE FINAL_ASSIGNMENT.StudentID=APPLICATION.StudentID AND FINAL_ASSIGNMENT.RecruitmentID=APPLICATION.RecruitmentID)"""
        result = self.cursor.execute(sql)
        self.db.commit()

        
    #--------------------global-------------------------#

    def execute(self, query, args={}):
        self.cursor.execute(query, args)

    def executeOne(self, query, args={}):
        self.cursor.execute(query, args)
        row= self.cursor.fetchone()
        return row
 
    def executeAll(self, query, args={}):
        self.cursor.execute(query, args)
        row= self.cursor.fetchall()
        return row
 
    def commit():
        self.db.commit()