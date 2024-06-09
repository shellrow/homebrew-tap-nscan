class Nscan < Formula
  desc "Cross-platform network scan tool for host and service discovery"
  homepage "https://github.com/shellrow/nscan"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shellrow/nscan/releases/download/v1.1.0/nscan-aarch64-apple-darwin.tar.xz"
      sha256 "7ba700b240164a8c2850b1bcc512b491f0c3cc8fc614d1dae6830595487b6f90"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shellrow/nscan/releases/download/v1.1.0/nscan-x86_64-apple-darwin.tar.xz"
      sha256 "043f45de1b6ace4fa7836b1476fd4fece43f0df62f0a4dd21b266f22e9f526fb"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/shellrow/nscan/releases/download/v1.1.0/nscan-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "25961713121bb9e2229b360c4cac7c1f2faa8d07fc6743f17e96064654312380"
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
