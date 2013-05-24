require 'rspec'
require 'soundcloud'

module Scit
  class ScitScit
    def initialize
      @sc = Soundcloud.new(YAML.load(File.read(File.expand_path('~/.scit_id'))))
    end

    def connected?
      @connected
    end

    def auth
      @connected = true
    end

    def ls()
      @sc.get('/resolve', :url => 'http://soundcloud.com/illmdx/tracks').map(&:title)
    end

    def add(file)
      @files ||= []
      @files << file
    end

    def push
      @files.each do |f|
        track = @sc.post('/tracks', :track => {
            :title => f,
            :asset_date => File.new(f)
          })
      end
    end
  end
end

describe Scit do
  let(:scit) { Scit::ScitScit.new }

  it "connects to soundcloud" do
    scit.should_not be_connected
    scit.auth
    scit.should be_connected
  end

  it "lists available sounds on soundcloud" do
    scit.auth
    scit.ls.should include('Stolen Memories')
  end

  it "posts sounds to soundcloud" do
    scit.auth
    scit.ls.should_not include('sound1.aif')
    scit.add('sound1.aif')
    scit.ls.should_not include('sound1.aif')
    scit.push
    scit.ls.should include('sound1.aif')
  end

  it "fetches sounds from soundcloud" do
    File.rm('everlasting sound') if File.file?('everlasting sound')
    scit.auth
    scit.pull
    File.should be_file('everlasting sound')
  end

  it "creates sets of sounds" do

  end

  it "edits sounds' information"

  it "shares with other people"
end
