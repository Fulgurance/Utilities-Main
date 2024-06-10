class Target < ISM::Software

    def prepare
        if option("Pass1")
            @buildDirectory = true
            super

            configureSource([   "--disable-bzlib",
                                "--disable-libseccomp",
                                "--disable-xzlib",
                                "--disable-zlib"],
                                buildDirectoryPath)
            makeSource(path: buildDirectoryPath)
            @buildDirectory = false
        else
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
    end

    def configure
        super

        if option("Pass1")
            configureSource([   "--prefix=/usr",
                                "--host=#{Ism.settings.chrootTarget}",
                                "--build=$(./config.guess)"],
                                buildDirectoryPath)
        else
            configureSource([   "--prefix=/usr"],
                                path: buildDirectoryPath(entry: "MainBuild"))

            if option("32Bits")
                configureSource([   "--host=i686-#{Ism.settings.targetName}-linux-gnu",
                                    "--prefix=/usr",
                                    "--libdir=/usr/lib32"],
                                    path: buildDirectoryPath(entry: "32Bits"),
                                    environment: {"CC" =>"gcc -m32"})
            end

            if option("x32Bits")
                configureSource([   "--host=#{Ism.settings.target}x32",
                                    "--prefix=/usr",
                                    "--libdir=/usr/libx32"],
                                    path: buildDirectoryPath(entry: "x32Bits"),
                                    environment: {"CC" =>"gcc -mx32"})
            end
        end
    end

    def build
        super

        if option("Pass1")
            makeSource(["FILE_COMPILE=#{buildDirectoryPath(entry: "MainBuild")}/src/file"],buildDirectoryPath)
        else
            makeSource(path: buildDirectoryPath(entry: "MainBuild"))

            if option("32Bits")
                makeSource(path: buildDirectoryPath(entry: "32Bits"))
            end

            if option("x32Bits")
                makeSource(path: buildDirectoryPath(entry: "x32Bits"))
            end
        end
    end

    def prepareInstallation
        super

        makeSource( ["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}",
                    "install"],
                    path: buildDirectoryPath(entry: "MainBuild"))

        if option("Pass1")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/libmagic.la")
        else
            if option("32Bits")
                makeDirectory("#{buildDirectoryPath(false, entry: "32Bits")}/32Bits")
                makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr")

                makeSource( ["DESTDIR=#{buildDirectoryPath(entry: "32Bits")}/32Bits",
                            "install"],
                            path: buildDirectoryPath(entry: "32Bits"))

                copyDirectory(  "#{buildDirectoryPath(false, entry: "32Bits")}/32Bits/usr/lib32",
                                "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib32")
            end

            if option("x32Bits")
                makeDirectory("#{buildDirectoryPath(false, entry: "x32Bits")}/x32Bits")
                makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr")

                makeSource( ["DESTDIR=#{buildDirectoryPath(entry: "x32Bits")}/x32Bits",
                            "install"],
                            path: buildDirectoryPath(entry: "x32Bits"))

                copyDirectory(  "#{buildDirectoryPath(false, entry: "x32Bits")}/x32Bits/usr/libx32",
                                "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/libx32")
            end
        end
    end

end
