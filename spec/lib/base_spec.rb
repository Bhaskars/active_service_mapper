require 'spec_helper'
require 'json'


describe ActiveServiceMapper::Base do
extend ActiveServiceMapper
  #describe "Version" do
  #it "should return the correct version" do
  #  ActiveServiceMapper::VERSION.should == '0.0.1'
  #end
  #end

  describe "Parsing json responses to rails hash format " do
    #it"should assign the simple response values  to a hash" do
    #  simple_response = {"FirstName"=>"Bob", "LastName"=>"Newhart"}
    #  Person.convert_to_symbol(simple_response).should == {:first_name=>"Bob", :last_name=>"Newhart"}
    #  @person = Person.new(Person.convert_to_symbol(simple_response))
    #  @person.first_name.should == "Bob"
    #  @person.last_name.should == "Newhart"
    #end

    it"should assign the response's nested array values  to a hash" do
      not_simple_response = {"TestMe" => [{"Id"=> "one", "Desc" =>"Test"},{"Id"=> "two", "Desc" =>"test2"}]} #,{"Id"=> "two", "Desc" =>"test2"}
      response = Person.convert_to_symbol(not_simple_response)
      response.should == {:test_me => [{:id => "one", :desc =>"Test"},{:id => "two", :desc =>"test2"}]}
      @person = Person.new(response)
    end

    it"should assign the responses with nested hash values to a hash" do
      response_with_nested_attributes = {"FirstName"=>"Bob", "LastName"=>"Newhart", "BillingAddress" => {"Address1" => "one", "Address2" => "Two"}}
      response = Person.convert_to_symbol(response_with_nested_attributes)
      response.should == {:first_name=>"Bob", :last_name=>"Newhart", :billing_address => {:address1 => "one", :address2 => "Two"}}
      @person = Person.new(response)
      @person.first_name.should == "Bob"
      @person.billing_address.should == {:address1 => "one", :address2 => "Two"}
    end
    ##
    it"should assign the responses with sub nested values to the class attribute" do
      response_with_nested_attributes = {"FirstName"=>"Bob", "LastName"=>"Newhart", "BillingAddress" => {"Address1" => "one", "Address2" => "Two", "PhoneNumber" => {"Phone" => "123456789","Ext" => "2313"}}}
      Person.convert_to_symbol(response_with_nested_attributes).should == {:first_name=>"Bob", :last_name=>"Newhart", :billing_address=>{:address1=>"one", :address2=>"Two",:phone_number=>{:phone=>"123456789", :ext=>"2313"}} }
    end

    it"should assign the responses with multi level nested values to the class attribute" do
      response_with_nested_attributes = {"FirstName"=>"Bob", "LastName"=>"Newhart", "BillingAddress" => {"Address1" => "one", "Address2" => "Two", "PhoneNumber" => {"Phone" => "123456789","Ext" => "2313", "TestMe" => [{"Id"=> "one", "Desc" =>"test"},{"Id"=> "two", "Desc" =>"test2"} ]}}}
      Person.convert_to_symbol(response_with_nested_attributes).should == {:first_name=>"Bob", :last_name=>"Newhart", :phone_number=>{:phone=>"123456789", :ext=>"2313"}, :billing_address=>{:address1=>"one", :address2=>"Two"}}
    end


  end


end



# mapper , a config file which tells what to map to where . i.e like class.attribute = service.attribute
#
#

require 'plain_old_model/base'
require 'active_service_mapper'
class Person < PlainOldModel::Base
  extend ActiveServiceMapper
  #include ActiveServiceMapper::Base
  attr_accessor :first_name, :last_name, :billing_address

end

#require 'plain_old_model/base'
#require 'active_service_mapper'
#class BillingAddress < PlainOldModel::Base
#  include ActiveServiceMapper
#  attr_accessor :phone, :ext
#end

class Service_response < ActiveServiceMapper::Base
   include ActiveServiceMapper
  def self.simple_response
    response ={
        "FirstName" => "Bob",
        "LastName" => "NewHart"
    }
    ActiveServiceMapper.convert_to_symbol(response)
  end

  #def self.convert_to_symbol(response)
  #  new_response = {}
  #  response.each do |k,v|
  #    if v.class == Hash || v.class == Array
  #      puts v.inspect
  #      puts "\n"
  #    #  convert_to_symbol(v)
  #    end
  #    new_response[k.to_s.underscore.to_sym] = v
  #  end
  #  new_response
  #end

  def self.get_complex_response
    response = {
        "FirstName" => "Bob",
        "LastName" => "Newhart",
        "OrganizationName" => "Sales & Marketing",
        "VatNumber" => "1312313123",
        "TaxOffice" => "Fake Tax Office",
        "BillingAddress" => {
            "Address1" => "605 5th Ave S",
            "Address2" => "Suite 400",
            "Address3" => "3rd bedroom down the hall",
            "City"  => "Seattle",
            "StateProvinceName" => "NA",
            "StateProvinceCode" => "WA",
            "PostalCode"   => "98104",
            "CountryCode" => " USA"
        },
        "Phone" => {
            "Number" => "(123) 456-7890",
            "Extension"=> "432"

        },
        "PaymentMethods" => [
            {
                "TypeId" => "SavedCreditCard",
                "Card" => {
                    "Type" => "VISA",
                    "LastFourDigits" => "1234"
                }
            }
        ],
        "DefaultPaymentMethod" => "SavedCreditCard"
    }
    response["DefaultPaymentMethod"] = "BillToAccount"
    response["Company"] = {
        "Name" => "Getty",
        "Id" => "123",
        "EmailAddress" => "gettyguy@gettyimages.com",
        "BillingContact" => "Fake Contact"
    }
    response['PaymentMethods'] << {
        "TypeId" => "BillToAccount",
        "IsDefault" => true,
    }
  return response

end

end