@echo off
REM test.bat — validate colored-charac-shape.lua against test.md
REM Run from repo root: test.bat
REM Generates .\output\test.{html,docx,pdf} and reports pass/fail.

setlocal enabledelayedexpansion

set SCRIPT_DIR=%~dp0
set FILTER=%SCRIPT_DIR%colored-charac-shape.lua
set INPUT=%SCRIPT_DIR%test.md
set OUTDIR=%SCRIPT_DIR%output

set FAILURES=0

if not exist "%OUTDIR%" mkdir "%OUTDIR%"

echo === colored-charac-shape test suite ===
echo Filter : %FILTER%
echo Input  : %INPUT%
echo Output : %OUTDIR%
echo.

REM --- helper macros ---
set "pass=echo PASS  "
set "fail=echo FAIL  "

REM --- function: run_pandoc ---
REM %1 = format name, %2 = extension, %3 = extra args
:run_pandoc
set FMT=%~1
set EXT=%~2
set EXTRA=%~3
set OUTFILE=%OUTDIR%\test.%EXT%

pandoc "%INPUT%" ^
--lua-filter "%FILTER%" ^
--standalone ^
%EXTRA% ^
-o "%OUTFILE%" 2>pandoc_err.txt

if %ERRORLEVEL% EQU 0 (
call %pass%%FMT% ^> %OUTFILE%
) else (
call %fail%%FMT%: pandoc exited with error
type pandoc_err.txt
set /a FAILURES+=1
)
goto :eof

REM --- run formats ---
call :run_pandoc "HTML" "html" ""
call :run_pandoc "DOCX" "docx" ""

REM --- PDF detection ---
where pdflatex >nul 2>&1
if %ERRORLEVEL% EQU 0 (
set PDF_ENGINE=pdflatex
) else (
where xelatex >nul 2>&1
if %ERRORLEVEL% EQU 0 (
set PDF_ENGINE=xelatex
) else (
echo SKIP  PDF: no LaTeX engine found (pdflatex / xelatex)
goto after_pdf
)
)

call :run_pandoc "PDF" "pdf" "--pdf-engine=%PDF_ENGINE%"

:after_pdf

echo.
echo === Content checks ===

set HTML_OUT=%OUTDIR%\test.html

REM --- function: check_html ---
REM %1 = pattern, %2 = description
:check_html
findstr /C:%~1 "%HTML_OUT%" >nul
if %ERRORLEVEL% EQU 0 (
call %pass%HTML contains %~2
) else (
call %fail%HTML missing %~2
set /a FAILURES+=1
)
goto :eof

call :check_html "color:#FF0000" "red square"
call :check_html "color:#00FF00" "green square"
call :check_html "color:#0000FF" "blue square"
call :check_html "color:#FF8800" "orange circle"
call :check_html "color:#FFD700" "gold triangle"
call :check_html "color:#FF69B4" "hot pink diamond"
call :check_html "color:#FF00FF" "magenta star"
call :check_html "■" "square entity"
call :check_html "●" "circle entity"
call :check_html "▲" "triangle entity"
call :check_html "◆" "diamond entity"
call :check_html "★" "star entity"
call :check_html "notashape:#FF0000" "unmatched code passes through"

echo.
if %FAILURES% EQU 0 (
echo All checks passed.
) else (
echo %FAILURES% check(s) failed.
exit /b 1
)

endlocal
