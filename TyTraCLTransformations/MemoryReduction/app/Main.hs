module Main where
import TyTraCLAST 
import ASTInstance (ast,functionSignaturesList)
import Transforms (splitLhsTuples, substituteVectors, applyRewriteRules, fuseStencils, decomposeExpressions)
import CodeGeneration (inferSignatures, generateSignatures, createStages, generateDefs, generateStageKernel)

ast1 = splitLhsTuples ast
ast2 = substituteVectors ast1
ast3 = applyRewriteRules ast2
ast3' = fuseStencils ast3
ast4 = decomposeExpressions ast3'
generatedSignatures = map generateSignatures ast4
inferedSignatures :: [[(Name,FSig)]]
inferedSignatures = map inferSignatures ast4
-- generatedDefs = map generateDefs ast4

(asts_function_defs,ast_stages) = createStages ast4
generatedDefs = map generateDefs asts_function_defs
generatedStageKernels = map (\(ast,ct) -> generateStageKernel ct ast) (zip ast_stages [1..])

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
    -- putStrLn "\n-- Decompose expressions"
    -- mapM_ ( \x -> (putStrLn ("-- " ++ ((show . LHSPrint . fst . head) x)) >> mapM print x )  ) ast4
    -- putStrLn "\n-- Infer intermediate function signatures"
    -- mapM_ ( \x -> (putStrLn "-- "  >> mapM print x )  ) inferedSignatures 
    putStrLn "\n-- Decompose expressions and Infer intermediate function signatures"
    putStrLn "-- Original function signatures"
    mapM_ print functionSignaturesList
    putStrLn "-- Decompose expressions and infered function signatures"
    mapM_ ( \(x1,x2) -> do
        putStrLn ("-- " ++ ((show . LHSPrint . fst . head) x1))
        putStrLn "-- Decomposed expressions"
        mapM print x1   
        putStrLn "-- Infered function signatures"
        mapM print x2
        ) (zip ast4 inferedSignatures)
    putStrLn "\n-- Generate subroutine definitions"
    mapM_ putStrLn (map (\(ls,ct) -> unlines (["! Stage "++(show ct)]++ls)) (zip generatedDefs [1..]))
    putStrLn "\n-- Generated stage kernels"
    mapM_ (putStrLn . unlines) generatedStageKernels
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
