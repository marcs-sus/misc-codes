
Program Courses_System_Double_Linked;

Uses crt;

{ Simulates a system that keeps track of student enrollments in different courses }
// Supports registering new courses and student
// Supports creating and deleting couses automatically
// Uses dynamic memory allocation for data structures
// Uses double linked lists to store courses and students

{ ===== Types ===== }

Type 
  // Type name
  mainType = string;

  // Students list
  studentPtr = ^studentNode;
  studentNode = Record
    studentName: mainType;
    next: studentPtr;
    prev: studentPtr;
  End;

  // Courses list
  coursePtr = ^courseNode;
  courseNode = Record
    courseName: mainType;
    courseStudentList: studentPtr;
    next: coursePtr;
    prev: coursePtr;
  End;

{ ===== Global Variables ===== }

Var 
  allCourses: coursePtr;
  option: byte;

{ ===== System Initialization ===== }
Procedure Initialize();
Begin
  writeln('Initializing double linked system...');
  allCourses := Nil;
  option := 0;
  clrscr;
End;

{ ===== System Sub-Routines ===== }

// Overload: Search both courses and students
Function Search(pointer: coursePtr; name: mainType): coursePtr;
overload;

Var 
  aux: coursePtr;
Begin
  aux := pointer;
  While (aux <> Nil) And (aux^.courseName <> name) Do
    aux := aux^.next;
  Search := aux;
End;

Function Search(pointer: studentPtr; name: mainType): studentPtr;
overload;

Var 
  aux: studentPtr;
Begin
  aux := pointer;
  While (aux <> Nil) And (aux^.studentName <> name) Do
    aux := aux^.next;
  Search := aux;
End;

// Overload: Insert both courses and students
Procedure Insert(Var pointer: coursePtr; newName: mainType);
overload;

Var 
  newNode, current: coursePtr;
Begin
  New(newNode);
  If (newNode = Nil) Then
    writeln('Error: Memory is full')
  Else
    Begin
      newNode^.courseName := newName;
      newNode^.courseStudentList := Nil;
      newNode^.next := Nil;
      newNode^.prev := Nil;

      // Insert in alphabetical order
      If (pointer = Nil) Then
        Begin
          // First node
          pointer := newNode;
        End
      Else If (newName < pointer^.courseName) Then
             Begin
               // Insert at beginning
               newNode^.next := pointer;
               pointer^.prev := newNode;
               pointer := newNode;
             End
      Else
        Begin
          // Find position to insert
          current := pointer;
          While (current^.next <> Nil) And (current^.next^.courseName < newName) Do
            current := current^.next;

          // Insert after current
          newNode^.next := current^.next;
          newNode^.prev := current;

          If current^.next <> Nil Then
            current^.next^.prev := newNode;

          current^.next := newNode;
        End;

      writeln('Course ', newName, ' created!');
    End;
End;

Procedure Insert(Var pointer: studentPtr; newName: mainType);
overload;

Var 
  newNode, current: studentPtr;
Begin
  New(newNode);
  If (newNode = Nil) Then
    Begin
      writeln('Error: Memory is full');
      writeln('Press any key to continue...');
      readkey;
    End
  Else
    Begin
      newNode^.studentName := newName;
      newNode^.next := Nil;
      newNode^.prev := Nil;

      // Insert in alphabetical order
      If (pointer = Nil) Then
        Begin
          // First node
          pointer := newNode;
        End
      Else If (newName < pointer^.studentName) Then
             Begin
               // Insert at beginning
               newNode^.next := pointer;
               pointer^.prev := newNode;
               pointer := newNode;
             End
      Else
        Begin
          // Find position to insert
          current := pointer;
          While (current^.next <> Nil) And (current^.next^.studentName < newName) Do
            current := current^.next;

          // Insert after current
          newNode^.next := current^.next;
          newNode^.prev := current;

          If current^.next <> Nil Then
            current^.next^.prev := newNode;

          current^.next := newNode;
        End;
    End;
End;

// Overload: Remove both courses and students
Function Remove(Var pointer: coursePtr; name: mainType): boolean;
overload;

Var 
  current: coursePtr;
  found: boolean;
