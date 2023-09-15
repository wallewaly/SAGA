@echo off
title SAGA v2 - Menu principal
:: Script Auxiliar de Gerenciamento do Active Directory - v2
:: Escrito por Walison Santos
echo SAGA - Script Auxiliar de Gerenciamento do Active Directory
echo.
echo Escolha uma opcao:
echo.

::Menu de rotinas

echo 1) Exportar membros de grupo
echo 2) Exportar acessos de um usuario
echo 3) Replicar acessos de um usuario para outro
echo.
echo Ou digite S para sair
echo.

::Ações do menu

choice /c 123s

if errorlevel 4 exit
if errorlevel 3 call "bin/rpusu.bat"
if errorlevel 2 call "bin/xpusu.bat"
if errorlevel 1 call "bin/xpgrp.bat"
if errorlevel not defined echo Insira uma opcao valida

:end
echo Fim da rotina
pause
exit
