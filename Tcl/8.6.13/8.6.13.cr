class Target < ISM::Software

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--mandir=/usr/share/man"],
                            "#{buildDirectoryPath}unix")
    end

    def build
        super

        makeSource(path: "#{buildDirectoryPath}/unix")
    end

    def prepareInstallation
        super

        fileReplaceText("#{buildDirectoryPath}unix/tclConfig.sh","#{buildDirectoryPath}unix","/usr/lib")
        fileReplaceText("#{buildDirectoryPath}unix/tclConfig.sh","#{buildDirectoryPath}","/usr/include")
        fileReplaceText("#{buildDirectoryPath}unix/pkgs/tdbc1.1.5/tdbcConfig.sh","#{buildDirectoryPath}unix/pkgs/tdbc1.1.5","/usr/lib/tdbc1.1.5")
        fileReplaceText("#{buildDirectoryPath}unix/pkgs/tdbc1.1.5/tdbcConfig.sh","#{buildDirectoryPath}pkgs/tdbc1.1.5/generic","/usr/include")
        fileReplaceText("#{buildDirectoryPath}unix/pkgs/tdbc1.1.5/tdbcConfig.sh","#{buildDirectoryPath}pkgs/tdbc1.1.5/library","/usr/lib/tcl8.6")
        fileReplaceText("#{buildDirectoryPath}unix/pkgs/tdbc1.1.5/tdbcConfig.sh","#{buildDirectoryPath}pkgs/tdbc1.1.5","/usr/include")
        fileReplaceText("#{buildDirectoryPath}unix/pkgs/itcl4.2.3/itclConfig.sh","#{buildDirectoryPath}unix/pkgs/itcl4.2.3","/usr/lib/itcl4.2.3")
        fileReplaceText("#{buildDirectoryPath}unix/pkgs/itcl4.2.3/itclConfig.sh","#{buildDirectoryPath}pkgs/itcl4.2.3/generic","/usr/include")
        fileReplaceText("#{buildDirectoryPath}unix/pkgs/itcl4.2.3/itclConfig.sh","#{buildDirectoryPath}pkgs/itcl4.2.3","/usr/include")

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],"#{buildDirectoryPath}/unix")

        setPermissions("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libtcl8.6.so",0o644)

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install-private-headers"],"#{buildDirectoryPath}unix")

        moveFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/man/man3/Thread.3","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/man/man3/Tcl_Thread.3")

        makeLink("tclsh8.6","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/tclsh",:symbolicLinkByOverwrite)
    end

end
