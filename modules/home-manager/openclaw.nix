{ lib, ... }:
{
  programs.openclaw = {
    enable = true;
    systemd.enable = true;
    config = {
      gateway.mode = "local";
      channels.telegram = {
        tokenFile = "/run/secrets/telegram_bot_token";
        allowFrom = [ 1741488803 ];
      };
      # Explicitly disable whatsapp: the runtime would otherwise auto-enable it
      # from the linked credentials, replying to any inbound DM with no allowlist.
      channels.whatsapp.enabled = false;
      agents.defaults.model = {
        primary = "anthropic/claude-sonnet-4-6";
        fallbacks = [ "openai/gpt-5.4" ];
      };
    };
  };

  # The openclaw runtime mutates ~/.openclaw/openclaw.json in place (auth token,
  # meta timestamps, plugin auto-enables). home-manager refuses to clobber an
  # unmanaged file, so remove it before the link phase.
  home.activation.openclawCleanConfig = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f $HOME/.openclaw/openclaw.json
  '';

  # Pin gateway.auth.token via OPENCLAW_GATEWAY_TOKEN so the runtime stops
  # regenerating it on every rebuild. Rendered by sops.templates."openclaw-env".
  xdg.configFile."systemd/user/openclaw-gateway.service.d/sops-env.conf".text = ''
    [Service]
    EnvironmentFile=/run/secrets/openclaw-env
  '';
}
