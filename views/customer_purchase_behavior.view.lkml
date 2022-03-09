view: customer_purchase_behavior {
  derived_table: {
    sql: SELECT
        user_id,
        COUNT(DISTINCT(id)) AS customer_lifetime_orders,
        ROUND(SUM(sale_price), 1) AS customer_lifetime_revenues,
        MIN(created_at) AS first_purchase_date,
        MAX(created_At) AS last_purchase_date,
        DATEDIFF(year, MIN(created_at), MAX(created_at)) AS years_being_alive,
        DATEDIFF(day, MAX(created_at), CURRENT_DATE()) AS days_since_last_purchase,
        CASE
          WHEN COUNT(DISTINCT(id)) = 1 THEN '1 Order'
          WHEN COUNT(DISTINCT(id)) = 2 THEN '2 Orders'
          WHEN COUNT(DISTINCT(id)) BETWEEN 3 AND 5 THEN '3-5 Orders'
          WHEN COUNT(DISTINCT(id)) BETWEEN 6 AND 9 THEN '6-9 Orders'
          ELSE '10+ Orders'
        END AS customer_lifetime_orders_bucket,
        CASE
          WHEN ROUND(SUM(sale_price), 1) BETWEEN 0 AND 5 THEN '$0.00 - $4.99'
          WHEN ROUND(SUM(sale_price), 1) BETWEEN 5 AND 20 THEN '$5.00 - $19.99'
          WHEN ROUND(SUM(sale_price), 1) BETWEEN 20 AND 50 THEN '$20.00 - $49.99'
          WHEN ROUND(SUM(sale_price), 1) BETWEEN 50 AND 100 THEN '$50.00 - $99.99'
          WHEN ROUND(SUM(sale_price), 1) BETWEEN 100 AND 500 THEN '$100.00 - $499.99'
          WHEN ROUND(SUM(sale_price), 1) BETWEEN 500 AND 1000 THEN '$500.00 - $999.99'
          ELSE '$1000.00+'
        END AS customer_lifetime_revenues_bucket
      FROM order_items
      GROUP BY user_id
       ;;
    persist_for: "24 hours"
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.USER_ID;;
    primary_key: yes
  }

  dimension: customer_lifetime_orders {
    hidden: yes
    type: number
    sql: ${TABLE}.CUSTOMER_LIFETIME_ORDERS;;
  }

  dimension: customer_lifetime_orders_bucket {
    label: "Customer Lifetime Orders"
    type: string
    sql: ${TABLE}.CUSTOMER_LIFETIME_ORDERS_BUCKET;;
  }

  dimension: customer_lifetime_revenues {
    hidden: yes
    type: number
    sql: ${TABLE}.CUSTOMER_LIFETIME_REVENUES;;
  }

  dimension: customer_lifetime_revenues_bucket {
    label: "Customer Lifetime Revenue"
    type: string
    sql: ${TABLE}.CUSTOMER_LIFETIME_REVENUES_BUCKET;;
  }

  dimension_group: first_purchase_date {
    label: "First Order"
    type: time
    sql: ${TABLE}.FIRST_PURCHASE_DATE;;
  }

  dimension_group: last_purchase_date {
    label: "Last Order"
    type: time
    sql: ${TABLE}.LAST_PURCHASE_DATE;;
  }

  dimension: years_being_alive {
    type: number
    sql: ${TABLE}.YEARS_BEING_ALIVE;;
  }

  dimension: days_since_last_purchase {
    label: "Days Since Latest Order"
    type: number
    sql: ${TABLE}.DAYS_SINCE_LAST_PURCHASE;;
  }

  dimension: is_alive {
    type: yesno
    sql: ${days_since_last_purchase} <= 90 ;;
  }

  dimension: is_repeating_customer {
    label: "Is Repeating Customer"
    type: yesno
    sql: ${customer_lifetime_orders} > 1 ;;
  }

  measure: count {
    label: "Count"
    type: count
    drill_fields: [detail*]
  }

  measure: clv_orders {
    label: "Total Lifetime Orders"
    type: sum
    sql: ${customer_lifetime_orders} ;;
  }

  measure: clv_revenues {
    label: "Total Lifetime Revenue"
    type: sum
    sql: ${customer_lifetime_revenues} ;;
  }


  measure: avg_lifetime_orders { # double check the denominator
    label: "Average Lifetime Orders"
    type: number
    sql: ${clv_orders}/NULLIF(${count}, 0);;
    value_format: "0"
  }

  measure: avg_lifetime_revenue {
    label: "Average Lifetime Revenues"
    type: number
    sql: ${clv_revenues}/NULLIF(${count},0) ;;
    value_format_name: usd

  }


  measure: avg_days_since_latest_orders{ # double check the definition
    label: "Average Days Since Latest Orders"
    type: average
    filters: [is_alive: "yes"]
    sql: ROUND(${days_since_last_purchase}, 0) ;;
  }

  set: detail {
    fields: [
      user_id,
      customer_lifetime_orders,
      customer_lifetime_revenues,
      first_purchase_date_time,
      last_purchase_date_time,
      years_being_alive,
      days_since_last_purchase
    ]
  }
}