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
  opt.on("--cpu NUM", Integer, "Top CPU percentage to monitor.") do |cpu|
    @options.cpu = cpu
  end
  opt.on("--mem NUM", Integer, "Top MEM percentage to monitor.") do |mem|
    @options.mem = mem
  end
  opt.on("--time NUM", Integer, "Time proc must be running before being killed.") do |time|
    @options.time = time
  end
end.parse!

@options.time = 1 if @options.time.nil?
usage if @options.cpu.nil? || @options.mem.nil?

def time_of_proc(name)
  unless name == 'top'
    [`ps -o etime -p $(pidof #{name}) 2> /dev/null`]
      .to_s.match(/[0-9]*:[0-9]*/)
      .to_s.split(/:/)[0]
  end
end

[`top -n1 -b | head -n20`].each do |top| 

  top.to_s.scan(/(\d+)\s(anthony|root).*(\d+\.\d+)\s+(\d+\.\d+)\s+\d:\d+\.\d+\s(\w+)/).each do |e|
  
    pid,name,cpu,mem,p = e[0],e[1],e[2],e[3],e[4];time=time_of_proc(p)
  
    if time.to_i >= @options.time and mem.to_i >= @options.mem and cpu.to_i >= @options.cpu and !p.nil?
      puts "Killing process -> #{p} with pid: #{pid.to_i}"
      puts "Time: #{time.to_i}, CPU% #{cpu.to_i}, %MEM: #{mem.to_i}, Name: #{name}, PID: #{pid}, Process: #{p}\n"
      #`/bin/kill -9 #{pid.to_i}` 
      `/bin/pkill #{p}` unless pid.nil? or p.nil? 
    end
  end
end
