#!/bin/bash

#===============  FUNCTION  ====================================================#
#===========+++++   Copyright©Pinguianer Bash Toolbox  Function  +++++==========#
#          NAME:  get_OS							#
#   DESCRIPTION:  Get OS Distribution Name			      		#
#    PARAMETERS:  none						      		#
#       RETURNS:  $Returnstring					      		#
#===============================================================================#

get_OS() { #{{{

	if [[ -f /etc/issue ]] ; then
		if cat /etc/issue | grep -q "Ubuntu" ; then
			OSTAG="Ubuntu"
		elif cat /etc/issue | grep -q "Debian" ; then
			OSTAG="Debian"
		fi
		
	fi
	if [[ -f /etc/redhat-release ]] ; then
		if cat /etc/redhat-release | grep -q "CentOS" ; then
			OSTAG="CentOS"
		fi
		
	fi
	if uname -a | grep -q "FreeBSD" ; then
		OSTAG="FreeBSD"
	fi


                case $OSTAG in
                        "Ubuntu"     ) Returnstring="Ubuntu" ;;
                        "Debian"     ) Returnstring="Debian" ;;
			"CentOS"     ) Returnstring="CentOS" ;;
		   	"FreeBSD"    ) Returnstring="FreeBSD" ;;
                esac
		echo $Returnstring
} #}}}



#-------------------------------------------------------------------------------
#   This MUST be at the end of the file, all functions must already be defined
#
#   this little snippet allows us to symlink function names to this file
#-------------------------------------------------------------------------------
if [[ "$INCLUDED"  != "1" ]]
then
        $(basename $0) "$@"
fi

