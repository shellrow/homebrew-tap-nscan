class Nscan < Formula
  desc "Cross-platform network scan tool for host and service discovery"
  homepage "https://github.com/shellrow/nscan"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shellrow/nscan/releases/download/v1.2.0/nscan-aarch64-apple-darwin.tar.xz"
      sha256 "7f356291b823b05389a7fb11595cef40057ac9017a33cbf757b026d9deef4446"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shellrow/nscan/releases/download/v1.2.0/nscan-x86_64-apple-darwin.tar.xz"
      sha256 "59b9db473f3787f42270e6d5486f9f033a78e9da448f15464eb663d832f8acbf"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/shellrow/nscan/releases/download/v1.2.0/nscan-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a5137e39722b9d4a37d6b4257bfde3d648433cbe2d1303f83fcfbfe3d89314b0"
    end
  end
  license "MIT"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-unknown-linux-gnu": {}}

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "nscan"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "nscan"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "nscan"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
