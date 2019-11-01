module ASTInstance ( ast
        , functionSignaturesList
        , stencilDefinitionsList
        , mainArgDeclsList 
        , scalarisedArgsList
        , origNamesList
        ) where
import TyTraCLAST

ast :: TyTraCLAST
ast = [
            ( Scalar VT DInt "acc_1", Fold (Function "f1" []) (Scalar VI DInt "acc_0") (Vec VI (Scalar VI DInt "v_0")) )
        ,(Vec VS (SVec 3 (Scalar VDC DInt "v_s_0" )) , Stencil (SVec 3 (Scalar VDC DInt "s1")) (Vec VI (Scalar VI DInt "v_0")))
        ,( Vec VO (Scalar VDC DInt "v_1"), Map (Function "f2"  [Scalar VT DInt "acc_1"]) (Vec VS (SVec 3 (Scalar VDC DInt "v_s_0"))) )
        ]

functionSignaturesList = [
        ("f1",  [Tuple [],Scalar VDC DInt "acc_0",Scalar VDC DInt "v_0",Scalar VDC DInt "acc_1"]),
        ("f2",  [Scalar VDC DInt "acc_1",SVec 3 (Scalar VDC DInt "v_s_0"),Scalar VDC DInt "v_1"])
    ]
stencilDefinitionsList = [("s1" , [-1,0,1] )]

mainArgDeclsList = [
      ("v_0" , MkFDecl "integer"  (Just [500]) (Just In) ["v_0"] )
    , ("acc_0" , MkFDecl "integer" Nothing (Just In) ["acc_0"] )
    , ("v_1" , MkFDecl "integer"  (Just [500]) (Just Out) ["v_1"] )
  ]
scalarisedArgsList = []
origNamesList = []