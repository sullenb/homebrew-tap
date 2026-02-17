class Agari < Formula
  desc "A Riichi Mahjong hand calculator and scoring engine"
  homepage "https://github.com/rysb-dev/agari"
  version "0.18.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rysb-dev/agari/releases/download/v0.18.0/agari-aarch64-apple-darwin.tar.xz"
      sha256 "09fb1d21150d8bc47e5209e31908a472abac619f19cc0303d417cd9252d7ce86"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rysb-dev/agari/releases/download/v0.18.0/agari-x86_64-apple-darwin.tar.xz"
      sha256 "7e70483a75570a5d7c5fa15e975cffd8a5e16084b230a37d72272bbc77df9a74"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rysb-dev/agari/releases/download/v0.18.0/agari-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7447034a8c42147638e4cb367dc020cddd17f4ca673333b5d851b464f53cf8bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rysb-dev/agari/releases/download/v0.18.0/agari-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "08fde97de4ad1f7c8b686d3ff577ca13ccfab5743e86cc9d6b8fca0994449124"
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
