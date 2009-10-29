module ModelMacros
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    # put all of your custom macros in here. See http://railscasts.com/episodes/157-rspec-matchers-macros
    # for more info
    def it_should_validate_presence_for_attributes(instance, *attributes)
      attributes.each do |attribute|
        it "should validate for the presence of #{attribute}" do
          instance.should validate_presence_of attribute
        end
      end
    end
  end
end