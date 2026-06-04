#!/bin/bash
#SBATCH --job-name=star_index
#SBATCH --cpus-per-task=32
#SBATCH --mem=512G
#SBATCH --time=7-00:00:00
#SBATCH --output=star_index.out
#SBATCH --error=star_index.err
#SBATCH --partition=aoraki

singularity exec -B /projects,/weka /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/rna-seq/star/star_2.7.10a_alpha_220506.sif \
	STAR \
	--runThreadN 32 \
	--runMode genomeGenerate \
	--genomeDir /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/rna-seq/star/star_output \
	--genomeFastaFiles /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/hi-c/final_assembly.fasta \
	--genomeChrBinNbits 18 \
	--limitGenomeGenerateRAM 160000000000
