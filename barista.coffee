class Dashing.Barista extends Dashing.Widget

  # Make the tile when the page loads
  ready: ->
    super
    bar = $(@node).find(".bar")
    @make_tile(bar.attr('series'))



  # Make the tile when new data is received
  onData: (data) ->
    super
    @make_tile(data.series)



  # Draws graphs for each series provided. Data with a single series, 2 values, and a hide percentages option would look like this in ruby:
  # [
  #   { 
  #     values: [ 
  #       { 
  #         label: 'Value1', 
  #         value: 1
  #       },
  #       { 
  #         label: 'Value2', 
  #         value: 2
  #       }
  #     ], 
  #     hide_percentages: true
  #   }
  # ]
  make_tile: (data) ->
    if(!data)
      data = @get("series")
    if(!data)
      return
  
    data = JSON.parse(data);
    
    # remove old graphs
    $(@node).children("g").remove();
    
    background_color = $(@node).css('background-color')
    colors = [shadeRGBColor(background_color, -0.30), shadeRGBColor(background_color, -0.15), shadeRGBColor(background_color, -0.45), shadeRGBColor(background_color, -0.60)]
  

    # Make charts for each series
    for series, i in data  
      classes = ""
      if i == 0
        classes += " first"
      if i == data.length - 1
        classes += " last"
      @draw_series(series, colors, classes)
      



  draw_total: (variables) ->      
    # Make the total label!
    total_label_container = variables.node
      .append("svg")
      .attr("class", "total multiple_value")
      .attr("height", variables.label_height * 1.5)
      .attr("width", variables.label_width)
      
    total_label = total_label_container.selectAll("text")
      .data([variables.total])
      .enter()
      .append("text")
      .attr("y", variables.label_height)
      .attr("x", variables.label_width / 2)
      .attr("text-anchor", "middle")
      .text((d) -> d)


  
  # Has these options:
    # hide_key: hides the colored squares 
    # use_value: replaces the series values with the value supplied
  draw_legend: (variables, options = {}) ->
    legend_container = variables.node
      .append("svg")
      .attr("class", "legend")
      .attr("height", variables.label_height * variables.values.length)
      .attr("width", variables.label_width)
      
    
    legend = legend_container.selectAll("text")
      .data(variables.values)
      .enter()
      .append("g")
      .each((value, index) ->
        g = d3.select(this)
        
        if options.hide_key != true
          # Draw the key
          g.append("rect")
            .attr("x", 0)
            .attr("y", variables.label_height * index + 2)
            .attr("width", variables.square_size)
            .attr("height", variables.square_size)
            .attr("fill", variables.colors[index])
        
        # Draw the label
        g.append("text")
          .attr("x", variables.square_size + variables.square_padding)
          .attr("y", variables.font_size  + variables.label_height * index)
          .attr("class", "label")
          .attr("text-anchor", "start")
          .text(value.label)
        
        # Draw the value
        g.append("text")
          .attr("x", variables.label_width)
          .attr("y", variables.font_size  + variables.label_height * index)
          .attr("class", "value")
          .attr("text-anchor", "end")
          .text(if options.use_value then options.use_value else value.value)
          
        return g
      )



  # Has these options:
    # show_percent: draw the series' percent inside its bar
    # custom_fill: overrides the default css for the percent text's color. You must supply a valid color
  draw_bars: (variables, options = {}) ->
    chart = variables.node.append("svg:svg")
      .attr("width", variables.bar_width)
      .attr("height", variables.bar_height)
      .attr("class", "chart")
      
    total_percent = 0
    
    chart.selectAll("g")
      .data(variables.values)
      .enter()
      .append("g")
      .each((value, index) ->
        percent = parseFloat(value.value) / variables.total
        g = d3.select(this)
        # Draw the bars as a percentage of the total
        g.append("rect")
          .attr("x", total_percent * variables.bar_width)
          .attr("y", 0)
          .attr("width", percent * variables.bar_width)
          .attr("height", variables.bar_height)
          .attr("fill", variables.colors[index])
        if value.label != "max_value" && options.show_percent && percent >= variables.minimum_percentage
          # Put percentage labels over the bars
          g.append("text")
            .attr("y", variables.font_size + 5 / (40 / 22 * variables.font_size) * variables.bar_height)
            .attr("x", percent * variables.bar_width / 2 + total_percent * variables.bar_width)
            .attr("class", "percent")
            .attr("text-anchor", "middle")
            .text(Math.round(percent * 100) + "%")
            .attr("fill", if options.custom_fill then options.custom_fill else $(@this).css('font-color'))
          
        total_percent += percent
        return g
      )
  
  
  
  
  # Treats series with only one value very differently from series with multiple values.
  # Multiple value series: Receives the class "multiple_value". The total used to determine the length of bars in the graph is the sum of all given values. The maximum number values per series is 4 (by default). The sum of all values is displayed above the graph, and a key is displayed below the graph. Each bar is based off the tile's background color.
  # Single value series: Receives the class "single_value". The total used to determine the length of the bars in the graph must be supplied in the series with the key "max_value". Only 1 value is supported per series. The name of the value is displayed above the graph along with the supplied total. The first bar is always white, and the second is based off the tile's background color.
  # Has these options (should be stored as keys in series_data):
    # hide_percentages : Hides percentages being drawn inside the bars. Boolean
    # hide_total : For multiple value series, hides the total above the graph. Boolean
    # max_value : Must be supplied if using single value series. Must be larger than the value's value. Should be an integer (can have units though)
  draw_series: (series_data, colors, classes) ->  
      
    font_size = parseInt($(@node).css('font-size'))
    bar_width = $(@node).width()
      
    variables =
      font_size: font_size
      bar_width: bar_width
      label_width: bar_width
      bar_height: 40 / 22 * font_size
      label_height: 36 / 22 * font_size
      square_size: font_size
      square_padding: 5
      # This variable determines the minimum percentage of the total a given component must have in order to have a label over its bar.
      # This is done to stop labels from overlapping each other when there are lots of small values.
      minimum_percentage: 0.2
      colors: colors
      values: series_data.values
      total: 0
      node: d3.select(@node).append("g")
    
      
    if variables.values.length > 1
      
      variables.node.attr("class", classes + " multiple_value")
    
      for value_item in variables.values
        variables.total += parseFloat(value_item.value)
    
      if typeof(series_data.hide_total) == 'undefined'
        @draw_total(variables)
        
      options = 
        show_percent: typeof(series_data.hide_percentages) == 'undefined'
        
      @draw_bars(variables, options)
      @draw_legend(variables)
        
        
    else
      
      
      variables.node.attr("class", classes + " single_value")
      variables.bar_height = 40 / 22 * variables.font_size
      variables.total = parseFloat(series_data.max_value)
      variables.square_padding = 0
      variables.square_size = 0
      
      options = 
        hide_key: true
        use_value: series_data.max_value
      
      @draw_legend(variables, options)
      
      variables.values[1] = { label: "max_value", value: variables.total - parseFloat(variables.values[0].value) }
      variables.colors = ["#FFFFFF", colors[0]]
      
      options = 
        custom_fill: colors[1]
        show_percent: typeof(series_data.hide_percentages) == 'undefined'
      
      @draw_bars(variables, options)

      
      
      
      
# This fantastic function was made by this person http://stackoverflow.com/users/693927/pimp-trizkit
`function shadeRGBColor(color, percent) {
    var f=color.split(","),t=percent<0?0:255,p=percent<0?percent*-1:percent,R=parseInt(f[0].slice(4)),G=parseInt(f[1]),B=parseInt(f[2]);
    return "rgb("+(Math.round((t-R)*p)+R)+","+(Math.round((t-G)*p)+G)+","+(Math.round((t-B)*p)+B)+")";
}`
