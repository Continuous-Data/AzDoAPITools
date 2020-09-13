Deploy Module {
    By PSGalleryModule {
        FromSource BuildOutput\AzDoAPITools
        To PSGallery
        WithOptions @{
            ApiKey = $ENV:PSGalleryKey
        }
    }
}