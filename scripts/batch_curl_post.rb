# frozen_string_literal: true

require 'json'

def search_files(dir, extension, recursiv)
  search = "#{dir}/*/*.{#{extension}}"
  search = "#{dir}/**/*.{#{extension}}" if recursiv
  Dir.glob(search)
end

root_dir = ARGV[0]
extension = ARGV[1]

url = 'http://localhost:3000/api/v1/revit/families.json'
curl_command = "curl -v -H 'Content-Type: application/json' -H 'Connection: close' -X POST"

searched_files = search_files(root_dir, extension, true)
p ">> Count #{searched_files.length}"
searched_files.each do |file|
  Kernel.system "#{curl_command} -d '@#{file}' #{url}"
end
