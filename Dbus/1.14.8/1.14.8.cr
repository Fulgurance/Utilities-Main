class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr                                      \
                                    --sysconfdir=/etc                                   \
                                    --localstatedir=/var                                \
                                    --enable-user-session                               \
                                    --disable-doxygen-docs                              \
                                    --disable-xml-docs                                  \
                                    --disable-static                                    \
                                    --docdir=/usr/share/doc/dbus-1.14.8                 \
                                    --with-console-auth-dir=/run/console                \
                                    --with-system-pid-file=/run/dbus/pid                \
                                    --with-system-socket=/run/dbus/system_bus_socket    \
                                    --with-systemduserunitdir=no                        \
                                    --with-systemdsystemunitdir=no",
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

        if option("Openrc")
            prepareOpenrcServiceInstallation(   path:   "#{workDirectoryPath}/Dbus-Init.d",
                                                name:   "dbus")
        end

        makeLink(   target: "/var/lib/dbus/machine-id",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/machine-id",
                    type:   :symbolicLink)

        deleteDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}no")
    end

    def install
        super

        runChownCommand("root:messagebus /usr/libexec/dbus-daemon-launch-helper")

        runChmodCommand("u+s /usr/libexec/dbus-daemon-launch-helper")

        runDbusUuidgenCommand("--ensure")
    end

end
