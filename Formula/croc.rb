class Croc < Formula
  desc "Easily and securely send things from one computer to another"
  homepage "https://schollz.com/software/croc6"
  url "https://github.com/schollz/croc/archive/v8.1.3.tar.gz"
  sha256 "507266a99e91e4872c1657674702c8869b907ed9e1638daec06556de77013006"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    mkdir "out"
    (testpath/"test.txt").write "Hello Homebrew!"
    server_pid = fork do
      exec "#{bin}/croc", "send", "-c", "homebrew-demo", "test.txt"
    end
    sleep 1
    system "#{bin}/croc", "--yes", "--out", "out", "homebrew-demo"
    sleep 1
    assert_predicate testpath/"out/test.txt", :exist?
    assert_equal "Hello Homebrew!", (testpath/"out/test.txt").read
    Process.kill("TERM", server_pid)
  end
end
