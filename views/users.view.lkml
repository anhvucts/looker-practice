include: "/views/geography_fields.view"
view: users {
  extends: [geography_fields]
  sql_table_name: users;;
  drill_fields: [id]

### dynamic field picker

parameter: cohort_picker {
  type: unquoted
  allowed_value: {
    label: "City"
    value: "city"
  }
  allowed_value: {
    label: "Country"
    value: "country"
  }
  allowed_value: {
    label: "Gender"
    value: "gender"
  }
}

dimension: selected_cohort {
  type: string
  label_from_parameter: cohort_picker
  sql: ${TABLE}.{% parameter cohort_picker %};;
}

  parameter: metric_picker {
    type: unquoted
    allowed_value: {
      label: "Average days from signup"
      value: "avg_days_from_signup"
    }
    allowed_value: {
      label: "Max days from signup"
      value: "max_days_from_signup"
    }
    allowed_value: {
      label: "Total users"
      value: "count"
    }
  }

  measure: selected_metric {
    type: string
    label_from_parameter: metric_picker
    sql:
    CASE
      WHEN {% parameter metric_picker %} = 'Average days from signup' THEN ${avg_days_from_signup}
      WHEN {% parameter metric_picker %} = 'Max days from signup' THEN ${max_days_from_signup}
      WHEN {% parameter metric_picker %} = 'Total users' THEN ${count}
    ELSE NULL
    END
    ;;
  }


  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ID;;
    group_label: "Identifiers"
  }

  dimension: city_and_state {
    type: string
    sql: CONCAT(${city}, ' ', ${state});;
    group_label: "Demographics"

  }

  dimension: age {
    type: number
    sql: ${TABLE}.AGE;;
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
    sql: ${TABLE}.CITY;;
    drill_fields: [gender, state]
    link: {
      label: "{{value}} drill down"
      url: "/dashboards/65?City={{ value | url_encode}}"
    }
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.COUNTRY;;
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
    sql: ${TABLE}.CREATED_AT;;

  }

  dimension: created {
    type: date
    sql: ${created_date} ;;
    link: {
      label: "{{value}} drill down"
      url: "/dashboards/65?Gender={{ _filters['users.gender'] | url_encode}}&State={{ _filters['users.state'] | url_encode}}
      &Date+Input={{filterable_value}}"
    }
}
  dimension: current {
    type: date
    sql: CURRENT_DATE ;;
  }


  filter: date_input {
    type: date
    sql: {% condition date_input %} ${users.created_date} {% endcondition %};;
  }


  dimension: email {
    type: string
    sql: ${TABLE}.EMAIL;;
    #required_access_grants: [exclude_email_address]
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.FIRST_NAME;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.GENDER;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.LAST_NAME;;
  }

  dimension: first_last_name {
    type: string
    sql: CONCAT(${first_name}, ' ' , ${last_name}) ;;
  }


  dimension: latitude {
    type: number
    sql: ${TABLE}.LATITUDE;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.LONGITUDE;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.STATE;;
    # required_access_grants: [state]
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.TRAFFIC_SOURCE;;


  }

  # dimension: email or not
  dimension: is_traffic_source_email {
    type: yesno
    sql: ${traffic_source} = 'Email' ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.ZIP;;
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
    # link: {
    #   label: "User info"
    #   url: "
    #   { % if _explore._name == users %}
    #     /ctspartner.de.looker.com/dashboards/3
    #   {% elsif _explore._name == order_items %}
    #   /ctspartner.de.looker.com/dashboards/1
    #   {% else %}
    #   /ctspartner.de.looker.com/dashboards/6
    #   {% endif %}
    #   "
    # }
  }

  # dimension: days since signup
  dimension: days_since_signup {
    type: number
    sql: date_diff(current_date, ${created_date},  day);; # redshift syntax
  }


  dimension: is_new_customer {
    type: yesno
    sql: ${days_since_signup} <= 90 ;;
  }

  dimension: months_since_signup {
    type: number
    sql: date_diff(current_date, ${created_date}, month) ;;
  }

# test parameter stuff

  parameter: cr_generator {
    type: number
  }

  measure: cr_calculated {
    type: number
    sql: NULLIF({% parameter cr_generator %}/100, 0);;
    value_format_name: percent_1
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
    value_format: "0"

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
    #drill_fields: [gender, state]

  }

  measure: from_target {
    type: number
    sql: (1000000000 - ${count})/1000000000 ;;
    value_format_name: percent_3

  }
  measure: count_html {
    type: count
    html: <p>{{rendered_value}} <br> {{users.from_target._rendered_value}} </br>
    <br>from reaching target </br> </p>;;
  }
}
