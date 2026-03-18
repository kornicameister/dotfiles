class AwsSessionManager < Formula
  desc "AWS Session Manager Plugin for the AWS CLI"
  homepage "https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html"
  version "latest"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac_arm64/sessionmanager-bundle.zip"
      sha256 "9c469a186b117747ddb5b9fd8ddccc3fa71f9a55e1f2188b9291d2b237dbe5e7"
    else
      url "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip"
      sha256 "7ed5ecbbe5b84515325e11a886d5b65a6fac41b0d074758de8bad2159302213c"
    end
  end

  def install
    bin.install "bin/session-manager-plugin"
  end

  test do
    system bin/"session-manager-plugin", "--version"
  end
end
