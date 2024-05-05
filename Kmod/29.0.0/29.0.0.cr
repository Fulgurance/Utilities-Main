class Target < ISM::Software

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--sysconfdir=/etc",
                            "--with-xz",
                            "--with-zstd",
                            "--with-zlib"],
                            buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        makeLink("../bin/kmod","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/sbin/depmod",:symbolicLinkByOverwrite)
        makeLink("../bin/kmod","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/sbin/insmod",:symbolicLinkByOverwrite)
        makeLink("../bin/kmod","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/sbin/modinfo",:symbolicLinkByOverwrite)
        makeLink("../bin/kmod","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/sbin/modprobe",:symbolicLinkByOverwrite)
        makeLink("../bin/kmod","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/sbin/rmmod",:symbolicLinkByOverwrite)
        makeLink("kmod","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/bin/lsmod",:symbolicLinkByOverwrite)
    end

end
