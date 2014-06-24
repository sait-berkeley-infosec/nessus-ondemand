require 'ipaddr'

class AddressValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      internal = false
      ip = IPAddr.new(value)
      Address.all.each do |a|
        range = IPAddr.new(a.address)
        if range.include?(ip)
          internal = true
        end
      end
      record.errors.add(attribute, "are not all internal addresses") unless internal
    rescue
      record.errors.add(attribute, "are not all valid addresses")
    end
  end
end

class Scan < ActiveRecord::Base
  validates :user, presence: true
  validates :targets, presence: true, address: true
  validates :time, presence: true
  validates :policy, presence: true
end
