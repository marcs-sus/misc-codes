
Program ListSimulator;
// Simulate a list data structure in Pascal
// Ordering numbers in ascending order

Uses crt;

Const 
  ListMax = 10;
  RandomMax = 100;

Type 
  List = Array[1..ListMax] Of Integer;

Var 
  myList: List;
  listLast, OpMode, userInputInt: Integer;

  // Check if the list is full
Function IsFull(last: Integer; max: Integer): Boolean;
Begin
  If last = max Then
    Begin
      IsFull := True;
    End
  Else
    Begin
      IsFull := False;
    End;
End;

// Check if the list is empty
Function IsEmpty(last: Integer): Boolean;
Begin
  If last = 0 Then
    Begin
      IsEmpty := True;
    End
  Else
    Begin
      IsEmpty := False;
    End;
End;

// Binary search with recursion
Function BinarySearchRecursive(Const arr: Array Of Integer; low, high, target: Integer): Integer;

Var 
  mid: Integer;
Begin
  If low > high Then
    BinarySearchRecursive := -1
  Else
    Begin
      mid := (low + high) Div 2;
      If (arr[mid] = target) Then
        BinarySearchRecursive := mid
      Else If arr[mid] < target Then
             BinarySearchRecursive := BinarySearchRecursive(arr, mid + 1, high, target)
      Else
        BinarySearchRecursive := BinarySearchRecursive(arr, low, mid - 1, target);
    End;
End;

Function BinarySearch(Const arr: Array Of Integer; n, target: Integer): Integer;
Begin
  BinarySearch := BinarySearchRecursive(arr, 0, n - 1, target);
End;

// Insert an element into the list
Procedure Insert(Var list: List; Var last: Integer; max: Integer; input: Integer);

Var 
  i: Integer;
Begin
  If IsFull(last, max) Then
    Begin
      writeln('List is full!');
    End
  Else
    Begin
      writeln('Enter the element to insert: ');
      readln(input);

      i := last;
      While (i > 0) And (list[i] > input) Do
        Begin
          list[i + 1] := list[i];
          i := i - 1;
        End;

      list[i + 1] := input;
      last := last + 1;
    End;
End;

// Remove an element from the list
Procedure Remove(Var list: List; Var last: Integer; max: Integer; input: Integer);

Var 
  i, pos: Integer;
Begin
  If IsEmpty(last) Then
    Begin
      writeln('List is empty!');
    End
  Else
    Begin
      writeln('Enter the element to remove: ');
      readln(input);

      pos := BinarySearch(list, last, input);
      If pos = -1 Then
        writeln('Element not found!')
      Else
        Begin
          For i := pos + 1 To last - 1 Do
            Begin
              list[i] := list[i + 1];
            End;

          last := last - 1;
        End;
    End;
End;

// Consult an element from the list
Procedure Consult(list: List; max: Integer; input: Integer);
Begin
  writeln('Enter the position to consult: ');
  readln(input);

  If input > max Then
    Begin
      writeln('Invalid position!');
    End
  Else
    Begin
      writeln('Element in position ', input, ' ==> ', list[input]);
    End;
End;

// Write the list
Procedure WriteList(list: List; last: Integer; max: Integer);

Var 
  i: Integer;
Begin
  If IsFull(last, max) Then
    writeln('List is full!');
  If IsEmpty(last) Then
    writeln('List is empty!');

  writeln;
  writeln('Current list: ');
  For i := 1 To last Do
    Begin
      If i = last Then
        writeln(list[i])
      Else
        write(list[i], ' - ');
    End;
  writeln;
End;

// Seed the list
Procedure RandomSeed(Var list: List; Var last: Integer; max: Integer);

Var 
  i, randListLimit: Integer;
Begin
  randomize;
  randListLimit := random(max);

  For i := 1 To randListLimit Do
    Begin
      list[i] := i;
    End;

  last := randListLimit;
End;

// Main
Begin
  listLast := 0;
  userInputInt := 0;
  OpMode := 0;

  // Generate random elements
  RandomSeed(myList, listLast, ListMax);

  // Main loop
  Repeat
    clrscr;

    // Write terminal display
    writeln('List data structure simulator');
    writeln;
    writeln('Enter the operation mode: ');
    writeln('-------------------------');
    writeln('1. Insert');
    writeln('2. Remove');
    writeln('3. Consult');
    writeln('4. Write');
    writeln('0. Exit');

    readln(OpMode);

    // Switch case for each operation
    Case OpMode Of 
      1: Insert(myList, listLast, ListMax, userInputInt);
      2: Remove(myList, listLast, ListMax, userInputInt);
      3: Consult(myList, ListMax, userInputInt);
      4: WriteList(myList, listLast, ListMax);
      0: writeln('Exiting...');
      Else writeln('Invalid operation mode!');
    End;

    // Wait for user key input
    writeln('Press any key to continue...');
    readkey;
  Until (OpMode = 0);
End.
