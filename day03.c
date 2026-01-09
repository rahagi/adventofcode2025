#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define INPUT_PATH "input/day03.txt"

int two_joltages_sum = 0;
long unsigned series_joltages_sum = 0;

void solve_a(char *bank)
{
  int len = strlen(bank);

  int first_bty = 0;
  int second_bty = 0;
  for (int i = 0; i < len; ++i)
  {
    int joltage = bank[i] - '0';
    if (joltage > first_bty && i < len - 1)
    {
      first_bty = joltage;
      second_bty = 0;
    }
    else if (joltage > second_bty)
    {
      second_bty = joltage;
    }
  }
  int total_joltage = (first_bty * 10) + second_bty;
  two_joltages_sum += total_joltage;
}

void solve_b(char *bank)
{
  int len = strlen(bank);

  char active_batteries[13];
  int max = 0;
  int last_max_pos = 0;
  for (int i = 0; i < 12; ++i)
  {
    int last_possible_pos = len - 12 + i + 1;
    for (int j = last_max_pos; j < last_possible_pos; ++j)
    {
      int joltage = bank[j] - '0';
      if (joltage > max)
      {
        max = joltage;
        active_batteries[i] = bank[j];
        last_max_pos = j + 1;
      }
    }
    max = 0;
  }
  active_batteries[12] = '\0';

  long series = atoll(active_batteries);
  series_joltages_sum += series;
}
int main(void)
{
  FILE *input = fopen(INPUT_PATH, "r");
  if (input == NULL)
    return 1;

  char bank[1024];
  while (fgets(bank, sizeof(bank), input))
  {
    bank[strcspn(bank, "\n")] = 0;
    solve_a(bank);
    solve_b(bank);
  }

  printf("a: %d\n", two_joltages_sum);
  printf("b: %lu\n", series_joltages_sum);
  fclose(input);
  return 0;
}
