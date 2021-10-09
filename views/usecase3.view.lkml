view: usecase3 {
  derived_table: {
    explore_source: order_items {
      column: order_id {field: order_items.order_id}
      column: user_id {field: order_items.user_id}
      column: created_time {field: order_items.created_time}
      derived_column: order_sequence {
        sql: RANK() OVER (PARTITION BY user_id ORDER BY created_time) ;;
      }
      derived_column: previous_order_dt {
        sql: LAG(created_time) OVER (PARTITION BY user_id ORDER BY created_time) ;;
      }
    }
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: user_id {
    type: number
  }

  dimension_group: created_time {
    type: time
  }

  dimension: previous_order_dt {
    type: date
  }

  dimension: order_sequence {
    type: number
  }

  dimension_group: time_between_orders {
    type: duration
    sql_start: ${previous_order_dt};;
    sql_end: ${created_time_date};;
    intervals: [day, month, week, hour]
  }

  dimension: is_first_purchase {
    type: yesno
    sql: ${previous_order_dt} IS NULL ;;
  }

  dimension: is_returning_customer_60 {
    type: yesno
    sql: ${days_time_between_orders} <= 60 ;;
  }

  measure: count {
    type: count
  }

  measure: count_returning_customers_60 {
    type: count_distinct
    filters: [is_returning_customer_60: "yes"]
    sql: ${user_id} ;;
  }

  measure: count_distinct_users {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: rcr_60 {
    type: number
    sql: ${count_returning_customers_60}/${count_distinct_users} ;;
    value_format: "0.0%"
  }
}
