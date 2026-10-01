class Macmonitor < Formula
  desc "Menu bar monitor for CPU, memory, and CPU temperature"
  homepage "https://github.com/krysko/MacMonitor"
  url "https://github.com/krysko/MacMonitor/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "00e13945edeb83c7736de25848d0e993c8e7688fa0524f9986ba3509d80bafea"
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
