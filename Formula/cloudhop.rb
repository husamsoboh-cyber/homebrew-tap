class Cloudhop < Formula
  include Language::Python::Virtualenv

  desc "The easiest way to copy files between cloud storage services"
  homepage "https://github.com/husamsoboh-cyber/cloudhop"
  url "https://files.pythonhosted.org/packages/68/01/5848616e5ce9a9e358cfd8fc0e9cdd19355d97f599ded19cd4b1c7d201cc/cloudhop-0.12.1.tar.gz"
  sha256 "016c07346fa12ea3062640666c7086744623d4def142802a57cd17bd8e3da88c"
  license "MIT"

  depends_on :macos
  depends_on "python@3.12"
  depends_on "rclone"

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/7a/71/cca6167c06d00c81375fd668719df245864076d284f7cb46a694cbeb5454/bottle-0.13.4.tar.gz"
    sha256 "787e78327e12b227938de02248333d788cfe45987edca735f8f88e03472c3f47"
  end

  resource "proxy_tools" do
    url "https://files.pythonhosted.org/packages/f2/cf/77d3e19b7fabd03895caca7857ef51e4c409e0ca6b37ee6e9f7daa50b642/proxy_tools-0.1.0.tar.gz"
    sha256 "ccb3751f529c047e2d8a58440d86b205303cf0fe8146f784d1cbcd94f0a28010"
  end

  resource "typing_extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "pywebview" do
    url "https://files.pythonhosted.org/packages/64/09/75cf92c4db19350ddb084d841e352ce30e89668815d0494d1dd595c85469/pywebview-6.1.tar.gz"
    sha256 "f0b95047860caf3d921581f9e16b4edb1a125b23e2ce691c4da2968f8b160ff2"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")

    # Install pure-python resources from source
    %w[bottle proxy_tools typing_extensions].each do |r|
      venv.pip_install resource(r)
    end

    # Install pyobjc frameworks from pre-built wheels (they fail to compile in brew sandbox)
    system "python3.12", "-m", "pip",
           "--python=#{libexec}/bin/python",
           "install", "--no-deps", "--only-binary", ":all:",
           "pyobjc-core==12.1",
           "pyobjc-framework-Cocoa==12.1",
           "pyobjc-framework-Quartz==12.1",
           "pyobjc-framework-UniformTypeIdentifiers==12.1",
           "pyobjc-framework-WebKit==12.1",
           "pyobjc-framework-security==12.1"

    # Install pywebview (pure python, depends on pyobjc already installed)
    venv.pip_install resource("pywebview")

    # Install cloudhop itself
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "cloudhop", shell_output("#{bin}/cloudhop --help 2>&1", 1)
  end
end
