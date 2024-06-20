class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr",
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

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/doc/intltool-0.51.0")

        copyFile(   "#{buildDirectoryPath}doc/I18N-HOWTO",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/doc/intltool-0.51.0/I18N-HOWTO")
    end

    def install
        super

        runChmodCommand("0644 /usr/share/doc/intltool-0.51.0/I18N-HOWTO")
    end

end
