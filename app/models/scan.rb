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
end
