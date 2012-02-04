#! /bin/bash 

APP_DIR=/home/nfournel/projects/APES/apps/ParallelMjpeg.git


# #############################################################################
#  Print Functions
# #############################################################################

if [ -t 1 ] ; then # stdout in terminal
	case "$(tput colors)" in
		256)
			INFO_LINE_COLOR="$(tput bold)$(tput setaf 226)" # Light Yellow
			INFO_TEXT_COLOR="$(tput bold)$(tput setaf 63)"  # Blue
			
			ERROR_LINE_COLOR="$(tput bold)$(tput setaf 9)"  # Red
			ERROR_TEXT_COLOR="$(tput bold)$(tput setaf 9)"  # Red
			NO_COLOR="$(tput sgr0)"
			;;
		*)
			INFO_LINE_COLOR="$(tput bold)$(tput setaf 3)"   # Yellow
			INFO_TEXT_COLOR="$(tput bold)$(tput setaf 6)"   # Blue
			
			ERROR_LINE_COLOR="$(tput bold)$(tput setaf 2)"  # Red
			ERROR_TEXT_COLOR="$(tput bold)$(tput setaf 2)"  # Red
			NO_COLOR="$(tput sgr0)"
			;;
	esac
else # stdout in file !!!
	INFO_LINE_COLOR=""
	INFO_TEXT_COLOR=""
	
	ERROR_LINE_COLOR=""
	ERROR_TEXT_COLOR=""
	
	NO_COLOR=""
fi

print_greatings()
{
    echo -en ${INFO_LINE_COLOR}
    echo     "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo -n  "+"
    echo -en ${INFO_TEXT_COLOR}
	echo -n  " DNAOS Toolchain Testing                              "
    echo -en ${INFO_LINE_COLOR}
    echo     "+"
    echo     "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo -en ${NO_COLOR}
}

print_step()
{
    echo -en ${INFO_LINE_COLOR}
    echo     "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo -en ${INFO_TEXT_COLOR}
	echo     " "$1
    echo -en ${INFO_LINE_COLOR}
    echo     "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo -en ${NO_COLOR}
}

error()
{
    echo -en ${ERROR_LINE_COLOR}
    echo     "!---------------------------------!"
    echo     "! ERROR $1"
    echo     "!---------------------------------!"
    echo -en ${NO_COLOR}

	false
	exit
}

# #############################################################################
#  Test Functions
# #############################################################################

build_toolchain() {
   CUR_ARCH=$1
   cd ${BASEDIR}/..
   ${BUILD_SCRIPT} ${CUR_ARCH} ${BUILD_DIR}/xtools_${CUR_ARCH}
}

compilation_test() {

   CUR_ARCH=$1

   case ${CUR_ARCH} in
	   arm|mips)
		   cd ${APP_DIR}
		   export PATH=${SAVE_PATH}:${BUILD_DIR}/xtools_${CUR_ARCH}/bin
		   git checkout -q ${arch}
		   source install.sh
		   apes-compose -c
		   apes-compose || error "Compilation error"
		   echo "Passed"
		   ;;
	   *)
		   echo "Skipped"
		   ;;
   esac
}

# #############################################################################
#  Main Function
# #############################################################################

BASEDIR=${PWD}

ARCHS="arm mips microblaze c6x x86"
BUILD_SCRIPT=./build_xtools

BUILD_DIR=/tmp/xtools_tests/
SAVE_PATH=$PATH

print_greatings

mkdir -p ${BUILD_DIR}
cd ${BASEDIR}/..

for arch in ${ARCHS} ; do

	print_step "Building "$arch
	build_toolchain ${arch} || error $arch

	print_step "Compile test "$arch
	compilation_test ${arch} || error $arch

	rm -fr ${BASEDIR}/../build-*

done

rm -fr ${BUID_DIR}
