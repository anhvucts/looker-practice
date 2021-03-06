view: revenue_brand_ndt {
  derived_table: {
    explore_source: order_items {
      column: sale_price {}
      column: inventory_item_id {}
    filters: [order_items.created_date: "365 days"]
    }
    datagroup_trigger: ecommerce_etl
  }
  dimension: sale_price {
    type: number
  }
  dimension: inventory_item_id {
    primary_key: yes
    type: string
  }

  measure: total_revenue {
    type: sum
    sql: ${sale_price};;
    value_format_name: usd
  }
}
