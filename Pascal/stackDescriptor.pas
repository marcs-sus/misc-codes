
Program StackSimulatorDescriptor;
// Simulate a stack data structure in Pascal with descriptor

Uses sysutils, crt;

Const 
  STACK_MAX = 10;
  RANDOM_MAX = 100;

Type 
  Stack = Record
    arr : Array[1..STACK_MAX] Of String;
    top: Integer;
  End;

Var 
  myStack: Stack;
  OpMode, userInputInt: Integer;
  userInputStr: String;

  // Check if the stack is full
Function IsFull(stack: Stack): Boolean;
Begin
  IsFull := stack.top = STACK_MAX;
End;

// Check if the stack is empty
Function IsEmpty(stack: Stack): Boolean;
Begin
  IsEmpty := stack.top = 0;
End;

// Push an element onto the stack
Procedure Push(Var stack: Stack; input: String);
Begin
  If IsFull(stack) Then
    Begin
      writeln('Stack is full!');
    End
  Else
    Begin
      writeln('Enter the element to push: ');
      readln(input);

      If stack.top < STACK_MAX Then
        Begin
          stack.top := stack.top + 1;
          stack.arr[stack.top] := input;
        End
    End;
End;

// Pop an element from the stack
Procedure Pop(Var stack: Stack);
Begin
  If IsEmpty(stack) Then
    Begin
      writeln('Stack is empty!');
    End
  Else
    Begin
      stack.arr[stack.top] := '';
      stack.top := stack.top - 1;
    End;
End;

// Consult an element from the stack
Procedure Consult(stack: Stack; input: Integer);
Begin
  writeln('Enter the position to consult: ');
  readln(input);

  If input > stack.top Then
    writeln('Invalid position!')
  Else
    writeln('Element in position ', input, ' ==> ', stack.arr[input]);
End;

// Write the stack
Procedure WriteStack(stack: Stack);

Var 
  i: Integer;
Begin
  If IsFull(stack) Then
    writeln('Stack is full!');
  If IsEmpty(stack) Then
    writeln('Stack is empty!');

  writeln('Current stack: ');
  writeln;
  For i := stack.top Downto 1 Do
    writeln(stack.arr[i]);
  writeln;
End;

// Seed the stack
Procedure RandomSeed(Var stack: Stack);

Var 
  i, randStackLimit: Integer;
Begin
  randomize;
  randStackLimit := random(STACK_MAX);

  For i := 1 To randStackLimit Do
    Begin
      stack.arr[i] := IntToStr(random(RANDOM_MAX));
    End;

  stack.top := randStackLimit;
End;

// Main
Begin
  userInputStr := '';
  userInputInt := 0;
  OpMode := 0;

  // Generate random elements
  RandomSeed(myStack);

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
      1: Push(myStack, userInputStr);
      2: Pop(myStack);
      3: Consult(myStack, userInputInt);
      4: WriteStack(myStack);
      0: writeln('Exiting...');
      Else writeln('Invalid operation mode!');
    End;

    // Wait for user key input
    write('Press any key to continue...');
    readkey;
  Until (OpMode = 0);
End.
