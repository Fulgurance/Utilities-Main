class Target < ISM::Software

    def prepare
        super

        fileDeleteLine("#{buildDirectoryPath}ksym_mod.c",192)

        fileReplaceText(path:       "#{buildDirectoryPath}syslogd.c",
                        text:       "union wait",
                        newText:    "int")
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "BINDIR=/sbin DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
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

end
