class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr          \
                                    --with-tcl=/usr/lib     \
                                    --enable-shared         \
                                    --mandir=/usr/share/man \
                                    --with-tclinclude=/usr/include",
                        path:       buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        makeLink(   target: "expect5.45.4/libexpect5.45.4.so",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib",
                    type:   :symbolicLinkByOverwrite)
    end

end
