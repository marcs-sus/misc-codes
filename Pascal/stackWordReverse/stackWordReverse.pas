
Program StackWordReverse;
// Reverses the words of a given string, maintaining its order

Uses sysutils, crt;

Const 
  StackMax = 200;

Type 
  Stack = Array[1..StackMax] Of Char;

Var 
  myStack: Stack;
  stackTop: Integer;
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

Function StringLength(str: String; max: Integer): Integer;

Var 
  i: Integer;
Begin
  i := 1;
  While (i <= max) And (str[i] <> #0) Do
    Begin
      i := i + 1;
      StringLength := i - 1;
    End;
End;

Function ReverseWords(Var stack: Stack; Var top: Integer; input: String; max: Integer): String;

Var 
  i: Integer;
Begin
  ReverseWords := '';
  For i := 1 To StringLength(input, max) Do
    Begin
      If input[i] <> ' ' Then
        Push(stack, top, max, input[i])
      Else
        Begin
          While top > 0 Do
            ReverseWords := ReverseWords + Pop(stack, top);

          ReverseWords := ReverseWords + ' ';
        End;
    End;
  While top > 0 Do
    ReverseWords := ReverseWords + Pop(stack, top);
End;

// Main
Begin
  stackTop := 0;
  userInputStr := '';

  clrscr;

  // Write terminal display
  writeln('The following String input value will have its words inverted, preserving its order');
  writeln('-----------------------------------------------------------------------------------');
  writeln('Enter a String input:');
  readln(userInputStr);
  writeln('String output:');

  // Reverse string words 
  writeln(ReverseWords(myStack, stackTop, userInputStr, StackMax));

  // Wait for user key input
  write('Press any key to continue...');
  readkey;
End.
