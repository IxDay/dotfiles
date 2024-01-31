Passage setup
=============

For the whole flow to work properly we will need to generate two age keys:

- One for ssh which will be used by `yubikey-agent` and stored in the PIV slot.
	Run: `yubikey-agent -setup` to create the key and ensure that the
	`yubikey-agent -l <path_to_agent_socket>` process is running.
- Another one for encryption/decryption used by `passage` and generated using:
	`age-pluging-yubikey --generate`. Once this is done, you need to pass the
	relevant info to passage:

	```bash
	# since it is not possible to run multiple process against the yubikey first run
	kill -HUP $(systemctl --user show --property MainPID --value yubikey-agent)
	# then
	age-plugin-yubikey --identity >> $PASSAGE_IDENTITIES_FILE
	age-plugin-yubikey --list >> $PASSAGE_DIR/.age-recipients
	```
