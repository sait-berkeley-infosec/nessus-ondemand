require 'spec_helper'

describe Nessus do
  describe '#test_login_logout' do
    it "should login and logout without issue" do
      Nessus.createSession
      expect(Nessus.killSession).to be(true)
    end
  end

  describe '#createScan' do
    it "should be able to create a scan" do
      Nessus.createSession
      Nessus.createScan('127.0.0.1', 'OnDemand Test')
      Nessus.killSession
    end
  end

  describe '#getScanResults' do
    it "should get the results of a scan" do
      Nessus.createSession
      scan = Nessus.createScan('127.0.0.1', 'OnDemand Results Test')
      Nessus.getScanResults(scan)
      Nessus.killSession
    end
  end
end
