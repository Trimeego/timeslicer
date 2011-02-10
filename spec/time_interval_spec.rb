require File.dirname(__FILE__) + '/../time_slicer'

describe TimeInterval do
  before(:each) do
    @test_time = Time.mktime(2011, 2, 5, 13, 30,  47)
    [$stdin, $stdout, $stderr].each{|io| io.stub(:reopen)}
  end
    
  it "should not accept empty initializers" do
    begin
      TimeInterval.new().nil?
    rescue
      true
    end
  end
  
  it "should accept valid initializers" do
    TimeInterval.new(@test_time, 's').should_not nil
  end

  it "should bracket correctly on minute" do
    target_start = Time.mktime(2011, 2, 5, 13, 30)
    target_end = Time.mktime(2011, 2, 5, 13, 31)-1
    ti = TimeInterval.new(@test_time, 'minute')
    ti.start_time.should == target_start
    ti.end_time.should == target_end
  end
  it "should bracket correctly on hour" do
    target_start = Time.mktime(2011, 2, 5, 13)
    target_end = Time.mktime(2011, 2, 5, 14)-1
    ti = TimeInterval.new(@test_time, 'hour')
    ti.start_time.should == target_start
    ti.end_time.should == target_end
  end
  it "should bracket correctly on day" do
    target_start = Time.mktime(2011, 2, 5)
    target_end = Time.mktime(2011, 2, 6)-1
    ti = TimeInterval.new(@test_time, 'day')
    ti.start_time.should == target_start
    ti.end_time.should == target_end
  end
  it "should bracket correctly on week" do
    target_start = Time.mktime(2011, 1, 30)
    target_end = Time.mktime(2011, 2, 6)-1
    ti = TimeInterval.new(@test_time, 'week')
    ti.start_time.should == target_start
    ti.end_time.should == target_end
  end
  it "should bracket correctly on month" do
    target_start = Time.mktime(2011, 2, 1)
    target_end = Time.mktime(2011, 3, 1)-1
    ti = TimeInterval.new(@test_time, 'month')
    ti.start_time.should == target_start
    ti.end_time.should == target_end
  end
  it "should bracket correctly on year" do
    target_start = Time.mktime(2011)
    target_end = Time.mktime(2012)-1
    ti = TimeInterval.new(@test_time, 'year')
    ti.start_time.should == target_start
    ti.end_time.should == target_end
  end

    
end