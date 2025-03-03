class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr  \
                                    --docdir=/usr/share/doc/acpid-2.0.34",
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

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/acpi/events")

        eventsLidData = <<-CODE
        event=button/lid
        action=/etc/acpi/lid.sh
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/acpi/events/lid",eventsLidData)

        lidData = <<-CODE
        #!/bin/sh
        /bin/grep -q open /proc/acpi/button/lid/LID/state && exit 0
        /usr/sbin/pm-suspend
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/acpi/lid.sh",lidData)

        if option("Openrc")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/conf.d")

            acpidData = <<-CODE
            # /etc/conf.d/acpid: config file for /etc/init.d/acpid
            ACPID_ARGS=""
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/conf.d/acpid",acpidData)

            prepareOpenrcServiceInstallation(   path:   "#{workDirectoryPath}/Acpid-Init.d",
                                                name:   "acpid")
        end
    end

end
