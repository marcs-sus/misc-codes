using System;
using System.Collections.Generic;
using System.Linq;

namespace StandardCardDeck
{
    public enum Suit
    {
        Hearts,
        Diamonds,
        Clubs,
        Spades
    }

    public enum Rank
    {
        Two,
        Three,
        Four,
        Five,
        Six,
        Seven,
        Eight,
        Nine,
        Ten,
        Jack,
        Queen,
        King,
        Ace
    }

    public class Card
    {
        public Suit Suit { get; }
        public Rank Rank { get; }
        public string Name => $"{Rank} of {Suit}";

        public Card(Suit suit, Rank rank)
        {
            Suit = suit;
            Rank = rank;
        }
    }

    public class Deck
    {
        private List<Card> _cards;

        public Deck()
        {
            _cards = new List<Card>();
            InitializeDeck();
        }

        private void InitializeDeck()
        {
            foreach (Suit suit in Enum.GetValues(typeof(Suit)))
            {
                foreach (Rank rank in Enum.GetValues(typeof(Rank)))
                {
                    _cards.Add(new Card(suit, rank));
                }
            }
        }

        public void Shuffle()
        {
            Random rng = new Random();
            int n = _cards.Count;

            while (n > 1)
            {
                n--;
                int randN = rng.Next(n + 1);
                Card temp = _cards[randN];
                _cards[randN] = _cards[n];
                _cards[n] = temp;
            }
        }

        public Card DrawCard()
        {
            if (_cards.Count == 0)
                throw new InvalidOperationException("Empty deck!");

            Card card = _cards[0];
            _cards.RemoveAt(0);
            return card;
        }

        public void PrintDeck()
        {
            foreach (Card card in _cards)
            {
                Console.WriteLine(card.Name);
            }
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            Deck deck = new Deck();
            deck.Shuffle();

            Console.WriteLine("----- 52 Card Deck -----");
            Console.WriteLine("Drawing 5 cards:");
            for (int i = 0; i < 5; i++)
            {
                Card drawnCard = deck.DrawCard();
                Console.WriteLine(drawnCard.Name);
            }

            Console.WriteLine("\nRemaining cards in deck:");
            deck.PrintDeck();

            Console.WriteLine("\nPress any key to exit...");
            Console.ReadKey();
        }
    }
}
