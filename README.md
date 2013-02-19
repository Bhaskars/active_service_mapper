# ActiveServiceMapper

This gem will convert the json responses received from the web services to ruby hash.

## Installation

Add this line to your application's Gemfile:

    gem 'active_service_mapper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_service_mapper

## Usage
      #service response in jso format 
      
      1. response = {"FirstName"=>"Bob", "LastName"=>"Newhart"}
      
      # convert the json response to a hash with symbols.
      
      2. response = Person.convert_response(response)

      3. puts response #{:first_name=>"Bob", :last_name=>"Newhart"}
   
        
     4. we can use plain_old_model gem and the person calss can be 
    
    class Person < PlainOldModel::Base
      attr_accessor :first_name, :last_name
    end

     5. @person = Person.new(response)
     
## TODO
    # add complex mapping, i.e when the service response keys are different from the class attribute names.
    # 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
