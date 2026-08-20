#!/bin/bash

# ============================================================
# QIIME 2 Gut-to-Soil Axis Tutorial
#
# Official tutorial:
# https://amplicon-docs.qiime2.org/en/stable/tutorials/gut-to-soil/
# ============================================================


# ============================================================
# 1. SAMPLE METADATA
# ============================================================

wget -O 'sample-metadata.tsv' \
  'https://gut-to-soil-tutorial.readthedocs.io/en/2026.4/data/gut-to-soil/sample-metadata.tsv'

qiime metadata tabulate \
  --m-input-file sample-metadata.tsv \
  --o-visualization sample-metadata.qzv


# ============================================================
# 2. ACCESS ALREADY-IMPORTED QIIME 2 DATA
# ============================================================

wget -O 'demux.qza' \
  'https://gut-to-soil-tutorial.readthedocs.io/en/2026.4/data/gut-to-soil/demux.qza'


# ============================================================
# 3. SUMMARIZE DEMULTIPLEXED SEQUENCES
# ============================================================

qiime demux summarize \
  --i-data demux.qza \
  --o-visualization demux.qzv


# ============================================================
# 4. DADA2 - SEQUENCE QUALITY CONTROL
#    AND FEATURE TABLE CONSTRUCTION
# ============================================================

qiime dada2 denoise-paired \
  --i-demultiplexed-seqs demux.qza \
  --p-trim-left-f 0 \
  --p-trunc-len-f 250 \
  --p-trim-left-r 0 \
  --p-trunc-len-r 250 \
  --o-representative-sequences asv-seqs.qza \
  --o-table asv-table.qza \
  --o-denoising-stats denoising-stats.qza \
  --o-base-transition-stats base-transition-stats.qza


# ============================================================
# 5. SUMMARIZE DADA2 DENOISING STATISTICS
# ============================================================

qiime metadata tabulate \
  --m-input-file denoising-stats.qza \
  --o-visualization denoising-stats.qzv


# ============================================================
# 6. MERGE SAMPLE METADATA WITH DADA2 STATISTICS
# ============================================================

qiime metadata tabulate \
  --m-input-file sample-metadata.tsv denoising-stats.qza \
  --o-visualization sample-metadata-w-dada2-stats.qzv


# ============================================================
# 7. FEATURE TABLE SUMMARY
# ============================================================

qiime feature-table summarize \
  --i-table asv-table.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-summary asv-table.qzv \
  --o-sample-frequencies sample-frequencies.qza \
  --o-feature-frequencies asv-frequencies.qza


# ============================================================
# 8. TABULATE ASV SEQUENCES
# ============================================================

qiime feature-table tabulate-seqs \
  --i-data asv-seqs.qza \
  --m-metadata-file asv-frequencies.qza \
  --o-visualization asv-seqs.qzv


# ============================================================
# 9. FILTER FEATURES PRESENT IN AT LEAST 2 SAMPLES
# ============================================================

qiime feature-table filter-features \
  --i-table asv-table.qza \
  --p-min-samples 2 \
  --o-filtered-table asv-table-ms2.qza


# ============================================================
# 10. FILTER ASV SEQUENCES
# ============================================================

qiime feature-table filter-seqs \
  --i-data asv-seqs.qza \
  --i-table asv-table-ms2.qza \
  --o-filtered-data asv-seqs-ms2.qza


# ============================================================
# 11. SUMMARIZE FILTERED FEATURE TABLE
# ============================================================

qiime feature-table summarize \
  --i-table asv-table-ms2.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-summary asv-table-ms2.qzv \
  --o-sample-frequencies sample-frequencies-ms2.qza \
  --o-feature-frequencies asv-frequencies-ms2.qza


# ============================================================
# 12. TAXONOMIC ANNOTATION
# ============================================================

# Download reference sequences

wget -O 'reference-sequences.qza' \
  'https://gut-to-soil-tutorial.readthedocs.io/en/2026.4/data/gut-to-soil/reference-sequences.qza'


# Download reference taxonomy

wget -O 'reference-taxonomy.qza' \
  'https://gut-to-soil-tutorial.readthedocs.io/en/2026.4/data/gut-to-soil/reference-taxonomy.qza'


# ============================================================
# 13. VIEW REFERENCE TAXONOMY
# ============================================================

qiime feature-table tabulate-seqs \
  --i-data reference-sequences.qza \
  --i-taxonomy Greengenes_13_8_85p_OTUs:reference-taxonomy.qza \
  --p-merge-method intersect \
  --o-visualization reference-taxonomy.qzv


