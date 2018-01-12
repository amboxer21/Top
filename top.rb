#!/usr/local/bin/ruby

require 'ostruct'
require 'optparse'

def usage
  puts "\nruby top.rb --cpu=<cpu%> --mem=<mem%>\n"
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
  opt.on("--time NUM", Integer, "Time proc must be running before being killed.") do |t|
    @options.time = t
  end
end.parse!

@options.time = 1 if @options.time.nil?
usage if @options.cpu.nil? || @options.mem.nil?

def time_of_proc(name)
  @time_arr = []
  `ps -o etime -p $(pidof #{name}) 2> /dev/null`.each_line do |time| 
    @time_arr.push time
  end
  return @time_arr[1].to_i
end

@capture.each do |e|

  #puts "e => #{e}"
  
  name = e[3]
  cpu  = e[1].to_i
  mem  = e[2].to_i
  time = time_of_proc(name)

  puts "Time: #{time}, Name: #{name}" if time > @options.time

  puts "CPU% #{cpu}, Name: #{name}" if cpu > @options.cpu 
  puts "MEM% #{mem}, Name: #{name}" if mem > @options.mem
  puts "Killing process -> #{name}" if cpu > @options.cpu && mem > @options.mem && time > @options.time
  `pkill #{name}` if cpu > @options.cpu && mem > @options.mem && time > @options.time
end
