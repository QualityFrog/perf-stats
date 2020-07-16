########
# PerfStats
# => Performance timers for counting and timing activity
#
# by Ben Simo, ben@qualityfrog.com
#
# licensed under the GNU General Public License v3.0
#

require 'date'

class PerfStats


  def initialize (verbose = false)
    self.reset
    @verbose = verbose
  end


  def reset
    @stats = {}
  end


  def stats
    s = @stats.dup

    s.each do |k,v|
      s[k][:avg_duration] = (v[:duration]/v[:count]).round(6)
      s[k].delete(:start)
    end

    return s
  end


  protected def now_epoch
    DateTime.now.strftime('%Q').to_i / 1000.0
  end



  def start(transaction_name=nil)
    transaction_name = caller_locations.first.label if transaction_name.nil?

    puts "[START #{transaction_name}]" if @verbose == true

    unless @stats.key? transaction_name
      @stats[transaction_name] = {
        :count => 0,
        :duration => 0
      }
    end

    @stats[transaction_name][:start] = self.now_epoch
  end


  def end(transaction_name=nil,count=1)
    transaction_name = caller_locations.first.label if transaction_name.nil?

    duration = (self.now_epoch - @stats[transaction_name][:start]).round(6)
    @stats[transaction_name][:count] += count
    @stats[transaction_name][:duration] += duration
    @stats[transaction_name][:start] = nil

    puts "[END #{transaction_name}] #{duration.to_s}s / #{[count,1].max} = #{(duration/[count,1].max).round(6)}s" if @verbose == true

    return duration
  end


  protected def report1 (k,v)
    duration = sprintf("%.3f",v[:duration].round(3)).rjust(12)
    count = [v[:count],1].max.round(0).to_s.rjust(12)
    duration_each = sprintf("%.3f",(1000.0*(v[:duration])/[v[:count],1].max).round(3)).rjust(12)

    return "#{duration}s / #{count} = #{duration_each}ms : #{k}"
  end


  def report()
    text = []
    @stats.each { |k,v| text << self.report1(k,v) }
    return text.sort.join("\r\n")
  end


end
