class Target < ISM::Software

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--sysconfdir=/etc",
                            "--localstatedir=/var",
                            "--enable-user-session",
                            "--disable-doxygen-docs",
                            "--disable-xml-docs",
                            "--disable-static",
                            "--docdir=/usr/share/doc/dbus-1.14.8",
                            "--with-console-auth-dir=/run/console",
                            "--with-system-pid-file=/run/dbus/pid",
                            "--with-system-socket=/run/dbus/system_bus_socket",
                            "--with-systemduserunitdir=no",
                            "--with-systemdsystemunitdir=no"],
                            buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        if option("Openrc")
            prepareOpenrcServiceInstallation("#{workDirectoryPath(false)}/Dbus-Init.d","dbus")
        end
    end

    def install
        super

        setOwner("#{Ism.settings.rootPath}usr/libexec/dbus-daemon-launch-helper","root","messagebus")
        runChmodCommand(["u+s","/usr/libexec/dbus-daemon-launch-helper"])
        runDbusUuidgenCommand(["--ensure"])
        makeLink("/var/lib/dbus/machine-id","#{Ism.settings.rootPath}etc",:symbolicLink)
    end

end
