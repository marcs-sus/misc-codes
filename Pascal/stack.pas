
Program StackSimulator;
// Simulate a stack data structure in Pascal

Uses sysutils, crt;

Const 
  StackMax = 10;
  RandomMax = 100;

Type 
  Stack = Array[1..StackMax] Of String;

Var 
  myStack: Stack;
  stackTop, OpMode, userInputInt: Integer;
  userInputStr: String;

  // Check if the stack is full
Function IsFull(top: Integer; max: Integer): Boolean;
Begin
  If top = max Then
    Begin
      IsFull := True;
    End
  Else
    Begin
      IsFull := False;
    End;
End;

// Check if the stack is empty
Function IsEmpty(top: Integer): Boolean;
Begin
  If top = 0 Then
    Begin
      IsEmpty := True;
    End
  Else
    Begin
      IsEmpty := False;
    End;
End;

// Push an element onto the stack
Procedure Push(Var stack: Stack; Var top: Integer; max: Integer; input: String);
Begin
  If IsFull(top, max) Then
    Begin
      writeln('Stack is full!');
    End
  Else
    Begin
      writeln('Enter the element to push: ');
      readln(input);

      If top < max Then
        Begin
          top := top + 1;
          stack[top] := input;
        End
    End;
End;

// Pop an element from the stack
Procedure Pop(Var stack: Stack; Var top: Integer);
Begin
  If IsEmpty(top) Then
    Begin
      writeln('Stack is empty!');
    End
  Else
    Begin
      stack[top] := '';
      top := top - 1;
    End;
End;

// Consult an element from the stack
Procedure Consult(stack: Stack; top: Integer; input: Integer);
Begin
  writeln('Enter the position to consult: ');
  readln(input);

  If input > top Then
    Begin
      writeln('Invalid position!');
    End
  Else
    Begin
      writeln('Element in position ', input, ' ==> ', stack[input]);
    End;
End;

// Write the stack
Procedure WriteStack(stack: Stack; top: Integer);

Var 
  i: Integer;
Begin
  If IsFull(top, StackMax) Then
    writeln('Stack is full!');
  If IsEmpty(top) Then
    writeln('Stack is empty!');

  writeln('Current stack: ');
  writeln;
  For i := top Downto 1 Do
    writeln(stack[i]);
  writeln;
End;

// Seed the stack
Procedure RandomSeed(Var stack: Stack; Var top: Integer; elementMax: Integer; max: Integer);

Var 
  i, randStackLimit: Integer;
Begin
  randomize;
  randStackLimit := random(max);

  For i := 1 To randStackLimit Do
    Begin
      stack[i] := IntToStr(random(elementMax));
    End;

  top := randStackLimit;
End;

// Main
Begin
  stackTop := 0;
  userInputStr := '';
  userInputInt := 0;
  OpMode := 0;

  // Generate random elements
  RandomSeed(myStack, stackTop, RandomMax, StackMax);

  // Main loop
  Repeat
    clrscr;

    // Write terminal display
    writeln('Enter the operation mode: ');
    writeln('-------------------------');
    writeln('1. Push');
    writeln('2. Pop');
    writeln('3. Consult');
    writeln('4. Write');
    writeln('0. Exit');
    writeln;

    readln(OpMode);

    // Switch case for each operation
    Case OpMode Of 
      1: Push(myStack, stackTop, StackMax, userInputStr);
      2: Pop(myStack, stackTop);
      3: Consult(myStack, stackTop, userInputInt);
      4: WriteStack(myStack, stackTop);
      0: writeln('Exiting...');
      Else writeln('Invalid operation mode!');
    End;

    // Wait for user key input
    write('Press any key to continue...');
    readkey;
  Until (OpMode = 0);
End.
