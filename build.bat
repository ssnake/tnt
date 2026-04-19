@echo off
setlocal EnableDelayedExpansion

set "STUDIO_ROOT="
for %%I in ("%ProgramFiles(x86)%\Embarcadero\Studio") do set "STUDIO_ROOT=%%~sI"
if not defined STUDIO_ROOT set "STUDIO_ROOT=%ProgramFiles(x86)%\Embarcadero\Studio"
set "RSVARS="

for %%V in (29.0 28.0 27.0 26.0 25.0 24.0 23.0 22.0 21.0 20.0 19.0 18.0 17.0) do (
  if not defined RSVARS if exist "!STUDIO_ROOT!\%%V\bin\rsvars.bat" (
    set "RSVARS=!STUDIO_ROOT!\%%V\bin\rsvars.bat"
  )
)

if not defined RSVARS (
  for /d %%D in ("!STUDIO_ROOT!\*") do (
    if not defined RSVARS if exist "%%~fD\bin\rsvars.bat" (
      set "RSVARS=%%~fD\bin\rsvars.bat"
    )
  )
)

if not exist "%RSVARS%" (
  echo [ERROR] rsvars.bat not found under:
  echo         %STUDIO_ROOT%
  exit /b 1
)

echo [INFO] Using %RSVARS%

call "%RSVARS%"
if errorlevel 1 (
  echo [ERROR] Failed to initialize Delphi environment.
  exit /b 1
)

dcc32 -NSWinapi;System;Data;Xml;Vcl;Vcl.Imaging -U"%BDS%\lib\win32\release" TnT.dpr
set "BUILD_EXIT=%ERRORLEVEL%"

if "%BUILD_EXIT%"=="0" (
  echo.
  echo [OK] Build succeeded.
) else (
  echo.
  echo [ERROR] Build failed with exit code %BUILD_EXIT%.
)

exit /b %BUILD_EXIT%
