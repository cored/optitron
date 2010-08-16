require 'spec_helper'

describe "Optitron::Parser types" do
  context "numeric" do
    context "on args" do
      before(:each) {
        @parser = Optitron.new {
          cmd "kill" do
            arg 'pid', :type => :numeric
          end
        }
      }

      it "should parse 'kill 123'" do
        response = @parser.parse(%w(kill 123))
        response.command.should == 'kill'
        response.args.first.should == 123
        response.valid?.should be_true
      end

      it "shouldn't parse 'kill asd'" do
        response = @parser.parse(%w(kill asd))
        response.command.should == 'kill'
        response.args.first.should == 'asd'
        response.valid?.should be_false
      end
    end

    context "on opts" do
      before(:each) do
        @parser = Optitron.new do
          cmd "kill" do
            opt 'pid', :type => :numeric
          end
        end
      end

      it "should parse 'kill --pid=123'" do
        response = @parser.parse(%w(kill --pid=123))
        response.command.should == 'kill'
        response.params['pid'].should == 123
        response.valid?.should be_true
      end

      it "shouldn't parse 'kill --pid=asd'" do
        response = @parser.parse(%w(kill --pid=asd))
        response.command.should == 'kill'
        response.params['pid'].should == 'asd'
        response.valid?.should be_false
      end
    end
  end

  context "array" do
    context "on opt" do
      before(:each) {
        @parser = Optitron.new {
          cmd "kill" do
            opt 'pid', :type => :array
          end
        }
      }

      it "should parse 'kill --pid=123 234 456'" do
        response = @parser.parse(%w(kill --pid=123 234 456))
        response.command.should == 'kill'
        response.params['pid'].should == %w(123 234 456)
        response.valid?.should be_true
      end

      it "should parse 'kill -p 123 234 456'" do
        response = @parser.parse(%w(kill -p 123 234 456))
        response.command.should == 'kill'
        response.params['pid'].should == %w(123 234 456)
        response.valid?.should be_true
      end
    end
  end

  context "hash" do
    context "on opt" do
      before(:each) {
        @parser = Optitron.new {
          cmd "kill" do
            opt 'pid', :type => :hash
          end
        }
      }

      it "should parse 'kill --pid=123:234 456:890'" do
        response = @parser.parse(%w(kill -p 123:234 456:890))
        response.command.should == 'kill'
        response.params['pid'].should == {"123"=>"234", "456"=>"890"}
        response.valid?.should be_true
      end

      it "should parse 'kill -p 123:234 456:890'" do
        response = @parser.parse(%w(kill -p 123:234 456:890))
        response.command.should == 'kill'
        response.params['pid'].should == {"123"=>"234", "456"=>"890"}
        response.valid?.should be_true
      end
    end
  end
end