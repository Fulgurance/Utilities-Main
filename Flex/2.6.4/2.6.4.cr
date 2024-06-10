class Target < ISM::Software

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--docdir=/usr/share/doc/flex-2.6.4",
                            "--disable-static"],
                            buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        makeLink("flex","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/lex",:symbolicLink)
    end

end
