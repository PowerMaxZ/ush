NAME = ush

SRCD = src
INCD = inc
OBJD = obj
LBMXD = libmx

LMBX = libmx.a
INC = ush.h
SRC = mx_ush.c \
	  mx_unset.c \

INCLUDE = -I $(LBMXD) \
	-I $(INCD) \

LBMXS = $(addprefix $(LBMXD)/, $(LMBX))
INCS = $(addprefix $(INCD)/, $(INC))
SRCS = $(addprefix $(SRCD)/, $(SRC))
OBJS = $(addprefix $(OBJD)/, $(SRC:%.c=%.o))
	
CFLAGS = -std=c99 $(addprefix -W, all extra error pedantic)
CC = clang

all: $(NAME)

install: $(NAME) clean

$(LBMXS):
	@make -sC $(LBMXD)

$(NAME): $(OBJS) $(LBMXS)
	@$(CC) $(CFLAGS) $(LBMXS) $(OBJS) -o $@
	@printf "\x1b[32;1m$@ created\x1b[0m\n"

$(OBJD)/%.o: $(SRCD)/%.c $(INCS)
	@$(CC) $(CFLAGS) -c $< -o $@ $(INCLUDE)
	@printf "\x1b[32mcompiled: \x1b[0m[$(<:$(SRCD)/%.c=%.c)]\n"

$(OBJS): | $(OBJD)

$(OBJD):
	@mkdir -p $@

uninstall: clean
	@make -sC $(LBMXD) $@
	@rm -rf $(NAME)
	@printf "\x1b[34;1mdeleted $(NAME)\x1b[0m\n"

clean:
	@make -sC $(LBMXD) $@
	@rm -rf $(OBJD)
	@printf "\x1b[34;1mdeleted $(OBJD)\x1b[0m\n"

reinstall: uninstall install
