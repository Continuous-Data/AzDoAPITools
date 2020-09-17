Deploy Module {
    By PSGalleryModule {
        FromSource AzDoAPITools
        To PSGallery
        WithOptions @{
            
            ApiKey = $ENV:PSGalleryKey
        }
    }
}