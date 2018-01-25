/*================================================================*/
/* Database name:  GameParadise			                          */
/* DBMS name:      Microsoft SQL Server 2017                      */
/* Created on:     20/12/2017							          */
/* Made by:        Martijn de Geus								  */
/* Purpose:        Views for reports							  */
/*================================================================*/

USE GAMEPARADISE
GO

-- Cre�er view voor artikelen die nu zijn verhuurd
DROP VIEW VIEW_MOMENTEEL_VERHUURD
GO;

CREATE VIEW VIEW_MOMENTEEL_VERHUURD AS
SELECT
	AR.BARCODE, HU.EINDDATUM,
	CASE WHEN AR.TITEL IS NULL THEN CONCAT(COALESCE(RTRIM(AR.MERK), ' '), SPACE(1), COALESCE(RTRIM(AR.TYPE), ' ')) ELSE AR.TITEL END AS ARTIKEL
FROM HUUROVEREENKOMST HU
INNER JOIN ARTIKELENVERHUUR AV ON HU.EMAILADRES = AV.EMAILADRES AND HU.STARTDATUM = AV.STARTDATUM
INNER JOIN ARTIKEL AR ON AV.BARCODE = AR.BARCODE
WHERE HU.HUURSTATUS = 'VERHUURD' AND HU.STARTDATUM <= GETDATE() AND HU.EINDDATUM >= GETDATE()
GROUP BY AR.BARCODE, AR.TITEL, AR.MERK, AR.TYPE, HU.EINDDATUM
ORDER BY ARTIKEL;

-- Cre�er view voor spellen die niet zijn verhuurd in 2016
DROP VIEW VIEW_MOMENTEEL_VERHUURD
GO;

CREATE VIEW VIEW_NIET_VERHUURD_2016 AS
SELECT
	AR.BARCODE, AR.TITEL
FROM 
	ARTIKEL AR
WHERE BARCODE NOT IN 
	(
		SELECT 
			AR.BARCODE
		FROM HUUROVEREENKOMST HU
		INNER JOIN ARTIKELENVERHUUR AV ON HU.EMAILADRES = AV.EMAILADRES AND HU.STARTDATUM = AV.STARTDATUM
		INNER JOIN ARTIKEL AR ON AV.BARCODE = AR.BARCODE
		WHERE AR.SPEL_OF_CONSOLE = 'SPEL' AND HU.HUURSTATUS = 'VERHUURD' AND YEAR(HU.STARTDATUM) = 2016 
		OR AR.SPEL_OF_CONSOLE = 'SPEL' AND HU.HUURSTATUS = 'VERHUURD' AND YEAR(HU.EINDDATUM) = 2016
	)
	AND AR.SPEL_OF_CONSOLE = 'SPEL'

-- Cre�er view voor omzet per maand voor 2012 - 2017 NIET KLAAR! (view in view -> eerst alles wat omzet heeft opgeleverd en dan een view daarop maken)
DROP VIEW VIEW_OMZET_PER_MAAND
GO

DROP PROCEDURE PROC_VERKOOPOMZET_PER_MAAND
GO

CREATE PROCEDURE PROC_VERKOOPOMZET_PER_MAAND AS

DECLARE @YEAR INT;
DECLARE @MONTH INT;
SET @YEAR = 2012;

CREATE TABLE #Temp
(
    MAAND VARCHAR(255),
	TOTAAL VARCHAR(255)
)

WHILE @YEAR <= 2017
BEGIN
   SET @MONTH = 1;
   WHILE @MONTH < 13
   BEGIN
	   INSERT INTO #Temp
	   SELECT MAAND, SUM(OMZETVERKOOP) AS TOTAAL 
	   FROM
		   (
			   SELECT CONCAT(@YEAR, '-', FORMAT(@MONTH, '0#')) AS MAAND, SUM(AR.PRIJS) AS OMZETVERKOOP
			   FROM VERKOOPOVEREENKOMST VK
			   INNER JOIN ARTIKELENVERKOOP AV ON VK.EMAILADRES = AV.EMAILADRES AND VK.DATUM = AV.DATUM
			   INNER JOIN ARTIKEL AR ON AV.BARCODE = AR.BARCODE
			   WHERE MONTH(VK.DATUM) = @MONTH AND YEAR(VK.DATUM) = @YEAR
			   GROUP BY AR.BARCODE
		   ) OVZ
		   WHERE OMZETVERKOOP IS NOT NULL
		   GROUP BY MAAND;
	   SET @MONTH = @MONTH + 1;
   END
   SET @YEAR = @YEAR + 1;
END;

SELECT MAAND, TOTAAL
FROM #Temp

IF(OBJECT_ID('tempdb..#temp') Is Not Null)
BEGIN
    DROP TABLE #Temp
END


GO

DROP PROCEDURE PROC_VERHUUROMZET_PER_MAAND
GO

CREATE PROCEDURE PROC_VERHUUROMZET_PER_MAAND AS

DECLARE @YEAR INT;
DECLARE @MONTH INT;
SET @YEAR = 2012;

CREATE TABLE #Temp
(
    MAAND VARCHAR(255),
	TOTAAL VARCHAR(255)
)

