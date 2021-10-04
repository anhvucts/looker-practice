view: inventory_facts {
  derived_table: {
    sql:
          SELECT
            product_sku,
            SUM(cost) AS total_inventory_cost,
            SUM(CASE WHEN sold_at IS NULL THEN 0 ELSE cost END) AS total_sold_good_cost
          FROM inventory_items
          GROUP BY product_sku
          ORDER BY total_sold_good_cost
        ;;
    datagroup_trigger: ecommerce_etl
  }

  dimension: product_sku {
    primary_key: yes
    type: string
    sql: ${TABLE}."PRODUCT_SKU";;
  }

  dimension: total_inventory_cost {
    type: number
  }

  dimension: total_sold_good_cost {
    type: number
  }

  measure: perc_inventory_sold {
    type: number
    sql: ${total_sold_good_cost}/NULLIF(${total_inventory_cost}, 0);;
    value_format: "0.0%"
  }
}
