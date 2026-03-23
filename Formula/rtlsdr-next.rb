class RtlsdrNext < Formula
  desc "A high-performance, async-native Rust driver for RTL2832U-based SDRs, with first-class support for the RTL-SDR Blog V4."
  homepage "https://github.com/mattdelashaw/rtlsdr-next"
  version "1.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.0.3/rtlsdr-next-aarch64-apple-darwin.tar.xz"
      sha256 "f5b260d53861114020d9797fcc11b11c62f3246645f722ab7ca979d413969a2f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.0.3/rtlsdr-next-x86_64-apple-darwin.tar.xz"
      sha256 "1ca16b50e8a99ca7b030b078e20305d0164a8e96c2805b3a865aa49a8cfcbaee"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.0.3/rtlsdr-next-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f0faef6f91e1ec4f5902d4a9fcfabfd757f228dc8a06441fb19c132157e977d6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.0.3/rtlsdr-next-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f60a62c43c14e81d699b3122b1b5f297727e3ca508451b18591d2b7d6230cc83"
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
    bin.install "rtl_tcp", "websdr" if OS.mac? && Hardware::CPU.arm?
    bin.install "rtl_tcp", "websdr" if OS.mac? && Hardware::CPU.intel?
    bin.install "rtl_tcp", "websdr" if OS.linux? && Hardware::CPU.arm?
    bin.install "rtl_tcp", "websdr" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
