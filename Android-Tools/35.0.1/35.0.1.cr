class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runCmakeCommand(arguments:      "-DCMAKE_INSTALL_PREFIX=/usr            \
                                        -DCMAKE_BUILD_TYPE=Release              \
                                        -DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON   \
                                        -Dprotobuf_MODULE_COMPATIBLE=ON         \
                                        -DANDROID_TOOLS_LIBUSB_ENABLE_UDEV=ON   \
                                        -DANDROID_TOOLS_USE_BUNDLED_LIBUSB=ON   \
                                        -B #{buildDirectoryPath}                \
                                        -G Ninja",
                        path:           mainWorkDirectoryPath)
    end

    def build
        super

        runCmakeCommand(arguments:      "--build #{buildDirectoryPath}",
                        path:           mainWorkDirectoryPath)
    end

    def prepareInstallation
        super

        runCmakeCommand(arguments:      "--install #{buildDirectoryPath}",
                        path:           mainWorkDirectoryPath,
                        environment:    {"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})
    end

end
