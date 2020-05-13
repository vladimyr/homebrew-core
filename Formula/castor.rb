class Castor < Formula
  desc "Graphical browser for plain-text protocols"
  homepage "https://git.sr.ht/~julienxx/castor"
  url "https://git.sr.ht/~julienxx/castor/archive/0.8.3.tar.gz"
  sha256 "f1f41c47bf7b0cb9391582f468d9e4def5e9f3a16479b09bfeb4808e7e3ec72d"

  depends_on "coreutils" => :build # GNU install
  depends_on "rust" => :build
  depends_on "adwaita-icon-theme"
  depends_on "atk"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "openssl@1.1"
  depends_on "pango"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    inreplace "Makefile", "update-desktop-database", ""
    system "make", "install", "PREFIX=#{prefix}", "INSTALL=ginstall -D"
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-qtf", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    pid = fork do
      exec "#{bin}/castor", "gemini://gemini.circumlunar.space"
    end
    sleep 10
    ensure
      Process.kill("HUP", pid)
  end
end
