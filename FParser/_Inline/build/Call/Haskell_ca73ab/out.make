/usr/bin/perl /System/Library/Perl/5.18/ExtUtils/xsubpp  -typemap "/System/Library/Perl/5.18/ExtUtils/typemap"   Haskell_ca73ab.xs > Haskell_ca73ab.xsc && mv Haskell_ca73ab.xsc Haskell_ca73ab.c
cc -c  -I"/Users/wim/SoC_Research/Code/Git/RefactorF4Acc/FParser" -I/Users/wim/SoC_Research/Code/Git/RefactorF4Acc/FParser/_Call_Haskell -arch i386 -arch x86_64 -g -pipe -fno-common -DPERL_DARWIN -fno-strict-aliasing -fstack-protector -Os   -DVERSION=\"0.00\" -DXS_VERSION=\"0.00\"  "-I/System/Library/Perl/5.18/darwin-thread-multi-2level/CORE"   Haskell_ca73ab.c
Running Mkbootstrap for Call::Haskell_ca73ab ()
chmod 644 Haskell_ca73ab.bs
rm -f blib/arch/auto/Call/Haskell_ca73ab/Haskell_ca73ab.bundle
/usr/bin/clang  -arch x86_64 -arch i386 -bundle -undefined dynamic_lookup -L/usr/local/lib    -DTABLES_NEXT_TO_CODE    -Wl,-no_compact_unwind -L../../../../_Call_Haskell ../../../../_Call_Haskell/test_src.o -lF95StatementParserHsC -L/Users/wim/.cabal/lib/x86_64-osx-ghc-7.8.3/language-fortran-0.3 -L/opt/local/lib/x86_64-osx-ghc-7.8.3/haskell-src-1.0.1.6 -L/opt/local/lib/x86_64-osx-ghc-7.8.3/syb-0.4.1 -L/opt/local/lib/ghc-7.8.3/pretty-1.1.1.1 -L/Users/wim/.cabal/lib/x86_64-osx-ghc-7.8.3/parsec-3.1.9 -L/Users/wim/.cabal/lib/x86_64-osx-ghc-7.8.3/text-1.2.1.3 -L/opt/local/lib/ghc-7.8.3/binary-0.7.1.0 -L/opt/local/lib/ghc-7.8.3/containers-0.5.5.1 -L/Users/wim/.cabal/lib/x86_64-osx-ghc-7.8.3/mtl-2.2.1 -L/Users/wim/.cabal/lib/x86_64-osx-ghc-7.8.3/transformers-0.4.3.0 -L/opt/local/lib/ghc-7.8.3/bytestring-0.10.4.0 -L/opt/local/lib/ghc-7.8.3/deepseq-1.3.0.2 -L/opt/local/lib/ghc-7.8.3/array-0.5.0.0 -L/opt/local/lib/ghc-7.8.3/base-4.7.0.1 -L/opt/local/lib -L/opt/local/lib/ghc-7.8.3/integer-gmp-0.5.1.0 -L/opt/local/lib/ghc-7.8.3/ghc-prim-0.3.1.0 -L/opt/local/lib/ghc-7.8.3/rts-1.0 ../../../../_Call_Haskell/tmp/ghc24418_0/ghc24418_2.o -Wl,-u,_ghczmprim_GHCziTypes_Izh_static_info -Wl,-u,_ghczmprim_GHCziTypes_Czh_static_info -Wl,-u,_ghczmprim_GHCziTypes_Fzh_static_info -Wl,-u,_ghczmprim_GHCziTypes_Dzh_static_info -Wl,-u,_base_GHCziPtr_Ptr_static_info -Wl,-u,_ghczmprim_GHCziTypes_Wzh_static_info -Wl,-u,_base_GHCziInt_I8zh_static_info -Wl,-u,_base_GHCziInt_I16zh_static_info -Wl,-u,_base_GHCziInt_I32zh_static_info -Wl,-u,_base_GHCziInt_I64zh_static_info -Wl,-u,_base_GHCziWord_W8zh_static_info -Wl,-u,_base_GHCziWord_W16zh_static_info -Wl,-u,_base_GHCziWord_W32zh_static_info -Wl,-u,_base_GHCziWord_W64zh_static_info -Wl,-u,_base_GHCziStable_StablePtr_static_info -Wl,-u,_ghczmprim_GHCziTypes_Izh_con_info -Wl,-u,_ghczmprim_GHCziTypes_Czh_con_info -Wl,-u,_ghczmprim_GHCziTypes_Fzh_con_info -Wl,-u,_ghczmprim_GHCziTypes_Dzh_con_info -Wl,-u,_base_GHCziPtr_Ptr_con_info -Wl,-u,_base_GHCziPtr_FunPtr_con_info -Wl,-u,_base_GHCziStable_StablePtr_con_info -Wl,-u,_ghczmprim_GHCziTypes_False_closure -Wl,-u,_ghczmprim_GHCziTypes_True_closure -Wl,-u,_base_GHCziPack_unpackCString_closure -Wl,-u,_base_GHCziIOziException_stackOverflow_closure -Wl,-u,_base_GHCziIOziException_heapOverflow_closure -Wl,-u,_base_ControlziExceptionziBase_nonTermination_closure -Wl,-u,_base_GHCziIOziException_blockedIndefinitelyOnMVar_closure -Wl,-u,_base_GHCziIOziException_blockedIndefinitelyOnSTM_closure -Wl,-u,_base_ControlziExceptionziBase_nestedAtomically_closure -Wl,-u,_base_GHCziWeak_runFinalizzerBatch_closure -Wl,-u,_base_GHCziTopHandler_flushStdHandles_closure -Wl,-u,_base_GHCziTopHandler_runIO_closure -Wl,-u,_base_GHCziTopHandler_runNonIO_closure -Wl,-u,_base_GHCziConcziIO_ensureIOManagerIsRunning_closure -Wl,-u,_base_GHCziConcziIO_ioManagerCapabilitiesChanged_closure -Wl,-u,_base_GHCziConcziSync_runSparks_closure -Wl,-u,_base_GHCziConcziSignal_runHandlers_closure -Wl,-search_paths_first -lHSlanguage-fortran-0.3 -lHShaskell-src-1.0.1.6 -lHSsyb-0.4.1 -lHSpretty-1.1.1.1 -lHSparsec-3.1.9 -lHStext-1.2.1.3 -lHSbinary-0.7.1.0 -lHScontainers-0.5.5.1 -lHSmtl-2.2.1 -lHStransformers-0.4.3.0 -lHSbytestring-0.10.4.0 -lHSdeepseq-1.3.0.2 -lHSarray-0.5.0.0 -lHSbase-4.7.0.1 -lHSinteger-gmp-0.5.1.0 -lHSghc-prim-0.3.1.0 -lHSrts -liconv -lcharset -lgmp -lm -ldl -lffi Haskell_ca73ab.o  -o blib/arch/auto/Call/Haskell_ca73ab/Haskell_ca73ab.bundle 	\
	     	\
	  
ld: illegal text reloc in '_mtlzm2zi2zi1_ControlziMonadziReaderziClass_zdfMonadReaderrExceptTzuzdclocal_info' to '_transformerszm0zi5zi2zi0_ControlziMonadziTransziExcept_mapExceptT_closure' for architecture x86_64
clang: error: linker command failed with exit code 1 (use -v to see invocation)
make: *** [blib/arch/auto/Call/Haskell_ca73ab/Haskell_ca73ab.bundle] Error 1
