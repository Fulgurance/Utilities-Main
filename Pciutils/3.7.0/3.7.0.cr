class Target < ISM::Software

    def build
        super

        makeSource(["PREFIX=/usr","SHAREDIR=/usr/share/hwdata","SHARED=yes"],buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","PREFIX=/usr","SHAREDIR=/usr/share/hwdata","SHARED=yes","install","install-lib"],buildDirectoryPath)
    end

    def install
        super

        setPermissions("#{Ism.settings.rootPath}usr/lib/libpci.so",0o755)
    end

end
