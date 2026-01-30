class Agari < Formula
  desc "A Riichi Mahjong hand calculator and scoring engine"
  homepage "https://github.com/ryblogs/agari"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ryblogs/agari/releases/download/v0.10.0/agari-aarch64-apple-darwin.tar.xz"
      sha256 "f5e6dd3e7243523756a2b47806eabccc62439342f3243b63f7adb462025efb0f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ryblogs/agari/releases/download/v0.10.0/agari-x86_64-apple-darwin.tar.xz"
      sha256 "b3c77c186ed84b09e1b80369887be32ea521b36465bb47228639a4f58d6b2849"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ryblogs/agari/releases/download/v0.10.0/agari-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1ea5483be878b39799daf82632447a2ccdb008bbe198e9edb10faa85bd66c338"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ryblogs/agari/releases/download/v0.10.0/agari-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "590a56e2f05edb1ed1638908130d95eb87c97589f53b36e984ce3a4b376f9aee"
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
