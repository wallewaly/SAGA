@echo off
title SAGA - Exportacao - Usuarios
:: Rotina Exportação - Usuários
:: Esta rotina exporta para um txt a relação de todos os grupos que um usuario é membro

:start
cls

:check-dir
:: Verifica o diretório atual para inibir a execução direta da rotina evitando erros

dir | findstr /i /c:"data" > nul
if errorlevel == 1 (
		exit
)

::Obter data e hora do sistema

for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j
set ldt=%ldt:~0,8%

::Solicita nome de usuário para consulta e padroniza em letras maiúsculas

:usname
set upper=
echo insira o nome de logon do usuario a ser exportado:
set /p str=
if not defined str goto usname
for /f "skip=2 delims=" %%i in ('tree "\%str%"') do if not defined upper set "upper=%%~i"
set "upper=%upper:~3%"
set usuario=%upper%

:: Definir nome do arquivo

set filename=data\users\%usuario%_%ldt%.txt

::Verificar se o arquivo existe e remover duplicatas
if exist %filename% (
		del %filename%
)

:consulta

:: Verifica se o usuario informado existe no AD e, caso exista, gera o TXT

dsquery user -samid %usuario%|dsget user |findstr /i /R  "%usuario%" > nul

if errorlevel == 1 (
		cls
		echo Usuario nao encontrado.
		echo Por favor, insira um usuario valido.
		echo.
		goto usname
) else (
		echo Consultando o AD...
		dsquery user -samid %usuario% | dsget user -memberof >> %filename%
		echo.
		echo Acessos de usuario exportados para %filename%
		explorer /select, "%filename%"
)

:end

echo.

pause

cls

call saga.bat