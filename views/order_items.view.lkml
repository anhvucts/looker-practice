view: order_items {
  sql_table_name: "PUBLIC"."ORDER_ITEMS";;
  drill_fields: [id]

## --- PARAMETERS --- ##

parameter: metric_selector {
  type: string
  allowed_value: {
    label: "Total profit"
    value: "total_profit_html"
  }

  allowed_value: {
    label: "Gross Margin Percentage"
    value: "gross_margin_perc"
  }

  allowed_value: {
    label: "Average Spend per Customer"
    value: "avg_spend_per_customer"
  }
}

measure: metric {
  label_from_parameter: metric_selector
  type: number
  sql:
    CASE
      WHEN {% parameter metric_selector %} = 'total_profit_html' THEN ${total_profit_html}
      WHEN {% parameter metric_selector %} = 'gross_margin_perc' THEN ${gross_margin_perc}
      WHEN {% parameter metric_selector %} = 'avg_spend_per_customer' THEN ${avg_spend_per_customer}
      ELSE NULL
    END
  ;;
}

# create comparison time templated filters

filter: timeframe_1 {
  type: date_time
}

filter: timeframe_2 {
  type: date_time
}

dimension: timeframe_1_only {
  type: yesno
  sql: {% condition timeframe_1 %} ${created_raw} {% endcondition %} ;;
}

dimension: timeframe_2_only {
  type: yesno
  sql: {% condition timeframe_2 %} ${created_raw} {% endcondition %} ;;
}

dimension: timeframe_1_or_2 {
  type: string
  sql: CASE WHEN ${timeframe_1_only} THEN 'First Period' ELSE 'Second Period' END
  ;;
}

# Cohort picker

parameter: cohort_picker {
  label: "Choose your cohort"
  allowed_value: {
    label: "Age groups"
    value: "age_bucket"
  }
  allowed_value: {
    label: "Country"
    value: "country"
  }
  allowed_value: {
    label: "City"
    value: "city"
  }
}

  dimension: cohort {
    description: "Use in conjuction with the Cohort Picker"
    type: string
    sql: ${TABLE}.cohort;;
    label_from_parameter: cohort_picker
  }

  measure: metrics_for_cohorts {
    type: number
    sql:
    CASE
      WHEN {% parameter metric_selector %} = 'Total profit' THEN ${total_profit_html}
      WHEN {% parameter metric_selector %} = 'Gross Margin Percentage' THEN ${gross_margin_perc}
      WHEN {% parameter metric_selector %} = 'Average Spend per Customer' THEN ${avg_spend_per_customer}
    ELSE NULL
    END
    ;;
    label_from_parameter: metric_selector
  }

## -- DIMENSIONS AND MEASURES --- ##
  dimension: id { # this is an orderline ID
    primary_key: yes
    alias: [orderline_id]
    type: number
    sql: ${TABLE}."ID" ;;
    group_label: "Identifiers"
  }

  measure: count_distinct_users {
    type: count_distinct
    sql: ${user_id} ;;
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
    group_label: "Orders"
  }

  # dimension_group: order_created {
  #   type: time
  #   timeframes: [raw, date, month, year, month_name, day_of_week]
  #   sql: ${TABLE}."CREATED_AT";;
  # }

  # dimension_group: days_from_signup {
  #   type: duration
  #   intervals: [day, hour, week, month]
  #   sql_start: ${users.created_date};;
  #   sql_end: CURRENT_DATE();;
  # }

  dimension: created_yr {
    hidden: yes
    type: date_year
    sql: ${created_raw} ;;
    link: {
      label: "Monthly performance"
      url: "/looks/21?&f[created_year]={{ _filters['order_items.created_year'] | url_encode }}"
      }
  }

# try formatting
  dimension: created_html {
    type: date
    sql: ${created_date} ;;
    html: {{rendered_value | date: "%B %e, %Y"}} ;;
    hidden: yes
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
    group_label: "Delivery"
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
    group_label: "Identifiers"
  }

  dimension: order_id { # this can be considered a transaction ID
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
    group_label: "Identifiers"
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
    group_label: "Delivery"
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
    group_label: "Orders"
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
    group_label: "Delivery"
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
    group_label: "Orders"
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."USER_ID" ;;
    group_label: "Identifiers"
  }

  dimension: shipping_days {
    type: duration_day
    sql_start: ${shipped_date} ;;
    sql_end: ${delivered_date} ;;
  }

  # Days between signup and all purchases
  dimension_group: bought_after_signup {
    type: duration
    intervals: [day, month, year, hour]
    sql_start: ${users.created_raw} ;;
    sql_end: ${created_raw} ;;
  }

  # test dynamic count measure
  filter: category_count_picker {
    type: string
    suggest_explore: products
    suggest_dimension: products.category
  }

  measure: category_count {
    type: sum
    sql:
      CASE
        WHEN {% condition category_count_picker %} ${products.category} {% endcondition %} THEN 1
        ELSE 0
      END
    ;;
  }

  # multiple condition filter
  # measure: status_cancelled_ocean_avenue {
  #   type: count
  #   filters: [status: "-Cancelled"]
  # }

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

## -- Key use case 0 metrics --

# Total Sale Price Items Sold
  measure: sum_price {
    label: "Total Sale Price"
    # filters: [order_items.status: "Complete"]
    type: sum
    sql: round(${sale_price}, 1);;
    value_format_name: usd
}

# Average Sale Price
  measure: avg_sale_price {
    label: "Average Sale Price"
    type: average
    sql: ${sale_price};;
    value_format_name: usd
  }
# Cumulative Total Sales
  measure: cumulative_total_sales {
    label: "Cumulative Total Sales"
    type: running_total
    sql: ${sum_price};;
    value_format_name: usd
  }

# Total Gross Revenue

  measure: total_gross_revenue {
    label: "Total Gross Revenue"
    description: "Gross revenue excluding cancelled and returned orders"
    type: sum
    sql: ${sale_price};;
    filters: [status: "-Cancelled, -Returned"]
    value_format_name: usd
  }

# Total Cost

  measure: total_cost {
    label: "Total Cost"
    type: sum
    sql: ${inventory_items.cost};;
    value_format_name: usd
  }

# Avg cost of items sold in inventory

  measure: avg_cost {
    label: "Average Cost of Items Sold"
    type: average
    sql: round(${inventory_items.cost}, 1);;
    value_format_name: usd
  }

# Total Gross Margin Amount
  measure: total_gross_margin {
    label: "Total Gross Margin Amount"
    type: number
    sql: ${total_gross_revenue} - ${total_cost};;
    value_format_name: usd
  }

# Average Gross Margin

  measure: avg_gross_margin {
    label: "Average Gross Margin"
    type: number
    sql: (${total_gross_revenue} - ${total_cost})/NULLIF(${count}, 0);;
    value_format_name: usd
  }

# Gross Margin %

  measure: gross_margin_perc {
    label: "Gross Margin Percentage"
    type: number
    sql: ${total_gross_margin}/${total_gross_revenue};;
    value_format_name: percent_1
  }

# Number of items returned

  measure: num_returned_items {
    label: "Number of Items Returned"
    type: count_distinct
    sql: ${id};;
    filters: [status: "Returned"]
  }

# Item Return Rate

  measure: item_return_rate {
    label: "Item Return Rate"
    type: number
    sql: ${num_returned_items}/NULLIF(${count}, 0);;
    value_format_name: percent_2
  }

# Number of customers who return items

  measure: num_customers_return {
    label: "Number of Customers Returning Items"
    type: count_distinct
    sql: ${user_id} ;;
    filters: [status: "Returned"]
  }


# % users with returns
  measure: perc_customers_return {
    label: "Percentage of users with returning items"
    type: number
    sql: ${num_customers_return}/COUNT(DISTINCT(${user_id}));;
    value_format_name: percent_2
  }

# Avg spend per customer
  measure: avg_spend_per_customer {
    label: "Average Spend per Customer"
    type: number
    sql: ${sum_price}/NULLIF(COUNT(DISTINCT(${user_id})), 0);;
    value_format_name: usd
  }

## -- end of key use case 0 metrics --


## -- key use case 2 --

dimension: days_since_signup {
  type: duration_day
  label: "Days Since Signup"
  sql_start: ${users.created_date} ;;
  sql_end: ${created_date} ;;
}

dimension: months_since_signup {
  type: duration_month
  label: "Months Since Signup"
  sql_start: ${users.created_date} ;;
  sql_end: ${created_date} ;;
}

measure: avg_days_since_signup {
  type: average
  label: "Average Days Since Signup"
  sql: ${days_since_signup} ;;
}

measure: avg_months_since_signup {
  type: average
  label: "Average Months Since Signup"
  sql: ${months_since_signup} ;;
}

# cohort 7, 14, 28, 90 and 180

dimension: customer_cohort {
  type: tier
  tiers: [7, 14, 28, 90, 180, 360]
  sql: ${days_since_signup} ;;
  style: integer
}


# % unique orders
  measure: perc_orders {
    label: "Percentage orders"
    type: percent_of_total
    sql: COUNT(DISTINCT(${order_id})) ;;
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

# Total orders
  # measure: count_orders {
  #   label: "Total orders"
  #   type:  count_distinct
  #   sql: ${order_id} ;;
  # }

  measure: count {
    type: count
    drill_fields: [detail*]
  }


  # measure: count_user_id {
  #   type: number
  #   sql: COUNT(DISTINCT(${user_id}));;
  # }
  # # SAME AS
  # measure: count_distinct_users {
  #   type: count_distinct
  #   sql: ${user_id};;
  # }

  # total profit

  measure: total_profit_html {
    hidden: yes
    type: number
    sql: ${total_gross_revenue} - ${total_cost} ;;
    value_format_name: usd
    html: {% if  products.category._in_query and value >= 75000 %}
    <font color = "green" > {{rendered_value}} </font>
    {% elsif  products.category._in_query and value >= 50000 and value < 75000 %}
    <font color = "yellow" > {{rendered_value}} </font>
    {% elsif products.category._in_query %}
    <font color = "red" > {{rendered_value}} </font>
    {%else%}
      {{rendered_value}}
    {%endif%}
    ;;
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
