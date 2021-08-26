view: test_dimensionalize_measure {
  derived_table: {
    sql: SELECT
        users.city AS city,
        COUNT(DISTINCT(order_items.order_id)) AS total_orders
      FROM users
      LEFT JOIN order_items ON users.id = order_items.user_id
      GROUP BY users.city
 ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: total_orders {
    type: number
    sql: ${TABLE}."TOTAL_ORDERS" ;;
  }

  measure: avg_count {
    type: average
    sql: ${total_orders} ;;
  }


}
