use Mix.Config

# Authorize the device to receive firmware using your public key.
# See https://hexdocs.pm/nerves_firmware_ssh/readme.html for more information
# on configuring nerves_firmware_ssh.

config :bulma_widgets_phx_test, BulmaWidgetsPhxTestWeb.Endpoint,
  server: true,
  url: [host: "45.63.37.162"],
  http: [:inet6, port: 80, protocol_options: [idle_timeout: :infinity]],
  secret_key_base: "mY5NRonaUXEQpTnHYZA4l8fggFt3QaWpABKsp7Bs3mBPUPAwsqDfkar3blneGC5f",
  render_errors: [view: BulmaWidgetsPhxTestWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BulmaWidgetsPhxTest.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "gECXkLYQ"]

keys =
  [
    Path.join([System.user_home!(), ".ssh", "id_rsa.pub"]),
    Path.join([System.user_home!(), ".ssh", "id_ecdsa.pub"]),
    Path.join([System.user_home!(), ".ssh", "id_ed25519.pub"])
  ]
  |> Enum.filter(&File.exists?/1)

if keys == [],
  do:
    Mix.raise("""
    No SSH public keys found in ~/.ssh. An ssh authorized key is needed to
    log into the Nerves device and update firmware on it using ssh.
    See your project's config.exs for this error message.
    """)

config :nerves_firmware_ssh,
  authorized_keys: Enum.map(keys, &File.read!/1)

# Configure nerves_init_gadget.
# See https://hexdocs.pm/nerves_init_gadget/readme.html for more information.

# Setting the node_name will enable Erlang Distribution.
# Only enable this for prod if you understand the risks.
node_name = if Mix.env() != :prod, do: "cloud_server"

config :nerves_init_gadget,
  ifname: "eth0",
  address_method: :dhcp,
  mdns_domain: "cloud-server.local",
  node_name: node_name,
  node_host: :mdns_domain

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.target()}.exs"
