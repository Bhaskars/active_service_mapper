require 'plain_old_model'
require_relative 'phone_number'
class BillingAddress < PlainOldModel::Base
  attr_accessor :address1, :address2
  has_one :phone_number

end
