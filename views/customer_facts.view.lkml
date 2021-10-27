view: customer_facts {
  derived_table: {
    sql:
    SELECT
      user_id,
      MAX(created_at) AS most_recent_order
    FROM order_items
    WHERE {% condition order_status_filter %} order_items.status {% endcondition %}
    GROUP BY user_id ;;
  }

  filter: order_status_filter {
    type: string
  }

  dimension: user_id {
    type: number
  }

  dimension: most_recent_order {
    type: date
  }

}
