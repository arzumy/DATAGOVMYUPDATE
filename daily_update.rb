#!/usr/bin/env ruby

require 'wombat'
begin
  result = Wombat.crawl do
    base_url "http://data.gov.my/"
    path "/dataset.php"
    counter xpath: "//*[contains(text(),'Total Records')]"
  end
  puts result['counter'].split(':').last.to_i
rescue
end