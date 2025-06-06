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
                                    -Dprebuilt_server=scrcpy-server.apk                 \
                                    -Dusb=#{option("Libusb") ? "true" : "false"}",
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

        deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/share/applications/scrcpy-console.desktop")
        deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/share/applications/scrcpy.desktop")
    end

end
