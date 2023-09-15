@echo off
title SAGA - Exportacao - Grupo
:: Rotina Exportacao - Grupo
:: Esta rotina exporta uma relação de todos os membros de um grupo para um arquivo txt

:start
cls

:check-dir
:: Verifica o diretório atual para inibir a execução direta da rotina evitando erros

dir | findstr /i /c:"data" > nul
if errorlevel == 1 (
		exit
)

:: obter data e hora do sistema

for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j
set ldt=%ldt:~0,8%%ldt:~8,2%%ldt:~10,2%
if not defined ldt goto date_error


:: Menu 2º nível

:menu-n2

echo Digite a opcao desejada:
echo.
echo 1) Digitar nome dos grupos
echo 2) Obter grupos de um arquivo TXT
echo.
echo ou digite S para sair
echo.

choice /C 12s

if errorlevel 3 cls & call saga.bat
if errorlevel 2 call bin\xpgrarq.bat
if errorlevel 1 goto gpname


::Solicita nome do grupo e padroniza colocando em letras maiúsculas

:gpname
cls
set upper=
echo Insira o nome do grupo a ser exportado:
set /p str=
if not defined str goto gpname
for /f "skip=2 delims=" %%I in ('tree "\%str%"') do if not defined upper set "upper=%%~I"
set "upper=%upper:~3%"
set grupo=%upper%

if not defined grupo echo por favor insira o nome do grupo & goto gpname

:: Definir nome padrão do arquivo exportado

set filename=data\groups\%grupo%_%ldt%.txt

::Verificar se o arquivo existe e remover duplicatas
if exist %filename% (
		del %filename%
)

:consulta

::Valida se o usuário inseriu um grupo existente no AD e, se existir, gera o txt

dsquery group -name "%grupo%" | dsget group -samid | findstr /i /R  "dsquery group -name "%grupo%" | dsget group -samid" > nul

if errorlevel == 1 (
		cls
		echo Este grupo nao existe no Active Directory.
		echo Por favor insira um grupo valido.
		goto gpname
) else (
		cls
		echo Consultando o AD...
		dsquery group -name "%grupo%" | dsget group -members >> %filename%
		echo.
		echo Grupo exportado para %filename%
		explorer /select, "%filename%"
)

:end

echo.

pause

cls

call saga.bat