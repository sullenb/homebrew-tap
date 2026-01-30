class Agari < Formula
  desc "A Riichi Mahjong hand calculator and scoring engine"
  homepage "https://github.com/ryblogs/agari"
  version "0.13.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ryblogs/agari/releases/download/v0.13.0/agari-aarch64-apple-darwin.tar.xz"
      sha256 "3c2c74bfc83f90716364a6880e63af6f501e7951f52ad947f08c0081ac757c33"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ryblogs/agari/releases/download/v0.13.0/agari-x86_64-apple-darwin.tar.xz"
      sha256 "b6516060cba203f5de49bda793d373ede33c9a93a1ddd5dedfe998af0fbe6aac"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ryblogs/agari/releases/download/v0.13.0/agari-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "065822189d5485b941c5f5c08e66fd4dc479a5f8c2018efe0835e5830d99cf32"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ryblogs/agari/releases/download/v0.13.0/agari-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f7bd963d9fc90879453492fd81004c906e27a413a18e4d9ac69e7cdf7da8dab8"
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
