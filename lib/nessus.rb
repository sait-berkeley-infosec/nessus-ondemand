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

  def self.test_login_logout
    @@session = self.createSession()
    if self.killSession(@@session)
      @@session = nil
      return true
    else
      return false
    end
  end

  private
    def self.createSession
      # Takes the environment variables needed
      # Returns randomly generated token.
      s = seq
      data = RestClient.post @@nessus_host+'login', :login => @@nessus_user, :seq => s, :password => @@nessus_pw
      # Put in exceptions for bad server stuff!
      xml = Nokogiri::XML(data)
      verifyResponse(xml, s)
      return xml.at_css('token').content
    end

    def self.killSession(token)
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
        return true
      end
      return false
    end

    def self.seq
      return Random.new.rand(9999).to_s
    end

    def self.verifyResponse(xml, s)
      # Checks a Nokogiri XML doc for validity.
      # Raises errors when it is not.
      raise StandardError unless xml.at_css('status').content == 'OK'
      raise StandardError unless xml.at_css('seq').content == s
      return true
    end
end
