# 16S Amplicon Analysis with QIIME 2

This repository documents my hands-on work following the official **QIIME 2 Gut-to-Soil tutorial**  
as part of the **2026 Research Summer Internship** at Nile University  
(Lab of Dr. Mohamed Mysara – Bioinformatics benchmarking track).

**Official tutorial followed:**  
https://amplicon-docs.qiime2.org/en/stable/tutorials/gut-to-soil/

---

## Objectives
- Install and run QIIME 2 on macOS (Apple Silicon)
- Complete the full Gut-to-Soil pipeline
- Generate ASVs, diversity analyses, taxonomy, and differential abundance results
- Document all steps and outputs for reproducibility

---

## Installation (macOS Apple Silicon)

See detailed instructions in:  
[`installation/mac-apple-silicon.md`](installation/mac-apple-silicon.md)

Main reference used:  
https://library.qiime2.org/quickstart/qiime2

---

## Pipeline Overview

- Sample metadata exploration
- Demultiplexed sequence quality assessment
- ASV generation
- Feature-table exploration
- K-mer-based diversity analysis
- Alpha diversity
- Beta diversity
- Taxonomic classification
- Taxonomic barplots
- Differential abundance analysis using ANCOM-BC2

---

## Dataset

The tutorial uses 16S rRNA gene sequencing data from the Gut-to-Soil Axis study.

The data represents different sample types related to human excrement composting and soil/compost environments.

The dataset contains:

- 104 forward samples
- 104 reverse samples
- 
The analysis includes different sample types associated with human excrement, compost, soil, and related materials.

---
## Software

- QIIME 2
- Conda / Miniconda
- Bash
- macOS Apple Silicon
- QIIME 2 `.qza` artifacts
- QIIME 2 `.qzv` visualizations

---
## Key Results Summary

### Demultiplexed sequences
- Total samples: **104** (forward) + **104** (reverse)
- Total sequences: **62,378** (forward) + **62,378** (reverse)
- Median sequences per sample: **659.5**

### ASV Table (before filtering)
- Number of samples: **104**
- Number of unique features (ASVs): **1,069**
- Total observations: **39,949**
- Mean sequence length: **253.33 bp**

### After filtering
- Number of samples: **99**
- Number of unique features: **335**
- Total observations: **29,978**

### Taxonomic Analysis

Different sample types showed different dominant bacterial groups.

- Bulking Material was mainly dominated by Proteobacteria.
- Food Compost showed a mixture of Proteobacteria, Actinobacteria, and Firmicutes.
- Human Excrement was strongly dominated by Firmicutes.
- Human Excrement Compost was predominantly Proteobacteria, with Bacteroidetes and Actinobacteria also present.

### Differential Abundance

ANCOM-BC2 was used to investigate differential abundance between sample groups.

The analysis identified taxa including SMB53 and Epulopiscium as enriched in specific comparisons, while Pseudomonadaceae and Blautia were depleted in specific comparisons.

---

## Important Note about Version Difference

The official tutorial uses:

```bash
qiime composition ancombc2-visualizer \
  --i-data ancombc2-results.qza \
  --i-taxonomy taxonomy.qza \
  --o-visualization ancombc2-barplot.qzv
```
Because of a different QIIME 2 version, I used:

```bash
qiime composition da-barplot \
  --i-data ancombc2-results.qza \
  --i-taxonomy taxonomy.qza \
  --o-visualization ancombc2-barplot.qzv
```
