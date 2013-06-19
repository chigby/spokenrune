include Nanoc::Helpers::Blogging
include Nanoc::Helpers::HTMLEscape
include Nanoc::Helpers::LinkTo
include Nanoc::Helpers::Rendering

# ad hoc definition.  only readings have authors ... for now.
def readings
  @items.select { |item| item[:author] }
end

def sorted_readings
  readings.sort_by do |a|
    attribute_to_time(a[:created_at])
  end.reverse
end

def s3_url(filename)
  "http://s3.amazonaws.com/spokenrune/#{filename}.mp3"
end

# should this include "by" between title and author??
def reading_nav_link(reading)
  title = link_to(reading[:title].gsub("'", '&#8217;'), reading.path)
  author = reading[:author].gsub("'", '&#8217;')
  "#{title} #{author}"
end

# what reading do we feature on the home page?]
def featured_reading
  sorted_readings[0]
end

def atom_id(reading)
  domain = @site.config[:base_url].gsub('http://', '')
  created_at = attribute_to_time(reading[:created_at])
  date = created_at.strftime('%Y-%m-%d')
  timestamp = created_at.strftime('%Y%m%d%H%M%S') #reading[:created_at].to_s.gsub(/[^0-9]/, '')
  "tag:#{domain},#{date}:/readings/#{timestamp}"
end
