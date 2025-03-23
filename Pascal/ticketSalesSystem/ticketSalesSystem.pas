
Program TicketSalesSystem;

Uses crt;
{ Simulate a ticket sales system that sells tickets for a soccer match championship }


{ ===== Constants ===== }

Const 
  // Maximum capacities of data structures
  COVERED_CAPACITY         = 2000;
  GENERAL_CAPACITY         = 1000;
  GENERAL_VISITOR_CAPACITY = 300;
  MEMBER_LIMIT             = 500;

  // Ticket prices
  PRICE_COVERED_MEMBER  = 50;
  PRICE_COVERED_FAN     = 100;
  PRICE_GENERAL_FAN     = 40;
  PRICE_GENERAL_VISITOR = 80;

  // General structure maximum capacities
  MAX_QUEUE = 1000;
  MAX_STACK = 3000;
  MAX_LIST  = 3000;


{ ===== Types ===== }

Type 
  // Costumer types and record
  CostumerType = (Member, Fan, Visitor);
  AccommodationType = (Covered, General);
  CostumerRecordType = Record
    CostumerType: CostumerType;
    Accommodation: AccommodationType;
  End;

  // Data structures types
  CostumerQueueType = Array[1..MAX_QUEUE] Of CostumerRecordType;
  TicketStackType = Array[1..MAX_STACK] Of Integer;
  SeatListType = Array[1..MAX_LIST] Of Integer;

  // Seat availability type
  SeatAvailabilityType = Array[1..MAX_LIST] Of Boolean;


{ ===== Global Variables ===== }

Var 
  // Ticket stacks
  CoveredTicketStack, GeneralTicketStack: TicketStackType;
  CoveredTicketStackTop, GeneralTicketStackTop: Integer;

  // Costumer queues
  MemberQueue, FanQueue, VisitorQueue: CostumerQueueType;
  MemberQueueRear, FanQueueRear, VisitorQueueRear: Integer;

  // Seat lists
  CoveredSeatList, GeneralSeatList: SeatListType;
  CoveredSeatListCount, GeneralSeatListCount: Integer;
  CoveredSeatsAvailable, GeneralSeatsAvailable: SeatAvailabilityType;

  // Revenue counters
  RevenueCoveredMembers, RevenueCoveredFans: Real;
  RevenueGeneralFans, RevenueGeneralVisitors: Real;
  TotalRevenue: Real;

  // Capacity counters
  SoldCovered, SoldGeneral: Integer;
  SoldGeneralVisitors, SoldMembers: Integer;


{ ===== System Initialization ===== }
Procedure Initialize();

Var 
  i: Integer;
Begin
  clrscr;

  CoveredTicketStackTop := 0;
  GeneralTicketStackTop := 0;

  For i := 1 To COVERED_CAPACITY Do
    Begin
      CoveredTicketStackTop := CoveredTicketStackTop + 1;
      CoveredTicketStack[CoveredTicketStackTop] := i;
    End;
  For i := 1 To GENERAL_CAPACITY Do
    Begin
      GeneralTicketStackTop := GeneralTicketStackTop + 1;
      GeneralTicketStack[GeneralTicketStackTop] := i;
    End;

  MemberQueueRear := 0;
  FanQueueRear := 0;
  VisitorQueueRear := 0;

  For i := 1 To COVERED_CAPACITY Do
    CoveredSeatList[i] := i;
  CoveredSeatListCount := COVERED_CAPACITY;
  For i := 1 To GENERAL_CAPACITY Do
    GeneralSeatList[i] := i;
  GeneralSeatListCount := GENERAL_CAPACITY;

  For i := 1 To COVERED_CAPACITY Do
    CoveredSeatsAvailable[i] := True;
  For i := 1 To GENERAL_CAPACITY Do
    GeneralSeatsAvailable[i] := True;

  RevenueCoveredMembers := 0;
  RevenueCoveredFans := 0;
  RevenueGeneralFans := 0;
  RevenueGeneralVisitors := 0;
  TotalRevenue := 0;
  SoldCovered := 0;
  SoldGeneral := 0;
  SoldGeneralVisitors := 0;
  SoldMembers := 0;
End;

{ ===== Search Algorithms ===== }
Function BinarySearchRecursive(Const arr: SeatListType; low, high, target: Integer): Integer;

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

Function BinarySearch(Const arr: SeatListType; n, target: Integer): Integer;
Begin
  BinarySearch := BinarySearchRecursive(arr, 1, n, target);
End;

{ ===== Data Structure Manipulation ===== }
Procedure Enqueue(Var queue: CostumerQueueType; Var rear: Integer; costumer: CostumerRecordType);
Begin
  If rear >= MAX_QUEUE Then
    writeln('Queue is full!')
  Else
    Begin
      rear := rear + 1;
      queue[rear] := costumer;
    End;
