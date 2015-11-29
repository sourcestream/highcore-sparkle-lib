SparkleFormation::Registry.register(:iam_role) do | id, config = {} |
  config[:assume_role_policy_document] ||= {
      :version => '2012-10-17',
      :statement => [
          :effect => 'Allow',
          :principal => {
              :service => ['ec2.amazonaws.com']
          },
          :action => 'sts:AssumeRole'
      ]
  }
  config[:policies] ||= [{
      :policy_name => 'AllowEC2Describe',
      :policy_document => {
          :version => '2012-10-17',
          :statement => [
              :effect => 'Allow',
              :action => 'ec2:Describe*',
              :resource => '*'
          ]
      }
  }]

  config[:path] ||= '/'

  dynamic!(:iam_role, id, config)
end