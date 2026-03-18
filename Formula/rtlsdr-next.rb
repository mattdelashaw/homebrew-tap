class RtlsdrNext < Formula
  desc "A high-performance, async-native Rust driver for RTL2832U-based SDRs, with first-class support for the RTL-SDR Blog V4."
  homepage "https://github.com/mattdelashaw/rtlsdr-next"
  version "1.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.0.1/rtlsdr-next-aarch64-apple-darwin.tar.xz"
      sha256 "e170183cab7146620038e1fa49152a1319d375b4ffce96edd6b2423c67004281"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.0.1/rtlsdr-next-x86_64-apple-darwin.tar.xz"
      sha256 "5618f8ada1ca65651c00fd1e2d76858ac20b74020fc34bf9ccdd466db4154db2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.0.1/rtlsdr-next-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "12bdfa62a35765ac6816dcd41f3774f00bd36f0efa8644b071337b7f969091dd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.0.1/rtlsdr-next-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "051cd624765913443bba2d2dc6b978196a48bf9587433c02401390f12feee100"
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
