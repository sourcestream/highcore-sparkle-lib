SparkleFormation::Registry.register(:instance_metadata) do |id, config={}|

  config[:files] ||= []
  config[:files] << -> {[:files_cfn_hup, id]}
  config[:files] << -> {[:files_cfn_autoreloader, id]}

  metadata do
    set!('AWS::CloudFormation::Init') do
      _camel_keys_set(:auto_disable)
      config do
        files do
          config[:files].each { | file |
            file.is_a?(Proc) ? dynamic!(*file.call) : file
          }
        end
        services do
          sysvinit do
            set!('cfn-hup') do
              enabled true
              ensureRunning true
              files [
                "/etc/cfn/cfn-hup.conf",
                "/etc/cfn/hooks.d/cfn-auto-reloader.conf"
              ]
            end
          end
        end
        if config[:commands]
          commands do
            config[:commands].each do | name, properties |
              set!(name) do
                properties.each do | property, value |
                  set!(property, value)
                end
              end
            end
          end
        end
        if config[:packages]
          packages do
            config[:packages].each do | manager, packages |
              set!(manager) do
                packages.each do | package, value |
                  set!(package, value)
                end
              end
            end
          end
        end
      end
      _camel_keys_set(:auto_enable)
    end
  end
end