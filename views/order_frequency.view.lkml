view: order_frequency {
  derived_table: {
    sql: WITH S AS (SELECT
        user_id,
        id,
        created_at,
        ROW_NUMBER () OVER (PARTITION BY user_id ORDER BY created_at) AS order_rank,
        LAG(created_at) OVER (PARTITION BY user_id ORDER BY created_at) AS previous_order_date
      FROM order_items)

      SELECT
        user_id,
        id,
        created_at,
        order_rank,
        DATEDIFF(day, previous_order_date, created_at) AS days_from_prev_order
      FROM S
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: id {
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension_group: created_at {
    type: time
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension: order_rank {
    type: number
    sql: ${TABLE}."ORDER_RANK" ;;
  }

  dimension: days_from_prev_order {
    type: number
    sql: ${TABLE}."DAYS_FROM_PREV_ORDER" ;;
  }

  # add new dimension: is_repeating_customer

  dimension: is_repeating_purchase {
    type: yesno
    sql: ${order_rank} > 1 ;;
  }

  set: detail {
    fields: [user_id, id, created_at_time, order_rank, days_from_prev_order]
  }
}