End;

Function Dequeue(Var queue: CostumerQueueType; Var rear: Integer): CostumerRecordType;

Var 
  i: integer;
  costumer: CostumerRecordType;
Begin
  If rear = 0 Then
    Begin
      writeln('Queue is empty!');

      costumer.CostumerType := Fan;
      costumer.Accommodation := General;
      Dequeue := costumer;
    End
  Else
    Begin
      costumer := queue[1];
      For i := 2 To rear Do
        queue[i - 1] := queue[i];

      rear := rear - 1;
      Dequeue := costumer;
    End;
End;

Procedure Push(Var stack: TicketStackType; Var top: Integer; number: Integer);
Begin
  If top >= MAX_STACK Then
    writeln('Stack is full!')
  Else
    Begin
      top := top + 1;
      stack[top] := number;
    End;
End;

Function Pop(Var stack: TicketStackType; Var top: Integer): Integer;

Var 
  result: Integer;
Begin
  If top = 0 Then
    Begin
      writeln('Stack is empty!');
      Pop := 1;
    End
  Else
    Begin
      result := stack[top];
      top := top - 1;
      Pop := result;
    End;
End;

Procedure Insert(Var list: SeatListType; Var count: Integer; value: Integer);
Begin
  If count >= MAX_LIST Then
    writeln('List is full!')
  Else
    Begin
      count := count + 1;
      list[count] := value;
    End;
End;

Function Remove(Var list: SeatListType; Var count: Integer; element: Integer): Integer;

Var 
  i, pos: Integer;
Begin
  If count = 0 Then
    Begin
      writeln('List is empty!');
      Remove := -1;
    End
  Else
    Begin
      pos := BinarySearch(list, count, element);
      If pos = -1 Then
        Begin
          write('Seat not found, defaulting to first possible seat: ');
          Remove := list[1];

          For i := 1 To count - 1 Do
            list[i] := list[i + 1];

          count := count - 1;
        End
      Else
        Begin
          Remove := list[pos];

          For i := pos To count - 1 Do
            Begin
              list[i] := list[i + 1];
            End;
          count := count - 1;
        End;
    End;
End;

{ ===== System processing ===== }
Procedure CostumerEntry();

Var 
  costumerType: char;
  costumer: CostumerRecordType;
Begin
  clrscr;
  writeln('--- Costumer Entry ---');
  writeln('Enter the costumer type (M - Member, F - Fan, V - Visitor): ');
  write('Choice: ');

  readln(costumerType);
  Case costumerType Of 
    'M', 'm':
              Begin
                costumer.CostumerType := Member;
                Enqueue(MemberQueue, MemberQueueRear, costumer);
                writeln('Member entered the queue');
              End;
    'F', 'f':
              Begin
                costumer.CostumerType := Fan;
                Enqueue(FanQueue, FanQueueRear, costumer);
                writeln('Fan entered the queue');
              End;
    'V', 'v':
              Begin
                costumer.CostumerType := Visitor;
                Enqueue(VisitorQueue, VisitorQueueRear, costumer);
                writeln('Visitor entered the queue');
              End;
    Else
      writeln('Invalid choice!');
  End;
End;

Function AssignSeat(isCovered: Boolean; Var seatList: SeatListType; Var seatCount: Integer;
                    Var seatAvailable: SeatAvailabilityType; capacity: integer): Integer;

Var 
  i, seatNumber: Integer;
  validSeat: Boolean;
Begin
  writeln('Available seats: ');
  For i := 1 To capacity Do
    If seatAvailable[i] Then
      write(i, ' ');
  writeln;

  Repeat
    validSeat := False;
    write('Choose a seat number: ');

    readln(seatNumber);
    If (seatNumber >= 1) And (seatNumber <= capacity) Then
      Begin
        If seatAvailable[seatNumber] Then
          validSeat := True
        Else
          writeln('Seat ', seatNumber, ' is not available!');
      End
    Else
      Begin
        writeln('Invalid seat number!');
      End;
  Until (validSeat);

  seatAvailable[seatNumber] := False;
  AssignSeat := seatNumber;
End;

Procedure ProcessTicketSales();

Var 
  ticketID, seatNumber: Integer;
  costumer: CostumerRecordType;
  accommodationType: char;
