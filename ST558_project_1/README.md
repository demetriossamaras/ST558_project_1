Vignette for reading and summarizing data from API’s
================
Demetrios Samaras
2023-06-16

- [Purpose](#purpose)
- [Required packages](#required-packages)
- [Functions for querying endpoints](#functions-for-querying-endpoints)
  - [Step 0](#step-0)
  - [Contact the API](#contact-the-api)
  - [Interacting with the Pokemon API
    endpoints.](#interacting-with-the-pokemon-api-endpoints)
    - [Pokemon `WhosThatPokemon` endpoint
      1](#pokemon-whosthatpokemon-endpoint-1)
    - [Berry `WhichBerry` endpoint 2](#berry-whichberry-endpoint-2)
    - [Generation `WhatGeneration` endpoint
      3](#generation-whatgeneration-endpoint-3)
    - [Contest-type`ContestTypes` endpoint
      4](#contest-typecontesttypes-endpoint-4)
    - [Item `GotItem` endpoint 5](#item-gotitem-endpoint-5)
    - [Location `WhereAmI` endpoint 6](#location-whereami-endpoint-6)
    - [`GiveMeThisInfo`](#givemethisinfo)
- [EDA](#eda)
  - [Berry sizes](#berry-sizes)
  - [Pokemon heights, weights and
    types](#pokemon-heights-weights-and-types)
  - [Pokemon Linear density](#pokemon-linear-density)
- [Conclusion](#conclusion)

# Purpose

##### The purpose of this Vignette is to summarize how to interact with, pull data and then analyze the data from the pokemon data API <https://pokeapi.co/>.

# Required packages

##### The following packages will be required

- **tidyverse**
  - We will use a number of the functions from the tidyverse
- **jsonlite**
  - This will help up interact with the API
- **httr**
  - for the `GET` function
- **ggplot2**
  - This will be required to create the data visualizations (comes in
    tidyverse)

# Functions for querying endpoints

### Step 0

Make sure all of the required packages are installed using the
`install.packages()` function and library them using `library()`

``` r
library(tidyverse)
library(jsonlite)
library(httr)
library(ggplot2)
```

## Contact the API

This is the general format that we will use to contact the api and
retrieve data (One thing to note is that the Pokemon API does not
require a key, many other API’s will require you to use your specific
key included at the end of the URL)

``` r
## this is a functin to contact the API from a url 
query <- function(x){
  ## will generate a url with the desired endpoint and inputed data 
  url<- x 
  
 ## contact the api  and store the response  
 response <-GET(x)
 ## converts raw to charecter  
 data <- rawToChar(response$content)
 ## converts from json data
 jsondata <- fromJSON(data)
 ## organizes results of interest in a tibble and prints 
 tibbleresults <- as_tibble(jsondata$ResultOfInterest)
 
 tibbleresults
 
}
```

## Interacting with the Pokemon API endpoints.

### Pokemon `WhosThatPokemon` endpoint 1

This function will return a list of Pokemon and their ID number. As of
writing there are 1281 Pokemon so by default it will return a tibble
containing the names of all Pokemon in order. If you only wanted to see
the first n number of Pokemon you would set n equal to that number. For
example n=151 will return only the first 151 Pokemon. If you have a
specific Pokemon in mind you can give the name or ID as pokemon=“name”
or pokemon=ID which will return a the information available about that
specific pokemon. If you know the information that you want on that
pokemon you can set info equal to the info of interest. For example if
want the weight set info=“weight”.

``` r
## https://pokeapi.co/api/v2/pokemon/ 

WhosThatPokemon <- function(pokemon="all", n=1281, info=NULL){
  ## if you want all Pokemon between 1 and your number of interest n
  if(n>1281){
    ## kicks out the user if n is larger than what is available from the api
    stop("There are only 1281 pokemon")
  }
  if(pokemon=="all"){
  
 n == n
 ## creates the url to contact   
 url <- paste0("https://pokeapi.co/api/v2/pokemon/", "?limit=", n )
    
 response <-GET(url)
 
 data <- rawToChar(response$content)
 
 jsondata <- fromJSON(data)

 data<- as_tibble(jsondata$results)
 ## gets rid of the url column and adds a new column containing id numbers 
 data1<- data %>% select(name) %>% mutate(ID=1:n)
 
  }
 ## this returns info available on the specific Pokemon or ID number 
  if(pokemon!= "all"&is.null(info)){
 ## generates url containing Pokemon name or ID of interest   
 url <- paste0("https://pokeapi.co/api/v2/pokemon/", pokemon, "/" ) 
 
 response <-GET(url)
 
 data <- rawToChar(response$content)
 
 jsondata <- fromJSON(data)
 ## gives the available info on this Pokemon 
 data1<- as_tibble(names(jsondata))
 
  }
  if(pokemon!="all"& !is.null(info)){
  url <- paste0("https://pokeapi.co/api/v2/pokemon/", pokemon, "/" ) 
  
  #"https://pokeapi.co/api/v2/pokemon/bulbasaur/
 
 response <-GET(url)
 
 data <- rawToChar(response$content)
 
 jsondata <- fromJSON(data)  
 ## gives the desired info on this Pokemon 
 data1 <- as_tibble(jsondata[info])
  
 
  }
  data1
}
```

### Berry `WhichBerry` endpoint 2

This function will return a list of berries and their ID number. If you
only wanted to see the first n number of berries you would set n equal
to that number. For example n=10 will return only the first 10 berries.
If you have a specific berry in mind you can give the name or ID as
berry=“name” or berry=ID which will return a the information available
about that specific berry. If you know the information that you want on
that berry you can set info equal to the info of interest. For example
if want the smoothness set info=“smoothness”.

``` r
WhichBerry <- function(berry="all", n=64, info=NULL){
  ## if you want all berries between 1 and your number of interest n
  if(n>64){
    ## kicks out the user if n is larger than what is available from the api
    stop("There are only 64 berries")
  }
  
  if(berry=="all"){
  
 n == n
 ## creates the url to contact   
 url <- paste0("https://pokeapi.co/api/v2/berry/", "?limit=", n )
    
 response <-GET(url)
 
 data <- rawToChar(response$content)
 
 jsondata <- fromJSON(data)

 data<- as_tibble(jsondata$results)
 ## gets rid of the url column and adds a new column containing id numbers 
 data1<- data %>% select(name) %>% mutate(ID=1:n)
 
  }
 ## this returns info available on the specific berry or ID number 
  if(berry!= "all"&is.null(info)){
 ## generates url containing berry name or ID of interest   
 url <- paste0("https://pokeapi.co/api/v2/berry/", berry, "/" ) 
 
 response <-GET(url)
 
 data <- rawToChar(response$content)
 
 jsondata <- fromJSON(data)
 ## gives the available info on this berry 
 data1<- as_tibble(names(jsondata))
 
  }
  if(berry!="all"& !is.null(info)){
  url <- paste0("https://pokeapi.co/api/v2/berry/", berry, "/" ) 
  
 
 
 response <-GET(url)
 
 data <- rawToChar(response$content)
 
 jsondata <- fromJSON(data)  
 ## gives the desired info on this berry 
 data1 <- as_tibble(jsondata[[info]])
  
 
  }
  data1
}
```

### Generation `WhatGeneration` endpoint 3

This function will return a list of generations and their ID number. If
you only wanted to see the first n number of generations you would set n
equal to that number. For example n=9 will return all 9 generations. If
you have a specific generation in mind you can give the name or ID as
gen=“name” or gen=ID which will return the information available about
that specific generation. If you know the information that you want on
that generation you can set info equal to the info of interest. For
example if want the types of pokemon in that generations set
info=“types”.

``` r
WhatGeneration <- function(gen="all", n=9, info=NULL){
  ## if you want all between 1 and your number of interest n
  if(n>9){
    ## kicks out the user if n is larger than what is available from the api
    stop("There are only 9 generations")
  }
  if(gen=="all"){
  
 n == n
 ## creates the url to contact   
 url <- paste0("https://pokeapi.co/api/v2/generation/", "?limit=", n )
    
 response <-GET(url)
 
 data <- rawToChar(response$content)
 
 jsondata <- fromJSON(data)

 data<- as_tibble(jsondata$results)
 ## gets rid of the url column and adds a new column containing id numbers 
 data1<- data %>% select(name) %>% mutate(ID=1:n)
 
  }
 ## this returns info available on the specific generation or ID number 
  if(gen!= "all"&is.null(info)){
 ## generates url containing generation name or ID of interest   
 url <- paste0("https://pokeapi.co/api/v2/generation/", gen, "/" ) 
 
 response <-GET(url)
 
 data <- rawToChar(response$content)
 
 jsondata <- fromJSON(data)
 ## gives the available info on this generation 
 data1<- as_tibble(names(jsondata))
 
  }
  if(gen!="all"& !is.null(info)){
  url <- paste0("https://pokeapi.co/api/v2/generation/", gen, "/" ) 
  
 
 response <-GET(url)
 
 data <- rawToChar(response$content)
 
 jsondata <- fromJSON(data)  
 ## gives the desired info on this generation 
 data1 <- as_tibble(jsondata[[info]])
  
 
  }
  data1
}
```

### Contest-type`ContestTypes` endpoint 4

This function will return a list of contest types and their ID number.
If you only wanted to see the first n number of contest types you would
set n equal to that number. For example n=5 will return all contest
types. If you have a specific contest in mind you can give the name or
ID as con=“name” or con=ID which will return the information available
about that specific contest type. If you know the information that you
want on that contest type you can set info equal to the info of
interest. For example if want the berry flavor that correlates with this
contest type set info=“berry_flavor”.

``` r
ContestTypes <- function(con="all", n=5, info=NULL){
  ## if you want all  between 1 and your number of interest n
  if(n>5){
    ## kicks out the user if n is larger than what is available from the api
    stop("There are only 5 contest types")
  }
  if(con=="all"){
  
 n == n
 ## creates the url to contact   
 url <- paste0("https://pokeapi.co/api/v2/contest-type/", "?limit=", n )
    
 response <-GET(url)
 
 data <- rawToChar(response$content)
 
 jsondata <- fromJSON(data)

 data<- as_tibble(jsondata$results)
 ## gets rid of the url column and adds a new column containing id numbers 
 data1<- data %>% select(name) %>% mutate(ID=1:n)
 
  }
 ## this returns info available on the specific contest type or ID number 
  if(con!= "all"&is.null(info)){
 ## generates url containing contest type or ID of interest   
 url <- paste0("https://pokeapi.co/api/v2/contest-type/", con, "/" ) 
 
 response <-GET(url)
 
 data <- rawToChar(response$content)
 
 jsondata <- fromJSON(data)
 ## gives the available info on this contest type
 data1<- as_tibble(names(jsondata))
 
  }
  if(con!="all"& !is.null(info)){
  url <- paste0("https://pokeapi.co/api/v2/contest-type/", con, "/" ) 
  
  
 
 response <-GET(url)
 
 data <- rawToChar(response$content)
 
 jsondata <- fromJSON(data)  
 ## gives the desired info on this contest type 
 data1 <- as_tibble(jsondata[[info]])
  
 
  }
  data1
}
```

### Item `GotItem` endpoint 5

This function will return a list of items and their ID number. If you
only wanted to see the first n number of items you would set n equal to
that number. For example n=10 will return only the first 10 items. If
you have a specific item in mind you can give the name or ID as
item=“name” or item=ID which will return the information available about
that specific item. If you know the information that you want on that
item you can set info equal to the info of interest. For example if want
the cost set info=“cost”.

``` r
GotItem <- function(item="all", n=2050, info=NULL){
  ## if you want all between 1 and your number of interest n
  if(n>2050){
    ## kicks out the user if n is larger than what is available from the api
   stop("There are only 2050 items")
  }
  if(item=="all"){
  
 n == n
 ## creates the url to contact   
 url <- paste0("https://pokeapi.co/api/v2/item/", "?limit=", n )
    
 response <-GET(url)
 
 data <- rawToChar(response$content)
 
 jsondata <- fromJSON(data)

 data<- as_tibble(jsondata$results)
 ## gets rid of the url column and adds a new column containing id numbers 
 data1<- data %>% select(name) %>% mutate(ID=1:n)
 
  }
 ## this returns info available on the specific item or ID number 
  if(item!= "all"&is.null(info)){
 ## generates url containing item name or ID of interest   
 url <- paste0("https://pokeapi.co/api/v2/item/", item, "/" ) 
 
 response <-GET(url)
 
 data <- rawToChar(response$content)
 
 jsondata <- fromJSON(data)
 ## gives the available info on this item 
 data1<- as_tibble(names(jsondata))
 
  }
  if(item!="all"& !is.null(info)){
  url <- paste0("https://pokeapi.co/api/v2/item/", item, "/" ) 
  
 
 
 response <-GET(url)
 
 data <- rawToChar(response$content)
 
 jsondata <- fromJSON(data)  
 ## gives the desired info on this item 
 data1 <- as_tibble(jsondata[[info]])
  
 
  }
  data1
}
```

### Location `WhereAmI` endpoint 6

This function will return a list of locations and their ID number. If
you only wanted to see the first n number of locations you would set n
equal to that number. For example n=10 will return only the first 10
locations. If you have a specific location in mind you can give the name
or ID as loc=“name” or loc=ID which will return a the information
available about that specific location. If you know the information that
you want on that location you can set info equal to the info of
interest. For example if want the region set info=“region”.

``` r
WhereAmI <- function(loc="all", n=850, info=NULL){
  ## if you want all between 1 and your number of interest n
  if(n>850){
    ## kicks out the user if n is larger than what is available from the api
    stop("There are only 850 locations")
  }
  
  if(loc=="all"){
  
 n == n
 ## creates the url to contact   
 url <- paste0("https://pokeapi.co/api/v2/location/", "?limit=", n )
    
 response <-GET(url)
 
 data <- rawToChar(response$content)
 
 jsondata <- fromJSON(data)

 data<- as_tibble(jsondata$results)
 ## gets rid of the url column and adds a new column containing id numbers 
 data1<- data %>% select(name) %>% mutate(ID=1:n)
 
  }
 ## this returns info available on the specific location or ID number 
  if(loc!= "all"&is.null(info)){
 ## generates url containing location name or ID of interest   
 url <- paste0("https://pokeapi.co/api/v2/location/", loc, "/" ) 
 
 response <-GET(url)
 
 data <- rawToChar(response$content)
 
 jsondata <- fromJSON(data)
 ## gives the available info on this location 
 data1<- as_tibble(names(jsondata))
 
  }
  if(loc!="all"& !is.null(info)){
  url <- paste0("https://pokeapi.co/api/v2/location/", loc, "/" ) 
  
 
 response <-GET(url)
 
 data <- rawToChar(response$content)
 
 jsondata <- fromJSON(data)  
 ## gives the desired info on this location 
 data1 <- as_tibble(jsondata[[info]])
  
 
  }
  data1
}
```

### `GiveMeThisInfo`

This function will use our 6 endpoint functions to pull info from
whichever endpoint is desired by setting fun=desired function to help
with our EDA. For example say you want costs for items ID 25 - 42 or a
random sample of pokemon and their heights. This function takes a vector
of names **or** a vector of ID’s that are supplied by the user and info
= “desired info”. The desired info must return a single integer, for
example height, weight, size, cost, etc.

``` r
GiveMeThisInfo <- function(fun = WhosThatPokemon, vec, info=NULL){
  
  ## checks if the vector input is numeric 
  if(is.numeric(vec)){
  
  ##creates index of all from the desired function  
  index <- fun()
  
  ## adjusts the index to be the ID of interest   
  index <- subset(index, ID %in% vec) 
  
  ## applies the function to ID's of interest 
  ThesePokemon <-sapply(X=vec, FUN = fun, info = info)
  ThesePokemon <- unlist(ThesePokemon)
  
  ## creates a data frame with names 
  p<- data.frame(name=index$name, ID=index$ID , info=ThesePokemon)
  ## sets the name of the column with desired info to the info requested 
  names(p)[3] <- info
  
  return(as_tibble(p))
  }
else{
  index <- fun() 
  ## adjusts the index to be name of interest   
  index <- subset(index, name %in% vec)

  ## applies the  function to names of interest 
  ThesePokemon <-sapply(X=vec, FUN = fun, info = info)
  ThesePokemon <- unlist(ThesePokemon)
  
  ## creates a data frame with names 
  p<- data.frame(name=index$name, ID=index$ID , info=ThesePokemon, row.names = NULL)
  ## sets the name of the column with desired info to the info requested 
  names(p)[3] <- info
  
  return(as_tibble(p))

 }
}
```

# EDA

### Berry sizes

Here we will look at the size distribution of all berries using the
functions we created. This will return a tibble that has all 64 berries
and their sizes.

``` r
## grabs all the berries
Berries <- GiveMeThisInfo(fun = WhichBerry, vec = 1:64, info = "size")

Berries 
```

    ## # A tibble: 64 × 3
    ##    name      ID  size
    ##    <chr>  <int> <int>
    ##  1 cheri      1    20
    ##  2 chesto     2    80
    ##  3 pecha      3    40
    ##  4 rawst      4    32
    ##  5 aspear     5    50
    ##  6 leppa      6    28
    ##  7 oran       7    35
    ##  8 persim     8    47
    ##  9 lum        9    34
    ## 10 sitrus    10    95
    ## # ℹ 54 more rows

Here we will categorize the berries into size and look at how many fall
into each group. We can see that the largest number of berries fall into
the small size category, none are tiny and a similar amount fall into
medium and large.

``` r
## categorizes the berries based on size 
 BerrySize<- ifelse(Berries$size >= 200, "large",
      ifelse(Berries$size >= 100, "medium",
        ifelse(Berries$size >= 10, "small", "tiny")))
## makes a contigency table of the size categories
table(BerrySize)
```

    ## BerrySize
    ##  large medium  small 
    ##     14     18     32

Looking at the frequency histogram We can see that berry size does not
seem to be symmetrically distributed and has a long right tail.

``` r
## estimates a decent binwidth
bw <- 2 * IQR(Berries$size) / length(Berries$size)^(1/3)
##sets plotting object 
h <- ggplot(Berries, aes(x=size))
## makes histogram
h+geom_histogram(binwidth = bw, color="red", fill="blue") + labs(x="Size(mm)") + ggtitle("Berry size frequency")
```

![](C:/Users/Demetri/Documents/NCSU_masters/ST558/Project_1/ST558_project_1/ST558_project_1/README_files/figure-gfm/histogram-1.png)<!-- -->

### Pokemon heights, weights and types

We are going to use the functions that we created to figure out how many
pokemon are in generation 1 and get the heights and weights and types of
all of the pokemon in generation 1 to look at the relationship.

``` r
## gives us a count of all the pokemon in the first generation
gen1<- WhatGeneration(gen=1, info="pokemon_species") %>% nrow()

## contacts the api to get the heights for the first generation of pokemon
Gen1PokeHeights <- GiveMeThisInfo(fun = WhosThatPokemon, vec=1:gen1, info = "height")

## contacts the api to get the weights for the first generation of pokemon
Gen1PokeWeights <- GiveMeThisInfo(fun = WhosThatPokemon, vec =1:gen1, info = "weight")

## types does not return a single integer so we will use sapply to get types 
Gen1PokeTypes <- sapply(X=c(1:gen1), FUN = WhosThatPokemon, info = "types")

## pulls the primary type out for each pokemon 
Gen1PokeTypes <- sapply(1:gen1, FUN = function(i){ Gen1PokeTypes[[i]][[2]][1,1]})

## takes primary type as a tiblle
Gen1PokeTypes<- Gen1PokeTypes%>% as_tibble()

## renames column
names(Gen1PokeTypes) <- "type"

## binds the column of heights, weights, and types together

Gen1PokeHWT <- cbind(Gen1PokeHeights, select(Gen1PokeWeights, "weight"), select(Gen1PokeTypes, "type"))

Gen1PokeHWT
```

    ##           name  ID height weight     type
    ## 1    bulbasaur   1      7     69    grass
    ## 2      ivysaur   2     10    130    grass
    ## 3     venusaur   3     20   1000    grass
    ## 4   charmander   4      6     85     fire
    ## 5   charmeleon   5     11    190     fire
    ## 6    charizard   6     17    905     fire
    ## 7     squirtle   7      5     90    water
    ## 8    wartortle   8     10    225    water
    ## 9    blastoise   9     16    855    water
    ## 10    caterpie  10      3     29      bug
    ## 11     metapod  11      7     99      bug
    ## 12  butterfree  12     11    320      bug
    ## 13      weedle  13      3     32      bug
    ## 14      kakuna  14      6    100      bug
    ## 15    beedrill  15     10    295      bug
    ## 16      pidgey  16      3     18   normal
    ## 17   pidgeotto  17     11    300   normal
    ## 18     pidgeot  18     15    395   normal
    ## 19     rattata  19      3     35   normal
    ## 20    raticate  20      7    185   normal
    ## 21     spearow  21      3     20   normal
    ## 22      fearow  22     12    380   normal
    ## 23       ekans  23     20     69   poison
    ## 24       arbok  24     35    650   poison
    ## 25     pikachu  25      4     60 electric
    ## 26      raichu  26      8    300 electric
    ## 27   sandshrew  27      6    120   ground
    ## 28   sandslash  28     10    295   ground
    ## 29   nidoran-f  29      4     70   poison
    ## 30    nidorina  30      8    200   poison
    ## 31   nidoqueen  31     13    600   poison
    ## 32   nidoran-m  32      5     90   poison
    ## 33    nidorino  33      9    195   poison
    ## 34    nidoking  34     14    620   poison
    ## 35    clefairy  35      6     75    fairy
    ## 36    clefable  36     13    400    fairy
    ## 37      vulpix  37      6     99     fire
    ## 38   ninetales  38     11    199     fire
    ## 39  jigglypuff  39      5     55   normal
    ## 40  wigglytuff  40     10    120   normal
    ## 41       zubat  41      8     75   poison
    ## 42      golbat  42     16    550   poison
    ## 43      oddish  43      5     54    grass
    ## 44       gloom  44      8     86    grass
    ## 45   vileplume  45     12    186    grass
    ## 46       paras  46      3     54      bug
    ## 47    parasect  47     10    295      bug
    ## 48     venonat  48     10    300      bug
    ## 49    venomoth  49     15    125      bug
    ## 50     diglett  50      2      8   ground
    ## 51     dugtrio  51      7    333   ground
    ## 52      meowth  52      4     42   normal
    ## 53     persian  53     10    320   normal
    ## 54     psyduck  54      8    196    water
    ## 55     golduck  55     17    766    water
    ## 56      mankey  56      5    280 fighting
    ## 57    primeape  57     10    320 fighting
    ## 58   growlithe  58      7    190     fire
    ## 59    arcanine  59     19   1550     fire
    ## 60     poliwag  60      6    124    water
    ## 61   poliwhirl  61     10    200    water
    ## 62   poliwrath  62     13    540    water
    ## 63        abra  63      9    195  psychic
    ## 64     kadabra  64     13    565  psychic
    ## 65    alakazam  65     15    480  psychic
    ## 66      machop  66      8    195 fighting
    ## 67     machoke  67     15    705 fighting
    ## 68     machamp  68     16   1300 fighting
    ## 69  bellsprout  69      7     40    grass
    ## 70  weepinbell  70     10     64    grass
    ## 71  victreebel  71     17    155    grass
    ## 72   tentacool  72      9    455    water
    ## 73  tentacruel  73     16    550    water
    ## 74     geodude  74      4    200     rock
    ## 75    graveler  75     10   1050     rock
    ## 76       golem  76     14   3000     rock
    ## 77      ponyta  77     10    300     fire
    ## 78    rapidash  78     17    950     fire
    ## 79    slowpoke  79     12    360    water
    ## 80     slowbro  80     16    785    water
    ## 81   magnemite  81      3     60 electric
    ## 82    magneton  82     10    600 electric
    ## 83   farfetchd  83      8    150   normal
    ## 84       doduo  84     14    392   normal
    ## 85      dodrio  85     18    852   normal
    ## 86        seel  86     11    900    water
    ## 87     dewgong  87     17   1200    water
    ## 88      grimer  88      9    300   poison
    ## 89         muk  89     12    300   poison
    ## 90    shellder  90      3     40    water
    ## 91    cloyster  91     15   1325    water
    ## 92      gastly  92     13      1    ghost
    ## 93     haunter  93     16      1    ghost
    ## 94      gengar  94     15    405    ghost
    ## 95        onix  95     88   2100     rock
    ## 96     drowzee  96     10    324  psychic
    ## 97       hypno  97     16    756  psychic
    ## 98      krabby  98      4     65    water
    ## 99     kingler  99     13    600    water
    ## 100    voltorb 100      5    104 electric
    ## 101  electrode 101     12    666 electric
    ## 102  exeggcute 102      4     25    grass
    ## 103  exeggutor 103     20   1200    grass
    ## 104     cubone 104      4     65   ground
    ## 105    marowak 105     10    450   ground
    ## 106  hitmonlee 106     15    498 fighting
    ## 107 hitmonchan 107     14    502 fighting
    ## 108  lickitung 108     12    655   normal
    ## 109    koffing 109      6     10   poison
    ## 110    weezing 110     12     95   poison
    ## 111    rhyhorn 111     10   1150   ground
    ## 112     rhydon 112     19   1200   ground
    ## 113    chansey 113     11    346   normal
    ## 114    tangela 114     10    350    grass
    ## 115 kangaskhan 115     22    800   normal
    ## 116     horsea 116      4     80    water
    ## 117     seadra 117     12    250    water
    ## 118    goldeen 118      6    150    water
    ## 119    seaking 119     13    390    water
    ## 120     staryu 120      8    345    water
    ## 121    starmie 121     11    800    water
    ## 122    mr-mime 122     13    545  psychic
    ## 123    scyther 123     15    560      bug
    ## 124       jynx 124     14    406      ice
    ## 125 electabuzz 125     11    300 electric
    ## 126     magmar 126     13    445     fire
    ## 127     pinsir 127     15    550      bug
    ## 128     tauros 128     14    884   normal
    ## 129   magikarp 129      9    100    water
    ## 130   gyarados 130     65   2350    water
    ## 131     lapras 131     25   2200    water
    ## 132      ditto 132      3     40   normal
    ## 133      eevee 133      3     65   normal
    ## 134   vaporeon 134     10    290    water
    ## 135    jolteon 135      8    245 electric
    ## 136    flareon 136      9    250     fire
    ## 137    porygon 137      8    365   normal
    ## 138    omanyte 138      4     75     rock
    ## 139    omastar 139     10    350     rock
    ## 140     kabuto 140      5    115     rock
    ## 141   kabutops 141     13    405     rock
    ## 142 aerodactyl 142     18    590     rock
    ## 143    snorlax 143     21   4600   normal
    ## 144   articuno 144     17    554      ice
    ## 145     zapdos 145     16    526 electric
    ## 146    moltres 146     20    600     fire
    ## 147    dratini 147     18     33   dragon
    ## 148  dragonair 148     40    165   dragon
    ## 149  dragonite 149     22   2100   dragon
    ## 150     mewtwo 150     20   1220  psychic
    ## 151        mew 151      4     40  psychic

In the following histograms we can see that the distribution of the
heights and weights are both centered at the lower end with long right
tails. This suggests that while most pokemon are similar sizes there are
some that are incredibly tall and heavy.

``` r
n <- ggplot(Gen1PokeHWT, aes(x=height))

n+ geom_histogram(color="red", fill="blue")+labs(x="Height(dm)")+ggtitle("Gen 1 height distribution")
```

![](C:/Users/Demetri/Documents/NCSU_masters/ST558/Project_1/ST558_project_1/ST558_project_1/README_files/figure-gfm/height%20distribution-1.png)<!-- -->

``` r
n <- ggplot(Gen1PokeHWT, aes(x=weight))

n+ geom_histogram(color="grey", fill="gold")+labs(x="weight(hg)")+ggtitle("Gen 1 weight distribution")
```

![](C:/Users/Demetri/Documents/NCSU_masters/ST558/Project_1/ST558_project_1/ST558_project_1/README_files/figure-gfm/weight%20distribution-1.png)<!-- -->

Here we can look at the relationship between the heights and the weights
of Pokemon based on there types. There is some correlation between
heights and weights, we can see that in general as weights increase so
do heights but there are some extreme examples of both that don’t follow
the trend line. There doesn’t seem to be an obvious relationship between
type and either size or weight based on this plot.

``` r
## correlation between height and weight 
correlation <- cor(Gen1PokeHWT$height, Gen1PokeHWT$weight)
## sets the plotting object as Gen1PokeHWT
s <- ggplot(Gen1PokeHWT, aes(x=height, y=weight))
## adds scatter and line 
s+geom_point(aes(color=type)) + geom_smooth(method = lm) +labs(y= "Height (dm)", x="Weight(hg)")+ggtitle("Height and Weight by type") + geom_text( x=75, y=500, size = 5, label = paste0("Correlation = ",
round(correlation, 2)))
```

![](C:/Users/Demetri/Documents/NCSU_masters/ST558/Project_1/ST558_project_1/ST558_project_1/README_files/figure-gfm/heights%20vs%20weights%20scatter-1.png)<!-- -->

This is a contingency table of the number of each type of Pokemon
followed by a bar plot of that count, we can see that water is the most
common type followed by normal. Ice and fairy are the least common types

``` r
## generates contingency table of type count 
TypeFeq <- table(Gen1PokeHWT$type)

TypeFeq
```

    ## 
    ##      bug   dragon electric    fairy fighting     fire    ghost    grass   ground      ice   normal 
    ##       12        3        9        2        7       12        3       12        8        2       22 
    ##   poison  psychic     rock    water 
    ##       14        8        9       28

``` r
f <- ggplot(data = Gen1PokeHWT, aes(y=type, fill=type))

f + geom_bar(stat = "count", ) + ggtitle("Count of each type")
```

![](C:/Users/Demetri/Documents/NCSU_masters/ST558/Project_1/ST558_project_1/ST558_project_1/README_files/figure-gfm/contigency%20table%20type-1.png)<!-- -->

### Pokemon Linear density

Here we will create a new variable from two of our variables height and
weight. We will take weight/height and treat it as linear density and
look at the average density for each setting of our categorical variable
type.

``` r
## creates new column density that is weight/height 
Gen1PokeHWT$density<- (Gen1PokeHWT$weight/Gen1PokeHWT$height)

Gen1PokeHWT
```

    ##           name  ID height weight     type      density
    ## 1    bulbasaur   1      7     69    grass   9.85714286
    ## 2      ivysaur   2     10    130    grass  13.00000000
    ## 3     venusaur   3     20   1000    grass  50.00000000
    ## 4   charmander   4      6     85     fire  14.16666667
    ## 5   charmeleon   5     11    190     fire  17.27272727
    ## 6    charizard   6     17    905     fire  53.23529412
    ## 7     squirtle   7      5     90    water  18.00000000
    ## 8    wartortle   8     10    225    water  22.50000000
    ## 9    blastoise   9     16    855    water  53.43750000
    ## 10    caterpie  10      3     29      bug   9.66666667
    ## 11     metapod  11      7     99      bug  14.14285714
    ## 12  butterfree  12     11    320      bug  29.09090909
    ## 13      weedle  13      3     32      bug  10.66666667
    ## 14      kakuna  14      6    100      bug  16.66666667
    ## 15    beedrill  15     10    295      bug  29.50000000
    ## 16      pidgey  16      3     18   normal   6.00000000
    ## 17   pidgeotto  17     11    300   normal  27.27272727
    ## 18     pidgeot  18     15    395   normal  26.33333333
    ## 19     rattata  19      3     35   normal  11.66666667
    ## 20    raticate  20      7    185   normal  26.42857143
    ## 21     spearow  21      3     20   normal   6.66666667
    ## 22      fearow  22     12    380   normal  31.66666667
    ## 23       ekans  23     20     69   poison   3.45000000
    ## 24       arbok  24     35    650   poison  18.57142857
    ## 25     pikachu  25      4     60 electric  15.00000000
    ## 26      raichu  26      8    300 electric  37.50000000
    ## 27   sandshrew  27      6    120   ground  20.00000000
    ## 28   sandslash  28     10    295   ground  29.50000000
    ## 29   nidoran-f  29      4     70   poison  17.50000000
    ## 30    nidorina  30      8    200   poison  25.00000000
    ## 31   nidoqueen  31     13    600   poison  46.15384615
    ## 32   nidoran-m  32      5     90   poison  18.00000000
    ## 33    nidorino  33      9    195   poison  21.66666667
    ## 34    nidoking  34     14    620   poison  44.28571429
    ## 35    clefairy  35      6     75    fairy  12.50000000
    ## 36    clefable  36     13    400    fairy  30.76923077
    ## 37      vulpix  37      6     99     fire  16.50000000
    ## 38   ninetales  38     11    199     fire  18.09090909
    ## 39  jigglypuff  39      5     55   normal  11.00000000
    ## 40  wigglytuff  40     10    120   normal  12.00000000
    ## 41       zubat  41      8     75   poison   9.37500000
    ## 42      golbat  42     16    550   poison  34.37500000
    ## 43      oddish  43      5     54    grass  10.80000000
    ## 44       gloom  44      8     86    grass  10.75000000
    ## 45   vileplume  45     12    186    grass  15.50000000
    ## 46       paras  46      3     54      bug  18.00000000
    ## 47    parasect  47     10    295      bug  29.50000000
    ## 48     venonat  48     10    300      bug  30.00000000
    ## 49    venomoth  49     15    125      bug   8.33333333
    ## 50     diglett  50      2      8   ground   4.00000000
    ## 51     dugtrio  51      7    333   ground  47.57142857
    ## 52      meowth  52      4     42   normal  10.50000000
    ## 53     persian  53     10    320   normal  32.00000000
    ## 54     psyduck  54      8    196    water  24.50000000
    ## 55     golduck  55     17    766    water  45.05882353
    ## 56      mankey  56      5    280 fighting  56.00000000
    ## 57    primeape  57     10    320 fighting  32.00000000
    ## 58   growlithe  58      7    190     fire  27.14285714
    ## 59    arcanine  59     19   1550     fire  81.57894737
    ## 60     poliwag  60      6    124    water  20.66666667
    ## 61   poliwhirl  61     10    200    water  20.00000000
    ## 62   poliwrath  62     13    540    water  41.53846154
    ## 63        abra  63      9    195  psychic  21.66666667
    ## 64     kadabra  64     13    565  psychic  43.46153846
    ## 65    alakazam  65     15    480  psychic  32.00000000
    ## 66      machop  66      8    195 fighting  24.37500000
    ## 67     machoke  67     15    705 fighting  47.00000000
    ## 68     machamp  68     16   1300 fighting  81.25000000
    ## 69  bellsprout  69      7     40    grass   5.71428571
    ## 70  weepinbell  70     10     64    grass   6.40000000
    ## 71  victreebel  71     17    155    grass   9.11764706
    ## 72   tentacool  72      9    455    water  50.55555556
    ## 73  tentacruel  73     16    550    water  34.37500000
    ## 74     geodude  74      4    200     rock  50.00000000
    ## 75    graveler  75     10   1050     rock 105.00000000
    ## 76       golem  76     14   3000     rock 214.28571429
    ## 77      ponyta  77     10    300     fire  30.00000000
    ## 78    rapidash  78     17    950     fire  55.88235294
    ## 79    slowpoke  79     12    360    water  30.00000000
    ## 80     slowbro  80     16    785    water  49.06250000
    ## 81   magnemite  81      3     60 electric  20.00000000
    ## 82    magneton  82     10    600 electric  60.00000000
    ## 83   farfetchd  83      8    150   normal  18.75000000
    ## 84       doduo  84     14    392   normal  28.00000000
    ## 85      dodrio  85     18    852   normal  47.33333333
    ## 86        seel  86     11    900    water  81.81818182
    ## 87     dewgong  87     17   1200    water  70.58823529
    ## 88      grimer  88      9    300   poison  33.33333333
    ## 89         muk  89     12    300   poison  25.00000000
    ## 90    shellder  90      3     40    water  13.33333333
    ## 91    cloyster  91     15   1325    water  88.33333333
    ## 92      gastly  92     13      1    ghost   0.07692308
    ## 93     haunter  93     16      1    ghost   0.06250000
    ## 94      gengar  94     15    405    ghost  27.00000000
    ## 95        onix  95     88   2100     rock  23.86363636
    ## 96     drowzee  96     10    324  psychic  32.40000000
    ## 97       hypno  97     16    756  psychic  47.25000000
    ## 98      krabby  98      4     65    water  16.25000000
    ## 99     kingler  99     13    600    water  46.15384615
    ## 100    voltorb 100      5    104 electric  20.80000000
    ## 101  electrode 101     12    666 electric  55.50000000
    ## 102  exeggcute 102      4     25    grass   6.25000000
    ## 103  exeggutor 103     20   1200    grass  60.00000000
    ## 104     cubone 104      4     65   ground  16.25000000
    ## 105    marowak 105     10    450   ground  45.00000000
    ## 106  hitmonlee 106     15    498 fighting  33.20000000
    ## 107 hitmonchan 107     14    502 fighting  35.85714286
    ## 108  lickitung 108     12    655   normal  54.58333333
    ## 109    koffing 109      6     10   poison   1.66666667
    ## 110    weezing 110     12     95   poison   7.91666667
    ## 111    rhyhorn 111     10   1150   ground 115.00000000
    ## 112     rhydon 112     19   1200   ground  63.15789474
    ## 113    chansey 113     11    346   normal  31.45454545
    ## 114    tangela 114     10    350    grass  35.00000000
    ## 115 kangaskhan 115     22    800   normal  36.36363636
    ## 116     horsea 116      4     80    water  20.00000000
    ## 117     seadra 117     12    250    water  20.83333333
    ## 118    goldeen 118      6    150    water  25.00000000
    ## 119    seaking 119     13    390    water  30.00000000
    ## 120     staryu 120      8    345    water  43.12500000
    ## 121    starmie 121     11    800    water  72.72727273
    ## 122    mr-mime 122     13    545  psychic  41.92307692
    ## 123    scyther 123     15    560      bug  37.33333333
    ## 124       jynx 124     14    406      ice  29.00000000
    ## 125 electabuzz 125     11    300 electric  27.27272727
    ## 126     magmar 126     13    445     fire  34.23076923
    ## 127     pinsir 127     15    550      bug  36.66666667
    ## 128     tauros 128     14    884   normal  63.14285714
    ## 129   magikarp 129      9    100    water  11.11111111
    ## 130   gyarados 130     65   2350    water  36.15384615
    ## 131     lapras 131     25   2200    water  88.00000000
    ## 132      ditto 132      3     40   normal  13.33333333
    ## 133      eevee 133      3     65   normal  21.66666667
    ## 134   vaporeon 134     10    290    water  29.00000000
    ## 135    jolteon 135      8    245 electric  30.62500000
    ## 136    flareon 136      9    250     fire  27.77777778
    ## 137    porygon 137      8    365   normal  45.62500000
    ## 138    omanyte 138      4     75     rock  18.75000000
    ## 139    omastar 139     10    350     rock  35.00000000
    ## 140     kabuto 140      5    115     rock  23.00000000
    ## 141   kabutops 141     13    405     rock  31.15384615
    ## 142 aerodactyl 142     18    590     rock  32.77777778
    ## 143    snorlax 143     21   4600   normal 219.04761905
    ## 144   articuno 144     17    554      ice  32.58823529
    ## 145     zapdos 145     16    526 electric  32.87500000
    ## 146    moltres 146     20    600     fire  30.00000000
    ## 147    dratini 147     18     33   dragon   1.83333333
    ## 148  dragonair 148     40    165   dragon   4.12500000
    ## 149  dragonite 149     22   2100   dragon  95.45454545
    ## 150     mewtwo 150     20   1220  psychic  61.00000000
    ## 151        mew 151      4     40  psychic  10.00000000

by creating a box plot of densities for each type we can see that for
some types the density is fairly symmetrical, whereas for others it is
highly skewed, like for type=dragon.

``` r
## creates a plotting object with density vs type
b <- ggplot(Gen1PokeHWT, aes(y=type, x=density, color=type))
## creats a set of boxplots of density vs type            
b + geom_boxplot(show.legend = FALSE) + labs(x="Linear density (hg/dm)")+ggtitle("Density by type")
```

![](C:/Users/Demetri/Documents/NCSU_masters/ST558/Project_1/ST558_project_1/ST558_project_1/README_files/figure-gfm/boxplot%20density-1.png)<!-- -->

# Conclusion

To summarize this vignette, we were able to create a number of functions
that allow the user to query a number of endpoints and extract desired
information into a form that allows for easy understanding and analysis.
We also used these functions to do a basic data analysis to check the
functionality and to look at some interesting data.
