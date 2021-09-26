view: order_items {
  sql_table_name: "PUBLIC"."ORDER_ITEMS"
    ;;
  drill_fields: [id]

  dimension: id {
    #primary_key: yes
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


# try formatting
  dimension: created_html {
    type: date
    sql: ${created_date} ;;
    html: {{rendered_value | date: "%B %e, %Y"}} ;;
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
    primary_key: yes
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

  # Days between signup and all purchases

  dimension_group: bought_after_signup {
    type: duration
    sql_start: ${users.created_date} ;;
    sql_end: ${created_date} ;;
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

  measure: median_sale_price {
    type: median
    sql: ${sale_price};;
  }

  measure: percentile_25 {
    type: percentile
    percentile: 25
    sql: ${sale_price};;
  }


# Total Sale Price Items Sold
  measure: sum_price {
    label: "Total Sale Price"
    # filters: [order_items.status: "Complete"]
    type: sum
    sql: round(${sale_price});;
    value_format_name: usd
}

# Average Sale Price
  measure: avg_sale_price {
    label: "Average Sale Price Items Sold"
    # filters: [order_items.status: "Complete"] #
    type: average
    sql: ${sale_price};;
    value_format_name: usd
  }

  measure: cumulative_total_sales {
    label: "Cumulative Total Sales"
    type:  running_total
    sql: ${sum_price} ;;
    value_format_name:  usd
    #direction: "column"
  }

# Total Gross Revenue

  measure: total_gross_revenue {
    label: "Total Gross Revenue"
    type: sum
    filters: [order_items.status: "-Cancelled, -Returned"]
    sql: ${sale_price};;
    value_format_name: usd
  }

# Total orders
  measure: count_orders {
    label: "Total orders"
    type:  count_distinct
    sql: ${order_id} ;;
  }

  measure: order_count {
    type: count
  }

# Total Gross Margin Amount
  measure: total_gross_margin {
    label: "Total Gross Margin Amount"
    type: number
    sql: ${total_gross_revenue} - ${inventory_items.total_cost};;
    value_format_name: usd
  }

# Total unique inventory items
  measure: count_inventory_items {
    type: count_distinct
    sql: ${inventory_item_id} ;;
  }

# Average Gross Margin -- double check this

  measure: avg_gross_margin {
    label: "Average Gross Margin"
    type: number
    sql: ${total_gross_margin}/NULLIF(${count_inventory_items}, 0);;
    value_format_name: usd
  }

# Gross Margin

  measure: gross_margin_perc {
    label: "Gross Margin Percentage"
    type: number
    sql: ${total_gross_margin}/NULLIF(${total_gross_revenue},0);;
    value_format: "0%"
    drill_fields: [products.category, products.id]
  }

# Number of items returned

  measure: total_items_returned {
    label: "Number of Items Returned"
    type: count_distinct
    filters: [status: "Returned"]
    sql: ${inventory_item_id};;
  }

# Item Return Rate

  measure: item_return_rate {
    type: number
    sql: ${total_items_returned}/count(${inventory_item_id});;
    value_format: "0%"
  }
# Number of customers who return items

  measure: total_users_return_item {
    type: count_distinct
    filters: [status: "Returned"]
    sql: ${user_id} ;;
  }

# % users with returns
  measure: perc_users_return {
    label: "% users with returns"
    type: number
    sql: ${total_users_return_item}/count(distinct(${user_id}));;
    value_format: "0%"
  }

# Avg spend per customer
  measure: avg_spend_per_customer {
    label: "Average Spend Per Customer"
    type: number
    sql: ${sum_price}/NULLIF(COUNT(DISTINCT(${user_id})), 0);;
    value_format_name: usd
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
    sql: ${sum_price} ;;
  }

  # total profit measure
  measure: total_profit_example {
    type:  number
    sql: ${total_gross_revenue} - SUM(${inventory_items.cost}) ;;
    value_format_name: usd
    html: <font color="green">{{rendered_value}}</font> ;;
  }

  # total revenue measure html formatting

  measure: total_revenue_html {
    type: sum
    sql: ${sale_price} ;;
    html: {{rendered_value | replace: ',', '.'}} ;;
  }

  # measure count html
  measure: count_html {
    type: count
    drill_fields: [products.category, total_gross_revenue]
    html: <a href="{{ link }}&f[total_gross_revenue]=>=50000">{{
rendered_value }}</a> ;;
  }
  # measure count link
  measure: count_link {
    type: count
    drill_fields: [products.category, total_gross_revenue]
    link: {
      label: "Revenue breakdown < 50000"
      url: "{{link}}&f[total_gross_revenue]=>=50000"
    }
  }

  # measure count link value
  measure: count_example {
    type: count
    drill_fields:
    [orders.id,orders.created_date,orders.created_quarter,orders.status,orders.user_id,order_items.total_profit]
    html: <p style="font-size: 15px"><a href="{{link}}"> {{rendered_value}}
</a></p> ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_user_id {
    type: number
    sql: COUNT(DISTINCT(${user_id}));;
  }
  # SAME AS
  measure: count_distinct_users {
    type: count_distinct
    sql: ${user_id};;
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

}
