class RtlsdrNext < Formula
  desc "A high-performance, async-native Rust driver for RTL2832U-based SDRs, with first-class support for the RTL-SDR Blog V4."
  homepage "https://github.com/mattdelashaw/rtlsdr-next"
  version "1.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.0.2/rtlsdr-next-aarch64-apple-darwin.tar.xz"
      sha256 "69bb5bb46a61cdc5f2e615adfbcc54aee46214e50ab25ac278bd8ba7aac12825"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.0.2/rtlsdr-next-x86_64-apple-darwin.tar.xz"
      sha256 "69281f51ab272b55edf1079df3519ed0e0507c9df12262e8f218cb49ad1b89f0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.0.2/rtlsdr-next-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b73866de25550ca16422e50fe26448eff641465067514e8dec24e71e7d0795d6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.0.2/rtlsdr-next-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e3f749758384c1b3b37ee284c90a3cf637cb1aca2f68e29fe348a862e78001aa"
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
