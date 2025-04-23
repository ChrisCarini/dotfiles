# Created by `pipx` on 2024-03-14 02:20:11
export PATH="$PATH:/Users/ccarini/.local/bin"
if [ -f "/Users/ccarini/.config/fabric/fabric-bootstrap.inc" ]; then . "/Users/ccarini/.config/fabric/fabric-bootstrap.inc"; fi

# $HOME/.cargo/bin is added to user PATH by MDM
# You can opt-out by creating ~/.no_touch_shell_rc file
case ":${PATH}:" in
    *:"$HOME/.cargo/bin":*)
    ;;
    *)
    export PATH="$PATH:$HOME/.cargo/bin"
    ;;
esac

# direnv hook is added to by MDM
command -v direnv > /dev/null && eval "$(direnv hook bash)"