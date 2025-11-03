class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr          \
                                    --sysconfdir=/etc       \
                                    --with-curl             \
                                    --disable-static        \
                                    --disable-gtk-doc",
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
