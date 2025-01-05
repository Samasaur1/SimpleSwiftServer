{
  description = "SimpleSwiftServer";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs, ... }:
    let
      forAllSystems = gen:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed
        (system: gen nixpkgs.legacyPackages.${system});
    in {
      packages = forAllSystems (pkgs: { default = pkgs.callPackage ./. {
        date = 
          let
            months = [ "" "January" "February" "March" "April" "May" "June" "July" "August" "September" "October" "November" "December" ];
            month = builtins.elemAt months (pkgs.lib.toIntBase10 (builtins.substring 4 2 self.lastModifiedDate));
            year = builtins.substring 0 4 self.lastModifiedDate;
          in
            "${month} ${year}";
      }; });
    };
}
