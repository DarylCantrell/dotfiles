#! /bin/bash

# Parse dev SSH key files for some users:

monaPublicKey=`sed 's/= .*/=/' /home/vscode/dotfiles/devKeys/monalisa.rsa.pub`
monaFingerprint=$(ssh-keygen -l -E SHA256 -f /home/vscode/dotfiles/devKeys/monalisa.rsa.pub | awk -F '[:| ]' '{print($3)}')

collabPublicKey=`sed 's/= .*/=/' /home/vscode/dotfiles/devKeys/collaborator.rsa.pub`
collabFingerprint=$(ssh-keygen -l -E SHA256 -f /home/vscode/dotfiles/devKeys/collaborator.rsa.pub | awk -F '[:| ]' '{print($3)}')

outsiderPublicKey=`sed 's/= .*/=/' /home/vscode/dotfiles/devKeys/outsider.rsa.pub`
outsiderFingerprint=$(ssh-keygen -l -E SHA256 -f /home/vscode/dotfiles/devKeys/outsider.rsa.pub | awk -F '[:| ]' '{print($3)}')

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
		'${monaPublicKey}',
		'${monaFingerprint}',
		'monalisa.rsa',
		'git',
		'user',
		0,
		now(), now(), now()
	),(
		@collab_id, @collab_id, @collab_id,
		'${collabPublicKey}',
		'${collabFingerprint}',
		'collaborator.rsa',
		'git',
		'user',
		0,
		now(), now(), now()
	),(
		@outsider_id, @outsider_id, @outsider_id,
		'${outsiderPublicKey}',
		'${outsiderFingerprint}',
		'outsider.rsa',
		'git',
		'user',
		0,
		now(), now(), now()
	);
EOF
