class Target < ISM::Software

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin")
        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/include")
        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib")

        moveFile(   "#{mainWorkDirectoryPath}/snowball",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/snowball")

        moveFile(   "#{mainWorkDirectoryPath}/stemwords",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/stemwords")

        copyFile(   "#{mainWorkDirectoryPath}/include/libstemmer.h",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/include/libstemmer.h")

        moveFile(   "#{mainWorkDirectoryPath}/libstemmer.so",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libstemmer.so")

        moveFile(   "#{mainWorkDirectoryPath}/libstemmer.so.#{majorVersion}",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libstemmer.so.#{majorVersion}")

        version = "#{majorVersion}.#{minorVersion}.#{patchVersion}"

        moveFile(   "#{mainWorkDirectoryPath}/libstemmer.so.#{version}",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libstemmer.so.#{version}")
    end

end