Begin
  found := false;
  current := pointer;

  // Search for the item
  While (current <> Nil) And (Not found) Do
    Begin
      If current^.courseName = name Then
        found := true
      Else
        current := current^.next;
    End;

  // Remove if found and course is empty
  If found And (current^.courseStudentList = Nil) Then
    Begin
      // Update links
      If current^.prev <> Nil Then
        current^.prev^.next := current^.next
      Else
        pointer := current^.next;
      // Removing first node

      If current^.next <> Nil Then
        current^.next^.prev := current^.prev;

      writeln('Empty course ', current^.courseName, ' has been removed!');
      Dispose(current);
    End;

  Remove := found;
End;

Function Remove(Var pointer: studentPtr; name: mainType): boolean;
overload;

Var 
  current: studentPtr;
  found: boolean;
Begin
  found := false;
  current := pointer;

  While (current <> Nil) And (Not found) Do
    Begin
      If current^.studentName = name Then
        found := true
      Else
        current := current^.next;
    End;

  If found Then
    Begin
      // Update links
      If current^.prev <> Nil Then
        current^.prev^.next := current^.next
      Else
        pointer := current^.next;
      // Removing first node

      If current^.next <> Nil Then
        current^.next^.prev := current^.prev;

      Dispose(current);
    End;

  Remove := found;
End;

// Overload: Find last node
Function FindLast(pointer: coursePtr): coursePtr;
overload;

Var 
  current: coursePtr;
Begin
  current := pointer;
  If current <> Nil Then
    While current^.next <> Nil Do
      current := current^.next;
  FindLast := current;
End;

Function FindLast(pointer: studentPtr): studentPtr;
overload;

Var 
  current: studentPtr;
Begin
  current := pointer;
  If current <> Nil Then
    While current^.next <> Nil Do
      current := current^.next;
  FindLast := current;
End;

// Overload: Display courses and students from both directions
Procedure Display(coursesList: coursePtr; forward: boolean);
overload;

Var 
  current: coursePtr;
  i: integer;
Begin
  i := 1;

  If coursesList = Nil Then
    Begin
      writeln('There are no courses in the list');
      writeln('Press any key to continue...');
      readkey;
    End
  Else
    Begin
      If forward Then
        Begin
          writeln('Courses list (Start -> End):');
          current := coursesList;
          While (current <> Nil) Do
            Begin
              writeln(i, ' - ', current^.courseName);
              current := current^.next;
              i := i + 1;
            End;
        End
      Else
        Begin
          writeln('Courses list (End -> Start):');
          current := FindLast(coursesList);
          While (current <> Nil) Do
            Begin
              writeln(i, ' - ', current^.courseName);
              current := current^.prev;
              i := i + 1;
            End;
        End;

      writeln('Press any key to continue...');
      readkey;
    End;
End;

Procedure Display(studentsList: studentPtr; courseName: mainType; forward: boolean);
overload;

Var 
  student: studentPtr;
  i: integer;
Begin
  i := 1;

  If studentsList = Nil Then
    writeln('There are no students in this course')
  Else
    Begin
      If forward Then
        Begin
          writeln('List of students from ', courseName, ' (Start -> End):');
          student := studentsList;
          While (student <> Nil) Do
            Begin
              writeln(i, ' - ', student^.studentName);
              student := student^.next;
              i := i + 1;
            End;
        End
      Else
        Begin
          writeln('List of students from ', courseName, ' (End -> Start):');
          student := FindLast(studentsList);
          While (student <> Nil) Do
            Begin
              writeln(i, ' - ', student^.studentName);
              student := student^.prev;
              i := i + 1;
            End;
        End;
    End;

  writeln('Press any key to continue...');
  readkey;
End;

{ ===== Main System Procedures ===== }

// Register a student
Procedure RegisterStudent(Var coursesList: coursePtr);

Var 
  courseName, studentName: mainType;
  foundCourse: coursePtr;
