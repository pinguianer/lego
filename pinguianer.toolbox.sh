#!/bin/bash
#=================================  FUNCTION  ==================================#
#===========+++++   Copyright©Pinguianer Bash Toolbox  Function  +++++==========#
#          NAME:  plausibility_check						#
#   DESCRIPTION:  checks input for error data			      		#
#    PARAMETERS:  type, var (look at code for possible types)	      		#
#       RETURNS:  either correct var or ""			      		#
#===============================================================================#

plausibility_check() { #{{{
        local Type="${1}"
        local Var="${2:-}"
        local Var2="${3:-}"
        local Returnstring=""
        case $Type in
                  ip ) # Check if user input is in valid list of IPv4 format
			if [[ ${Var} =~ ^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$ ]] ; then 
				Returnstring="${Var}"
			else
                		die "ERROR: IP format ${Var} not allowed "
			fi
                        ;;

                  mac ) # Check if user input is in valid list of MAC format
			if [[ ${Var} =~ ^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$ ]] ; then 
				Returnstring="${Var}"
			else
                		die "ERROR: MAC format ${Var} not allowed "
			fi
                        ;;

                delnull )
			Var=$(echo ${Var} | sed 's/^0\{1,3\}//g')
			Returnstring="${Var}"
                        ;;
                addnull )
			while [ ${#Var} -le 2 ]
			do
				Var="0"${Var};
			done
			Returnstring="${Var}"
                        ;;
                numeric ) # Check if user input is numeric
                        isNumeric "${Var}" && Returnstring="${Var}"
                        ;;
                * ) # Unknown Type, return ""
                        ;;
        esac
        echo "${Returnstring}"
        return 0
} #}}}


#=================================  FUNCTION  ==================================#
#===========+++++   Copyright©Pinguianer Bash Toolbox  Function  +++++==========#
#          NAME:  mysql_query							#
#   DESCRIPTION:  executes a mysql query via ssh and returns the result		#
#    PARAMETERS:  sql								#
#       RETURNS:  mysql result as echo						#
#===============================================================================#
mysql_query(){ #{{{
	MyServer="IP"
	MyPort="3306"
	MyUser="Username"
	MyPass="Passwd"
	MysqlResult=$(mysql -D iconfig --skip-column-names -e "$@")
} #}}}

#=================================  FUNCTION  ==================================#
#===========+++++   Copyright©Pinguianer Bash Toolbox  Function  +++++==========#
#          NAME:  isNumeric							#
#   DESCRIPTION:  simple function that checks if $@ is numeric (more or less)	#
#    PARAMETERS:  string							#
#       RETURNS:  0 if numeric							#
#===============================================================================#

isNumeric() { #{{{
        echo "$@" | grep -q -v "[^0-9\ \.]"
} #}}}
isRealNumeric() { #{{{
        echo "$@" | grep -q -v "[^0-9]"
} #}}}

officexxx() { #{{{
        echo "$@" | grep -q -v "^office[0-9]{1,3}$"
	
} #}}}


print() { printf "\e[31m $*\n" "%\e[31m\n"; }

#=================================  FUNCTION  ==================================#
#===========+++++   Copyright©Pinguianer Bash Toolbox  Function  +++++==========#
#          NAME:  die								#
#   DESCRIPTION:  Print Error Exception message					#
#    PARAMETERS:  string							#
#       RETURNS:  exit 1							#
#===============================================================================#

die() { #{{{
        print "
Shell function error:

$1" 1>&2
        prog_exit "${2:-1}"
} #}}} # => die()

printinfo() { printf "\e[34m $*\n" "%\e[34m\n"; }

shellinfo() { #{{{
        printinfo "
Shell function info:
	$1"
} #}}}

#=================================  FUNCTION  ==================================#
#===========+++++   Copyright©Pinguianer Bash Toolbox  Function  +++++==========#
#          NAME:  mss								#
#   DESCRIPTION:  Print message							#
#    PARAMETERS:  string							#
#       RETURNS:  exit 0							#
#===============================================================================#

mss() { printf "\e[34m $*\n" "%\e[34m\n"; }


prog_exit() {
        ESTAT=0
        [ -n "$1" ] && ESTAT=$1
        (stty echo 2>/dev/null) || set -o echo
        echo "" # just to get a clean line
        exit "$ESTAT"
} # => prog_exit()


#if dpkg --get-selections | grep -q easy ; then echo ok ; fi



#===  FUNCTION  =======================================================
#          NAME:  delete_all					      #
#   DESCRIPTION:  delete all container config and certificate etc.    #
#    PARAMETERS:  none						      #
#       RETURNS:  						      #
#======================================================================

delete_all() { #{{{

	rm -fr ~/pki ; rm -fr /ovpn
	docker stop $(docker ps -aq); docker rm $(docker ps -aq)
	docker system prune
} #}}}

