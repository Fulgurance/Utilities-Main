class Target < ISM::Software

    def prepare
        if option("32Bits") || option("x32Bits")
            @buildDirectory = true
        end

        if option("32Bits")
            @buildDirectoryNames["32Bits"] = "mainBuild-32"
        end

        if option("x32Bits")
            @buildDirectoryNames["x32Bits"] = "mainBuild-x32"
        end
        super
    end

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--sysconfdir=/etc",
                            "--with-xz",
                            "--with-zstd",
                            "--with-zlib"],
                            path: buildDirectoryPath(entry: "MainBuild"))

        if option("32Bits")
            configureSource([   "--host=i686-#{Ism.settings.systemTargetName}-linux-gnu",
                                "--prefix=/usr",
                                "--libdir=/usr/lib32",
                                "--sysconfdir=/etc",
                                "--with-openssl",
                                "--with-xz",
                                "--with-zstd",
                                "--with-zlib",
                                "--with-rootlibdir=/usr/lib32"],
                                path: buildDirectoryPath(entry: "32Bits"),
                                environment: {  "CC" =>"gcc -m32"})
        end

        if option("x32Bits")
            configureSource([   "--host=#{Ism.settings.systemTarget}x32",
                                "--prefix=/usr",
                                "--libdir=/usr/libx32",
                                "--sysconfdir=/etc",
                                "--with-openssl",
                                "--with-xz",
                                "--with-zstd",
                                "--with-zlib",
                                "--with-rootlibdir=/usr/xlib32"],
                                path: buildDirectoryPath(entry: "x32Bits"),
                                environment: {  "CC" =>"gcc -mx32"})
        end
    end

    def build
        super

        makeSource(path: buildDirectoryPath(entry: "MainBuild"))

        if option("32Bits")
            makeSource(path: buildDirectoryPath(entry: "32Bits"))
        end

        if option("x32Bits")
            makeSource(path: buildDirectoryPath(entry: "x32Bits"))
        end
    end

    def prepareInstallation
        super

        makeSource( ["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}",
                    "install"],
                    path: buildDirectoryPath(entry: "MainBuild"))

        if option("32Bits")
            makeDirectory("#{buildDirectoryPath(entry: "32Bits")}/32Bits")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr")

            makeSource( ["DESTDIR=#{buildDirectoryPath(entry: "32Bits")}/32Bits",
                        "install"],
                        path: buildDirectoryPath(entry: "32Bits"))

            copyDirectory(  "#{buildDirectoryPath(entry: "32Bits")}/32Bits/usr/lib32",
                            "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib32")
        end

        if option("x32Bits")
            makeDirectory("#{buildDirectoryPath(entry: "x32Bits")}/x32Bits")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr")

            makeSource( ["DESTDIR=#{buildDirectoryPath(entry: "x32Bits")}/x32Bits",
                        "install"],
                        path: buildDirectoryPath(entry: "x32Bits"))

            copyDirectory(  "#{buildDirectoryPath(entry: "x32Bits")}/x32Bits/usr/libx32",
                            "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/libx32")
        end

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/sbin")
        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin")

        makeLink("../bin/kmod","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/sbin/depmod",:symbolicLinkByOverwrite)
        makeLink("../bin/kmod","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/sbin/insmod",:symbolicLinkByOverwrite)
        makeLink("../bin/kmod","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/sbin/modinfo",:symbolicLinkByOverwrite)
        makeLink("../bin/kmod","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/sbin/modprobe",:symbolicLinkByOverwrite)
        makeLink("../bin/kmod","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/sbin/rmmod",:symbolicLinkByOverwrite)
        makeLink("kmod","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/lsmod",:symbolicLinkByOverwrite)
    end

end
