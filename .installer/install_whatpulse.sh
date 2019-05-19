#!/bin/bash

arch="$( if ((1<<32)); then echo 64; else echo 32; fi;)"
version="313"  # for ubuntu derivates

download_url="https://whatpulse.org/downloads/${version}/{$arch}bit/"
