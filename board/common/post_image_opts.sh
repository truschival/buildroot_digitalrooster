# iterate options, for some reason I could not get getopts to work
# first option is set to BINARIES_DIR by buildroot
shift
while [ -n "$1" ]; do 
    case "$1" in
	-b)
	    BOARD_DIR=$2
	    echo " BOARD_DIR = $BOARD_DIR"
	    shift
	    ;;

	-c)
	    GENIMAGE_CFG=$2
	    echo " genimage config = $GENIMAGE_CFG"
	    shift
	    ;;
	-s)
	    SWUIMAGE_CFG=$2
	    echo " SWU image config = $SWUIMAGE_CFG"
	    shift
	    ;;
	*) echo "Option $1 not recognized" ;;
    esac
    shift
done

if [ -z "$GENIMAGE_CFG" ];
then
    GENIMAGE_CFG=$BOARD_DIR/genimage.cfg
fi
test -r  $GENIMAGE_CFG ||  {
    echo "genimage config : $GENIMAGE_CFG - not readable!"
    exit 1
}


if [ -z "$SWUIMAGE_CFG" ];
then
    SWUIMAGE_CFG=$BOARD_DIR/gen_swuimage.cfg
fi
test -r  $SWUIMAGE_CFG ||  {
    echo "gen_swuimage config: $SWUIMAGE_CFG - not readable!"
    exit 1
}
