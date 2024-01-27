# The themes layer
#   All non-data ink
#   Visual elements not part of the data
#     Text, line or rectangle
#     -> element_text(), element_line(), element_rect()


# Text:
#   axis.title.x
#     axis.title.x.top
#     axis.title.x.bottom
#   axis.title.y
#     axis.title.y.left
#     axis.title.y.right

# title:
#     Legend.title
#     plot.title
#     plot.subtitle
#     plot.caption
#     plot.tag

# axis.text
#   axis.text.x
#     axis.text.x.top
#     axis.text.x.bottom
#   axis.text.y
#     .left
#     .right

# Legend text
# stirp.text
#   .x
#   .y

# theme(
#   line,
#     axis.ticks,
#       .x,
#         .top,
#         .bottom,
#       .y,
#         .left,
#         .right,
#     axis.line,
#       axis.line.x
#         .top,  .bottom
#     axis.line.y
#       axis.line.y,
#         .left, .right
#   panel.grid,
#     .major,
#       .x, .y
#     .minor,
#       .x, .y
# )

# Example
ggplot(iris,
       aes(x= Sepal.Length,
           y= Sepal.Width,
           color = Species))+
  geom_jitter(alpha = 0.6)+
  theme(axis.title = element_text(color = "blue"))

