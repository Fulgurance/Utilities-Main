class Target < ISM::Software

    def prepare
        if option("Pass1")
            @buildDirectory = true
            super
            configureSource([   "--disable-bzlib",
                                "--disable-libseccomp",
                                "--disable-xzlib",
                                "--disable-zlib"],
                                buildDirectoryPath)
            makeSource([Ism.settings.makeOptions],buildDirectoryPath)
            @buildDirectory = false
        else
            super
        end
    end

    def configure
        super

        if option("Pass1")
            configureSource([   "--prefix=/usr",
                                "--host=#{Ism.settings.target}",
                                "--build=#{Ism.settings.target}"],
                                buildDirectoryPath)
        else
            configureSource([   "--prefix=/usr"],
                                buildDirectoryPath)
        end
    end

    def build
        super

        if option("Pass1")
            makeSource([Ism.settings.makeOptions,"FILE_COMPILE=#{buildDirectoryPath}build/src/file"],buildDirectoryPath)
        else
            makeSource([Ism.settings.makeOptions],buildDirectoryPath)
        end
    end

    def prepareInstallation
        super

        makeSource([Ism.settings.makeOptions,"DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
