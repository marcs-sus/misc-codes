using System;

class Program
{
    static void Main()
    {
        Console.Clear();
        // Start of the program

        Random random = new Random();

        Console.WriteLine("Let's play a little game!!");
        PlayGame(prize: random.Next(1000, 10000));

        void PlayGame(int target = 1, double prize = 0)
        {
            int roll = random.Next(1, 7);

            Console.WriteLine($"\nRoll a number greater than {target} to win!\nYou rolled a {roll}");

            if (target < roll && target == 5)
            {
                Console.WriteLine($"You won {prize:C2}, the biggest prize!\nPlay again? (Y/N)");
                if (Console.ReadKey().Key == ConsoleKey.Y)
                    PlayGame(prize: random.Next(1000, 10000));
            }
            else if (target < roll && target < 6)
            {
                Console.WriteLine($"You won {prize:C2}!\nDouble or nothing? (Y/N)");
                if (Console.ReadKey().Key == ConsoleKey.Y)
                {
                    PlayGame(target += 1, prize *= 2);
                    prize *= 2;
                }
            }
            else if (target >= roll)
            {
                Console.WriteLine($"You lose!\nPlay again? (Y/N)");
                if (Console.ReadKey().Key == ConsoleKey.Y)
                    PlayGame(prize: random.Next(1000, 10000));
            }
        }
    }
}