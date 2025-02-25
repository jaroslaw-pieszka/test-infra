#!/usr/bin/env bash

set -o errexit
set -o pipefail # Fail a pipe if any sub-command fails.

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=prow/scripts/cluster-integration/kyma-serverless-run-test.sh
source "${SCRIPT_DIR}/kyma-serverless-run-test.sh"

date

make -C "$SERVERLESS_SOURCES"/components/operator/hack/ci replace-chart-images run-without-lifecycle-manager

export INTEGRATION_SUITE=("$@")
run_tests "${INTEGRATION_SUITE[@]}"
