/* 
 * DB_UNIQUE_NAME: Name of the database as specified in the DB_UNIQUE_NAME initialization parameter.
 */ 
SELECT SYS_CONTEXT('USERENV', 'DB_UNIQUE_NAME') FROM DUAL;
--
SELECT SYS_CONTEXT('USERENV', 'SESSIONID') FROM DUAL;
--
/* OS_USER: Operating system username of the client process that initiated the database session. */
SELECT SYS_CONTEXT('USERENV', 'OS_USER') FROM DUAL;

/* IP_ADDRESS: IP address of the machine from which the client is connected. */
SELECT SYS_CONTEXT('USERENV', 'IP_ADDRESS') FROM DUAL;

/* HOST: Name of the host machine from which the client has connected. */
SELECT SYS_CONTEXT('USERENV', 'HOST') FROM DUAL;

/* Get Current User*/
SELECT SYS_CONTEXT('USERENV', 'CURRENT_USER') FROM DUAL;

/* Get Current Schema*/
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') FROM DUAL;

/* To get further info :
 * http://psoug.org/reference/sys_context.html?__cf_chl_jschl_tk__=691046d4af00fe9a998bc3998b103771619726fd-1621510833-0-AchA-Cdx8qKhGbX2W77nk2KVR_CIjLPukmVkXbq96pbIGk-RyClR39l60sZ5d53-w7fuY5peNO2AyM_qTRWMrv_qjmdKb0OBN-kyAHHJDjr9eUviuCRZyPwZ1eiSpjD0HKYNBIQTLRFNTa-3nfe8Mmlkp8CgssDDaWbn7CN3XJbQgW77lyrlGibBgaNPD-7XKI21FS0sWoAYoUZ_drayDzXrbNpBbGNAkieJZCGia6XyDykxDbvTmN2yOBNMegMx60FeWn2wUaohPzX3eSJ3hhIvCGr8Bj6z4Pkn4KVMF49P4fsYgX6N7UW3d1OvDs9-abQxHIKqxpj41fy9cyHs46Prhf6hnL1-Bjr9wLZWMBlibRHSzjoZFRHCi97wLa_7_VCKZ_cUxg2rW7UbcyaucLBBMVG0wgGjvkpQyx6Dxtr9
 */

/* LANG: The ISO abbreviation for the language name, a shorter form than the 
 * existing 'LANGUAGE' parameter. 
 */
SELECT SYS_CONTEXT('USERENV', 'LANG') FROM DUAL;

/* LANGUAGE: The language and territory currently used by your session, 
 * along with the database character set, in the form:
 * language_territory.characterset.
 */
SELECT SYS_CONTEXT('USERENV', 'LANGUAGE') FROM DUAL;

/* MODULE: The application name (module) set through the 
 * DBMS_APPLICATION_INFO package or OCI
 */
SELECT SYS_CONTEXT('USERENV', 'MODULE') FROM DUAL;

/* NLS_CALENDAR: The current calendar of the current session. */
SELECT SYS_CONTEXT('USERENV', 'NLS_CALENDAR') FROM DUAL;

/* NLS_CURRENCY: The currency of the current session.*/
SELECT SYS_CONTEXT('USERENV', 'NLS_CURRENCY') FROM DUAL;

/* NLS_DATE_FORMAT: The date format for the session.*/
SELECT sys_context('USERENV', 'NLS_DATE_FORMAT') FROM DUAL;

/* NLS_DATE_LANGUAGE: The language used for expressing dates.*/
SELECT SYS_CONTEXT('USERENV', 'NLS_DATE_LANGUAGE') FROM DUAL;

/* NLS_SORT: BINARY or the linguistic sort basis.*/
SELECT SYS_CONTEXT('USERENV', 'NLS_SORT') FROM DUAL;

/* NLS_TERRITORY: The territory of the current session.*/
SELECT SYS_CONTEXT('USERENV', 'NLS_TERRITORY') FROM DUAL;

/* 
 * SERVER_HOST: The host name of the machine on which the instance is running.
 */
SELECT SYS_CONTEXT('USERENV', 'SERVER_HOST') FROM DUAL; 

SELECT SYS_CONTEXT('USERENV', 'TERMINAL') FROM DUAL;

SELECT SYS_CONTEXT('USERENV', 'DB_NAME') FROM DUAL;

SELECT SYS_CONTEXT('USERENV', 'DB_DOMAIN') FROM DUAL;

SELECT SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER') FROM DUAL;

SELECT SYS_CONTEXT('USERENV', 'CLIENT_INFO') FROM DUAL;

SELECT SYS_CONTEXT('USERENV', 'SERVICE_NAME') FROM DUAL;

SELECT SYS_CONTEXT('USERENV','INSTANCE_NAME') FROM DUAL;

SELECT SYS_CONTEXT('USERENV','CURRENT_SQL') FROM DUAL;

SELECT sys_context('USERENV', 'SID') FROM DUAL; 

--???
SELECT SYS_CONTEXT('USERENV', 'CURRENT_EDITION_NAME') FROM DUAL;

-- Find "sys_context(userenv" usages in database 
SELECT * FROM dba_source ds 
WHERE LOWER(DS.TEXT) LIKE '%sys_context(''userenv''%'
--AND LOWER(DS.TEXT) NOT LIKE '%db_unique_name%'
ORDER BY DS.OWNER, DS.TYPE
;