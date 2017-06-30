SparkleFormation.dynamic(:files_ansible_vault_password) do | id, config = {} |

  set!('/root/.ansible_vault_password') do
    content config[:password]
    mode "000600"
  end

end