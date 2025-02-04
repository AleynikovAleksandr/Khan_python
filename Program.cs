using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Minesweeper
{
    class Program
    {
        static ConsoleColor[] BombColorAmount =
        {
            ConsoleColor.DarkGray,
            ConsoleColor.DarkCyan,
            ConsoleColor.DarkGreen,
            ConsoleColor.Red,
            ConsoleColor.Magenta,
            ConsoleColor.Yellow,
            ConsoleColor.White,
            ConsoleColor.White,
            ConsoleColor.White,
            ConsoleColor.White
        };
        static int[,] GenerateField(int x, int y) {
            int[,] field = new int[x,y];
            Random rnd = new Random();
            int Bombs = Convert.ToInt32((x * y) / 10);
            int BombsLeft = Bombs;
            for (int i = 0; i < x; i++)
            {
                for (int v = 0; v < y; v++)
                {
                    field[i, v] = 0;
                }
            }
            while (BombsLeft > 0)
            {
                for (int i = 0; i < x; i++)
                {
                    for (int v = 0; v < y; v++)
                    {
                        int mark = field[i, v];
                        int BombSpawn = rnd.Next(1, 100);
                        if (mark == 0 & BombSpawn <= 5 & BombsLeft > 0)
                        {
                            BombsLeft -= 1;
                            field[i, v] = -1;
                        }
                    }
                }
            };
            for (int i = 0; i < x; i++)
            {
                for (int v = 0; v < y; v++)
                {
                    int Cell = field[i, v];
                    if (Cell == 0)
                    {
                        int BombsAround = 0;
                        for (int c1 = -1; c1 <= 1; c1 += 1)
                        {
                            for (int c2 = -1; c2 <= 1; c2 += 1)
                            {
                                int CalculateX = i + c1;
                                int CalculateY = v + c2;
                                bool InGame = true;
                                if (CalculateX > x - 1 | CalculateX < 0 | CalculateY > y - 1 | CalculateY < 0)
                                {
                                    InGame = false;
                                };
                                if (InGame)
                                {
                                    int IsBomb = field[CalculateX, CalculateY];
                                    if (IsBomb == -1)
                                    {
                                        BombsAround += 1;
                                    };
                                };
                            };
                        };
                        field[i, v] = BombsAround;
                    };
                }
            }
            return field;
        }
        static void ColorPrint(string text, ConsoleColor color, int mode = 0)
        {
            ConsoleColor originalColor = Console.ForegroundColor;
            Console.ForegroundColor = color;

            Console.Write(mode == 0 ? text + Environment.NewLine : text);

            Console.ForegroundColor = originalColor;
        }
        static void OpenCell(int[,] Field, bool[,] OpenedCells, bool[,] Flagged, int SelX, int SelY)
        {
            if (Flagged[SelX, SelY] || OpenedCells[SelX, SelY]) return;
            
            OpenedCells[SelX, SelY] = true;
            
            if (Field[SelX, SelY] != 0) return;

            for (int i = -1; i <= 1; i++)
            for (int j = -1; j <= 1; j++)
            {
                if (i == 0 && j == 0) continue;

                int NewX = SelX + i, NewY = SelY + j;
                if (NewX >= 0 && NewY >= 0 && NewX < OpenedCells.GetLength(0) && NewY < OpenedCells.GetLength(1))
                    OpenCell(Field, OpenedCells, Flagged, NewX, NewY);
            }
        }
        static void Main(string[] args)
        {
            string FlagMark = "F", BombMark = "B", ClosedMark = "*";
            int MinField = 6, MaxField = 20;
            Random rnd = new Random();

            Console.ReadLine();
            Console.Clear();

            Console.WriteLine("Введите количество строк:");
            int XCount = Math.Clamp(Convert.ToInt32(Console.ReadLine()), MinField, MaxField);

            Console.WriteLine("Введите количество столбцов:");
            int YCount = Math.Clamp(Convert.ToInt32(Console.ReadLine()), MinField, MaxField);

            int[,] GameField = GenerateField(XCount, YCount);
            int Bombs = GameField.Cast<int>().Count(cell => cell == -1);
            
            bool GameOver = false;
            bool Winner = false;
            bool[,] opened = new bool[XCount, YCount];
            bool[,] flagged = new bool[XCount, YCount];
            int SelX = 0;
            int SelY = 0;
            
            while (GameOver == false)
            {
                Console.Clear();
                int totalopen = 0;

                for (int i = 0; i < XCount; i++)
                {
                    for (int v = 0; v < YCount; v++)
                    {
                        bool IsOpen = opened[i, v];
                        bool IsFlagged = flagged[i, v];
                        ConsoleColor help = SelX == i && SelY == v ? ConsoleColor.Green : IsFlagged ? ConsoleColor.Yellow : ConsoleColor.White;

                        if (IsOpen)
                        {
                            int Code = GameField[i, v];
                            if (Code == -1) GameOver = true;
                            ColorPrint(Code + " ", help == ConsoleColor.White ? BombColorAmount[Code] : help, 1);
                            totalopen++;
                        }
                        else if (IsFlagged)
                        {
                            ColorPrint(FlagMark + " ", help, 1);
                        }
                        else
                        {
                            ColorPrint(ClosedMark + " ", help, 1);
                        }
                    }
                    Console.WriteLine();
                }

                if (totalopen == (XCount * YCount - Bombs))
                {
                    GameOver = true;
                    Winner = true;
                }
                else if (GameOver)
                {
                    break;
                }

                ConsoleKeyInfo userinput = Console.ReadKey();
                SelX += userinput.Key == ConsoleKey.DownArrow ? 1 : userinput.Key == ConsoleKey.UpArrow ? -1 : 0;
                SelY += userinput.Key == ConsoleKey.RightArrow ? 1 : userinput.Key == ConsoleKey.LeftArrow ? -1 : 0;

                if (SelX >= XCount) { SelX = XCount-1; } else if (SelX < 0) { SelX = 0; };
                if (SelY >= YCount) { SelY = YCount-1; } else if (SelY < 0) { SelY = 0; };
                if (userinput.Key == ConsoleKey.Enter)
                {
                    OpenCell(GameField, opened, flagged, SelX, SelY);
                }
                else if (userinput.Key == ConsoleKey.Escape)
                {
                    GameOver = true;
                }
                else if (userinput.Key == ConsoleKey.F)
                {
                    if (opened[SelX,SelY] == false) {
                        flagged[SelX, SelY] = !flagged[SelX, SelY];
                    };
                }
            };
            Console.Clear();
            for (int i = 0; i < XCount; i++)
            {
                for (int v = 0; v < YCount; v++)
                {
                    int Code = GameField[i, v];
                    ColorPrint(Code == -1 ? BombMark + " " : Code + " ", Code == -1 ? ConsoleColor.DarkRed : BombColorAmount[Code], 1);
                }
                Console.WriteLine();
            }
            Console.WriteLine(Winner ? "Вы победили!" : "Вы проиграли :(");
            Console.ReadLine();
        }
    }
}