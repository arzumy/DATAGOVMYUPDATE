#!/usr/bin/env ruby

require 'wombat'
require 'parse-ruby-client'
require 'hey'

Parse.init :application_id => ENV['PARSE_APP_ID'],
           :api_key        => ENV['PARSE_API_KEY']

parse_query = Parse::Query.new('dataset_count').get
stored_total = parse_query.empty? ? 0 : parse_query.first[:total]

result = Wombat.crawl do
  base_url "http://data.gov.my/"
  path "/dataset.php"
  counter xpath: "//*[contains(text(),'Total Records')]"
end

current_total = result['counter'].split(':').last.to_i

if current_total != stored_total
  parse_push = Parse::Object.new('dataset_count')
  parse_push['total'] = current_total
  parse_push.save

  Hey.api_token = ENV['YO_TOKEN']
  Hey::Yo.all
end  