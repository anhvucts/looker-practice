view: usecase1 {
  derived_table: {
    sql:
          SELECT
            user_id,
            COUNT(DISTINCT(order_id)) AS total_lifetime_orders,
            CASE
              WHEN COUNT(DISTINCT(order_id)) = 1 THEN '1 Order'
              WHEN COUNT(DISTINCT(order_id)) = 2 THEN '2 Orders'
              WHEN COUNT(DISTINCT(order_id)) BETWEEN 3 AND 5 THEN '3-5 Orders'
              WHEN COUNT(DISTINCT(order_id)) BETWEEN 6 AND 9 THEN '6-9 Orders'
              ELSE '10 Orders'
            END AS customer_lifetime_orders,
            SUM(sale_price) AS total_lifetime_value,
            MIN(created_at) AS first_order_date,
            MAX(created_at) AS last_order_date
          FROM order_items
          GROUP BY user_id
        ;;
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."USER_ID" ;;
  }
  dimension: total_lifetime_orders {
    type: number
  }
  dimension: customer_lifetime_orders {
    type: string
  }
  dimension: customer_lifetime_revenue {
    type: tier
    tiers: [5, 20, 50, 100, 500, 1000]
    sql: ${total_lifetime_value} ;;
    style: integer
    value_format_name: usd
  }
  dimension: total_lifetime_value {
    type: number
    value_format_name: usd
  }
  dimension_group: first_order {
    type: time
    timeframes: [date, month, year]
    sql: ${TABLE}."FIRST_ORDER_DATE" ;;
  }

  dimension_group: last_order{
    type: time
    timeframes: [date, month, year]
    sql: ${TABLE}."LAST_ORDER_DATE" ;;
  }

  dimension_group: since_latest_order {
    type: duration
    intervals: [day, month]
    sql_start: ${last_order_date};;
    sql_end: CURRENT_DATE();;
  }

  dimension: is_active_customer {
    type: yesno
    sql: ${days_since_latest_order} <= 90;;
  }

  dimension: is_repeating_customer {
    type: yesno
    sql: ${total_lifetime_orders} > 1;;
  }

  measure: avg_lifetime_orders {
    type: average
    sql: ${total_lifetime_orders};;
  }
  measure: avg_lifetime_revenue {
    type: average
    sql: ${total_lifetime_value};;
  }

  measure: avg_days_since_latest_order {
    type: average
    sql: ${days_since_latest_order};;
  }

  measure: count {
    type: count
    drill_fields: [details*]
  }

  set: details  {
    fields: [user_id]
  }
}
