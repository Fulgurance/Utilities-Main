class Target < ISM::Software
    
    def configure
        super

        if option("Pass1")
            configureSource([   "--prefix=#{Ism.settings.rootPath}usr",
                                "--host=#{Ism.settings.target}",
                                "--build=$(build-aux/config.guess)",
                                "--enable-install-program=hostname",
                                "--enable-no-install-program=kill,uptime"],
                                buildDirectoryPath)
        else
            runAutoreconfCommand(["-fiv"],buildDirectoryPath)
            configureSource([   "--prefix=/usr",
                                "--enable-no-install-program=kill,uptime"],
                                buildDirectoryPath,
                                "",
                                {"FORCE_UNSAFE_CONFIGURE" => "1"})
        end
    end
    
    def build
        super

        makeSource([Ism.settings.makeOptions],buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        if option("Pass1")
            makeSource([Ism.settings.makeOptions,"DESTDIR=#{builtSoftwareDirectoryPath}","install"],buildDirectoryPath)
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/sbin")
            moveFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/chroot","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/sbin/chroot")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/man/man8")
            moveFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/man/man1/chroot.1","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/man/man8/chroot.8")
            fileReplaceText("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/man/man8/chroot.8","\"1\"","\"8\"")
        else
            makeSource([Ism.settings.makeOptions,"DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
            makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/sbin")
            moveFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/chroot","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/sbin/chroot")
            makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/man/man8/")
            moveFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/man/man1/chroot.1","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/man/man8/chroot.8")
            fileReplaceText("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/man/man8/chroot.8","\"1\"","\"8\"")
        end
    end

end
