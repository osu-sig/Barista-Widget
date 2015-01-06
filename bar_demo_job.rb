series = [
  {
    values: [
      { label: 'Value 1', value: 1 },
      { label: 'Value 2', value: 2 }
    ]
  }
]

send_event("bar_demo_1", series: series.to_json)




series = [
  { values: [ { label: 'Value 1', value: 1 } ], max_value: "3 M"},
  { values: [ { label: 'Value 2', value: 2 } ], max_value: "3 TB"}
]

send_event("bar_demo_2", series: series.to_json)




series = [
  { values: [ { label: 'Value 1', value: 1 } ], max_value: "3 M"},
  { values: [ { label: 'Value 2', value: 2 } ], max_value: "3 GB"},
  { values: [ { label: 'Value 3', value: 3 } ], max_value: "3 TB"}
]

send_event("bar_demo_3", series: series.to_json)
