require "active_service_mapper/version"

module ActiveServiceMapper
  extend self
  def convert_to_symbol(response)
      new_response = {}
      new_method(new_response,response)
      #populate_data(new_response, response)
      new_response
    end
  #
  #def populate_data(new_response, response)
  #  response.each do |k, v|
  #    g = {}
  #    if v.class == Hash || v.class == Array
  #      recursive(g, k, new_response, v)
  #    else
  #      new_response[k.to_s.underscore.to_sym] = v
  #    end
  #  end
  #end
  #
  #def recursive(g, k, new_response, v)
  #
  #    if v.class == Hash
  #     recursive(f= {},k,new_response,v)
  #    elsif v.class == Array
  #      v.each do
  #     recursive(f= {},k,new_response,v)
  #
  #      end
  #    else
  #    g[k.to_s.underscore.to_sym] = v
  #    end
  #  end

    #new_response[k.to_s.underscore.to_sym] = g
  #end

  #def new_method(new_response, response)
  #  response.each do |key, value|
  #    g = {}
  #    testrecurse(g, key, new_response, value)
  #  end
  #end
  #
  #def testrecurse(g, key, new_response, value)
  #  puts "g #{g}"
  #  puts "key#{key}"
  #  puts "new_response#{new_response}"
  #  puts "value#{value}"
  #  if value.class == Hash
  #    value.each do |newkey, newvalue|
  #      #testrecurse(new_response,newkey,g,newvalue)
  #      testrecurse(g,newkey,new_response,newvalue)
  #    end
  #    new_response[key.to_s.underscore.to_sym] = g
  #  elsif value.class == Array
  #    new_array = []
  #    value.each do |array_key|
  #      testrecurse(f={},k=nil,g,array_key)
  #    end
  #    puts "new g #{g} key #{key}"
  #    new_array << g
  #    new_response[key.to_s.underscore.to_sym] = new_array
  #  else
  #    new_response[key.to_s.underscore.to_sym] = value
  #  end
  #end

  def new_method(new_response, response)
    response.each do | key, value|
      puts key
      testrecurse(new_response, key, value)
    end
  end

  def testrecurse(new_response, key, value)
    if value.class == Hash
      extract_from_hash(key,new_response,value,false)
    elsif value.class == Array
      value.each do | item |
        extract_from_hash(key,new_response,item,true) if item.class == Hash
        if item.class == Array
          puts "Still an array"
        end
      end
    else
      new_response[key.to_s.underscore.to_sym] = value
    end

  end

  def extract_from_hash(key,new_response,value, is_array)
    g = {}
    value.each do |key, value|
      g[key.to_s.underscore.to_sym] = value
    end
    if is_array
      new_response[key.to_s.underscore.to_sym].class == Array ? new_response[key.to_s.underscore.to_sym] << g :new_response[key.to_s.underscore.to_sym] = [g]
    else
      puts "merge the hash ? #{g}"
      new_response[key.to_s.underscore.to_sym] = g
    end
    new_response
  end
end


# simple case - just convert the response keys to rails format.- Done

# somewhat complex - Do  the sane as above , but also need to do nested hashes. -Done

# complex : When the service response keys don't match up with the model.
 # 3rd case option 1: A dsl implementation at the class level , which does indicate the mapping level
 # 3rd case option 2 : A Config file which tells the mapper that certain fields from certain class map to certain field in the response.
