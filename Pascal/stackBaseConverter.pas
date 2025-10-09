
Program StackBaseConverter;
// Convert a decimal number to a binary, octal, or hexadecimal number using a stack

Uses sysutils, crt;

Const 
  StackMax = 200;
  HexDigits: Array[0..15] Of Char = ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');

Type 
  Stack = Array[1..StackMax] Of Char;

Var 
  myStack: Stack;
  userInputInt, stackTop, opMode: Integer;

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
Procedure Push(Var stack: Stack; Var top: Integer; max: Integer; input: Char);
Begin
  If IsFull(top, max) Then
    Begin
      writeln('Stack is full!');
    End
  Else
    Begin
      If top < max Then
        Begin
          top := top + 1;
          stack[top] := input;
        End
    End;
End;

// Pop an element from the stack
Function Pop(Var stack: Stack; Var top: Integer): Char;
Begin
  If IsEmpty(top) Then
    Begin
      writeln('Stack is empty!');
    End
  Else
    Begin
      Pop := stack[top];
      top := top - 1;
    End;
End;

Function DecimalToBinary(Var stack: Stack; Var top: Integer; max: Integer; input: Integer; digits: Array Of Char): String;

Var 
  dec, remainder: Integer;
Begin
  top := 0;
  dec := input;
  If dec = 0 Then
    DecimalToBinary := '0'
  Else
    Begin
      While dec > 0 Do
        Begin
          remainder := dec Mod 2;
          dec := dec Div 2;

          Push(stack, top, max, digits[remainder]);
        End;

      DecimalToBinary := '';
      While Not IsEmpty(top) Do
        DecimalToBinary := DecimalToBinary + Pop(stack, top);
    End;
End;

Function DecimalToOctal(Var stack: Stack; Var top: Integer; max: Integer; input: Integer; digits: Array Of Char): String;

Var 
  dec, remainder: Integer;
Begin
  top := 0;
  dec := input;
  If dec = 0 Then
    DecimalToOctal := '0'
  Else
    Begin
      While dec > 0 Do
        Begin
          remainder := dec Mod 8;
          dec := dec Div 8;

          Push(stack, top, max, digits[remainder]);
        End;

      DecimalToOctal := '';
      While Not isEmpty(top) Do
        DecimalToOctal := DecimalToOctal + Pop(stack, top);
    End;
End;

Function DecimalToHexadecimal(Var stack: Stack; Var top: Integer; max: Integer; input: Integer; digits: Array Of Char): String;

Var 
  dec, remainder: Integer;
Begin
  top := 0;
  dec := input;
  If dec = 0 Then
    DecimalToHexadecimal := '0'
  Else
    Begin
      While dec > 0 Do
        Begin
          remainder := dec Mod 16;
          dec := dec Div 16;

          Push(stack, top, max, digits[remainder]);
        End;

      DecimalToHexadecimal := '';
      While Not isEmpty(top) Do
        DecimalToHexadecimal := DecimalToHexadecimal + Pop(stack, top);
    End;
End;

// Main
Begin
  stackTop := 0;
  userInputInt := 0;

  clrscr;

  // Write terminal display
  writeln('Convert the Integer input to a binary, octal, or hexadecimal number:');
  writeln('--------------------------------------------------------------------');
  writeln('Enter a Integer input:');
  readln(userInputInt);

  // Select base to convert to
  writeln('Select the base to convert to:');
  writeln('1. Binary');
  writeln('2. Octal');
  writeln('3. Hexadecimal');
  readln(opMode);

  // Switch case for each operation
  Case opMode Of 
    1: writeln('Result: ', DecimalToBinary(myStack, stackTop, StackMax, userInputInt, HexDigits));
    2: writeln('Result: ', DecimalToOctal(myStack, stackTop, StackMax, userInputInt, HexDigits));
    3: writeln('Result: ', DecimalToHexadecimal(myStack, stackTop, StackMax, userInputInt, HexDigits));
    Else
      writeln('Invalid option!');
  End;

  // Wait for user key input
  write('Press any key to continue...');
  readkey;
End.
