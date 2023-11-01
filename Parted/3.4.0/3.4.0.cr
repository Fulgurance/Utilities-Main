class Target < ISM::Software

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "#{option("Lvm2") ? "--enable-device-mapper" : "--disable-device-mapper"}",
                            "--disable-static"],
                            buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
