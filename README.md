# Ansible Environment Setup

<p align="justify">
   <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/ansible/ansible-original.svg" width="50" height="50"/>
</p>

## Roles

| Role | Description |
| ---- | ----------- |
| `update_os` | Refreshes the apt cache, runs a `dist` upgrade, removes orphaned packages, cleans the package cache and handles pending reboots |
| `docker_install` | Installs Docker Engine, Buildx and Compose from the official Docker apt repository, configures the `local` logging driver and grants Docker access to the listed users |

Both roles load `<distribution>.yaml` or, when it does not exist, `<os_family>.yaml` from their `tasks/` directory, following the `ansible_facts` values (e.g. `Fedora.yaml`, `Debian.yaml`). Debian is currently supported.

### Variables

| Variable | Default | Description |
| -------- | ------- | ----------- |
| `update_os_cache_valid_time` | `3600` | Seconds the apt cache is considered valid |
| `update_os_upgrade_type` | `dist` | apt upgrade mode (`dist`, `full`, `safe`, `yes`) |
| `update_os_reboot_if_required` | `false` | Reboot the host when `/var/run/reboot-required` exists; otherwise only report it |
| `docker_install_log_max_size` | `10m` | Maximum size of each container log file (`local` logging driver) |
| `docker_install_log_max_file` | `"3"` | Number of rotated container log files kept |
| `docker_install_users` | `[]` | Users added to the `docker` group to run Docker without `sudo`. The group grants root-level privileges on the host |

## Todo

- [ ] Fedora support in `update_os` (`roles/update_os/tasks/Fedora.yaml`)
- [ ] Fedora support in `docker_install` (`roles/docker_install/tasks/Fedora.yaml`)
- [ ] macOS support in `update_os` (`roles/update_os/tasks/Darwin.yaml`)
- [ ] macOS support in `docker_install` (`roles/docker_install/tasks/Darwin.yaml`)

## Usage

```sh
ansible-galaxy collection install -r requirements.yaml
```

Apply the roles from a playbook:

```yaml
- name: Set up the environment
  hosts: all
  roles:
    - update_os
    - role: docker_install
      vars:
        docker_install_users:
          - "{{ ansible_user }}"
```

The tasks escalate privileges with `become`, so run the playbook with `--ask-become-pass` when the user needs a sudo password.
