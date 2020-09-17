Deploy Module {
    By PSGalleryModule {
        FromSource AzDoAPITools
        To PSGallery
        WithOptions @{
            
            nugetApiKey = $ENV:PSGalleryKey
        }
    }
}