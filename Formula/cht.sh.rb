class ChtSh < Formula
  desc "Command-line client for cheat.sh"
  homepage "https://cheat.sh/"
  url "https://github.com/chubin/cheat.sh.git",
      :revision => "c4c3a627de74b8f414066efe267b8a048a9081e6"
  version "6"
  head "https://github.com/chubin/cheat.sh.git"

  bottle :unneeded

  depends_on "rlwrap"

  def install
    bash_completion.install "share/bash_completion.txt" => "cht_sh.bash"
    fish_completion.install "share/fish.txt" => "cht_sh.fish"
    zsh_completion.install "share/zsh.txt" => "_cht_sh"
    bin.install "share/cht.sh.txt" => "cht.sh"
  end

  test do
    (testpath/"cht.sh.conf").write "CHTSH_QUERY_OPTIONS=\"T\""

    output = shell_output("CHTSH_CONF=cht.sh.conf #{bin}/cht.sh tar")
    assert_match /^# tar\n# Archiving utility./, output
    assert_match /^# Create an archive from files:/, output
    assert_match /^tar cf target.tar file1 file2 file3/, output

    stdin, stdout, = Open3.popen2("CHTSH_CONF=cht.sh.conf #{bin}/cht.sh --shell")
    stdin.puts "ln"
    stdin.puts "exit"
    output = stdout.read
    assert_match /^# ln\n# Creates links to files and directories./, output
    assert_match /^# Create a symbolic link to a file or directory:/, output
    assert_match %r{^ln -s path/to/file_or_directory path/to/symlink}, output
  end
end
