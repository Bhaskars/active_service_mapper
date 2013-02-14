require 'plain_old_model/base'
class PhoneNumber < PlainOldModel::Base
  attr_accessor :phone, :ext
end