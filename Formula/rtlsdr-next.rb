class RtlsdrNext < Formula
  desc "A high-performance, async-native Rust driver for RTL2832U-based SDRs, with first-class support for the RTL-SDR Blog V4."
  homepage "https://github.com/mattdelashaw/rtlsdr-next"
  version "1.0.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.0.4/rtlsdr-next-aarch64-apple-darwin.tar.xz"
      sha256 "e101f5120d0453a8569adc7e4465eb6f1b23c1cd577a2407e738128f7e118206"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.0.4/rtlsdr-next-x86_64-apple-darwin.tar.xz"
      sha256 "04718fd67f9b1183d6d58bf1bea050b0d01e4b72ee4449dbdb576f9626c9ea0c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.0.4/rtlsdr-next-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c411ca1d7ce57a885c21df6001fd893117063682dc222ea25a6923cc33abf2df"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.0.4/rtlsdr-next-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "368b338bb6f4a7eefe011a55eb186a7e9a444fd492f573a0f0fa8c9ee88b41c0"
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
