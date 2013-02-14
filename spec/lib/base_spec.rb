require 'spec_helper'
#require 'json'


describe ActiveServiceMapper::Base do
extend ActiveServiceMapper
  #describe "Version" do
  #it "should return the correct version" do
  #  ActiveServiceMapper::VERSION.should == '0.0.1'
  #end
  #end

  describe "Parsing json responses to rails hash format " do
    it"should convert simple response values  to a hash" do
      simple_response = {"FirstName"=>"Bob", "LastName"=>"Newhart"}
      Person.convert_response(simple_response).should == {:first_name=>"Bob", :last_name=>"Newhart"}
    end

    it"should convert response's with nested array values to a hash" do
      not_simple_response = {"TestMe" => [{"Id"=> "one", "Desc" =>"Test"},{"Id"=> "two", "Desc" =>"test2"}]}
      Person.convert_response(not_simple_response).should == {:test_me => [{:id => "one", :desc =>"Test"},{:id => "two", :desc =>"test2"}]}
    end

    it"should convert responses with nested hash values to a hash format" do
      response_with_nested_attributes = {"FirstName"=>"Bob", "LastName"=>"Newhart", "BillingAddress" => {"Address1" => "one", "Address2" => "Two"}}
      Person.convert_response(response_with_nested_attributes).should == {:first_name=>"Bob", :last_name=>"Newhart", :billing_address => {:address1 => "one", :address2 => "Two"}}
    end
    it"should convert responses with  one level deep nested values to the proper hash format" do
      response_with_nested_attributes = {"FirstName"=>"Bob", "LastName"=>"Newhart", "BillingAddress" => {"Address1" => "one", "Address2" => "Two", "PhoneNumber" => {"Phone" => "123456789","Ext" => "2313"}}}
      Person.convert_response(response_with_nested_attributes).should == {:first_name=>"Bob", :last_name=>"Newhart", :billing_address=>{:address1=>"one", :address2=>"Two",:phone_number=>{:phone=>"123456789", :ext=>"2313"}} }
    end
    it"should convert responses with multi level nested values to hash format" do
      response_with_nested_attributes = {"FirstName"=>"Bob", "LastName"=>"Newhart", "BillingAddress" => {"Address1" => "one", "Address2" => "Two", "PhoneNumber" => {"Phone" => "123456789","Ext" => "2313", "TestMe" => [{"Id"=> "one", "Desc" =>"test"},{"Id"=> "two", "Desc" =>"test2"} ]}}}
      Person.convert_response(response_with_nested_attributes).should == {:first_name=>"Bob", :last_name=>"Newhart",:billing_address=>{:address1=>"one", :address2=>"Two",:phone_number => {:phone => "123456789",:ext => "2313", :test_me => [{:id => "one", :desc =>"test"},{:id => "two", :desc =>"test2"} ]}}}
    end
    it"should assign the responses with deep nested hashes and arrays to proper hash" do
      response_with_nested_attributes = {"FirstName"=>"Bob", "LastName"=>"Newhart", "BillingAddress" => {"Address1" => "one", "Address2" => "Two", "PhoneNumber" => {"Phone" => "123456789","Ext" => "2313", "TestMe" => [{"Id"=> "one", "Desc" =>"test", "Test" => [{"ID" => "identity"}]},{"Id"=> "two", "Desc" =>"test2"} ]}}}
      Person.convert_response(response_with_nested_attributes).should == {:first_name=>"Bob", :last_name=>"Newhart", :billing_address=>{:address1=>"one", :address2=>"Two", :phone_number=>{:phone=>"123456789", :ext=>"2313", :test_me=>[{:id=>"one", :desc=>"test", :test=>[{:id=>"identity"}]}, {:id=>"two", :desc=>"test2"}]}}}
    end

  end

  describe "response mapping to class" do
    it"should assign the simple response values  to a hash" do
      simple_response = {"FirstName"=>"Bob", "LastName"=>"Newhart"}
      Person.convert_response(simple_response).should == {:first_name=>"Bob", :last_name=>"Newhart"}
      @person = Person.new(Person.convert_to_symbol(simple_response))
      @person.first_name.should == "Bob"
      @person.last_name.should == "Newhart"
    end
    it"should assign the response's nested array values  to a hash" do
      not_simple_response = {"TestMe" => [{"Id"=> "one", "Desc" =>"Test"},{"Id"=> "two", "Desc" =>"test2"}]}
      response = Person.convert_response(not_simple_response)
      response.should == {:test_me => [{:id => "one", :desc =>"Test"},{:id => "two", :desc =>"test2"}]}
      @person = Person.new(response)
    end
    it"should assign the responses with nested hash values to a hash" do
      response_with_nested_attributes = {"FirstName"=>"Bob", "LastName"=>"Newhart", "BillingAddress" => {"Address1" => "one", "Address2" => "Two"}}
      response = Person.convert_response(response_with_nested_attributes)
      response.should == {:first_name=>"Bob", :last_name=>"Newhart", :billing_address => {:address1 => "one", :address2 => "Two"}}
      #@person = Person.new(response)
      #@person.billing_address.should == {:address1 => "one", :address2 => "Two"}
      #puts @person.billing_address.class

    end
    it"should assign the responses with multi level nested values to the class attribute" do
      response_with_nested_attributes = {"FirstName"=>"Bob", "LastName"=>"Newhart", "BillingAddress" => {"Address1" => "one", "Address2" => "Two", "PhoneNumber" => {"Phone" => "123456789","Ext" => "2313", "TestMe" => [{"Id"=> "one", "Desc" =>"test"},{"Id"=> "two", "Desc" =>"test2"} ]}}}
      response = Person.convert_response(response_with_nested_attributes)
      response.should == {:first_name=>"Bob", :last_name=>"Newhart",:billing_address=>{:address1=>"one", :address2=>"Two",:phone_number => {:phone => "123456789",:ext => "2313", :test_me => [{:id => "one", :desc =>"test"},{:id => "two", :desc =>"test2"} ]}}}
      #@person = Person.new(response)
      #@person.billing_address.should == {:address1=>"one", :address2=>"Two", :phone_number=>{:phone=>"123456789", :ext=>"2313", :test_me=>[{:id=>"one", :desc=>"test"}, {:id=>"two", :desc=>"test2"}]}}
      #@billing_address = @person.billing_address
      ##@phone = @billing_address.phone_number
    end
    it"should assign the responses with multi level nested values to the class attribute" do
      response_with_nested_attributes = {"FirstName"=>"Bob", "LastName"=>"Newhart", "BillingAddress" => {"Address1" => "one", "Address2" => "Two", "PhoneNumber" => {"Phone" => "123456789","Ext" => "2313", "TestMe" => [{"Id"=> "one", "Desc" =>"test", "Test" => [{"ID" => "identity"}]},{"Id"=> "two", "Desc" =>"test2"} ]}}}
      Person.convert_response(response_with_nested_attributes).should == {:first_name=>"Bob", :last_name=>"Newhart", :billing_address=>{:address1=>"one", :address2=>"Two", :phone_number=>{:phone=>"123456789", :ext=>"2313", :test_me=>[{:id=>"one", :desc=>"test", :test=>[{:id=>"identity"}]}, {:id=>"two", :desc=>"test2"}]}}}
    end

  end

end



# mapper , a config file which tells what to map to where . i.e like class.attribute = service.attribute
#
#

require 'plain_old_model/base'
require 'active_service_mapper'
class Person < PlainOldModel::Base
  require_relative '../../example/billing_address'
  attr_accessor :first_name, :last_name
  has_one :billing_address

  extend ActiveServiceMapper
  def self.convert_response(response,options={})
    convert_to_symbol(response,options={})
  end
end

class BillingAddress < PlainOldModel::Base
  attr_accessor :address1, :address2
  has_one :phone_number

end

class PhoneNumber < PlainOldModel::Base
  attr_accessor :phone, :ext
end
