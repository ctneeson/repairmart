IF OBJECT_ID('sp_updateEmotionHistByID', 'P') IS NOT NULL
    DROP PROCEDURE sp_updateEmotionHistByID;
GO

CREATE PROCEDURE sp_updateEmotionHistByID
    @inp_ehid INT,
    @inp_anger INT,
    @inp_contempt INT,
    @inp_disgust INT,
    @inp_enjoyment INT,
    @inp_fear INT,
    @inp_sadness INT,
    @inp_surprise INT,
    @inp_notes VARCHAR(500),
    @inp_triggerlist VARCHAR(500),
    @inp_snapshotdate DATETIME,
    @inp_user VARCHAR(100),
    @eh_affectedRows INT OUTPUT,
    @et_affectedRows_ins INT OUTPUT,
    @et_affectedRows_del INT OUTPUT,
    @tr_affectedRows_ins INT OUTPUT,
    @tr_affectedRows_del INT OUTPUT,
    @ERR_MESSAGE VARCHAR(500) OUTPUT,
    @ERR_IND BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @ERR_IND = 0;

    IF (@inp_ehid IS NULL
        OR @inp_anger IS NULL
        OR @inp_contempt IS NULL
        OR @inp_disgust IS NULL
        OR @inp_enjoyment IS NULL
        OR @inp_fear IS NULL
        OR @inp_sadness IS NULL
        OR @inp_surprise IS NULL
        OR @inp_snapshotdate IS NULL
        OR @inp_user IS NULL)
    BEGIN
        SET @ERR_MESSAGE = 'Invalid input provided: emotion levels, snapshot date and user must not be null.';
        SET @ERR_IND = 1;
    END
    ELSE IF (NOT EXISTS (SELECT 1 FROM emotionhistory WHERE id = @inp_ehid))
    BEGIN
        SET @ERR_MESSAGE = 'Invalid snapshot ID provided';
        SET @ERR_IND = 1;
    END
    ELSE IF (NOT EXISTS (SELECT 1 FROM emotiontracker_users WHERE name = @inp_user))
    BEGIN
        SET @ERR_MESSAGE = 'Invalid user name provided.';
        SET @ERR_IND = 1;
    END
    ELSE IF (@inp_snapshotdate > GETDATE())
    BEGIN
        SET @ERR_MESSAGE = 'Invalid snapshot date: cannot be in the future';
        SET @ERR_IND = 1;
    END
    ELSE IF (@inp_anger < 0 OR @inp_anger > 10
             OR @inp_contempt < 0 OR @inp_contempt > 10
             OR @inp_disgust < 0 OR @inp_disgust > 10
             OR @inp_enjoyment < 0 OR @inp_enjoyment > 10
             OR @inp_fear < 0 OR @inp_fear > 10
             OR @inp_sadness < 0 OR @inp_sadness > 10
             OR @inp_surprise < 0 OR @inp_surprise > 10)
    BEGIN
        SET @ERR_MESSAGE = 'Invalid snapshot value(s).';
        SET @ERR_IND = 1;
    END
    ELSE IF (@inp_anger = (SELECT level_anger FROM emotionhistory WHERE id = @inp_ehid)
             AND @inp_contempt = (SELECT level_contempt FROM emotionhistory WHERE id = @inp_ehid)
             AND @inp_disgust = (SELECT level_disgust FROM emotionhistory WHERE id = @inp_ehid)
             AND @inp_enjoyment = (SELECT level_enjoyment FROM emotionhistory WHERE id = @inp_ehid)
             AND @inp_fear = (SELECT level_fear FROM emotionhistory WHERE id = @inp_ehid)
             AND @inp_sadness = (SELECT level_sadness FROM emotionhistory WHERE id = @inp_ehid)
             AND @inp_surprise = (SELECT level_surprise FROM emotionhistory WHERE id = @inp_ehid)
             AND @inp_snapshotdate = (SELECT INSERT_DATE FROM emotionhistory WHERE id = @inp_ehid)
             AND LTRIM(RTRIM(@inp_notes)) = (SELECT LTRIM(RTRIM(notes)) FROM emotionhistory WHERE id = @inp_ehid)
             AND (SELECT STRING_AGG(a.name, ',') WITHIN GROUP (ORDER BY a.name)
                  FROM (SELECT LTRIM(RTRIM(j.name)) AS name
                        FROM OPENJSON(@inp_triggerlist) WITH (name VARCHAR(50) '$')) a)
             = (SELECT STRING_AGG(t.description, ',') WITHIN GROUP (ORDER BY t.description)
                FROM triggers t
                JOIN emotion_triggers et ON et.emotionhistory_id = @inp_ehid
                WHERE t.id = et.trigger_id AND t.UPDATED_BY = @inp_user AND t.ACTIVE = 1 AND et.ACTIVE = 1))
    BEGIN
        SET @ERR_MESSAGE = 'Update snapshot rejected. No changes exist in the input values.';
        SET @ERR_IND = 1;
    END

    IF @ERR_IND = 1
    BEGIN
        RAISERROR (@ERR_MESSAGE, 16, 1);
        RETURN;
    END

    BEGIN TRANSACTION;

    -- 1. Update emotionhistory table first
    UPDATE emotionhistory
    SET level_anger = @inp_anger,
        level_contempt = @inp_contempt,
        level_disgust = @inp_disgust,
        level_enjoyment = @inp_enjoyment,
        level_fear = @inp_fear,
        level_sadness = @inp_sadness,
        level_surprise = @inp_surprise,
        notes = @inp_notes,
        INSERT_DATE = @inp_snapshotdate,
        UPDATE_DATE = GETDATE(),
        UPDATED_BY = @inp_user
    WHERE id = @inp_ehid;
    SET @eh_affectedRows = @@ROWCOUNT;

    -- 2. Delete any existing triggers that no longer apply from emotion_triggers table
    IF OBJECT_ID('tempdb..#temp_triggerids') IS NOT NULL
        DROP TABLE #temp_triggerids;

    CREATE TABLE #temp_triggerids (trigger_id INT);

    INSERT INTO #temp_triggerids (trigger_id)
    SELECT DISTINCT et.trigger_id
    FROM emotion_triggers et
    WHERE et.ACTIVE = 1
      AND et.emotionhistory_id = @inp_ehid
      AND et.trigger_id NOT IN (
          SELECT id
          FROM triggers
          WHERE ACTIVE = 1
            AND description IN (
                SELECT LTRIM(RTRIM(j.name))
                FROM OPENJSON(@inp_triggerlist) WITH (name VARCHAR(50) '$')
            )
      );

    DELETE FROM  
    WHERE emotionhistory_id = @inp_ehid
      AND ACTIVE = 1
      AND trigger_id IN (SELECT trigger_id FROM #temp_triggerids);
    SET @et_affectedRows_del = @@ROWCOUNT;

    DELETE FROM triggers
    WHERE UPDATED_BY = @inp_user
      AND ACTIVE = 1
      AND id NOT IN (
          SELECT trigger_id
          FROM emotion_triggers
          WHERE UPDATED_BY = @inp_user
            AND ACTIVE = 1
      );
    SET @tr_affectedRows_del = @@ROWCOUNT;

    -- 3. Insert any new triggers for the selected emotionhistory record into the triggers & emotion_triggers tables
    IF OBJECT_ID('tempdb..#temp_triggers') IS NOT NULL
        DROP TABLE #temp_triggers;

    CREATE TABLE #temp_triggers (description VARCHAR(500), UPDATED_BY VARCHAR(100));

    INSERT INTO #temp_triggers (description, UPDATED_BY)
    SELECT LTRIM(RTRIM(j.name)), @inp_user
    FROM OPENJSON(@inp_triggerlist) WITH (name VARCHAR(50) '$')
    WHERE LTRIM(RTRIM(j.name)) NOT IN (
        SELECT description
        FROM triggers
        WHERE ACTIVE = 1 AND UPDATED_BY = @inp_user
    );

    INSERT INTO triggers (description, UPDATED_BY)
    SELECT description, UPDATED_BY
    FROM #temp_triggers;
    SET @tr_affectedRows_ins = @@ROWCOUNT;

    IF OBJECT_ID('tempdb..#temp_emotiontriggers') IS NOT NULL
        DROP TABLE #temp_emotiontriggers;

    CREATE TABLE #temp_emotiontriggers (
        emotionhistory_id INT,
        trigger_id INT,
        UPDATED_BY VARCHAR(100)
    );

    INSERT INTO #temp_emotiontriggers (emotionhistory_id, trigger_id, UPDATED_BY)
    SELECT @inp_ehid, t.id, @inp_user
    FROM triggers t
    JOIN (SELECT LTRIM(RTRIM(j.name)) AS name
          FROM OPENJSON(@inp_triggerlist) WITH (name VARCHAR(50) '$')) tt
      ON t.description = tt.name
    WHERE t.active = 1 AND t.UPDATED_BY = @inp_user;

    INSERT INTO emotion_triggers (emotionhistory_id, trigger_id, UPDATED_BY)
    SELECT emotionhistory_id, trigger_id, UPDATED_BY
    FROM #temp_emotiontriggers
    WHERE trigger_id NOT IN (
        SELECT trigger_id
        FROM emotion_triggers
        WHERE emotionhistory_id = @inp_ehid
          AND UPDATED_BY = @inp_user
          AND ACTIVE = 1
    );
    SET @et_affectedRows_ins = @@ROWCOUNT;

    SELECT @eh_affectedRows, @et_affectedRows_del, @et_affectedRows_ins, @tr_affectedRows_del, @tr_affectedRows_ins;

    COMMIT;
END;
GO