@echo off
rem version = "v1.01-win"

if %1== --help goto help
if %1== --version goto version
echo %1
set pdfinput=%1
REM for /f "delims=." %%m in ('echo %1') do (
	REM set nameraw = %%m
	REM echo set complete
	REM )
set cdnow= %cd%
:main
echo Welcome to Simple PDF Extractor
echo Selected file : %pdfinput%
echo 1) PDF2PDFs
echo 2) PDF2SVGs
echo 3) Custom range PDF2PDFs
echo 4) Custom range PDF2SVGs
set /p destination="Enter your choice : "
set /p folder="Make an output folder : "
md %folder%
if %destination%== 1 goto PDF2PDFs
if %destination%== 2 goto PDF2SVGs
if %destination%== 3 goto CusPDF2PDFs
if %destination%== 4 goto CusPDF2SVGs
if %destination%== exit goto end
:help
echo "Usage : pdf-extractor [FILENAME.pdf] then chose your action i.e: pdf-extractor sclash-driver.pdf"
echo.
echo "--help		show this help page"
echo "--version		display version number"
echo.
echo PDF2PDFs : extract multiple pdf pages to separated pdf files
echo PDF2SVGs : extract multiple pdf pages to separated svg files
echo.
goto end

:version
echo v1.01-win
goto end

set arch = %02d.pdf

:PDF2PDFs
pdftk %pdfinput% burst
for /f %%i in ('dir /b ^| findstr pg_') do (
	move %%i %folder%
	)
goto end

:PDF2SVGs
pdftk %pdfinput% burst
for /f "delims=." %%b in ('dir /b ^| findstr pg_') do (
	inkscape -z --file=%%b.pdf --export-plain-svg=%%b.svg
	move %%b.svg %folder%
	del %%b.pdf
	)
REM cd %cdnow%
goto end


:CusPDF2PDFs
set /p begin="Extract from page : "
set /p end="to page : "
gswin32c -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dFirstPage=%begin% -dLastPage=%end% -sOutputFile="PDFX-temp-file.pdf" "%pdfinput%"
pdftk "PDFX-temp-file.pdf" burst

del PDFX-temp-file.pdf

for /f "delims=." %%b in ('dir /b ^| findstr pg_') do (
	move %%b.pdf %folder%
	)
REM cd %cdnow%
goto end

:CusPDF2SVGs
set /p begin="Extract from page : "
set /p end="to page : "
gswin32c -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dFirstPage=%begin% -dLastPage=%end% -sOutputFile="PDFX-temp-file.pdf" "%pdfinput%"
pdftk "PDFX-temp-file.pdf" burst

del PDFX-temp-file.pdf

for /f "delims=." %%b in ('dir /b ^| findstr pg_') do (
	inkscape -z --file=%%b.pdf --export-plain-svg=%%b.svg
	move %%b.svg %folder%
	del %%b.pdf
	)
goto end

:end