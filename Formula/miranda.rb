class Miranda < Formula
  desc "Lazy, purely functional programming language"
  homepage "http://miranda.org.uk/"
  url "https://www.cs.kent.ac.uk/people/staff/dat/miranda/src/mira-2066-src.tgz"
  version "2.066"
  sha256 "521c281e8c2fde87a2cd7c41d9677daa09514debb71435efc08ff3a7c20016eb"

  depends_on "byacc" => :build

  def install
    ENV.deparallelize

    bin.mkpath
    lib.mkpath
    man1.mkpath

    inreplace "Makefile" do |s|
      s.gsub! "./ugroot", "whoami"
      s.gsub! "./protect", "/usr/bin/true"
      s.gsub! "./unprotect", "/usr/bin/true"
    end

    args = %W[
      CC=#{ENV.cc}
      CFLAGS=-O
      BIN=#{bin}
      LIB=#{lib}
      MAN=#{man1}
    ]

    system "make", "install", *args
  end

  def post_install
    miralib = "#{lib}/miralib"

    chmod "+w", "#{miralib}/preludx"
    chmod "+w", Dir["#{miralib}/**/*.x"]
    system "#{bin}/mira", "-make", "-lib", miralib, "#{miralib}/**/*.m"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mira -version")

    (testpath/"test.m").write <<~EOS
      main = [ Stdout "it works!\\n" ]
    EOS

    assert_equal "it works!\n", shell_output("#{bin}/mira -exec test.m")
  end
end
