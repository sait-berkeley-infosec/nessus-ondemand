require 'retriable'
require 'rest_client'

class Nessus
  # Library for Nessus API
  # Small and limited to what OnDemand needs:
  # 1. Create and kill sessions
  # 2. Create a scan
  # 3. Get the results of a scan
  # addressable and retriable will help here!
  @@session = nil
  @@nessus_host = ENV['NESSUS_HOST']
  @@nessus_user = ENV['NESSUS_USER']
  @@nessus_pw = ENV['NESSUS_PW']
  @@nessus_policy = ENV['NESSUS_POLICY']

  def self.createScan(target, name, token=@@session)
    # Creates a scan to be started RIGHT NOW.
    # Returns a UUID
    s = seq
    data = RestClient.post @@nessus_host+'scan/new', :token => token, :seq => s,
      :scan_name => name, :target => target, :policy_id => @@nessus_policy
    xml = Nokogiri::XML(data)
    verifyResponse(xml, s)
    return xml.at_css('uuid').content
  end

  def self.getScanResults(uuid, token=@@session)
    # Given a UUID, gets the results of a scan.
    # You should probably create multiple filters so that
    # you can glean different information from these results depending
    # on the situation.
    s = seq
    data = RestClient.post @@nessus_host+'report2/vulnerabilities',
      :token => token, :seq => s, :report => uuid
    xml = Nokogiri::XML(data)
    verifyResponse(xml, s)
    return xml
  end

  def self.createSession
    # Takes the environment variables needed
    # Returns randomly generated token.
    s = seq
    data = RestClient.post @@nessus_host+'login', :login => @@nessus_user,
      :seq => s, :password => @@nessus_pw
    # Put in exceptions for bad server stuff!
    xml = Nokogiri::XML(data)
    verifyResponse(xml, s)
    @@session = xml.at_css('token').content
  end

  def self.killSession(token=@@session)
    # Kills the currently defined session
    # Returns true if successful, false otherwise.
    s = seq()
    data = RestClient.post @@nessus_host+'logout', :token => token, :seq => s
    xml = Nokogiri::XML(data)
    begin
      verifyResponse(xml, s)
    rescue
      return false
    end
    if xml.at_css('contents').content == 'OK'
      @@session = nil
      return true
    end
    return false
  end

    private 
      def self.seq
        return Random.new.rand(9999).to_s
      end

      def self.verifyResponse(xml, s)
        # Checks a Nokogiri XML doc for validity.
        # Raises errors when it is not.
        raise StandardError unless xml.at_xpath('/reply/status').content == 'OK'
        raise StandardError unless xml.at_css('/reply/seq').content == s
        return true
      end
end
