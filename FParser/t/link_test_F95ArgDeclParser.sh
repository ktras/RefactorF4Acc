/usr/bin/gcc -m64 -fno-stack-protector -DTABLES_NEXT_TO_CODE -I. -Qunused-arguments -x assembler -c tmp/ghc59315_0/ghc59315_15.s -o test_F95ArgDeclParser.o
/usr/bin/gcc -m64 -fno-stack-protector -DTABLES_NEXT_TO_CODE -m64 -o test_F95ArgDeclParser -Wl,-no_compact_unwind ../F95VarDeclParser.o ../F95ParserCommon.o ./RunTestWV.o ./NormaliseF95Code.o ./F95ArgDeclParserTestRefs.o test_F95ArgDeclParser.o ../F95Types.o ../F95VarDecl.o ../F95ParDecl.o ../F95SubDecl.o -L/Library/Frameworks/GHC.framework/Versions/7.8.3-x86_64/usr/lib/ghc-7.8.3/process-1.2.0.0 -L/Library/Frameworks/GHC.framework/Versions/7.8.3-x86_64/usr/lib/ghc-7.8.3/directory-1.2.1.0 -L/Library/Frameworks/GHC.framework/Versions/7.8.3-x86_64/usr/lib/ghc-7.8.3/unix-2.7.0.1 -L/Library/Frameworks/GHC.framework/Versions/7.8.3-x86_64/usr/lib/ghc-7.8.3/time-1.4.2 -L/Library/Frameworks/GHC.framework/Versions/7.8.3-x86_64/usr/lib/ghc-7.8.3/old-locale-1.0.0.6 -L/Library/Frameworks/GHC.framework/Versions/7.8.3-x86_64/usr/lib/ghc-7.8.3/filepath-1.3.0.2 -L/Library/Haskell/ghc-7.8.3-x86_64/lib/HUnit-1.2.5.2 -L/Library/Haskell/ghc-7.8.3-x86_64/lib/parsec-3.1.5 -L/Library/Haskell/ghc-7.8.3-x86_64/lib/text-1.1.0.0 -L/Library/Haskell/ghc-7.8.3-x86_64/lib/mtl-2.1.3.1 -L/Library/Frameworks/GHC.framework/Versions/7.8.3-x86_64/usr/lib/ghc-7.8.3/transformers-0.3.0.0 -L/Library/Frameworks/GHC.framework/Versions/7.8.3-x86_64/usr/lib/ghc-7.8.3/containers-0.5.5.1 -L/Library/Frameworks/GHC.framework/Versions/7.8.3-x86_64/usr/lib/ghc-7.8.3/bytestring-0.10.4.0 -L/Library/Frameworks/GHC.framework/Versions/7.8.3-x86_64/usr/lib/ghc-7.8.3/deepseq-1.3.0.2 -L/Library/Frameworks/GHC.framework/Versions/7.8.3-x86_64/usr/lib/ghc-7.8.3/array-0.5.0.0 -L/Library/Frameworks/GHC.framework/Versions/7.8.3-x86_64/usr/lib/ghc-7.8.3/base-4.7.0.1 -L/Library/Frameworks/GHC.framework/Versions/7.8.3-x86_64/usr/lib/ghc-7.8.3/integer-gmp-0.5.1.0 -L/Library/Frameworks/GHC.framework/Versions/7.8.3-x86_64/usr/lib/ghc-7.8.3/ghc-prim-0.3.1.0 -L/Library/Frameworks/GHC.framework/Versions/7.8.3-x86_64/usr/lib/ghc-7.8.3/rts-1.0 tmp/ghc59315_0/ghc59315_18.o -Wl,-u,_ghczmprim_GHCziTypes_Izh_static_info -Wl,-u,_ghczmprim_GHCziTypes_Czh_static_info -Wl,-u,_ghczmprim_GHCziTypes_Fzh_static_info -Wl,-u,_ghczmprim_GHCziTypes_Dzh_static_info -Wl,-u,_base_GHCziPtr_Ptr_static_info -Wl,-u,_ghczmprim_GHCziTypes_Wzh_static_info -Wl,-u,_base_GHCziInt_I8zh_static_info -Wl,-u,_base_GHCziInt_I16zh_static_info -Wl,-u,_base_GHCziInt_I32zh_static_info -Wl,-u,_base_GHCziInt_I64zh_static_info -Wl,-u,_base_GHCziWord_W8zh_static_info -Wl,-u,_base_GHCziWord_W16zh_static_info -Wl,-u,_base_GHCziWord_W32zh_static_info -Wl,-u,_base_GHCziWord_W64zh_static_info -Wl,-u,_base_GHCziStable_StablePtr_static_info -Wl,-u,_ghczmprim_GHCziTypes_Izh_con_info -Wl,-u,_ghczmprim_GHCziTypes_Czh_con_info -Wl,-u,_ghczmprim_GHCziTypes_Fzh_con_info -Wl,-u,_ghczmprim_GHCziTypes_Dzh_con_info -Wl,-u,_base_GHCziPtr_Ptr_con_info -Wl,-u,_base_GHCziPtr_FunPtr_con_info -Wl,-u,_base_GHCziStable_StablePtr_con_info -Wl,-u,_ghczmprim_GHCziTypes_False_closure -Wl,-u,_ghczmprim_GHCziTypes_True_closure -Wl,-u,_base_GHCziPack_unpackCString_closure -Wl,-u,_base_GHCziIOziException_stackOverflow_closure -Wl,-u,_base_GHCziIOziException_heapOverflow_closure -Wl,-u,_base_ControlziExceptionziBase_nonTermination_closure -Wl,-u,_base_GHCziIOziException_blockedIndefinitelyOnMVar_closure -Wl,-u,_base_GHCziIOziException_blockedIndefinitelyOnSTM_closure -Wl,-u,_base_ControlziExceptionziBase_nestedAtomically_closure -Wl,-u,_base_GHCziWeak_runFinalizzerBatch_closure -Wl,-u,_base_GHCziTopHandler_flushStdHandles_closure -Wl,-u,_base_GHCziTopHandler_runIO_closure -Wl,-u,_base_GHCziTopHandler_runNonIO_closure -Wl,-u,_base_GHCziConcziIO_ensureIOManagerIsRunning_closure -Wl,-u,_base_GHCziConcziIO_ioManagerCapabilitiesChanged_closure -Wl,-u,_base_GHCziConcziSync_runSparks_closure -Wl,-u,_base_GHCziConcziSignal_runHandlers_closure -Wl,-search_paths_first -lHSprocess-1.2.0.0 -lHSdirectory-1.2.1.0 -lHSunix-2.7.0.1 -lHStime-1.4.2 -lHSold-locale-1.0.0.6 -lHSfilepath-1.3.0.2 -lHSHUnit-1.2.5.2 -lHSparsec-3.1.5 -lHStext-1.1.0.0 -lHSmtl-2.1.3.1 -lHStransformers-0.3.0.0 -lHScontainers-0.5.5.1 -lHSbytestring-0.10.4.0 -lHSdeepseq-1.3.0.2 -lHSarray-0.5.0.0 -lHSbase-4.7.0.1 -lHSinteger-gmp-0.5.1.0 -lHSghc-prim-0.3.1.0 -lHSrts -lCffi -ldl -liconv -lm -ldl
