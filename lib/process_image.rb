module ProcessImage
  def ProcessImage.process(auth_id)
    file_name = auth_id + Time.now.to_s.delete(' ')
    togo = Time.diff(Time.now(), "2014-07-27", '%d %h %m %s')[:diff]
    togo.slice! 'days' 
    command = "convert #{Rails.root}/tmp/images/image4.jpg -fill white -gravity Center -font Mojave-Bold -pointsize 300 -kerning 1 -annotate -20-50 ' #{togo} ' -fill white -gravity Center -font Mojave-Bold -pointsize 90 -annotate +0+250 ' DAYS  HOURS  MINS  SECS' -fill white -gravity Center -font Ubuntu-Light -pointsize 70 -kerning 0 -annotate +0+130 '___________________________________________' -fill white -gravity Center -font Mojave-Slanted -pointsize 45 -annotate +0+340 ' TO GO ' -fill white -gravity Center -font Ubuntu-Light -pointsize 70 -kerning 0 -annotate +0+300 '______________          ______________'  -fill white -gravity Center -font Mojave-Slanted -pointsize 40 -kerning 1 -annotate +0-400 ' COUNTDOWN TO CENTENNIAL ' -fill white -gravity Center -font Mojave-Slanted -pointsize 30 -kerning 1 -annotate +0+450 ' COUNTDOWN2014 ORG ' -fill white -gravity Center -font Ubuntu-Regular -pointsize 20 -kerning 1 -annotate +59+283 ' . ' #{Rails.root}/tmp/images/#{file_name}.jpg"
    system command 
    file_name
  end 

  def ProcessImage.remove_photo(file_name)
    command = "rm #{Rails.root}/tmp/images/#{file_name}.jpg"
    system command
  end
end
