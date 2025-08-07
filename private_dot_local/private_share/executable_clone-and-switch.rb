#!/usr/bin/env mruby

module Rakefile
  extend self

  MISE_TOML = <<~EOF
    [env]
    PROJECT = "{{config_root}}"
  EOF

  def run(cmd)
    cmd = (cmd.respond_to? 'join') ? cmd.join(' ') : cmd
    STDERR.puts ">>> ".yellow + cmd
    `#{cmd}`
  end

  def write(name, str) = File.open(name, File::CREAT | File::TRUNC | File::WRONLY).write(str)

  def generate(url, repo, branch)
    include Rake::DSL

    directory repo do
      catch(:exit_early) do
        Dir.chdir(repo) do
          # https://morgan.cugerone.com/blog/workarounds-to-git-worktree-using-bare-repository-and-cannot-fetch-remote-branches/
          run %W[git clone --bare "#{url}" ".bare"]
          write ".git", "gitdir: ./.bare"
          run %W[git config remote.origin.fetch +refs/heads/*:refs/remotes/origin/*]
          throw :exit_early unless branch.nil?
          branch = `git branch --show-current`.strip
        end
        Rake.application.tasks.clear
        generate(url, repo, branch).invoke()
      end
    end

    file File.join(repo, "mise.toml") => [repo] do |t|
      write t.name, MISE_TOML
      run %W[mise -C #{repo} trust --quiet]
    end

    task "mise" => [File.join(repo, "mise.toml")]

    file File.join(repo, ".editorconfig") => [repo] do |t|
      write t.name, ""
    end

    task "editorconfig" => [File.join(repo, ".editorconfig")]

    # !!! exit early if no branch is specified
    return task "repository" => [repo] if branch.nil?

    file_create File.join(repo, branch) => [repo] do |t|
      run %W[git -C "#{repo}" fetch origin]
      run %W[git -C "#{repo}" worktree add #{branch}]
    end

    task "clone_and_switch" => [File.join(repo, branch)] do |t|
      Dir.chdir(t.prerequisites.first) { puts Dir.getwd }
    end
  end
end

class Repo

  def initialize(name, path=nil, branch=nil)
    path ||= name.split("/").last().delete_suffix(".git")

    # if repo exists we try to get default branch if not specified
    begin
      branch ||= Dir.chdir(path) { `git branch --show-current`.strip }
    rescue Errno::ENOENT
    end

    @task = Rakefile.generate(name, path, branch)
  end

  def with_mise = @task.prerequisites << "mise"
  def with_editor_config = @task.prerequisites << "editorconfig"
  def generate = @task.invoke
end

def options()
  # Default options of our CLI
  options = {
    :branch => nil,
    :path => nil,
    :repo => nil,
    :mise => false,
    :editorconfig => false,
  }

  parser = OptionParser.new do |opts|
    program_name = File.basename __FILE__
    # Banner has been heavily inspired by the jq --help output
    opts.banner = <<~EOF
      #{program_name} - clone and switch to a specific branch one or more repositories

      Usage: #{program_name} [options] <repo> [<dir>]

      This command will clone one or more repos as bare and create a worktree
      for a specified branch if provided.

      Example:

        $ #{program_name} --branch my-custom-branch some_org/some_repo specific_directory

      Command options:
    EOF
    opts.on_tail("-h", "--help", "-H", "Display this help message.") do
      STDERR.puts opts
      exit
    end
    [
      ["--branch <name>", "-B",
        "Name of the branch you want to checkout.",
        lambda { |v| options[:branch] = v }
      ],
      ["--mise", "-M",
        "Initiate a mise file (https://mise.jdx.dev/) in directory root.",
        lambda { |_| options[:mise] = true }
      ],
      ["--editorconfig", "-E",
        "Initiate an editorconfig file (https://editorconfig.org/) in directory root.",
        lambda { |_| options[:editorconfig] = true }
      ],
    ].each { |args| opts.on(*args) }
  end

  parser.parse!(ARGV)
  case ARGV.length
  when 0
    STDERR.puts "You must at least specify a repository to clone.\n\n#{parser}"
    exit 2
  when 1
    options[:repo] = ARGV[0]
  when 2
    options[:repo], options[:path] = ARGV[0], ARGV[1]
  else
    STDERR.puts "Too many arguments.\n\n#{parser}"
    exit 2
  end
  options
end

def main(repo:, path:, branch:, mise:, editorconfig:)
  repo = "https://github.com/#{repo}" if repo.match? %r{\A[\w.-]+\/[\w.-]+\z}
  repo = Repo.new repo, path, branch
  repo.with_editor_config if editorconfig
  repo.with_mise if mise
  repo.generate
end

main(**options)
