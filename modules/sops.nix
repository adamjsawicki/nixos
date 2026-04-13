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
}
