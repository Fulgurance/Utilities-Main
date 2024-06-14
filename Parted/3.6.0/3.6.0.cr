class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr                                                              \
                                    #{option("Lvm2") ? "--enable-device-mapper" : "--disable-device-mapper"}    \
                                    --disable-static",
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
    end

end
