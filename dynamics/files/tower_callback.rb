SparkleFormation.dynamic(:files_tower_callback) do | id, config = {} |

  set!('/usr/local/bin/tower-callback') do
    content join!([
                      "#!/bin/bash\n",
                      "retry_attempts=10\n",
                      "attempt=0\n",
                      "while [[ $attempt -lt $retry_attempts ]]\n",
                      "do\n",
                      "  status_code=`curl -s -i --data \"host_config_key=$2\" https://$1/api/v1/job_templates/$3/callback/ | head -n 1 | awk '{print $2}'`\n",
                      "  if [[ $status_code == 202 ]]\n",
                      "    then\n",
                      "    exit 0\n",
                      "  fi\n",
                      "  attempt=$(( attempt + 1 ))\n",
                      "  echo \"${status_code} received... retrying in 1 minute. (Attempt ${attempt})\"\n",
                      "  sleep 60\n",
                      "done\n",
                      "exit 1\n",
                  ])
    mode "000755"
  end

end