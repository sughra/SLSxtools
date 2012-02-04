#! /bin/bash 


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
