# Metapipe-hacks
-------------

A collection of small scripts for meta-pipe

For more detailed help in running the scripts, run them with --help

## Annotator and exporter replacement prototype
* annotate.py
* create_db.py

A replacement for the annotator and exporter, which should run a few orders of magnitude faster.

**create_db.py** creates a database from a uniprot .dat file, which is required for annotating BLAST results from META-pipe
**annotate.py** produces a EMBL file with annotations. Currently the data in the annotations is minimal.

## MGA-exporter
* mga-exporter.py

A replacement for the MGA exporter, which runs a few orders of magnitude faster
