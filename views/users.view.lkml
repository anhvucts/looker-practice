view: users {
  sql_table_name: "PUBLIC"."USERS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}."AGE" ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}."COUNTRY" ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."FIRST_NAME" ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}."GENDER" ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."LAST_NAME" ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}."LATITUDE" ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}."LONGITUDE" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."STATE" ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}."TRAFFIC_SOURCE" ;;
  }
  # dimension: email or not
  dimension: is_traffic_source_email {
    type: yesno
    sql: ${traffic_source} = 'Email' ;;

  }
  dimension: zip {
    type: zipcode
    sql: ${TABLE}."ZIP" ;;
  }
  # dimension: city + state
  dimension: place {
    type:  string
    sql: ${city} || ', ' || ${state} ;;
  }

  # dimension: age groups
  dimension: age_group {
    type:  tier
    sql: ${age} ;;
    tiers: [18, 25, 35, 45, 55, 65, 75, 90]
    style:  integer
  }

  # dimension: days since signup
  dimension: days_since_signup {
    type: number
    sql: DATEDIFF(day, ${created_date}, current_date);; # redshift syntax
  }

  measure: signup_date {
    type: date_time
    sql: min(${created_date}) ;;
  }

  measure: count {
    type: count
    drill_fields: [users.id, users.last_name, users.first_name, events.count, order_items.count]
  }
}
