#!/usr/bin/env bash

set -e

# Check if src directory exists
if [ ! -d "./src" ]; then
    echo "Warning: src directory not found. Skipping coverage generation."
    exit 0
fi

# Check if .gcno files exist in src directory
if ! find ./src -name "*.gcno" | grep -q .; then
    echo "Warning: No .gcno files found in src directory. Skipping coverage generation."
    echo "Note: To generate coverage data, compile with coverage flags (e.g., --coverage or -fprofile-arcs -ftest-coverage)"
    exit 0
fi

echo "Generating coverage report..."

# Get absolute path of src directory (resolves symlinks)
SRC_ABS_PATH=$(cd ./src && pwd)

# Generate coverage data
lcov --capture --directory ./src --output-file coverage.info --ignore-errors gcov,source

# Extract only files from our project's src directory
lcov --extract coverage.info "${SRC_ABS_PATH}/*" --output-file coverage.info --ignore-errors source

# Generate HTML report
genhtml coverage.info --output-directory coverage

echo "Coverage report generated successfully!"
echo "Open coverage/index.html to view the report"
