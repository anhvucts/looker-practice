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
