#!/bin/sh

suppressions=""

# readdir_r is depreciated - see readdir_r(3)
suppressions="${suppressions} --suppress=readdirCalled"

# no need for strtok threadsafety in t2conf.c
suppressions="${suppressions} --suppress=strtokCalled:src/t2conf.c"

suppressions="${suppressions} --suppress=missingIncludeSystem"

# Sticking to C89 kernel style throws these errors - but not a problem
suppressions="${suppressions} --suppress=variableScope"

# vsnprintf() is used in accordance with the man page
suppressions="${suppressions} --suppress=nullPointer:src/jgmenu-obtheme.c:58"

#suppressions="${suppressions} --suppress="

cppcheck \
	--inconclusive \
	--enable=all \
	-DVERSION=3.4 \
	-I src/ \
	--std=c99 \
	--std=posix \
	--quiet \
	${suppressions} \
	$@ \
	src/*.c