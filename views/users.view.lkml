include: "/views/geography_fields.view"
view: users {
  extends: [geography_fields]
  sql_table_name: "PUBLIC"."USERS";;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
    group_label: "Identifiers"
  }

  dimension: city_and_state {
    type: string
    sql: CONCAT(${city}, ' ', ${state});;
    group_label: "Demographics"
  }

  dimension: age {
    type: number
    sql: ${TABLE}."AGE" ;;
    group_label: "Demographics"
  }

  dimension: age_bucket {
    type: tier
    tiers: [18, 25, 35, 45, 55, 65, 75, 90]
    sql: ${age};;
    style: integer
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

  dimension: state_location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude:${longitude};;
    drill_fields: [products.category, products.brand]
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
    required_access_grants: [exclude_email_address]
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

  dimension: first_last_name {
    type: string
    sql: CONCAT(${first_name}, ' ' , ${last_name}) ;;
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
    # required_access_grants: [state]
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}."TRAFFIC_SOURCE" ;;
    drill_fields: [age_group, gender, is_new_customer]
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
    tiers: [15, 26, 36, 51, 66]
    style:  integer
    drill_fields: [gender]
  }

  # dimension: days since signup
  dimension: days_since_signup {
    type: number
    sql: DATEDIFF(day, ${created_date}, current_date);; # redshift syntax
  }


  dimension: is_new_customer {
    type: yesno
    sql: ${days_since_signup} <= 90 ;;
  }

  dimension: months_since_signup {
    type: number
    sql: DATEDIFF(month, ${created_date}, current_date) ;;
  }

  dimension: cohort_group {
    type: tier
    sql: ${days_since_signup} ;;
    tiers: [30, 60, 90, 180, 365]
    style:  integer
  }

  measure: avg_days_from_signup {
    type: average
    sql: ${days_since_signup} ;;
  }

  measure: avg_months_from_signup {
    type: average
    sql: ${months_since_signup} ;;
  }

  measure: max_days_from_signup {
    type: max
    sql: ${days_since_signup} ;;
  }

  measure: count {
    type: count
    drill_fields: [users.id, users.last_name, users.first_name, events.count, order_items.count]
  }
}
