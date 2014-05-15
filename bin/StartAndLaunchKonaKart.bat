@echo off
rem ===========================
rem  Start and Launch KonaKart
rem ===========================

set KK_TOMCAT_BIN=%~dp0

call "%KK_TOMCAT_BIN%/startkonakart.bat"

echo ========================================
echo Waiting for the KonaKart server to start
echo.

:try_konakart_again
if exist "..\work\Catalina\localhost\konakart" goto konakart_ready
sleep 2
goto try_konakart_again

:konakart_ready 

:try_konakartadmin_again
if exist "..\work\Catalina\localhost\konakartadmin" goto konakartadmin_ready
sleep 2
goto try_konakartadmin_again


:konakartadmin_ready 

rem adjust this sleep value to suit your environment:
sleep 15

rem start the KonaKart application UI
start http://localhost:8780/konakart/

rem we need to have a little gap here otherwise the first browser window is overwritten
rem adjust as appropriate - your mileage may differ :-)
sleep 10

rem start the KonaKart Admin application UI
start http://localhost:8780/konakartadmin/


rem
rem (c) 2006 DS Data Systems UK Ltd, All rights reserved.
rem
rem DS Data Systems and KonaKart and their respective logos, are 
rem trademarks of DS Data Systems UK Ltd. All rights reserved.
rem
rem The information in this document is the proprietary property of
rem DS Data Systems UK Ltd. and is protected by English copyright law,
rem the laws of foreign jurisdictions, and international treaties,
rem as applicable. No part of this document may be reproduced,
rem transmitted, transcribed, transferred, modified, published, or
rem translated into any language, in any form or by any means, for
rem any purpose other than expressly permitted by DS Data Systems UK Ltd.
rem in writing.
rem
