class Target < ISM::Software
    
    def configure
        super

        if option("Pass1")
            configureSource([   "--disable-shared"],
                                buildDirectoryPath)
        else
            configureSource([   "--prefix=/usr",
                                "--disable-static",
                                "--docdir=/usr/share/doc/gettext-0.21"],
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
            makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/")
            copyDirectory("#{buildDirectoryPath(false)}gettext-tools/src/msgfmt","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/msgfmt")
            copyDirectory("#{buildDirectoryPath(false)}gettext-tools/src/msgmerge","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/msgmerge")
            copyDirectory("#{buildDirectoryPath(false)}gettext-tools/src/xgettext","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/xgettext")
        else
            makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
            setPermissions("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/lib/preloadable_libintl.so",0o755)
        end
    end

end
