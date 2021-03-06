#!/usr/bin/env script/runner

default_domain = 'cloudshield.com'

require 'rexml/document'
include REXML # (import the namespace)

# really, we're decoding XML, but it seems to use HTML Entities
require 'htmlentities'

@htmlDecoder = HTMLEntities.new

$debug = false

require 'optparse'

OptionParser.new do |opt|
  opt.banner = "Usage from_wheel.rb [-v] restaurants.xml [users.xml]"
  opt.on('-v', '--verbose', 'Verbose output') { |v| $debug = v }
  opt.parse!(ARGV)
end

begin 
  restaurants = Document.new(File.new(ARGV.shift))
rescue Errno::ENOENT, Errno::EPERM => err
  $stderr.puts "Can't read restaurants file: #{err}"
  exit 255;
rescue
  $stderr.puts "Missing restaunts file name"
  exit 255;
end

begin 
  users = Document.new(File.new(ARGV.shift))
rescue
  # This is optional
  puts "Skipping user import"
end

byWheelID = {}
byName = {}
voteMap = {}

def extractText(parent, name)
  el = parent.elements[name]
  el.nil? ? "" : @htmlDecoder.decode(el.children.to_s)
end

def debug(*args)
  puts args if $debug
end

restaurants.elements.each("/WheelOYum/Destinations/Destination") do |dest|

  name = extractText(dest, "Name")
  wID = extractText(dest, "Id").to_i
  town = extractText(dest, "Town")
  url = extractText(dest, "URL")

  debug("Restaurant: #{name}")

  r = Restaurant.find_or_create_by_name(name)
  r.city = town
  r.url = url unless url.blank?
  
  lastVisit = dest.elements['LastVisited']
  unless lastVisit.nil?
    year = extractText(lastVisit, 'Year').to_i
    month = extractText(lastVisit,'Month').to_i + 1
    day = extractText(lastVisit, 'DayOfMonth').to_i

    date = "#{year}-#{month}-#{day}"
  
    debug "  date: #{date}"

    if r.visits.find_by_date(date).nil?
      v = Visit.new(:date => date)
      r.visits << v
    end
  end

  r.save!
  byWheelID[wID] = r
  byName[name] = r
end

exit if users.nil?

u = []

users.elements.each("/WheelOYum/Users/User") do |user|
  #extra
  inner = user.elements["User"]
  name = extractText(inner,"Name")
  login = extractText(user,"LoginName")

  active = false;

  debug "User: #{login} - #{name}"

  user = User.find_or_create_by_login(login)
  user.name = name
  user.plain_password_confirmation = user.plain_password = login if user.password.blank?

  if user.emails.length == 0
    # we should probably throw an exception rather than potentially
    # allow two users with the same email
    user.emails << Email.find_or_initialize_by_address("#{login}@#{default_domain}")
  end
  user.save!

  mood = Mood.find_by_user_id_and_name(user.id, "Wheel o' Yum")
  unless mood.nil?
    active = mood.active
    mood.destroy
    debug "  Removing old mood"
  end
  mood = Mood.new(:name => "Wheel o' Yum", :user_id => user.id)

  inner.elements.each("VoteRecords/VoteRecord/DestinationVotes/DestinationVote") do |dv|
    d = dv.attributes['DestinationId'].to_i
    v = dv.attributes['Vote'].to_i
    if voteMap.member?(v)
      v = voteMap[v]
    else
      v = Vote.find_by_value(v)
      voteMap[v.value] = v
    end
    debug "-- #{v.name} / #{byWheelID[d].name }"
    p = Preference.new(:restaurant => byWheelID[d], :vote => v)
    mood.preferences << p
  end

  test = Mood.find_by_user_id_and_active(user.id,true)

  if (test.nil?) 
    active = true
  end

  mood.active = active
  mood.save!
end
