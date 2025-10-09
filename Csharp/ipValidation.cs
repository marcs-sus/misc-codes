using System;

class Program
{
    static void Main()
    {
        Console.Clear();
        // Start of the program

        string? ipv4Input;
        bool validInput;

        Console.WriteLine("Enter an IPv4 address to be validated: ");
        do
        {
            validInput = true;
            ipv4Input = Console.ReadLine();

            if (ipv4Input == null || ipv4Input == "" || ipv4Input == ".")
            {
                ipv4Input = "";
                Console.WriteLine("Enter a valid string input");
                validInput = false;
            }
            else
            {
                foreach (char digit in ipv4Input)
                {
                    if (!char.IsDigit(digit) && digit != '.')
                    {
                        Console.WriteLine("The input may only contain digits and periods");
                        validInput = false;
                        break;
                    }
                }
            }
        } while (validInput == false);

        if (ValidateIPv4(ipv4Input))
        {
            Console.WriteLine($"{ipv4Input} is a valid IPv4 address");
        }
        else
        {
            Console.WriteLine($"{ipv4Input} is NOT a valid IPv4 address");
        }


        bool ValidateIPv4(string ip)
        {
            string[] address = ip.Split(".", StringSplitOptions.RemoveEmptyEntries);

            if (ValidateLength() && ValidateZeroes() && ValidateRange())
            {
                return true;
            }
            else
            {
                return false;
            }

            bool ValidateLength()
            {
                if (address.Length == 4)
                    return true;
                else
                    return false;
            }

            bool ValidateZeroes()
            {
                foreach (string num in address)
                {
                    if (num.Length > 1 && num.StartsWith("0"))
                    {
                        return false;
                    }
                }
                return true;
            }

            bool ValidateRange()
            {
                foreach (string num in address)
                {
                    int value = int.Parse(num);
                    if (value < 0 || value > 255)
                    {
                        return false;
                    }
                }
                return true;
            }
        }
    }
}