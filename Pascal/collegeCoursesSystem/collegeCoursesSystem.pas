
Program Couses_System;

Uses crt;

{ Simulates a system that keeps track of student enrollments in different courses }
// Supports registering new courses and student
// Supports creating and deleting couses automatically
// Uses dynamic memory allocation for data structures

{ ===== Types ===== }

Type 
  // Type name
  mainType = string;

  // Students list object
  studentPtr = ^studentNode;
  studentNode = Record
    studentName: mainType;
    next: studentPtr;
  End;

  // Courses list object
  coursePtr = ^courseNode;
  courseNode = Record
    courseName: mainType;
    courseStudentList: studentPtr;
    next: coursePtr;
  End;


{ ===== Global Variables ===== }

Var 
  allCourses: coursePtr;
  option: byte;

{ ===== System Initialization ===== }
Procedure Initialize();
Begin
  writeln('Initializing system...');

  allCourses := Nil;
  option := 0;

  clrscr;
End;

{ ===== System Sub-Routines ===== }
// Search given course
Function SearchCourse(pointer: coursePtr; courseName: mainType): coursePtr;

Var 
  aux: coursePtr;
Begin
  aux := pointer;

  // Search course by iterating through the list
  While (aux <> Nil) And (aux^.courseName <> courseName) Do
    aux := aux^.next;
  SearchCourse := aux;
End;

// Search given student
Function SearchStudent(pointer: studentPtr; studentName: mainType): studentPtr;

Var 
  aux: studentPtr;
Begin
  aux := pointer;

  // Search student by iterating through the list
  While (aux <> Nil) And (aux^.studentName <> studentName) Do
    aux := aux^.next;
  SearchStudent := aux;
End;

// Create a course
Procedure CreateCourse(Var pointer: coursePtr; newCourseName: mainType);

Var 
  newNode, current, prev: coursePtr;
Begin
  New(newNode);
  If (newNode = Nil) Then
    writeln('Error: Memory is full')
  Else
    Begin
      newNode^.courseName := newCourseName;
      newNode^.courseStudentList := Nil;

      // Insert in alphabetical order
      If (pointer = Nil) Or (newCourseName < pointer^.courseName) Then
        Begin
          newNode^.next := pointer;
          pointer := newNode;
        End
      Else
        Begin
          current := pointer;
          prev := Nil;
          While (current <> Nil) And (current^.courseName < newCourseName) Do
            Begin
              prev := current;
              current := current^.next;
            End;
          newNode^.next := current;
          prev^.next := newNode;
        End;

      writeln('Course ', newCourseName, ' created!');
    End;
End;

// Register a student
Procedure RegisterStudent(Var coursesList: coursePtr);

Var 
  courseName, studentName: mainType;
  foundCourse: coursePtr;
  newNode, current, prev: studentPtr;
Begin
  write('Enter a course name: ');
  readln(courseName);

  // Search course
  foundCourse := SearchCourse(coursesList, courseName);

  If (foundCourse = Nil) Then
    Begin
      // If course doesn't exist, create it
      CreateCourse(coursesList, courseName);
      foundCourse := SearchCourse(coursesList, courseName);
      If foundCourse = Nil Then
        Begin
          writeln('Error: Couldn''t create a new course');
          writeln('Press any key to continue...');
          readkey;
          exit;
        End;
    End;

  write('Enter the student''s name for the course ', foundCourse^.courseName, ': ');
  readln(studentName);

  // Check if student is already registered
  If SearchStudent(foundCourse^.courseStudentList, studentName) <> Nil Then
    Begin
      writeln('Student is already registered');
      writeln('Press any key to continue...');
      readkey;
      exit;
    End;

  // Create new student
  New(newNode);
  If (newNode = Nil) Then
    Begin
      writeln('Error: Memory is full');
      writeln('Press any key to continue...');
      readkey;
      exit;
    End;

  newNode^.studentName := studentName;

  // Insert in alphabetical order
  If (foundCourse^.courseStudentList = Nil) Or (studentName < foundCourse^.courseStudentList^.studentName) Then
    Begin
      newNode^.next := foundCourse^.courseStudentList;
      foundCourse^.courseStudentList := newNode;
    End
  Else
    Begin
      current := foundCourse^.courseStudentList;
      prev := Nil;
      While (current <> Nil) And (current^.studentName < studentName) Do
        Begin
          prev := current;
          current := current^.next;
        End;
      newNode^.next := current;
      prev^.next := newNode;
    End;

  writeln('Student ', studentName, ' registered in course: ', foundCourse^.courseName);
  writeln('Press any key to continue...');
  readkey;
End;

// Remove empty course
Procedure RemoveEmptyCourse(Var coursesList: coursePtr; courseName: mainType);

Var 
  current, prev: coursePtr;
  found: boolean;
