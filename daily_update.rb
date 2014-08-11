#!/usr/bin/env ruby

require 'wombat'
require 'parse-ruby-client'
require 'hey'

Parse.init :application_id => ENV['PARSE_APP_ID'],
           :api_key        => ENV['PARSE_API_KEY']

parse_query = Parse::Query.new('dataset_count')
parse_query.eq("objectId", ENV['PARSE_OBJECT_ID'])
parse_data = parse_query.get.first
stored_total = parse_data ? parse_data["total"] : 0

result = Wombat.crawl do
  base_url "http://data.gov.my/"
  path "/dataset.php"
  counter xpath: "//*[contains(text(),'Total Records')]"
end

current_total = result['counter'].split(':').last.to_i

if current_total != stored_total
  parse_data['total'] = current_total
  parse_data.save

  Hey.api_token = ENV['YO_TOKEN']
  Hey::Yo.all
end  