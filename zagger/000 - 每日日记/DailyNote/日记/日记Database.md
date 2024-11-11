---
database-plugin: basic
created: 2023-11-06T08:24
updated: 2023-11-06T08:24
---

```yaml:dbfolder
name: new database
description: new description
columns:
  __file__:
    key: __file__
    id: __file__
    input: markdown
    label: File
    accessorKey: __file__
    isMetadata: true
    skipPersist: false
    isDragDisabled: false
    csvCandidate: true
    position: 1
    isHidden: false
    sortIndex: -1
    config:
      enable_media_view: true
      link_alias_enabled: true
      media_width: 100
      media_height: 100
      isInline: true
      task_hide_completed: true
      footer_type: none
      persist_changes: false
  __created__:
    key: __created__
    id: __created__
    input: metadata_time
    label: Created
    accessorKey: __created__
    isMetadata: true
    isDragDisabled: false
    skipPersist: false
    csvCandidate: true
    isHidden: true
    position: 2
    sortIndex: -1
    config:
      enable_media_view: true
      link_alias_enabled: true
      media_width: 100
      media_height: 100
      isInline: false
      task_hide_completed: true
      footer_type: none
      persist_changes: false
  __modified__:
    key: __modified__
    id: __modified__
    input: metadata_time
    label: Modified
    accessorKey: __modified__
    isMetadata: true
    isDragDisabled: false
    skipPersist: false
    csvCandidate: true
    isHidden: true
    position: 3
    sortIndex: -1
    config:
      enable_media_view: true
      link_alias_enabled: true
      media_width: 100
      media_height: 100
      isInline: false
      task_hide_completed: true
      footer_type: none
      persist_changes: false
  __tasks__:
    key: __tasks__
    id: __tasks__
    input: task
    label: Task
    accessorKey: __tasks__
    isMetadata: true
    isDragDisabled: false
    skipPersist: false
    csvCandidate: false
    width: 292
    position: 5
    isHidden: false
    sortIndex: -1
    config:
      enable_media_view: true
      link_alias_enabled: true
      media_width: 100
      media_height: 100
      isInline: false
      task_hide_completed: true
      footer_type: none
      persist_changes: false
  __inlinks__:
    key: __inlinks__
    id: __inlinks__
    input: inlinks
    label: Inlinks
    accessorKey: __inlinks__
    isMetadata: true
    isDragDisabled: false
    skipPersist: false
    csvCandidate: false
    isHidden: true
    position: 6
    sortIndex: -1
    config:
      enable_media_view: true
      link_alias_enabled: true
      media_width: 100
      media_height: 100
      isInline: false
      task_hide_completed: true
      footer_type: none
      persist_changes: false
  __outlinks__:
    key: __outlinks__
    id: __outlinks__
    input: outlinks
    label: Outlinks
    accessorKey: __outlinks__
    isMetadata: true
    isDragDisabled: false
    skipPersist: false
    csvCandidate: false
    isHidden: true
    position: 7
    sortIndex: -1
    config:
      enable_media_view: true
      link_alias_enabled: true
      media_width: 100
      media_height: 100
      isInline: false
      task_hide_completed: true
      footer_type: none
      persist_changes: false
  __tags__:
    key: __tags__
    id: __tags__
    input: metadata_tags
    label: File Tags
    accessorKey: __tags__
    isMetadata: true
    isDragDisabled: false
    skipPersist: false
    csvCandidate: false
    position: 8
    isHidden: false
    sortIndex: -1
    config:
      enable_media_view: true
      link_alias_enabled: true
      media_width: 100
      media_height: 100
      isInline: false
      task_hide_completed: true
      footer_type: none
      persist_changes: false
  要事:
    input: text
    accessorKey: 要事
    key: 要事
    id: 要事
    label: 要事
    position: 9
    skipPersist: false
    isHidden: false
    sortIndex: -1
    config:
      enable_media_view: true
      link_alias_enabled: true
      media_width: 100
      media_height: 100
      isInline: false
      task_hide_completed: true
      footer_type: none
      persist_changes: false
      wrap_content: true
  反思:
    input: text
    accessorKey: 反思
    key: 反思
    id: 反思
    label: 反思
    position: 10
    skipPersist: false
    isHidden: false
    sortIndex: -1
    config:
      enable_media_view: true
      link_alias_enabled: true
      media_width: 100
      media_height: 100
      isInline: false
      task_hide_completed: true
      footer_type: none
      persist_changes: false
      wrap_content: true
  随想:
    input: text
    accessorKey: 随想
    key: 随想
    id: 随想
    label: 随想
    position: 11
    skipPersist: false
    isHidden: false
    sortIndex: -1
    config:
      enable_media_view: true
      link_alias_enabled: true
      media_width: 100
      media_height: 100
      isInline: false
      task_hide_completed: true
      footer_type: none
      persist_changes: false
      wrap_content: true
  标签:
    input: text
    accessorKey: 标签
    key: 标签
    id: 标签
    label: 标签
    position: 12
    skipPersist: false
    isHidden: false
    sortIndex: -1
    config:
      enable_media_view: true
      link_alias_enabled: true
      media_width: 100
      media_height: 100
      isInline: false
      task_hide_completed: true
      footer_type: none
      persist_changes: false
  天气:
    input: text
    accessorKey: 天气
    key: 天气
    id: 天气
    label: 天气
    position: 13
    skipPersist: false
    isHidden: false
    sortIndex: -1
    config:
      enable_media_view: true
      link_alias_enabled: true
      media_width: 100
      media_height: 100
      isInline: false
      task_hide_completed: true
      footer_type: none
      persist_changes: false
      wrap_content: true
  早起:
    input: text
    accessorKey: 早起
    key: 早起
    id: 早起
    label: 早起
    position: 14
    skipPersist: false
    isHidden: false
    sortIndex: -1
    config:
      enable_media_view: true
      link_alias_enabled: true
      media_width: 100
      media_height: 100
      isInline: false
      task_hide_completed: true
      footer_type: none
      persist_changes: false
  心情:
    input: text
    accessorKey: 心情
    key: 心情
    id: 心情
    label: 心情
    position: 15
    skipPersist: false
    isHidden: false
    sortIndex: -1
    config:
      enable_media_view: true
      link_alias_enabled: true
      media_width: 100
      media_height: 100
      isInline: false
      task_hide_completed: true
      footer_type: none
      persist_changes: false
  日期:
    input: calendar
    accessorKey: 日期
    key: 日期
    id: 日期
    label: 日期
    position: 4
    skipPersist: false
    isHidden: false
    sortIndex: -1
    config:
      enable_media_view: true
      link_alias_enabled: true
      media_width: 100
      media_height: 100
      isInline: false
      task_hide_completed: true
      footer_type: none
      persist_changes: false
config:
  remove_field_when_delete_column: false
  cell_size: normal
  sticky_first_column: false
  group_folder_column: 
  remove_empty_folders: false
  automatically_group_files: false
  hoist_files_with_empty_attributes: true
  show_metadata_created: true
  show_metadata_modified: true
  show_metadata_tasks: true
  show_metadata_inlinks: true
  show_metadata_outlinks: true
  show_metadata_tags: true
  source_data: current_folder
  source_form_result: 
  source_destination_path: /
  row_templates_folder: /
  current_row_template: 
  pagination_size: 10
  font_size: 16
  enable_js_formulas: false
  formula_folder_path: /
  inline_default: false
  inline_new_position: last_field
  date_format: yyyy-MM-dd
  datetime_format: "yyyy-MM-dd HH:mm:ss"
  metadata_date_format: "yyyy-MM-dd HH:mm:ss"
  enable_footer: false
  implementation: default
filters:
  enabled: true
  conditions:
      - condition: AND
        disabled: true
        label: "1月"
        color: "hsl(64, 95%, 90%)"
        filters:
        - field: file.name
          operator: CONTAINS
          value: "2023-01"
          type: text
      - condition: AND
        disabled: true
        label: "2月"
        color: "hsl(104, 95%, 90%)"
        filters:
        - field: file.name
          operator: CONTAINS
          value: "2023-02"
          type: text
      - condition: AND
        disabled: true
        label: "3月"
        color: "hsl(115, 95%, 90%)"
        filters:
        - field: file.name
          operator: CONTAINS
          value: "2023-03"
          type: text
      - condition: AND
        disabled: true
        label: "4月"
        color: "hsl(100, 95%, 90%)"
        filters:
        - field: file.name
          operator: CONTAINS
          value: "2023-04"
          type: text
      - condition: AND
        disabled: true
        label: "5月"
        color: "hsl(56, 95%, 90%)"
        filters:
        - field: file.name
          operator: CONTAINS
          value: "2023-05"
          type: text
      - condition: AND
        disabled: true
        label: "6月"
        color: "hsl(153, 95%, 90%)"
        filters:
        - field: file.name
          operator: CONTAINS
          value: "2023-06"
          type: text
      - condition: AND
        disabled: true
        label: "7月"
        color: "hsl(119, 95%, 90%)"
        filters:
        - field: file.name
          operator: CONTAINS
          value: "2023-07"
          type: text
      - condition: AND
        disabled: true
        label: "8月"
        color: "hsl(15, 95%, 90%)"
        filters:
        - field: file.name
          operator: CONTAINS
          value: "2023-08"
          type: text
      - condition: AND
        disabled: true
        label: "9月"
        color: "hsl(95, 95%, 90%)"
        filters:
        - field: file.name
          operator: CONTAINS
          value: "2023-09"
          type: text
      - condition: AND
        disabled: false
        label: "10月"
        color: "hsl(225, 95%, 90%)"
        filters:
        - field: file.name
          operator: CONTAINS
          value: "2023-10"
          type: text
      - condition: AND
        disabled: true
        label: "11月"
        color: "hsl(319, 95%, 90%)"
        filters:
        - field: file.name
          operator: CONTAINS
          value: "2023-11"
          type: text
      - condition: AND
        disabled: true
        label: "12月"
        color: "hsl(159, 95%, 90%)"
        filters:
        - field: file.name
          operator: CONTAINS
          value: "2023-12"
          type: text
```