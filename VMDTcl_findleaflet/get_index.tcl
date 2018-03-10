
set lipidtype [lindex $argv 0]
set Pname [lindex $argv 1]
set initmol [molinfo top get id]
puts "$initmol =initmol"
set all [atomselect $initmol all]
set membrane [measure center [atomselect $initmol "resname $lipidtype"] weight mass]
$all move [trans origin $membrane]
set lower [atomselect $initmol "(resname $lipidtype and name $Pname) and z < 0"]
set upper [atomselect $initmol "(resname $lipidtype and name $Pname) and z > 0"]
set totlip [atomselect $initmol "(resname $lipidtype and name $Pname)"]

$upper num
$lower num

set residl [$lower get resid]
set residu [$upper get resid]
 
set outfileu [open "resid_upper" w]
set outfilel [open "resid_lower" w]

puts $outfileu "$residu"
puts $outfilel "$residl"

close $outfileu
close $outfilel
exit
