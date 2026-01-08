CC ?= gcc
CFLAGS ?= -Wall -Wextra -std=c99
DEBUG ?= 1
DAYS := $(basename $(wildcard day*.c))

ifeq ($(DEBUG), 1)
	CFLAGS += -g
else
	CFLAGS += -O2
endif

.PHONY: all clean

all: $(DAYS)

day%: day%.c
	$(CC) -o $@ $(CFLAGS) $<

clean:
	rm -f $(DAYS)
