class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runMesonCommand(arguments:  "setup                                              \
                                    --reconfigure                                       \
                                    #{@buildDirectoryNames["MainBuild"]}                \
                                    --prefix=/usr                                       \
                                    --buildtype=release                                 \
                                    -Dusb=#{option("Libusb") ? "true" : "false"}        \
                                    -Dcompile_server=false",
                            path: mainWorkDirectoryPath)
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
    end

end
