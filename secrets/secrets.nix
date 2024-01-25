let

  # This whole file is bookkeeping for the arenix command line tool.
  # It keeps track of the public keys of the people/host who can decrypt the secrets

  # If you add a  new person or host, you need to add their public key here
  # and then run `agenix -r` to encrypt the secrets again
  elliott = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFa64P1p+IFzKghQSp0kEkz2qNppaRiffqb/xNlG4xpt";

  # hosts
  # Host ssh keys are needed so that the host can decrypt the secrets without
  # needing to have our private key on the host or without passwords
  frost = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJaxaD4KTRKbrCvAyn9ChtNCAaJmRvocF/LfviUBnJjM";
in
{
  "batteriesincl_wg.age".publicKeys = [ elliott frost ];
}
