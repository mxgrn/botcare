#!/usr/bin/env sh

set -euf -o pipefail

# the only way I found to clean up the ssh tunnel on exiting the script
trap "pkill -f 'ssh.*lbdb'" SIGINT SIGTERM EXIT

# note: this won't become a child process of the current script
ssh -N -f -L 1111:localhost:5432 lbdb

psql -U botcare_prod -d botcare_prod -h localhost -p 1111
