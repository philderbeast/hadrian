module Settings.Packages.IntegerGmp (integerGmpPackageArgs, gmpBuildPath) where

import Base
import GHC
import Oracles.Config.Setting
import Predicate
import Settings.Path

-- TODO: Is this needed?
-- ifeq "$(GMP_PREFER_FRAMEWORK)" "YES"
-- libraries/integer-gmp_CONFIGURE_OPTS += --with-gmp-framework-preferred
-- endif
integerGmpPackageArgs :: Args
integerGmpPackageArgs = package integerGmp ? do
    let includeGmp = "-I" ++ gmpBuildPath -/- "include"
    gmpIncludeDir <- getSetting GmpIncludeDir
    gmpLibDir     <- getSetting GmpLibDir
    mconcat [ builder Cc ? arg includeGmp

            , builder GhcCabal ? mconcat
              [ (null gmpIncludeDir && null gmpLibDir) ?
                arg "--configure-option=--with-intree-gmp"
              , appendSub "--configure-option=CFLAGS" [includeGmp]
              , appendSub "--gcc-options"             [includeGmp] ] ]
