class Agari < Formula
  desc "A Riichi Mahjong hand calculator and scoring engine"
  homepage "https://github.com/sullenb/agari"
  version "0.17.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sullenb/agari/releases/download/v0.17.0/agari-aarch64-apple-darwin.tar.xz"
      sha256 "8dd3da95f29f13c293d025f8b6b8113b87fd33c161d4d3148e40a5db5aeb045b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sullenb/agari/releases/download/v0.17.0/agari-x86_64-apple-darwin.tar.xz"
      sha256 "f0dcee9f9c477fdd002cab9273d08697068b8279bc51c7a00b6965fcd0e2a1a2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sullenb/agari/releases/download/v0.17.0/agari-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b8169856fca2f3469ca4960ba2efedaeb64cf67aeafa1ae882c7a5aa47785f41"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sullenb/agari/releases/download/v0.17.0/agari-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0bbfc0ea25c301d6f07a5c045886941d3948135b66a21291fd60d433b53cfb69"
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
