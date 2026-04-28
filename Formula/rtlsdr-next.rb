class RtlsdrNext < Formula
  desc "A high-performance, async-native Rust driver for RTL2832U-based SDRs, with first-class support for the RTL-SDR Blog V4."
  homepage "https://github.com/mattdelashaw/rtlsdr-next"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.1.0/rtlsdr-next-aarch64-apple-darwin.tar.xz"
      sha256 "8af7d88b05c0ce56e1e40859b1c124ed04fc7f6e994a001f1b2177d3f06f6fd2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.1.0/rtlsdr-next-x86_64-apple-darwin.tar.xz"
      sha256 "87018b65a384bd65397360c02153a204e914c7cd626ee91b2b8d6db997f6119d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.1.0/rtlsdr-next-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "aa3d608f654d11ddd61b9407a60dd34fa17b456e4917d061ee94fa30735c1459"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.1.0/rtlsdr-next-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b074e49bae24fcdb0a21ae41a246ddcf89a01032db3368899add89f676b0c233"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":        {},
    "aarch64-unknown-linux-gnu":   {},
    "arm-unknown-linux-gnueabihf": {},
    "x86_64-apple-darwin":         {},
    "x86_64-pc-windows-gnu":       {},
    "x86_64-unknown-linux-gnu":    {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "daemon", "rtl_tcp", "websdr" if OS.mac? && Hardware::CPU.arm?
    bin.install "daemon", "rtl_tcp", "websdr" if OS.mac? && Hardware::CPU.intel?
    bin.install "daemon", "rtl_tcp", "websdr" if OS.linux? && Hardware::CPU.arm?
    bin.install "daemon", "rtl_tcp", "websdr" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
