#include <stdio.h>

int wraps_to_zeros = 0;
int dial = 50;
int zeros = 0;

void solve(char turn_dir, int turn_amount)
{
  if (turn_dir == 'R')
  {
    int total = dial + turn_amount;
    wraps_to_zeros += total / 100;
    dial = (dial + turn_amount) % 100;
  }
  else
  {
    int start_step = dial == 0 ? 100 : dial;
    if (turn_amount >= start_step)
    {
      wraps_to_zeros += 1 + ((turn_amount - start_step) / 100);
    }
    dial -= turn_amount % 100;
    if (dial < 0)
      dial += 100;
  }
}

int main(void)
{
  FILE *input = fopen("input/day01.txt", "r");
  if (input == NULL)
    return 1;

  char line[16];
  while (fgets(line, sizeof(line), input) != NULL)
  {
    char turn_dir;
    int turn_amount;
    sscanf(line, "%c%d", &turn_dir, &turn_amount);

    solve(turn_dir, turn_amount);
    if (dial == 0)
      ++zeros;
  }

  printf("a: %d\n", zeros);
  printf("b: %d\n", wraps_to_zeros);
  fclose(input);
  return 0;
}
