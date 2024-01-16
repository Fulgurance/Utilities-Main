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

        if option("Pass1")
            makeDirectory("#{buildDirectoryPath(false)}/var/lib/hwclock")
        end
    end

    def configure32Bits
        if option("Pass1")
            configureSource([   "ADJTIME_PATH=/var/lib/hwclock/adjtime",
                                "--libdir=/usr/lib32",
                                "--host=i686-#{Ism.settings.targetName}-linux-gnu",
                                "--docdir=/usr/share/doc/util-linux-2.39.1",
                                "--disable-chfn-chsh",
                                "--disable-login",
                                "--disable-nologin",
                                "--disable-su",
                                "--disable-setpriv",
                                "--disable-runuser",
                                "--disable-pylibmount",
                                "--disable-static",
                                "--without-python",
                                "--runstatedir=/run"],
                                path: buildDirectoryPath(entry: "32Bits"),
                                environment: {"CC" =>"gcc -m32"})
        else
            configureSource([   "ADJTIME_PATH=/var/lib/hwclock/adjtime",
                                "--libdir=/usr/lib32",
                                "--host=i686-#{Ism.settings.targetName}-linux-gnu",
                                "--docdir=/usr/share/doc/util-linux-2.39.1",
                                "--disable-chfn-chsh",
                                "--disable-login",
                                "--disable-nologin",
                                "--disable-su",
                                "--disable-setpriv",
                                "--disable-runuser",
                                "--disable-pylibmount",
                                "--disable-static",
                                "--without-python",
                                "--without-systemd",
                                "--without-systemdsystemunitdir"],
                                path: buildDirectoryPath(entry: "32Bits"),
                                environment: {"CC" =>"gcc -m32"})
        end
    end

    def configurex32Bits
        if option("Pass1")
            configureSource([   "ADJTIME_PATH=/var/lib/hwclock/adjtime",
                                "--libdir=/usr/libx32",
                                "--host=#{Ism.settings.target}x32",
                                "--docdir=/usr/share/doc/util-linux-2.39.1",
                                "--disable-chfn-chsh",
                                "--disable-login",
                                "--disable-nologin",
                                "--disable-su",
                                "--disable-setpriv",
                                "--disable-runuser",
                                "--disable-pylibmount",
                                "--disable-static",
                                "--without-python",
                                "--without-systemd",
                                "--without-systemdsystemunitdir"],
                                path: buildDirectoryPath(entry: "x32Bits"),
                                environment: {"CC" =>"gcc -mx32"})
        else

        end
    end

    def configure
        super

        if option("Pass1")
            configureSource([   "ADJTIME_PATH=/var/lib/hwclock/adjtime",
                                "--libdir=/usr/lib",
                                "--docdir=/usr/share/doc/util-linux-2.39.1",
                                "--disable-chfn-chsh",
                                "--disable-login",
                                "--disable-nologin",
                                "--disable-su",
                                "--disable-setpriv",
                                "--disable-runuser",
                                "--disable-pylibmount",
                                "--disable-static",
                                "--without-python",
                                "--runstatedir=/run"],
                                buildDirectoryPath)
        else
            configureSource([   "ADJTIME_PATH=/var/lib/hwclock/adjtime",
                                "--bindir=/usr/bin",
                                "--libdir=/usr/lib",
                                "--docdir=/usr/share/doc/util-linux-2.39.1",
                                "--runstatedir=/run",
                                "--sbindir=/usr/sbin",
                                "--disable-chfn-chsh",
                                "--disable-login",
                                "--disable-nologin",
                                "--disable-su",
                                "--disable-setpriv",
                                "--disable-runuser",
                                "--disable-pylibmount",
                                "--disable-static",
                                "--without-python",
                                "--without-systemd",
                                "--without-systemdsystemunitdir"],
                                buildDirectoryPath)
        end

        if option("32Bits")
            configure32Bits
        end

        if option("x32Bits")
            configurex32Bits
        end
    end

    def build
        super

        makeSource(path: buildDirectoryPath(entry: "mainBuild"))

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
                    path: buildDirectoryPath(entry: "mainBuild"))

        if option("32Bits")
            makeDirectory("#{buildDirectoryPath(false, entry: "32Bits")}/32Bits")
            makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr")

            makeSource( ["DESTDIR=#{buildDirectoryPath(entry: "32Bits")}/32Bits",
                        "install"],
                        path: buildDirectoryPath(entry: "32Bits"))

            copyDirectory(  "#{buildDirectoryPath(false, entry: "32Bits")}/32Bits/usr/lib32",
                            "#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/lib32")
        end

        if option("x32Bits")
            makeDirectory("#{buildDirectoryPath(false, entry: "x32Bits")}/x32Bits")
            makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr")

            makeSource( ["DESTDIR=#{buildDirectoryPath(entry: "x32Bits")}/x32Bits",
                        "install"],
                        path: buildDirectoryPath(entry: "x32Bits"))

            copyDirectory(  "#{buildDirectoryPath(false, entry: "x32Bits")}/x32Bits/usr/libx32",
                            "#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/libx32")
        end
    end

end