Begin
  If coursesList = Nil Then
    exit;

  current := coursesList;
  prev := Nil;
  found := false;

  // Search for the course
  While (Not found) And (current <> Nil) Do
    Begin
      If current^.courseName = courseName Then
        found := true
      Else
        Begin
          prev := current;
          current := current^.next;
        End;
    End;

  // If course has no students, remove it
  If found And (current^.courseStudentList = Nil) Then
    Begin
      If prev = Nil Then
        coursesList := current^.next
      Else
        prev^.next := current^.next;

      writeln('Empty course ', current^.courseName, ' has been removed!');
      Dispose(current);
      current := Nil;
    End;
End;

// Remove a student
Procedure RemoveStudent(coursesList: coursePtr);

Var 
  courseName, studentName: mainType;
  targetCourse: coursePtr;
  current, prev: studentPtr;
  found: boolean;
Begin
  If coursesList = Nil Then
    Begin
      writeln('There is no course with this name');
      write('Press any key to continue...');
      readkey;
      exit;
    End;

  write('Enter the course name: ');
  readln(courseName);

  // Search course
  targetCourse := SearchCourse(coursesList, courseName);

  If targetCourse = Nil Then
    Begin
      writeln('Error: Course not found');
      write('Press any key to continue...');
      readkey;
      exit;
    End;

  If targetCourse^.courseStudentList = Nil Then
    Begin
      writeln('There are no students registered in this course');
      write('Press any key to continue...');
      readkey;
      exit;
    End;

  write('Enter the name of a student in course ', targetCourse^.courseName, ': ');
  readln(studentName);

  // Search for the student
  current := targetCourse^.courseStudentList;
  prev := Nil;
  found := false;

  While (Not found) And (current <> Nil) Do
    Begin
      If current^.studentName = studentName Then
        found := true
      Else
        Begin
          prev := current;
          current := current^.next;
        End;
    End;

  If Not found Then
    Begin
      writeln('Error: Student ', studentName, ' not found');
      write('Press any key to continue...');
      readkey;
    End
  Else
    Begin
      If prev = Nil Then
        targetCourse^.courseStudentList := current^.next
      Else
        prev^.next := current^.next;

      // Remove student
      writeln('Student ', current^.studentName, ' removed from the course ', targetCourse^.courseName, '!');
      Dispose(current);
      current := Nil;

      // Check if course is now empty
      If targetCourse^.courseStudentList = Nil Then
        Begin
          writeln('Course ', courseName, ' is now empty and will be removed');
          RemoveEmptyCourse(allCourses, courseName);
        End;

      write('Press any key to continue...');
      readkey;
    End;
End;

// Write all courses
Procedure WriteCourses(coursesList: coursePtr);

Var 
  current: coursePtr;
  i: integer;
Begin
  i := 1;
  current := coursesList;
  If current = Nil Then
    Begin
      writeln('There are no courses in the list');
      writeln('Press any key to continue...');
      readkey;
    End
  Else
    Begin
      writeln('Courses list:');
      While (current <> Nil) Do
        Begin
          writeln(i, ' - ', current^.courseName);
          current := current^.next;
          i := i + 1;
        End;
      writeln('Press any key to continue...');
      readkey;
    End;
End;

// Write all students from a course
Procedure WriteStudents(coursesList: coursePtr);

Var 
  courseName: mainType;
  course: coursePtr;
  student: studentPtr;
  i: integer;
Begin
  write('Enter a course name: ');
  readln(courseName);

  course := SearchCourse(coursesList, courseName);

  If course = Nil Then
    Begin
      writeln('Course not found');
      writeln('Press any key to continue...');
      readkey;
      exit;
    End;

  student := course^.courseStudentList;
  i := 1;
  If student = Nil Then
    writeln('There are no students in this course')
  Else
    Begin
      writeln('List of students from ', course^.courseName, ':');
      While (student <> Nil) Do
        Begin
          writeln(i, ' - ', student^.studentName);
          student := student^.next;
          i := i + 1;
        End;
    End;
  writeln('Press any key to continue...');
  readkey;
End;

// Main menu
Procedure MainMenu();
Begin
  clrscr;

  Repeat
    clrscr;
    writeln('1. Register student/course');
    writeln('2. Remove student');
    writeln('3. Write students');
    writeln('4. Write courses');
    writeln('0. Exit');
    write('Choose an option: ');
    readln(option);
    Case option Of 
      1: RegisterStudent(allCourses);
      2: RemoveStudent(allCourses);
      3: WriteStudents(allCourses);
      4: WriteCourses(allCourses);
      0:
         Begin
           clrscr;
           writeln('Goodbye! Exiting the system...');
         End;
      Else
        Begin
          writeln('Invalid option, press any key to continue...');
          readkey;
        End;
    End;
  Until option = 0;
End;

// Main
Begin
  Initialize();
  MainMenu();
End.
