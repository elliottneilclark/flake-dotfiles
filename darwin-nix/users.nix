{ ... }:
{
  users = {
    users = {
      elliott = {
        # Darwin's Home Manager needs the home location
        # while it seems nixos depends on the fact that
        # a user is a normal user to use /etc/passwd
        home = "/Users/elliott";
      };
    };
  };
}
