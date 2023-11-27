class Target < ISM::Software

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--docdir=/usr/share/doc/acpid-2.0.34"],
                            buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/acpi/events")

        eventsLidData = <<-CODE
        event=button/lid
        action=/etc/acpi/lid.sh
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/acpi/events/lid",eventsLidData)

        lidData = <<-CODE
        #!/bin/sh
        /bin/grep -q open /proc/acpi/button/lid/LID/state && exit 0
        /usr/sbin/pm-suspend
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/acpi/lid.sh",lidData)
        runChmodCommand(["+x","lid.sh"],"#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/acpi")

        if option("Openrc")
            makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/conf.d")

            acpidData = <<-CODE
            # /etc/conf.d/acpid: config file for /etc/init.d/acpid
            ACPID_ARGS=""
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/conf.d/acpid",acpidData)

            prepareOpenrcServiceInstallation("#{workDirectoryPath(false)}/Acpid-Init.d","acpid")
        end
    end

    def install
        super

        setPermissions("#{Ism.settings.rootPath}etc/acpi/events",0o755)
    end

end
