class Agari < Formula
  desc "A Riichi Mahjong hand calculator and scoring engine"
  homepage "https://github.com/rysb-dev/agari"
  version "0.19.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rysb-dev/agari/releases/download/v0.19.1/agari-aarch64-apple-darwin.tar.xz"
      sha256 "3032dda884ae32103e9c34c70f60ffaeb4f13db666daa1616b28f710ff65df96"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rysb-dev/agari/releases/download/v0.19.1/agari-x86_64-apple-darwin.tar.xz"
      sha256 "73f5a6b6851d2316eff99fd5fa4c0a33c73b14543f26c20fa307555d7b7e602f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rysb-dev/agari/releases/download/v0.19.1/agari-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cdbc9d20bfe30711ba4afb9f6f51edc3bf401b7d4530ba9bc2124201f0692a33"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rysb-dev/agari/releases/download/v0.19.1/agari-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9944fe53fb2b3e414fa6501c6fab99ce209be8229747ca40a27aa8079aef0ae8"
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
