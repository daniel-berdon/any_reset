@echo off
setlocal enableextensions enabledelayedexpansion
title Reset AnyDesk ID

:: 1. Verificar permisos de Administrador
reg query HKEY_USERS\S-1-5-19 >NUL || (
    echo Por favor, ejecuta este archivo como Administrador.
    pause
    exit
)

chcp 437 >NUL

echo Deteniendo AnyDesk...
call :stop_any

echo Realizando copia de seguridad de configuracion de usuario...

:: Borra ID antigua
del /f "%ALLUSERSPROFILE%\AnyDesk\service.conf" 2>NUL
del /f "%APPDATA%\AnyDesk\service.conf" 2>NUL
del /f "%ALLUSERSPROFILE%\AnyDesk\system.conf" 2>NUL
del /f "%APPDATA%\AnyDesk\system.conf" 2>NUL

:: Backup de preferencias y miniaturas
copy /y "%APPDATA%\AnyDesk\user.conf" "%temp%" >NUL 2>NUL
rd /s /q "%temp%\thumbnails" 2>NUL
xcopy /c /e /h /r /y /i /k "%APPDATA%\AnyDesk\thumbnails" "%temp%\thumbnails" >NUL 2>NUL

:: Limpieza de archivos (wildcard corregido)
del /f /a /q "%ALLUSERSPROFILE%\AnyDesk\ad_*" 2>NUL
del /f /a /q "%APPDATA%\AnyDesk\ad_*" 2>NUL

echo Reiniciando AnyDesk para generar nueva ID...
call :start_any

:: Espera a que se genere el archivo de sistema con la nueva ID
set /a intentos=0

:lic
timeout /t 2 /nobreak >NUL
set /a intentos+=1

if exist "%ALLUSERSPROFILE%\AnyDesk\system.conf" (
    type "%ALLUSERSPROFILE%\AnyDesk\system.conf" | find "ad.anynet.id=" >NUL
    if !errorlevel! equ 0 goto restore
)

if exist "%APPDATA%\AnyDesk\system.conf" (
    type "%APPDATA%\AnyDesk\system.conf" | find "ad.anynet.id=" >NUL
    if !errorlevel! equ 0 goto restore
)

:: Salir del bucle tras 15 intentos (~30 segundos)
if %intentos% lss 15 goto lic

echo Advertencia: No se pudo confirmar la nueva ID, continuando de todas formas...

:restore
echo Restaurando configuracion de usuario...
call :stop_any
move /y "%temp%\user.conf" "%APPDATA%\AnyDesk\user.conf" >NUL 2>NUL
xcopy /c /e /h /r /y /i /k "%temp%\thumbnails" "%APPDATA%\AnyDesk\thumbnails" >NUL 2>NUL
rd /s /q "%temp%\thumbnails" >NUL 2>NUL

echo Iniciando AnyDesk final...
call :start_any

echo *********
echo Completado.
echo(
pause
goto :eof


:: FUNCIONES

:start_any
:: Intenta iniciar servicio (si existe)
sc start AnyDesk >NUL 2>NUL
:: Busca ejecutables comunes
set AnyDesk1=%SystemDrive%\Program Files (x86)\AnyDesk\AnyDesk.exe
set AnyDesk2=%SystemDrive%\Program Files\AnyDesk\AnyDesk.exe
if exist "%AnyDesk1%" start "" "%AnyDesk1%"
if exist "%AnyDesk2%" start "" "%AnyDesk2%"
exit /b

:stop_any
:: Intenta detener servicio
sc stop AnyDesk >NUL 2>NUL
:: Mata el proceso forzosamente por si es portable
taskkill /f /im "AnyDesk.exe" >NUL 2>NUL
exit /b