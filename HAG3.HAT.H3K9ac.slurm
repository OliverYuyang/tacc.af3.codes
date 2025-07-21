#!/bin/bash
#----------------------------------------------------------------------
#SBATCH -J HAG3.HAT.H3K9ac             # Job name
#SBATCH -o HAG3.HAT.H3K9ac.o%j         # Name of stdout output file
#SBATCH -e HAG3.HAT.H3K9ac.e%j         # Name of stderr error file
#SBATCH -p gpu-a100                # Queue (partition) name
#SBATCH -N 1                       # Total # of nodes
#SBATCH -t 01:00:00                # Run time (hh:mm:ss)
#SBATCH -A MCB23097              # Allocation name
#----------------------------------------------------------------------

# Load required modules
module unload xalt
module use /scratch/tacc/apps/bio/alphafold3/modulefiles
module load alphafold3/3.0.1-ctr.lua

# Set environment variable definitions to point to your input, output, and model parameters directories:
export AF3_INPUT_DIR=$SCRATCH/af3.proj/input/
export AF3_OUTPUT_DIR=$SCRATCH/af3.proj/output/
export AF3_MODEL_PARAMETERS_DIR=$WORK/af3_parameter

# Run AlphaFold3 container
apptainer exec \
     --nv --bind $AF3_INPUT_DIR:/root/af_input \
     --bind $AF3_OUTPUT_DIR:/root/af_output \
     --bind $AF3_MODEL_PARAMETERS_DIR:/root/models \
     --bind $AF3_DATABASES_DIR:/root/public_databases \
     $AF3_IMAGE \
     python ${AF3_CODE_DIR}/run_alphafold.py \
     --json_path=/root/af_input/HAG3.HAT.H3K9ac.json \
     --model_dir=/root/models \
     --db_dir=/root/public_databases \
     --output_dir=/root/af_output
