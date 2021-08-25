# If necessary, uncomment the line below to include explore_source.
# include: "av-practice-looker-project.model.lkml"
view: user_facts {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: user_id {}
      column: sum {}
      column: created_time {}
      derived_column: order_sequence_number {
        sql: rank() over (partition by user_id order by created_time) ;;
      }
      derived_column: order_rank_sales_price {
        sql: rank() over (partition by user_id order by sum) ;;
      }
    }
  }
  dimension: order_id {
    type: number
  }
  dimension: user_id {
    type: number
  }
  dimension: sum {
    label: "Order Items Total sale price"
    value_format: "$#,##0.00"
    type: number
  }
  dimension: created_time {
    type: date_time
  }

  # dont forget to reference the new derived columns!
  dimension: order_sequence_number {
    type: number
  }

  dimension: order_rank_sales_price {
    type: number
  }

  measure: count_users {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: avg_order_price {
    type: average
    sql: ${sum}/NULLIF(${count_users},0) ;;
    value_format_name: usd
  }

}
