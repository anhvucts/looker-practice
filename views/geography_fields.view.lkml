view: geography_fields {
  extension: required
  dimension: city {
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."STATE" ;;
  }

}
