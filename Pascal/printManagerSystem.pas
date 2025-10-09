
Program PrintManagerSystem;

Uses crt;
{ Simulates a printing company's service queue management system }
{ The system allows customers to enter and exit the queue, view the queue, process the queue, and display statistics. }
{ There are 3 queues: Mono, Color, and Plotter. }
{ For each queue, the system keeps track of the number of customers entered, served, and rejected. }


{ ===== Constants ===== }

Const 
  // Maximum size of each queue
  MAX_MONO    = 10;
  MAX_COLOR   = 5;
  MAX_PLOTTER = 3;
  MAX         = 100;


{ ===== Types ===== }

Type 
  // Object that stores the queue statistics
  QueueStats = Record
    entered: integer;
    served: integer;
    rejected: integer;
  End;

  // Object that stores the queue information
  Queue = Record
    arr: Array[1..MAX] Of String;
    rear: integer;
    maxSize: integer;
    name: String;
    stats: QueueStats;
  End;


{ ===== Global Variables ===== }

Var 
  MonoQueue: Queue;
  ColorQueue: Queue;
  PlotterQueue: Queue;


{ ===== System Initialization ===== }
Procedure Initialize();

Var 
  i: integer;
Begin
  clrscr;

  // Init MonoQueue
  For i := 1 To MAX_MONO Do
    MonoQueue.arr[i] := '';
  MonoQueue.rear := 0;
  MonoQueue.maxSize := MAX_MONO;
  MonoQueue.name := 'Mono';
  MonoQueue.stats.entered := 0;
  MonoQueue.stats.served := 0;
  MonoQueue.stats.rejected := 0;

  // Init ColorQueue
  For i := 1 To MAX_COLOR Do
    ColorQueue.arr[i] := '';
  ColorQueue.rear := 0;
  ColorQueue.maxSize := MAX_COLOR;
  ColorQueue.name := 'Color';
  ColorQueue.stats.entered := 0;
  ColorQueue.stats.served := 0;
  ColorQueue.stats.rejected := 0;

  // Init PlotterQueue
  For i := 1 To MAX_PLOTTER Do
    PlotterQueue.arr[i] := '';
  PlotterQueue.rear := 0;
  PlotterQueue.maxSize := MAX_PLOTTER;
  PlotterQueue.name := 'Plotter';
  PlotterQueue.stats.entered := 0;
  PlotterQueue.stats.served := 0;
  PlotterQueue.stats.rejected := 0;
End;

{ ===== Queue Operations ===== }
Function IsEmpty(Q: Queue): Boolean;
Begin
  IsEmpty := Q.rear = 0;
End;

Function IsFull(Q: Queue): Boolean;
Begin
  IsFull := Q.rear = Q.maxSize;
End;


// Enqueue an element in the queue
Procedure Enqueue(Var Q: Queue; element: String);
Begin
  If Not IsFull(Q) Then
    Begin
      Q.rear := Q.rear + 1;
      Q.arr[Q.rear] := element;
    End
  Else
    Begin
      Writeln('Queue is full! Element rejected');
    End;
End;

// Dequeue an element from the queue
Function Dequeue(Var Q: Queue): String;

Var 
  i: integer;
  aux: String;
Begin
  If Not IsEmpty(Q) Then
    Begin
      aux := Q.arr[1];
      For i := 1 To Q.rear - 1 Do
        Q.arr[i] := Q.arr[i + 1];

      Q.arr[Q.rear] := '';
      Q.rear := Q.rear - 1;
      Dequeue := aux;
    End
  Else
    Begin
      Writeln('Queue ', Q.name, ' is empty! No elements to dequeue');
      Dequeue := '';
    End;
End;

// Peek the first element in the queue
Function Peek(Q: Queue): String;
Begin
  If Not IsEmpty(Q) Then
    Peek := Q.arr[1]
  Else
    Begin
      writeln('Queue ', Q.name, ' is empty! No elements to peek');
      Peek := '';
    End;
End;

// Write the queue to the console
Procedure WriteQueue(Q: Queue);

Var 
  i: integer;
Begin
  writeln('Queue ', Q.name, ': ');
  If IsEmpty(Q) Then
    writeln('Queue is empty!')
  Else
    Begin
      For i := 1 To Q.rear Do
        Begin
          If i = Q.rear Then
            write(Q.arr[i])
          Else
            write(Q.arr[i], ' - ');
        End;
      writeln;
    End;
End;

{ ===== Processing Methods ===== }

// Adds a customer to a given queue
Procedure CustomerEntry(Var Q: Queue);

Var 
  element: String;
  inputValid: Boolean;
Begin
  // Read and validate the input string that represents the customer
  Repeat
    writeln('Enter customer on queue ', Q.name, ': ');
    write('Customer: ');
    readln(element);

    If element = '' Then
      Begin
        inputValid := False;
        writeln('Invalid input! Please try again.');
      End
    Else
      inputValid := True;
  Until (inputValid);

  If IsFull(Q) Then
    Begin
      writeln('Queue is full! Customer ', element, ' rejected');
      Q.stats.rejected := Q.stats.rejected + 1;
    End
  Else
    Begin
      // Enqueue the customer
      Enqueue(Q, element);
      Q.stats.entered := Q.stats.entered + 1;
      writeln('Customer ', element, ' entered the queue ', Q.name);
    End;
End;

// Removes a customer from a given queue, only used in emergency situations
Procedure CustomerExit(Var Q: Queue);

Var 
  element: String;
  i, pos: Integer;
  found: Boolean;
Begin
  If IsEmpty(Q) Then
    Begin
      writeln('Queue ', Q.name, ' is empty! Nothing to exit');
      Exit;
    End;

  writeln('WARNING: ONLY USE THIS OPTION WHEN A Customer HAS SPORADICALLY EXITED A QUEUE!');
  writeln('Exit customer from queue ', Q.name, ': ');
  WriteQueue(Q);
  writeln;
  write('Customer: ');
  readln(element);

  found := False;
  pos := 0;

  // Search for the customer in the queue
  For i := 1 To Q.rear Do
    Begin
      If Q.arr[i] = element Then
        Begin
          pos := i;
          found := True;
          Break;
        End;
    End;

  // If found, remove the customer and shift the queue
  If found Then
    Begin
      For i := pos To Q.rear - 1 Do
        Q.arr[i] := Q.arr[i + 1];
      Q.rear := Q.rear - 1;
      writeln('Customer ', element, ' has been removed from the queue');
    End
  Else
    writeln('Customer ', element, ' not found in the queue');
End;

// Process all customers in the queue
Procedure ProcessQueue(Var Q: Queue);

Var 
  element: String;
  i: integer;
  confirm: Char;
Begin
  If IsEmpty(Q) Then
    writeln('Queue is empty! Nothing to process')
  Else
    Begin
      // Ask for confirmation
      writeln('Processing will dequeue all elements from queue ', Q.name);
      writeln('Do you want to process all elements? (Y/n)');
      readln(confirm);

      If (upcase(confirm) <> 'N') Then
        Begin
          writeln('Processing all elements form queue ', Q.name);

          // Dequeue all elements
          For i := 1 To Q.rear Do
            Begin
              element := Dequeue(Q);
              Writeln('Processed element ', element, ' from queue ', Q.name);
              Q.stats.served := Q.stats.served + 1;
            End;
        End
      Else
        writeln('Processing cancelled!');
    End;
End;

{ ===== Display ===== }
Procedure DisplayStats(Q: Queue);
Begin
  Writeln('Queue: ', Q.name);
  Writeln('Number of elements entered: ', Q.stats.entered);
  Writeln('Number of elements served: ', Q.stats.served);
  Writeln('Number of elements rejected: ', Q.stats.rejected);
  Writeln;
End;

Procedure MainMenu();

Var 
  option, input: Integer;
  inputValid: Boolean;
Begin
  Repeat
    clrscr;

    // Display main menu options
    writeln('===== Print Manager System =====');
    writeln('1 - Enter Customer');
    writeln('2 - Exit Customer');
    writeln('3 - Peek Queue');
    writeln('4 - Write Queue');
    writeln('5 - Process Queue');
    writeln('6 - Display Queue Stats');
    writeln('0 - Exit');
    writeln;
    write('Option: ');
    readln(option);

    If option <> 0 Then
      Begin
        Repeat
          // Read queue to perform operations on
          writeln('Select queue to operate on:');
          writeln('1 - Mono Queue');
          writeln('2 - Color Queue');
          writeln('3 - Plotter Queue');
          writeln;
          write('Option: ');
          readln(input);

          // Using Queue number to select the queue
          inputValid := True;
          Case input Of 
            // Case for Mono Queue
            1:
               Begin
                 clrscr;
                 Case option Of 
                   1: CustomerEntry(MonoQueue);
                   2: CustomerExit(MonoQueue);
                   3: WriteLn('First in queue: ', Peek(MonoQueue));
                   4: WriteQueue(MonoQueue);
                   5: ProcessQueue(MonoQueue);
                   6: DisplayStats(MonoQueue);
                 End;
               End;
            // Case for Color Queue
            2:
               Begin
                 clrscr;
                 Case option Of 
                   1: CustomerEntry(ColorQueue);
                   2: CustomerExit(ColorQueue);
                   3: WriteLn('First in queue: ', Peek(ColorQueue));
                   4: WriteQueue(ColorQueue);
                   5: ProcessQueue(ColorQueue);
                   6: DisplayStats(ColorQueue);
                 End;
               End;
            // Case for Plotter Queue
            3:
               Begin
                 clrscr;
                 Case option Of 
                   1: CustomerEntry(PlotterQueue);
                   2: CustomerExit(PlotterQueue);
                   3: WriteLn('First in queue: ', Peek(PlotterQueue));
                   4: WriteQueue(PlotterQueue);
                   5: ProcessQueue(PlotterQueue);
                   6: DisplayStats(PlotterQueue);
                 End;
               End;
            Else
              Begin
                writeln('Invalid option! Please try again.');
                inputValid := False;
              End;
          End;
        Until (inputValid);

        writeln('Press any key to continue...');
        readkey;
      End;
  Until (option = 0);
End;

// Main
Begin
  Initialize();
  MainMenu();
End.
