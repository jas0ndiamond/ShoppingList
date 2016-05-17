require 'sinatra'
require 'json'
set :server, 'thin'
set :bind, '0.0.0.0'
set :port, 3333
  
#json file

#  "section":{
#    "section item":[
#      "item 1",
#      "item 2"
#      ]
    
get '/' do
  #return rendered page
  shopping_list = ""
  File.open(ARGV[0], "r") do |f|
    f.each_line do |line|
      shopping_list << line
    end
  end
  
  json_shopping_list = JSON.parse(shopping_list)
  
##local resources
#  output = "<html><head><title>Shopping List</title><meta charset=\"utf-8\">" + 
#  "<link rel=\"stylesheet\" href=\"jquery-ui-1.11.4.custom/jquery-ui.min.css\">\n"+
#  "<script type=\"text/javascript\" src=\"jquery-1.11.2.min.js\"></script>\n"+
#  "<script type=\"text/javascript\" src=\"jquery-ui-1.11.4.custom/jquery-ui.min.js\"></script>\n"+
#  "</head>\n<body>\n<div id=\"tabs\">\n<ul>\n"
  
  output = "<html><head><title>Shopping List</title><meta charset=\"utf-8\">" + 
  "<link rel=\"stylesheet\" href=\"//code.jquery.com/ui/1.11.4/themes/redmond/jquery-ui.css\">\n"+
  "<script src=\"//code.jquery.com/jquery-1.11.2.js\"></script>\n"+
  "<script src=\"//code.jquery.com/ui/1.11.4/jquery-ui.js\"></script>\n"+
  "</head>\n<body>\n<div id=\"tabs\">\n<ul>\n"
  
  tab_num=0
  json_shopping_list.keys.each do |section|
    output << "<li><a href=\"#fragment-#{tab_num}\"><span>#{section}</span></a></li>\n"
    tab_num+=1
  end
  
  output << "</ul>\n"
  
  tab_num=0
  json_shopping_list.each do |section,sub_section|
    output << "<div id=\"fragment-#{tab_num}\">\n"      
    output << "<ul>\n"
    sub_section.each do |item,notes|
      output<< "<input type=\"checkbox\"><b>#{item}</b></input><br>\n<ul>\n"
      
      notes.each do |note|
        output << "<input type=\"checkbox\">#{note}</input><br>\n"
      end
      
      output << "</ul>"
    end
    output << "</ul>\n"
    output << "</div>\n"
    tab_num+=1
  end
  
  output<<"</div>\n"
  
#  json_shopping_list.each do |key,val|
#
#    output << "<ul>"    
#    val.each do |item|
#      output << "<li><input type= \"checkbox\"/>"+ item + "</li>"
#    end
#    
#    output << "</ul>\n"
#  end
  
    
  
  return output+ "\n\n<script>\n$( \"#tabs\" ).tabs();\n</script>\n</body></html>"
end

get '/stop' do
  Thread.exit!
end

