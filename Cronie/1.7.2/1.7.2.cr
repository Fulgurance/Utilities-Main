class Target < ISM::Software

    def configure
        super

        runScript("autogen.sh", path: buildDirectoryPath)

        configureSource([   "--prefix=/usr",
                            "#{option("Linux-Pam") ? "--with-pam" : "--without-pam"}"],
                            path: buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        if option("Openrc")
            prepareOpenrcServiceInstallation("#{workDirectoryPath(false)}/Cronie-Init.d","cronie")
        end
    end

end
