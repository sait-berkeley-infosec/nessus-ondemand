require 'ipaddr'

class Address
  include ActiveAttr::Model

  attribute :address, :type => String
  attribute :location, :type => String, :default => "No Location Given"

  @@all_addresses = []

  def initialize(attributes={})
    super
    @@all_addresses << self
  end

  def self.all
    @@all_addresses
  end

  def self.find(ip)
    begin
      add = IPAddr.new(ip)
    rescue
      raise RangeError # if ip is not actually an IP
    end

    Address.all.each do |a|
      range = IPAddr.new(a.address)
      if range.include?(add)
        return a # If it is in a range, then we return that.
      end
    end
    return nil # Else we return nil
  end
end

f = YAML::load_file(File.join(Rails.root, 'config/targets.yml'))
f["Addresses"].each do |location, addresses|
  addresses.each do |ip|
    Address.new(address: ip, location: location)
  end
end
