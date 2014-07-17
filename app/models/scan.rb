class AddressValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      valid = Address.find(value)
      if valid.nil?
        record.errors.add(attribute, "is not a whitelisted address")
      end
    rescue
      record.errors.add(attribute, "is not a valid address")
    end
  end
end

class TimeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      if value.past?
        record.errors.add(attribute, "is in the past")
      end
    rescue NoMethodError
      record.errors.add(attribute, "can't be blank")
    end
  end
end

class Scan < ActiveRecord::Base
  validates :user, presence: true
  validates :targets, presence: true, address: true
  validates :time, presence: true, time: true
  validates :policy, presence: true

  def self.export!
    # Looks for all scans that are ready to be sent off.
    # Then sends them out through the API.
    right_now = Time.zone.now()
    results = []
    Scan.all.each do |s|
      if s.time <= right_now and s.uuid == nil
        results << s
      end
    end
    if Nessus.createSession
      results.each do |scan|
        scan.uuid = Nessus.createScan(scan.targets, "Scan ##{scan.id}")
        Rails.logger.warn "Scan ##{scan.id} exported! - UUID: #{scan.uuid}"
        scan.save
      end
      Nessus.killSession
    end
  end
end