# ============================================================
# 14. TRAIN NAIVE BAYES TAXONOMY CLASSIFIER
# ============================================================

qiime feature-classifier fit-classifier-naive-bayes \
  --i-reference-reads reference-sequences.qza \
  --i-reference-taxonomy reference-taxonomy.qza \
  --o-classifier suboptimal-16S-rRNA-classifier.qza


# ============================================================
# 15. APPLY TAXONOMY CLASSIFIER
# ============================================================

qiime feature-classifier classify-sklearn \
  --i-classifier suboptimal-16S-rRNA-classifier.qza \
  --i-reads asv-seqs-ms2.qza \
  --o-classification taxonomy.qza


# ============================================================
# 16. VIEW ASV SEQUENCES WITH TAXONOMY
# ============================================================

qiime feature-table tabulate-seqs \
  --i-data asv-seqs-ms2.qza \
  --i-taxonomy Greengenes_13_8:taxonomy.qza \
  --m-metadata-file asv-frequencies-ms2.qza \
  --o-visualization asv-seqs-ms2.qzv


# ============================================================
# 17. K-MER-BASED DIVERSITY ANALYSIS
# ============================================================

qiime boots kmer-diversity \
  --i-table asv-table-ms2.qza \
  --i-sequences asv-seqs-ms2.qza \
  --m-metadata-file sample-metadata.tsv \
  --p-sampling-depth 96 \
  --p-n 10 \
  --p-replacement \
  --p-alpha-average-method median \
  --p-beta-average-method medoid \
  --output-dir boots-kmer-diversity


# ============================================================
# 18. ALPHA RAREFACTION
# ============================================================

qiime diversity alpha-rarefaction \
  --i-table asv-table-ms2.qza \
  --p-max-depth 260 \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization alpha-rarefaction.qzv


# ============================================================
# 19. TAXONOMIC BARPLOT
# ============================================================

qiime taxa barplot \
  --i-table asv-table-ms2.qza \
  --i-taxonomy taxonomy.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization taxa-bar-plots.qzv


# ============================================================
# 20. FILTER SAMPLES FOR ANCOM-BC2
#
# Keep:
# - Human Excrement Compost
# - Human Excrement
# - Food Compost
# ============================================================

qiime feature-table filter-samples \
  --i-table asv-table-ms2.qza \
  --m-metadata-file sample-metadata.tsv \
  --p-where '[SampleType] IN ("Human Excrement Compost", "Human Excrement", "Food Compost")' \
  --o-filtered-table asv-table-ms2-dominant-sample-types.qza


# ============================================================
# 21. ANCOM-BC2 DIFFERENTIAL ABUNDANCE
# ============================================================

qiime composition ancombc2 \
  --i-table asv-table-ms2-dominant-sample-types.qza \
  --m-metadata-file sample-metadata.tsv \
  --p-fixed-effects-formula SampleType \
  --p-reference-levels 'SampleType::Human Excrement Compost' \
  --o-ancombc2-output ancombc2-results.qza


# ============================================================
# 22. ANCOM-BC2 VISUALIZATION
# ============================================================

# Official tutorial command:

qiime composition ancombc2-visualizer \
  --i-data ancombc2-results.qza \
  --i-taxonomy taxonomy.qza \
  --o-visualization ancombc2-barplot.qzv


# ============================================================
# 23.  QIIME 2 VERSION DIFFERENCE
#
# The command above is the command in the tutorial.
# In my installed version i used:
# ============================================================

qiime composition da-barplot \
  --i-data ancombc2-results.qza \
  --i-taxonomy taxonomy.qza \
  --o-visualization ancombc2-barplot.qzv


# ============================================================
# 24. COLLAPSE ASVs TO GENUS LEVEL
# ============================================================

qiime taxa collapse \
  --i-table asv-table-ms2-dominant-sample-types.qza \
  --i-taxonomy taxonomy.qza \
  --p-level 6 \
  --o-collapsed-table genus-table-ms2-dominant-sample-types.qza


# ============================================================
# 25. ANCOM-BC2 ON GENUS-LEVEL TABLE
# ============================================================

qiime composition ancombc2 \
  --i-table genus-table-ms2-dominant-sample-types.qza \
  --m-metadata-file sample-metadata.tsv \
  --p-fixed-effects-formula SampleType \
  --p-reference-levels 'SampleType::Human Excrement Compost' \
  --o-ancombc2-output genus-ancombc2-results.qza