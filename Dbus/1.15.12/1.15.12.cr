class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runMesonCommand(arguments:  "setup                                                  \
                                    --reconfigure                                           \
                                    #{@buildDirectoryNames["MainBuild"]}                    \
                                    --prefix=/usr                                           \
                                    --localstatedir=/var                                    \
                                    -Dxml_docs=disabled                                     \
                                    -Ddoxygen_docs=disabled                                 \
                                    -Dducktype_docs=disabled                                \
                                    -Ddbus_user=messagebus                                  \
                                    -Dembedded_tests=false                                  \
                                    -Dinstalled_tests=false                                 \
                                    -Dsystem_pid_file=/run/dbus/dbus.pid                    \
                                    -Dsystem_socket=/run/dbus/system_bus_socket",
                        path:       mainWorkDirectoryPath)
    end

    def build
        super

        runNinjaCommand(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        runNinjaCommand(arguments:      "install",
                        path:           buildDirectoryPath,
                        environment:    {"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})

        if option("Openrc")
            prepareOpenrcServiceInstallation(   path:   "#{workDirectoryPath}/Dbus-Init.d",
                                                name:   "dbus")
        end

        makeLink(   target: "/var/lib/dbus/machine-id",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/machine-id",
                    type:   :symbolicLink)
    end

    def install
        super

        runDbusUuidgenCommand("--ensure")
    end

    def deploy
        if autoDeployServices
            if option("Openrc")
                runRcUpdateCommand("add dbus default")
            end
        end
    end

end