Begin
  write('Enter a course name: ');
  readln(courseName);

  // Search course
  foundCourse := Search(coursesList, courseName);

  If (foundCourse = Nil) Then
    Begin
      // If course doesn't exist, create it
      Insert(coursesList, courseName);
      foundCourse := Search(coursesList, courseName);
    End;

  If foundCourse <> Nil Then
    Begin
      write('Enter the student''s name for the course ', foundCourse^.courseName, ': ');
      readln(studentName);

      // Check if student is already registered
      If Search(foundCourse^.courseStudentList, studentName) <> Nil Then
        Begin
          writeln('Student is already registered');
          writeln('Press any key to continue...');
          readkey;
        End
      Else
        Begin
          // Insert student
          Insert(foundCourse^.courseStudentList, studentName);
          writeln('Student ', studentName, ' registered in course: ', foundCourse^.courseName);
          writeln('Press any key to continue...');
          readkey;
        End;
    End
  Else
    Begin
      writeln('Error: Couldn''t create or find the course');
      writeln('Press any key to continue...');
      readkey;
    End;
End;

// Remove a student
Procedure RemoveStudent(coursesList: coursePtr);

Var 
  courseName, studentName: mainType;
  targetCourse: coursePtr;
Begin
  If coursesList = Nil Then
    Begin
      writeln('There is no course with this name');
      write('Press any key to continue...');
      readkey;
    End
  Else
    Begin
      write('Enter the course name: ');
      readln(courseName);

      // Search course
      targetCourse := Search(coursesList, courseName);

      If targetCourse = Nil Then
        Begin
          writeln('Error: Course not found');
          write('Press any key to continue...');
          readkey;
        End
      Else
        Begin
          If targetCourse^.courseStudentList = Nil Then
            Begin
              writeln('There are no students registered in this course');
              write('Press any key to continue...');
              readkey;
            End
          Else
            Begin
              write('Enter the name of a student in course ', targetCourse^.courseName, ': ');
              readln(studentName);

              // Remove student
              If Remove(targetCourse^.courseStudentList, studentName) Then
                Begin
                  writeln('Student ', studentName, ' removed from the course ', targetCourse^.courseName, '!');

                  // Check if course is now empty and remove if necessary
                  If targetCourse^.courseStudentList = Nil Then
                    Begin
                      writeln('Course ', courseName, ' is now empty and will be removed');
                      Remove(allCourses, courseName);
                    End;
                End
              Else
                Begin
                  writeln('Error: Student ', studentName, ' not found');
                End;

              write('Press any key to continue...');
              readkey;
            End;
        End;
    End;
End;

// Write all students from a course from both directions
Procedure WriteStudentsForward(coursesList: coursePtr);

Var 
  courseName: mainType;
  course: coursePtr;
Begin
  write('Enter a course name: ');
  readln(courseName);

  course := Search(coursesList, courseName);

  If course = Nil Then
    Begin
      writeln('Course not found');
      writeln('Press any key to continue...');
      readkey;
    End
  Else
    Begin
      Display(course^.courseStudentList, course^.courseName, true);
    End;
End;

Procedure WriteStudentsBackward(coursesList: coursePtr);

Var 
  courseName: mainType;
  course: coursePtr;
Begin
  write('Enter a course name: ');
  readln(courseName);

  course := Search(coursesList, courseName);

  If course = Nil Then
    Begin
      writeln('Course not found');
      writeln('Press any key to continue...');
      readkey;
    End
  Else
    Begin
      Display(course^.courseStudentList, course^.courseName, false);
    End;
End;

// Main menu
Procedure MainMenu();
Begin
  clrscr;

  Repeat
    clrscr;
    writeln('===== COURSES MANAGEMENT SYSTEM =====');
    writeln('1. Register student/course');
    writeln('2. Remove student');
    writeln('3. Write courses (Start -> End)');
    writeln('4. Write courses (End -> Start)');
    writeln('5. Write students (Start -> End)');
    writeln('6. Write students (End -> Start)');
    writeln('0. Exit');
    write('Choose an option: ');
    readln(option);

    Case option Of 
      1: RegisterStudent(allCourses);
      2: RemoveStudent(allCourses);
      3: Display(allCourses, true); // true = forward
      4: Display(allCourses, false); // false = backward
      5: WriteStudentsForward(allCourses);
      6: WriteStudentsBackward(allCourses);
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
