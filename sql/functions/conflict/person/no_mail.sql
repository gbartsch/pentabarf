
-- returns all speaker/moderator without email
CREATE OR REPLACE FUNCTION conflict_person_no_email(integer) RETURNS SETOF conflict_person AS $$
  DECLARE
    cur_conference_id ALIAS FOR $1;
    cur_conflict conflict_person%rowtype;

  BEGIN

    FOR cur_conflict IN
      SELECT person_id FROM person
                            INNER JOIN event_person USING (person_id)
                            INNER JOIN event USING (event_id)
        WHERE person.email_contact IS NULL AND
              event.conference_id = cur_conference_id
    LOOP
      RETURN NEXT cur_conflict;
    END LOOP;

    RETURN;
  END;
$$ LANGUAGE 'plpgsql' RETURNS NULL ON NULL INPUT;

