view: order_frequency {
  derived_table: {
    sql: WITH S AS (SELECT
        user_id,
        id,
        created_at,
        ROW_NUMBER () OVER (PARTITION BY user_id ORDER BY created_at) AS order_rank,
        LAG(created_at) OVER (PARTITION BY user_id ORDER BY created_at) AS previous_order_date,
        LEAD(created_at) OVER (PARTITION BY user_id ORDER BY created_at) AS next_order_date
      FROM order_items)

      SELECT
        user_id,
        id,
        created_at,
        order_rank,
        DATEDIFF(day, previous_order_date, created_at) AS days_from_prev_order,
        CASE WHEN next_order_date IS NOT NULL THEN 1 ELSE 0 END AS is_subsequent_customer
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

  dimension: is_subsequent_customer {
    type: string
    sql: ${TABLE}."IS_SUBSEQUENT_CUSTOMER";;
  }

  # add new dimension: is_repeating_customer

  dimension: is_repeating_purchase {
    type: yesno
    sql: ${order_rank} > 1 ;;
  }

  # to count distinct users, a non-primary key
  measure: user_count {
    type: number
    sql: COUNT(DISTINCT(${user_id}));;
  }

  measure: perc_users {
    type: percent_of_total
    sql: ${user_count} ;;
  }

  set: detail {
    fields: [user_id, id, created_at_time, order_rank, days_from_prev_order]
  }
}
