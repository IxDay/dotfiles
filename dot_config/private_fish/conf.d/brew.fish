fish_add_path "/opt/homebrew/bin";
fish_add_path "/opt/homebrew/sbin";
fish_add_path "/opt/homebrew/opt/ruby/bin";

set -Ux HOMEBREW_PREFIX "/opt/homebrew";
set -Ux HOMEBREW_CELLAR "/opt/homebrew/Cellar";
set -Ux HOMEBREW_REPOSITORY "/opt/homebrew";

if test -n "$MANPATH[1]"; set --global --export MANPATH '' $MANPATH; end;
if not contains "/opt/homebrew/share/info" $INFOPATH; set --global --export INFOPATH "/opt/homebrew/share/info" $INFOPATH; end;

# Avoid using shellenv as it will push a path I do not want (i.e brew first)
# This file contains a curated output of the command I'd like to run
#brew shellenv | source

