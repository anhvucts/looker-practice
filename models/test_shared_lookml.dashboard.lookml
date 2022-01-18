- dashboard: cohort_analysis__key_use_case_2
  title: Cohort analysis - key use case 2
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - title: Revenue proportion by customer cohorts
    name: Revenue proportion by customer cohorts
    model: av-practice-looker-project
    explore: customer_purchase_behavior
    type: looker_pie
    fields: [users.cohort_group, customer_purchase_behavior.clv_revenues]
    fill_fields: [users.cohort_group]
    sorts: [users.cohort_group]
    limit: 500
    column_limit: 50
    value_labels: labels
    label_type: labPer
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
    series_types: {}
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    show_null_points: true
    interpolation: linear
    row: 0
    col: 0
    width: 8
    height: 6
  - title: Avg lifetime revenue after months signup
    name: Avg lifetime revenue after months signup
    model: av-practice-looker-project
    explore: customer_purchase_behavior
    type: looker_line
    fields: [customer_purchase_behavior.avg_lifetime_revenue, users.months_since_signup]
    sorts: [customer_purchase_behavior.avg_lifetime_revenue desc]
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
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    series_types: {}
    row: 0
    col: 8
    width: 8
    height: 6
  - title: Avg lifetime revenue by customer cohorts
    name: Avg lifetime revenue by customer cohorts
    model: av-practice-looker-project
    explore: customer_purchase_behavior
    type: looker_bar
    fields: [customer_purchase_behavior.avg_lifetime_revenue, users.cohort_group]
    fill_fields: [users.cohort_group]
    sorts: [users.cohort_group]
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
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    row: 0
    col: 16
    width: 8
    height: 6
  - title: Email traffic acquisition over time
    name: Email traffic acquisition over time
    model: av-practice-looker-project
    explore: customer_purchase_behavior
    type: looker_line
    fields: [users.count, users.created_month]
    fill_fields: [users.created_month]
    filters:
      users.traffic_source: Email
    sorts: [users.created_month desc]
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
    x_axis_scale: time
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: Acquired users count, orientation: left, series: [{axisId: users.count,
            id: users.count, name: Users}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_label: Month
    series_types: {}
    trend_lines: []
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    row: 6
    col: 0
    width: 8
    height: 6
  - title: Display traffic acquisition
    name: Display traffic acquisition
    model: av-practice-looker-project
    explore: customer_purchase_behavior
    type: looker_line
    fields: [users.count, users.created_month]
    fill_fields: [users.created_month]
    filters:
      users.traffic_source: Display
    sorts: [users.created_month desc]
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
    x_axis_scale: time
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: Acquired users count, orientation: left, series: [{axisId: users.count,
            id: users.count, name: Users}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_label: Month
    series_types: {}
    trend_lines: []
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    row: 12
    col: 0
    width: 8
    height: 6
  - title: Retention rate by cohorts
    name: Retention rate by cohorts
    model: av-practice-looker-project
    explore: order_items
    type: looker_grid
    fields: [users.created_month, order_items.months_bought_after_signup, order_items.count]
    pivots: [order_items.months_bought_after_signup]
    fill_fields: [users.created_month]
    filters:
      users.created_month: 12 months
    sorts: [users.created_month, order_items.months_bought_after_signup]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${order_items.count}/pivot_index(${order_items.count},1)",
        label: Repurchase rate, value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: repurchase_rate, _type_hint: number}]
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_cell_visualizations:
      order_items.count:
        is_active: true
        value_display: true
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: 0
    x_axis_gridlines: false
    y_axis_gridlines: true
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
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    series_types: {}
    hidden_fields: [order_items.count]
    series_column_widths:
      users.created_month: 75
    listen: {}
    row: 18
    col: 0
    width: 24
    height: 8
