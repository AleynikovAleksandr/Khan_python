import random

VALUES = ('2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A')
SUITS = ('Spades', 'Clubs', 'Diamonds', 'Hearts')
SUITS_UNI = {
    'Spades': '♠',
    'Clubs': '♣',
    'Diamonds': '♦',
    'Hearts': '♥'
}

class Card:
    def __init__(self, value, suit):
        self.value = value
        self.suit = suit

    def __str__(self):
        return f"{self.value}{SUITS_UNI[self.suit]}"

    def __lt__(self, other):
        return VALUES.index(self.value) < VALUES.index(other.value)

    def __gt__(self, other):
        return VALUES.index(self.value) > VALUES.index(other.value)

class Deck:
    def __init__(self):
        self.cards = [Card(value, suit) for suit in SUITS for value in VALUES]
        self.shuffle()

    def shuffle(self):
        random.shuffle(self.cards)

    def draw(self, x):
        drawn_cards = self.cards[:x]
        self.cards = self.cards[x:]
        return drawn_cards

class Player:
    def __init__(self, name):
        self.name = name
        self.hand = []

    def take_cards(self, cards):
        self.hand.extend(cards)

    def play_smallest_card(self):
        smallest_card = min(self.hand, key=lambda card: VALUES.index(card.value))
        self.hand.remove(smallest_card)
        return smallest_card

    def try_to_beat(self, card):
        beating_cards = [c for c in self.hand if c.suit == card.suit and c > card]
        if beating_cards:
            chosen_card = min(beating_cards, key=lambda card: VALUES.index(card.value))
            self.hand.remove(chosen_card)
            return chosen_card
        return None

    def can_throw_in(self, played_cards):
        return [c for c in self.hand if c.value in [card.value for card in played_cards]]

    def throw_in(self, played_cards):
        throw_in_cards = self.can_throw_in(played_cards)
        if throw_in_cards:
            chosen_card = throw_in_cards[0]
            self.hand.remove(chosen_card)
            return chosen_card
        return None

def show_hands(player1, player2, initial=False):
    stage = "Начальные карты" if initial else "Текущие карты"
    print(f"{stage}: {player1.name}: " + ", ".join(str(card) for card in player1.hand))
    print(f"{stage}: {player2.name}: " + ", ".join(str(card) for card in player2.hand))

def ensure_full_hand(player, deck):
    if len(player.hand) < 10 and len(deck.cards) > 0:
        cards_to_draw = min(10 - len(player.hand), len(deck.cards))
        player.take_cards(deck.draw(cards_to_draw))
        print(f"{player.name} добрал {cards_to_draw} карт(ы), теперь у него {len(player.hand)} карт.")

def main():
    deck = Deck()
    player1 = Player("Игрок 1")
    player2 = Player("Игрок 2")
    player1.take_cards(deck.draw(10))
    player2.take_cards(deck.draw(10))
    show_hands(player1, player2, initial=True)

    attacker, defender = player1, player2
    played_cards = []

    while player1.hand and player2.hand:
        print(f"\n{attacker.name} ходит...")
        attacking_card = attacker.play_smallest_card()
        played_cards.append(attacking_card)
        print(f"{attacker.name} выложил {attacking_card}")

        beaten_card = defender.try_to_beat(attacking_card)
        if beaten_card:
            print(f"{defender.name} побил {attacking_card} картой {beaten_card}")
            played_cards.append(beaten_card)
            throw_in_card = attacker.throw_in(played_cards)
            if throw_in_card:
                print(f"{attacker.name} подкинул {throw_in_card}")
                played_cards.append(throw_in_card)
                beaten_card = defender.try_to_beat(throw_in_card)
                if beaten_card:
                    print(f"{defender.name} побил {throw_in_card} картой {beaten_card}")
                    played_cards.append(beaten_card)
                else:
                    print(f"{defender.name} не смог побить карту {throw_in_card} и забирает все карты.")
                    defender.take_cards(played_cards)
                    played_cards.clear()
                    ensure_full_hand(defender, deck)
                    ensure_full_hand(attacker, deck)
                    continue
            else:
                print(f"{defender.name} отбился!")
        else:
            print(f"{defender.name} не смог побить карту {attacking_card} и забирает её.")
            defender.take_cards(played_cards)
            played_cards.clear()

        ensure_full_hand(defender, deck)
        ensure_full_hand(attacker, deck)
        show_hands(player1, player2)

        if not player1.hand:
            print(f"\n{player1.name} выиграл!")
            return
        elif not player2.hand:
            print(f"\n{player2.name} выиграл!")
            return

        attacker, defender = defender, attacker

if __name__ == "__main__":
    main()