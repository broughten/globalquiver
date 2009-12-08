require File.dirname(__FILE__) + '/../spec_helper'

describe Image do
  describe "associations" do
    it "should belong to owner" do
      image = Image.make()
      user = User.make()
      image.owner = user
    end
    
    it "should have an attached file called data" do
      # check the attributes/db fields
      image = Image.make()
      image.should respond_to(:data_content_type)
      image.should respond_to(:data_file_name)
      image.should respond_to(:data_file_size)
      # test to make sure the data method it there.
      image.should respond_to(:data)
    end
  end
  
  describe "validations" do
    it "should validate that the data file content type is jpeg or png" 
    
    it "should validate that the data file size is less than 600K" 
  end
end