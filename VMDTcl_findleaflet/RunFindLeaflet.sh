#!/bin/sh
#How to use : sh run_Z_coordinate [.gro file] [lipid type:DPPC, DLPC] [P atoms name: PO4, P, P8][.xtc file] [.tpr file]
# example : sh ./RunFindLeaflet.sh ./test.gro POPC PO4 ./test.xtc ./test.tpr
##########################################################################

#read inputs 
i=$1
lipid=$2
Patoms=$3
xtc=$4
tpr=$5

gmx="gmx_sse"
index="leaflet.ndx"

# run vmd tcl script to get resid
# -args followed by lipid type, and P atom name
vmd $i -dispdev text -e ./get_index.tcl -args $lipid $Patoms

############################################################################
#make index
#read resid from vmd exported files
residl=`cat resid_lower`
residu=`cat resid_upper`

#make index
make_ndx -f $i -o $index << EOF
del 1-30
a PO4 &r $residl
name 1 PO4_lower
a PO4 &r $residu
name 2 PO4_upper
q
EOF

#remove temp files
rm resid_lower resid_upper
###########################################################################

## Start calculate the (center of mass of selected groups') coordinate 
echo 0 | $gmx traj -f $xtc -s $tpr -n $index -ob system_size 
echo 1 | $gmx traj -f $xtc -s $tpr -n $index -com -pbc -nojump -nox -noy -ox PO4_lower 
echo 2 | $gmx traj -f $xtc -s $tpr -n $index -com -pbc -nojump -nox -noy -ox PO4_upper

################################################################################

