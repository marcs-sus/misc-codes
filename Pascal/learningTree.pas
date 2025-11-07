
Program BinaryTreeGame;
// A simple binary tree game similar to Akinator

Uses crt, sysutils;

Const 
  TREE_MAX = 50;

Type 
  TreeNodePtr = ^TreeNode;
  TreeNode = Record
    Value: String;
    Left, Right: TreeNodePtr;
  End;

  TreeType = Record
    Root: TreeNodePtr;
    Size: Integer;
  End;

Var 
  myTree: TreeType;
  input: String;
  op: Integer;

  // Initialize the binary tree
Procedure Init();
Begin
  new(myTree.Root);
  myTree.Root^.Value := 'A person';

  new(myTree.Root^.Left);
  myTree.Root^.Left^.Value := 'New York';

  new(myTree.Root^.Right);
  myTree.Root^.Right^.Value := 'John Smith';

  myTree.Size := 3;

  input := '';
End;

// Display the entire tree
Procedure DisplayTree(node: TreeNodePtr; level: Integer);
Begin
  If node <> Nil Then
    Begin
      // Print the current node
      WriteLn(node^.Value);

      // Print left child (if exists)
      If node^.Left <> Nil Then
        Begin
          Write(StringOfChar(' ', level * 2), 'L: ');
          DisplayTree(node^.Left, level + 1);
        End;

      // Print right child (if exists)
      If node^.Right <> Nil Then
        Begin
          Write(StringOfChar(' ', level * 2), 'R: ');
          DisplayTree(node^.Right, level + 1);
        End;
    End;
End;

// Insert a new question and answer into the tree
Procedure Insert(node: TreeNodePtr; newAnswer: String; newQuestion: String);

Var 
  oldAnswer: String;
Begin
  If myTree.Size >= TREE_MAX - 1 Then
    writeln('Tree is full (max ', TREE_MAX, ')!')
  Else
    Begin
      // Store the old answer value from the node
      oldAnswer := node^.Value;

      // The current node becomes a question node
      node^.Value := newQuestion;

      // Create new nodes for the answers
      // Right -> 'yes' branch for the new answer
      new(node^.Right);
      node^.Right^.Value := newAnswer;
      node^.Right^.Left := Nil;
      node^.Right^.Right := Nil;

      // Left -> 'no' branch for the old answer
      new(node^.Left);
      node^.Left^.Value := oldAnswer;
      node^.Left^.Left := Nil;
      node^.Left^.Right := Nil;

      myTree.Size := myTree.Size + 2;
    End;
End;

// Play the game
Procedure PlayGame(node: TreeNodePtr);

Var 
  newAnswer, newQuestion: String;
Begin
  // It's a leaf node (an answer) if it has no children
  If (node^.Left = Nil) And (node^.Right = Nil) Then
    Begin
      Writeln('Are you thinking of: ', node^.Value, '? (y/N)');
      readln(input);

      If input = 'y' Then
        Begin
          Writeln('Great! I guessed it!');
        End
      Else
        Begin
          Writeln('You win! What were you thinking of?');
          readln(newAnswer);

          Writeln('Please give me a yes/no question that is YES for "', newAnswer, '" and NO for "', node^.Value, '".');
          readln(newQuestion);

          // Call Insert to modify the tree
          Insert(node, newAnswer, newQuestion);

          Writeln('Thank you for teaching me!');
        End;
    End
  Else
    Begin
      Writeln(node^.Value, ' (y/N)');
      readln(input);

      If input = 'y' Then
        Begin
          If node^.Right <> Nil Then
            PlayGame(node^.Right)
          Else
            Writeln('Error: No "yes" path from this question.');
        End
      Else
        Begin
          If node^.Left <> Nil Then
            PlayGame(node^.Left)
          Else
            Writeln('Error: No "no" path from this question.');
        End;
    End;
End;

// Main
Begin
  Init();

  Repeat
    clrscr;

    // Display menu
    Writeln('Binary Tree Game');
    Writeln('=======================');
    Writeln;
    Writeln('Enter the operation mode: ');
    Writeln('-------------------------');
    Writeln('1. Play the game!');
    Writeln('2. Display Tree');
    Writeln('0. Exit');
    Writeln;
    write('Option: ');
    readln(op);

    // Switch case for each operation
    Case op Of 
      1: PlayGame(myTree.Root);
      2: DisplayTree(myTree.Root, 0);
      0: writeln('Exiting...');
      Else writeln('Invalid option. Please try again.');
    End;

    // Wait for user input
    writeln('Press Enter to continue...');
    readln;
  Until op = 0;
End.
