#!/bin/bash
#SBATCH --job-name=fastqc_trimgalore
#SBATCH --cpus-per-task=32
#SBATCH --mem=212G
#SBATCH --time=3-00:00:00
#SBATCH --output=fastqc_trimgalore_samples_removed.out
#SBATCH --error=fastqc_trimgalore_samples_removed.err
#SBATCH --partition=aoraki
#SBATCH --array=1-38

# Set locale to avoid Perl warnings
export LC_ALL=C

# Define paths
DATA_DIR=/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/rna-seq/trimgalore_samples_removed
OUT_DIR=/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/rna-seq/fastqc/trimgalore
CONTAINER=/projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/Containers/fastqc_0.12.1.sif

# Create output and log directories if they don't exist
mkdir -p "$OUT_DIR"
mkdir -p "$OUT_DIR/logs"

# Get sample name based on SLURM array task ID
SAMPLE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ${DATA_DIR}/samples.txt)

# Exit if no sample name is found
if [[ -z "$SAMPLE" ]]; then
    echo "ERROR: No sample found for array task ID ${SLURM_ARRAY_TASK_ID}"
    exit 1
fi

# Define input read paths
R1="${DATA_DIR}/${SAMPLE}_R1_val_1.fq.gz"
R2="${DATA_DIR}/${SAMPLE}_R2_val_2.fq.gz"

# Run FastQC via Singularity
singularity exec "$CONTAINER" fastqc \
    -o "$OUT_DIR" \
    -f fastq \
    -t 6 \
    "$R1" "$R2"
