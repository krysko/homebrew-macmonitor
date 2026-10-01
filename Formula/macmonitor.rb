class Macmonitor < Formula
  desc "Menu bar monitor for CPU, memory, and CPU temperature"
  homepage "https://github.com/krysko/MacMonitor"
  url "https://github.com/krysko/MacMonitor/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "81b98ea47d1a603729d141c34ba7c72d5373eeca50128191f6f32f8d1e50241f"
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
