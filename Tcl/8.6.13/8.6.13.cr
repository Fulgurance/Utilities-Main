class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr  \
                                    --mandir=/usr/share/man",
                        path:       "#{buildDirectoryPath}/unix")
    end

    def build
        super

        makeSource(path: "#{buildDirectoryPath}/unix")
    end

    def prepareInstallation
        super

        fileReplaceText(path:       "#{buildDirectoryPath}unix/tclConfig.sh",
                        text:       "#{buildDirectoryPath}unix",
                        newText:    "/usr/lib")

        fileReplaceText(path:       "#{buildDirectoryPath}unix/tclConfig.sh",
                        text:       "#{buildDirectoryPath}",
                        newText:    "/usr/include")

        fileReplaceText(path:       "#{buildDirectoryPath}unix/pkgs/tdbc1.1.5/tdbcConfig.sh",
                        text:       "#{buildDirectoryPath}unix/pkgs/tdbc1.1.5",
                        newText:    "/usr/lib/tdbc1.1.5")

        fileReplaceText(path:       "#{buildDirectoryPath}unix/pkgs/tdbc1.1.5/tdbcConfig.sh",
                        text:       "#{buildDirectoryPath}pkgs/tdbc1.1.5/generic",
                        newText:    "/usr/include")

        fileReplaceText(path:       "#{buildDirectoryPath}unix/pkgs/tdbc1.1.5/tdbcConfig.sh",
                        text:       "#{buildDirectoryPath}pkgs/tdbc1.1.5/library",
                        newText:    "/usr/lib/tcl8.6")

        fileReplaceText(path:       "#{buildDirectoryPath}unix/pkgs/tdbc1.1.5/tdbcConfig.sh",
                        text:       "#{buildDirectoryPath}pkgs/tdbc1.1.5",
                        newText:    "/usr/include")

        fileReplaceText(path:       "#{buildDirectoryPath}unix/pkgs/itcl4.2.3/itclConfig.sh",
                        text:       "#{buildDirectoryPath}unix/pkgs/itcl4.2.3",
                        newText:    "/usr/lib/itcl4.2.3")

        fileReplaceText(path:       "#{buildDirectoryPath}unix/pkgs/itcl4.2.3/itclConfig.sh",
                        text:       "#{buildDirectoryPath}pkgs/itcl4.2.3/generic",
                        newText:    "/usr/include")

        fileReplaceText(path:       "#{buildDirectoryPath}unix/pkgs/itcl4.2.3/itclConfig.sh",
                        text:       "#{buildDirectoryPath}pkgs/itcl4.2.3",
                        newText:    "/usr/include")

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} install",
                    path:       "#{buildDirectoryPath}/unix")

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install-private-headers",
                    path:       "#{buildDirectoryPath}unix")

        moveFile(   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/man/man3/Thread.3",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/man/man3/Tcl_Thread.3")

        makeLink(   target: "tclsh8.6",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/tclsh",
                    type:   :symbolicLinkByOverwrite)
    end

    def deploy
        super

        runChownCommand("root:root /usr/lib/libtcl8.6.so")
        runChmodCommand("0644 /usr/lib/libtcl8.6.so")
    end

end
