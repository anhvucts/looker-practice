view: customer_purchase_behavior {
  derived_table: {
    sql: SELECT
        user_id,
        COUNT(DISTINCT(id)) AS customer_lifetime_orders,
        ROUND(SUM(sale_price), 1) AS customer_lifetime_revenues,
        MIN(created_at) AS first_purchase_date,
        MAX(created_At) AS last_purchase_date,
        DATEDIFF(month, MIN(created_at), MAX(created_at)) AS months_being_alive,
        DATEDIFF(day, MAX(created_at), CURRENT_DATE()) AS days_since_last_purchase
        --ROUND(COUNT(DISTINCT(id))/NULLIF(DATEDIFF(month, MIN(created_at), MAX(created_at)), 0), 0) AS avg_lifetime_orders_month
      FROM order_items
      GROUP BY user_id
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: customer_lifetime_orders {
    type: number
    sql: ${TABLE}."CUSTOMER_LIFETIME_ORDERS" ;;
  }

  dimension: customer_lifetime_revenues {
    type: number
    sql: ${TABLE}."CUSTOMER_LIFETIME_REVENUES" ;;
  }

  dimension_group: first_purchase_date {
    type: time
    sql: ${TABLE}."FIRST_PURCHASE_DATE" ;;
  }

  dimension_group: last_purchase_date {
    type: time
    sql: ${TABLE}."LAST_PURCHASE_DATE" ;;
  }

  dimension: months_being_alive {
    type: number
    sql: ${TABLE}."MONTHS_BEING_ALIVE" ;;
  }

  dimension: days_since_last_purchase {
    type: number
    sql: ${TABLE}."DAYS_SINCE_LAST_PURCHASE" ;;
  }

  set: detail {
    fields: [
      user_id,
      customer_lifetime_orders,
      customer_lifetime_revenues,
      first_purchase_date_time,
      last_purchase_date_time,
      months_being_alive,
      days_since_last_purchase
    ]
  }
}
