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
    # Returns a hashtable of vulnerabilities.
    s = seq
    data = RestClient.post @@nessus_host+'report2/vulnerabilities',
      :token => token, :seq => s, :report => uuid
    xml = Nokogiri::XML(data)
    verifyResponse(xml, s)
    xml_vulns = xml.xpath("//vulnerability")
    description_url = "https://www.tenable.com/plugins/index.php?view=single&id="
    vulnerabilities = []
    # Okay, now we have to order the vulnerabilities from here.
    xml_vulns.each do |vuln|
      v = {}
      v['id'] = vuln.xpath('.//plugin_id')[0].content
      v['url'] = description_url + v['id']
      v['name'] = vuln.xpath('.//plugin_name')[0].content
      sev = vuln.xpath('.//severity')[0].content
      v['severity'] = severity_to_str(sev)
      v['severity_id'] = sev.to_i
      if v['severity_id'] != 0 # I don't care about informational shit
        vulnerabilities << v
      end
    end
    vulnerabilities = vulnerabilities.sort_by {|key| key['severity_id']}
    return vulnerabilities.reverse
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

      def self.severity_to_str(sev)
        if sev == "0"
          return "Informational"
        elsif sev == "1"
          return "Low"
        elsif sev == "2"
          return "Medium"
        elsif sev == "3"
          return "High"
        elsif sev == "4"
          return "Critical"
        else
          return "Unclassified"
        end
      end
end
