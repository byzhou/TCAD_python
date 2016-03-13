#!/usr/bin/perl

use File::Basename ;
#use integer ;
use Switch ;
use warnings ;

#cell info file
$cellinfo   = "des_ALLCELL.txt" ;

sub dir ;

$helpInfo   = << "EOF" ;

Usage: Sample the square areas covered in the def file.

    - First argument    size of the window frame    \$ARGV[0]
    - Second argument   maximum size of the chip    \$ARGV[1] 
    - Third argument    file to be processed        \$ARGV[2]
    - Fourth argument   directory to be saved       \$ARGV[3]

    example:
        ./ext.pl 10 100 TjIn.def c1355 # sampling data from the first 10x10 square to the top
        lef 10x10 square
EOF

# argument number guard
if ( $#ARGV != 3 ) {
    print "Number of arguement list only has ". ($#ARGV + 2). " arguments!\n";
    print $helpInfo . "\n" ;
    exit;
} elsif ( $ARGV[1] < $ARGV[0] ) {
    print "Window size is too large!\n";
    print $helpInfo . "\n" ;
    exit;
}

# def file that is about to be read
$defHTIn    = $ARGV[2] ;
$TjFlag     = substr $defHTIn, 0, -4; 

# test if the save directory exist 
if (-d "txt") {
    print "txt exists, we can write results into directory\n";
} else {
    print "txt does not exit, I will create one directory for you!\n";
    system ("mkdir txt");
}

if (-d "txt\/$ARGV[3]") {
    print "$ARGV[3] exists, we can write results into directory\n";
} else {
    print "$ARGV[3] does not exit, I will create one directory for you!\n";
    system ("mkdir txt\/$ARGV[3]");
}

if (-d "txt\/$ARGV[3]\/$TjFlag") {
    print "$TjFlag exists, we can write results into directory\n";
} else {
    print "$TjFlag does not exit, I will create one directory for you!\n";
    system ("mkdir txt\/$ARGV[3]\/$TjFlag");
}

#write to Trojan Free file
for ( $xdownlimit = 0 ; $xdownlimit <= $ARGV[1] ; $xdownlimit = $xdownlimit + $ARGV[0] ) {
    for ( $ydownlimit = $ARGV[0] ; $ydownlimit <= $ARGV[1] ; $ydownlimit = $ydownlimit + $ARGV[0] ) {
        $xuplimit       = $xdownlimit + 10 ;
        $yuplimit       = $ydownlimit + 10 ;
        
        $outIn          = "txt\/$ARGV[3]\/$TjFlag\/". "x". $xdownlimit. $xuplimit. "y". $ydownlimit. $yuplimit. "\.txt";
        open $writeFree , "+>" , $outIn or die "$outIn is not available!\n" ; 
        print $outIn . " has been successfully opened!\n" ;

        #read Trojan Free file
        open $readFree , "<" , $defHTIn or die "$defHTIn is not available!\n" ;
        print $defHTIn . " has been successfully opened!\n" ;

        #write info the cell
        while ( <$readFree> ) {
            if ( /PLACED/ ) {
                my @definfo     = split ( ' ' , $' ) ;
                my @preinfo     = split ( ' ' , $` ) ;

                if ( @preinfo >= 2 ) {
                    $cellins        = $preinfo[1] ;
                    $cellname       = $preinfo[2] ;
                    $celldir        = $definfo[4] ;
                    $cellposx       = $definfo[1] / 2000 ;
                    $cellposy       = $definfo[2] / 2000 ;

                    #read the all standard cell reference file
                    open $cellref , "<" , $cellinfo or die "$cellinfo is not available!\n" ;

                    while ( <$cellref> ) {
                        my @refinfo     = split ( '\t' , $_ ) ;
                        $refcellname    = $refinfo[0] ;
                        #print $refcellname . "\n" ;
                        if ( $refcellname eq $cellname ) {
                            $refxsize       = $refinfo[3] ;
                            $refysize       = $refinfo[5] ;
                            last ;
                        }
                    }

                    #cell position limited in a square area  
                    if ( ( $cellposx > $xdownlimit ) && ( $cellposx < $xuplimit ) &&
                            ( $cellposy > $ydownlimit ) && ( $cellposy < $yuplimit ) ) {
                        &dir ( $celldir , $cellname , $cellins , $cellposx , $cellposy , $refxsize , $refysize ) ;
                    } 
                    close ( $cellref ) ;
                }
            }
        }
        close ( $writeFree ) ;
        close ( $readFree ) ;
    }
}

foreach $resultFiles (glob("txt\/$ARGV[3]\/$TjFlag\/*.txt")) {
    if (-z $resultFiles) {
        print $resultFiles. " is empty! It will be removed!\n";
        system("rm ". $resultFiles);
    }
}

#end of the one readFile

sub dir {
    my ( $celldir , $cellname , $cellins , $cellposx , $cellposy , $refxsize , $refysize ) = @_ ;
    switch ( $celldir ) {
        case "N" { 
            print $writeFree $cellname. ("\t") .$cellins .( 
                "\t" ).( $cellposx ).( "\t" ).( $cellposy + $refysize ).(
                "\t" ).( $cellposx + $refxsize ).( "\t" ).( $cellposy + $refysize ).(
                "\t" ).( $cellposx + $refxsize ).( "\t" ).( $cellposy ).(
                "\t" ).( $cellposx ).( "\t" ).( $cellposy )
                . "\n" 
        } case "S" {
            print $writeFree $cellname. ("\t") .$cellins .( 
                "\t" ).( $cellposx ).( "\t" ).( $cellposy + $refysize ).(
                "\t" ).( $cellposx + $refxsize ).( "\t" ).( $cellposy + $refysize ).(
                "\t" ).( $cellposx + $refxsize ).( "\t" ).( $cellposy ).(
                "\t" ).( $cellposx ).( "\t" ).( $cellposy )
                . "\n" 
        } case "W" {
            print $writeFree $cellname. ("\t") . $cellins .( 
                "\t" ).( $cellposx - $refysize ).( "\t" ).( $cellposy + $refxsize ).(
                "\t" ).( $cellposx ).( "\t" ).( $cellposy + $refxsize ).(
                "\t" ).( $cellposx ).( "\t" ).( $cellposy ).(
                "\t" ).( $cellposx - $refysize ).( "\t" ).( $cellposy )
                . "\n" 
        } case "E" {
            print $writeFree $cellname. ("\t") . $cellins .( 
                "\t" ).( $cellposx ).( "\t" ).( $cellposy ).(
                "\t" ).( $cellposx + $refysize ).( "\t" ).( $cellposy ).(
                "\t" ).( $cellposx + $refysize ).( "\t" ).( $cellposy - $refxsize ).(
                "\t" ).( $cellposx ).( "\t" ).( $cellposy - $refxsize )
                . "\n" 
        } case "FS" {
            print $writeFree $cellname. ("\t") .$cellins .( 
                "\t" ).( $cellposx ).( "\t" ).( $cellposy + $refysize ).(
                "\t" ).( $cellposx + $refxsize ).( "\t" ).( $cellposy + $refysize ).(
                "\t" ).( $cellposx + $refxsize ).( "\t" ).( $cellposy ).(
                "\t" ).( $cellposx ).( "\t" ).( $cellposy )
                . "\n" 
        } case "FN" {
            print $writeFree $cellname. ("\t") .$cellins .( 
                "\t" ).( $cellposx ).( "\t" ).( $cellposy + $refysize ).(
                "\t" ).( $cellposx + $refxsize ).( "\t" ).( $cellposy + $refysize ).(
                "\t" ).( $cellposx + $refxsize ).( "\t" ).( $cellposy ).(
                "\t" ).( $cellposx ).( "\t" ).( $cellposy )
                . "\n" 
        } case "FW" {
            print $writeFree $cellname. ("\t") . $cellins .( 
                "\t" ).( $cellposx ).( "\t" ).( $cellposy ).(
                "\t" ).( $cellposx + $refysize ).( "\t" ).( $cellposy ).(
                "\t" ).( $cellposx + $refysize ).( "\t" ).( $cellposy - $refxsize ).(
                "\t" ).( $cellposx ).( "\t" ).( $cellposy - $refxsize )
                . "\n" 
        } case "FE" {
            print $writeFree $cellname. ("\t") . $cellins .( 
                "\t" ).( $cellposx - $refysize ).( "\t" ).( $cellposy + $refxsize ).(
                "\t" ).( $cellposx ).( "\t" ).( $cellposy + $refxsize ).(
                "\t" ).( $cellposx ).( "\t" ).( $cellposy ).(
                "\t" ).( $cellposx - $refysize ).( "\t" ).( $cellposy )
                . "\n" 
        } 
    } #end switch
}


