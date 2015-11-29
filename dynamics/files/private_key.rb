SparkleFormation.dynamic(:files_private_key) do | id, config = {} |

  set!(config[:path] || '/root/.ssh/id_rsa') do
    content config[:key]
    mode "000600"
    owner config[:owner] if config[:owner]
    group config[:group] if config[:group]
  end

end