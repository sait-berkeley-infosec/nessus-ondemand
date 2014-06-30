require 'spec_helper'

describe Nessus do
  describe '#test_login_logout' do
    it "should login and logout without issue" do
      expect(Nessus.test_login_logout).to be(true)
    end
  end
end
