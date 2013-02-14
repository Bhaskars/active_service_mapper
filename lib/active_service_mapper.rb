require "active_service_mapper/version"
require 'plain_old_model/base'
module ActiveServiceMapper
  extend self
  def convert_to_symbol(response,options={})
     keys_to_symbol(response, options={})
  end


  def keys_to_symbol(response, options)
    new_hash = {}
    response.each do |key,value|
      if value.class == Hash
        new_hash[key_to_symbol(key,options={})] = keys_to_symbol(value,options)
      elsif value.class == Array
        new_hash[key_to_symbol(key,options={})] = keys_to_symbol_array(value)
      else #if value.class == String || value.class == Fixnum || value.class == Float
        new_hash[key_to_symbol(key,options={})] = value
      end
    end
    return new_hash
  end

  def key_to_symbol(key,options={})
    key.to_s.underscore.to_sym
  end

  def keys_to_symbol_array(array)
    new_array = []
    array.each do |item|
      if item.class == Hash
        new_array << keys_to_symbol(item,options={})
      elsif item.class == Array
        new_array << keys_to_symbol_array(item)
      else
        new_array << item
      end
    end
    return new_array
  end


end


# simple case - just convert the response keys to rails format.

# somewhat complex
# - The hash has nested hash and arrays.
# -  Do the same as simple case.

# complex : When the service response keys don't match up with the model's attributes.
 # 3rd case option 1: A dsl implementation at the class level , which does indicate the mapping level
 # 3rd case option 2 : A Config file which tells the mapper that certain fields from certain class map to certain field in the response.
