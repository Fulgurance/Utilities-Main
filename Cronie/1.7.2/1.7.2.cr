class Target < ISM::Software

    def configure
        super

        runFile("autogen.sh", path: buildDirectoryPath)

        configureSource([   "--prefix=/usr",
                            "--with-daemon_username=cronie",
                            "--with-daemon_groupname=cronie",
                            "#{option("Linux-Pam") ? "--with-pam" : "--without-pam"}"],
                            path: buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        if option("Linux-Pam")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d")

            croniePamData = <<-CODE
            auth       include    system-auth
            account    required   pam_access.so
            account    include    system-auth
            session    required   pam_loginuid.so
            session    include    system-auth
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d/cronie",croniePamData)
        end

        crontabData = <<-CODE
        SHELL=/bin/bash
        PATH=/sbin:/bin:/usr/sbin:/usr/bin
        MAILTO=root
        HOME=/

        # .---------------- minute (0 - 59)
        # |  .------------- hour (0 - 23)
        # |  |  .---------- day of month (1 - 31)
        # |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
        # |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
        # |  |  |  |  |
        # *  *  *  *  * user-name  command to be executed
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/crontab",crontabData)

        if option("Openrc")
            prepareOpenrcServiceInstallation("#{workDirectoryPath}/Cronie-Init.d","cronie")
        end
    end

end
