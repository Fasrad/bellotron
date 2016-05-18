#!/usr/bin/perl -w

# perl script to generate postscript. 
# Because I'm not doing trig in ps, nor am 
# I about to use ps to write a web cgi program.. 

# this needs cgiified later

{
    local $/;
    $help=<DATA>;
}

print "hi\n";

#open file and print header info 
$fn='ps.ps'; # fixme

#$ps=*STDOUT;
open ($ps, ">", $fn) || die "can't open ps";

print "postheader\n";

$riw=100;
$row=120;
$fiw=100;
$fow=120;
$length=200;

#&commandline;
#&get_UI;
&bellofy;

sub bellofy{    # bellows-drawing algorithm.

    print $ps 
    "%!
    %% pattern for bellows generated by bellofy.pl
    /mm {360 mul 127 div} def % cause I don't do points
    ";

    print $ps "
    %move to center of paper based on heuristic estimate of bellows extant
    newpath
    100 100 moveto
    ";

    $toplength=$length;       # [over]simplification; fixme
    $meanpleat=($row-$riw)/2; # pleats constrained by rear frame
    $numpleats=int($length/$meanpleat + 1); # that's a ceiling 
    $toplength=$numpleats*$meanpleat;

    print $ps "
    0 $toplength rlineto
    stroke 
    100 100 moveto
    ";

    print $ps "
    newpath
    0 0 moveto
    0 $row lineto
    $row $row lineto
    $row 0 lineto
    0 0 lineto";

    $tmp=($row-$riw)/2;

    print $ps "
    $tmp $tmp translate
    0 0 moveto
    0 $riw lineto
    $riw $riw lineto
    $riw 0 lineto
    0 0 lineto

    -$tmp -$tmp translate
    0 0 moveto
    0 $fiw lineto
    $fiw $fiw lineto
    $fiw 0 lineto
    0 0 lineto";

    $tmp=($fow-$fiw)/2;

    print $ps "
    $tmp $tmp translate
    0 0 moveto
    0 $fow lineto
    $fow $fow lineto
    $fow 0 lineto
    0 0 lineto

    2 setlinewidth
    stroke
    ";
    
    print $ps "
    showpage 
    ";

    `evince $fn`;

} #bellofy
 
sub line{
    print $ps "
    newpath
    $_[0] $_[1] moveto
    $_[2] $_[3] lineto
    stroke
    ";
}

   # precalculation of globally-relevant parameters
    # length of top and side center panel lines and/or outer corner lines 
    # from bellows length and vector math
    # distance between outer, narrower pleat lines
    # distance between inner, wider pleat lines 

    # coordinate transform subroutine? translation+rotation??
    # save lines as objects and find intersections with subroutine? 
    # draw_line subroutine? 

    # draw top trapezoid. Center line for convenience. Necessary because these 
    # lines are extra? Maybe just define.

    # draw top, shorter outer pleat lines. Can we calc distance and just linearly scale 
    # the distance between them?  

    # Can we calculate the location and distance of the longer outer-pleat lines, also linearly
    # scale, and draw them longer? Calculate how much longer than inner pleates from trig?

    # we should draw the zig-zag on the left side using the endpoints of the pleat lines.
    # then the zigzags are taken care of. 
    
    # Coordinate transform to the side trapezoid, and draw the side pleat lines same way? 
    # Should magically touch?

    # coordinate transform and do both of the above once to save computation? meh. bottom 
    # needs drawn twice. Be a pal and draw slopey lines. Maybe on all panels?

#
sub commandline{
    LOOP:
    while(){
        print "Select an action. Enter...
        B to create a bellows pattern
        Q to quit:\n";
        $choice=uc(<STDIN>);
        chomp $choice;
        if ($choice eq "B"){
            &get_UI;
        } elsif ($choice eq "Q") {
            exit;
        } else {
            next LOOP;
        }
    } #end first UI loop 
}

sub get_UI{
   print "enter your rear standard inner bellows width in mm ";
    $riw=<STDIN> ; chomp $riw; $riw=~s/\s//g;
    if($riw=~/[^0-9]/){print "Illegal characters in input text.\n"; return}

    print "enter your rear standard outer bellows width in mm ";
    $row=<STDIN>; chomp $row; $row=~s/\s//g;
    if($row=~/[^0-9]/){print "Illegal characters in input text.\n"; return}

    print "enter your front standard inner bellows width in mm ";
    $fiw=<STDIN>; chomp $fiw; $fiw=~s/\s//g;
    if($fiw=~/[^0-9]/){print "Illegal characters in input text.\n"; return}

    print "enter your front standard outer bellows width in mm ";
    $fow=<STDIN>; chomp $fow; $fow=~s/\s//g;
    if($fow=~/[^0-9]/){print "Illegal characters in input text.\n"; return}

    print "enter the maximum extended length of your bellows in mm ";
    $length=<STDIN>; chomp $length; $length=~s/\s//g;
    if($length=~/[^0-9]/){print "Illegal characters in input text.\n"; return}

    # sanity checking here 

    if($fow<$fiw){
        print "outer widths must be bigger than inner widths\n"; return}
    if($row<$riw){
        print "outer widths must be bigger than inner widths\n"; return}
    if($row<25|| $riw<25 ||$fow<25 ||$fiw<25){
        print "Error. The smallest dimension supported is 25mm\n\n"; return}
    if($row>1000 ||$riw>1000 ||$fow>1000 ||$fiw>1000){
        print "Error. The largest dimension supported is 1000mm\n\n"; return}
    if($row>$riw*4||$riw>$row*4||$fow>$fiw*4||$fiw>$fow*4){
        print "Error. Maximum height/width aspect ratio supported is 4:1\n\n"; return}
    if($row*10<$length){
        print "Error. Maximum length/width ratio supported is 10\n\n"; return}
    if($row>$length){
        print "Error. Minimum length/width ratio supported is 1\n\n"; return}
    if($length/($row-$riw)<2||$length/($fow-$fiw)<2){
        print "Error. Your bellows will have less than 2 pleats\n\n"; return}
    if($length/($row-$riw)>90||$length/($fow-$fiw)>90){
        print "Error. Your bellows will have more than 90 pleats\n\n"; return}
    if(($row-$riw)<3||($fow-$fiw)<3){
        print "Error. Your bellows will have pleats less than 3mm.\n\n"; return}
    if(($row/$fow)>3){
        print "Error. Your bellows is too tapered. \n\n"; return}
    if(($row<$fow)||($riw<$fiw)){
        print "Error. The front dimensions of your bellows must be equal or 
        smaller than the rear. \n\n"; return}

    print "\ngenerating pattern with following parameters:
    Rear outer width=$row,
    Rear inner width=$riw, 
    Front outer width=$fow,
    Front inner width=$fiw,
    Extended length = $length...\n\n";

    &bellofy;

    return;
}# bellofy UI loop 2


__END__
    print "\n\n";
    return;

}#bellowfi

__DATA__

Instructions?


