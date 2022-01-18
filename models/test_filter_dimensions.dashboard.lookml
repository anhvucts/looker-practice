- dashboard: test_slider
  title: test slider
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  elements:
  - title: New Tile
    name: New Tile
    model: av-practice-looker-project
    explore: users
    type: single_value
    fields: [users.cr_calculated]
    filters: {}
    limit: 500
    query_timezone: Europe/Amsterdam
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    defaults_version: 1
    series_types: {}
    listen:
      Cr Generator: users.cr_generator
    row: 0
    col: 0
    width: 8
    height: 6
  filters:
  - name: Cr Generator
    title: Cr Generator
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: slider
      display: inline
      options: []
    model: av-practice-looker-project
    explore: users
    listens_to_filters: []
    field: users.cr_generator
