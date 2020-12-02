class Mtm < Formula
  desc "Micro terminal multiplexer"
  homepage "https://github.com/deadpixi/mtm"
  url "https://github.com/deadpixi/mtm/archive/1.2.0.tar.gz"
  sha256 "68f753f743fcd3d87f269011d4bbd3fed59cfcad710d7c7db98844e3e675c196"
  license "GPL-3.0-or-later"

  head do
    url "https://github.com/deadpixi/mtm.git"

    uses_from_macos "ncurses"
  end

  depends_on "ncurses" # requires ncurses >= 6.1

  def install
    bin.mkpath
    man1.mkpath

    makefile = build.head? ? "Makefile.darwin" : "Makefile"
    inreplace makefile, /strip\s+(?:-s)/, "strip"

    system "make", "-f", makefile, "install", "DESTDIR=#{prefix}", "MANDIR=#{man1}"
    system "make", "-f", makefile, "install-terminfo"
  end

  test do
    require "open3"

    env = { "SHELL" => "/bin/sh", "TERM" => "xterm" }
    Open3.popen2(env, bin/"mtm") do |input, output, wait_thr|
      input.puts "printf 'TERM=%s PID=%s\n' $TERM $MTM"
      input.putc "\cG"
      sleep 1
      input.putc "w"

      assert_match "TERM=screen-bce PID=#{wait_thr.pid}", output.read
    end
  end
end
