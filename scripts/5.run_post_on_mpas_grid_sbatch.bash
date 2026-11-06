#!/bin/bash -x
#SBATCH --job-name=${GRID_jobname}
#SBATCH --nodes=${GRID_nnodes}
#SBATCH --ntasks=${GRID_ntasks}
#SBATCH --cpus-per-task=${GRID_ncpt}
#SBATCH --partition=${GRID_QUEUE}
#SBATCH --time=${GRID_walltime}
#SBATCH --output=${DATAOUT}/2025121700/Post/mpas_post.bash.o%j    # File name for standard output
#SBATCH --error=${DATAOUT}/2025121700/Post/mpas_post.bash.e%j     # File name for standard error output
#SBATCH --exclusive
#SBATCH --mem=${POST_memory}G

# Set environment variables exports:
echo ""
echo -e "\033[1;32m==>\033[0m Moduling environment for MONAN model...\n"
. setenv.bash


# Standart directories variables:---------------------------------------
DIRHOMES=${DIR_SCRIPTS}/scripts_CD-CT; mkdir -p ${DIRHOMES}
DIRHOMED=${DIR_DADOS}/scripts_CD-CT;   mkdir -p ${DIRHOMED}
export SCRIPTS=${DIRHOMES}/scripts;    mkdir -p ${SCRIPTS}
DATAIN=${DIRHOMED}/datain;             mkdir -p ${DATAIN}
DATAOUT=${DIRHOMED}/dataout;           mkdir -p ${DATAOUT}
SOURCES=${DIRHOMES}/sources;           mkdir -p ${SOURCES}
EXECS=${DIRHOMED}/execs;               mkdir -p ${EXECS}
#----------------------------------------------------------------------

echo "sources dir:"
echo $SOURCES

# Define local variables
VAR=surface_pressure
#V_MIN=-0.000125
#V_MAX=0.000125
FILENAME=lat_-15_lon_-65_ellipse_a_4000_b_6000_ang_30_iradius_2000_margin_800_hres_5_lres_15.region.init
FILEPATH=${DATAOUT}/2025121700/Pre/${FILENAME}.nc
GFILEPATH=${DATAOUT}/2025121700/Pre/lat_-15_lon_-65_ellipse_a_4000_b_6000_ang_30_iradius_2000_margin_800_hres_5_lres_15.region.init.nc
POSTFILEDIR=${DATAOUT}/2025121700/Post
POSTFILEPATH=${POSTFILEDIR}/${VAR}_${FILENAME}_accelerated.png

# Ensure output directory exists
if [ ! -d "${POSTFILEDIR}" ]; then
  mkdir -p "${POSTFILEDIR}"
fi

# Write the batch script
cat << EOF0 > run_post_on_mpas_grid.bash
#!/bin/bash -x
#SBATCH --job-name=${GRID_jobname}
#SBATCH --nodes=${GRID_nnodes}
#SBATCH --ntasks=${GRID_ntasks}
#SBATCH --cpus-per-task=${GRID_ncpt}
#SBATCH --partition=${GRID_QUEUE}
#SBATCH --time=${GRID_walltime}
#SBATCH --output=${DATAOUT}/2025121700/Post/mpas_post.bash.o%j    # File name for standard output
#SBATCH --error=${DATAOUT}/2025121700/Post/mpas_post.bash.e%j     # File name for standard error output
#SBATCH --exclusive
#SBATCH --mem=${GRID_memory}G

echo "Loading anaconda..."
module load anaconda3-2022.05-gcc-11.2.0-q74p53i
echo "Making sure we have access to conda env..."
conda init
source ~/.bashrc
conda config --add envs_dirs /home/guilherme.mendonca/.conda/envs
echo "Activating conda env..."
conda activate vtx_env

if [[ \$LAT_MIN == "" ]]; then
   if [[ \$V_MIN == "" ]]; then
      python3 ${SOURCES}/CGFD-USP-Post-Proc/mpas_plot.py -f $FILEPATH -gf $GFILEPATH -v $VAR -o $POSTFILEPATH -nc ${GRID_ntasks}
   else
      python3 ${SOURCES}/CGFD-USP-Post-Proc/mpas_plot.py -f $FILEPATH -gf $GFILEPATH -vmin $V_MIN -vmax $V_MAX -v $VAR -o $POSTFILEPATH -nc ${GRID_ntasks}
   fi
else
   python3 ${SOURCES}/CGFD-USP-Post-Proc/mpas_plot.py -f $FILEPATH -gf $GFILEPATH -vmin $V_MIN -vmax $V_MAX -v $VAR -lat_min $LAT_MIN -lat_max $LAT_MAX -lon_min $LON_MIN -lon_max $LON_MAX -o $POSTFILEPATH -nc ${POST_ntasks}
fi
EOF0

# Make the batch script executable
chmod a+x run_post_on_mpas_grid.bash

# Submit the batch script
echo -e "\033[1;32m==>\033[0m Submitting script to run postprocessing and waiting for it to finish...\n"
sbatch --wait run_post_on_mpas_grid.bash

# Move the batch script to the output directory
mv run_post_on_mpas_grid.bash ${DATAOUT}/2025121700/Post
