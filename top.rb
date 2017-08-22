#!/usr/local/bin/ruby

require 'ostruct'
require 'optparse'

def usage
  puts "\nruby top.rb <cpu%> <mem%>\n"
  puts "     top.rb will kill any process running if it's CPU\n"
  puts "     and MEM % is greater than both arguments provided.\n\n"
  exit
end

@arr = []
`top -n1`.each_line do |line|
  @arr.push line
end

@capture = @arr.to_s.scan(/[\s\d]+(\d+)\s+[root|anthony]+\s+\w+\s+[\w\-]+\s+\w+\s+\w+\s+\w+\s\w+\s+([\w\.]+)\s+([\w\.]+)\s+[\w:\.]+\s+([\w\-]+)/)

@options = OpenStruct.new

OptionParser.new do |opt|
  opt.on("--cpu NUM", Integer, "Top CPU percentage to monitor.") do |c|
    @options.cpu = c
  end
  opt.on("--mem NUM", Integer, "Top MEM percentage to monitor.") do |m|
    @options.mem = m
  end
end.parse!

usage if @options.cpu.nil? || @options.mem.nil?

@capture.each do |e|

  #puts "e => #{e}"
  
  name = e[3]
  cpu  = e[1].to_i
  mem  = e[2].to_i

  puts "CPU% #{cpu}, Name: #{name}" if cpu > @options.cpu 
  puts "MEM% #{mem}, Name: #{name}" if mem > @options.mem
  puts "Killing processi -> #{name}" if cpu > @options.cpu && mem > @options.mem
  `pkill #{name}` if cpu > @options.cpu && mem > @options.mem
end
