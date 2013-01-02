# encoding: UTF-8
require 'spec_helper'
require 'fakeweb'

require 'agcaldav'

describe AgCalDAV::Client do

  before(:each) do
    @c = AgCalDAV::Client.new(:uri => "http://localhost:5232/user/calendar", :user => "user" , :password => "")
  end

  it "check Class of new calendar" do
    @c.class.to_s.should == "AgCalDAV::Client"
  end

  it "create one event" do
    uid = "5385e2d0-3707-0130-9e49-0019996389cc"
    FakeWeb.register_uri(:any, %r{http://user@localhost:5232/user/calendar/(.*).ics}, :body => "")
    r = @c.create_event(:start => "2012-12-29 10:00", :end => "2012-12-30 12:00", :title => "12345", :description => "12345 12345")
    r.should_not be_nil
  end

  it "failed create one event DuplicateError" do
    uid = "5385e2d0-3707-0130-9e49-0019996389cc"
    FakeWeb.register_uri(:any, %r{http://user@localhost:5232/user/calendar/(.*).ics}, :body => "BEGIN:VCALENDAR\nPRODID:.....")
    lambda{@c.create_event(:start => "2012-12-29 10:00", :end => "2012-12-30 12:00", :title => "12345", :description => "12345 12345")}.should raise_error(AgCalDAV::DuplicateError) 
  end
 
  it "find one event" do
    uid = "5385e2d0-3707-0130-9e49-001999638982"
    FakeWeb.register_uri(:get, "http://user@localhost:5232/user/calendar/#{uid}.ics", :body => "BEGIN:VCALENDAR\nPRODID:-//Radicale//NONSGML Radicale Server//EN\nVERSION:2.0\nBEGIN:VEVENT\nDESCRIPTION:12345 12ss345\nDTEND:20130101T110000\nDTSTAMP:20130101T161708\nDTSTART:20130101T100000\nSEQUENCE:0\nSUMMARY:123ss45\nUID:#{uid}\nX-RADICALE-NAME:#{uid}.ics\nEND:VEVENT\nEND:VCALENDAR")
     r = @c.find_event(uid)
     r.should_not be_nil
     r.uid.should == uid
  end


  #it "find 2 events" do
  #  FakeWeb.register_uri(:get, "http://user@10.100.12.111:5232/user/calendar/5385e2d0-3707-0130-9e49-001999638982.ics", :body => "BEGIN:VCALENDAR\nPRODID:-//Radicale//NONSGML Radicale Server//EN\nVERSION:2.0\nBEGIN:VEVENT\nDESCRIPTION:12345 12ss345\nDTEND:20130101T110000\nDTSTAMP:20130101T161708\nDTSTART:20130101T100000\nSEQUENCE:0\nSUMMARY:123ss45\nUID:5385e2d0-3707-0130-9e49-001999638982\nX-RADICALE-NAME:5385e2d0-3707-0130-9e49-001999638982.ics\nEND:VEVENT\nEND:VCALENDAR")
  #  r = @c.find_events("5385e2d0-3707-0130-9e49-001999638982")
  #  r.should_not be_nil
    #r.length.should == 1
  #end
end


