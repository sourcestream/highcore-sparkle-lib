SparkleFormation::Registry.register(:instance_user_data) do | id, resource = id, handle = nil |

  if handle
    signal = ["/usr/local/bin/cfn-signal -e $? '", handle, "'\n"]
  else
    signal = [
        "/usr/local/bin/cfn-signal -e $? ",
        " --stack ", _stack_name,
        " --resource ", ::SparkleFormation::camel(resource),
        " --region ", _region, "\n",]
  end

  properties.user_data base64!(join!([
      "#!/bin/bash -xe\n",
      "apt-get update\n",
      "apt-get -y install python-setuptools python-crypto git-core\n",
      "easy_install pip\n",
      "pip install pyopenssl ndg-httpsclient pyasn1 ansible boto\n",

      "mkdir aws-cfn-bootstrap-latest\n",
      "curl https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz | tar xz -C aws-cfn-bootstrap-latest --strip-components 1\n",
      "pip install -e aws-cfn-bootstrap-latest\n",
      "cp /aws-cfn-bootstrap-latest/init/ubuntu/cfn-hup /etc/init.d/\n",
      "update-rc.d cfn-hup defaults\n",
      "chmod +x /etc/init.d/cfn-hup\n",

      "/usr/local/bin/cfn-init -v ",
      " --stack ", _stack_name,
      " --resource ", ::SparkleFormation::camel(id),
      " --region ", _region, "\n",

      *signal
  ]))
end