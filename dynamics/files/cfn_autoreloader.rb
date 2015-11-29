SparkleFormation.dynamic(:files_cfn_autoreloader) do | id, config = {} |

  set!('/etc/cfn/hooks.d/cfn-auto-reloader.conf') do
    content join!([
                      "[cfn-auto-reloader-hook]\n",
                      "triggers=post.update\n",
                      "path=Resources.", SparkleFormation.camel(id), ".Metadata.AWS::CloudFormation::Init\n",
                      "action=/usr/local/bin/cfn-init -v ",
                      " --stack ", _stack_name,
                      " --resource ", SparkleFormation.camel(id),
                      " --region ", _region, "\n",
                      "runas=root\n"
                  ])
  end

end