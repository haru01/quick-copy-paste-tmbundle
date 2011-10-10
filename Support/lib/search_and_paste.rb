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
results = `find "#{find_dir}"  #{names} -print0 | xargs -0 egrep "#{word}" | sed 's/.*#{word}/#{word}/'| sort | uniq`


choices = results.split("\n").sort{ |a, b|
  b.include?("(") ? b <=> a : a<=> b
}.map do |node|
  if m = /(\w+)(.*)/.match(node)
    index = 0
    insert = m[2].split(/,\s*/).map{|n| index  += 1; "${#{index}:#{n}}" }.join(", ") + "${#{index + 1}}"
    {'display' =>  node, 'match' => m[1], 'insert' => insert}
  else
    {'display' =>  node, 'match' => node}
  end
end

TextMate::UI.complete(choices, :extra_chars => '_!?')