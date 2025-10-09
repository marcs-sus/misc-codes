using System;

class Program
{
    static void Main()
    {
        Console.Clear();
        // Start of the program

        Random random = new Random();
        int heroHP = 100,
            monsterHP = 100;
        bool isHeroDefending = false,
            isMonsterDefending = false;

        while (heroHP > 0 && monsterHP > 0)
        {
            Console.WriteLine($"Hero's health: {heroHP}\tMonster's health: {monsterHP}");
            Console.WriteLine("What do you want to do?\n1. Attack\t2. Defend\t3. Heal");

            isHeroDefending = false;
            
            bool validInput;
            do
            {
                validInput = true;
                string? input = Console.ReadLine();

                // Hero's turn
                if (int.TryParse(input, out int action))
                {
                    if (action == 1) // Attack
                    {
                        int damage = random.Next(1, 10);
                        if (isMonsterDefending)
                        {
                            Console.WriteLine($"The monster defended your {damage} damage attack!");
                            damage /= 2;
                        }
                        monsterHP -= damage;
                        Console.WriteLine($"You hit the monster for {damage} damage!");
                    }
                    else if (action == 2) // Defend
                    {
                        isHeroDefending = true;
                        Console.WriteLine("You prepare to defend.");
                    }
                    else if (action == 3) // Heal
                    {
                        int heal = random.Next(1, 10);
                        heroHP += heal;
                        if (heroHP > 100)
                            heroHP = 100;
                        Console.WriteLine($"You healed for {heal} health!");
                    }
                    else
                    {
                        Console.WriteLine("Invalid action! Please choose 1, 2, or 3.");
                        validInput = false;
                    }
                }
                else
                {
                    Console.WriteLine("Invalid input! Please enter a number.");
                    validInput = false;
                }
            } while (validInput == false);

            // Monster's turn
            int monsterAction = random.Next(1, 4);
            isMonsterDefending = false;

            if (monsterAction == 1) // Attack
            {
                int damage = random.Next(1, 10);
                if (isHeroDefending)
                {
                    Console.WriteLine($"You defended the monster's {damage} damage attack!");
                    damage /= 2;
                }
                heroHP -= damage;
                Console.WriteLine($"The monster hit you for {damage} damage!");
            }
            else if (monsterAction == 2) // Defend
            {
                isMonsterDefending = true;
                Console.WriteLine("The monster is preparing to defend.");
            }
            else if (monsterAction == 3) // Heal
            {
                int heal = random.Next(1, 10);
                monsterHP += heal;
                if (monsterHP > 100)
                    monsterHP = 100;
                Console.WriteLine($"The monster healed for {heal} health!");
            }

            Console.WriteLine("\n");
        }

        // End of the battle
        Console.WriteLine("Battle over!");
        if (heroHP <= 0)
            Console.WriteLine("The Monster won!");
        else
            Console.WriteLine("You won!");
    }
}