# XFM Memory Channel Interleave Compression Emulation

This repository contains an evaluation of the compression ratio performance of
XFM's compressed data layout when using memory channel interleaving

[`run.sh`] contains a script to reorder data within a set of corpus files
 into XFM's interleaved data format before performing compression for 1, 2, and
 4 DIMMs before compressing and comparing ratios
 
[`fetch_corpus.sh`] fetches and prepares the corpus files for testing

[`build_gzip.sh`] fetches and builds gzip-1.10

* Running the experiment (generating data for figure 8 in [XFM:Accelerating Far Memory using Near Memory Processing](https://www.micro56.org/))
```sh
./build_gzip.sh
./fetch_corpus.sh
./run.sh
```

## More information

For more information see our MICRO 2023 paper
