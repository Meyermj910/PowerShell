



$newManifestParams = @{
    RequiredModules = 'ActiveDirectory'
    PowerShellVersion = '5.1'
    Author = 'Joshua Meyer'
    FunctionsToExport = 'LIST_OF_FUNCTIONS_CREATED_IN_THE_MODULE_FILE'
    CompanyName = 'COMPANYS_NAME_OR_PERSONAL_PREFERENCE'
    Description = 'This module provides a basic tool set, Help Desk advisors can use to make their jobs easier'
    CompatiblePSEditions = @('Desktop','Core')
    Path = 'FILE_LOCATION_FOR_THE_MANIFEST'
    RootModule = 'HelpDesk'
}

New-ModuleManifest @newManifestParams

