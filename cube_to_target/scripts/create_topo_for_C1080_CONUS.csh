#!/bin/tcsh


set case = "c1080_CONUS_06"
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

set ogrid = "geos_c1080_CONUS"
set Co = "15"
set Fi = "0"

# This is now used for all. Doesn't matter, will eliminate
#set Nrs=00

echo "Here you are 1"


set scrip = "PE1080x6480-Refinement-CF.nc"
set Yfac = "8"


set scrip = '/project/amp/juliob/Topo-generate-devel/Topo/inputdata/grid-descriptor-file/'${scrip}
set cstopo = '/project/amp/juliob/Topo-generate-devel/Topo/inputdata/cubed-sphere-topo/gmted2010_modis_bedmachine-ncube3000-220518.nc'

echo "Here you are 2"

set cog = `printf "%.3d" $Co`
set cog = "Co"$cog
set fig = `printf "%.3d" $Fi`
set fig = "Fi"$fig
echo "Here you are 3"

set smtopo = 'topo_smooth_gmted2010_bedmachine_nc3000_'$cog'.nc'

echo  $cog
echo  $fig

set smtopodir = '/project/amp/juliob/Topo-generate-devel/Topo/smooth_topo/bedmachine_lap/'
set smtopo = 'topo_smooth_gmted2010_modis_bedmachine_nc3000_Co060_nolk.nc'
set smtopo = $smtopodir$smtopo

#set smtopo = '/project/amp/juliob/Topo-generate-devel/Topo/Topo.git/cases/ne30pg3_co60_fi0_bsln/output/topo_smooth_gmted2010_modis_bedmachine_nc3000_Co060.nc'

echo  "SMooth topo file= "$smtopo
ln -sf $smtopo output/topo_smooth.nc

set smoo_scale = "25."

#READ IN Smooth and find ridges
./cube_to_target --grid_descriptor_file=$scrip --intermediate_cs_name=$cstopo --output_grid=$ogrid --smoothing_scale=25. --fine_radius=$Fi -u 'juliob@ucar.edu' -q 'output/' -z -y $Yfac -v

#./cube_to_target --grid_descriptor_file=$scrip --intermediate_cs_name=$cstopo --output_grid=$ogrid --smoothing_scale=100. --fine_radius=$Fi --smooth_topo_file=$smtopo -u 'juliob@ucar.edu' -q 'output/' -z




exit
