# perf-stats
Super-simple performance timers


## Example Usage

```ruby

require 'perf_stats.rb'

perf = PerfStats.new

[1..10].each do |i|
  perf.start "print things"
  puts "things"
  perf.end "print things"
 end
 
 
stuff_count = 0
perf.start "print stuff"
[1..10].each do |i|
  puts "stuff"
  stuff_count += 1
 end
 perf.end "print stuff", stuff_count


puts perf.report

```
