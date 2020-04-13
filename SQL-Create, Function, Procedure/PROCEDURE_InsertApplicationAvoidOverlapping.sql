
/*한 공고에의 중복 방지 프로시저*/
DELIMITER //

CREATE PROCEDURE InsertApplicationAvoidOverlapping
			(IN		newStudentID	   			INT,
             IN		newRecruitmentID		VARCHAR(45))

spicwt:BEGIN

	DECLARE	varRowCount			  	Int;

	# Check to see if InsertApplicationAvoidOverlapping already exist in APPLICATION

	SELECT	COUNT(*) INTO varRowCount
	FROM		APPLICATION
	WHERE		RecruitmentID = newRecruitmentID
		AND		StudentID = newStudentID;

	# IF (varRowCount > 0) THEN Student already enroll.
	IF (varRowCount > 0)
		THEN
       SELECT '이미 지원한 공고입니다.';
		   ROLLBACK;
       LEAVE spicwt;
	  END IF;

	# IF varRowCount = 0 THEN Student does not exist in APPLICATION.
  IF (varRowCount = 0)
		THEN
    spicwtif:BEGIN
	    # Start transaction - Rollback everything if unable to complete it.
	    START TRANSACTION;

      # Insert new STUDENT data.
	    INSERT INTO APPLICATION (StudentID, RecruitmentID)
           VALUES(newStudentID, newRecruimentID);

	    # Commit the Transaction
	    COMMIT;
      END spicwtif;
    END IF;
END spicwt
//

DELIMITER ;

