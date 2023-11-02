class Target < ISM::Software

    def prepare
        super
        fileReplaceText("#{buildDirectoryPath(false)}/gnulib/lib/malloc/dynarray-skeleton.c","__attribute_nonnull__","__nonnull")
    end
    
    def configure
        super
        configureSource([   "--prefix=/usr"],
                            buildDirectoryPath)
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
