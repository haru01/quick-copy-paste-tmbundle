require File.dirname(__FILE__) + "/../lib/complement"

describe "choices" do
  it "引数なし のチョイス要素のHashがつくれること" do
    choices("validate_attribute")[0].should == {"insert"=>"()", 
                                                "display"=>"validate_attribute()  RSS::Element#validate_attribute", 
                                                "match"=>"validate_attribute"}
  end  

  it "引数ありのチョイスの Hash要素がつくれること" do
    choices("it_should_behave_like")[0].should == {"insert"=>"(${1:*shared_example_groups})", 
                                                    "display"=>"it_should_behave_like(*shared_example_groups)  Spec::Example::ExampleGroupMethods#it_should_behave_like", 
                                                    "match"=>"it_should_behave_like"}
  end
  
  it "&block を置き換えたチョイス Hashの要素がつくれること" do
    choices("map").select{|node| 
        node["display"].include? "Rack::Builder#map" 
    }[0].should ==  {
        "insert"=>"(${1:path}) {|${101:xxx}| ${102:} }", 
        "display"=>"map(path, &block)  Rack::Builder#map", 
        "match"=>"map"}
  end
  
  it "&proc を置き換えたチョイス Hashの要素がつくれること" do
    choices("form_for").select{|node| 
        node["display"].include? "object_name" 
    }[0].should ==  {
      "insert"=>"(${1:object_name}, ${2:*args}) {|${101:xxx}| ${102:} }", 
      "display"=>"form_for(object_name, *args, &proc)  ActionView::Helpers::FormHelper#form_for", 
      "match"=>"form_for"}
  end
end

