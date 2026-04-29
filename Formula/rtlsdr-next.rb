class RtlsdrNext < Formula
  desc "A high-performance, async-native Rust driver for RTL2832U-based SDRs, with first-class support for the RTL-SDR Blog V4."
  homepage "https://github.com/mattdelashaw/rtlsdr-next"
  version "1.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.1.1/rtlsdr-next-aarch64-apple-darwin.tar.xz"
      sha256 "46ef7837c4415db1e1f7e23ca3a4f8bc31fc23f7a93b60ecd1126cff4470d25f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.1.1/rtlsdr-next-x86_64-apple-darwin.tar.xz"
      sha256 "478df29df2a48df9519f9ed11f4e7d0224080ccab3a7a0d07f956be06e57ec6e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.1.1/rtlsdr-next-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "637f7a47c399676f3b26a5d42717baf2dfd98685ce8643f9a7199d4f4f20dea0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.1.1/rtlsdr-next-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8baaa79353186e95fcf3416b8331499fc62f9d8f82569a2128bb08eb0da4e43f"
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
    bin.install "rtl_tcp", "rtlsdr-daemon", "websdr" if OS.mac? && Hardware::CPU.arm?
    bin.install "rtl_tcp", "rtlsdr-daemon", "websdr" if OS.mac? && Hardware::CPU.intel?
    bin.install "rtl_tcp", "rtlsdr-daemon", "websdr" if OS.linux? && Hardware::CPU.arm?
    bin.install "rtl_tcp", "rtlsdr-daemon", "websdr" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
