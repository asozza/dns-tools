#!/bin/bash
#
#SBATCH --job-name=af
#SBATCH -o ./%x.%j.out
#SBATCH -e ./%x.%j.err
#SBATCH --partition=Cascade
#SBATCH --nodes=2
#SBATCH --ntasks=128
#SBATCH --ntasks-per-node=64
#SBATCH --time=4-00:00:00
#
module purge
module use /applis/PSMN/debian11/E5/modules/all
module load intel-compilers/2021.2.0
module load OpenMPI/4.1.1-intel-compilers-2021.2.0
module load iomkl/2021a
module load FFTW/2.1.5-iomkl-2021a
#
cd $SLURM_SUBMIT_DIR
#
set -x
#
mpirun -np $SLURM_NTASKS ./af
