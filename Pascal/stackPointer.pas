
Program StackPointer;
// Simulates a stack data structure in Pascal using pointers

Uses crt;

Const 
  STACK_MAX = 10;
  RANDOM_MAX = 100;

Type 
  MainType = integer;
  Node = ^StackNode;
  StackNode = Record
    data: MainType;
    next: Node;
  End;

  StackType = Record
    top: Node;
    size: Integer;
  End;

Var 
  myStack: StackType;
  input: MainType;
  op: integer;

  // Initialize the stack
Procedure Init();
Begin
  myStack.top := Nil;
  myStack.size := 0;

  input := 0;
  op := 0;
End;

// Check if the stack is full
Function IsFull(stack: StackType): boolean;
Begin
  IsFull := stack.size >= STACK_MAX;
End;

// Check if the stack is empty
Function IsEmpty(stack: StackType): boolean;
Begin
  IsEmpty := (stack.top = Nil);
End;

// Insert an element to the stack
Procedure Push(Var stack: StackType; input: MainType);

Var 
  aux: Node;
Begin
  If IsFull(stack) Then
    Begin
      writeln('Stack is full!');
      Exit;
    End;

  new(aux);
  aux^.data := input;
  aux^.next := stack.top;
  stack.top := aux;

  stack.size := stack.size + 1;
  writeln('Element ', input, ' pushed successfully.');
End;

// Remove an element from the stack
Procedure Pop(Var stack: StackType);

Var 
  aux: Node;
Begin
  If IsEmpty(stack) Then
    Begin
      writeln('Stack is empty!');
      Exit;
    End;

  aux := stack.top;
  writeln('Element ', aux^.data, ' popped successfully.');

  stack.top := stack.top^.next;

  dispose(aux);

  stack.size := stack.size - 1;
End;

// Write the whole stack
Procedure WriteStack(stack: StackType);

Var 
  current: Node;
  position: Integer;
Begin
  If IsEmpty(stack) Then
    Begin
      writeln('Stack is empty!');
      Exit;
    End;

  writeln('Stack contents:');
  writeln('-----------------------------');

  current := stack.top;
  position := 1;

  While current <> Nil Do
    Begin
      writeln(current^.data);

      current := current^.next;
      position := position + 1;
    End;

  writeln;
  writeln('Stack size: ', stack.size);
End;

// Seed the stack randomly
Procedure RandomSeed(Var stack: StackType; count: integer);

Var 
  i: integer;
  value: integer;
Begin
  randomize;

  While Not IsEmpty(stack) Do
    Begin
      Pop(stack);
    End;

  If count > STACK_MAX Then
    count := STACK_MAX;

  writeln('Seeding stack with ', count, ' random values...');

  For i := 1 To count Do
    Begin
      value := random(RANDOM_MAX) + 1;
      Push(stack, value);
    End;

  writeln('Stack seeded successfully.');
End;

// Main
Begin
  Init();

  // Generate random elements
  RandomSeed(myStack, STACK_MAX Div 2);

  Repeat
    clrscr;

    // Write terminal display
    writeln('Stack Data Structure Simulator');
    writeln('============================');
    writeln;
    writeln('Enter the operation mode: ');
    writeln('-------------------------');
    writeln('1. Push (add) an element');
    writeln('2. Pop (remove) an element');
    writeln('3. Display Stack');
    writeln('0. Exit');
    writeln;
    writeln('Current stack size: ', myStack.size, '/', STACK_MAX);
    write('Option: ');
    readln(op);

    // Switch case for each operation
    Case op Of 
      1:
         Begin
           writeln('Enter value to push: ');
           readln(input);
           Push(myStack, input);
         End;
      2: Pop(myStack);
      3: WriteStack(myStack);
      0: writeln('Exiting...');
      Else writeln('Invalid operation! Please try again.');
    End;

    // Wait for user input
    writeln('Press Enter to continue...');
    readln;
  Until op = 0;
End.
