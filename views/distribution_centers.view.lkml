view: distribution_centers {
  sql_table_name: "PUBLIC"."DISTRIBUTION_CENTERS"
    ;;
  drill_fields: [id]
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}."LATITUDE" ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}."LONGITUDE" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
    #view_label: "Test view label"
  }

  parameter: select_distribution_center {
    type: string
    suggest_dimension: distribution_centers.name
  }

  dimension: selected_center {
    type: string
    sql: CASE WHEN ${name} = {% parameter select_distribution_center %} THEN ${name}
    ELSE NULL END;;
  }
  measure: count {
    type: count
    drill_fields: [id, name, products.count]
  }
}
