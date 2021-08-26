view: order_items {
  sql_table_name: "PUBLIC"."ORDER_ITEMS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
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

  dimension_group: delivered {
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
    sql: ${TABLE}."DELIVERED_AT" ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension_group: returned {
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
    sql: ${TABLE}."RETURNED_AT" ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
  }

  dimension_group: shipped {
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
    sql: ${TABLE}."SHIPPED_AT" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: shipping_days {
    type: duration_day
    sql_start: ${shipped_date} ;;
    sql_end: ${delivered_date} ;;
  }

  # multiple condition filter
  measure: status_cancelled_ocean_avenue {
    type: count
    filters: [status: "-Cancelled"]
  }

  measure: min_shipping_days {
    type: min
    sql: ${shipping_days} ;;
  }

  measure: max_shipping_days {
    type: max
    sql: ${shipping_days} ;;
  }

  measure: sum_price {
    label: "Total sale price"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: average {
    label: "Average sale price"
    type:  average
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: count_orders {
    label: "Total orders"
    type:  count_distinct
    sql: ${order_id} ;;
  }
  # % unique orders
  measure: perc_orders {
    label: "Percentage orders"
    type: percent_of_total
    sql: ${count_orders} ;;
  }

  # total sales for users with email as traffic source
  measure: total_sales_email_users {
    type: sum
    filters: [users.traffic_source: "Email"]
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  # perc of sales for users with email as traffic source
  measure: perc_sales_email_users {
    type: number
    sql: ${total_sales_email_users}/NULLIF(${sum_price}, 0);;
    value_format_name: percent_1
  }

  # perc sales
  measure: perc_sales_value {
    label: "Percentage of sales values"
    type: percent_of_total
    sql: ${sale_price} ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      inventory_items.product_name,
      inventory_items.id,
      users.last_name,
      users.first_name,
      users.id
    ]
  }
  # avg spend per user

  measure: avg_spend_per_user {
    type: number
    sql: ${sum_price}/${count} ;;
    value_format_name: usd
  }
}
