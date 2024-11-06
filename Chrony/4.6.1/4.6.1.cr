class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr  \
                                    --enable-scfilter",
                        path:       buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/conf.d")

        chronydData = <<-CODE
        CFGFILE="/etc/chrony.conf"
        ARGS=" -u ntp -F 2"
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/conf.d/chronyd",chronydData)

        chronyconfData = <<-CODE
        pool pool.ntp.org iburst auto_offline
        makestep 1.0 3
        rtcsync
        logdir /var/log/chrony
        log measurements statistics tracking
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/chrony.conf",chronyconfData)

        if option("Openrc")
            prepareOpenrcServiceInstallation(   path:   "#{workDirectoryPath}/Chrony-Init.d",
                                                name:   "chronyd")
        end
    end

end
