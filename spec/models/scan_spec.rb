require 'spec_helper'

describe Scan do
  before :all do
    @empty_scan = Scan.new
    @invalid_target = Scan.new(user: 000000, targets: 'nope',
                              policy: 0, time: Time.now()+1000)
    @valid_target = Scan.new(user: 000000, targets: '169.229.0.1',
                             policy: 0, time: Time.now()+1000)
    @external_target = Scan.new(user:000000, targets: '127.0.0.1',
                                policy: 0, time: Time.now()+1000)
    @default_policy = 0
    @past_scan = Scan.new(user:000000, targets: '169.229.0.1',
                          policy: 0, time: Time.now-1000)
  end

  describe "#new" do
    it "should not validate an empty scan" do
      expect(@empty_scan.valid?).to be(false)
    end

    it "should have a default" do
      expect(@empty_scan.policy).to be(@default_policy)
    end

    it "should expect an ip address" do
      expect(@invalid_target.valid?).to be(false)
    end

    it "should only allow certain ip addresses" do
      expect(@external_target.valid?).to be(false)
    end

    it "should validate a real ip address" do
      expect(@valid_target.valid?).to be(true)
    end

    it "should not allow past times" do
      expect(@past_scan.valid?).to be(false)
    end
  end
end
