$(document).ready(function(){
  var newYear = new Date() 
  newYear = new Date("July 27, 2014 00:00:00") 
  $('#defaultCountdown').countdown({until: newYear, compact: true}) 
})


