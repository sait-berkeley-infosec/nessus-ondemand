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
end

f = YAML::load_file(File.join(Rails.root, 'config/targets.yml'))
f["Addresses"].each do |location, addresses|
  addresses.each do |ip|
    Address.new(address: ip, location: location)
  end
end
