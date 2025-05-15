class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runMesonCommand(arguments:  "setup                                  \
                                    --reconfigure                           \
                                    #{@buildDirectoryNames["MainBuild"]}    \
                                    --prefix=/usr                           \
                                    --buildtype=release                     \
                                    -Dgtk_doc=false                         \
                                    -Dtests=false                           \
                                    -Dsystemdsystemunitdir=no",
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
            prepareOpenrcServiceInstallation(   path:   "#{workDirectoryPath}/Power-Profiles-Daemon-Init.d",
                                                name:   "power-profiles-daemon")
        else
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/no")
        end
    end

    def deploy
        if autoDeployServices
            if option("Openrc")
                runRcUpdateCommand("add power-profiles-daemon default")
            end
        end
    end

end
