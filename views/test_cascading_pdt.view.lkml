view: clean_events {
  derived_table: {
    sql:
      SELECT *
      FROM events
      WHERE type NOT IN ('test', 'staff') ;;
    datagroup_trigger: events_datagroup
  }
}

view: events_summary {
  derived_table: {
    sql:
      SELECT
        type,
        date,
        COUNT(*) AS num_events
      FROM
        ${clean_events.SQL_TABLE_NAME} AS clean_events
      GROUP BY
        type,
        date ;;
    datagroup_trigger: events_datagroup
  }
}

view: clean_events_v2 {
  derived_table: {
    sql_trigger_value: SELECT FLOOR(((TIMESTAMP_DIFF(CURRENT_TIMESTAMP(),'1970-01-01 00:00:00',SECOND)) - 60*60*16)/(60*60*24)) ;;
    create_process: {
      sql_step: SELECT *
      FROM events
       ;;

      sql_step: SELECT * FROM users WHERE user.country = 'Australia' ;;
    }
  }
}
