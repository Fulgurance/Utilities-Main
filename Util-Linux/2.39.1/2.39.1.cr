class Target < ISM::Software

    def prepare
        super

        if option("Pass1")
            makeDirectory("#{buildDirectoryPath(false)}/var/lib/hwclock")
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
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
