require "#{ENV["TM_SUPPORT_PATH"]}/lib/ui"

paths = `mdfind "name:#{ENV['TM_CURRENT_WORD']}" | grep "i.yaml$"`
comp_list = []
paths.each do|path|
  open(path.strip) do |f|
    full_name, name, params, params_with_index = nil
    f.each do |line|
      if m = /^\s*full_name:\s*(.*)$/.match(line)
        full_name = m[1]
      elsif m = /^\s*name:\s*(.*)$/.match(line)
        name = m[1]
      elsif m = /^\s*params:\s*\w*\((.*)\)$/.match(line)
        params = m[1]
        if params
          index = 0
          params_with_index = params.split(",").map do |node|
            index = index + 1
            "${#{index}:#{node.strip}}"
          end.join(", ")
        end
      end
    end
    # puts "name:#{name}, params:#{params}"
    comp_list << {'display' => "#{name}(#{params}) \t\t-#{full_name}", 'insert' => "(#{params_with_index})", 'match' => name}
  end
end

TextMate::UI.complete(comp_list.uniq, :extra_chars => '_')
