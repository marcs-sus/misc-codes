
Program QueueSimulator;
// Simulate a queue data structure in Pascal

Uses sysutils, crt;

Const 
  QueueMax = 10;
  RandomMax = 100;

Type 
  Queue = Array[1..QueueMax] Of String;

Var 
  myQueue: Queue;
  queueRear, OpMode, userInputInt: Integer;
  userInputStr: String;

  // Check if the queue is full
Function IsFull(rear: Integer; max: Integer): Boolean;
Begin
  If rear = max Then
    Begin
      IsFull := True;
    End
  Else
    Begin
      IsFull := False;
    End;
End;

// Check if the queue is empty
Function IsEmpty(queue: Queue): Boolean;
Begin
  If queue[1] = '' Then
    Begin
      IsEmpty := True;
    End
  Else
    Begin
      IsEmpty := False;
    End;
End;


// Insert an element into the queue
Procedure Insert(Var queue: Queue; Var rear: Integer; max: Integer; input: String);
Begin
  If IsFull(rear, max) Then
    Begin
      writeln('Queue is full!');
    End
  Else
    Begin
      writeln('Enter the element to insert: ');
      readln(input);

      If rear < max Then
        Begin
          rear := rear + 1;
          queue[rear] := input;
        End
    End;
End;

// Remove an element from the queue
Procedure Remove(Var queue: Queue; Var rear: Integer; max: Integer);

Var 
  i: Integer;
Begin
  If IsEmpty(queue) Then
    Begin
      writeln('Queue is empty!');
    End
  Else
    Begin
      If queue[1] <> '' Then
        Begin
          rear := rear - 1;
          For i := 2 To max Do
            Begin
              queue[i - 1] := queue[i];
            End;
        End;
    End;
End;

// Consult an element from the queue
Procedure Consult(queue: Queue; max: Integer; input: Integer);
Begin
  writeln('Enter the position to consult: ');
  readln(input);

  If input > max Then
    Begin
      writeln('Invalid position!');
    End
  Else
    Begin
      writeln('Element in position ', input, ' ==> ', queue[input]);
    End;
End;

// Write the queue
Procedure WriteQueue(queue: Queue; rear: Integer; max: Integer);

Var 
  i: Integer;
Begin
  If IsFull(rear, max) Then
    writeln('Queue is full!');
  If IsEmpty(queue) Then
    writeln('Queue is empty!');

  writeln;
  writeln('Current queue: ');
  For i := 1 To rear Do
    Begin
      If i = rear Then
        writeln(queue[i])
      Else
        write(queue[i], ' - ');
    End;
  writeln;
End;

// Seed the queue
Procedure RandomSeed(Var queue: Queue; Var rear: Integer; elementMax: Integer; max: Integer);

Var 
  i, randQueueLimit: Integer;
Begin
  randomize;
  randQueueLimit := random(max);

  For i := 1 To randQueueLimit Do
    Begin
      queue[i] := IntToStr(random(elementMax));
    End;

  rear := randQueueLimit;
End;

// Main
Begin
  queueRear := 0;
  userInputStr := '';
  userInputInt := 0;
  OpMode := 0;

  // Generate random elements
  RandomSeed(myQueue, queueRear, RandomMax, QueueMax);

  // Main loop
  Repeat
    clrscr;

    // Write terminal display
    writeln('Queue data structure simulator');
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
      1: Insert(myQueue, queueRear, QueueMax, userInputStr);
      2: Remove(myQueue, queueRear, QueueMax);
      3: Consult(myQueue, QueueMax, userInputInt);
      4: WriteQueue(myQueue, queueRear, QueueMax);
      0: writeln('Exiting...');
      Else writeln('Invalid operation mode!');
    End;

    // Wait for user key input
    writeln('Press any key to continue...');
    readkey;
  Until (OpMode = 0);
End.
