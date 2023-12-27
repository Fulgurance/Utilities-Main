class Target < ISM::Software
    
    def build
        super

        makeSource(["PREFIX=/usr",
                    "BUILD_STATIC_LIB=0",
                    "MANDIR=/usr/share/man"],
                    path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["PREFIX=/usr",
                    "BUILD_STATIC_LIB=0",
                    "MANDIR=/usr/share/man",
                    "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],
                    path: buildDirectoryPath)
    end

end
