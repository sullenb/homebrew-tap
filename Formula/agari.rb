class Agari < Formula
  desc "A Riichi Mahjong hand calculator and scoring engine"
  homepage "https://github.com/rysb-dev/agari"
  version "0.21.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rysb-dev/agari/releases/download/v0.21.0/agari-aarch64-apple-darwin.tar.xz"
      sha256 "d5c09618bd5e2c83e0deea2e5877debe6fcdcb292b57963ac674da4bba9d5bb7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rysb-dev/agari/releases/download/v0.21.0/agari-x86_64-apple-darwin.tar.xz"
      sha256 "c30471631db05053fb3c525cbed4131e2ad523f544c6d2bce22be803ec9d223c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rysb-dev/agari/releases/download/v0.21.0/agari-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e2c3d4a5df8029300948ad31be2d86a550ba7e05d7c9bdf11b8d0acc2f3eaeca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rysb-dev/agari/releases/download/v0.21.0/agari-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e245fbc30df2c467fdea5028bca0a538aaa7bf3c9a88b31b03ecd3b516325e0b"
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
