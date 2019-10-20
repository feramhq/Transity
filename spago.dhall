{ name = "transity"
, dependencies =
    [ "ansi"
    , "argonaut-codecs"
    , "bigints"
    , "console"
    , "console"
    , "debug"
    , "effect"
    , "either"
    , "format"
    , "formatters"
    , "js-date"
    , "node-buffer"
    , "node-fs"
    , "node-process"
    , "ordered-collections"
    , "prelude"
    , "psci-support"
    , "psci-support"
    , "rationals"
    , "result"
    , "spec"
    , "strings"
    , "yaml"
    ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}