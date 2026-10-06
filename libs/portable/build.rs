fn main() {
    #[cfg(windows)]
    {
        use std::io::Write;
        let mut res = winres::WindowsResource::new();
        res.set_icon("../../res/icon.ico")
            .set("CompanyName", "Easy Cloud ERP")
            .set("ProductName", "Easy Cloud Remote")
            .set("FileDescription", "Easy Cloud Remote Desktop")
            .set("LegalCopyright", "Copyright (c) 2026 Easy Cloud ERP")
            .set("OriginalFilename", "EasyCloudRemote.exe")
            .set("InternalName", "EasyCloudRemote")
            .set_language(winapi::um::winnt::MAKELANGID(
                winapi::um::winnt::LANG_ENGLISH,
                winapi::um::winnt::SUBLANG_ENGLISH_US,
            ))
            .set_manifest_file("../../res/manifest.xml");
        match res.compile() {
            Err(e) => {
                write!(std::io::stderr(), "{}", e).unwrap();
                std::process::exit(1);
            }
            Ok(_) => {}
        }
    }
}
