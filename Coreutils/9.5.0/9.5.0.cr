class Target < ISM::Software
    
    def configure
        super

        if option("Pass1")
            configureSource(arguments:  "--prefix=/usr                          \
                                        --host=#{Ism.settings.chrootTarget}     \
                                        --build=#{Ism.settings.chrootTarget}    \
                                        --enable-install-program=hostname       \
                                        --enable-no-install-program=kill,uptime \
                                        gl_cv_macro_MB_CUR_MAX_good=y",
                            path:       buildDirectoryPath)
        else
            runAutoreconfCommand(   arguments:  "-fiv",
                                    path:       buildDirectoryPath)

            configureSource(arguments:      "--prefix=/usr  \
                                            --enable-no-install-program=kill,uptime",
                            path:           buildDirectoryPath,
                            environment:    {"FORCE_UNSAFE_CONFIGURE" => "1"})
        end
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        if option("Pass1")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/sbin")

            moveFile(   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/chroot",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/sbin/chroot")

            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/man/man8")

            moveFile(   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/man/man1/chroot.1",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/man/man8/chroot.8")

            fileReplaceText(path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/man/man8/chroot.8",
                            text:       "\"1\"",
                            newText:    "\"8\"")
        else
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/sbin")

            moveFile(   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/chroot",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/sbin/chroot")

            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/man/man8/")

            moveFile(   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/man/man1/chroot.1",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/man/man8/chroot.8")

            fileReplaceText(path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/man/man8/chroot.8",
                            text:       "\"1\"",
                            newText:    "\"8\"")
        end
    end

end
