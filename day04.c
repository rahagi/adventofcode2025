#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define INPUT_PATH "input/day04.txt"

typedef struct Map Map;
struct Map
{
  char **lines;
  int len;
  int cap;
};

int accesible_paths = 0;
int removed_papers = 0;

int is_accessible(int i, int j, Map *map)
{
  int papers = 0;

  int deltas[3] = {-1, 0, 1};
  for (int x = 0; x < 3; ++x)
  {
    int di = deltas[x];
    for (int y = 0; y < 3; ++y)
    {
      int dj = deltas[y];

      int ci = i + di;
      if (ci < 0 || ci > map->len - 1)
        continue;

      int cj = j + dj;
      if (cj < 0 || cj > (int)strlen(map->lines[0]) - 1)
        continue;

      if (map->lines[ci][cj] == '@')
        ++papers;
    }
  }

  return papers <= 4 ? 1 : 0;
}

void solve(Map *map)
{
  int lap = 1;
  while (1)
  {
    int removed = 0;
    for (int i = 0; i < map->len; ++i)
    {
      char *line = map->lines[i];
      int len = strlen(line);
      for (int j = 0; j < len; ++j)
      {
        char maybe_paper = line[j];
        if (maybe_paper != '@')
          continue;
        if (is_accessible(i, j, map))
        {
          ++removed;
          if (lap == 1)
          {
            ++accesible_paths;
          }
          else
          {
            map->lines[i][j] = '.';
          }
        }
      }
    }
    if (removed == 0)
      break;
    if (lap > 1)
      removed_papers += removed;
    ++lap;
  }
}

int main(void)
{
  FILE *input = fopen(INPUT_PATH, "r");
  if (input == NULL)
    return 1;

  Map map = {0};
  char buffer[1024];
  while (fgets(buffer, sizeof(buffer), input) != NULL)
  {
    buffer[strcspn(buffer, "\n")] = 0;
    if (map.len >= map.cap)
    {
      if (map.cap == 0)
        map.cap = 16;
      else
        map.cap *= 2;
      map.lines = realloc(map.lines, map.cap * sizeof(*map.lines));
    }

    size_t len = strlen(buffer);
    char *line = malloc(len + 1);
    memcpy(line, buffer, len + 1);
    map.lines[map.len++] = line;
  }

  solve(&map);

  printf("a: %d\n", accesible_paths);
  printf("b: %d\n", removed_papers);
  fclose(input);
  return 0;
}
