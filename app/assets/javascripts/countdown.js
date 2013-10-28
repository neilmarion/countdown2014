$(document).ready(function(){
  var newYear = new Date() 
  newYear = new Date(newYear.getFullYear() + 1, 1 - 1, 1) 
  $('#defaultCountdown').countdown({until: newYear, compact: true}) 
})


