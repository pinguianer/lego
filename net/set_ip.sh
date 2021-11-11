#=================================  FUNCTION  ==================================#
#===========+++++   Copyright©Pinguianer Bash Toolbox  Function  +++++==========#
#          NAME:  set_ip							#
#   DESCRIPTION:  set ip 							#
#    PARAMETERS:  IPv4								#
#       RETURNS:  none								#
#===============================================================================#

initialize() { #{{{
	for file in ./get_OS.sh ./pinguianer.toolbox.sh 
	do
	  if [ -e ${file} ]
	then
		INCLUDED=1 # var for shell_functions to detect we are including it
	SF=1 # indicate that we found the file
	. ${file}
	fi
	done
} #}}}

#===  FUNCTION  =======================================================
#          NAME:  set_ip					      #
#   DESCRIPTION:  set_ip					      #
#    PARAMETERS:  $@						      #
#       RETURNS:  none						      #
#======================================================================

set_ip() { #{{{

	initialize
	parse_args_set_ip "$@"
	OS="$(get_OS)"
	echo "OS TAG : $OS"
	local Gateway=$(echo $IP | sed "s/[0-9]\{1,3\}\$/1/g")
	case $OS in
		Ubuntu )
			NetConfigFile="/etc/netplan/01-network-manager-all.yaml"
		;;
		debian )
		;;
		freebsd )
		;;
        esac

	DeviceArray=(`/usr/sbin/ip link show | awk -F ':' '{print $2}' | grep "^ [a-Z]" | sed "s/ //g" | sed "/lo/d"`)
	if [[ ${#DeviceArray[*]} == 1 ]]; then
		Device=$DeviceArray
		echo $Device
	else
		echo "Network Device : "${DeviceArray[*]}
		read Device
		echo $Device
	fi
	
	cat << EOF > $NetConfigFile
network:
  ethernets:
    $Device:
      addresses:
      - $IP/24
      gateway4: $Gateway
      nameservers:
        addresses:
        - $Gateway
  version: 2
EOF

} #}}}

#===  FUNCTION  =======================================================
#          NAME:  parse_args_set_ip				      #
#   DESCRIPTION:  parses the cli args				      #
#    PARAMETERS:  $@						      #
#       RETURNS:  $IP						      #
#======================================================================
parse_args_set_ip() { #{{{
        while getopts ":i:" Option
        do
                case $Option in
                        i     ) IP="$(plausibility_check ip "${OPTARG}")" ;;
                        h     ) print_help_set_ip ;;
                        *     ) print_help_set_ip ;;   # DEFAULT
                esac
        done
        shift $(($OPTIND - 1))
} #}}}

#===  FUNCTION  =======================================================
#          NAME:  Print_help_set_ip			 	      #
#   DESCRIPTION:  Prints help and exits				      #
#======================================================================

print_help_set_ip() { #{{{
        echo "Usage: `basename $0` -i <IPv4> [ -h ] [ -c ]"
        echo ""
        echo "e.g. ./`basename $0` -i 192.168.5.11"
        echo ""
        exit 0
} #}}}


#-------------------------------------------------------------------------------#
#   This MUST be at the end of the file, all functions must already be defined  #
#										#
#   this little snippet allows us to symlink function names to this file	#
#-------------------------------------------------------------------------------#
if [[ "$INCLUDED"  != "1" ]]
then
        $(basename $0) "$@"
fi


