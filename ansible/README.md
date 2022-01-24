### Ansible Playbooks to configure Axelar blockchain Nodes

### Datadog
Installs and configures the DataDog agent on the blockchain nodes.

Prerequisites:

Download the [Datadog role](https://github.com/DataDog/ansible-datadog):
```
ansible-galaxy install Datadog.datadog
```

Datadog API key is stored at `/Volumes/Keybase/team/figureops/ansible/datadog_vars`.


Usage: `ansible-playbook -i hosts axelar-datadog.yml`