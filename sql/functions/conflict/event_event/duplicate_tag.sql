
-- returns events with conflicting tags
CREATE OR REPLACE FUNCTION conflict.conflict_event_event_duplicate_tag( INTEGER ) RETURNS SETOF conflict.conflict_event_event AS $$
  DECLARE 
    cur_conference_id ALIAS FOR $1;
    cur_event RECORD;
    cur_event2 RECORD;
    conflicting_event conflict.conflict_event_event%ROWTYPE;
  BEGIN
-- Loop through all events
    FOR cur_event IN
      SELECT event.event_id,
             event.slug
        FROM event
       WHERE event.conference_id = cur_conference_id AND
             event.event_state = 'accepted' AND
             event.slug IS NOT NULL
    LOOP
      FOR cur_event2 IN
        SELECT event_id 
          FROM event 
         WHERE event.conference_id = cur_conference_id AND 
               event.event_id <> cur_event.event_id AND
               event.event_state = 'accepted' AND
               event.slug = cur_event.slug
      LOOP
        conflicting_event.event_id1 := cur_event.event_id;
        conflicting_event.event_id2 := cur_event2.event_id;
        RETURN NEXT conflicting_event;
      END LOOP;
    END LOOP;
    RETURN;
  END;
$$ LANGUAGE 'plpgsql';

