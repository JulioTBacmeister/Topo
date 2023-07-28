#!/bin/tcsh


set case = "c540_CONUS_07"
echo $case

mkdir -p ../cases/${case}/output
cp *.F90 ../cases/${case}
cp Makefile ../cases/${case}
cp ../machine_settings.make ../cases/${case}

cd ../cases/${case}




# Assumes you are in the right directory, i.e, the one with F90 files and namelists
#----------------------------------------------------------------------------------
mkdir -p output
mkdir -p output/raw
mkdir -p output/clean


module load compiler/gnu/default
gmake clean
gmake

set ogrid = "geos_c540_CONUS"

# Script is messy. These parameters aren't used by the actual
# code, but for historical reasons they still appear. Didn't have time
# to clean up.(7/28/23)
#----------------------------------------------------
set Co = "30"
set Fi = "0"

# SCRIP file for target grid
set scrip = "PE540x3240-Refinement-CF.nc"
# Maximum refinement factor in SCRIP file
set Yfac = "8"


# I've copied these files onto Casper, NCAR's HPC analysis front-end. Hopefully,
# you can find someone at GSFC with access. They are in this directory:
#          /glade/work/juliob/TopoFiles/inutdata/
#----------------------------------------------------------------------------
# Set the SCRIP file
set scrip = '/project/amp/juliob/Topo-generate-devel/Topo/inputdata/grid-descriptor-file/'${scrip}
# Set the 'cubed sphere topography' file. Currently needs to be our 3000x3000x6
# file.
set cstopo = '/project/amp/juliob/Topo-generate-devel/Topo/inputdata/cubed-sphere-topo/gmted2010_modis_bedmachine-ncube3000-220518.nc'

set cog = `printf "%.3d" $Co`
set cog = "Co"$cog
set fig = `printf "%.3d" $Fi`
set fig = "Fi"$fig

# Ditto comment from above: Next code should be irrlevant, but
# haven't had chance to clean up.
#-----------------------------------------------------
#vvvvvv
set smtopo = 'topo_smooth_gmted2010_bedmachine_nc3000_'$cog'.nc'

echo  $cog
echo  $fig

set smtopodir = '/project/amp/juliob/Topo-generate-devel/Topo/smooth_topo/bedmachine_lap/'
set smtopo = 'topo_smooth_gmted2010_modis_bedmachine_nc3000_Co060_nolk.nc'
set smtopo = $smtopodir$smtopo

echo  "SMooth topo file= "$smtopo
ln -sf $smtopo output/topo_smooth.nc
#^^^^^^

# This is set based on the coarsest gridlengths in the grid.
# For the CONUS_c540 I saw a coarsest gridlength of ~50km 
# hence the value of 50 here.
# Smoothing will then be scaled for finer portions of the grid 
# based on the refinement_factor w/ respect to coarsest portion.
# -----------------------------------------------------
set smoo_scale = "50."

#READ IN Smooth and find ridges
./cube_to_target --grid_descriptor_file=$scrip --intermediate_cs_name=$cstopo --output_grid=$ogrid --smoothing_scale=$smoo_scale --fine_radius=$Fi -u 'juliob@ucar.edu' -q 'output/' -z -y $Yfac -v



exit
