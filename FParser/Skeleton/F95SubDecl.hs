module F95SubDecl (
        SubDecl
        )
    where
import F95VarDecl

data SubDecl = MkSubDecl {
	sd_name :: String
    ,sd_arglst :: [String]
    ,sd_argdecls :: [VarDecl]
    ,sd_code :: [String]
} deriving (Eq, Ord, Show)


