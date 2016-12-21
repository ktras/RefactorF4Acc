import F95SrcIO
import Test.HUnit
import RunTestWV
import System.Process

read_write src_name = do
    src_lines <- read_F95_src src_name
    write_F95_src ("test_"++src_name) src_lines

getDiff f1 f2 = do
    lst <- readProcess "/usr/bin/diff" ["-u","-i",f1,f2] []
    return lst    

read_write_diff = do
    read_write "module_LES_ocl_TEMPL.f95"
    res <- getDiff "module_LES_ocl_TEMPL.f95" "test_module_LES_ocl_TEMPL.f95"
    assertEqual "Diff" res ""

tests = TestList ["test1" ~: read_write_diff ]

main = runTestWV "F95SrcIO" tests    

