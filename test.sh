#!/usr/bin/env bash
# test.sh — validate colored-charac-shape.lua against test.md
# Run from the repo root: bash ./test.sh
# Generates ./output/test.{html,docx,pdf} and reports pass/fail.

set -euo pipefail

FILTER="$(cd "$(dirname "$0")" && pwd)/colored-charac-shape.lua"
INPUT="$(dirname "$0")/test.md"
OUTDIR="$(dirname "$0")/output"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

pass() { echo -e "${GREEN}PASS${NC}  $1"; }
fail() { echo -e "${RED}FAIL${NC}  $1"; FAILURES=$((FAILURES + 1)); }

FAILURES=0
mkdir -p "$OUTDIR"

run_pandoc() {
  local fmt="$1" ext="$2" extra="${3:-}"
  local out="$OUTDIR/test.$ext"
  if pandoc "$INPUT" \
      --lua-filter "$FILTER" \
      --standalone \
      $extra \
      -o "$out" 2>/tmp/pandoc_err; then
    pass "$fmt → $out"
  else
    fail "$fmt: pandoc exited with error"
    cat /tmp/pandoc_err >&2
  fi
}

echo "=== colored-charac-shape test suite ==="
echo "Filter : $FILTER"
echo "Input  : $INPUT"
echo "Output : $OUTDIR"
echo ""

HTML_OUT="$OUTDIR/test.html"
DOCX_OUT="$OUTDIR/test.docx"

# HTML
run_pandoc "HTML" "html"

# DOCX
run_pandoc "DOCX" "docx"

# PDF (requires a LaTeX engine default is pdflatex, fall back to xelatex)
PDF_ENGINE="pdflatex"
if ! command -v pdflatex &>/dev/null; then
  PDF_ENGINE="xelatex"
fi
if ! command -v "$PDF_ENGINE" &>/dev/null; then
  echo "SKIP  PDF: no LaTeX engine found (pdflatex / xelatex)"
else
  run_pandoc "PDF" "pdf" "--pdf-engine=$PDF_ENGINE"
fi

# Verify HTML output with expected color spans
echo ""
echo "=== Content checks ==="

check_html() {
  local pattern="$1" desc="$2"
  if grep -q "$pattern" "$HTML_OUT"; then
    pass "HTML contains $desc"
  else
    fail "HTML missing $desc"
  fi
}

check_html 'color:#FF0000' 'red square'
check_html 'color:#00FF00' 'green square'
check_html 'color:#0000FF' 'blue square'
check_html 'color:#FF8800' 'orange circle'
check_html 'color:#FFD700' 'gold triangle'
check_html 'color:#FF69B4' 'hot pink diamond'
check_html 'color:#FF00FF' 'magenta star'
check_html '&#x25A0;'      'square entity'
check_html '&#x25CF;'      'circle entity'
check_html '&#x25B2;'      'triangle entity'
check_html '&#x25C6;'      'diamond entity'
check_html '&#x2605;'      'star entity'
check_html 'notashape:#FF0000' 'unmatched code passes through'

echo ""
if [ "$FAILURES" -eq 0 ]; then
  echo -e "${GREEN}All checks passed.${NC}"
else
  echo -e "${RED}$FAILURES check(s) failed.${NC}"
  exit 1
fi
