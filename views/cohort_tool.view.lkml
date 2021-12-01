include: "*.view"

explore: cohorts {
  view_name: cohort_tool
  label: "Cohort Tool"
  join: users {
    relationship: many_to_one
    sql_on:
      CASE
        WHEN {% parameter cohort_tool.cohort_picker %} = 'Gender' THEN ${users.gender} = ${cohort_tool.cohort}
        WHEN {% parameter cohort_tool.cohort_picker %} = 'Country' THEN ${users.country} = ${cohort_tool.cohort}
        WHEN {% parameter cohort_tool.cohort_picker %} = 'City' THEN ${users.city} = ${cohort_tool.cohort}
      ELSE ${users.created_month} = ${cohort_tool.cohort}
      END
    ;;
  }
  join: order_items {
    relationship: one_to_many
    fields: [-order_items.total_cost, -order_items.category_count,-order_items.avg_cost]
    sql_on: ${users.id} = ${order_items.user_id}  ;;
  }
}

view: cohort_tool {
  derived_table: {
    sql:
    SELECT
      CASE
        WHEN {% parameter cohort_picker %} = 'Gender' THEN users.gender
        WHEN {% parameter cohort_picker %} = 'Country' THEN users.country
        WHEN {% parameter cohort_picker %} = 'City' THEN users.city
      ELSE TO_CHAR(DATE_TRUNC('month', CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', CAST(users.created_at  AS TIMESTAMP_NTZ))), 'YYYY-MM')
      END as cohort,
      COUNT(DISTINCT(users.id)) AS size
    FROM users
    GROUP BY cohort
    ;;
  }

# Cohort picker

parameter: cohort_picker {
  label: "Choose your cohort"
  allowed_value: {
    value: "Gender"
  }
  allowed_value: {
    value: "Country"
  }
  allowed_value: {
    value: "City"
  }
}

parameter: metric_selector {
  allowed_value: {
    value: "Total sale price"
  }
  allowed_value: {
    value: "Average Sale Price"
  }
  allowed_value: {
    value: "Average Spend per Customer"
  }
}

measure: metrics_for_cohorts {
  label: "Metric Selected"
  type: number
  sql:
    CASE
      WHEN {% parameter metric_selector %} = 'Total sale price' THEN ${total_sale_price}
      WHEN {% parameter metric_selector %} = 'Average Sale Price' THEN ${avg_sale_price}
      WHEN {% parameter metric_selector %} = 'Average Spend per Customer' THEN ${avg_spend_per_customer}
    ELSE NULL
    END
    ;;
  label_from_parameter: metric_selector
}


dimension: cohort {
  description: "Use in conjuction with the Cohort Picker"
  primary_key: yes
  type: string
  sql: ${TABLE}.cohort;;
  label_from_parameter: cohort_picker
}

measure: total_sale_price {
  hidden: yes
  type: sum
  sql: ${order_items.sale_price} ;;
}

measure: avg_sale_price {
  hidden: yes
  type: number
  sql: ${total_sale_price}/NULLIF(COUNT(DISTINCT(${order_items.id})), 0) ;;
}

measure: avg_spend_per_customer {
  hidden: yes
  type: number
  sql:  ${total_sale_price}/NULLIF(COUNT(DISTINCT(${order_items.user_id})),0) ;;
}

measure: size {
  type: sum
  sql: ${TABLE}.size ;;
}

}
