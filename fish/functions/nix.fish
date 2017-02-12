if test -n $HOME
  set -l NIX_LINK $HOME/.nix-profile

  if test ! -L $NIX_LINK
    echo "creating $NIX_LINK" >&2
    set -l _NIX_DEF_LINK /nix/var/nix/profiles/default
    /nix/store/9pn260ybk3gl3cc1ff6vxxajzqp7zk8j-coreutils-8.25/bin/ln -s $_NIX_DEF_LINK $NIX_LINK
  end
  
  set -x PATH $NIX_LINK/bin $PATH
  set -x MANPATH $NIX_LINK/share/man $MANPATH

  if test ! -e $HOME/.nix-channels
    echo "https://nixos.org/channels/nixpkgs-unstable nixpkgs" > $HOME/.nix-channels
  end

  set -x NIX_PATH nixpkgs=$HOME/.nix-defexpr/channels/nixpkgs
  
  if test -e /etc/ssl/certs/ca-certificates.crt
    set -x SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
  else if test -e /etc/ssl/certs/ca-bundle.crt
    set -x SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt
  else if test -e /etc/pki/tls/certs/ca-bundle.crt
    set -x SSL_CERT_FILE /etc/pki/tls/certs/ca-bundle.crt
  else if test -e $NIX_LINK/etc/ssl/certs/ca-bundle.crt
    set -x SSL_CERT_FILE $NIX_LINK/etc/ssl/certs/ca-bundle.crt
  else if test -e $NIX_LINK/etc/ca-bundle.crt
    set -x SSL_CERT_FILE $NIX_LINK/etc/ca-bundle.crt
  end
end
