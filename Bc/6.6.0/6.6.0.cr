class Target < ISM::Software

    def configure
        super

        configureSource(arguments:      "--prefix=/usr  \
                                        -G              \
                                        -O3",
                        path:           buildDirectoryPath,
                        environment:    {"CC" => "gcc"})
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end
