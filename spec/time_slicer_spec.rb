require File.dirname(__FILE__) + '/../lib/timeslicer'

describe Timeslicer::Slicer do
  describe 'Initializes' do    
    before(:each) do
      @test_start = Time.mktime(2010)
      @test_stop = Time.mktime(2011)-1
    end
    
    it "should accept empty initializers" do
      Timeslicer::Slicer.new.should_not == nil
    end
    
    it "should accept valid dates initializers" do
      Timeslicer::Slicer.new(@test_start, @test_stop).should_not == nil
    end
  end

  describe "slices" do
    before(:each) do
      @test_start = Time.mktime(2010)
      @test_month_stop = Time.mktime(2010, 2)
      @test_stop = Time.mktime(2011)-1

      @test_odd_start = Time.mktime(2010, 2, 5, 13, 30,  47)
      @test_odd_month_stop = Time.mktime(2010, 3, 5, 13, 30,  47)
      @test_odd_stop = Time.mktime(2011, 2, 5, 13, 30,  47)

      @test_leap_start = Time.mktime(2000, 1)
      @test_leap_stop = Time.mktime(2001, 1)-1

    end

    it "should slice an exact year into 12 months" do
      ts_reg = Timeslicer::Slicer.new(@test_start, @test_stop)
      ts_reg.slice('month').size.should == 12
    end
    
    it "should slice an irregular year into all included months (13)" do
      ts_odd = Timeslicer::Slicer.new(@test_odd_start, @test_odd_stop)
      ts_odd.slice('month').size.should == 13
    end

    it "should slice an exact year into 53 weeks" do
      ts_reg = Timeslicer::Slicer.new(@test_start, @test_stop)      
      ts_reg.slice('week').size.should == 53
    end
    
    it "should slice an irregular year into all included weeks (52)" do
      ts_odd = Timeslicer::Slicer.new(@test_odd_start, @test_odd_stop)
      ts_odd.slice('week').size.should == 53
    end

    it "should slice an exact year into 365 days" do
      ts_reg = Timeslicer::Slicer.new(@test_start, @test_stop)      
      ts_reg.slice('day').size.should == 365
    end

    it "should slice an irregular year into 366 days" do
      ts_odd = Timeslicer::Slicer.new(@test_odd_start, @test_odd_stop)
      ts_odd.slice('day').size.should == 366
    end
    
    it "should slice an leap year into 366 days" do
      ts_odd = Timeslicer::Slicer.new(@test_leap_start, @test_leap_stop)
      ts_odd.slice('day').size.should == 366
    end

    it "should slice an exact year into 8760 hours" do
      ts_reg = Timeslicer::Slicer.new(@test_start, @test_stop)      
      ts_reg.slice('hour').size.should == 8760
    end

    it "should slice an irregular year into 8761 hours" do
      ts_odd = Timeslicer::Slicer.new(@test_odd_start, @test_odd_stop)
      ts_odd.slice('hour').size.should == 8761
    end
    
    it "should slice an leap year into 8784 hours" do
      ts_odd = Timeslicer::Slicer.new(@test_leap_start, @test_leap_stop)
      ts_odd.slice('hour').size.should == 8784
    end

    it "should slice a month into 44641 minutes" do
      ts_reg = Timeslicer::Slicer.new(@test_start, @test_month_stop)      
      ts_reg.slice('minutes').size.should == 44641
    end
    

  end

  describe "timepoints" do
    before(:each) do
      @test_start = Time.mktime(2010, 2, 5, 13, 30,  47)
      @test_stop = Time.mktime(2011, 2, 5, 13, 30,  47)
      
      @ts = Timeslicer::Slicer.new(@test_start, @test_stop)
    end

    it "should accept timepoint in the initializer" do
      ts = Timeslicer::Slicer.new(@test_start, @test_stop, [Timeslicer::TimePoint.new(Time.mktime(2010, 3, 5, 5, 5), 3, {}), Timeslicer::TimePoint.new(Time.mktime(2010, 3, 7, 13, 30,  4), 3, {})])
      ts.timepoints.size.should ==2
    
    end

    it "should accept new points without data" do
      ts = Timeslicer::Slicer.new(@test_start, @test_stop, [Timeslicer::TimePoint.new(Time.mktime(2010, 3, 5, 5, 5), 3, {}), Timeslicer::TimePoint.new(Time.mktime(2010, 3, 7, 13, 30,  4), 3, {})])
      ts.add_timepoint(Time.mktime(2010, 3, 7, 13, 30,  4), 3)
      ts.timepoints.size.should ==3
    
    end

    it "should accept new points with data" do
      ts = Timeslicer::Slicer.new(@test_start, @test_stop, [Timeslicer::TimePoint.new(Time.mktime(2010, 3, 5, 5, 5), 3, {}), Timeslicer::TimePoint.new(Time.mktime(2010, 3, 7, 13, 30,  4), 3, {})])
      ts.add_timepoint(Time.mktime(2010, 3, 7, 13, 30,  4), 3, {:data => 'test'})
      ts.timepoints.size.should ==3
    
    end

  end
  
  describe "slice with points" do
    before(:each) do
      @test_start = Time.mktime(2010, 2, 5, 13, 30,  47)
      @test_stop = Time.mktime(2011, 2, 5, 13, 30,  47)
      
      @ts = Timeslicer::Slicer.new(@test_start, @test_stop)
    end

    it "should include points and data in intervals" do
      ts = Timeslicer::Slicer.new(@test_start, @test_stop, [Timeslicer::TimePoint.new(Time.mktime(2010, 3, 5, 5, 5), 3, {}), Timeslicer::TimePoint.new(Time.mktime(2010, 3, 7, 13, 30,  4), 3, {})])
      ts.add_timepoint(Time.mktime(2010, 3, 7, 13, 30,  4), 4, {:data => 'test'})
      ts.add_timepoint(Time.mktime(2011, 1, 7, 13, 30,  4), 1, {:data => 'test'})
      slices = ts.slice('year')
      slices[0].sum.should == 10
      slices[1].sum.should == 1
    end

    it "should filter based upon point data" do
      ts = Timeslicer::Slicer.new(@test_start, @test_stop, [Timeslicer::TimePoint.new(Time.mktime(2010, 3, 5, 5, 5), 3, {}), Timeslicer::TimePoint.new(Time.mktime(2010, 3, 7, 13, 30,  4), 3, {})])
      ts.add_timepoint(Time.mktime(2010, 3, 7, 13, 30,  4), 4, {:data => 'test'})
      ts.add_timepoint(Time.mktime(2011, 1, 7, 13, 30,  4), 1, {:data => 'test'})
      slices = ts.slice('year'){|point| point.data=={:data => 'test'}}
      slices[0].sum.should == 4
      slices[1].sum.should == 1
    end

  end
  
end