require 'rspec'
require 'replaceable_string'
describe String do
  context "Replaceable" do
    let(:message) {
"Congratulations %%NAME%%;

You have won a coupon: %%COUPON_CODE%%

Wuaki.tv team"
    }

    let(:replaced_message) {
"Congratulations hello;

You have won a coupon: 1234

Wuaki.tv team"
    }

    it "parses simple hash values" do
      message.parse_variables(:name => 'hello', :coupon_code => '1234', :not_present => 'lalal').should == {:name => 'hello', :coupon_code => '1234'}
    end

    it "should replace values" do
      locals = {:name => 'hello', :coupon_code => '1234'}
      message.replace_values!(locals)
      message.should == replaced_message
    end

    context "message with parameters contanining lambdas" do
      it "parses values within a lambda without parameters" do
        message.parse_variables(:name => 'hello', :coupon_code => lambda{ '1234' }).should == {:name => 'hello', :coupon_code => '1234'}
      end

      it "parses values within a lambda with parameters" do
        message.parse_variables({:name => 'hello', :coupon_code => lambda{|coupon| coupon }}, '1234').should == {:name => 'hello', :coupon_code => '1234'}
      end

      it "parses values within a lambda with parameters which is nil" do
        message.parse_variables({:name => 'hello', :coupon_code => lambda{|coupon| coupon }}, nil).should == {:name => 'hello', :coupon_code => ''}
      end
    end
  end
end