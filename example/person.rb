require 'active_service_mapper'
require 'plain_old_model/base'
require_relative 'billing_address'

class Person < PlainOldModel::Base
  attr_accessor :first_name, :last_name
  has_one :billing_address

  extend ActiveServiceMapper
  def self.convert_response(response,options={})
    convert_to_symbol(response,options={})
  end
end