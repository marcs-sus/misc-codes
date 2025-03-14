using System;

public class MyStack
{
    private const int MAX = 100;
    public char[] _stack = new char[MAX];
    public int _top = 0;

    private bool IsFull()
    {
        return _top == MAX;
    }

    private bool IsEmpty()
    {
        return _top == 0;
    }

    public void Push(char input)
    {
        if (IsFull())
        {
            Console.WriteLine("Stack is full");
            return;
        }

        _stack[_top++] = input;
    }

    public char Pop()
    {
        if (IsEmpty())
        {
            Console.WriteLine("Stack is empty");
            return '\0';
        }

        return _stack[--_top];
    }
}

public class WordReverser
{
    public string ReverseWords(string input, MyStack stack)
    {
        string result = "";

        for (int i = 0; i < input.Length; i++)
        {
            if (input[i] != ' ')
                stack.Push(input[i]);
            else
            {
                while (stack._top > 0)
                    result += stack.Pop();

                result += ' ';
            }
        }

        while (stack._top > 0)
            result += stack.Pop();

        return result;
    }
}

public class Program
{
    public static void Main(string[] args)
    {
        Console.Clear();
        // Start of the program

        MyStack stack = new MyStack();
        WordReverser wordReverser = new WordReverser();
        string result = "";

        Console.WriteLine("Enter a sentence to reverse its words: ");

        string? input;
        do
        {
            Console.WriteLine("Please enter a valid sentence: ");
            input = Console.ReadLine();
        } while (string.IsNullOrEmpty(input));

        try
        {
            result = wordReverser.ReverseWords(input, stack);
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex);
        }

        Console.WriteLine($"The reversed sentence is: {result}");
    }
}