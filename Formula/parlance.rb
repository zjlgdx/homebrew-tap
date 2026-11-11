class Parlance < Formula
  desc "Rewrite prompts and explain coding agents' output"
  homepage "https://github.com/zjlgdx/parlance"
  url "https://github.com/zjlgdx/parlance/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "262faf5d43de178967a0b4bec1644f493b64983a35f6403f48c483cab7cd7bcd"
  license "GPL-3.0-or-later"

  depends_on macos: :sequoia

  deny_network_access!

  def fetch
    # Homebrew runs fetch with network access before the offline install phase.
    # Resolve Package.resolved into this buildpath; SwiftPM's sandbox cannot nest here.
    system "swift", "package", "resolve", "--disable-sandbox"
  end

  def install
    system "swift", "build", "--product", "pl", "--disable-sandbox", "--force-resolved-versions", *std_swift_args
    bin.install ".build/release/pl"
    generate_completions_from_executable(bin/"pl", "--generate-completion-script")
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/pl --version").strip
  end
end
