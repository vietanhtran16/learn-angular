#!/bin/bash -l
set -e

npm run build && aws s3 sync ./dist/angularWhatever  s3://viet-whatever-app-dev/ --delete
