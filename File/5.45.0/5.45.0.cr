class Target < ISM::Software

    def prepare
        if option("Pass1")
            @buildDirectory = true
            super

            configureSource(arguments:  "--disable-bzlib        \
                                        --disable-libseccomp    \
                                        --disable-xzlib         \
                                        --disable-zlib",
                            path:       buildDirectoryPath)

            makeSource(path: buildDirectoryPath)

            @buildDirectory = false
        end
    end

    def configure
        super

        if option("Pass1")
            configureSource(arguments:  "--prefix=/usr                      \
                                        --host=#{Ism.settings.chrootTarget} \
                                        --build=#{Ism.settings.chrootTarget}",
                            path:       buildDirectoryPath)
        else
            configureSource(arguments:  "--prefix=/usr",
                            path:       buildDirectoryPath)
        end
    end

    def build
        super

        if option("Pass1")
            makeSource( arguments:  "FILE_COMPILE=#{buildDirectoryPath}/src/file",
                        path:       buildDirectoryPath)
        else
            makeSource(path: buildDirectoryPath)
        end
    end

    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        if option("Pass1")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libmagic.la")
        end
    end

end
