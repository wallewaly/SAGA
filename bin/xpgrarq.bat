@echo off
title SAGA - Exportacao - Grupos (Arquivo)
:: Rotina Exportacao - Grupos (Arquivo)
:: Esta rotina lê os grupos de um arquivo de usuário e exporta os membros de cada um dos grupos

:start
cls

:check-dir
:: Verifica o diretório atual para inibir a execução direta da rotina evitando erros

dir | findstr /i /c:"data" > nul
if errorlevel == 1 (
		exit
)

echo EM DESENVOLVIMENTO

:end

echo.

pause

call saga.bat