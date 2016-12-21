-- Code generated by F95StatementParser_ffi_wrapper_gen
{-# LANGUAGE ForeignFunctionInterface #-}

module F95StatementParserFFIWrapper where

import Foreign.C.Types
import Foreign.C.String
import FFIGenerator.ShowToPerl
import Data.Map
import F95StatementParser


foreign export ccall parseF95Statement_ffi :: CString -> IO CString
foreign export ccall parseF95Decl_ffi :: CString -> IO CString

parseF95Statement_ffi :: CString -> IO CString
parseF95Statement_ffi cstr = do
        str <- peekCString cstr
        let
            argtup :: [Char]
            argtup = read str
            x1 = argtup
            retval =  parseF95Statement x1
            retval_str = showToPerl $ show retval
        cstr' <- newCString retval_str
        return cstr'

parseF95Decl_ffi :: CString -> IO CString
parseF95Decl_ffi cstr = do
        str <- peekCString cstr
        let
            argtup :: [Char]
            argtup = read str
            x1 = argtup
            retval =  parseF95Decl x1
            retval_str = showToPerl $ show retval
        cstr' <- newCString retval_str
        return cstr'


