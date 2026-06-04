#!/bin/bash
#SBATCH --job-name=trimgalore
#SBATCH --cpus-per-task=64
#SBATCH --mem=128G
#SBATCH --time=3-00:00:00
#SBATCH --output=trimgalore.out
#SBATCH --error=trimgalore.err
#SBATCH --partition=aoraki

# Define image path
IMAGE="/projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/Containers/trimgalore_0.6.10.sif"

# Loop through files ending in .fq.gz containing _R1
for r1_file in /projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/RNA_Seq/2025_Mapping/Raw_Data/Z1383/*_R1.fq.gz
do
    # Replace "_R1" with "_R2" to get the pair filename
    r2_file="${r1_file/_R1/_R2}"

    # Check if R2 file actually exists before running
    if [[ ! -f "$r2_file" ]]; then
        echo "Error: Could not find pair $r2_file for $r1_file. Skipping..."
        continue
    fi

    echo "Processing pair: $r1_file and $r2_file"

    singularity exec "$IMAGE" trim_galore \
        --quality 20 \
        --fastqc \
        --cores 8 \
        --paired \
        "$r1_file" "$r2_file"

done
