class Macmonitor < Formula
  desc "Menu bar monitor for CPU, memory, and CPU temperature"
  homepage "https://github.com/krysko/MacMonitor"
  url "https://github.com/krysko/MacMonitor/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "bd22aaa02ab5883e4c24a0b7906ba1b606015816ed3188ce1d9d3f55d11db006"
  depends_on macos: :sonoma

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"

    app = buildpath/"MacMonitor.app"
    (app/"Contents/MacOS").mkpath
    cp ".build/release/MacMonitor", app/"Contents/MacOS/MacMonitor"
    cp "Resources/Info.plist", app/"Contents/Info.plist"
    chmod 0755, app/"Contents/MacOS/MacMonitor"
    system "codesign", "--force", "--sign", "-", app
    prefix.install app

    (bin/"macmonitor").write <<~SH
      #!/bin/bash
      exec open "#{opt_prefix}/MacMonitor.app"
    SH
  end

  test do
    assert_path_exists opt_prefix/"MacMonitor.app/Contents/MacOS/MacMonitor"
  end
end
