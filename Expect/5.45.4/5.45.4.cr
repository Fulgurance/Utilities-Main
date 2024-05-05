class Target < ISM::Software

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--with-tcl=/usr/lib",
                            "--enable-shared",
                            "--mandir=/usr/share/man",
                            "--with-tclinclude=/usr/include"],
                            buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        makeLink("expect5.45.4/libexpect5.45.4.so","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/lib",:symbolicLinkByOverwrite)
    end

end
