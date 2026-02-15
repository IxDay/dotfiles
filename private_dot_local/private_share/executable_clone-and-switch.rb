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

Clap.run("clone-and-switch") do |c|
  c.about "Clone and switch to a specific branch one or more repositories"

  c.arg "repo" do |a|
    a.positional
    a.required
    a.help "Repository to clone (org/repo or full URL)"
  end

  c.arg "dir" do |a|
    a.positional
    a.help "Target directory"
  end

  c.arg "branch" do |a|
    a.short "B"
    a.long "branch"
    a.help "Name of the branch you want to checkout"
  end

  c.arg "mise" do |a|
    a.short "M"
    a.long "mise"
    a.flag
    a.help "Initiate a mise file (https://mise.jdx.dev/) in directory root"
  end

  c.arg "editorconfig" do |a|
    a.short "E"
    a.long "editorconfig"
    a.flag
    a.help "Initiate an editorconfig file (https://editorconfig.org/) in directory root"
  end

  c.action do |matches|
    name = matches.get_one("repo")
    name = "https://github.com/#{name}" if name.match? %r{\A[\w.-]+\/[\w.-]+\z}
    repo = Repo.new name, matches.get_one("dir"), matches.get_one("branch")
    repo.with_editor_config if matches.flag?("editorconfig")
    repo.with_mise if matches.flag?("mise")
    repo.generate
  end
end
