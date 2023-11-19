# Bar Plots ====
data(msleep)
d <- ggplot(msleep,
            aes(vore, 
                sleep_total))

# Wrong way
d +
  stat_summary(fun.y = mean,
               geom= "bar",
               fill = "grey50")+
  stat_summary(fun.data = mean_sdl,
               fun.args = list(mult =1),
               geom = "errorbar",
               width = 0.2)

# Individual data points
# position
posn_j <- position_jitter(width = 0.2)

d + 
  geom_point(alpha = 0.6,
             position = posn_j)

d + 
  geom_point()+
  stat_summary(fun.y = mean,
               geom= "point",
               fill = "red")+
  stat_summary(fun.data = mean_sdl,
               fun.args = list(mult =1),
               geom = "errorbar",
               width = 0.2,
               color = "red")


d + 
  geom_point()+
  stat_summary(fun.data = mean_sdl,
               mult = 1,
               width = 0.2,
               color = "red")
