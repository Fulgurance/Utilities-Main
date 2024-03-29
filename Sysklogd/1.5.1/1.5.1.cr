class Target < ISM::Software

    def prepare
        super

        fileDeleteLine("#{buildDirectoryPath(false)}ksym_mod.c",192)
        fileReplaceText("#{buildDirectoryPath(false)}syslogd.c","union wait","int")
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["BINDIR=/sbin","DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/conf.d")

        syslogData = <<-CODE
        auth,authpriv.* -/var/log/auth.log
        *.*;auth,authpriv.none -/var/log/sys.log
        daemon.* -/var/log/daemon.log
        kern.* -/var/log/kern.log
        mail.* -/var/log/mail.log
        user.* -/var/log/user.log
        *.emerg *
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/syslog.conf",syslogData)

        if option("Openrc")
            sysklogdData = <<-CODE
            # Config file for /etc/init.d/sysklogd
            SYSLOGD="-m 0 -s -s -r 10M:10"
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/conf.d/sysklogd",sysklogdData)

            prepareOpenrcServiceInstallation("#{workDirectoryPath(false)}/Sysklogd-Init.d","sysklogd")
        end
    end

end
