class Target < ISM::Software

    def prepare
        super

        fileReplaceText("#{buildDirectoryPath(false)}Makefile.in","manpages: doc/asciidoc.1 doc/a2x.1 doc/testasciidoc.1","manpages: doc/asciidoc.1 doc/a2x.1")
        deleteFile("#{buildDirectoryPath(false)}doc/testasciidoc.1.txt")
    end

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--sysconfdir=/etc",
                            "--docdir=/usr/share/doc/asciidoc-9.1.0"],
                            buildDirectoryPath)
    end

    def build
        super

        makeSource([Ism.settings.makeOptions],buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource([Ism.settings.makeOptions,"DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
        makeSource([Ism.settings.makeOptions,"DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","docs"],buildDirectoryPath)
    end

end
