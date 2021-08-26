view: test_dimensionalize_measure {
  derived_table: {
    sql: -- write a subquery for to get the average order volume of all cities
      SELECT
        users.city AS city,
        COUNT(DISTINCT(order_items.order_id)) AS total_orders
      FROM users
      LEFT JOIN order_items ON users.id = order_items.user_id
      GROUP BY users.city
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: avg_order_count {
    type: number
    sql: ${TABLE}."AVG_ORDER_COUNT" ;;
  }

  set: detail {
    fields: [avg_order_count]
  }
}
