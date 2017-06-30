SparkleFormation.dynamic(:files_cfn_hup) do | id, config = {} |

  set!('/etc/cfn/cfn-hup.conf') do
    content join!([
                      "[main]\n",
                      "stack=", _stack_id, "\n",
                      "region=", _region, "\n",
                      "interval=1", "\n"
                  ])
  end

end