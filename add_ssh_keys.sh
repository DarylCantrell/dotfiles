#! /bin/sh

monaPubKey=`sed 's/= .*/=/' ~/dotfiles/testKeys/monalisa.rsa.pub`
monaFingerprint=$(ssh-keygen -l -E SHA256 -f /root/dotfiles/testKeys/monalisa.rsa.pub | /bin/sed -e 's/.*SHA256://g' -e 's/ .*//g')

collabPubKey=`sed 's/= .*/=/' ~/dotfiles/testKeys/collaborator.rsa.pub`
collabFingerprint=$(ssh-keygen -l -E SHA256 -f /root/dotfiles/testKeys/collaborator.rsa.pub | /bin/sed -e 's/.*SHA256://g' -e 's/ .*//g')

mysql -D github_development << EOF
SELECT id INTO @mona_id FROM users WHERE login = 'monalisa';
SELECT id INTO @collab_id FROM users WHERE login = 'collaborator';

INSERT INTO public_keys
	(user_id,
	\`key\`,
	username,
	title,
	created_at,
	updated_at,
	verified_at,
	creator_id,
	verifier_id,
	created_by,
	read_only,
	fingerprint_sha256)
VALUES (
	@mona_id,
	'${monaPubKey}',
	'git',
	'monalisa.rsa.pub',
	now(),
	now(),
	now(),
	@mona_id,
	@mona_id,
	'user',
	0,
	'${monaFingerprint}'
),(
	@collab_id,
	'${collabPubKey}',
	'git',
	'collaborator.rsa.pub',
	now(),
	now(),
	now(),
	@collab_id,
	@collab_id,
	'user',
	0,
	'${collabFingerprint}'
);
EOF
