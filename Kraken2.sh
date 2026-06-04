#!/bin/bash
#SBATCH --job-name=kraken2_all
#SBATCH --partition=aoraki
#SBATCH --array=1-84
#SBATCH --cpus-per-task=24
#SBATCH --mem=150G
#SBATCH --time=3-00:00:00
#SBATCH --output=kraken2_logs/%x_%A_%a.out
#SBATCH --error=kraken2_logs/%x_%A_%a.err

set -euo pipefail

# Paths
# Paths
SAMPLE_LIST="/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/rna-seq/trimgalore/samples.txt"
TRIMMED_DIR="/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/rna-seq/trimgalore"
KRAKEN2_DB="/projects/health_sciences/bms/biochemistry/dearden_lab/sarahinwood/dbs/kraken2/2024_12_28_standard"
CONTAINER="/projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/Containers/kraken2_2.1.3.sif"
OUTPUT_DIR="/projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/RNA_Seq/2025_Mapping/Kraken/Kraken_Redo"

# Create output and log directories if they don't exist
mkdir -p "$OUTPUT_DIR" logs

# Get sample name for this array task
SAMPLE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$SAMPLE_LIST")

# Define input files
R1="${TRIMMED_DIR}/${SAMPLE}_R1_val_1.fq.gz"
R2="${TRIMMED_DIR}/${SAMPLE}_R2_val_2.fq.gz"

# Define output files
REPORT_FILE="${OUTPUT_DIR}/${SAMPLE}.kraken2.report.txt"
OUTPUT_FILE="${OUTPUT_DIR}/${SAMPLE}.kraken2.output.txt"

# Run Kraken2
singularity exec -B /projects "$CONTAINER" \
  kraken2 \
  --db "$KRAKEN2_DB" \
  --threads 24 \
  --paired \
  --report "$REPORT_FILE" \
  --output "$OUTPUT_FILE" \
  "$R1" "$R2"
