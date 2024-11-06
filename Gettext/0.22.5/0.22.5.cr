class Target < ISM::Software
    
    def configure
        super

        if option("Pass1")
            configureSource(arguments:  "--disable-shared",
                            path:       buildDirectoryPath)
        else
            configureSource(arguments:  "--prefix=/usr      \
                                        --disable-static    \
                                        --docdir=/usr/share/doc/#{versionName}",
                            path:       buildDirectoryPath)
        end
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        if option("Pass1")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/")

            copyDirectory(  "#{buildDirectoryPath}gettext-tools/src/msgfmt",
                            "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/msgfmt")

            copyDirectory(  "#{buildDirectoryPath}gettext-tools/src/msgmerge",
                            "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/msgmerge")

            copyDirectory(  "#{buildDirectoryPath}gettext-tools/src/xgettext",
                            "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/xgettext")
        else
            makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                        path:       buildDirectoryPath)
        end
    end

    def install
        super

        if !option("Pass1")
            runChmodCommand("0755 /usr/lib/preloadable_libintl.so")
        end
    end

end
