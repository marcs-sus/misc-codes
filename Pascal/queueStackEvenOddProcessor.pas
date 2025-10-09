
Program QueueStackEvenOddProcessor;
{ Classify numbers into queues of even and odd numbers, 
processes them alternatively, and adds them, 
based on a condition, to a stack }


Uses crt;

Const 
  QueueMax = 100;
  StackMax = 100;

Type 
  Queue = Array[1..QueueMax] Of Integer;
  Stack = Array[1..StackMax] Of Integer;

Var 
  myStack: Stack;
  myEvenQueue, myOddQueue: Queue;
  myStackTop, myEvenRear, myOddRear, userInputInt: Integer;

  // Check if the data structure is full
Function IsFull(dataIdx: Integer; max: Integer): Boolean;
Begin
  If dataIdx = max Then
    Begin
      IsFull := True;
    End
  Else
    Begin
      IsFull := False;
    End;
End;

// Check if the data structure is empty
Function IsEmpty(dataIdx: Integer): Boolean;
Begin
  If dataIdx = 0 Then
    Begin
      IsEmpty := True;
    End
  Else
    Begin
      IsEmpty := False;
    End;
End;

// Add an element to the queue
Procedure Enqueue(Var queue: Queue; Var rear: Integer; max: Integer; input: Integer);
Begin
  If IsFull(rear, max) Then
    Begin
      writeln('Queue is full!');
    End
  Else
    Begin
      rear := rear + 1;
      queue[rear] := input;
    End;
End;

// Remove an element from the queue
Function Dequeue(Var queue: Queue; Var rear: Integer; max: Integer): Integer;

Var 
  i, dequeuedNumber: Integer;
Begin
  If IsEmpty(rear) Then
    Begin
      writeln('Queue is empty!');
      Dequeue := 0;
    End
  Else
    Begin
      dequeuedNumber := queue[1];
      For i := 2 To rear Do
        queue[i - 1] := queue[i];
      rear := rear - 1;
      Dequeue := dequeuedNumber;
    End;
End;

// Add an element to the stack
Procedure Push(Var stack: Stack; Var top: Integer; max: Integer; input: Integer);
Begin
  If IsFull(top, max) Then
    Begin
      writeln('Stack is full!');
    End
  Else
    Begin
      top := top + 1;
      stack[top] := input;
    End;
End;

// Remove an element from the stack
Procedure Pop(stack: Stack; Var top: Integer);
Begin
  If IsEmpty(top) Then
    Begin
      writeln('Stack is empty!');
    End
  Else
    Begin
      top := top - 1;
    End;
End;

Procedure ReadNumbers(Var evenQueue: Queue; Var evenRear: Integer;
                      Var oddQueue: Queue; Var oddRear: Integer; max: Integer);

Var input: Integer;
Begin
  readln(input);
  While input <> 0 Do
    Begin
      If input Mod 2 = 0 Then
        Enqueue(evenQueue, evenRear, max, input)
      Else
        Enqueue(oddQueue, oddRear, max, input);
      readln(input);
    End;
End;

Procedure PushOrPopNumbers(Var stack: Stack; Var top: Integer; max: Integer; input: Integer);
Begin
  If input > 0 Then
    Push(stack, top, max, input)
  Else If input < 0 Then
         Pop(stack, top);
End;

Procedure AlternateOutput(Var stack: Stack; Var top: Integer; max: Integer;
                          Var evenQueue: Queue; Var evenRear: Integer;
                          Var oddQueue: Queue; Var oddRear: Integer);
Begin
  While (evenRear > 0) And (oddRear > 0) Do
    Begin
      PushOrPopNumbers(stack, top, max, Dequeue(oddQueue, oddRear, max));
      PushOrPopNumbers(stack, top, max, Dequeue(evenQueue, evenRear, max));
    End;
End;

Procedure WriteNumbers(stack: Stack; top: Integer; max: Integer);

Var 
  i: Integer;
Begin
  writeln('Output: ');
  For i := top Downto 1 Do
    Begin
      writeln(stack[i]);
    End;
End;

// Main
Begin
  myStackTop := 0;
  myEvenRear := 0;
  myOddRear := 0;
  userInputInt := 0;

  clrscr;

  // Display instructions and request user input
  writeln('Input how many numbers you want until 0 is entered');
  writeln('Each value have their parity checked, and added to a corresponding queue');
  writeln('Once all values are read, elements a dequeued alternately from their queues');
  writeln('If a dequeued value is positive, it is pushed to the stack');
  writeln('If a dequeued value is negative, an element is popped from the stack');
  writeln;
  writeln('Input: ');

  // Main process
  ReadNumbers(myEvenQueue, myEvenRear, myOddQueue, myOddRear, QueueMax);
  AlternateOutput(myStack, myStackTop, StackMax, myEvenQueue, myEvenRear, myOddQueue, myOddRear);
  WriteNumbers(myStack, myStackTop, StackMax);

  // Wait for user key input
  write('Press any key to continue...');
  readkey;
End.
