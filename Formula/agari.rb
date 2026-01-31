class Agari < Formula
  desc "A Riichi Mahjong hand calculator and scoring engine"
  homepage "https://github.com/ryblogs/agari"
  version "0.13.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ryblogs/agari/releases/download/v0.13.1/agari-aarch64-apple-darwin.tar.xz"
      sha256 "3949ef17abc64c05876954b8d3b5344ef71c953bb78d1b416413f9b30d70a6b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ryblogs/agari/releases/download/v0.13.1/agari-x86_64-apple-darwin.tar.xz"
      sha256 "24d33e9e938036846abdc0e179773a12910cbe5e631857ef9a4f248b5baf09de"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ryblogs/agari/releases/download/v0.13.1/agari-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b67b0b1978b1a86a64addf280404565564b23735078ecc3e1db5c808aad02a6e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ryblogs/agari/releases/download/v0.13.1/agari-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "78a387f603f522a40cada7b86fccfda48357373a76e8d189366d198eaa6980b5"
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
