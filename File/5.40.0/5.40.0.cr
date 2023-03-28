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
            makeSource(path: buildDirectoryPath)
            @buildDirectory = false
        else
            super
        end
    end

    def configure
        super

        if option("Pass1")
            configureSource([   "--prefix=/usr",
                                "--host=#{Ism.settings.chrootTarget}",
                                "--build=$(./config.guess)"],
                                buildDirectoryPath)
        else
            configureSource([   "--prefix=/usr"],
                                buildDirectoryPath)
        end
    end

    def build
        super

        if option("Pass1")
            makeSource(["FILE_COMPILE=#{buildDirectoryPath}build/src/file"],buildDirectoryPath)
        else
            makeSource(path: buildDirectoryPath)
        end
    end

    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
