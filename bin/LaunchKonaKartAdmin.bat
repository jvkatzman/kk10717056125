@echo off
rem ======================
rem  Launch KonaKartAdmin
rem ======================

set KK_TOMCAT_BIN=%~dp0

echo ========================================
echo Waiting for the KonaKart server to start
echo.

:try_again
if exist "..\work\Catalina\localhost\konakartadmin" goto ready
sleep 2
goto try_again


:ready 

rem adjust this sleep value to suit your environment:
sleep 7

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
