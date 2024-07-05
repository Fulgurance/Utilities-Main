class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr      \
                                    --sysconfdir=/etc   \
                                    --with-xz           \
                                    --with-zstd         \
                                    --with-zlib",
                        path:       buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/sbin")
        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin")

        makeLink(   target: "../bin/kmod",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/sbin/depmod",
                    type:   :symbolicLinkByOverwrite)

        makeLink(   target: "../bin/kmod",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/sbin/insmod",
                    type:   :symbolicLinkByOverwrite)

        makeLink(   target: "../bin/kmod",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/sbin/modinfo",
                    type:   :symbolicLinkByOverwrite)

        makeLink(   target: "../bin/kmod",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/sbin/modprobe",
                    type:   :symbolicLinkByOverwrite)

        makeLink(   target: "../bin/kmod",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/sbin/rmmod",
                    type:   :symbolicLinkByOverwrite)

        makeLink(   target: "kmod",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/lsmod",
                    type:   :symbolicLinkByOverwrite)
    end

end
