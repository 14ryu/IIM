DELIMITER //

CREATE FUNCTION Priority
-- These are the input parameters
      (
        EnglishPriority INT, 
        ChinesePriority INT, 
        ComputerPriority INT
      )
RETURNS INT DETERMINISTIC

BEGIN
   DECLARE		EnglishPriority		INT;
   DECLARE		ChinesPriority		INT;
   DECLARE		ComputerPriority	INT;

	IF (EnglishPriority NOT BETWEEN 1 and 3 OR
		ChinesePriority NOT BETWEEN 1 and 3 OR
        ComputerPriority NOT BETWEEN 1 AND 3)
    THEN
		SELECT '1~3 사이 정수 값만 가능합니다';
		ROLLBACK;

	ELSEIF (EnglishPriority = ChinesePriority = ComputerPriority)
    THEN
		SELECT '우선 순위는 같을 수 없습니다';
		ROLLBACK;

    ELSEIF
    (EnglishPriority < ChinesePrioritiy < ComputerPriority)
    THEN SELECT *
		FROM APPLICATION AS A, RECRUITMENT AS R
		WHERE A.RecruitmentID = R.RecruitmentID
        ORDER BY A.EnglishPriority DESC, A.ChinesePriority DESC,
				A.ComputerPriority DESC, A.IncomeQuintile ASC,
                A.Grade DESC, A.StudentLoan DESC;

    ELSEIF
    (EnglishPriority < ComputerPriority <  ChinesePrioritiy)
    THEN SELECT *
		FROM APPLICATION AS A, RECRUITMENT AS R
		WHERE A.RecruitmentID = R.RecruitmentID
        ORDER BY A.EnglishPriority DESC, A.ComputerPriority DESC,
				A.ChinesePriority DESC, A.IncomeQuintile ASC,
                A.Grade DESC, A.StudentLoan DESC;

    ELSEIF
    (ChinesePriority < EnglishPrioritiy < ComputerPriority)
    THEN SELECT *
		FROM APPLICATION AS A, RECRUITMENT AS R
		WHERE A.RecruitmentID = R.RecruitmentID
        ORDER BY A.ChinesePriority DESC, A.EnglishPriority DESC,
				A.ComputerPriority DESC, A.IncomeQuintile ASC,
                A.Grade DESC, A.StudentLoan DESC;

    ELSEIF
    (ChinesePriority < ComputerPriority < EnglishPriority)
    THEN SELECT *
		FROM APPLICATION AS A, RECRUITMENT AS R
		WHERE A.RecruitmentID = R.RecruitmentID
        ORDER BY A.ChinesePriority DESC, A.ComputerPriority DESC,
				A.EnglishPriority DESC, A.IncomeQuintile ASC,
                A.Grade DESC, A.StudentLoan DESC;

    ELSEIF
    (ComputerPriority < EnglishPrioritiy < ChinesePriority)
    THEN SELECT *
		FROM APPLICATION AS A, RECRUITMENT AS R
		WHERE A.RecruitmentID = R.RecruitmentID
        ORDER BY A.ComputerPriority DESC, A.EnglishPriority DESC,
				A.ChinesePriority DESC, A.IncomeQuintile ASC,
                A.Grade DESC, A.StudentLoan DESC;

    ELSEIF
    (ComputerPriority < ChinesePriority < EnglishPrioritiy)
    THEN SELECT *
		FROM APPLICATION AS A, RECRUITMENT AS R
		WHERE A.RecruitmentID = R.RecruitmentID
        ORDER BY A.ComputerPriority DESC, A.ChinesePriority DESC,
				A.EnglishPriority DESC, A.IncomeQuintile ASC,
                A.Grade DESC, A.StudentLoan DESC;        

END IF;
END
//