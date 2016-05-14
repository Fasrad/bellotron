#!/usr/bin/perl -w

# perl script to generate postscript. 
# Because I'm not doing trig in ps, nor am 
# I about to use ps to write a web cgi program.. 

# this needs cgiified later

{
    local $/;
    $help=<DATA>;
}
print "hi";

LOOP:
while(){
    print "Select an action. Enter...
    B to create a bellows pattern
    Q to quit:\n";
    $choice=uc(<STDIN>);
    chomp $choice;
    if ($choice eq "B"){
        &bellofy;
    } elsif ($choice eq "Q") {
        exit;
    } else {
        next LOOP;
    }
}
sub bellofy{

   print "enter your rear standard inner bellows width in mm ";
    $riw=<STDIN> ;
    chomp $riw;
    $riw=~s/\s//g;
    if($riw=~/[^0-9]/){print "Illegal characters in input text.\n"; return}

    print "enter your rear standard outer bellows width in mm ";
    $row=<STDIN>;
    chomp $row;
    $row=~s/\s//g;
    if($row=~/[^0-9]/){print "Illegal characters in input text.\n"; return}

    print "enter your front standard inner bellows width in mm ";
    $fiw=<STDIN>;
    chomp $fiw;
    $fiw=~s/\s//g;
    if($fiw=~/[^0-9]/){print "Illegal characters in input text.\n"; return}

    print "enter your front standard outer bellows width in mm ";
    $fow=<STDIN>;
    chomp $fow;
    $fow=~s/\s//g;
    if($fow=~/[^0-9]/){print "Illegal characters in input text.\n"; return}

    print "$row, $riw, $fow, $fiw \n";

    $fn='outfile.ps'; # fixme

    open ($outfile, ">", $fn) || die "can't open outfile";

    print $outfile 
"%!
%% Attempt to draw lines for fabric patterns

/mm {360 mul 127 div} def % cause I don't do points

newpath

0 0 moveto
0 $row lineto
$row $row lineto
$row 0 lineto
0 0 lineto

0 0 moveto
0 $riw lineto
$riw $riw lineto
$riw 0 lineto
0 0 lineto

0 0 moveto
0 $fiw lineto
$fiw $fiw lineto
$fiw 0 lineto
0 0 lineto

0 0 moveto
0 $fow lineto
$fow $fow lineto
$fow 0 lineto
0 0 lineto

2 setlinewidth
stroke
showpage 
";

    print "\n\n";
    return;

}#bellowfi
__DATA__

Instructions?


