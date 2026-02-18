class Agari < Formula
  desc "A Riichi Mahjong hand calculator and scoring engine"
  homepage "https://github.com/rysb-dev/agari"
  version "0.19.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rysb-dev/agari/releases/download/v0.19.0/agari-aarch64-apple-darwin.tar.xz"
      sha256 "d6485e7a496f68127633f4146d525c90dd173b50e25eed26d502431405acd9f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rysb-dev/agari/releases/download/v0.19.0/agari-x86_64-apple-darwin.tar.xz"
      sha256 "5f29d5e220fcc127a4f53f6294061b3cdb6913a8e58bedda32baf6c109936899"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rysb-dev/agari/releases/download/v0.19.0/agari-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2c7daeb88ad945e1cef3bc6414873f4f404eeeb633f74ed893356c06c8d425a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rysb-dev/agari/releases/download/v0.19.0/agari-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "06f40bc293b7ab1dcbb911f0eed48711e3d0fcebc8b85435766316fd852cf7e8"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "agari" if OS.mac? && Hardware::CPU.arm?
    bin.install "agari" if OS.mac? && Hardware::CPU.intel?
    bin.install "agari" if OS.linux? && Hardware::CPU.arm?
    bin.install "agari" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
