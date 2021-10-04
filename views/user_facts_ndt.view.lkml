view: user_facts_ndt {
  derived_table: {
    explore_source: order_items {
      column: user_id {}
      column: count {}
      column: sum_price {}
    }
  }

  dimension: user_id {
    primary_key: yes
    type: number
  }

  dimension: count {
    type: number
  }

  dimension: sum_price {
    type: number
  }

  measure: avg_lifetime_value {
    type: average
    sql: ${sum_price};;
  }

  measure: avg_lifetime_order_count {
    type:  average
    sql: ${count} ;;
  }
}
