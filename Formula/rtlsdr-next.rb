class RtlsdrNext < Formula
  desc "A high-performance, async-native Rust driver for RTL2832U-based SDRs, with first-class support for the RTL-SDR Blog V4."
  homepage "https://github.com/mattdelashaw/rtlsdr-next"
  version "1.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.0.1/rtlsdr-next-aarch64-apple-darwin.tar.xz"
      sha256 "a37a2b35607cf17135d9b7456ef58eea239bcb1c0e43d7c902f49be31306be37"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.0.1/rtlsdr-next-x86_64-apple-darwin.tar.xz"
      sha256 "0d9e15b395fa0624b8925a4b611630cf47c8135ffdd3d3444d8710a823df22e2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.0.1/rtlsdr-next-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1c00942eb7537be9f2ccf8d0432d3e02b74a5fe707b54d6f873b12fb495a630b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.0.1/rtlsdr-next-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "068fc43acfd7041073a195188b5ee9f5254edb251104b9bd4c80bb32e2012132"
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
    bin.install "rtl_tcp" if OS.mac? && Hardware::CPU.arm?
    bin.install "rtl_tcp" if OS.mac? && Hardware::CPU.intel?
    bin.install "rtl_tcp" if OS.linux? && Hardware::CPU.arm?
    bin.install "rtl_tcp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
