view: inventory_items {
  sql_table_name: inventory_items;;
  drill_fields: [id]


  parameter: item_to_add_up {
    type: unquoted
    allowed_value: {
      label: "Total Sale Price"
      value: "product_retail_price"
    }
    allowed_value: {
      label: "Total Cost"
      value: "cost"
    }
  }

  filter: multi_select_item_ids {
    type: number
  }

  dimension: selected_items {
    type: string
    sql:
    CASE
      WHEN {% condition multi_select_item_ids %} ${id} {% endcondition %} THEN ${id}
    ELSE NULL END;;
  }

  measure: dynamic_sum {
    type: sum
    sql: ${TABLE}.{% parameter item_to_add_up %} ;;
    value_format_name: usd
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
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
    sql: ${TABLE}.created_at ;;
  }



  dimension: product_category {
    type: string
    sql: ${TABLE}.product_category ;;
  }

  dimension: product_department {
    type: string
    sql: ${TABLE}.PRODUCT_DEPARTMENT;;
  }

  dimension: product_distribution_center_id {
    type: number
    sql: ${TABLE}.PRODUCT_DISTRIBUTION_CENTER_ID;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.PRODUCT_ID;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.PRODUCT_NAME;;
  }

  dimension: product_retail_price {
    type: number
    sql: ${TABLE}.PRODUCT_RETAIL_PRICE;;
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}.PRODUCT_SKU;;
  }

  dimension_group: sold {
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
    sql: ${TABLE}.SOLD_AT;;
  }


  measure: count {
    type: count
    drill_fields: [id, product_name, products.id, products.name, order_items.count]
  }

# Total Cost
  measure: total_cost {
    label: "Total Cost"
    type: sum
    sql: ${cost};;
    value_format_name: usd
  }



# Average cost
  measure: avg_cost {
    label: "Average Cost"
    type: average
    sql: ${cost};;
    value_format_name: usd
  }

}
