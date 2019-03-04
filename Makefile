DESTDIR?=	${HOME}
BINDIR?=	/bin/scripts

INSTALL =	install

all:
	@echo "Use `make install` to install the script"
.PHONY:	all

install:
	${INSTALL} -C musl-clang.sh ${DESTDIR}${BINDIR}/musl-clang
.PHONY:	install
