SparkleFormation.dynamic(:files_known_hosts) do | id, config = {} |

  set!('/root/.ssh/known_hosts') do
    content join!([join!(config[:host_keys], :options => {:delimiter => "\n"}), "\n"])
  end

end