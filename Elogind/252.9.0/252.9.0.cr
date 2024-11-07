class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runMesonCommand(arguments:  "setup                                  \
                                    --reconfigure                           \
                                    #{@buildDirectoryNames["MainBuild"]}    \
                                    --prefix=/usr                           \
                                    --buildtype=release                     \
                                    -Dman=auto                              \
                                    -Ddocdir=/usr/share/doc/#{versionName}   \
                                    -Dcgroup-controller=elogind             \
                                    -Ddbuspolicydir=/etc/dbus-1/system.d",
                        path:       mainWorkDirectoryPath)
    end

    def build
        super

        runNinjaCommand(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        runNinjaCommand(arguments:      "install",
                        path:           buildDirectoryPath,
                        environment:    {"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})

        fileReplaceTextAtLineNumber(path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/elogind/logind.conf",
                                    text:       "#KillUserProcesses=yes",
                                    newText:    "KillUserProcesses=no",
                                    lineNumber: 15)

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d")
        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/conf.d")

        if File.exists?("#{Ism.settings.rootPath}etc/pam.d/system-session")
            copyFile(   "/etc/pam.d/system-session",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d/system-session")
        else
            generateEmptyFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d/system-session")
        end

        systemSessionData = <<-CODE
        session  required    pam_loginuid.so
        session  optional    pam_elogind.so
        CODE
        fileUpdateContent("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d/system-session",systemSessionData)

        elogindUserData = <<-CODE
        account  required    pam_access.so
        account  include     system-account

        session  required    pam_env.so
        session  required    pam_limits.so
        session  required    pam_unix.so
        session  required    pam_loginuid.so
        session  optional    pam_keyinit.so force revoke
        session  optional    pam_elogind.so

        auth     required    pam_deny.so
        password required    pam_deny.so
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d/elogind-user",elogindUserData)

        elogindConfData = <<-CODE
        ELOGIND_EXEC=/usr/lib/elogind/elogind
        ELOGIND_PIDFILE=/var/run/elogind.pid
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/conf.d/elogind",elogindConfData)

        if option("Openrc")
            prepareOpenrcServiceInstallation(   path:   "#{workDirectoryPath}/Elogind-Init.d",
                                                name:   "elogind")
        end

        makeLink(   target: "libelogind.pc",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib64/pkgconfig/libsystemd.pc",
                    type:   :symbolicLinkByOverwrite)

        makeLink(   target: "elogind",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/include/systemd",
                    type:   :symbolicLinkByOverwrite)
    end

end