Begin
  clrscr;

  While (MemberQueueRear > 0) And (SoldCovered < COVERED_CAPACITY) And (SoldMembers < MEMBER_LIMIT) Do
    Begin
      costumer := Dequeue(MemberQueue, MemberQueueRear);

      If CoveredTicketStackTop > 0 Then
        Begin
          ticketID := Pop(CoveredTicketStack, CoveredTicketStackTop);
          SoldCovered := SoldCovered + 1;
          SoldMembers := SoldMembers + 1;
          RevenueCoveredMembers := RevenueCoveredMembers + PRICE_COVERED_MEMBER;
          writeln('Member purchase ticket ', ticketID, ' for covered stands');

          seatNumber := AssignSeat(True, CoveredSeatList, CoveredSeatListCount, CoveredSeatsAvailable, COVERED_CAPACITY);
          writeln('Assigned seat: ', seatNumber);
        End;
      writeln;
    End;

  While (FanQueueRear > 0) And ((SoldCovered < COVERED_CAPACITY) Or (SoldGeneral < GENERAL_CAPACITY)) Do
    Begin
      costumer := Dequeue(FanQueue, FanQueueRear);

      writeln('Fan wants to purchase which ticket? (C - Covered, G - General)');
      write('Choice: ');

      readln(accommodationType);
      Case accommodationType Of 
        'C', 'c':
                  If SoldCovered < COVERED_CAPACITY Then
                    Begin
                      ticketID := Pop(CoveredTicketStack, CoveredTicketStackTop);
                      costumer.Accommodation := Covered;
                      SoldCovered := SoldCovered + 1;
                      RevenueCoveredFans := RevenueCoveredFans + PRICE_COVERED_FAN;
                      writeln('Fan purchase ticket ', ticketID, ' for covered stands');

                      seatNumber := AssignSeat(True, CoveredSeatList, CoveredSeatListCount, CoveredSeatsAvailable, COVERED_CAPACITY);
                      writeln('Assigned seat: ', seatNumber);
                    End;
        'G', 'g':
                  If SoldGeneral < GENERAL_CAPACITY Then
                    Begin
                      If GeneralTicketStackTop > 0 Then
                        Begin
                          ticketID := Pop(GeneralTicketStack, GeneralTicketStackTop);
                          SoldGeneral := SoldGeneral + 1;
                          RevenueGeneralFans := RevenueGeneralFans + PRICE_GENERAL_FAN;
                          writeln('Fan purchase ticket ', ticketID, ' for general stands');

                          seatNumber := AssignSeat(True, GeneralSeatList, GeneralSeatListCount, GeneralSeatsAvailable, GENERAL_CAPACITY);
                          writeln('Assigned seat: ', seatNumber);
                        End;
                    End;
        Else
          writeln('Invalid choice!');
      End;
      writeln;
    End;

  While (VisitorQueueRear > 0) And (SoldGeneral < GENERAL_CAPACITY) And (SoldGeneralVisitors < GENERAL_VISITOR_CAPACITY) Do
    Begin
      costumer := Dequeue(VisitorQueue, VisitorQueueRear);

      If GeneralTicketStackTop > 0 Then
        Begin
          ticketID := Pop(GeneralTicketStack, GeneralTicketStackTop);
          SoldGeneral := SoldGeneral + 1;
          SoldGeneralVisitors := SoldGeneralVisitors + 1;
          RevenueGeneralVisitors := RevenueGeneralVisitors + PRICE_GENERAL_VISITOR;
          writeln('Visitor purchase ticket ', ticketID, ' for general stands');

          seatNumber := AssignSeat(True, GeneralSeatList, GeneralSeatListCount, GeneralSeatsAvailable, GENERAL_CAPACITY);
          writeln('Assigned seat: ', seatNumber);
        End;
      writeln;
    End;

  writeln('Ticket sales processing completed!');
End;

{ ===== Displays ===== }
Procedure DisplayRevenue();
Begin
  clrscr;
  writeln('--- Revenue Totals ---');
  writeln('Covered stands (Members): R$ ', RevenueCoveredMembers:0:2);
  writeln('Covered stands (Fans): R$ ', RevenueCoveredFans:0:2);
  writeln('General stands (Fans): R$ ', RevenueGeneralFans:0:2);
  writeln('General stands (Visitors): R$ ', RevenueGeneralVisitors:0:2);
  TotalRevenue := RevenueCoveredMembers + RevenueCoveredFans + RevenueGeneralFans + RevenueGeneralVisitors;
  writeln('Total Revenue: R$ ', TotalRevenue:0:2);
  readkey;
End;

Procedure MainMenu();

Var 
  option: Integer;
Begin
  Repeat
    clrscr;

    writeln('===== Ticket Sales System =====');
    writeln('1 - Enter Costumer');
    writeln('2 - Process Ticket Sales');
    writeln('3 - Display Revenue Summary');
    writeln('0 - Exit');
    writeln;
    write('Option: ');
    readln(option);

    Case option Of 
      1: CostumerEntry();
      2: ProcessTicketSales();
      3: DisplayRevenue();
      0: writeln('Exiting...');
      Else
        writeln('Invalid option!');
    End;

    writeln('Press any key to continue...');
    readkey;
  Until (option = 0);
End;

// Main
Begin
  Initialize();
  MainMenu();
End.
