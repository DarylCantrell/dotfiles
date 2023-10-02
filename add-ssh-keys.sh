#! /bin/bash

# Parse dev SSH key files for some users:

monaRsaKey=`sed 's/= .*/=/' /home/vscode/dotfiles/devKeys/monalisa.rsa.pub`
monaRsaFingerprint=$(ssh-keygen -l -E SHA256 -f /home/vscode/dotfiles/devKeys/monalisa.rsa.pub | awk -F '[:| ]' '{print($3)}')
monaEdKey=`awk '{print $1,$2}' /home/vscode/dotfiles/devKeys/monalisa.ed25519.pub`
monaEdFingerprint=$(ssh-keygen -l -E SHA256 -f /home/vscode/dotfiles/devKeys/monalisa.ed25519.pub | awk -F '[:| ]' '{print($3)}')

collabRsaKey=`sed 's/= .*/=/' /home/vscode/dotfiles/devKeys/collaborator.rsa.pub`
collabRsaFingerprint=$(ssh-keygen -l -E SHA256 -f /home/vscode/dotfiles/devKeys/collaborator.rsa.pub | awk -F '[:| ]' '{print($3)}')
collabEdKey=`awk '{print $1,$2}' /home/vscode/dotfiles/devKeys/collaborator.ed25519.pub`
collabEdFingerprint=$(ssh-keygen -l -E SHA256 -f /home/vscode/dotfiles/devKeys/collaborator.ed25519.pub | awk -F '[:| ]' '{print($3)}')

outsiderRsaKey=`sed 's/= .*/=/' /home/vscode/dotfiles/devKeys/outsider.rsa.pub`
outsiderRsaFingerprint=$(ssh-keygen -l -E SHA256 -f /home/vscode/dotfiles/devKeys/outsider.rsa.pub | awk -F '[:| ]' '{print($3)}')
outsiderEdKey=`awk '{print $1,$2}' /home/vscode/dotfiles/devKeys/outsider.ed25519.pub`
outsiderEdFingerprint=$(ssh-keygen -l -E SHA256 -f /home/vscode/dotfiles/devKeys/outsider.ed25519.pub | awk -F '[:| ]' '{print($3)}')

# Insert dev keys into public_keys table:

mysql -D github_development << EOF
	SELECT id INTO @mona_id FROM users WHERE login = 'monalisa';
	SELECT id INTO @collab_id FROM users WHERE login = 'collaborator';
	SELECT id INTO @outsider_id FROM users WHERE login = 'outsider';

	INSERT INTO public_keys (
		user_id, creator_id, verifier_id,
		\`key\`,
		fingerprint_sha256,
		title,
		username,
		created_by,
		read_only,
		created_at, updated_at, verified_at
	) VALUES (
		@mona_id, @mona_id, @mona_id,
		'${monaRsaKey}',
		'${monaRsaFingerprint}',
		'monalisa.rsa',
		'git',
		'user',
		0,
		now(), now(), now()
	),(
		@mona_id, @mona_id, @mona_id,
		'${monaEdKey}',
		'${monaEdFingerprint}',
		'monalisa.ed25519',
		'git',
		'user',
		0,
		now(), now(), now()
	),(
		@collab_id, @collab_id, @collab_id,
		'${collabRsaKey}',
		'${collabRsaFingerprint}',
		'collaborator.rsa',
		'git',
		'user',
		0,
		now(), now(), now()
	),(
		@collab_id, @collab_id, @collab_id,
		'${collabEdKey}',
		'${collabEdFingerprint}',
		'collaborator.ed25519',
		'git',
		'user',
		0,
		now(), now(), now()
	),(
		@outsider_id, @outsider_id, @outsider_id,
		'${outsiderRsaKey}',
		'${outsiderRsaFingerprint}',
		'outsider.rsa',
		'git',
		'user',
		0,
		now(), now(), now()
	),(
		@outsider_id, @outsider_id, @outsider_id,
		'${outsiderEdKey}',
		'${outsiderEdFingerprint}',
		'outsider.ed25519',
		'git',
		'user',
		0,
		now(), now(), now()
	);

	INSERT INTO github_development_collab.git_signing_ssh_public_keys (
		user_id,
		\`key\`,
		title,
		fingerprint_sha256,
		created_at, updated_at
	) VALUES (
		@mona_id,
		'${monaEdKey}',
		'monalisa.ed25519',
		'${monaEdFingerprint}',
		now(), now()
	),(
		@collab_id,
		'${collabEdKey}',
		'collaborator.ed25519',
		'${collabEdFingerprint}',
		now(), now()
	),(
		@outsider_id,
		'${outsiderEdKey}',
		'outsider.ed25519',
		'${outsiderEdFingerprint}',
		now(), now()
	);
EOF
