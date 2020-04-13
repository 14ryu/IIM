DELIMITER //
CREATE FUNCTION NetScore
(
varEnglish VARCHAR(10),
varChinese VARCHAR(10),
varComputerSkills VARCHAR(10)
)
RETURNs INT DETERMINISTIC

BEGIN
	DECLARE NetScore INT;
    SET Netscore = 0.1*SUBSTRING(varEnglish,6,4)+10*SUBSTRING(varChinese,5,1)
    +50*CHARACTER_LENGTH(SUBSTRING(varComputerSkills,7,1));
    RETURN Netscore;
END
//
