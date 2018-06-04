#!/usr/local/bin/ruby

require 'ostruct'
require 'optparse'

def usage
  puts "\nruby top.rb --cpu=<cpu%> --mem=<mem%>\n"
  puts "     top.rb will kill any process running if it's CPU\n"
  puts "     and MEM % is greater than both arguments provided.\n\n"
  exit
end

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

[`top -n1 -b`].each do |top| 

  top.to_s.scan(/(\d+)\s(anthony|root).*(\d+\.\d+)\s+(\d+\.\d+)\s+\d:\d+\.\d+\s(\w+)/).each do |e|
  
    pid,name,cpu,mem,p = e[0],e[1],e[2],e[3],[4];time=time_of_proc(name)

    puts "Time: #{time}, CPU% #{cpu}, %MEM: #{@mem}, Name: #{name}, PID: #{@pid}, Process: #{@p}\n" if time > @options.time

    puts "CPU% #{cpu}, Name: #{name}" if cpu > @options.cpu 
    puts "MEM% #{mem}, Name: #{name}" if mem > @options.mem
    puts "Killing process -> #{name}" if cpu > @options.cpu && mem > @options.mem && time > @options.time
    `pkill #{name}` if cpu > @options.cpu && mem > @options.mem && time > @options.time
  end
end