WHILE @YEAR <= 2017
BEGIN
   SET @MONTH = 1;
   WHILE @MONTH < 13
   BEGIN
	   INSERT INTO #Temp
	   SELECT MAAND, SUM(OMZETVERHUUR) AS TOTAAL 
	   FROM
		   (
			   SELECT CONCAT(@YEAR, '-', FORMAT(@MONTH, '0#')) AS MAAND, SUM(AR.PRIJS_PER_D * DATEDIFF(day, HU.STARTDATUM, HU.EINDDATUM)) AS OMZETVERHUUR
			   FROM HUUROVEREENKOMST HU
			   INNER JOIN ARTIKELENVERHUUR AV ON HU.EMAILADRES = AV.EMAILADRES AND HU.STARTDATUM = AV.STARTDATUM
			   INNER JOIN ARTIKEL AR ON AV.BARCODE = AR.BARCODE
			   WHERE MONTH(HU.STARTDATUM) = @MONTH AND YEAR(HU.STARTDATUM) = @YEAR 
			   GROUP BY AR.BARCODE
		   ) OVZ
		   WHERE OMZETVERHUUR IS NOT NULL
		   GROUP BY MAAND;
	   SET @MONTH = @MONTH + 1;
   END
   SET @YEAR = @YEAR + 1;
END;

SELECT MAAND, TOTAAL
FROM #Temp

IF(OBJECT_ID('tempdb..#temp') Is Not Null)
BEGIN
    DROP TABLE #Temp
END


GO

DROP PROCEDURE PROC_TOTALE_OMZET_PER_MAAND
GO

CREATE PROCEDURE PROC_TOTALE_OMZET_PER_MAAND AS

CREATE TABLE #verkoop
(
	MAAND VARCHAR(255),
	TOTAAL MONEY
)

CREATE TABLE #verhuur
(
	MAAND VARCHAR(255),
	TOTAAL MONEY
)

INSERT INTO #verkoop
EXEC PROC_VERKOOPOMZET_PER_MAAND

INSERT INTO #verhuur
EXEC PROC_VERHUUROMZET_PER_MAAND


SELECT 
	VK.MAAND, COALESCE(VK.TOTAAL + VH.TOTAAL, VK.TOTAAL, VH.TOTAAL, 0) AS OMZET
FROM #verkoop VK
LEFT JOIN #verhuur VH ON VK.MAAND = VH.MAAND
GROUP BY VK.MAAND, VK.TOTAAL, VH.TOTAAL

IF(OBJECT_ID('tempdb..#verkoop') IS NOT NULL)
BEGIN
    DROP TABLE #verkoop
END

IF(OBJECT_ID('tempdb..#verhuur') IS NOT NULL)
BEGIN
    DROP TABLE #verhuur
END

CREATE VIEW OMZET_PER_MAAND AS
SELECT * FROM
OPENQUERY('exec [GAMEPARADISE].[dbo].[PROC_TOTALE_OMZET_PER_MAAND]')
GO

-- Cre�er view voor alle consoles in reparatie
DROP VIEW VIEW_CONSOLES_IN_REPARATIE
GO

CREATE VIEW VIEW_CONSOLES_IN_REPARATIE AS

SELECT 
	AR.BARCODE, AR.MERK, AR.TYPE, AR.PRIJS, RE.KOSTEN, RE.DATUM_GEREED
FROM REPARATIE RE
INNER JOIN ARTIKEL AR ON RE.BARCODE = AR.BARCODE
WHERE RE.REPARATIESTATUS = 'IN REPARATIE'

GO

-- Cre�er view voor top tien spellen verhuur
DROP VIEW VIEW_TOP_10_SPELLEN_VERHUUR;
GO

CREATE VIEW VIEW_TOP_10_SPELLEN_VERHUUR AS
SELECT TOP 10
	AR.TITEL, COUNT(*) AS KEREN_VERHUURD, SUM(DATEDIFF(day, HO.STARTDATUM, HO.EINDDATUM)) AS DAGEN_VERHUURD,
	SUM(DATEDIFF(day, HO.STARTDATUM, HO.EINDDATUM) * AR.PRIJS_PER_D) AS OMZET 
FROM
HUUROVEREENKOMST HO
INNER JOIN ARTIKELENVERHUUR AV ON HO.EMAILADRES = AV.EMAILADRES AND HO.STARTDATUM = AV.STARTDATUM
INNER JOIN ARTIKEL AR ON AV.BARCODE = AR.BARCODE
WHERE AR.SPEL_OF_CONSOLE = 'SPEL'
GROUP BY AR.TITEL
ORDER BY SUM(DATEDIFF(day, HO.STARTDATUM, HO.EINDDATUM)) DESC

-- Cre�er view voor top tien spellen verkoop
DROP VIEW VIEW_TOP_10_SPELLEN_VERKOOP;
GO

CREATE VIEW VIEW_TOP_10_SPELLEN_VERKOOP AS
SELECT TOP 10
	AR.TITEL, SUM(AR.PRIJS) AS OMZET, COUNT(*) AS KEREN_VERKOCHT
FROM
VERKOOPOVEREENKOMST VO
INNER JOIN ARTIKELENVERKOOP AV ON VO.EMAILADRES = AV.EMAILADRES AND VO.DATUM = AV.DATUM
INNER JOIN ARTIKEL AR ON AV.BARCODE = AR.BARCODE
WHERE AR.SPEL_OF_CONSOLE = 'SPEL'
GROUP BY AR.TITEL
ORDER BY COUNT(*) DESC, SUM(AR.PRIJS) DESC

-- Cre�er view voor alle spellen
DROP VIEW VIEW_ALLE_SPELLEN;
GO

CREATE VIEW VIEW_ALLE_SPELLEN AS
SELECT
	TITEL, JAAR_UITGAVE, UITGEVER, LEEFTIJDSCATEGORIE, OMSCHRIJVING
FROM SPEL SP