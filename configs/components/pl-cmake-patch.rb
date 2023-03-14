# OpenSSL 3 introduced a new versioning scheme. CMake < 3.18 doesn't
# understand the new scheme and will fail to `FindOpenSSL`. So patch
# cmake on platforms that need it. However, I wasn't able to just
# use the latest version of FindOpenSSL.cmake, so apply cherry-picked
# commits
component 'pl-cmake-patch' do |pkg, settings, platform|
  if platform.is_windows?
    pkg.add_source 'file://patches/cmake/0001-FindOpenSSL-Tolerate-tabs-in-header-while-parsing-ve.patch'
    pkg.add_source 'file://patches/cmake/0002-FindOpenSSL-Do-not-assume-that-the-version-regex-fin.patch'
    pkg.add_source 'file://patches/cmake/0003-FindOpenSSL-Detect-OpenSSL-3.0.0.patch'
    pkg.add_source 'file://patches/cmake/0004-FindOpenSSL-Fix-OpenSSL-3.0.0-version-extraction.patch'

    modules = "#{settings[:chocolatey_lib]}/cmake/content/cmake-3.2.2-win32-x86/share/cmake-3.2"
    patch_options = '--strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch'
    unix2dos = 'awk -v ORS="\r\n" 1'
    pkg.configure do
      [
        %(#{unix2dos} 0001-FindOpenSSL-Tolerate-tabs-in-header-while-parsing-ve.patch | #{platform[:patch]} #{patch_options} --dir $(shell cygpath -u #{modules})),
        %(#{unix2dos} 0002-FindOpenSSL-Do-not-assume-that-the-version-regex-fin.patch | #{platform[:patch]} #{patch_options} --dir $(shell cygpath -u #{modules})),
        %(#{unix2dos} 0003-FindOpenSSL-Detect-OpenSSL-3.0.0.patch                     | #{platform[:patch]} #{patch_options} --dir $(shell cygpath -u #{modules})),
        %(#{unix2dos} 0004-FindOpenSSL-Fix-OpenSSL-3.0.0-version-extraction.patch     | #{platform[:patch]} #{patch_options} --dir $(shell cygpath -u #{modules}))
      ]
    end
  end
end
