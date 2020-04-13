# -*- coding: utf-8 -*-

import tkinter as tk
from tkinter import ttk
from tkinter import filedialog
import dbModule
import datetime
import tkinter.messagebox

class Counter_program():
    def __init__(self, db):
        self.window = tk.Tk()
        self.window.title("근로장학생(관리자용)") #상단바 프로그램 이름
        self.window.geometry("1300x500+100+100")
        self.create_widgets()
        self.db=db #위의 self 옆의 db를 의미
    
        self.radio_variable = tk.StringVar()
        self.combobox_value = tk.StringVar()
    
    def login_success(self):
        self.ID_str = self.ID_entry.get() # 뒤에서도 작동하는 ID
        Password_str = self.PW_entry.get()
        self.ID_entry.delete(0,tk.END)
        self.PW_entry.delete(0,tk.END)
        check,name = self.db.logcheck_s(self.ID_str,Password_str)
        print(check)
        if check :
            ID_label = ttk.Label(self.Log_frame, text="안녕하세요\n"+name['WorkplaceName']+" 관리자님")
            ID_label.grid(row=1, column=4, sticky=tk.W, pady=3)

        self.refresh_table()


    def refresh_table(self):
        num, self.data = self.db.getmyrec(self.ID_str)
        for i in range(num):
            self.treeview.insert('', 'end', text=i, values=tuple(self.data[i].values()), iid=str(i))
            

        
    def OnDoubleClick(self, event):
        item = self.treeview.selection()[0]
        print("you clicked on", self.treeview.item(item,"text")) 
        self.selected_Rec = self.data[int(item)]['RecruitmentID']
        
        Setect_Title = ttk.Label(self.switch_frame, text="선택한 공고의 지원자입니다.")
        Setect_Title.grid(row=1, column=1, sticky=tk.W, pady=3)

        for i in self.apptreeview.get_children():
            self.apptreeview.delete(i)
        num2, self.myappllcation = self.db.getmystudent(self.selected_Rec)
        for i in range(num2):
            self.apptreeview.insert('', 'end', text=i, values=tuple(self.myappllcation[i].values()), iid=str(i))

    def OnDoubleClick_2(self, event):
        item = self.apptreeview.selection()[0]
        self.selected_student = self.myappllcation[int(item)]["StudentID"]
        if tkinter.messagebox.askyesno("Message", "이 학생을 최종 선발하시겠습니까?"):
            tkinter.messagebox.showinfo("Message", "선발되었습니다.")
            db.final_selection(self.selected_student, self.selected_Rec, self.ID_str)
            db.result_update()
            self.window.update()
        else: tkinter.messagebox.showinfo("Message", "취소되었습니다")
    

    def create_widgets(self):
        # Create some room around all the internal frames
        self.window['padx'] = 5
        self.window['pady'] = 5

        # - - - - - - - - - - - - - - - - - - - - -
        # The Login frame
        self.Log_frame = ttk.LabelFrame(self.window, text="Log-In", relief=tk.RIDGE)
        self.Log_frame.grid(row=1, column=1, sticky=tk.E + tk.W + tk.N + tk.S)

        ID_label = ttk.Label(self.Log_frame, text="SupervisorID")
        ID_label.grid(row=1, column=1, sticky=tk.E, pady=3)

        PW_label = ttk.Label(self.Log_frame, text="Password")
        PW_label.grid(row=2, column=1, sticky=tk.E, pady=3)
        
        self.ID_entry = ttk.Entry(self.Log_frame, width=20)
        self.ID_entry.grid(row=1, column=2, sticky=tk.W, pady=3)
        self.ID_entry.insert(tk.END, "A1_061")
        
        self.PW_entry = ttk.Entry(self.Log_frame, width=20)
        self.PW_entry.grid(row=2, column=2, sticky=tk.W, pady=3)
        self.PW_entry.insert(tk.END, "obb8210")
        
        

        Login_button = ttk.Button(self.Log_frame, text="Log-In", command=self.login_success)
        Login_button.grid(row=1, column=3)
        
        #refresh_button = ttk.Button(self.Log_frame, text="Refresh",  command=self.refresh_table)
        #refresh_button.grid(row=3, column=2)

        # - - - - - - - - - - - - - - - - - - - - -
        # The Get My Recruit frame
        self.entry_frame = ttk.LabelFrame(self.window, text="내가 게시한 공고", relief=tk.RIDGE)
        self.entry_frame.grid(row=2, column=1, sticky=tk.E + tk.W + tk.N + tk.S)
        
        self.treeview=ttk.Treeview(self.entry_frame, columns=["지원마감일", "근무지","영어", "중국어", "컴퓨터", "월", "화", "수", "목", "금"])        
        self.treeview.pack()
        
        self.treeview.column("#0", width=30)
        self.treeview.heading("#0", text="no.")
        
        self.treeview.column("#1", width=80, anchor="w")
        self.treeview.heading("#1", text="지원마감일", anchor="center")
        
        self.treeview.column("#2", width=120, anchor="w")
        self.treeview.heading("#2", text="근무지", anchor="center")
        
        self.treeview.column("#3", width=20, anchor="w")
        self.treeview.heading("#3", text="영어", anchor="center")
        
        self.treeview.column("#4", width=30, anchor="w")
        self.treeview.heading("#4", text="중국어", anchor="center")

        self.treeview.column("#5", width=80, anchor="w")
        self.treeview.heading("#5", text="컴퓨터", anchor="center")

        self.treeview.column("#6", width=10, anchor="w")
        self.treeview.heading("#6", text="월", anchor="center")

        self.treeview.column("#7", width=10, anchor="w")
        self.treeview.heading("#7", text="화", anchor="center")

        self.treeview.column("#8", width=10, anchor="w")
        self.treeview.heading("#8", text="수", anchor="center")

        self.treeview.column("#9", width=10, anchor="w")
        self.treeview.heading("#9", text="목", anchor="center")

        self.treeview.column("#10", width=10, anchor="w")
        self.treeview.heading("#10", text="금", anchor="center")

        self.treeview.bind("<Double-1>", self.OnDoubleClick)


        # The Choices frame
        self.switch_frame = ttk.LabelFrame(self.window, text="지원자 명단", relief=tk.RIDGE, padding=6)
        self.switch_frame.grid(row=2, column=2, padx=6, sticky=tk.E + tk.W + tk.N + tk.S)



        # # - - - - - - - - - - - - - - - - - - - - -
        # The Student View frame
        self.application_frame = ttk.LabelFrame(self.window, text="지원자 명단", relief=tk.RIDGE, padding=3)
        self.application_frame.grid(row=2, column=2, sticky=tk.E + tk.W + tk.N + tk.S, padx=6)

        self.apptreeview=ttk.Treeview(self.application_frame, columns=["학번", "이름", "총점"])        
        self.apptreeview.pack()
        
        self.apptreeview.column("#0", width=40)
        self.apptreeview.heading("#0", text="no.")
        
        self.apptreeview.column("#1", width=120, anchor="w")
        self.apptreeview.heading("#1", text="학번", anchor="center")
        
        self.apptreeview.column("#2", width=60, anchor="w")
        self.apptreeview.heading("#2", text="이름", anchor="center")

        self.apptreeview.column("#3", width=80, anchor="w")
        self.apptreeview.heading("#3", text="총점", anchor="center")

        self.apptreeview.bind("<Double-1>", self.OnDoubleClick_2)

       
        # Quit button in the lower right corner
        quit_button = ttk.Button(self.window, text="Quit", command=self.window.destroy)
        quit_button.grid(row=1, column=3)

        
# Create the entire GUI program
db = dbModule.Database()
program = Counter_program(db)

# Start the GUI event loop
program.window.mainloop()
