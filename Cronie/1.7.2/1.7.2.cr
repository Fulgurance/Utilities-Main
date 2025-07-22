class Target < ISM::Software

    def configure
        super

        runFile(file: "autogen.sh",
                path: buildDirectoryPath)

        usingGlibc = component("C-Library").uniqueDependencyIsEnabled("Glibc")

        configureEnvironment = Hash(String,String).new

        if !usingGlibc
            configureEnvironment = {"LIBS" => "-lobstack"}
        end

        configureSource(arguments:      "--prefix=/usr                  \
                                        --localstatedir=/var            \
                                        --with-daemon_username=cronie   \
                                        --with-daemon_groupname=cronie  \
                                        #{option("Linux-Pam") ? "--with-pam" : "--without-pam"}",
                        path:           buildDirectoryPath,
                        environment:    configureEnvironment)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

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
            prepareOpenrcServiceInstallation(   path:   "#{workDirectoryPath}/Cronie-Init.d",
                                                name:   "cronie")
        end
    end

    def deploy
        super

        if autoDeployServices
            if option("Openrc")
                runRcUpdateCommand("add cronie default")
            end
        end
    end

end
