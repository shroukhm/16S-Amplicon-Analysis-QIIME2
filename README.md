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

1. Summarize demultiplexed sequences
2. Denoising → ASV table generation
3. Feature filtering
4. K-mer based diversity analysis
5. Alpha rarefaction
6. Taxonomic analysis
7. Differential abundance testing (ANCOM-BC2 / da-barplot)

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

### Notable biological findings
- Human Excrement (HE) is clearly separated from all other sample types in PCoA
- Human Excrement Compost (HEC) is more similar to Food Compost than to Human Excrement
- SunMar Microbe Mix has the lowest richness (~500 observed features)
- Taxonomic composition:
  - Bulking Material → dominated by **Proteobacteria**
  - Human Excrement → strongly dominated by **Firmicutes**
  - Human Excrement Compost → mainly **Proteobacteria**

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
qiime composition da-barplot ...
```
See details in 'notes/version-differences.md'
