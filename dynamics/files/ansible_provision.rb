SparkleFormation.dynamic(:files_ansible_provision) do | id, config = {} |

  if config[:repository].is_a?(Hash) || config[:repository].end_with?('.git')
    set!('/usr/bin/ansible-provision') do
      content join!([
                        "#!/bin/bash\n",
                        "mkdir -p /root/playbooks\n",
                        "rm -rf /root/playbooks\n",
                        "git clone ", config[:repository], " /root/playbooks\n",
                        "cd /root/playbooks/\n",
                        "git checkout ", config[:version],
                        "\n",
                        "ansible-generate-vars\n",
                        "\n",
                        "[ -f requirements.yml ] && ansible-galaxy install --force -r requirements.yml\n",
                        "[ -f /root/.ansible_vault_password ] && export VAULT_PASSWORD_FILE='--vault-password-file /root/.ansible_vault_password'\n",
                        "HOST=`ec2metadata | grep local-hostname | cut -d ' ' -f2`\n",
                        "EC2_INI_PATH=/etc/ansible/ec2.ini ansible-playbook --limit $HOST -c local -i /etc/ansible/ec2.py ",
                        "$VAULT_PASSWORD_FILE ",
                        "-e \"@/root/.ansible/#{id}.yaml\" #{config[:playbook]}.yml > /var/log/#{id}-ansible-playbook.log",
                        "\n",
                        "exit_code=$?\n",
                        "echo $exit_code > /var/log/ansible-provision-result\n",
                        "exit $exit_code\n"
                    ])

      mode "000755"
    end
  else
    set!('/usr/bin/ansible-provision') do
      content join!([
        "#!/bin/sh\n",
        "\n",
        "python <<PY\n",
        "import boto\n",
        "from boto.s3.key import Key\n",
        "c = boto.connect_s3();\n",
        "b = c.get_bucket('#{config[:repository]}'.replace('s3://', ''));\n",
        "k = Key(b);\n",
        "\n",
        "k.key = '/#{config[:version]}';\n",
        "k.get_contents_to_filename('playbooks.tar.gz');\n",
        "PY\n",
        "\n",
        "mkdir -p /root/playbooks\n",
        "rm -rf /root/playbooks/*\n",
        "tar -zxf playbooks.tar.gz -C /root/playbooks/\n",
        "\n",
        "ansible-generate-vars",
        "\n",
        "cd /root/playbooks/\n",
        "[ -f requirements.yml ] && ansible-galaxy install --force -r requirements.yml\n",
        "[ -f /root/.ansible_vault_password ] && export VAULT_PASSWORD_FILE='--vault-password-file /root/.ansible_vault_password'\n",
        "HOST=`ec2metadata | grep local-hostname | cut -d ' ' -f2`\n",
        "EC2_INI_PATH=/etc/ansible/ec2.ini ansible-playbook --limit $HOST -c local -i /etc/ansible/ec2.py ",
        "$VAULT_PASSWORD_FILE ",
        "-e \"@/root/.ansible/#{id}.yaml\" #{config[:playbook]}.yml > /var/log/#{id}-ansible-playbook.log",
        "\n",
        "exit_code=$?\n",
        "echo $exit_code > /var/log/ansible-provision-result\n",
        "exit $exit_code\n"
                    ])
      mode "000755"
    end
  end


end