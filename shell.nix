let
  pkgs = import <nixpkgs> {};
in pkgs.mkShell {
  packages = [ 
    pkgs.aider-chat
    (pkgs.python3.withPackages (python-pkgs: [
      python-pkgs.google-generativeai
    ]))
  ];

  #shellHook = ''
  #  export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib/:$LD_LIBRARY_PATH
  #'';
}
