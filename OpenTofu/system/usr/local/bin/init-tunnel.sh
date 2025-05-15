#!/usr/bin/env bash
DESTHOST=$1

set -ex
test -n "$DESTHOST" || (
    echo missing DESTHOST;
    exit 1
)
test "$(ps -lef | grep ssh | grep "8880" | awk "{print \$4}")" \
&& echo "Going to kill running tunnel on port 8880 !" \
&& ps -lef | grep ssh | grep "8880" | awk "{print \$4}" | xargs kill

set +e

cleanup() {
    cat log.txt
    rm -rf log.txt
    exit $!
}

for try in {0..25}; do
    
    echo "Trying to port forward retry #$try"
    # The following command MUST NOT print to the stdio otherwise it will just
    # inherit the pipe from the parent process and will hold terraform's lock
    ssh -4 -f -o StrictHostKeyChecking=no \
    -i "$HOME/.ssh/ssh_key" \
    "terraform@$DESTHOST" \
    -L "8880:127.0.0.1:8888" \
    sleep 1h &>log.txt # This is the special ingredient!
    success="$?"
    if [ "$success" -eq 0 ]; then
        cleanup 0
    fi
    sleep 5s
done

echo "Failed to start a port forwarding session"
cleanup 1
