#!/bin/sh

set -e

curl -fsS http://localhost:8000/ready >/dev/null

exit 0