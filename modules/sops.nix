{ config, ... }:
{
  # Use the machine's SSH host key for age decryption
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # Default secrets file
  sops.defaultSopsFile = ../secrets/secrets.yaml;

  # API keys for adam (decrypted to /run/secrets/<name>, readable by adam)
  sops.secrets.openai_api_key = {
    owner = "adam";
  };
  sops.secrets.brave_api_key = {
    owner = "adam";
  };
  sops.secrets.anthropic_api_key = {
    owner = "adam";
  };
  sops.secrets.notion_api_key = {
    owner = "adam";
  };
  sops.secrets.telegram_bot_token = {
    owner = "adam";
  };
  sops.secrets.openclaw_gateway_token = {
    owner = "adam";
  };

  sops.templates."openclaw-env" = {
    content = ''
      OPENCLAW_GATEWAY_TOKEN=${config.sops.placeholder.openclaw_gateway_token}
      ANTHROPIC_API_KEY=${config.sops.placeholder.anthropic_api_key}
      OPENAI_API_KEY=${config.sops.placeholder.openai_api_key}
      NOTION_API_KEY=${config.sops.placeholder.notion_api_key}
    '';
    owner = "adam";
    path = "/run/secrets/openclaw-env";
  };
}
