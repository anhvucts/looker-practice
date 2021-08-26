view: test_union_operator {
  derived_table: {
    sql: (SELECT * FROM order_items)
          UNION
          (SELECT * FROM users);;
  }
}
