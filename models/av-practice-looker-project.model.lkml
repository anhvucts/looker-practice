connection: "snowlooker"
label: "Fashion.ly analytics project"
# include all the views
include: "/views/**/*.view"

datagroup: ecommerce_etl {
  ### Datagroups Allow you to sync cache and Persisted Derived Tables to events like ETL
  sql_trigger: SELECT max(completed_at) FROM public.etl_jobs ;;
  max_cache_age: "24 hours"
}

# access_grant: state {
#   user_attribute: state
#   allowed_values: ["California", "Arizona"]
# }

access_grant: exclude_email_address{
  user_attribute: email # the field email is not accessible to anyone
}

persist_with: ecommerce_etl

explore: distribution_centers {}

explore: etl_jobs {}

explore: user_facts {
  # join: users {
  #   type: left_outer
  #   sql_on: ${user_facts.user_id} = ${users.id} ;;
  #   relationship: one_to_one
  # }
  # sql_always_having: ${avg_order_price} > 2000 ;; # recommended practice
}

explore: events {
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: inventory_items {

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
  #   always_filter: {
  #     filters: [status: "Complete"]
  #   }
  #   #sql_always_having: ${count_inventory_items} > 5;;

  # conditionally_filter: {
  #   filters: [created_year: "2 years"]
  #   unless: [users.id]}

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  join: user_order_facts {
    type: left_outer
    sql_on: ${users.id} = ${user_order_facts.user_id} ;;
    relationship: one_to_one
  }

  join: order_frequency {
    type: left_outer
    sql_on: ${order_items.id} = ${order_frequency.id} ;;
    relationship: one_to_one
  }

}
explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
  sql_always_where: ${products.category} <> 'Jeans';;
}

explore: users {
  # access_filter: {
  #   field: state
  #   user_attribute: state
  # }
# joining a derived table
  # group_label: "Users and their purchasing behaviors"
  join: user_order_facts {
    type: left_outer
    sql_on: ${users.id} = ${user_order_facts.user_id} ;;
    relationship: one_to_one
  }
  join: customer_purchase_behavior{
    type: left_outer
    sql_on: ${users.id} = ${customer_purchase_behavior.user_id} ;;
    relationship: one_to_one
  }

  # access_filter: {
  #   user_attribute: email_yahoo_test
  #   field: users.email
  # }

  # conditionally_filter: {
  #   filters: [users.created_date: "90 days"]
  #   unless: [users.id, users.state]
  # }
}

explore: customer_purchase_behavior{
  description: "Explore customer purchasing behaviors across lifetimes"
  join: users {
    type: left_outer
    sql_on: ${customer_purchase_behavior.user_id} = ${users.id} ;;
    relationship: one_to_one
  }
}

explore: order_frequency {
  join: users {
    type: left_outer
    sql_on: ${order_frequency.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  join: customer_purchase_behavior {
    type: left_outer
    sql_on: ${order_frequency.user_id} = ${customer_purchase_behavior.user_id} ;;
    relationship: many_to_one
  }
}

explore: user_facts_ndt {
  join: users {
    sql_on: ${user_facts_ndt.user_id} = ${users.id} ;;
    relationship: one_to_one
    type: left_outer
  }
}

explore: inventory_facts {
  join: inventory_items {
    sql_on: ${inventory_facts.product_sku} = ${inventory_items.product_sku} ;;
    relationship: one_to_one
    type: left_outer
  }
}

explore: usecase1 {}
explore: revenue_brand_ndt {
  join: inventory_items {
    sql_on: ${revenue_brand_ndt.inventory_item_id} = ${inventory_items.id} ;;
    relationship: one_to_one
    type: left_outer
  }
  #fields: [inventory_items.product_brand, total_revenue, sale_price]
}
