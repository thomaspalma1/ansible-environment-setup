# Ansible Environment Setup

<p align="justify">
   <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/ansible/ansible-original.svg" width="50" height="50"/>
</p>

Ansible roles that prepare a workstation: they keep the operating system up to date and install the tools I use day to day.

## Roles

| Role | Description |
| ---- | ----------- |
| `update_os` | Refreshes the apt cache, runs a `dist` upgrade, removes orphaned packages, cleans the package cache and handles pending reboots |
| `install_base_packages` | Installs everyday packages from the Debian repositories (`git`, `python3-venv`, `tmux`, `jq`, `xclip`, `tree`, `bat`, `btop`, `vlc`) |
| `install_brave` | Installs the Brave browser from the official Brave release apt repository |
| `install_discord` | Installs the latest stable Discord from the official `.deb`; each run upgrades it when a newer version is available |
| `install_docker` | Installs Docker Engine, Buildx and Compose from the official Docker apt repository, configures the `local` logging driver and grants Docker access to the listed users |
| `install_spotify` | Installs the Spotify client from the official Spotify apt repository |
| `install_vim` | Installs Vim and downloads the `.vimrc` into the home directory of the user Ansible connects as |
| `install_vscode` | Installs the latest stable Visual Studio Code from the official `.deb`, which also adds the Microsoft apt repository so `update_os` keeps it up to date |
| `install_zsh` | Installs Zsh and sets it as the default shell of the user running the playbook |

Each role loads `<distribution>.yaml` or, when it does not exist, `<os_family>.yaml` from its `tasks/` directory, following the `ansible_facts` values (e.g. `Fedora.yaml`, `Debian.yaml`). Debian is currently supported.

### Variables

| Variable | Default | Description |
| -------- | ------- | ----------- |
| `update_os_cache_valid_time` | `3600` | Seconds the apt cache is considered valid |
| `update_os_upgrade_type` | `dist` | apt upgrade mode (`dist`, `full`, `safe`, `yes`) |
| `update_os_reboot_if_required` | `false` | Reboot the host when `/var/run/reboot-required` exists; otherwise only report it |
| `install_docker_log_max_size` | `10m` | Maximum size of each container log file (`local` logging driver) |
| `install_docker_log_max_file` | `"3"` | Number of rotated container log files kept |
| `install_docker_users` | `[]` | Users added to the `docker` group to run Docker without `sudo`. The group grants root-level privileges on the host |

## Usage

```sh
ansible-galaxy collection install -r requirements.yaml
```

Apply the roles from a playbook:

```yaml
- name: Set up the environment
  hosts: all
  vars:
    install_docker_users:
      - "{{ ansible_user }}"
  roles:
    - update_os
    - install_base_packages
    - install_brave
    - install_discord
    - install_docker
    - install_spotify
    - install_vim
    - install_vscode
    - install_zsh
```

The tasks escalate privileges with `become`, so run the playbook with `--ask-become-pass` when the user needs a sudo password.

## Todo

- [ ] Fedora support in `update_os` (`roles/update_os/tasks/Fedora.yaml`)
- [ ] Fedora support in `install_docker` (`roles/install_docker/tasks/Fedora.yaml`)
- [ ] macOS support in `update_os` (`roles/update_os/tasks/Darwin.yaml`)
- [ ] macOS support in `install_docker` (`roles/install_docker/tasks/Darwin.yaml`)
