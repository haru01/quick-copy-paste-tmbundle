require "#{ENV["TM_SUPPORT_PATH"]}/lib/ui"

word = ENV['TM_CURRENT_WORD']
find_dir = ENV['TM_PROJECT_DIRECTORY']
exit if word.size <= 2

results = `mdfind #{word} -onlyin #{find_dir} | egrep 'rb|haml|'  | xargs grep "#{word}" | awk '{$1=\"\";print $0 }'| sort | uniq | sed 's/ //'`
choices = results.split("\n").map do |node|
  {'display' =>  node, 'match' => node}
end
TextMate::UI.complete(choices, :extra_chars => '_!?')

# cho


