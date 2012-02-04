#! /bin/bash 

print_greatings()
{
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo -en "+"
    echo -en "\033[01;32m DNAOS Toolchain Testing                               \033[00m"
    echo "+"
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
}

print_step()
{
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo -en "\033[01;32m"
	echo " "$1
	echo -en "\033[00m"
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
}

error()
{
	echo -en "\033[01;31m"
    echo "!---------------------------------!"
    echo "! ERROR $1"
    echo "!---------------------------------!"
    echo -en " \033[00m"

	exit
}

BASEDIR=${PWD}

ARCHS="arm mips microblaze c6x x86"
BUILD_SCRIPT=./build_xtools

BUILD_DIR=/tmp/xtools_tests/

print_greatings

mkdir -p ${BUILD_DIR}
cd ${BASEDIR}/..

for arch in ${ARCHS} ; do

	print_step "Building "$arch
	${BUILD_SCRIPT} ${arch} ${BUILD_DIR}/xtools_${arch} || error $arch

	# add compilation tests HERE
	

	rm -fr ${BASEDIR}/../build-*

done

rm -fr ${BUID_DIR}
