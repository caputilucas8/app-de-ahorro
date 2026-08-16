@echo off
REM ============================================================
REM  Respaldo de la app de ahorro.
REM  Doble clic y listo: guarda una copia fechada y, si Git esta
REM  configurado, tambien deja un commit en el historial.
REM ============================================================
cd /d "%~dp0"

for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HHmm"') do set STAMP=%%i

if not exist "copias" mkdir "copias"
copy /Y "ahorro.html" "copias\ahorro_%STAMP%.html" >nul
echo Copia guardada en: copias\ahorro_%STAMP%.html

git rev-parse --is-inside-work-tree >nul 2>&1
if %errorlevel%==0 (
  git add -A
  git commit -m "Respaldo %STAMP%" >nul 2>&1
  if %errorlevel%==0 (echo Commit hecho en el historial de Git.) else (echo Sin cambios para commitear.)
  git remote get-url origin >nul 2>&1
  if %errorlevel%==0 (
    echo Subiendo a GitHub...
    git push -q origin HEAD && echo Subido. || echo No se pudo subir. Fijate la conexion o el login.
  )
)

echo.
echo Listo. Cerra esta ventana.
pause >nul
