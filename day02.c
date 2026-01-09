#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define INPUT_PATH "input/day02.txt"

long unsigned half_split_invalid_ids = 0;
long unsigned at_least_twice_invalid_ids = 0;

void solve(long unsigned min, long unsigned max)
{
  for (long unsigned i = min; i <= max; ++i)
  {
    char id_digit[32];
    sprintf(id_digit, "%lu", i);
    int digit_len = strlen(id_digit);
    int mid = digit_len / 2;
    for (int j = 1; j < mid + 1; ++j)
    {
      if (digit_len % j != 0)
        continue;

      if (digit_len % 2 == 0)
      {
        if (memcmp(id_digit, id_digit + mid, mid) == 0)
        {
          half_split_invalid_ids += i;
          at_least_twice_invalid_ids += i;
          break;
        }
      }

      int parts = digit_len / j;
      int k = j;
      int pair = 1;
      while (k < digit_len)
      {
        if (memcmp(id_digit, id_digit + k, j) != 0)
          break;

        k += j;
        ++pair;
      }

      if (pair == parts)
      {
        at_least_twice_invalid_ids += i;
        break;
      }
    }
  }
}

int main(void)
{
  FILE *input = fopen(INPUT_PATH, "r");
  if (input == NULL)
    return 1;

  char line[1024];
  while (fgets(line, sizeof(line), input) != NULL)
  {
  }
  line[strcspn(line, "\n")] = 0;
  fclose(input);

  char *ids = strtok(line, ",");
  while (ids != NULL)
  {
    long unsigned min;
    long unsigned max;
    sscanf(ids, "%lu-%lu", &min, &max);

    solve(min, max);

    ids = strtok(NULL, ",");
  }

  printf("a: %lu\n", half_split_invalid_ids);
  printf("b: %lu\n", at_least_twice_invalid_ids);
  return 0;
}
