
Program QueuePointer;
// Simulates a queue data structure in Pascal using pointers

Uses crt;

Const 
  QUEUE_MAX = 10;
  RANDOM_MAX = 100;

Type 
  MainType = integer;
  Node = ^QueueNode;
  QueueNode = Record
    data: MainType;
    next: Node;
  End;

  QueueType = Record
    head: Node;
    tail: Node;
    size: Integer;
  End;

Var 
  myQueue: QueueType;
  input: MainType;
  op: integer;

  // Initialize the queue
Procedure Init();
Begin
  myQueue.head := Nil;
  myQueue.tail := Nil;
  myQueue.size := 0;

  input := 0;
  op := 0;
End;

// Check if the queue is full
Function IsFull(queue: QueueType): boolean;
Begin
  IsFull := queue.size >= QUEUE_MAX;
End;

// Check if the queue is empty
Function IsEmpty(queue: QueueType): boolean;
Begin
  IsEmpty := (queue.head = Nil);
End;

// Insert an element to the queue
Procedure Enqueue(Var queue: QueueType; input: MainType);

Var 
  aux: Node;
Begin
  If IsFull(queue) Then
    Begin
      writeln('Queue is full!');
      Exit;
    End;

  new(aux);
  aux^.data := input;
  aux^.next := Nil;

  If IsEmpty(queue) Then
    Begin
      queue.head := aux;
      queue.tail := aux;
    End
  Else
    Begin
      queue.tail^.next := aux;
      queue.tail := aux;
    End;

  queue.size := queue.size + 1;
  writeln('Element ', input, ' enqueued successfully.');
End;

// Remove an element from the queue
Procedure Dequeue(Var queue: QueueType);

Var 
  aux: Node;
Begin
  If IsEmpty(queue) Then
    Begin
      writeln('Queue is empty!');
      Exit;
    End;

  aux := queue.head;
  writeln('Element ', aux^.data, ' dequeued successfully.');

  queue.head := queue.head^.next;

  If queue.head = Nil Then
    queue.tail := Nil;

  dispose(aux);

  queue.size := queue.size - 1;
End;

// Write the whole queue
Procedure WriteQueue(queue: QueueType);

Var 
  current: Node;
  position: Integer;
Begin
  If IsEmpty(queue) Then
    Begin
      writeln('Queue is empty!');
      Exit;
    End;

  writeln('Queue contents:');
  writeln('-----------------------------');

  current := queue.head;
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
  writeln('Queue size: ', queue.size);
End;

// Seed the queue randomly
Procedure RandomSeed(Var queue: QueueType; count: integer);

Var 
  i: integer;
  value: integer;
Begin
  randomize;

  While Not IsEmpty(queue) Do
    Begin
      Dequeue(queue);
    End;

  If count > QUEUE_MAX Then
    count := QUEUE_MAX;

  writeln('Seeding queue with ', count, ' random values...');

  For i := 1 To count Do
    Begin
      value := random(RANDOM_MAX) + 1;
      Enqueue(queue, value);
    End;

  writeln('Queue seeded successfully.');
End;

// Main
Begin
  Init();

  // Generate random elements
  RandomSeed(myQueue, QUEUE_MAX Div 2);

  Repeat
    clrscr;

    // Write terminal display
    writeln('Queue Data Structure Simulator');
    writeln('============================');
    writeln;
    writeln('Enter the operation mode: ');
    writeln('-------------------------');
    writeln('1. Enqueue (add) an element');
    writeln('2. Dequeue (remove) an element');
    writeln('3. Display Queue');
    writeln('0. Exit');
    writeln;
    writeln('Current queue size: ', myQueue.size, '/', QUEUE_MAX);
    write('Option: ');
    readln(op);

    // Switch case for each operation
    Case op Of 
      1:
         Begin
           writeln('Enter value to enqueue: ');
           readln(input);
           Enqueue(myQueue, input);
         End;
      2: Dequeue(myQueue);
      3: WriteQueue(myQueue);
      0: writeln('Exiting...');
      Else writeln('Invalid operation! Please try again.');
    End;

    // Wait for user input
    writeln('Press Enter to continue...');
    readln;
  Until op = 0;
End.
