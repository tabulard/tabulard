# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name     = "tabulard"
  spec.version  = File.read(File.expand_path("VERSION", __dir__)).chomp
  spec.authors  = ["Erwan Thomas"]
  spec.email    = ["id@maen.fr"]
  spec.license  = "Apache-2.0"
  spec.homepage = "https://github.com/tabulard/tabulard"
  spec.summary  = "Process tabular data from different sources with a rich, unified API"

  spec.required_ruby_version = ">= 3.0"

  spec.metadata["source_code_uri"]   = "https://github.com/tabulard/tabulard"
  spec.metadata["bug_tracker_uri"]   = "https://github.com/tabulard/tabulard/issues"
  spec.metadata["changelog_uri"]     = "https://github.com/tabulard/tabulard/blob/master/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://github.com/tabulard/tabulard/blob/master/README.md"

  # All privileged operations by any of the owners require OTP.
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    git_paths = `git ls-files -z`.split("\x0")

    git_paths.grep(%r{^(?:exe|lib)/}) + %w[
      VERSION
      LICENSE
    ]
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{#{spec.bindir}/}) { |path| File.basename(path) }
  spec.require_paths = ["lib"]
end
