export GPG_TTY=$(tty)
if [ -f "$HOME/.gnupg-localhost/S.gpg-agent" ] && [ ! -S "$HOME/.gnupg/S.gpg-agent" ];then
	GPG_AGENT="$HOME/.gnupg-localhost/S.gpg-agent"
	PREPEND_FILE="/tmp/gpg_agent_prepend"
	WINDOWS_GPG_AGENT_PORT=$(head -n1 "$GPG_AGENT")
	tail -n+2 "$GPG_AGENT" > "$PREPEND_FILE"
	mkdir -p "$HOME/.gnupg/"
	socat "UNIX-LISTEN:$HOME/.gnupg/S.gpg-agent,fork" "SYSTEM:cat \"$PREPEND_FILE\" - <&3 | socat STDIO \"TCP\:host.docker.internal\:$WINDOWS_GPG_AGENT_PORT\" >&4,fdin=3,fdout=4" &
fi
