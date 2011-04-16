require "#{ENV["TM_SUPPORT_PATH"]}/lib/ui"

word = ENV['TM_CURRENT_WORD']
find_dir = ENV['TM_PROJECT_DIRECTORY']

if word.nil? || word.size <= 1
  puts "too short. please 2 more type(search keyword)"
  exit
end

results = `find "#{find_dir}" | egrep 'rb$|haml$|sass$|css$' | xargs egrep "#{word}" | sed 's/.*#{word}/#{word}/'|sort|uniq`

choices = results.split("\n").map do |node|
  {'display' =>  node, 'match' => node}
end
TextMate::UI.complete(choices, :extra_chars => '_!?')

#
