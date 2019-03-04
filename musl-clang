#!/bin/sh
#
# musl-clang: A clang wrapper for musl C library.
#             Supports static linking. (-static)
#
# WARNING: This is not a perfect drop-in replacement
#
# See LICENSE file for copyright and license details.
#

set -e
set -u

arch=$(uname -m)

incdir="/usr/include/$arch-linux-musl"
if [ ! -d "$incdir" ]; then
	echo "invalid include directory: $incdir" >/dev/stderr
	exit 1
fi

libdir="/usr/lib/$arch-linux-musl"
if [ ! -d "$libdir" ]; then
	echo "invalid lib directory: $libdir" >/dev/stderr
	exit 1
fi

CPP=no
case "$0" in
	*++) CPP=yes ;;
esac

if [ "${CPP}" = "yes" ]; then
	CLANG=${REALCLANGPP:-"clang++"}
else
	CLANG=${REALCLANG:-"clang"}
fi

hasNo() {
	pat="$1"
	shift 1

	for e in "$@"; do
		if [ "$e" = "$pat" ]; then
			return 1
		fi
	done
	return 0
}

ARGS="-nostdinc"
TAIL=""

if hasNo '-nostdinc' "$@"; then
	ARGS="$ARGS -isystem $incdir"
fi

if \
	hasNo '-c' "$@" && \
	hasNo '-S' "$@" && \
	hasNo '-E' "$@"
then
	ARGS="$ARGS -nostdlib"
	ARGS="$ARGS -Wl,-dynamic-linker=$libdir/libc.so"
	ARGS="$ARGS -L$libdir"

	if hasNo '-nostartfiles' "$@" && \
	   hasNo '-nostdlib' "$@" && \
	   hasNo '-nodefaultlibs' "$@"
	then
		ARGS="$ARGS $libdir/crt1.o"
		ARGS="$ARGS $libdir/crti.o"

		TAIL="$TAIL $libdir/crtn.o"
	fi

	if hasNo '-nostdlib' "$@" && \
	   hasNo '-nodefaultlibs' "$@"
	then
		if [ "$CPP" = "yes" ]; then
			TAIL="$TAIL -lc++"
			TAIL="$TAIL -lunwind"
			TAIL="$TAIL -lm"
		fi
		TAIL="$TAIL -lc"
	fi
fi

exec "$CLANG" $ARGS "$@" $TAIL

