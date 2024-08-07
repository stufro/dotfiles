source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH

export ASDF_DIR=/opt/homebrew/opt/asdf/libexec/
source /opt/homebrew/opt/asdf/libexec/asdf.sh
source /Users/stuart/.asdf/installs/rust/1.68.0/env

export EDITOR=vim
export NLS_LANG="ENGLISH_UNITED KINGDOM.AL32UTF8"

export OCI_DIR=$HOME/oracle/instantclient_12_2
# export NODE_OPTIONS=--openssl-legacy-provider

# Ruby flags for compiler issues
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl)"
# export PKG_CONFIG_PATH="/opt/homebrew/opt/readline/lib/pkgconfig:$PKG_CONFIG_PATH"
# export PKG_CONFIG_PATH="/opt/homebrew/opt/libffi/lib/pkgconfig:$PKG_CONFIG_PATH"
# export optflags="-Wno-error=implicit-function-declaration"
# 
# export LDFLAGS="-L/opt/homebrew/opt/capstone/lib"
# export LDFLAGS="-L/opt/homebrew/opt/readline/lib:$LDFLAGS"
# export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib:$LDFLAGS"
# export LDFLAGS="-L/opt/homebrew/opt/openssl@1.1/lib:$LDFLAGS"
# 
# export CPPFLAGS="-I/opt/homebrew/opt/capstone/include"
# export CPPFLAGS="-I/opt/homebrew/opt/readline/include:$CPPFLAGS"
# export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include:$CPPFLAGS"
# export CPPFLAGS="-I/opt/homebrew/opt/openssl@1.1/include:$CPPFLAGS"
# ---

# crystal lang development
export LLVM_CONFIG=/opt/homebrew/opt/llvm@15/bin/llvm-config
export PATH="/opt/homebrew/opt/libxml2/bin:$PATH"
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}/opt/homebrew/opt/libxml2/lib/pkgconfig"
export CRYSTAL_OPTS="--link-flags=-Wl,-ld_classic"

# python poetry
export PATH="$PATH:/Users/stuart/.local/bin"

# golang
export GOBIN=$(go env GOROOT)/bin

alias ibrew='arch --x86_64 /usr/local/Homebrew/bin/brew'
alias vim='/opt/homebrew/bin/nvim'

