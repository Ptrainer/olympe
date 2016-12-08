#!/usr/bin/env bash

set -eu
source $PTRAINER/scripts/lib/compose.sh

dc_run_volatile website rails c
