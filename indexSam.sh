#!/bin/sh
samtools index Aip02.sorted.bam
1>Aip02.index.log and 2>Aip02.index.err &
