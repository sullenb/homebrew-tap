class Agari < Formula
  desc "A Riichi Mahjong hand calculator and scoring engine"
  homepage "https://github.com/ryblogs/agari"
  version "0.6.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ryblogs/agari/releases/download/v0.6.2/agari-aarch64-apple-darwin.tar.xz"
      sha256 "476590de1970042891a07874173851fd7803638cdf10bebe18dfbd6edd7ea628"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ryblogs/agari/releases/download/v0.6.2/agari-x86_64-apple-darwin.tar.xz"
      sha256 "fbe98dc5b9c8fe2cdf4e9d6f7171b8536453a0a0f76284b8cd9e9c1b0215243a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ryblogs/agari/releases/download/v0.6.2/agari-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "db8de1288407af625e2b14a4d244a3fbfcaaf2fe70ccb2559dcc973f76692c7a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ryblogs/agari/releases/download/v0.6.2/agari-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "52accd6a09ba8bf540d82816b997ed0cbcf1a72e056519d03a731530382afa30"
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
