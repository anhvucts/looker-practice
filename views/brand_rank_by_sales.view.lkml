view: brand_rank_by_sales {
  derived_table: {
    sql:
        SELECT
         products.brand AS brand,
         COALESCE(SUM(order_items.sale_price ), 0) AS total_revenue,
         RANK() OVER (ORDER BY COALESCE(SUM(order_items.sale_price ), 0) DESC) AS RNK
        FROM
         order_items AS order_items
         LEFT JOIN inventory_items AS inventory_items ON order_items.inventory_item_id = inventory_items.id
         LEFT JOIN products AS products ON inventory_items.product_id = products.id
         WHERE
         1=1
         AND {% condition order_items.created_date %} order_items.created_at {% endcondition %}
         GROUP BY 1
         ORDER BY 2 DESC
        ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
    order_by_field: total_revenue
  }

  dimension: total_revenue {
    type: number
    sql: ${TABLE}.total_revenue ;;
  }

  dimension: rnk {
    type: number
    sql: ${TABLE}.rnk ;;
  }

  set: detail {
    fields: [brand, total_revenue, rnk]
  }
}
