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
                            "--with-systemduserunitdir=no",
                            "--with-systemdsystemunitdir=no",
                            "--docdir=/usr/share/doc/dbus-1.12.20",
                            "--with-console-auth-dir=/run/console",
                            "--with-system-pid-file=/run/dbus/pid",
                            "--with-system-socket=/run/dbus/system_bus_socket"],
                            buildDirectoryPath)
    end

    def build
        super

        makeSource([Ism.settings.makeOptions],buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource([Ism.settings.makeOptions,"DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        if option("Openrc")
            makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/init.d")
            moveFile("#{workDirectoryPath(false)}dbus.initd.in","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/init.d/dbus")
            runChmodCommand(["+x","dbus"],"#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/init.d")
        end
    end

    def install
        super

        setOwner("#{Ism.settings.rootPath}usr/libexec/dbus-daemon-launch-helper","root","messagebus")
        setPermissions("#{Ism.settings.rootPath}usr/libexec/dbus-daemon-launch-helper")
        runDbusUuidgenCommand(["--ensure"])
        makeLink("/var/lib/dbus/machine-id","#{Ism.settings.rootPath}etc",:symbolicLink)
    end

end
