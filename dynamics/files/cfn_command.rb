SparkleFormation.dynamic(:files_cfn_autoreloader) do | id, config = {} |

  set!('/etc/cfn/hooks.d/cfn-command.conf') do
    content join!([
                      "[cfn-command-hook]\n",
                      "triggers=on.command\n",
                      "send_result=True\n",
                      "path=Resources.", SparkleFormation.camel(id), ".Metadata.AWS::CloudFormation::Init\n",
                      "action=/usr/local/bin/cfn-init -v ",
                      " --stack ", _stack_name,
                      " --resource ", SparkleFormation.camel(id),
                      " --region ", _region, "\n",
                      "runas=root\n"
                  ])
  end

end