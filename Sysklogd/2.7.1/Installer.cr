class Target < ISM::Software

    def prepare
        super

        runAutoreconfCommand(   arguments: "-fiv",
                                path: buildDirectoryPath)
    end

    def configure
        super

        configureSource(arguments:  "--prefix=/usr          \
                                    --sysconfdir=/etc       \
                                    --runstatedir=/run      \
                                    --without-logger        \
                                    --disable-static        \
                                    --disable-doc",
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

        syslogData = <<-CODE
        auth,authpriv.* -/var/log/auth.log
        *.*;auth,authpriv.none -/var/log/sys.log
        daemon.* -/var/log/daemon.log
        kern.* -/var/log/kern.log
        mail.* -/var/log/mail.log
        user.* -/var/log/user.log
        *.emerg *
        secure_mode 2
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/syslog.conf",syslogData)

        if option("Openrc")
            sysklogdData = <<-CODE
            # Config file for /etc/init.d/sysklogd
            SYSLOGD="-m 0 -s -s -r 10M:10"
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/conf.d/sysklogd",sysklogdData)

            prepareOpenrcServiceInstallation(   path:   "#{workDirectoryPath}/Sysklogd-Init.d",
                                                name:   "sysklogd")
        end
    end

    def deploy
        super

        if autoDeployServices
            if option("Openrc")
                runRcUpdateCommand("add sysklogd default")
            end
        end
    end

end
