# Builds Lisdex from source on the user's Mac, so the app is never quarantined and runs without
# an Apple Developer ID (ADR 0008 in pedrol2b/lisdex).
class Lisdex < Formula
  desc "Menu bar app that keeps your Mac awake, for a while or on a schedule"
  homepage "https://github.com/pedrol2b/lisdex"
  url "https://github.com/pedrol2b/lisdex/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "9e3a738ca330af2090cf25984dee47ed3d9c5cba00fb00c0889edb2b1e4f05b6"
  license "MIT"
  head "https://github.com/pedrol2b/lisdex.git", branch: "main"

  depends_on macos: :sonoma

  def install
    # Swift 6 toolchain from the Xcode Command Line Tools (or Xcode).
    ENV["SWIFT_BUILD_FLAGS"] = "--disable-sandbox"
    system "./scripts/build-app.sh"
    prefix.install "build/Lisdex.app"
  end

  def caveats
    <<~EOS
      Put Lisdex in ~/Applications so Spotlight, Launchpad and Login Items find it:
        mkdir -p ~/Applications && ln -sf #{opt_prefix}/Lisdex.app ~/Applications/Lisdex.app
      Then open it:
        open ~/Applications/Lisdex.app
    EOS
  end

  test do
    app = prefix/"Lisdex.app"
    assert_predicate app/"Contents/MacOS/Lisdex", :executable?
    assert_path_exists app/"Contents/Resources/pill-active.pdf"
    system "codesign", "--verify", app
  end
end
