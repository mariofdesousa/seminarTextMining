# GGPLOT2
library(tidyverse)


ggplot2::mpg

# Gráfico simples com 

ggplot(data=mpg) +
  geom_point(mapping=(aes(x=displ,y=hwy)))
 
# Estrutura geral de um grafico com ggplot2
# ggplot(data = <DATA>) +
#   <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

# Exercises
# 1. Run  ggplot(data = mpg) . What do you see?

ggplot(data=mpg) #Nao vemos nada a funcao cria apenas uma estrutura vazis

# 2. How many rows are in  mtcars ? How many columns?
data <- ggplot2::mpg

dim(data)[1] # 234 rowm
dim(data)[2] # 11 columns

# 3. What does the  drv variable describe? Read the help for  ?mpg to
# find out.

?mpg
# It descrebes if the vehicle is f = front-wheel drive, 
#                                  r = rear wheel drive, 4 = 4wd

# 4. Make a scatterplot of  hwy versus  cyl 
ggplot(data=mpg)+
  geom_point(mapping=aes(x=cyl,y=hwy))
# 5. What happens if you make a scatterplot of  class versus  drv ?
ggplot(data=mpg)+
  geom_point(mapping = aes(x=class,y=drv))
# Why is the plot not useful?
 # The last plot is not useful because "class" is a categorical varible.

# Aesthetics(aes) include things like the size, the shape, 
# or the color of your points.

ggplot(data=mpg)+
  geom_point(mapping = aes(x=displ,y=hwy,col=class))#color

ggplot(data=mpg)+
  geom_point(mapping = aes(x=displ,y=hwy,size=class))#size

ggplot(data=mpg)+
  geom_point(mapping = aes(x=displ,y=hwy,alpha=class))#transparency

ggplot(data=mpg)+
  geom_point(mapping = aes(x=displ,y=hwy,shape=class))#shap2

# Exercises

# 1. What’s gone wrong with this code? Why are the points not blue?
ggplot(data = mpg) +
  geom_point(
    mapping = aes(x = displ, y = hwy, color = "blue")
  )
# The points are not blue because color is defined inside "aes". In order to the
# points be blue the code should be like below

ggplot(data = mpg) +
  geom_point(
    mapping = aes(x = displ, y = hwy), color = "blue")
# color defined outside "aes"

# 3. Map a continuous variable to  color ,  size , and  shape . How do
# these aesthetics behave differently for categorical versus contin‐
# uous variables?
ggplot(data=mpg)+
  geom_point(mapping = aes(x=cty,y=hwy,color=class))

ggplot(data=mpg)+
  geom_point(mapping = aes(x=cty,y=hwy,size=class))

ggplot(data=mpg)+
  geom_point(mapping = aes(x=cty,y=hwy,shape=class))

ggplot(data=mpg)+
  geom_point(mapping = aes(x=model,y=hwy,color=class))

ggplot(data=mpg)+
  geom_point(mapping = aes(x=model,y=hwy,size=class))

ggplot(data=mpg)+
  geom_point(mapping = aes(x=model,y=hwy,shape=class))

# Facets (facets_wrap)

ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ,y=hwy))+
  facet_wrap(~ class,nrow=2)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)

## exercises

ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = cyl))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)

# Geometric Objects

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data=mpg) +
  geom_smooth(mapping = aes(x=displ,y=hwy))

ggplot(data=mpg) +
  geom_smooth(mapping = aes(x=displ,y=hwy,linetype=drv))

ggplot(data=mpg) +
  geom_smooth(mapping = aes(x=displ,y=hwy,group=drv)) #nao mostra a legenda

ggplot(data=mpg) +
  geom_smooth(mapping = aes(x=displ,y=hwy,color=drv),
              show.legend = FALSE) 
# To display multiple geoms in the same plot,
# add multiple geom functions to  ggplot() 

ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ,y=hwy))+
  geom_smooth(mapping = aes(x=displ,y=hwy))

## Para facilitar pode ser feito como abaixo

ggplot(data=mpg,mapping = aes(x=displ,y=hwy)) +
  geom_point()+
  geom_smooth()

# Permite:
# If you place mappings in a geom function, ggplot2 will treat them as
# local mappings for the layer. It will use these mappings to extend or
# sible to display different aesthetics in different layers:
# overwrite the global mappings for that layer only. This makes it possible 
# to display different aesthetics in different layers:

ggplot(data=mpg,mapping = aes(x=displ,y=hwy)) +
  geom_point(mapping = aes(color=class))+
  geom_smooth()
# You can use the same idea to specify different  data for each layer.

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth(
    data = filter(mpg, class == "subcompact"),
    se = FALSE
  )
  
ggplot(
  data = mpg,
  mapping = aes(x = displ, y = hwy, color = drv)
) +
  geom_point() +
  geom_smooth(se = FALSE)
 
####
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()

# Identico a:

ggplot() +
  geom_point(
    data = mpg,
    mapping = aes(x = displ, y = hwy)
  ) +
  geom_smooth(
    data = mpg,
    mapping = aes(x = displ, y = hwy)
  )
####
#Exercise 6
#
#a)
ggplot(data=mpg,mapping = aes(x=displ,y=hwy))+
  geom_point(color="black")+
  geom_smooth(color="blue",se=FALSE,show.legend = FALSE)
#b)
ggplot(data=mpg,mapping = aes(x=displ,y=hwy))+
  geom_point(color="black")+
  geom_smooth(color="blue",se=FALSE,aes(group=drv))
#c)
ggplot(data=mpg,mapping = aes(x=displ,y=hwy))+
  geom_point(aes(color=drv))+
  geom_smooth(aes(color=drv),se=FALSE)
#d)
ggplot(data=mpg,mapping = aes(x=displ,y=hwy))+
  geom_point(aes(color=drv))+
  geom_smooth(color="blue",se=FALSE,show.legend = FALSE)
#e)
ggplot(data=mpg,mapping = aes(x=displ,y=hwy))+
  geom_point(aes(color=drv))+
  geom_smooth(aes(linetype=drv),se=FALSE,color="blue")
#f)
ggplot(data=mpg,mapping = aes(x=displ,y=hwy))+
  geom_point(aes(color=drv))

# Statistical Transformations
# Bar charts
ggplot2::diamonds

ggplot(data=diamonds)+
  geom_bar(mapping = aes(x=cut)) #count

ggplot(data=diamonds)+
  geom_bar(mapping = aes(x=cut,y=..prop..,group=1)) #prop

ggplot(data=diamonds)+
  stat_summary(mapping = aes(x=cut,y=depth),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median)

# Position Adjustments

ggplot(data=diamonds)+
  geom_bar(mapping = aes(x=cut,color=cut))

ggplot(data=diamonds)+
  geom_bar(mapping = aes(x=cut,fill=cut))

ggplot(data=diamonds)+
  geom_bar(mapping = aes(x=cut,fill=clarity))

ggplot(
  data = diamonds,
  mapping = aes(x = cut, fill = clarity)
) +
  geom_bar(alpha = 1/5, position = "identity")

ggplot(
  data = diamonds,
  mapping = aes(x = cut, color = clarity)
) +
  geom_bar(fill = NA, position = "identity")

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity),
           position = "dodge")

