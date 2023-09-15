@echo off
title SAGA - Replicar permissoes - Usuario
:: Rotina Replicar Permissões - Usuário
:: Copia as permissões de um usuário para outro no AD
:: Este script compara dois usuarios do AD e acrescenta permissões faltantes no usuario destino

:start
cls

:check-dir
:: Verifica o diretório atual para inibir a execução direta da rotina evitando erros

dir | findstr /i /c:"data" > nul
if errorlevel == 1 (
		exit
)

:user-origem

:: Levantamento de dados necessarios 

echo De quem os acessos deverao ser copiados?
set /P origem=
if not defined origem echo Insira um usuario valido & echo. & goto user-origem

::Validação de usuario: Verifica se o usuário informado existe no AD

dsquery user -samid %origem% |dsget user| findstr /i /c:"%origem%" > nul

if errorlevel == 1 (
		cls
		echo Usuario nao encontrado
		echo Por favor, verifique os dados informados e tente novamente.
		echo.
		goto user-origem
) else (
		goto user-destino
)

:user-destino

:: Levantamento de dados necessarios 

echo Quem recebera os acessos?
set /P destino=
if not defined origem echo Insira um usuario valido & echo. & goto user-origem

::Validação de usuario: Verifica se o usuário informado existe no AD e gera script (caso o user exista)

dsquery user -samid %destino% |dsget user| findstr /i /c:"%destino%" > nul

if errorlevel == 1 (
		cls
		echo Usuario nao encontrado
		echo Por favor, verifique os dados informados e tente novamente.
		echo.
		goto user-destino
) else (
		
		echo $CopyFromUser = Get-ADUser %origem% -prop MemberOf >> data\rpusu.ps1
		echo $CopyToUser = Get-ADUser %destino% -prop MemberOf >> data\rpusu.ps1
		echo $CopyFromUser.MemberOf ^| Where{$CopyToUser.MemberOf -notcontains $_} ^|  Add-ADGroupMember -Member $CopyToUser >> data\rpusu.ps1
		
		
		PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& data\rpusu.ps1" >> log\log.txt
		
		
		del data\rpusu.ps1
)

:end

echo.

pause

call saga.bat