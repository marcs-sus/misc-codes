
Program QueueSimulatorDescriptor;
// Simulate a queue data structure in Pascal with descriptor

Uses sysutils, crt;

Const 
  QUEUE_MAX = 10;
  RANDOM_MAX = 100;

Type 
  // Queue data descriptor
  Queue = Record
    arr : Array[1..QUEUE_MAX] Of String;
    rear: Integer;
  End;

Var 
  myQueue: Queue;
  OpMode, userInputInt: Integer;
  userInputStr: String;

  // Check if the queue is full
Function IsFull(queue: Queue): Boolean;
Begin
  IsFull := queue.rear = QUEUE_MAX;
End;

// Check if the queue is empty
Function IsEmpty(queue: Queue): Boolean;
Begin
  IsEmpty := queue.arr[1] = '';
End;

// Enqueue an element into the queue
Procedure Enqueue(Var queue: Queue; input: String);
Begin
  If IsFull(queue) Then
    Begin
      writeln('Queue is full!');
    End
  Else
    Begin
      writeln('Enter the element to insert: ');
      readln(input);

      If queue.rear < QUEUE_MAX Then
        Begin
          queue.rear := queue.rear + 1;
          queue.arr[queue.rear] := input;
        End
    End;
End;

// Dequeue an element from the queue
Procedure Dequeue(Var queue: Queue);

Var 
  i: Integer;
Begin
  If IsEmpty(queue) Then
    Begin
      writeln('Queue is empty!');
    End
  Else
    Begin
      If queue.arr[1] <> '' Then
        Begin
          queue.rear := queue.rear - 1;
          For i := 2 To QUEUE_MAX Do
            Begin
              queue.arr[i - 1] := queue.arr[i];
            End;
        End;
    End;
End;

// Consult an element from the queue
Procedure Consult(queue: Queue; input: Integer);
Begin
  writeln('Enter the position to consult: ');
  readln(input);

  If input > QUEUE_MAX Then
    writeln('Invalid position!')
  Else
    writeln('Element in position ', input, ' ==> ', queue.arr[input]);
End;

// Write the queue
Procedure WriteQueue(queue: Queue);

Var 
  i: Integer;
Begin
  If IsFull(queue) Then
    writeln('Queue is full!');
  If IsEmpty(queue) Then
    writeln('Queue is empty!');

  writeln;
  writeln('Current queue: ');
  For i := 1 To queue.rear Do
    Begin
      If i = queue.rear Then
        writeln(queue.arr[i])
      Else
        write(queue.arr[i], ' - ');
    End;
  writeln;
End;

// Seed the queue
Procedure RandomSeed(Var queue: Queue);

Var 
  i, randQueueLimit: Integer;
Begin
  randomize;
  randQueueLimit := random(QUEUE_MAX);

  For i := 1 To randQueueLimit Do
    Begin
      queue.arr[i] := IntToStr(random(RANDOM_MAX));
    End;

  queue.rear := randQueueLimit;
End;

// Main
Begin
  userInputStr := '';
  userInputInt := 0;
  OpMode := 0;

  // Generate random elements
  RandomSeed(myQueue);

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
      1: Enqueue(myQueue, userInputStr);
      2: Dequeue(myQueue);
      3: Consult(myQueue, userInputInt);
      4: WriteQueue(myQueue);
      0: writeln('Exiting...');
      Else writeln('Invalid operation mode!');
    End;

    // Wait for user key input
    writeln('Press any key to continue...');
    readkey;
  Until (OpMode = 0);
End.
