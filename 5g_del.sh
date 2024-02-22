#!/bin/bash
while read p; do
rm -rf $p
done <generator_list.txt

