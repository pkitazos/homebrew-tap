class GitJmp < Formula
  desc "A fast, interactive Git branch switcher with fuzzy search and recency sorting"
  homepage "https://github.com/pkitazos/git-jmp"
  version "0.2.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/pkitazos/git-jmp/releases/download/v0.2.0/git-jmp-aarch64-apple-darwin.tar.xz"
    sha256 "711b435733225a0d6fff8dafce55b7b8890f017a768171e433db9ee0a2bfe924"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pkitazos/git-jmp/releases/download/v0.2.0/git-jmp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fa0a3cec6ddd7c00b6b4b400fb898620ea7ffb93d3760be087b745cef0c8d990"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pkitazos/git-jmp/releases/download/v0.2.0/git-jmp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fd59818e34117e8845bc5253b36124cc4c3cfb6187c38714d96bce60ccb3be75"
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
