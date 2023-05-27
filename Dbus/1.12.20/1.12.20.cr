class Target < ISM::Software

    def prepare
        super

        fileReplaceText("#{workDirectoryPath(false)}/Dbus-Init.d","pidfile=\"@rundir@/dbus.pid\"","pidfile=\"/var/run/dbus/pid\"")
        fileReplaceText("#{workDirectoryPath(false)}/Dbus-Init.d","@rundir@","/var/run")
    end

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--sysconfdir=/etc",
                            "--localstatedir=/var",
                            "--enable-user-session",
                            "--disable-doxygen-docs",
                            "--disable-xml-docs",
                            "--disable-static",
                            "--docdir=/usr/share/doc/dbus-1.12.20",
                            "--with-console-auth-dir=/run/console",
                            "--with-system-pid-file=/run/dbus/pid",
                            "--with-system-socket=/run/dbus/system_bus_socket"],
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
        setPermissions("#{Ism.settings.rootPath}usr/libexec/dbus-daemon-launch-helper",4750)
        runDbusUuidgenCommand(["--ensure"])
        makeLink("/var/lib/dbus/machine-id","#{Ism.settings.rootPath}etc",:symbolicLink)
    end

end
