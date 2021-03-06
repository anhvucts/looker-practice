view: products {
  sql_table_name: products
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ID;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.BRAND;;
    drill_fields: [category, id]
    link: {
      label: "{{value}} performance breakdown dashboard"
      url: "/dashboards/42?Brand={{ value | url_encode}}"
  }

}



  dimension: br {
    type: string
    sql: ${TABLE}.BRAND;;
    drill_fields: [users.state, users.gender]
    link: {
      label: "{{value}} sales breakdown"
      url: "/dashboards/65?Br={{ _filters['products.br'] | url_encode }}"
    }
  }

  dimension: category {
    type: string
    sql: ${TABLE}.CATEGORY;;
    link: {
      label: "Conditional links to search engines"
      url: "https://www.google.com/search?q={{value}}"
      icon_url: "https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg"
    }
  }



  dimension: cost {
    type: number
    sql: ${TABLE}.COST;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.DEPARTMENT;;
  }

  dimension: distribution_center_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.DISTRIBUTION_CENTER_ID;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.NAME;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.RETAIL_PRICE;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.SKU;;
  }

  measure: count {
    type: count
    drill_fields: [id, order_items.created_date, users.state, name, distribution_centers.name, distribution_centers.id, inventory_items.count]
  }

}
