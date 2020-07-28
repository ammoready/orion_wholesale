require "spec_helper"

describe Orion do
  it "has a version number" do
    expect(Orion::VERSION).not_to be nil
  end

  describe "::Configuration" do
    before do
      Orion.configure do |config|
        config.ftp_host      = "ftp.host.com"
        config.top_level_dir = "Test"
      end
    end

    it { expect(Orion.config.ftp_host).to eq("ftp.host.com") }
  end
end
