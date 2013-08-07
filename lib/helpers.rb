require 'date'
require 'human_name_parser'
include Nanoc::Helpers::Blogging
include Nanoc::Helpers::HTMLEscape
include Nanoc::Helpers::LinkTo
include Nanoc::Helpers::Rendering
include Nanoc::Helpers::Tagging

def readings
  @items.select { |i| i[:layout] == 'post' }
end

def readings_for_author(author)
  @items.select { |item| (item[:author] || '')  == author }.sort_by do |r|
    r[:title]
  end
end

def readings_by_year(year)
  min = Date.new(year)
  max = Date.new(year + 1) - 1
  sort_by_date(readings.select { |r| (min..max).cover?(r[:created_at].to_date) }).reverse
end

def max_year
  sorted_readings[0][:created_at].to_date.year
end

def sorted_readings
  sort_by_date(readings)
end

def sort_by_date(readings)
  readings.sort_by do |r|
    attribute_to_time(r[:created_at])
  end.reverse
end

def authors(lower='a', upper='z')
  auths = Array.new
  readings.each do |r|
    auths.push(r[:author]) unless auths.include? r[:author]
  end
  auths = auths.select{|x| x.split(' ').last[0].downcase.between?(lower, upper)}
  auths.sort_by do |a|
    swap_names(a).downcase
  end
end

def s3_url(filename)
  "http://s3.amazonaws.com/spokenrune/#{filename}.mp3"
end

def apostrophize(s)
  s.gsub("'", '&#8217;')
end

def swap_names(name)
  parsed = HumanNameParser.parse name
  if parsed.last.empty?
    return parsed.to_s
  end
  if not parsed.suffix.empty?
    return "#{parsed.last}, #{parsed.first} #{parsed.middle}, #{parsed.suffix}"
  end
  "#{parsed.last}, #{parsed.first} #{parsed.middle}"
end

# should this include "by" between title and author??
def reading_nav_link(reading)
  title = link_to(reading[:title].gsub("'", '&#8217;'), reading.path)
  author = reading[:author].gsub("'", '&#8217;')
  date = reading[:created_at].strftime('%b %-d')
  "#{title}<br/> #{author} &\#8211; <span>#{date}</span>"
end

# what reading do we feature on the home page?
def featured_reading
  sorted_readings[0]
end

def atom_id(reading)
  domain = @site.config[:base_url].gsub('http://', '')
  created_at = attribute_to_time(reading[:created_at])
  date = created_at.strftime('%Y-%m-%d')
  timestamp = created_at.strftime('%Y%m%d%H%M%S')
  "tag:#{domain},#{date}:/readings/#{timestamp}"
end
