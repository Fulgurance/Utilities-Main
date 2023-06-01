class Target < ISM::Software

    def configure
        super

        configureSource(["--prefix=/usr"],buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/conf.d")

        chronydData = <<-CODE
        CFGFILE="/etc/chrony.conf"
        ARGS=" -u ntp -F 2"
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/conf.d/chronyd",chronydData)

        chronyconfData = <<-CODE
        pool pool.ntp.org iburst auto_offline
        makestep 1.0 3
        rtcsync
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/chrony.conf",chronyconfData)

        if option("Openrc")
            prepareOpenrcServiceInstallation("#{workDirectoryPath(false)}/Chrony-Init.d","chronyd")
        end
    end

end
