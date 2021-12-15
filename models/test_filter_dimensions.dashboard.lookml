- dashboard: users_total_sale_dashboard
  title: Users total sale dashboard
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  elements:
  - title: Total users by channel
    name: Total users by channel
    model: av-practice-looker-project
    explore: users
    type: looker_column
    fields: [users.traffic_source, users.count]
    sorts: [users.count desc]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    listen:
      State: users.state
      Gender: users.gender
      Past 30 days: users.created_date
      Num Generator: users.num_generator
    row: 0
    col: 0
    width: 16
    height: 7
  - title: New Tile
    name: New Tile
    model: av-practice-looker-project
    explore: order_items
    type: looker_column
    fields: [order_items.brand, order_items.count]
    sorts: [order_items.count desc]
    limit: 10
    query_timezone: Europe/Amsterdam
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    listen:
      Past 30 days: users.created_date
      Num Generator: users.num_generator
    row: 7
    col: 0
    width: 8
    height: 6
  filters:
  - name: Traffic Source
    title: Traffic Source
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
      options: []
    model: av-practice-looker-project
    explore: users
    listens_to_filters: []
    field: users.traffic_source
  - name: State
    title: State
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: av-practice-looker-project
    explore: users
    listens_to_filters: []
    field: users.state
  - name: Gender
    title: Gender
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
      options: []
    model: av-practice-looker-project
    explore: users
    listens_to_filters: []
    field: users.gender
  - name: Past 30 days
    title: Past 30 days
    type: field_filter
    default_value: 2021/11/15 to 2021/12/15
    allow_multiple_values: true
    required: false
    ui_config:
      type: day_range_picker
      display: inline
      options: []
    model: av-practice-looker-project
    explore: users
    listens_to_filters: []
    field: users.created_date
  - name: Num Generator
    title: Num Generator
    type: field_filter
    default_value: "[0,100]"
    allow_multiple_values: true
    required: false
    ui_config:
      type: range_slider
      display: inline
      options:
      - min: 0
      - max: 100
    model: av-practice-looker-project
    explore: users
    listens_to_filters: [Num Generator]
    field: users.num_generator
