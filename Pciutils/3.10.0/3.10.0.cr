class Target < ISM::Software

    def build
        super

        makeSource(["PREFIX=/usr",
                    "SHAREDIR=/usr/share/hwdata",
                    "SHARED=yes"],
                    path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}",
                    "PREFIX=/usr",
                    "SHAREDIR=/usr/share/hwdata",
                    "SHARED=yes","install",
                    "install-lib"],
                    path: buildDirectoryPath)
    end

    def install
        super

        runChmodCommand(["0755","/usr/lib/libpci.so"])
    end

end
