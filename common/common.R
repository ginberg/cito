library(glue)

# global properties
COLORS <- c("LIGHTBLUE", "LIGHTGRAY")

DECIMALS <- 2

get_percentage <- function(nom, denom) {
    round(100*(nom/denom), DECIMALS)
}

round_val <- function(value) {
    round(value, DECIMALS)
}

get_data_sample <- function(df, size = 200) {
  df[sample(nrow(df), size), ]
}

get_data_file <- function(file, type = "bo") {
  file.path(getwd(), "../data", ifelse(endsWith(file, "rds"), "rds", type),  file)
}

title_font <- list(
  family = "sans serif",
  size = 14,
  color = 'black')

get_source_text <- function(source_text) {
  ifelse(source_text == '', '', glue("Bron: {source_text}"))
}

get_annotations <- function(source_text, y_pos = -0.12) {
  list(x = 1, y = y_pos, text = get_source_text(source_text), showarrow = F, xref='paper', yref='paper',
      xanchor = 'right', yanchor = 'auto', xshift = 10, yshift = 0, font = list(size = 12, color = "black"))
}

get_total_sample_subtitle <- function(subtitle, values, values2 = NULL) {
  if (!is.null(subtitle)) {
    if (subtitle == '') {
      if (is.null(values2)) {
          subtitle <- glue("Gemiddelde: {round_val(mean(values))}, Standard deviatie: {round_val(sd(values))}, Mediaan: {round_val(median(values))}, N: {length(values)}")
        } else {
          subtitle <- glue("Totaal: Gemiddelde: {round_val(mean(values))}, Standard deviatie: {round_val(sd(values))}, Mediaan: {round_val(median(values))}, N: {length(values)}
                            Sample: Gemiddelde: {round_val(mean(values2))}, Standard deviatie: {round_val(sd(values2))}, Mediaan: {round_val(median(values2))}, N: {length(values2)} ")
        }
    }
    subtitle
  }
  subtitle
}

add_plot_config <- function(plot) {
  # http://svgicons.sparkk.fr/
  icon_svg_path = "M15.608,6.262h-2.338v0.935h2.338c0.516,0,0.934,0.418,0.934,0.935v8.879c0,0.517-0.418,0.935-0.934,0.935H4.392c-0.516,0-0.935-0.418-0.935-0.935V8.131c0-0.516,0.419-0.935,0.935-0.935h2.336V6.262H4.392c-1.032,0-1.869,0.837-1.869,1.869v8.879c0,1.031,0.837,1.869,1.869,1.869h11.216c1.031,0,1.869-0.838,1.869-1.869V8.131C17.478,7.099,16.64,6.262,15.608,6.262z M9.513,11.973c0.017,0.082,0.047,0.162,0.109,0.226c0.104,0.106,0.243,0.143,0.378,0.126c0.135,0.017,0.274-0.02,0.377-0.126c0.064-0.065,0.097-0.147,0.115-0.231l1.708-1.751c0.178-0.183,0.178-0.479,0-0.662c-0.178-0.182-0.467-0.182-0.645,0l-1.101,1.129V1.588c0-0.258-0.204-0.467-0.456-0.467c-0.252,0-0.456,0.209-0.456,0.467v9.094L8.443,9.553c-0.178-0.182-0.467-0.182-0.645,0c-0.178,0.184-0.178,0.479,0,0.662L9.513,11.973z"
  dl_button <- list(
      name = "Download data",
      icon = list(
          path = icon_svg_path,
          transform = "scale(0.84) translate(-1, -1)"
          ),
      click = htmlwidgets::JS("
            function(gd) {
              var text = '';
              console.log(gd.data);
              console.log(gd.data[0].x)
              for(var i = 0; i < gd.data.length; i++){
                if (gd.data[i].type == 'histogram') {
                  text += gd.data[i].name + '\\n';
                  for (var j = 0; j < gd.data[i].x.length; j++) {
                    text += gd.data[i].x[j] + '\\n';
                  }
                } else if (gd.data[i].type == 'box') {
                  var names = gd.data[i].name.split(';');
                  text += names[0] + ',' + names[1] + '\\n';
                  for (var j = 0; j < gd.data[i].x.length; j++) {
                    text += gd.data[i].x[j] + ',' + gd.data[i].y[j] + '\\n';
                  }
                } else if (gd.data[i].type == 'bar') {
                  var names = gd.data[i].name.split(';');
                  text += names[0] + ',' + gd.data[i].x + '\\n';
                  if (!names[1]) { names[1] = names[0]; }
                  text += names[1] + ',' + gd.data[i].y + '\\n';
                } else {
                  text += gd.data[i].name + ',' + gd.data[i].x + '\\n';
                  text += gd.data[i].name + ',' + gd.data[i].y + '\\n';
                }
              };
              var blob = new Blob([text], {type: 'text/csv'}); /* text/csv */
              var a = document.createElement('a');
              const object_URL = URL.createObjectURL(blob);
              a.href = object_URL;
              a.type = 'csv';
              a.download = 'data.csv';
              document.body.appendChild(a);
              a.click();
              URL.revokeObjectURL(object_URL);
            }
     ")
  )

  plot %>%
    config(displayModeBar = T, displaylogo = FALSE,
           modeBarButtonsToRemove = c("hoverCompareCartesian", "hoverClosestCartesian", "resetScale2d",
                                      "autoScale2d", "toggleSpikelines", "pan2d", "zoom2d", "select2d", "lasso2d"),
           modeBarButtonsToAdd = list(dl_button))
}

add_plot_properties <- function(plot, title, subtitle = '', xaxis_title = '', yaxis_title = '', width = NULL, height = NULL, source_text = "", source_ypos = -0.1, x_tick_angle = 0) {
  plot %>%
    layout(title = list(text = paste0(title,
                                      '<br>',
                                      '<sup>',
                                      subtitle,
                                      '</sup>'),
                        font = title_font),
           xaxis = list(title = xaxis_title, tickangle = x_tick_angle),
           yaxis = list(title = yaxis_title),
           annotations = get_annotations(source_text, y_pos = source_ypos)) %>%
    add_plot_config()
}

area_chart <- function(values, values2 = NULL, title = '', subtitle = '', xaxis_title = '', source_text = '', colors = COLORS) {
  subtitle <- get_total_sample_subtitle(subtitle, values, values2)
  density  <- density(values)
  fig <- plot_ly(x = ~density$x, y = ~density$y, type = 'scatter', mode = 'none', fill = 'tozeroy', name = "Totaal", fillcolor = colors[1])
  if (!is.null(values2)) {
    density2  <- density(values2)
    fig <- fig %>% add_trace(x = ~density2$x, y = ~density2$y, type = 'scatter', mode = 'none', fill = 'tozeroy', name = "Sample", fillcolor = colors[2])
  }
  fig %>%
    add_plot_properties(title, subtitle, xaxis_title, yaxis_title = 'Density', source_text = source_text)
}

create_histogram <- function(data, var, name = '', title = '', subtitle = '', xaxis_title = '', yaxis_title = '', source_text = '', colors = COLORS,
                             showlegend = TRUE, source_ypos = -0.1, bar_gap = 0.1, nbin = 41) {
  values <- data %>% pull(var)
  subtitle = get_total_sample_subtitle(subtitle, values)
  plot_ly(x = ~values, type = "histogram", nbinsx = nbin, name = name) %>%
    add_plot_properties(title, subtitle, xaxis_title, yaxis_title = yaxis_title, source_text = source_text, source_ypos = source_ypos) %>%
    layout(bargap = bar_gap)
}

create_vertical_bar_chart <- function(data, varx, vary, name = '', colors = COLORS, xaxis_title, yaxis_title, title, subtitle = '', legend_pos = list(x = 100, y = 0.5),
                                      height = NULL, autosize = TRUE, showlegend = TRUE, source_text = '', legend_order = "reversed", source_ypos = -0.12, text = NULL, hovertemplate = NULL) {
  plot_ly(data, x = ~get(varx), y = ~get(vary), type = 'bar', name = name, marker = list(color = colors), height = height, text = text, hovertemplate = hovertemplate) %>%
    layout(title = list(text = paste0(title,
                                    '<br>',
                                    '<sup>',
                                    subtitle,
                                    '</sup>'),
                        font = title_font),
           yaxis   = list(title = yaxis_title, hoverformat = ".2f"),
           xaxis   = list(title = xaxis_title, hoverformat = ".2f"),
           showlegend = showlegend,
           legend  = legend_pos) %>%
    layout(annotations = get_annotations(source_text, source_ypos),
           legend = list(traceorder = legend_order)) %>%
  add_plot_config()
}

create_vertical_stacked_bar_chart <- function(data, varx, vary, colors = COLORS, xaxis_title, yaxis_title, title, subtitle = '', showticklabels = TRUE, showlegend = TRUE,
                                              legend_pos = list(x = 100, y = 0.5), barmode = 'stack', source_text = '', legend_order = "reversed") {
  plot <- plot_ly(data, x = ~get(varx), y = ~get(vary[1]), type = 'bar', name = vary[1], marker = list(color = colors[1]))
    if (length(vary) == 2) {
        plot <- plot %>%
          add_trace(y = ~get(vary[2]), name = vary[2], marker = list(color = colors[2]))
    } else if (length(vary) == 3) {
      plot <- plot %>%
        add_trace(y = ~get(vary[2]), name = vary[2], marker = list(color = colors[2])) %>%
        add_trace(y = ~get(vary[3]), name = vary[3], marker = list(color = colors[3]))
    } else if (length(vary) == 4) {
      plot <- plot %>%
        add_trace(y = ~get(vary[2]), name = vary[2], marker = list(color = colors[2])) %>%
        add_trace(y = ~get(vary[3]), name = vary[3], marker = list(color = colors[3])) %>%
        add_trace(y = ~get(vary[4]), name = vary[4], marker = list(color = colors[4]))
    }
  plot %>%
    layout(title = list(text = paste0(title,
                                  '<br>',
                                  '<sup>',
                                  subtitle,
                                  '</sup>'),
                        font = title_font),
           yaxis   = list(title = yaxis_title, showticklabels = showticklabels, hoverformat = ".2f"),
           xaxis   = list(title = xaxis_title, hoverformat = ".2f"),
           barmode = barmode,
           showlegend = showlegend,
           legend  = legend_pos) %>%
    layout(annotations = get_annotations(source_text),
           legend = list(traceorder = legend_order)) %>%
  add_plot_config()
}

# Horizontal (stacked) bar chart
create_horizontal_bar_chart <- function(data, vary, varx, colors = COLORS, xaxis_title = "Percentage", yaxis_title = "", title = "", subtitle = '', height = NULL,
                                        showticklabels = TRUE, showlegend = TRUE, legend_pos = list(x = 100, y = 0.5), barmode = 'group', source_text = '',
                                        legend_order = "reversed") {
  plot <- plot_ly(data, y = ~get(vary), x = ~get(varx[1]), type = 'bar', name = varx[1], marker = list(color = colors[2]), orientation = 'h', height = height)
  if (length(varx) == 2) {
      plot <- plot %>% add_trace(x = ~get(varx[2]), name = varx[2], marker = list(color = colors[1]))
  } else if (length(varx) == 3) {
      plot <- plot %>% add_trace(x = ~get(varx[2]), name = varx[2], marker = list(color = colors[1])) %>%
                       add_trace(x = ~get(varx[3]), name = varx[3], marker = list(color = colors[3]))
  }
  plot %>%
    layout(title = list(text = paste0(title,
                                    '<br>',
                                    '<sup>',
                                    subtitle,
                                    '</sup>'),
                        font = title_font),
           yaxis   = list(title = yaxis_title, showticklabels = showticklabels, hoverformat = ".2f"),
           xaxis   = list(title = xaxis_title, hoverformat = ".2f"),
           barmode = barmode,
           showlegend = showlegend,
           legend  = legend_pos) %>%
    layout(annotations = get_annotations(source_text),
           legend = list(traceorder = legend_order)) %>%
    add_plot_config()
}

create_pie_plot <- function(data, label_col, value_col, colors = NULL, title = '', subtitle = '',
                            showlegend = TRUE, legend_pos = list(x = 100, y = 0.5), height = NULL, font_size = 20) {
  plot_ly(data, labels = ~get(label_col), values = ~get(value_col), text = ~get(label_col), type = 'pie',
          height = height, marker = list(colors = colors), textfont = list(color = "white", size = font_size)) %>%
    layout(title = list(text = paste0(title,
                                    '<br>',
                                    '<sup>',
                                    subtitle,
                                    '</sup>'),
                        font = title_font),
           showlegend = showlegend,
           legend  = legend_pos) %>%
    add_plot_config()
}

# create map
#' Creates a map displaying schools.
#'
#' @param data a data frame with schools. Shoud have lat/long.
create_map <- function(data, title = '', title_pos = "topright", popup = function(i) {}) {
  msg   <- lapply(seq(nrow(data)), popup)
  icons <- awesomeIcons(icon = "school",
                        library = "ion",
                        markerColor = "blue")

  # custom marker size
  icons <- makeIcon(
    iconUrl = "images/marker-icon.png",
    iconWidth = 15, iconHeight = 25,
    shadowUrl = "images/marker-shadow.png")

  leaflet(data = data) %>% addTiles() %>%
    addMarkers(~long, ~lat, popup = lapply(msg, HTML), label = lapply(msg, HTML), icon = icons) %>%
    addControl(tags$div(HTML(title)), position = title_pos)
}

get_score_map_tooltip <- function(df) {
  lapply(seq(nrow(df)), function(i) {
    if (df[i, "name"] %in% c("IJsselmeer", "Zeeuwse meren"))  {
      df[i, "name"]
    } else {
      paste0(df[i, "name"], ": ", formatC(df[i, "Score"], big.mark = ","), "<br>Aantal: ", df[i, "Count"])
    }
  })
}

map_fix_na_legend <- function(chart) {
  css_fix <- "div.info.legend.leaflet-control br {clear: both;}" # CSS to correct spacing
  html_fix <- htmltools::tags$style(type = "text/css", css_fix)  # Convert CSS to HTML
  chart %>% htmlwidgets::prependContent(html_fix)                   # Insert into leaflet HTML code
}

# create a province map
create_province_map <- function(data, title = '', title_pos = "topright", legend_title = '', legend_pos = "bottomright", source_text = "") {
  # read province map
  #df <- rgdal::readOGR("map/provinces.geojson", verbose = FALSE)
  df <- readRDS("map/provinces.rds")

  data <- data %>%
    select(PROVINCIE, Score) %>%
    filter(!is.na(Score)) %>%
    group_by(PROVINCIE) %>%
    summarise(Score = mean(Score), Count = n(), .groups = 'drop')

  df@data <- df@data %>% left_join(data, by = c("name" = "PROVINCIE"))
  pal     <- colorNumeric(c("white", "lightblue", "blue", "darkblue"), domain = NULL, na.color = "#AAD3DF")
  labs    <- get_score_map_tooltip(df@data)

  leaflet(data = df) %>% addTiles() %>%
    setView(lng = 5.1, lat = 52.3, zoom = 7) %>%
    addPolygons(stroke = FALSE, smoothFactor = 0.3, fillOpacity = 1, fillColor = ~pal(Score), label = lapply(labs, htmltools::HTML)) %>%
    addLegend(position = legend_pos, pal = pal, values = ~Score, opacity = 1.0, title = legend_title) %>%
    addControl(tags$div(HTML(paste(title, "</br><small><b>", get_source_text(source_text), "</small></b>"))), position = title_pos) %>%
    map_fix_na_legend()
}

create_gemeente_map <- function(data, title = '', title_pos = "topright", legend_title = '', legend_pos = "bottomright", source_text = "") {
  df <- rgdal::readOGR("map/townships.geojson", verbose = FALSE)

  data <- data %>%
    select(GEMEENTENAAM, Score) %>%
    filter(!is.na(Score)) %>%
    group_by(GEMEENTENAAM) %>%
    summarise(Score = mean(Score), Count = n(), .groups = 'drop') %>%
    mutate(GEMEENTENAAM = tolower(GEMEENTENAAM))

  df@data <- df@data %>%
    mutate(name = tolower(name)) %>%
    left_join(data, by = c("name" = "GEMEENTENAAM"))
  pal     <- colorNumeric(c("white", "lightblue", "blue", "darkblue"), domain = NULL, na.color = "#AAD3DF")
  labs    <- get_score_map_tooltip(df@data)

  leaflet(data = df) %>% addTiles() %>%
    setView(lng = 5.1, lat = 52.3, zoom = 7) %>%
    addPolygons(stroke = FALSE, smoothFactor = 0.3, fillOpacity = 1, fillColor = ~pal(Score), label = lapply(labs, htmltools::HTML)) %>%
    addLegend(position = legend_pos, pal = pal, values = ~Score, opacity = 1.0, title = legend_title) %>%
    addControl(tags$div(HTML(paste(title, "</br><small><b>", get_source_text(source_text), "</small></b>"))), position = title_pos)
}

create_score_map <- function(data, title = '', title_pos = "topright", legend_title = '', legend_pos = "bottomright", source_text = "", map_level = "GEMEENTE") {
  if (map_level == "GEMEENTE") {
    create_gemeente_map(data, title, title_pos, legend_title, legend_pos, source_text)
  } else {
    create_province_map(data, title, title_pos, legend_title, legend_pos, source_text)
  }
}

# create map
#' Creates a map displaying schools. The Score variable is used to color the markers.
#'
#' @param data a data frame with schools. Shoud have lat/long.
#' @param colors the colors.
#' @param breaks the breaks for the score segments.
create_marker_map <- function(data, colors, breaks, labels, title = '', title_pos = "topright", legend_title = '', legend_pos = "bottomright", popup = function(i) {}, source_text = "") {
  data  <- data %>% mutate(group = cut(Score, breaks = breaks,
                          labels = colors,
                          include.lowest = TRUE))

  msg   <- lapply(seq(nrow(data)), popup)
  icons <- awesomeIcons(icon = "school",
                        library = "ion",
                        markerColor = data$group)

  leaflet(data = data) %>% addTiles() %>%
    addAwesomeMarkers(~long, ~lat, popup = lapply(msg, HTML), label = lapply(msg, HTML), icon = icons) %>%
    addLegend(legend_pos, colors = colors, labels = labels, title = legend_title) %>%
    addControl(tags$div(HTML(paste(title, "</br><small><b>", get_source_text(source_text), "</small></b>"))), position = title_pos)
}

create_violinplot <- function(values, values2 = NULL, title = '', subtitle = '', xaxis_title = '', source_text = '', colors = COLORS) {
  subtitle <- get_total_sample_subtitle(subtitle, values, values2)
  fig <- plot_ly(y = ~values,  type = "violin", box = list(visible = T), meanline = list(visible = T), name = "Totaal", fillcolor = colors[1])

  if (!is.null(values2)) {
    fig <- fig %>% add_trace(y = ~values2, name = "Sample", fillcolor = colors[2])
  }
  fig %>%
    add_plot_properties(title, subtitle, xaxis_title, yaxis_title = 'Score', source_text = source_text)
}

create_boxplot <- function(df, x, y, title = '', subtitle = '', xaxis_title = '', source_text = '', colors = COLORS, source_ypos = -0.12, name = '') {
  plot_ly(df, y = ~get(y), x = ~get(x), type = "box", jitter = 0.3, pointpos = 0, name = name) %>%
    add_plot_properties(title, subtitle, xaxis_title, yaxis_title = 'Score', source_text = source_text, source_ypos = source_ypos, x_tick_angle = 90)
}

### Datatable

create_DT_datatable <- function(df) {
  DT::datatable(df, rownames = FALSE, height = "250px", escape = FALSE, options = list(dom = 't'))
}

create_datatable <- function(df_list) {
  df <- data.frame(Dataset = character(0), Aantal_Rijen = numeric(0), URL = character(0))
  for (category in names(df_list)) {
    items <- unlist(strsplit(df_list[[category]], ";"))
    df[nrow(df) + 1,] <- c(category, items[2], paste0("<a href='", items[1],"'>", items[1], "</a>"))
  }
  df[nrow(df) + 1,] <- c("Sample grootte", 200, "")
  create_DT_datatable(df)
}
