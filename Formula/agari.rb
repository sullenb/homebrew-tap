class Agari < Formula
  desc "A Riichi Mahjong hand calculator and scoring engine"
  homepage "https://github.com/ryblogs/agari"
  version "0.6.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ryblogs/agari/releases/download/v0.6.2/agari-aarch64-apple-darwin.tar.xz"
      sha256 "0d5ff44ecf78aeff46a80bd299ec1511666b82dc6901ebcc0e33ce33f2f41120"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ryblogs/agari/releases/download/v0.6.2/agari-x86_64-apple-darwin.tar.xz"
      sha256 "912b2ff67df384c9095bd38238c640796375c80fc69fcd756bfb6fe6a8b79af6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ryblogs/agari/releases/download/v0.6.2/agari-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3bd015c7f37914b2dad5cedcf832c5aa2b581dae3095a5aa4fc5714f16ba9935"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ryblogs/agari/releases/download/v0.6.2/agari-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "640949718ef30aa5a6097a0a42b47bea5c859c00a1479285aa90b9caa3fa4b1f"
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
