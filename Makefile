PROGNM  =  pandabin
PREFIX  ?= /home/halosghost
DOCDIR  ?= $(DESTDIR)$(PREFIX)/share/man
LIBDIR  ?= $(DESTDIR)$(PREFIX)/lib
BINDIR  ?= $(DESTDIR)$(PREFIX)/bin

.PHONY: all clean gen clang-analyze cov-build simple install uninstall

all: dist
	@tup upd

clean:
	@rm -rf -- dist cov-int $(PROGNM).tgz make.sh ./src/*.plist

dist:
	@mkdir -p ./dist

gen: clean
	@tup generate make.sh

cov-build: gen dist
	@cov-build --dir cov-int ./make.sh
	@tar czvf $(PROGNM).tgz cov-int

clang-analyze:
	@(pushd ./src; clang-check -analyze ./*.c)

simple: gen dist
	@./make.sh

install:
	@install -Dm755 dist/$(PROGNM)   $(BINDIR)/$(PROGNM)

uninstall:
	@rm -f $(BINDIR)/$(PROGNM)

include Makeeaster
