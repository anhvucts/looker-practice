connection: "snowlooker"

# include all the views
include: "/views/**/*.view"

datagroup: ecommerce_etl {
  ### Datagroups Allow you to sync cache and Persisted Derived Tables to events like ETL
  sql_trigger: SELECT max(completed_at) FROM public.etl_jobs ;;
  max_cache_age: "2 hours"
}

persist_with: ecommerce_etl

explore: distribution_centers {}

explore: etl_jobs {}

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

}

explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: users {
# joining a derived table
  join: user_order_facts {
    type: left_outer
    sql_on: ${users.id} = ${user_order_facts.user_id} ;;
    relationship: one_to_one
  }
}
