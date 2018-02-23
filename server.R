library(shiny)
library(plotly)
library(dplyr)

shinyServer(function(input, output) {
  
  prime<-function(min,max){
    if(min<=0 | max<=0 | min>max){return("Invalid number")}
    else{
      (min:max)[as.logical((min:max)%%2)]->p
      p[as.logical(p%%3)]->p
      p[as.logical(p%%5)]->p
      p[as.logical(p%%7)]->p
      
      length(p)->n
      b<-logical(n)
      for(i in 1:n){
        c<-logical(p[i])
        for(j in 1:p[i]){
          if(p[i]%%j==0){c[j]<-T}
        }
        if(sum(c)==2){b[i]<-T}
      }
      if (min<=2) {return(c(2,3,5,7,p[b]))}
      else if(min<=3) {return(c(3,5,7,p[b]))}
      else if(min<=5) {return(c(5,7,p[b]))}
      else if(min<=7) {return(c(7,p[b]))}
      else {return(p[b])}
    }
  }
  
  prime2<-function(x){
    if(x<=0 | x>10000){return("Invalid number")}
    else{
      if (x==2 | x==3 | x==5) {return("Yes")}
      else if(x==1 |(x%%2)==0|(x%%3)==0 |(x%%5)==0){return("No")}
      else {seq(from=2, to=x, by=2)->s1
        seq(from=3, to=x, by=3)->s2
        seq(from=5, to=x, by=5)->s3
        c(s1,s2,s3)->s
        s[order(s)]->s
        match(1:x,s)->m
        (1:x)[is.na(m)]->q
        c<-logical(length(q))
        for(i in 1:length(q)){
          if(x%%q[i]==0){c[i]<-T}
        }
        if(sum(c)==2){return("Yes")}
        else {return("No")}
      }
    }
  }
  
  observeEvent(input$Help1, {
    showModal(modalDialog(
      "Minimum is a natural number between 1 and 5000.
      Maximum is a natural number between 1 and 5000, greater than or equal to the minimum value.

      After entering the values, click 'Plot' button below to generate an interactive plot of prime numbers between min & max.
      
      If a large number is inputted, it may take a few seconds to generate a plot.
      Entering an invalid number will cause freeze. In that case, please reload the application.
  
       ",
      easyClose = TRUE,
      footer = NULL
    ))
  })
  
  observeEvent(input$Help2, {
    showModal(modalDialog(
      "Enter a natural number between 1 and 10000.
      
      Click the spin button to increse/decreae the inputted number by 1.
      
      Changing the value immediately gives an answer.",
      easyClose = TRUE,
      footer = NULL
    ))
  })
  

  yesno<-reactive({
    prime2(input$X)
  })
  
  x<-list(title="Index")
  y<-list(title="Number")
  
  Min<-eventReactive(input$PlotButton,{input$Minimum})
  Max<-eventReactive(input$PlotButton,{input$Maximum})
  p<-eventReactive(input$PlotButton,{prime(Min(),Max())})
  
  output$plot1 <- renderPlotly({
    input$PlotButton
    isolate({
      pp<-plot_ly(x=~time(p()),
                  y=~p(),type="scatter", mode="lines+markers")%>%
        layout(xaxis=x, yaxis=y)
      pp
    })
  })
  
  output$question<-renderText({
    paste("Is",input$X,"a prime number?")
  })
  output$answer<-renderText({
    paste(yesno(),"!")
  })
  
  
})