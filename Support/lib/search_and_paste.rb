require "#{ENV["TM_SUPPORT_PATH"]}/lib/ui"

# config
word = ENV['TM_CURRENT_WORD']
find_dir = ENV['TM_PROJECT_DIRECTORY']
extensions = %w[rb haml sass]

if word.nil? || word.size <= 1
  puts "too short. please 2 more type(search keyword)"
  exit
end

names = "\\(#{extensions.map{|e| "-or -name '*.#{e}' "}.join}\\)".sub("-or", "")
results = `find "#{find_dir}"  #{names} -print0 | xargs -0 egrep "#{word}" | sed 's/.*#{word}/#{word}/'|sort|uniq`

choices = results.split("\n").map do |node|
  {'display' =>  node, 'match' => node}
end

TextMate::UI.complete(choices, :extra_chars => '_!?') 
