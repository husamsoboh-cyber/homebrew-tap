class Cloudhop < Formula
  include Language::Python::Virtualenv

  desc "The easiest way to copy files between cloud storage services"
  homepage "https://github.com/husamsoboh-cyber/cloudhop"
  url "https://files.pythonhosted.org/packages/source/c/cloudhop/cloudhop-0.10.0.tar.gz"
  sha256 "652cff3c2eb82af9f3d88fc2c8fd97797e7e6f72967f8c75ecf5319db120ef87"
  license "MIT"

  depends_on "python@3.12"
  depends_on "rclone"

  resource "pywebview" do
    url "https://files.pythonhosted.org/packages/64/09/75cf92c4db19350ddb084d841e352ce30e89668815d0494d1dd595c85469/pywebview-6.1.tar.gz"
    sha256 "f0b95047860caf3d921581f9e16b4edb1a125b23e2ce691c4da2968f8b160ff2"
  end

  def install
    virtualenv_create(libexec, "python3.12")
    system libexec/"bin/pip", "install", "pywebview>=5.0"
    system libexec/"bin/pip", "install", "--no-deps", "."
    bin.install_symlink libexec/"bin/cloudhop"
  end

  test do
    assert_match "0.10.0", shell_output("#{bin}/cloudhop --version")
  end
end
