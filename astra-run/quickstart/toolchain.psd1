@{
    LfsInclude = 'speedrun-input/**,astra-output/**'
    Python = '3.13.15'
    Uv = @{
        Version = '0.12.20'
        Url = 'https://github.com/astral-sh/uv/releases/download/0.12.20/uv-x86_64-pc-windows-msvc.zip'
        Sha256 = '95f9bc30fbb3574d276e28ac4a6de932d25153645853d13da8c21eec3bc88d06'
    }
    GitLfs = @{
        Version = '3.8.0'
        Url = 'https://github.com/git-lfs/git-lfs/releases/download/v3.8.0/git-lfs-windows-amd64-v3.8.0.zip'
        Sha256 = 'b62e7b8ceddee635f691233d77de8eaa4b213e9209e0173811d8cfa77f7882c1'
    }
    Node = @{
        Version = '24.21.0'
        Url = 'https://nodejs.org/dist/v24.21.0/node-v24.21.0-win-x64.zip'
        Sha256 = '158f7685b44de51f6c0df1d153526cbcd3e1bc739a8dfc607721cef75de9e541'
    }
}
