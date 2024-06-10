class Target < ISM::Software

    def configure
        super

        configureSource([   "--libdir=/usr/lib",
                            "--disable-systemd",
                            "--with-rcdir=/tmp/cupsinit",
                            "--with-rundir=/run/cups",
                            "--with-system-groups=lpadmin",
                            "--with-docdir=/usr/share/cups/doc-2.4.6"],
                            buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        deleteDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}tmp")

        deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/cups.desktop")

        clientConfData = <<-CODE
        ServerName /run/cups/cups.sock
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/cups/client.conf",clientConfData)

        if option("Linux-Pam")
            cupsData = <<-CODE
            auth    include system-auth
            account include system-account
            session include system-session
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d/cups",cupsData)
        end

        if option("Openrc")
            prepareOpenrcServiceInstallation("#{workDirectoryPath}/Cups-Init.d","cups")
        end

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/doc")

        makeLink("../cups/doc-2.4.6","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/doc/cups-2.4.6",:symbolicLinkByOverwrite)
    end

end
