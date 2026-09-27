#!/usr/bin/env bash
# Prepares a freshly installed Debian-based system and runs the playbook:
# installs pipx and Git, installs Ansible with pipx, clones this repository
# and runs playbook.yaml.
#
#   curl -fsSL https://raw.githubusercontent.com/thomaspalma1/ansible-environment-setup/main/install.sh | bash
set -euo pipefail

REPO_URL="https://github.com/thomaspalma1/ansible-environment-setup.git"
REPO_DIR="$HOME/ansible-environment-setup"

# Everything runs from main, called on the last line, so bash only starts once
# curl has delivered the whole script.
main() {
  # https://pipx.pypa.io/stable/how-to/install-pipx/
  sudo apt-get update
  sudo apt-get install -y pipx git
  pipx ensurepath
  # ensurepath only affects new shells; this one needs ~/.local/bin now
  export PATH="$HOME/.local/bin:$PATH"

  # https://docs.ansible.com/projects/ansible/latest/installation_guide/intro_installation.html
  pipx install ansible-core
  ansible --version

  if [ -d "$REPO_DIR/.git" ]; then
    git -C "$REPO_DIR" pull --ff-only
  else
    git clone "$REPO_URL" "$REPO_DIR"
  fi

  cd "$REPO_DIR"
  ansible-galaxy collection install -r requirements.yaml
  # stdin is the script itself under curl | bash, so the password prompt reads the terminal
  ansible-playbook playbook.yaml --ask-become-pass </dev/tty
}

main "$@"
