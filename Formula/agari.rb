class Agari < Formula
  desc "A Riichi Mahjong hand calculator and scoring engine"
  homepage "https://github.com/rysb-dev/agari"
  version "0.20.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rysb-dev/agari/releases/download/v0.20.0/agari-aarch64-apple-darwin.tar.xz"
      sha256 "51ff48ce04c7e11e57120f8840dd7639299dfbabf61d188d17dc16daed67f835"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rysb-dev/agari/releases/download/v0.20.0/agari-x86_64-apple-darwin.tar.xz"
      sha256 "783876e8899e253bea3cc2d22ffb194130ff95cdcb57fed0cc0ce630bb516984"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rysb-dev/agari/releases/download/v0.20.0/agari-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "98eca780c29c0a29e5f03f680efb8bb3e3b37401956ac0faa7828d52d246fb07"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rysb-dev/agari/releases/download/v0.20.0/agari-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f088a7865416123b2d8ff9cbabf4e19ca4fe095cb6dd468d292eafd9a724e76e"
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
