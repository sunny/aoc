#!/usr/bin/env ruby

require "net/http"
require "pathname"

now = Time.now
dir = Pathname.new(__dir__)
input_path = dir.join(now.strftime("%Y/%d.txt"))
code_path = dir.join(now.strftime("%Y/%d.rb"))
cookie_path = dir.join(".aoc-cookie")
url = now.strftime("https://adventofcode.com/%Y/day/%-d/input")

unless input_path.exist?
  uri = URI(url)
  request = Net::HTTP::Get.new(uri)
  request["cookie"] = cookie_path.read.strip
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  File.write(input_path, http.request(request).read_body)
end

unless code_path.exist?
  File.write(code_path, <<~CODE)
    input = ""

    # input = File.read("#{input_path.basename}")

    input.lines.each do |line|
      p line
    end
  CODE
end
