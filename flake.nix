{
  description = "Amir's NixOS + Home-Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    # اگر unstable می‌خوای: "github:NixOS/nixpkgs/nixos-unstable"

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";   # هم‌ نسخه با nixpkgs اصلی
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix

        # اضافه کردن home-manager به عنوان module
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          # کاربر amir رو تعریف می‌کنیم
          home-manager.users.amir = import ./home.nix;

          # اختیاری: اجازه بده home-manager از nixpkgs سیستم استفاده کنه
          home-manager.extraSpecialArgs = { inherit nixpkgs; };
        }
      ];
    };
  };
}
