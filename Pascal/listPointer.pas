
Program ListPointer;
// Simulates a list data structure in Pascal using pointers
// Ordering numbers in ascending order

Uses crt;

Const 
  LIST_MAX = 10;
  RANDOM_MAX = 100;

Type 
  MainType = integer;
  Node = ^ListNode;
  ListNode = Record
    data: MainType;
    next: Node;
  End;

  ListType = Record
    head: Node;
    size: Integer;
  End;

Var 
  myList: ListType;
  input: MainType;
  op: integer;

  // Initialize the list
Procedure Init();
Begin
  myList.head := Nil;
  myList.size := 0;

  input := 0;
  op := 0;
End;

// Check if the list is full
Function IsFull(list: ListType): boolean;
Begin
  IsFull := list.size >= LIST_MAX;
End;

// Check if the list is empty
Function IsEmpty(list: ListType): boolean;
Begin
  IsEmpty := (list.head = Nil);
End;

// Insert an element to the list
Procedure Insert(Var list: ListType; input: MainType);

Var 
  aux: Node;
  aux2: Node;
  last: Node;
Begin
  If IsFull(list) Then
    Begin
      writeln('List is full!');
      Exit;
    End;

  new(aux);
  aux^.data := input;
  aux^.next := Nil;

  If (list.head = Nil) Then
    list.head := aux
  Else
    Begin
      last := list.head;
      aux2 := list.head;

      While ((aux2^.next <> Nil) And (input > aux2^.data)) Do
        Begin
          last := aux2;
          aux2 := aux2^.next;
        End;

      If (input < list.head^.data) Then
        Begin
          aux^.next := list.head;
          list.head := aux;
        End
      Else If (aux2^.next = Nil) And (input > aux2^.data) Then
             aux2^.next := aux
      Else
        Begin
          aux^.next := aux2;
          last^.next := aux;
        End;
    End;

  list.size := list.size + 1;
End;

// Remove an element from the list
Procedure Remove(Var list: ListType; value: MainType);

Var 
  current: Node;
  previous: Node;
  found: boolean;
Begin
  If IsEmpty(list) Then
    Begin
      writeln('List is empty!');
      Exit;
    End;

  current := list.head;
  previous := Nil;
  found := false;

  // Search for the element to remove
  While (current <> Nil) And (Not found) Do
    Begin
      If current^.data = value Then
        found := true
      Else
        Begin
          previous := current;
          current := current^.next;
        End;
    End;

  If Not found Then
    Begin
      writeln('Element ', value, ' not found in the list!');
      Exit;
    End;

  // Remove the element
  If previous = Nil Then
    // Removing the first element
    list.head := current^.next
  Else
    // Removing a middle or last element
    previous^.next := current^.next;

  dispose(current);
  list.size := list.size - 1;
  writeln('Element ', value, ' removed successfully.');
End;

// Write the whole list
Procedure WriteList(list: ListType);

Var 
  current: Node;
  position: Integer;
Begin
  If IsEmpty(list) Then
    Begin
      writeln('List is empty!');
      Exit;
    End;

  writeln('List contents:');
  writeln('-----------------------------');

  current := list.head;
  position := 1;

  While current <> Nil Do
    Begin
      If current^.next = Nil Then
        write(current^.data)
      Else
        write(current^.data, ' - ');

      current := current^.next;
      position := position + 1;
    End;

  writeln;
  writeln('List size: ', list.size);
End;

// Seed the list randomly
Procedure RandomSeed(Var list: ListType; count: integer);

Var 
  i: integer;
  value: integer;
Begin
  randomize;

  writeln('Generating ', count, ' random elements...');

  For i := 1 To count Do
    Begin
      If Not IsFull(list) Then
        Begin
          value := random(RANDOM_MAX) + 1;
          Insert(list, value);
        End
      Else
        Begin
          writeln('List became full after ', i-1, ' insertions.');
          Break;
        End;
    End;

  writeln('Random seeding completed.');
End;

// Main
Begin
  Init();

  // Generate random elements
  RandomSeed(myList, LIST_MAX Div 2);

  Repeat
    clrscr;

    // Write terminal display
    writeln('List Data Structure Simulator');
    writeln('============================');
    writeln;
    writeln('Enter the operation mode: ');
    writeln('-------------------------');
    writeln('1. Insert (add) an element');
    writeln('2. Remove (remove) an element');
    writeln('3. Display List');
    writeln('0. Exit');
    writeln;
    writeln('Current list size: ', myList.size, '/', LIST_MAX);
    write('Option: ');
    readln(op);

    // Switch case for each operation
    Case op Of 
      1:
         Begin
           writeln('Enter value to insert: ');
           readln(input);
           Insert(myList, input);
         End;
      2:
         Begin
           writeln('Enter value to remove: ');
           readln(input);
           Remove(myList, input);
         End;
      3: WriteList(myList);
      0: writeln('Exiting...');
      Else writeln('Invalid operation! Please try again.');
    End;

    // Wait for user input
    writeln('Press Enter to continue...');
    readln;
  Until op = 0;
End.
