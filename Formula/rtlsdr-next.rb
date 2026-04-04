class RtlsdrNext < Formula
  desc "A high-performance, async-native Rust driver for RTL2832U-based SDRs, with first-class support for the RTL-SDR Blog V4."
  homepage "https://github.com/mattdelashaw/rtlsdr-next"
  version "1.0.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.0.5/rtlsdr-next-aarch64-apple-darwin.tar.xz"
      sha256 "7ef35d70eaa1670cc35d640f567a119be4defd5b0e72536e5fafa78dc2783e61"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.0.5/rtlsdr-next-x86_64-apple-darwin.tar.xz"
      sha256 "477c8f067ae3f2365fe1858cab3c7240a90b1943df44b6b39b7e031040596870"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.0.5/rtlsdr-next-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5d1be55083317557ab4a62b7b59d1f258703209190eb65d0bdccb7cb06056e16"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mattdelashaw/rtlsdr-next/releases/download/v1.0.5/rtlsdr-next-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bdaeb45aecc74a26e754095f6b404f50453ed8d78cde733e9eb894c00b27414f"
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
