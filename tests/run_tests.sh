#!/bin/sh

echo "Running VALID tests"
for f in tests/valid/*.txt; do
    echo "==> $f"
    ./parser < "$f"
done

echo
echo "Running INVALID tests"
for f in tests/invalid/*.txt; do
    echo "==> $f"
    ./parser < "$f" || true
done
