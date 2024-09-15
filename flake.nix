{
  description = "Expo Yarn Workspace Monorepo";
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          android_sdk.accept_license = true;
          allowUnfree = true;
        };
      };
      pinnedJDK = pkgs.jdk17;
      androidBuildToolsVersion = "34.0.0";
      androidNdkVersion = "26.1.10909125";
      androidComposition = pkgs.androidenv.composeAndroidPackages {
        buildToolsVersions = [androidBuildToolsVersion];
        platformVersions = ["34"];
        cmakeVersions = ["3.10.2" "3.22.1"];
        includeNDK = true;
        ndkVersions = [androidNdkVersion];
      };
      sdk = androidComposition.androidsdk;
    in {
      formatter = pkgs.alejandra;

      devShells = {
        default = pkgs.mkShell rec {
          JAVA_HOME = pinnedJDK;
          ANDROID_SDK_ROOT = "${androidComposition.androidsdk}/libexec/android-sdk";
          ANDROID_NDK_ROOT = "${ANDROID_SDK_ROOT}/ndk-bundle";

          GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${ANDROID_SDK_ROOT}/build-tools/${androidBuildToolsVersion}/aapt2";

          buildInputs = with pkgs; [
            # Android
            sdk
            # iOS
            fastlane
            cocoapods
            # Node
            nodejs_20
            yarn-berry
            nodePackages.eas-cli
          ];
        };
      };
    });
}
