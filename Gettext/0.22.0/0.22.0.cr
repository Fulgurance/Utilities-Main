class Target < ISM::Software
    
    def configure
        super

        if option("Pass1")
            configureSource([   "--disable-shared"],
                                buildDirectoryPath)
        else
            configureSource([   "--prefix=/usr",
                                "--disable-static",
                                "--docdir=/usr/share/doc/gettext-0.22"],
                                buildDirectoryPath)
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
            copyDirectory("#{buildDirectoryPath}gettext-tools/src/msgfmt","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/msgfmt")
            copyDirectory("#{buildDirectoryPath}gettext-tools/src/msgmerge","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/msgmerge")
            copyDirectory("#{buildDirectoryPath}gettext-tools/src/xgettext","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/xgettext")
        else
            makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
            setPermissions("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/preloadable_libintl.so",0o755)
        end
    end

end
