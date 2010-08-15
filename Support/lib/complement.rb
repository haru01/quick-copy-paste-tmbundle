require "#{ENV["TM_SUPPORT_PATH"]}/lib/ui"

def tokenize(file)
  full_name, name, params = nil
  file.each do |line|
    if m = /^\s*full_name:\s*(.*)$/.match(line)
      full_name = m[1]
    elsif m = /^\s*name:\s*(.*)$/.match(line)
      name = m[1]
    elsif m = /^\s*params:\s*\w*\((.*)\)$/.match(line)
      params = m[1]
    end
  end
  return full_name, name, params
end

def params_with_index params
  return unless params
  index = 0
  params_with_index = params.split(",").map do |node|
    index = index + 1
    "${#{index}:#{node.strip}}"
  end.join(", ")
end

def choices
  return [] if ENV['TM_CURRENT_WORD'].size < 2
  paths = `mdfind "name:#{ENV['TM_CURRENT_WORD']}" -name yaml | grep "ri/.*\.yaml$"`
  comp_list = []
  paths.each do |path|
    open(path.strip) do |file|
      full_name, name, params = tokenize(file)
      # puts "name:#{name}, params:#{params}"
      comp_list << {'display' => "#{name}(#{params})  #{full_name}", 'insert' => "(#{params_with_index params})", 'match' => name}
    end
  end
  comp_list.uniq
end
# 
TextMate::UI.complete(choices, :extra_chars => '_!?')
