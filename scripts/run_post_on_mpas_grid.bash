#!/bin/bash -x
#SBATCH --job-name=GridPlot.MONAN
#SBATCH --nodes=4
#SBATCH --ntasks=512
#SBATCH --cpus-per-task=1
#SBATCH --partition=batch
#SBATCH --time=8:00:00
#SBATCH --output=/mnt/beegfs/guilherme.mendonca/scripts_CD-CT/dataout/2025121700/Post/mpas_post.bash.o%j    # File name for standard output
#SBATCH --error=/mnt/beegfs/guilherme.mendonca/scripts_CD-CT/dataout/2025121700/Post/mpas_post.bash.e%j     # File name for standard error output
#SBATCH --exclusive
#SBATCH --mem=32G

echo "Loading anaconda..."
module load anaconda3-2022.05-gcc-11.2.0-q74p53i
echo "Making sure we have access to conda env..."
conda init
source ~/.bashrc
conda config --add envs_dirs /home/guilherme.mendonca/.conda/envs
echo "Activating conda env..."
conda activate vtx_env

if [[ $LAT_MIN == "" ]]; then
   if [[ $V_MIN == "" ]]; then
      python3 /mnt/beegfs/guilherme.mendonca/scripts_CD-CT/sources/CGFD-USP-Post-Proc/mpas_plot.py -f /mnt/beegfs/guilherme.mendonca/scripts_CD-CT/dataout/2025121700/Pre/lat_-15_lon_-65_ellipse_a_4000_b_6000_ang_30_iradius_2000_margin_800_hres_5_lres_15.region.init.nc -gf /mnt/beegfs/guilherme.mendonca/scripts_CD-CT/dataout/2025121700/Pre/lat_-15_lon_-65_ellipse_a_4000_b_6000_ang_30_iradius_2000_margin_800_hres_5_lres_15.region.init.nc -v surface_pressure -o /mnt/beegfs/guilherme.mendonca/scripts_CD-CT/dataout/2025121700/Post/surface_pressure_lat_-15_lon_-65_ellipse_a_4000_b_6000_ang_30_iradius_2000_margin_800_hres_5_lres_15.region.init_accelerated.png -nc 512
   else
      python3 /mnt/beegfs/guilherme.mendonca/scripts_CD-CT/sources/CGFD-USP-Post-Proc/mpas_plot.py -f /mnt/beegfs/guilherme.mendonca/scripts_CD-CT/dataout/2025121700/Pre/lat_-15_lon_-65_ellipse_a_4000_b_6000_ang_30_iradius_2000_margin_800_hres_5_lres_15.region.init.nc -gf /mnt/beegfs/guilherme.mendonca/scripts_CD-CT/dataout/2025121700/Pre/lat_-15_lon_-65_ellipse_a_4000_b_6000_ang_30_iradius_2000_margin_800_hres_5_lres_15.region.init.nc -vmin  -vmax  -v surface_pressure -o /mnt/beegfs/guilherme.mendonca/scripts_CD-CT/dataout/2025121700/Post/surface_pressure_lat_-15_lon_-65_ellipse_a_4000_b_6000_ang_30_iradius_2000_margin_800_hres_5_lres_15.region.init_accelerated.png -nc 512
   fi
else
   python3 /mnt/beegfs/guilherme.mendonca/scripts_CD-CT/sources/CGFD-USP-Post-Proc/mpas_plot.py -f /mnt/beegfs/guilherme.mendonca/scripts_CD-CT/dataout/2025121700/Pre/lat_-15_lon_-65_ellipse_a_4000_b_6000_ang_30_iradius_2000_margin_800_hres_5_lres_15.region.init.nc -gf /mnt/beegfs/guilherme.mendonca/scripts_CD-CT/dataout/2025121700/Pre/lat_-15_lon_-65_ellipse_a_4000_b_6000_ang_30_iradius_2000_margin_800_hres_5_lres_15.region.init.nc -vmin  -vmax  -v surface_pressure -lat_min  -lat_max  -lon_min  -lon_max  -o /mnt/beegfs/guilherme.mendonca/scripts_CD-CT/dataout/2025121700/Post/surface_pressure_lat_-15_lon_-65_ellipse_a_4000_b_6000_ang_30_iradius_2000_margin_800_hres_5_lres_15.region.init_accelerated.png -nc 
fi
