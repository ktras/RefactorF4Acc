module Main where
import TyTraCLAST 
import ASTInstance (ast)
import Transforms (splitLhsTuples, substituteVectors, applyRewriteRules, fuseStencils, decomposeExpressions)
import CodeGeneration (inferSignatures)

ast1 = splitLhsTuples ast
ast2 = substituteVectors ast1
ast3 = applyRewriteRules ast2
ast3' = fuseStencils ast3
ast4 = decomposeExpressions ast3'
inferSignatures' = map  inferSignatures ast4
main = do
    putStrLn "-- Original AST"
    mapM_ print ast
    putStrLn "\n-- Split LHS tuples"
    mapM_ print ast1
    putStrLn "\n-- Substitute vectors (recursive)"
    mapM_ print ast2
    putStrLn "\n-- Apply rewrite rules"
    mapM_ print ast3
    putStrLn "\n-- Fuse stencils"
    mapM_ print ast3'    
-- --    mapM print map_checks
    putStrLn "\n-- Decompose expressions"
    mapM_ ( \x -> (putStrLn ("-- " ++ ((show . LHSPrint . fst . head) x)) >> mapM print x )  ) ast4
    putStrLn "\n-- Infer intermediate function signatures"
    mapM_ ( \x -> (putStrLn "-- "  >> mapM print x )  ) inferSignatures' 
    -- mapM_ ( mapM print) inferSignatures' 
{-    
    putStrLn "\nTest for Vec in RHS Expr"
    mapM (print . get_vec_subexprs . snd) ast''
    putStrLn "\nTest for non-input Vec in RHS Expr"
    mapM (print . expr_has_non_input_vecs . snd) ast'
    putStrLn "\nTest for non-input Vec in RHS Expr"
    mapM (print . expr_has_non_input_vecs . snd) ast''
    -- Tests for bottom-up reduction using everywhere
    print ll
    print (reduce_ll ll)
    print (reduce_tree tree)
--    print $ find_in_ast ast' (Vec VT "duu_1")
-}
