class GitJmp < Formula
  desc "A fast, interactive Git branch switcher with fuzzy search and recency sorting"
  homepage "https://github.com/pkitazos/git-jmp"
  version "0.2.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/pkitazos/git-jmp/releases/download/v0.2.1/git-jmp-aarch64-apple-darwin.tar.xz"
    sha256 "a6709327d521f83c0f62d4503cc3e56467074031d704bd211b703e5700d19425"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pkitazos/git-jmp/releases/download/v0.2.1/git-jmp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e97774dacd029759ea5caa18cf0f7ef313a56758d1470c58b4447c6eab5e6de0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pkitazos/git-jmp/releases/download/v0.2.1/git-jmp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e6014df86a1c2c5eae8186e03315b874685f023f94d98194025c65c9a49c9c4d"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
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
    bin.install "git-jmp" if OS.mac? && Hardware::CPU.arm?
    bin.install "git-jmp" if OS.linux? && Hardware::CPU.arm?
    bin.install "git-jmp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
