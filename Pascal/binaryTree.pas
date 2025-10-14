
Program BinaryTree;
// Simulate a binary tree data structure in Pascal

Uses crt, sysutils;

Const 
  TREE_MAX = 10;
  RANDOM_MAX = 100;

Type 
  TreeNodePtr = ^TreeNode;
  TreeNode = Record
    Value: Integer;
    Left, Right: TreeNodePtr;
  End;

  TreeType = Record
    Root: TreeNodePtr;
    Size: Integer;
  End;

Var 
  myTree: TreeType;
  input: Integer;
  op: Integer;

  // Initialize the binary tree
Procedure Init();
Begin
  myTree.Root := Nil;
  myTree.Size := 0;

  input := 0;
  op := 0;
End;

// Helper function to find the minimum value node in a subtree
Function FindMin(node: TreeNodePtr): TreeNodePtr;
Begin
  If node = Nil Then
    FindMin := Nil
  Else
    Begin
      While node^.Left <> Nil Do
        node := node^.Left;
      FindMin := node;
    End;
End;

// Insert a new node into the binary tree
Procedure Insert(Var root: TreeNodePtr; input: Integer);
Begin
  If myTree.Size >= TREE_MAX Then
    Begin
      writeln('Tree is full (max ', TREE_MAX, ').');
      Exit;
    End;
  If root = Nil Then
    Begin
      New(root);
      root^.Value := input;
      root^.Left := Nil;
      root^.Right := Nil;

      myTree.Size := myTree.Size + 1;
    End
  Else If input < root^.Value Then
         Insert(root^.Left, input)
  Else If input > root^.Value Then
         Insert(root^.Right, input)
End;

// Remove a node from the binary tree
Procedure Remove(Var root: TreeNodePtr; input: Integer);

Var 
  temp: TreeNodePtr;
Begin
  If root = Nil Then
    writeln('Value not found in the tree.')
  Else
    Begin
      If input < root^.Value Then
        Remove(root^.Left, input)
      Else If input > root^.Value Then
             Remove(root^.Right, input)
      Else
        Begin
          If root^.Left = Nil Then
            Begin
              temp := root;
              root := root^.Right;
              Dispose(temp);
              myTree.Size := myTree.Size - 1;
            End
          Else If root^.Right = Nil Then
                 Begin
                   temp := root;
                   root := root^.Left;
                   Dispose(temp);
                   myTree.Size := myTree.Size - 1;
                 End
          Else
            Begin
              temp := FindMin(root^.Right);
              root^.Value := temp^.Value;
              Remove(root^.Right, temp^.Value);
            End;
        End;
    End;
End;

// Write the tree in pre-order
Procedure PreOrder(node: TreeNodePtr);
Begin
  If node <> Nil Then
    Begin
      Write(node^.Value, ' - ');
      PreOrder(node^.Left);
      PreOrder(node^.Right);
    End;
End;

// Write the tree in in-order
Procedure InOrder(node: TreeNodePtr);
Begin
  If node <> Nil Then
    Begin
      InOrder(node^.Left);
      Write(node^.Value, ' - ');
      InOrder(node^.Right);
    End;
End;

// Write the tree in post-order
Procedure PostOrder(node: TreeNodePtr);
Begin
  If node <> Nil Then
    Begin
      PostOrder(node^.Left);
      PostOrder(node^.Right);
      Write(node^.Value, ' - ');
    End;
End;

// Display the entire tree
Procedure DisplayTree(node: TreeNodePtr; level: Integer);
Begin
  If node = Nil Then
    Exit;

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


// Display the leaf nodes of the tree
Procedure DisplayLeaves(node: TreeNodePtr);
Begin
  If node <> Nil Then
    Begin
      If (node^.Left = Nil) And (node^.Right = Nil) Then
        Write(node^.Value, ' - ');
      DisplayLeaves(node^.Left);
      DisplayLeaves(node^.Right);
    End;
End;

// Generate a random tree seed
Procedure RandomSeed(max: Integer);

Var 
  i, nodeCount, value: Integer;
Begin
  randomize;
  nodeCount := random(max) + 1;

  Writeln('Generating random tree with ', nodeCount, ' nodes:');
  For i := 1 To nodeCount Do
    Begin
      value := random(RANDOM_MAX + 1);
      Write(value, ' ');
      Insert(myTree.Root, value);
    End;
  Writeln;
End;

// Main
Begin
  Init();

  // Generate random tree nodes
  RandomSeed(6);

  Repeat
    clrscr;

    // Display menu
    Writeln('Binary Tree Simulation');
    Writeln('=======================');
    Writeln;
    Writeln('Enter the operation mode: ');
    Writeln('-------------------------');
    Writeln('1. Insert (add) an element');
    Writeln('2. Remove (remove) an element');
    Writeln('3. Pre-Order Traversal');
    Writeln('4. In-Order Traversal');
    Writeln('5. Post-Order Traversal');
    Writeln('6. Display Tree');
    Writeln('7. Display Leaf Nodes');
    Writeln('0. Exit');
    Writeln;
    Writeln('Current tree size: ', myTree.Size, '/', TREE_MAX);
    write('Option: ');
    readln(op);

    // Switch case for each operation
    Case op Of 
      1:
         Begin
           writeln('Enter a value to insert: ');
           readln(input);
           Insert(myTree.Root, input);
         End;
      2:
         Begin
           writeln('Enter a value to remove: ');
           readln(input);
           Remove(myTree.Root, input);
         End;
      3: PreOrder(myTree.Root);
      4: InOrder(myTree.Root);
      5: PostOrder(myTree.Root);
      6: DisplayTree(myTree.Root, 1);
      7: DisplayLeaves(myTree.Root);
      0: writeln('Exiting...');
      Else writeln('Invalid option. Please try again.');
    End;

    // Wait for user input
    writeln('Press Enter to continue...');
    readln;
  Until op = 0;
End.
