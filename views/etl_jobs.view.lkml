view: etl_jobs {
  sql_table_name: etl_jobs
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ID;;
  }

  dimension_group: completed {

    label: "some description again"

    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.COMPLETED_AT;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
