view: user_order_facts {
  derived_table: { # this is a SQL-derived table/Ephermeral DT
    sql:  SELECT
              user_id,
              count(distinct(order_id)) AS total_orders,
              SUM(sale_price) AS total_order_values,
              min(created_at) AS first_purchase_date,
              max(created_at) AS last_purchase_date
          FROM order_items
          GROUP BY user_id
          LIMIT 10
       ;;
    datagroup_trigger: ecommerce_etl
  }

  dimension: user_id {
    primary_key: yes # IMPORTANT TO KEEP THE PRIMARY KEY DECLARED
    type: number
    sql: ${TABLE}.USER_ID;;
  }

  dimension: total_orders {
    type: number
    sql: ${TABLE}.TOTAL_ORDERS;;
  }

  dimension: total_order_values {
    type: number
    sql: ${TABLE}.TOTAL_ORDER_VALUES;;
  }

  dimension_group: first_purchase_date {
    type: time
    timeframes: [date, month, year]
    sql: ${TABLE}.FIRST_PURCHASE_DATE;;
  }

  dimension_group: last_purchase_date {
    type: time
    timeframes: [date, month, year]
    sql: ${TABLE}.LAST_PURCHASE_DATE;;
  }

  measure: average_lifetime_value {
    type: average
    sql: ${total_order_values} ;;
    value_format_name: usd
  }
}